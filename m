From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed,  1 Jun 2022 12:53:24 -0400
Message-ID: <20220601165324.60892-2-longman@redhat.com>
References: <20220601165324.60892-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654102421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vYJ4Au8LKvlxbIQX28uISQmDIvtY4t/cHh1fBYMvRCE=;
        b=gm7OFJz7Hg7yONnM8i6ExYQd2qu1h1kwcXU3btG737cxYLvvOrv3Huu6ZbKRhUCd6Jaw/l
        eer+7e4PD1rVTRTbX2hh9jcck0d1tDPejNmoehRXew9K7nU284hrmIzRWPuf0LtrGANv7C
        n3A6AKGSFdbS4VT/D5Gq6MaokS6FZ9k=
In-Reply-To: <20220601165324.60892-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Waiman Long <longman@redhat.com>

For a system with many CPUs and block devices, the time to do
blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
can be especially problematic as interrupt is disabled during the flush.
It was reported that it might take seconds to complete in some extreme
cases leading to hard lockup messages.

As it is likely that not all the percpu blkg_iostat_set's has been
updated since the last flush, those stale blkg_iostat_set's don't need
to be flushed in this case. This patch optimizes blkcg_rstat_flush()
by keeping a lockless list of recently updated blkg_iostat_set's in a
newly added percpu blkcg->lhead pointer.

The blkg_iostat_set is added to the lockless list on the update side
in blk_cgroup_bio_start(). It is removed from the lockless list when
flushed in blkcg_rstat_flush(). Due to racing, it is possible that
blk_iostat_set's in the lockless list may have no new iostat's to
be flushed.

A blkg_iostat_set can determine if it is in a lockless list by checking
the content of its lnode.next pointer which will be non-NULL when in
a lockless list. This requires the presence of a special llist_last
sentinel to be put at the end of the lockless list.

When booting up an instrumented test kernel with this patch on a
2-socket 96-thread system with cgroup v2, out of the 2051 calls to
cgroup_rstat_flush() after bootup, 1788 of the calls were exited
immediately because of empty lockless list. After an all-cpu kernel
build, the ratio became 6295424/6340513. That was more than 99%.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 block/blk-cgroup.c | 74 ++++++++++++++++++++++++++++++++++++++++------
 block/blk-cgroup.h |  9 ++++++
 2 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index acd9b0aa8dc8..fcdac724970c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -59,6 +59,40 @@ static struct workqueue_struct *blkcg_punt_bio_wq;
 
 #define BLKG_DESTROY_BATCH_SIZE  64
 
+static struct llist_node llist_last;	/* Last sentinel node of llist */
+
+static inline bool blkcg_llist_empty(struct llist_head *lhead)
+{
+	return lhead->first == &llist_last;
+}
+
+static inline void init_blkcg_llists(struct blkcg *blkcg)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu_ptr(blkcg->lhead, cpu)->first = &llist_last;
+}
+
+static inline struct llist_node *
+fetch_delete_blkcg_llist(struct llist_head *lhead)
+{
+	return xchg(&lhead->first, &llist_last);
+}
+
+/*
+ * The retrieved blkg_iostat_set is immediately marked as not in the
+ * lockless list by clearing its node->next pointer. It could be put
+ * back into the list by a parallel update before the iostat's are
+ * finally flushed. So being in the list doesn't always mean it has new
+ * iostat's to be flushed.
+ */
+#define blkcg_llist_for_each_entry_safe(pos, node, nxt)			\
+	for (; (node != &llist_last) &&					\
+	       (pos = llist_entry(node, struct blkg_iostat_set, lnode),	\
+		nxt = node->next, node->next = NULL, true);		\
+		node = nxt)
+
 /**
  * blkcg_css - find the current css
  *
@@ -236,8 +270,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	blkg->blkcg = blkcg;
 
 	u64_stats_init(&blkg->iostat.sync);
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		u64_stats_init(&per_cpu_ptr(blkg->iostat_cpu, cpu)->sync);
+		per_cpu_ptr(blkg->iostat_cpu, cpu)->blkg = blkg;
+	}
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -852,17 +888,26 @@ static void blkg_iostat_sub(struct blkg_iostat *dst, struct blkg_iostat *src)
 static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct blkcg *blkcg = css_to_blkcg(css);
-	struct blkcg_gq *blkg;
+	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
+	struct llist_node *lnode, *lnext;
+	struct blkg_iostat_set *bisc;
 
 	/* Root-level stats are sourced from system-wide IO stats */
 	if (!cgroup_parent(css->cgroup))
 		return;
 
-	rcu_read_lock();
+	if (blkcg_llist_empty(lhead))
+		return;
 
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
+	lnode = fetch_delete_blkcg_llist(lhead);
+
+	/*
+	 * No RCU protection is needed as it is assumed that blkg_iostat_set's
+	 * in the percpu lockless list won't go away until the flush is done.
+	 */
+	blkcg_llist_for_each_entry_safe(bisc, lnode, lnext) {
+		struct blkcg_gq *blkg = bisc->blkg;
 		struct blkcg_gq *parent = blkg->parent;
-		struct blkg_iostat_set *bisc = per_cpu_ptr(blkg->iostat_cpu, cpu);
 		struct blkg_iostat cur, delta;
 		unsigned long flags;
 		unsigned int seq;
@@ -891,8 +936,6 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 			u64_stats_update_end_irqrestore(&parent->iostat.sync, flags);
 		}
 	}
-
-	rcu_read_unlock();
 }
 
 /*
@@ -1192,6 +1235,11 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 		}
 	}
 
+	blkcg->lhead = alloc_percpu_gfp(struct llist_head, GFP_KERNEL);
+	if (!blkcg->lhead)
+		goto free_blkcg;
+	init_blkcg_llists(blkcg);
+
 	for (i = 0; i < BLKCG_MAX_POLS ; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
 		struct blkcg_policy_data *cpd;
@@ -1233,7 +1281,8 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	for (i--; i >= 0; i--)
 		if (blkcg->cpd[i])
 			blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
-
+	free_percpu(blkcg->lhead);
+free_blkcg:
 	if (blkcg != &blkcg_root)
 		kfree(blkcg);
 unlock:
@@ -1997,6 +2046,7 @@ static int blk_cgroup_io_type(struct bio *bio)
 
 void blk_cgroup_bio_start(struct bio *bio)
 {
+	struct blkcg *blkcg = bio->bi_blkg->blkcg;
 	int rwd = blk_cgroup_io_type(bio), cpu;
 	struct blkg_iostat_set *bis;
 	unsigned long flags;
@@ -2015,9 +2065,15 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 	bis->cur.ios[rwd]++;
 
+	if (!bis->lnode.next) {
+		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
+
+		llist_add(&bis->lnode, lhead);
+	}
+
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
 	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
-		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
+		cgroup_rstat_updated(blkcg->css.cgroup, cpu);
 	put_cpu();
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index d4de0a35e066..65ac38e0708a 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -18,6 +18,7 @@
 #include <linux/cgroup.h>
 #include <linux/kthread.h>
 #include <linux/blk-mq.h>
+#include <linux/llist.h>
 
 struct blkcg_gq;
 struct blkg_policy_data;
@@ -43,8 +44,10 @@ struct blkg_iostat {
 
 struct blkg_iostat_set {
 	struct u64_stats_sync		sync;
+	struct llist_node		lnode;
 	struct blkg_iostat		cur;
 	struct blkg_iostat		last;
+	struct blkcg_gq		       *blkg;
 };
 
 /* association between a blk cgroup and a request queue */
@@ -97,6 +100,12 @@ struct blkcg {
 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
 
 	struct list_head		all_blkcgs_node;
+
+	/*
+	 * List of updated percpu blkg_iostat_set's since the last flush.
+	 */
+	struct llist_head __percpu	*lhead;
+
 #ifdef CONFIG_BLK_CGROUP_FC_APPID
 	char                            fc_app_id[FC_APPID_LEN];
 #endif
-- 
2.31.1


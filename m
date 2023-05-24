From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Wed, 24 May 2023 09:19:35 +0800
Message-ID: <20230524011935.719659-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684891231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XWfrXzi1lE088cYfxUvQvd0txTe3HPtik/NVcknqft0=;
        b=XBsPdpuVgkqPQlOwmorYapxrI2QeSbS8H0d4u7lS0D6y0VQHkjawZNDtmAP/1CFtg52XLD
        RJHZpa5L/GfL1LOlkyY/jmVDV51M6yE2EvWeSaQrzK4YsFAC1ocWbFe7J5s8ZOqM4UvTIn
        HSby1mcQ0Va1jpDB4YapobA3dqJE0eo=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, mkoutny@suse.com

As noted by Michal, the blkg_iostat_set's in the lockless list
hold reference to blkg's to protect against their removal. Those
blkg's hold reference to blkcg. When a cgroup is being destroyed,
cgroup_rstat_flush() is only called at css_release_work_fn() which
is called when the blkcg reference count reaches 0. This circular
dependency will prevent blkcg and some blkgs from being freed after
they are made offline.

It is less a problem if the cgroup to be destroyed also has other
controllers like memory that will call cgroup_rstat_flush() which will
clean up the reference count. If block is the only controller that uses
rstat, these offline blkcg and blkgs may never be freed leaking more
and more memory over time.

To prevent this potential memory leak:

- a new cgroup_rstat_css_cpu_flush() function is added to flush stats for
a given css and cpu. This new function will be called in __blkg_release().

- don't grab bio->bi_blkg when adding the stats into blkcg's per-cpu
stat list, and this kind of handling is the most fragile part of
original patch

Based on Waiman's patch:

https://lore.kernel.org/linux-block/20221215033132.230023-3-longman@redhat.com/

Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Cc: Waiman Long <longman@redhat.com>
Cc: cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mkoutny@suse.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-cgroup.c     | 15 +++++++++++++--
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 18 ++++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0ce64dd73cfe..5437b6af3955 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -163,10 +163,23 @@ static void blkg_free(struct blkcg_gq *blkg)
 static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
+	struct blkcg *blkcg = blkg->blkcg;
+	int cpu;
 
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	WARN_ON(!bio_list_empty(&blkg->async_bios));
 #endif
+	/*
+	 * Flush all the non-empty percpu lockless lists before releasing
+	 * us. Meantime no new bio can refer to this blkg any more given
+	 * the refcnt is killed.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
+
+		if (!llist_empty(lhead))
+			cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
+	}
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
@@ -991,7 +1004,6 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		if (parent && parent->parent)
 			blkcg_iostat_update(parent, &blkg->iostat.cur,
 					    &blkg->iostat.last);
-		percpu_ref_put(&blkg->refcnt);
 	}
 
 out:
@@ -2075,7 +2087,6 @@ void blk_cgroup_bio_start(struct bio *bio)
 
 		llist_add(&bis->lnode, lhead);
 		WRITE_ONCE(bis->lqueued, true);
-		percpu_ref_get(&bis->blkg->refcnt);
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 885f5395fcd0..97d4764d8e6a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -695,6 +695,7 @@ void cgroup_rstat_flush(struct cgroup *cgrp);
 void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
 void cgroup_rstat_flush_release(void);
+void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cpu);
 
 /*
  * Basic resource stats.
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 9c4c55228567..96e7a4e6da72 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -281,6 +281,24 @@ void cgroup_rstat_flush_release(void)
 	spin_unlock_irq(&cgroup_rstat_lock);
 }
 
+/**
+ * cgroup_rstat_css_cpu_flush - flush stats for the given css and cpu
+ * @css: target css to be flush
+ * @cpu: the cpu that holds the stats to be flush
+ *
+ * A lightweight rstat flush operation for a given css and cpu.
+ * Only the cpu_lock is being held for mutual exclusion, the cgroup_rstat_lock
+ * isn't used.
+ */
+void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cpu)
+{
+	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
+
+	raw_spin_lock_irq(cpu_lock);
+	css->ss->css_rstat_flush(css, cpu);
+	raw_spin_unlock_irq(cpu_lock);
+}
+
 int cgroup_rstat_init(struct cgroup *cgrp)
 {
 	int cpu;
-- 
2.40.1


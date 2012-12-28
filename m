From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Date: Fri, 28 Dec 2012 12:35:45 -0800
Message-ID: <1356726946-26037-24-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=Z97WoTmmlnXwdvbYVh56q4VflSu0+DLE6rMRg8tPkCI=;
        b=yl8zBKj9XH8F2rq2Bh71665ECmolJ+eNsMws9V/w6J5bfZoo8EXIDowqygf4FIVS+U
         iCVX/zx5kFjBk8UqnMR/YVXLjQMdyWJVr6OHIEAIHhqaKQ+uIzWYzywSOci0/ohF54H3
         SPjIs/9No28nQDZdupmw1PGZszr2XRPRoD1aDt58xl+cB5tCOwQjd04Omvg4Lb8FkTYd
         ndhZ/MebChAHWlybIYfZM1jY32JZZQaHhiaSNzzn0kXNQ/q3DwurfeCuVuKcLTVQUQqc
         D1gKP5Y3lRFJdXIzTNWMWFOdU43Kz1h/SHoFh7jHyMc4E6GfQaPC5F9fjQz85PqOOxf6
         yhgA==
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

To support hierarchical stats, it's necessary to remember stats from
dead children.  Add cfqg->dead_stats and make a dying cfqg transfer
its stats to the parent's dead-stats.

The transfer happens form ->pd_offline_fn() and it is possible that
there are some residual IOs completing afterwards.  Currently, we lose
these stats.  Given that cgroup removal isn't a very high frequency
operation and the amount of residual IOs on offline are likely to be
nil or small, this shouldn't be a big deal and the complexity needed
to handle residual IOs - another callback and rather elaborate
synchronization to reach and lock the matching q - doesn't seem
justified.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f8b34bb..4d75b79 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -289,7 +289,8 @@ struct cfq_group {
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 	struct cfq_ttime ttime;
-	struct cfqg_stats stats;
+	struct cfqg_stats stats;	/* stats for this cfqg */
+	struct cfqg_stats dead_stats;	/* stats pushed from dead children */
 };
 
 struct cfq_io_cq {
@@ -709,6 +710,47 @@ static void cfqg_stats_reset(struct cfqg_stats *stats)
 #endif
 }
 
+/* @to += @from */
+static void cfqg_stats_merge(struct cfqg_stats *to, struct cfqg_stats *from)
+{
+	/* queued stats shouldn't be cleared */
+	blkg_rwstat_merge(&to->service_bytes, &from->service_bytes);
+	blkg_rwstat_merge(&to->serviced, &from->serviced);
+	blkg_rwstat_merge(&to->merged, &from->merged);
+	blkg_rwstat_merge(&to->service_time, &from->service_time);
+	blkg_rwstat_merge(&to->wait_time, &from->wait_time);
+	blkg_stat_merge(&from->time, &from->time);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	blkg_stat_merge(&to->unaccounted_time, &from->unaccounted_time);
+	blkg_stat_merge(&to->avg_queue_size_sum, &from->avg_queue_size_sum);
+	blkg_stat_merge(&to->avg_queue_size_samples, &from->avg_queue_size_samples);
+	blkg_stat_merge(&to->dequeue, &from->dequeue);
+	blkg_stat_merge(&to->group_wait_time, &from->group_wait_time);
+	blkg_stat_merge(&to->idle_time, &from->idle_time);
+	blkg_stat_merge(&to->empty_time, &from->empty_time);
+#endif
+}
+
+/*
+ * Transfer @cfqg's stats to its parent's dead_stats so that the ancestors'
+ * recursive stats can still account for the amount used by this cfqg after
+ * it's gone.
+ */
+static void cfqg_stats_xfer_dead(struct cfq_group *cfqg)
+{
+	struct cfq_group *parent = cfqg_parent(cfqg);
+
+	lockdep_assert_held(cfqg_to_blkg(cfqg)->q->queue_lock);
+
+	if (unlikely(!parent))
+		return;
+
+	cfqg_stats_merge(&parent->dead_stats, &cfqg->stats);
+	cfqg_stats_merge(&parent->dead_stats, &cfqg->dead_stats);
+	cfqg_stats_reset(&cfqg->stats);
+	cfqg_stats_reset(&cfqg->dead_stats);
+}
+
 #else	/* CONFIG_CFQ_GROUP_IOSCHED */
 
 static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg) { return NULL; }
@@ -1475,11 +1517,23 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
 	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
 }
 
+static void cfq_pd_offline(struct blkcg_gq *blkg)
+{
+	/*
+	 * @blkg is going offline and will be ignored by
+	 * blkg_[rw]stat_recursive_sum().  Transfer stats to the parent so
+	 * that they don't get lost.  If IOs complete after this point, the
+	 * stats for them will be lost.  Oh well...
+	 */
+	cfqg_stats_xfer_dead(blkg_to_cfqg(blkg));
+}
+
 static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
 
 	cfqg_stats_reset(&cfqg->stats);
+	cfqg_stats_reset(&cfqg->dead_stats);
 }
 
 /*
@@ -4408,6 +4462,7 @@ static struct blkcg_policy blkcg_policy_cfq = {
 	.cftypes		= cfq_blkcg_files,
 
 	.pd_init_fn		= cfq_pd_init,
+	.pd_offline_fn		= cfq_pd_offline,
 	.pd_reset_stats_fn	= cfq_pd_reset_stats,
 };
 #endif
-- 
1.8.0.2

From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] bfq-iosched: stop using blkg->stat_bytes and ->stat_ios
Date: Wed,  6 Nov 2019 13:58:34 -0800
Message-ID: <20191106215838.3973497-2-tj@kernel.org>
References: <20191106215838.3973497-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EFOQyzdAOh5pEDm3B2vzWLhCGVBA0+rQSqnEuctv7O0=;
        b=Ynz07Cl5SmX1TE4Epf8q/jv9lH089hlEJY0miVQ9vSft2oj+rd5RJibmO7ZXmjOqzQ
         2fh0dIhDWxS3Z1YJg1kH6pbk/6ZlGyp3G3K2CpX2uXCNWnCKYNTYoiEGvtQRMWc0/oH/
         8Skfs09VCYS3jO8s46Qu/PaVMvJVIqL9SZx3Z5+J829cRAPzblHEQ19II41EflqAnsQr
         zqCLD+acTa9Z+y0XorBCmxSYmPyTblzc7NwEGvrRjMoWyTQ3JZl7j1tt3IWF96WQA4Dj
         L0aat3FqyO4WgfvKr0/42bLHeTHEH2Nj5q7kmGrTU7BXX55XwkLrBzB/1viwYLd5GeYz
         CZlg==
In-Reply-To: <20191106215838.3973497-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Paolo Valente <paolo.valente@linaro.org>

When used on cgroup1, bfq uses the blkg->stat_bytes and ->stat_ios
from blk-cgroup core to populate six stat knobs.  blk-cgroup core is
moving away from blkg_rwstat to improve scalability and won't be able
to support this usage.

It isn't like the sharing gains all that much.  Let's break it out to
dedicated rwstat counters which are updated when on cgroup1.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>
---
 block/bfq-cgroup.c  | 37 ++++++++++++++++++++++++++-----------
 block/bfq-iosched.c |  4 ++++
 block/bfq-iosched.h |  4 ++++
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 86a607cf19a1..c3093fde2e26 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -347,6 +347,14 @@ void bfqg_and_blkg_put(struct bfq_group *bfqg)
 	bfqg_put(bfqg);
 }
 
+void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq)
+{
+	struct bfq_group *bfqg = blkg_to_bfqg(rq->bio->bi_blkg);
+
+	blkg_rwstat_add(&bfqg->stats.bytes, rq->cmd_flags, blk_rq_bytes(rq));
+	blkg_rwstat_add(&bfqg->stats.ios, rq->cmd_flags, 1);
+}
+
 /* @stats = 0 */
 static void bfqg_stats_reset(struct bfqg_stats *stats)
 {
@@ -431,6 +439,8 @@ void bfq_init_entity(struct bfq_entity *entity, struct bfq_group *bfqg)
 
 static void bfqg_stats_exit(struct bfqg_stats *stats)
 {
+	blkg_rwstat_exit(&stats->bytes);
+	blkg_rwstat_exit(&stats->ios);
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
 	blkg_rwstat_exit(&stats->merged);
 	blkg_rwstat_exit(&stats->service_time);
@@ -448,6 +458,10 @@ static void bfqg_stats_exit(struct bfqg_stats *stats)
 
 static int bfqg_stats_init(struct bfqg_stats *stats, gfp_t gfp)
 {
+	if (blkg_rwstat_init(&stats->bytes, gfp) ||
+	    blkg_rwstat_init(&stats->ios, gfp))
+		return -ENOMEM;
+
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
 	if (blkg_rwstat_init(&stats->merged, gfp) ||
 	    blkg_rwstat_init(&stats->service_time, gfp) ||
@@ -1125,7 +1139,8 @@ static int bfqg_print_rwstat_recursive(struct seq_file *sf, void *v)
 static u64 bfqg_prfill_sectors(struct seq_file *sf, struct blkg_policy_data *pd,
 			       int off)
 {
-	u64 sum = blkg_rwstat_total(&pd->blkg->stat_bytes);
+	struct bfq_group *bfqg = blkg_to_bfqg(pd->blkg);
+	u64 sum = blkg_rwstat_total(&bfqg->stats.bytes);
 
 	return __blkg_prfill_u64(sf, pd, sum >> 9);
 }
@@ -1142,8 +1157,8 @@ static u64 bfqg_prfill_sectors_recursive(struct seq_file *sf,
 {
 	struct blkg_rwstat_sample tmp;
 
-	blkg_rwstat_recursive_sum(pd->blkg, NULL,
-			offsetof(struct blkcg_gq, stat_bytes), &tmp);
+	blkg_rwstat_recursive_sum(pd->blkg, &blkcg_policy_bfq,
+			offsetof(struct bfq_group, stats.bytes), &tmp);
 
 	return __blkg_prfill_u64(sf, pd,
 		(tmp.cnt[BLKG_RWSTAT_READ] + tmp.cnt[BLKG_RWSTAT_WRITE]) >> 9);
@@ -1226,13 +1241,13 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	/* statistics, covers only the tasks in the bfqg */
 	{
 		.name = "bfq.io_service_bytes",
-		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_bytes,
+		.private = offsetof(struct bfq_group, stats.bytes),
+		.seq_show = bfqg_print_rwstat,
 	},
 	{
 		.name = "bfq.io_serviced",
-		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_ios,
+		.private = offsetof(struct bfq_group, stats.ios),
+		.seq_show = bfqg_print_rwstat,
 	},
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
 	{
@@ -1269,13 +1284,13 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	/* the same statistics which cover the bfqg and its descendants */
 	{
 		.name = "bfq.io_service_bytes_recursive",
-		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_bytes_recursive,
+		.private = offsetof(struct bfq_group, stats.bytes),
+		.seq_show = bfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "bfq.io_serviced_recursive",
-		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_ios_recursive,
+		.private = offsetof(struct bfq_group, stats.ios),
+		.seq_show = bfqg_print_rwstat_recursive,
 	},
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
 	{
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b33be928d164..4629f5580d46 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5450,6 +5450,10 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	bool idle_timer_disabled = false;
 	unsigned int cmd_flags;
 
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
+		bfqg_stats_update_legacy_io(q, rq);
+#endif
 	spin_lock_irq(&bfqd->lock);
 	if (blk_mq_sched_try_insert_merge(q, rq)) {
 		spin_unlock_irq(&bfqd->lock);
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 5d1a519640f6..2676c06218f1 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -809,6 +809,9 @@ struct bfq_stat {
 };
 
 struct bfqg_stats {
+	/* basic stats */
+	struct blkg_rwstat		bytes;
+	struct blkg_rwstat		ios;
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
 	/* number of ios merged */
 	struct blkg_rwstat		merged;
@@ -956,6 +959,7 @@ void bfq_put_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
 
 /* ---------------- cgroups-support interface ---------------- */
 
+void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq);
 void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
 			      unsigned int op);
 void bfqg_stats_update_io_remove(struct bfq_group *bfqg, unsigned int op);
-- 
2.17.1


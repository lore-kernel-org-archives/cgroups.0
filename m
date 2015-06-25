From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/6] blkcg: remove cfqg_stats->sectors
Date: Thu, 25 Jun 2015 17:38:57 -0400
Message-ID: <1435268337-1738-7-git-send-email-tj@kernel.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=krAQzX2KJNKY238kLzEvYtdrxakjjEOcFLyJ29eXSVs=;
        b=RoF1nE4CaFswiv52im9PvxE1xj9ks1ExPfOOhK/5BdXDmal30BP5HYvpC18V/UL+Af
         PFJ+JOc1FWYEzlrdJtcF+7FCpyt5qQp4b6URS39cqp5uUwcBj2lzXXSwXJpZyIPhzq8B
         PHAhLpmufdKsn5iB00ZGJ8YxlPkxr1Mw4lFtS6sfgTLiKhL+ISOoMcWGL1h//+8544MA
         XZiu/sHsTMPRqJY79JWRxf2cSepFMRfFHycJ8PGO4mcjwpD+I9w89jcSTvBVel6TtpGK
         yzUoh423VC2spiDapvQQWoQQ8WHFQQh+sbpeMEB2AejseKnh/eePJJpQfyn2Bku/uiSN
         1IDg==
In-Reply-To: <1435268337-1738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cfq_stats->sectors is a blkg_stat which keeps track of the total
number of sectors serviced; however, this can be trivially calculated
from blkcg_gq->stat_bytes.  The only thing necessary is adding up
READs and WRITEs and then dividing by sector size.

Remove cfqg_stats->sectors and make cfq print "sectors" and
"sectors_recursive" from stat_bytes.

While this is a bit more code, it removes duplicate stat allocations
and updates and ensures that the reported stats stay in tune with each
other.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c | 55 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a6dd941..90b5bfe 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -180,8 +180,6 @@ struct cfqg_stats {
 	struct blkg_rwstat		wait_time;
 	/* number of IOs queued up */
 	struct blkg_rwstat		queued;
-	/* total sectors transferred */
-	struct blkg_stat		sectors;
 	/* total disk time and nr sectors dispatched by this group */
 	struct blkg_stat		time;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
@@ -663,12 +661,6 @@ static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int rw)
 	blkg_rwstat_add(&cfqg->stats.merged, rw, 1);
 }
 
-static inline void cfqg_stats_update_dispatch(struct cfq_group *cfqg,
-					      uint64_t bytes, int rw)
-{
-	blkg_stat_add(&cfqg->stats.sectors, bytes >> 9);
-}
-
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 			uint64_t start_time, uint64_t io_start_time, int rw)
 {
@@ -757,8 +749,6 @@ static inline void cfqg_stats_update_timeslice_used(struct cfq_group *cfqg,
 			unsigned long time, unsigned long unaccounted_time) { }
 static inline void cfqg_stats_update_io_remove(struct cfq_group *cfqg, int rw) { }
 static inline void cfqg_stats_update_io_merged(struct cfq_group *cfqg, int rw) { }
-static inline void cfqg_stats_update_dispatch(struct cfq_group *cfqg,
-					      uint64_t bytes, int rw) { }
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 			uint64_t start_time, uint64_t io_start_time, int rw) { }
 
@@ -1513,8 +1503,6 @@ static void cfqg_stats_exit(struct cfqg_stats *stats)
 	blkg_rwstat_exit(&stats->service_time);
 	blkg_rwstat_exit(&stats->wait_time);
 	blkg_rwstat_exit(&stats->queued);
-
-	blkg_stat_exit(&stats->sectors);
 	blkg_stat_exit(&stats->time);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	blkg_stat_exit(&stats->unaccounted_time);
@@ -1533,8 +1521,6 @@ static int cfqg_stats_init(struct cfqg_stats *stats, gfp_t gfp)
 	    blkg_rwstat_init(&stats->service_time, gfp) ||
 	    blkg_rwstat_init(&stats->wait_time, gfp) ||
 	    blkg_rwstat_init(&stats->queued, gfp) ||
-
-	    blkg_stat_init(&stats->sectors, gfp) ||
 	    blkg_stat_init(&stats->time, gfp))
 		goto err;
 
@@ -1833,6 +1819,40 @@ static int cfqg_print_rwstat_recursive(struct seq_file *sf, void *v)
 	return 0;
 }
 
+static u64 cfqg_prfill_sectors(struct seq_file *sf, struct blkg_policy_data *pd,
+			       int off)
+{
+	u64 sum = blkg_rwstat_total(&pd->blkg->stat_bytes);
+
+	return __blkg_prfill_u64(sf, pd, sum >> 9);
+}
+
+static int cfqg_print_stat_sectors(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  cfqg_prfill_sectors, &blkcg_policy_cfq, 0, false);
+	return 0;
+}
+
+static u64 cfqg_prfill_sectors_recursive(struct seq_file *sf,
+					 struct blkg_policy_data *pd, int off)
+{
+	struct blkg_rwstat tmp = blkg_rwstat_recursive_sum(pd->blkg, NULL,
+					offsetof(struct blkcg_gq, stat_bytes));
+	u64 sum = atomic64_read(&tmp.aux_cnt[BLKG_RWSTAT_READ]) +
+		atomic64_read(&tmp.aux_cnt[BLKG_RWSTAT_WRITE]);
+
+	return __blkg_prfill_u64(sf, pd, sum >> 9);
+}
+
+static int cfqg_print_stat_sectors_recursive(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  cfqg_prfill_sectors_recursive, &blkcg_policy_cfq, 0,
+			  false);
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 				      struct blkg_policy_data *pd, int off)
@@ -1907,8 +1927,7 @@ static struct cftype cfq_blkcg_files[] = {
 	},
 	{
 		.name = "sectors",
-		.private = offsetof(struct cfq_group, stats.sectors),
-		.seq_show = cfqg_print_stat,
+		.seq_show = cfqg_print_stat_sectors,
 	},
 	{
 		.name = "io_service_bytes",
@@ -1949,8 +1968,7 @@ static struct cftype cfq_blkcg_files[] = {
 	},
 	{
 		.name = "sectors_recursive",
-		.private = offsetof(struct cfq_group, stats.sectors),
-		.seq_show = cfqg_print_stat_recursive,
+		.seq_show = cfqg_print_stat_sectors_recursive,
 	},
 	{
 		.name = "io_service_bytes_recursive",
@@ -2820,7 +2838,6 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
-	cfqg_stats_update_dispatch(cfqq->cfqg, blk_rq_bytes(rq), rq->cmd_flags);
 }
 
 /*
-- 
2.4.3

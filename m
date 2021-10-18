From: Zheng Liang <zhengliang6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] block, bfq: fix UAF problem in bfqg_stats_init()
Date: Mon, 18 Oct 2021 10:42:25 +0800
Message-ID: <20211018024225.1493938-1-zhengliang6@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhengliang6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

In bfq_pd_alloc(), the function bfqg_stats_init() init bfqg. If
blkg_rwstat_init() init bfqg_stats->bytes successful and init
bfqg_stats->ios failed, bfqg_stats_init() return failed, bfqg will
be freed. But blkg_rwstat->cpu_cnt is not deleted from the list of
percpu_counters. If we traverse the list of percpu_counters, It will
have UAF problem.

we should use blkg_rwstat_exit() to cleanup bfqg_stats bytes in the
above scenario.

Fixes: commit fd41e60331b ("bfq-iosched: stop using blkg->stat_bytes and ->stat_ios")
Signed-off-by: Zheng Liang <zhengliang6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Changes since v1:
    Change some description for this patch
---
 block/bfq-cgroup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e2f14508f2d6..243ffbc1f106 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -463,7 +463,7 @@ static int bfqg_stats_init(struct bfqg_stats *stats, gfp_t gfp)
 {
 	if (blkg_rwstat_init(&stats->bytes, gfp) ||
 	    blkg_rwstat_init(&stats->ios, gfp))
-		return -ENOMEM;
+		goto error;
 
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
 	if (blkg_rwstat_init(&stats->merged, gfp) ||
@@ -476,13 +476,15 @@ static int bfqg_stats_init(struct bfqg_stats *stats, gfp_t gfp)
 	    bfq_stat_init(&stats->dequeue, gfp) ||
 	    bfq_stat_init(&stats->group_wait_time, gfp) ||
 	    bfq_stat_init(&stats->idle_time, gfp) ||
-	    bfq_stat_init(&stats->empty_time, gfp)) {
-		bfqg_stats_exit(stats);
-		return -ENOMEM;
-	}
+	    bfq_stat_init(&stats->empty_time, gfp))
+		goto error;
 #endif
 
 	return 0;
+
+error:
+	bfqg_stats_exit(stats);
+	return -ENOMEM;
 }
 
 static struct bfq_group_data *cpd_to_bfqgd(struct blkcg_policy_data *cpd)
-- 
2.25.4


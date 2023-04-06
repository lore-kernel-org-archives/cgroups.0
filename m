From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 2/3] blk-cgroup: delete cpd_bind_fn of blkcg_policy
Date: Thu,  6 Apr 2023 22:50:49 +0800
Message-ID: <20230406145050.49914-3-zhouchengming@bytedance.com>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680792669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhKhQOgHY4omeSf5oEZtApwayoKc6MIO22TQQuOJpsE=;
        b=CZieEMBTQy1sXreaOD5ONqXZQm9UZPO2FMYEGmaNnkHl66lF7X+TBFOBF6YevEuu8i
         3Un4k80LJ/JCkwFV5Sh2Sy/bEr8qsUPVwTEVaLCnDM7bLXbriwFdcGb0kp5rcx24Z+S4
         KTTkHmaT256dZfW4jWHyf4zlv/oHcnh+7+HqdkStMzmJ0UgKtY9uiliIZwqdHLzNML6R
         vMURaaBcOSPsvGPNdYwg5hrkebPPacRI9ZQresV32Nc6IzjvZHk1zUDKaQU1BoBryxgI
         oKT7HJQsPcdgYvEb0bhL8hVdsV1uB5W8kEneVCkEVjDIEv0GA7zDkS3RCzs+xtmQ5Z25
         NJxA==
In-Reply-To: <20230406145050.49914-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: paolo.valente@linaro.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

cpd_bind_fn is just used for update default weight when block
subsys attached to a hierarchy. No any policy need it anymore.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 21 ---------------------
 block/blk-cgroup.h |  1 -
 2 files changed, 22 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 18c922579719..f663178f3a19 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1395,26 +1395,6 @@ void blkcg_exit_disk(struct gendisk *disk)
 	blk_throtl_exit(disk);
 }
 
-static void blkcg_bind(struct cgroup_subsys_state *root_css)
-{
-	int i;
-
-	mutex_lock(&blkcg_pol_mutex);
-
-	for (i = 0; i < BLKCG_MAX_POLS; i++) {
-		struct blkcg_policy *pol = blkcg_policy[i];
-		struct blkcg *blkcg;
-
-		if (!pol || !pol->cpd_bind_fn)
-			continue;
-
-		list_for_each_entry(blkcg, &all_blkcgs, all_blkcgs_node)
-			if (blkcg->cpd[pol->plid])
-				pol->cpd_bind_fn(blkcg->cpd[pol->plid]);
-	}
-	mutex_unlock(&blkcg_pol_mutex);
-}
-
 static void blkcg_exit(struct task_struct *tsk)
 {
 	if (tsk->throttle_disk)
@@ -1428,7 +1408,6 @@ struct cgroup_subsys io_cgrp_subsys = {
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.css_rstat_flush = blkcg_rstat_flush,
-	.bind = blkcg_bind,
 	.dfl_cftypes = blkcg_files,
 	.legacy_cftypes = blkcg_legacy_files,
 	.legacy_name = "blkio",
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e98d2c1be354..073488b9c7a0 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -176,7 +176,6 @@ struct blkcg_policy {
 	blkcg_pol_alloc_cpd_fn		*cpd_alloc_fn;
 	blkcg_pol_init_cpd_fn		*cpd_init_fn;
 	blkcg_pol_free_cpd_fn		*cpd_free_fn;
-	blkcg_pol_bind_cpd_fn		*cpd_bind_fn;
 
 	blkcg_pol_alloc_pd_fn		*pd_alloc_fn;
 	blkcg_pol_init_pd_fn		*pd_init_fn;
-- 
2.39.2


From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH 2/4] blk-cgroup: delete cpd_bind_fn of blkcg_policy
Date: Tue, 28 Mar 2023 22:56:59 +0800
Message-ID: <20230328145701.33699-2-zhouchengming@bytedance.com>
References: <20230328145701.33699-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680015480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOMekqn6pAwuBjuJCTIwhDMskHoRMJ6M6licWqxl8ps=;
        b=kVjgs28u6ZNksz2pEQtkpS4P2iL7oyh1qLcvOVf/Afxc4nu07gCLFqhc30KY+nG0Z2
         O46T4piDfw0CifTJue9YTlQLKMkQPF9usnesOs1qpsRQkuyoztQiHfYhgA6YjfrAIoNJ
         A9HH1J5+lxm9cbIJYTjFFl2Zu0LjM1IHn9J5kM2wiBJNaSdbfHTOrrOopcCEw1aPkdDV
         XzHzQ0B5XCYJHHatR9RvMWDSSElzbFCBbmjhNKXBv5KT6O9jaY4AbWq/AoELevMfujBc
         vmMKlzPkWPZ6hH8Pss0I5aZ6ZrrreQwqQqbzyOq7P7bHfUXilV1Oj42VyzOXWTL8mJfC
         c0Wg==
In-Reply-To: <20230328145701.33699-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

cpd_bind_fn is just used for update default weight when block
subsys attached to a hierarchy. No any policy need it anymore.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 block/blk-cgroup.c | 21 ---------------------
 block/blk-cgroup.h |  1 -
 2 files changed, 22 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bd50b55bdb61..68b797b3f114 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1355,26 +1355,6 @@ void blkcg_exit_disk(struct gendisk *disk)
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
@@ -1388,7 +1368,6 @@ struct cgroup_subsys io_cgrp_subsys = {
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.css_rstat_flush = blkcg_rstat_flush,
-	.bind = blkcg_bind,
 	.dfl_cftypes = blkcg_files,
 	.legacy_cftypes = blkcg_legacy_files,
 	.legacy_name = "blkio",
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 9c5078755e5e..26ce62663e27 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -175,7 +175,6 @@ struct blkcg_policy {
 	blkcg_pol_alloc_cpd_fn		*cpd_alloc_fn;
 	blkcg_pol_init_cpd_fn		*cpd_init_fn;
 	blkcg_pol_free_cpd_fn		*cpd_free_fn;
-	blkcg_pol_bind_cpd_fn		*cpd_bind_fn;
 
 	blkcg_pol_alloc_pd_fn		*pd_alloc_fn;
 	blkcg_pol_init_pd_fn		*pd_init_fn;
-- 
2.39.2


From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 3/3] blk-cgroup: delete cpd_init_fn of blkcg_policy
Date: Thu,  6 Apr 2023 22:50:50 +0800
Message-ID: <20230406145050.49914-4-zhouchengming@bytedance.com>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680792672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IukBswUItQA0MwJ6mr8lJHmbvkt98zOHJDlzuZ9xc8=;
        b=iRJlt1CJvMm9eA18RMsi4Pd2vmqTpZST7WKy5PYRQriAE6O/3yD7tZ46f159yNbdWd
         sWkHmJyRT1QPOpKg1FKIakni2SeNhFvE47g04BKr12DCIKMh5ntJ8Bhq++/2LSXORGQk
         81N2B5tvbHSyGgxcdDOX6g+f+n/1cRHK2LWyUferpNf/DBOa02WAou5MUpMmVmafqLT5
         X0hpmy3pNW832fIRF8gT3xx7WlcPuwgoseI7QevKWW1jDeRF0C3XA6YUMBdgE0HE/zEH
         CFK2P57NKeaxPyOJZPLj/9/XBA61NM442z53Dnz6jwJ/G0q1piRk0XHrxw84/n75W0mq
         CEsQ==
In-Reply-To: <20230406145050.49914-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: paolo.valente@linaro.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

blkcg_policy cpd_init_fn() is used to just initialize some default
fields of policy data, which is enough to do in cpd_alloc_fn().

This patch delete the only user bfq_cpd_init(), and remove cpd_init_fn
from blkcg_policy.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bfq-cgroup.c | 10 ++--------
 block/blk-cgroup.c |  4 ----
 block/blk-cgroup.h |  1 -
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index a2ab5dd58068..74f7d051665b 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -497,14 +497,9 @@ static struct blkcg_policy_data *bfq_cpd_alloc(gfp_t gfp)
 	bgd = kzalloc(sizeof(*bgd), gfp);
 	if (!bgd)
 		return NULL;
-	return &bgd->pd;
-}
 
-static void bfq_cpd_init(struct blkcg_policy_data *cpd)
-{
-	struct bfq_group_data *d = cpd_to_bfqgd(cpd);
-
-	d->weight = CGROUP_WEIGHT_DFL;
+	bgd->weight = CGROUP_WEIGHT_DFL;
+	return &bgd->pd;
 }
 
 static void bfq_cpd_free(struct blkcg_policy_data *cpd)
@@ -1300,7 +1295,6 @@ struct blkcg_policy blkcg_policy_bfq = {
 	.legacy_cftypes		= bfq_blkcg_legacy_files,
 
 	.cpd_alloc_fn		= bfq_cpd_alloc,
-	.cpd_init_fn		= bfq_cpd_init,
 	.cpd_free_fn		= bfq_cpd_free,
 
 	.pd_alloc_fn		= bfq_pd_alloc,
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f663178f3a19..5fa77f32a52b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1289,8 +1289,6 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 		blkcg->cpd[i] = cpd;
 		cpd->blkcg = blkcg;
 		cpd->plid = i;
-		if (pol->cpd_init_fn)
-			pol->cpd_init_fn(cpd);
 	}
 
 	spin_lock_init(&blkcg->lock);
@@ -1645,8 +1643,6 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 			blkcg->cpd[pol->plid] = cpd;
 			cpd->blkcg = blkcg;
 			cpd->plid = pol->plid;
-			if (pol->cpd_init_fn)
-				pol->cpd_init_fn(cpd);
 		}
 	}
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 073488b9c7a0..6794157ea1eb 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -174,7 +174,6 @@ struct blkcg_policy {
 
 	/* operations */
 	blkcg_pol_alloc_cpd_fn		*cpd_alloc_fn;
-	blkcg_pol_init_cpd_fn		*cpd_init_fn;
 	blkcg_pol_free_cpd_fn		*cpd_free_fn;
 
 	blkcg_pol_alloc_pd_fn		*pd_alloc_fn;
-- 
2.39.2


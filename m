From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 1/3] block, bfq: remove BFQ_WEIGHT_LEGACY_DFL
Date: Thu,  6 Apr 2023 22:50:48 +0800
Message-ID: <20230406145050.49914-2-zhouchengming@bytedance.com>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680792666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvxogFZ7tzo2z7dxF0J9Y3jJgkG796IBeY87z8Qv1kQ=;
        b=PxWqmBRUj4WBnZSfVzpRfLqostqKXR8X10+oF706WENnUQNTAeGyug62X2dsa4tpYN
         TmZJqensASXgsRSvYlajRgHSMIgj2iFr/xVKZh8tJZGDsoodlod6SdH5oK9lq7q+7ePl
         eaWtyww8e1C07Wfpb5nER82j3g66y0RauEyorkQixXonVxmvCfIDmD6SHJ6PzTQihsqe
         I2AQUXe4NtRjpaxWSZwm/sykWFD+1zLra0dC+oUYexpzGyYlq9uYv7vXgtDPypULn3GD
         qClosOFu9bbC+DXhM1sMN06zbLRpwPyZr8aDAP28l2d16iq49K4A3UQfJINl2MstFl0K
         VtEg==
In-Reply-To: <20230406145050.49914-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: paolo.valente@linaro.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

BFQ_WEIGHT_LEGACY_DFL is the same as CGROUP_WEIGHT_DFL, which means
we don't need cpd_bind_fn() callback to update default weight when
attached to a hierarchy.

This patch remove BFQ_WEIGHT_LEGACY_DFL and cpd_bind_fn().

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bfq-cgroup.c  | 4 +---
 block/bfq-iosched.h | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 89ffb3aa992c..a2ab5dd58068 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -504,8 +504,7 @@ static void bfq_cpd_init(struct blkcg_policy_data *cpd)
 {
 	struct bfq_group_data *d = cpd_to_bfqgd(cpd);
 
-	d->weight = cgroup_subsys_on_dfl(io_cgrp_subsys) ?
-		CGROUP_WEIGHT_DFL : BFQ_WEIGHT_LEGACY_DFL;
+	d->weight = CGROUP_WEIGHT_DFL;
 }
 
 static void bfq_cpd_free(struct blkcg_policy_data *cpd)
@@ -1302,7 +1301,6 @@ struct blkcg_policy blkcg_policy_bfq = {
 
 	.cpd_alloc_fn		= bfq_cpd_alloc,
 	.cpd_init_fn		= bfq_cpd_init,
-	.cpd_bind_fn	        = bfq_cpd_init,
 	.cpd_free_fn		= bfq_cpd_free,
 
 	.pd_alloc_fn		= bfq_pd_alloc,
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 69aaee52285a..467e8cfc41a2 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -20,7 +20,6 @@
 
 #define BFQ_DEFAULT_QUEUE_IOPRIO	4
 
-#define BFQ_WEIGHT_LEGACY_DFL	100
 #define BFQ_DEFAULT_GRP_IOPRIO	0
 #define BFQ_DEFAULT_GRP_CLASS	IOPRIO_CLASS_BE
 
-- 
2.39.2


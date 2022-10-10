From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 3/4] blk-cgroup: Add NULL check of pd_alloc_fn in blkcg_activate_policy
Date: Mon, 10 Oct 2022 10:38:58 +0800
Message-ID: <20221010023859.11896-4-shikemeng@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221010023859.11896-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Function blkcg_policy_register only make sure pd_alloc_fn and pd_free_fn in
pairs, so pd_alloc_fn could be NULL in registered blkcg_policy. Check NULL
before use for pd_alloc_fn in blkcg_activate_policy to avoid protential
NULL dereference.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 463c568d3e86..fc083c35dc42 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1404,6 +1404,9 @@ int blkcg_activate_policy(struct request_queue *q,
 	if (blkcg_policy_enabled(q, pol))
 		return 0;
 
+	if (pol->pd_alloc_fn == NULL)
+		return -EINVAL;
+
 	if (queue_is_mq(q))
 		blk_mq_freeze_queue(q);
 retry:
-- 
2.30.0


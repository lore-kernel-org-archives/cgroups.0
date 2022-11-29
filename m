From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 06/10] blk-throttle: fix typo in comment of throtl_adjusted_limit
Date: Tue, 29 Nov 2022 11:01:43 +0800
Message-ID: <20221129030147.27400-7-shikemeng@huawei.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221129030147.27400-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

lapsed time -> elapsed time

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4977fac56a00..4b11099625da 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -129,7 +129,7 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
 /*
  * cgroup's limit in LIMIT_MAX is scaled if low limit is set. This scale is to
  * make the IO dispatch more smooth.
- * Scale up: linearly scale up according to lapsed time since upgrade. For
+ * Scale up: linearly scale up according to elapsed time since upgrade. For
  *           every throtl_slice, the limit scales up 1/2 .low limit till the
  *           limit hits .max limit
  * Scale down: exponentially scale down if a cgroup doesn't hit its .low limit
-- 
2.30.0


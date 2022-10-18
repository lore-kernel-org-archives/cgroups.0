From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 1/5] blk-iocost: Fix typo in comment
Date: Tue, 18 Oct 2022 20:19:28 +0800
Message-ID: <20221018121932.10792-2-shikemeng@huawei.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221018121932.10792-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

soley -> solely

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 495396425bad..be4bc38821e2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -111,7 +111,7 @@
  * busy signal.
  *
  * As devices can have deep queues and be unfair in how the queued commands
- * are executed, soley depending on rq wait may not result in satisfactory
+ * are executed, solely depending on rq wait may not result in satisfactory
  * control quality.  For a better control quality, completion latency QoS
  * parameters can be configured so that the device is considered saturated
  * if N'th percentile completion latency rises above the set point.
-- 
2.30.0


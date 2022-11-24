From: Li Nan <linan122@huawei.com>
Subject: [PATCH -next 2/2] blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in ioc_refresh_params()
Date: Thu, 24 Nov 2022 22:06:35 +0800
Message-ID: <20221124140635.695205-2-linan122@huawei.com>
References: <20221124140635.695205-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221124140635.695205-1-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com

vrate_min is calculated by DIV64_U64_ROUND_UP, but vrate_max is calculated
by div64_u64. Vrate_min may be 1 greater than vrate_max if the input
values min and max of cost.qos are equal.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a38a5324bf10..9030ad8672f3 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -926,7 +926,7 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
 
 	ioc->vrate_min = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MIN] *
 					    VTIME_PER_USEC, MILLION);
-	ioc->vrate_max = div64_u64((u64)ioc->params.qos[QOS_MAX] *
+	ioc->vrate_max = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MAX] *
 				   VTIME_PER_USEC, MILLION);
 
 	return true;
-- 
2.31.1


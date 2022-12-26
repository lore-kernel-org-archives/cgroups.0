From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v3 5/5] blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in ioc_refresh_params()
Date: Mon, 26 Dec 2022 16:58:59 +0800
Message-ID: <20221226085859.2701195-6-yukuai1@huaweicloud.com>
References: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Li Nan <linan122@huawei.com>

vrate_min is calculated by DIV64_U64_ROUND_UP, but vrate_max is calculated
by div64_u64. Vrate_min may be 1 greater than vrate_max if the input
values min and max of cost.qos are equal.

Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-iocost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c6b39024117b..7a0d754b9eb2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -930,8 +930,8 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
 
 	ioc->vrate_min = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MIN] *
 					    VTIME_PER_USEC, MILLION);
-	ioc->vrate_max = div64_u64((u64)ioc->params.qos[QOS_MAX] *
-				   VTIME_PER_USEC, MILLION);
+	ioc->vrate_max = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MAX] *
+					    VTIME_PER_USEC, MILLION);
 
 	return true;
 }
-- 
2.31.1


From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v4 5/5] blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in ioc_refresh_params()
Date: Tue, 17 Jan 2023 15:08:06 +0800
Message-ID: <20230117070806.3857142-6-yukuai1@huaweicloud.com>
References: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230117070806.3857142-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

vrate_min is calculated by DIV64_U64_ROUND_UP, but vrate_max is calculated
by div64_u64. Vrate_min may be 1 greater than vrate_max if the input
values min and max of cost.qos are equal.

Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 4cac0e7bb7cc..1f23480a7a01 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -931,8 +931,8 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
 
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


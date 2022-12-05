From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v3 7/9] blk-throttle: remove incorrect comment for tg_last_low_overflow_time
Date: Mon,  5 Dec 2022 19:57:07 +0800
Message-ID: <20221205115709.251489-8-shikemeng@huaweicloud.com>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221205115709.251489-1-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Function tg_last_low_overflow_time is called with intermediate node as
following:
throtl_hierarchy_can_downgrade
  throtl_tg_can_downgrade
    tg_last_low_overflow_time

throtl_hierarchy_can_upgrade
  throtl_tg_can_upgrade
    tg_last_low_overflow_time

throtl_hierarchy_can_downgrade/throtl_hierarchy_can_upgrade will traverse
from leaf node to sub-root node and pass traversed intermediate node
to tg_last_low_overflow_time.

No such limit could be found from context and implementation of
tg_last_low_overflow_time, so remove this limit in comment.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
---
 block/blk-throttle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7db8592dae38..e6a087de414d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1762,7 +1762,6 @@ static unsigned long __tg_last_low_overflow_time(struct throtl_grp *tg)
 	return min(rtime, wtime);
 }
 
-/* tg should not be an intermediate node */
 static unsigned long tg_last_low_overflow_time(struct throtl_grp *tg)
 {
 	struct throtl_service_queue *parent_sq;
-- 
2.30.0


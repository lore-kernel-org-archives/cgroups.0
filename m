From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v3 6/9] blk-throttle: fix typo in comment of throtl_adjusted_limit
Date: Mon,  5 Dec 2022 19:57:06 +0800
Message-ID: <20221205115709.251489-7-shikemeng@huaweicloud.com>
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

lapsed time -> elapsed time

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 1623507ed56e..7db8592dae38 100644
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


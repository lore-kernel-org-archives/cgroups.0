From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/11] blk-throttle: Use more siutable time_after check for update slice_start
Date: Wed, 23 Nov 2022 14:04:01 +0800
Message-ID: <20221123060401.20392-12-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221123060401.20392-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Use more siutable time_after check for update slice_start

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 82fe23e79b4b..69eeff764dee 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -635,7 +635,7 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 	 * that bandwidth. Do try to make use of that bandwidth while giving
 	 * credit.
 	 */
-	if (time_after_eq(start, tg->slice_start[rw]))
+	if (time_after(start, tg->slice_start[rw]))
 		tg->slice_start[rw] = start;
 
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
-- 
2.30.0


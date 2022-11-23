From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/11] blk-throttle: ignore cgroup without io queued in blk_throtl_cancel_bios
Date: Wed, 23 Nov 2022 14:03:53 +0800
Message-ID: <20221123060401.20392-4-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221123060401.20392-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Ignore cgroup without io queued in blk_throtl_cancel_bios for two
reasons:
1. Save cpu cycle for trying to dispatch cgroup which is no io queued.
2. Avoid non-consistent state that cgroup is inserted to service queue
without THROTL_TG_PENDING set as tg_update_disptime will unconditional
re-insert cgroup to service queue. If we are on the default hierarchy,
IO dispatched from child in tg_dispatch_one_bio will trigger inserting
cgroup to service queue without erase first and ruin the tree.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b33bcf53b36e..acfac916ed99 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1728,7 +1728,12 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
 		 * Set the flag to make sure throtl_pending_timer_fn() won't
 		 * stop until all throttled bios are dispatched.
 		 */
-		blkg_to_tg(blkg)->flags |= THROTL_TG_CANCELING;
+		tg->flags |= THROTL_TG_CANCELING;
+
+		/* No need to dispatch cgroup without io queued */
+		if (!(tg->flags & THROTL_TG_PENDING))
+			continue;
+
 		/*
 		 * Update disptime after setting the above flag to make sure
 		 * throtl_select_dispatch() won't exit without dispatching.
-- 
2.30.0


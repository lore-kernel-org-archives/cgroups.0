From: Zhang Wensheng <zhangwensheng5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] block: fix io hung of setting throttle limit frequently
Date: Mon, 16 May 2022 09:44:29 +0800
Message-ID: <20220516014429.33723-1-zhangwensheng5@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Our test find a io hung problem which could be simplified:
setting throttle iops/bps limit to small, and to issue a big
bio. if the io is limited to 10s, just wait 1s, continue to
set same throttle iops/bps limit again, now, we could see
that the new throttle time become 10s again, like this, if
we distribute limit repeatedly within 10s, this io will always
in throttle queue.

when the throttle limit iops/bps is set to io. tg_conf_updated
will be called, it will start a new slice and update a new
dispatch time to pending timer which lead to wait again.

Because of commit 9f5ede3c01f9 ("block: throttle split bio in
case of iops limit"), the io will work fine if limited by bps.
which could fix part of the problem, not the root cause.

To fix this problem, adding the judge before update dispatch time.
if the pending timer is alive, we should not to update time.

Signed-off-by: Zhang Wensheng <zhangwensheng5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 469c483719be..8acb205dfa85 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1321,12 +1321,14 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 	 * that a group's limit are dropped suddenly and we don't want to
 	 * account recently dispatched IO with new low rate.
 	 */
-	throtl_start_new_slice(tg, READ);
-	throtl_start_new_slice(tg, WRITE);
+	if (!timer_pending(&sq->parent_sq->pending_timer)) {
+		throtl_start_new_slice(tg, READ);
+		throtl_start_new_slice(tg, WRITE);
 
-	if (tg->flags & THROTL_TG_PENDING) {
-		tg_update_disptime(tg);
-		throtl_schedule_next_dispatch(sq->parent_sq, true);
+		if (tg->flags & THROTL_TG_PENDING) {
+			tg_update_disptime(tg);
+			throtl_schedule_next_dispatch(sq->parent_sq, true);
+		}
 	}
 }
 
-- 
2.31.1


From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 2/8] blk-throttle: Avoid getting the current time if tg->last_finish_time is 0
Date: Thu,  8 Oct 2020 11:52:23 +0800
Message-ID: <69cee051a3af94042c9479c39439fab38864e8b2.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1602128837.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
In-Reply-To: <cover.1602128837.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
References: <cover.1602128837.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We only update the tg->last_finish_time when the low limitaion is
enabled, so we can move the tg->last_finish_time validation a little
forward to avoid getting the unnecessary current time stamp if the
the low limitation is not enabled.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 block/blk-throttle.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4007b26..7e72102 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2077,10 +2077,14 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 
 static void blk_throtl_update_idletime(struct throtl_grp *tg)
 {
-	unsigned long now = ktime_get_ns() >> 10;
+	unsigned long now;
 	unsigned long last_finish_time = tg->last_finish_time;
 
-	if (now <= last_finish_time || last_finish_time == 0 ||
+	if (last_finish_time == 0)
+		return;
+
+	now = ktime_get_ns() >> 10;
+	if (now <= last_finish_time ||
 	    last_finish_time == tg->checked_last_finish_time)
 		return;
 
-- 
1.8.3.1


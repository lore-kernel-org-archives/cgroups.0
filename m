From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 3/4] blk-throttle: Avoid tracking latency if low limit is invalid
Date: Sun, 20 Sep 2020 17:14:26 +0800
Message-ID: <a244c9973c6fc0081dba4142625840696b386a0f.1600592693.git.baolin.wang@linux.alibaba.com>
References: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1600592693.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The IO latency tracking is only for LOW limit, so we should add a
validation to avoid redundant latency tracking if the LOW limit
is not valid.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 block/blk-throttle.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7e72102..b0d8f7c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2100,7 +2100,7 @@ static void throtl_update_latency_buckets(struct throtl_data *td)
 	unsigned long last_latency[2] = { 0 };
 	unsigned long latency[2];
 
-	if (!blk_queue_nonrot(td->queue))
+	if (!blk_queue_nonrot(td->queue) || !td->limit_valid[LIMIT_LOW])
 		return;
 	if (time_before(jiffies, td->last_calculate_time + HZ))
 		return;
@@ -2338,6 +2338,8 @@ void blk_throtl_bio_endio(struct bio *bio)
 	if (!blkg)
 		return;
 	tg = blkg_to_tg(blkg);
+	if (!tg->td->limit_valid[LIMIT_LOW])
+		return;
 
 	finish_time_ns = ktime_get_ns();
 	tg->last_finish_time = finish_time_ns >> 10;
-- 
1.8.3.1


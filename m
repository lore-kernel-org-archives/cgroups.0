From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] blk-iolatency: error out if blk_get_queue() failed in iolatency_set_limit()
Date: Thu, 5 Aug 2021 20:46:45 +0800
Message-ID: <20210805124645.543797-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, bo.liu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If queue is dying while iolatency_set_limit() is in progress,
blk_get_queue() won't increment the refcount of the queue. However,
blk_put_queue() will still decrement the refcount later, which will
cause the refcout to be unbalanced.

Thus error out in such case to fix the problem.

Fixes: 8c772a9bfc7c ("blk-iolatency: fix IO hang due to negative inflight counter")
Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iolatency.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 81be0096411d..d8b0d8bd132b 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -833,7 +833,11 @@ static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
 
 	enable = iolatency_set_min_lat_nsec(blkg, lat_val);
 	if (enable) {
-		WARN_ON_ONCE(!blk_get_queue(blkg->q));
+		if (!blk_get_queue(blkg->q)) {
+			ret = -ENODEV;
+			goto out;
+		}
+
 		blkg_get(blkg);
 	}
 
-- 
2.31.1


From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-block] blk-cgroup: Use css_tryget() in blkcg_destroy_blkgs()
Date: Sun, 27 Nov 2022 22:30:57 -0500
Message-ID: <20221128033057.1279383-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669606292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mh8+HZNMN2F6HzSwmWPr16ecpqC3Mw7WO0DSOHuRXuQ=;
        b=JD1i+j+QXnc1HbipMzQVoy70Q7r2FqnP54sOXtsrQmDNrJYY8FhPMvAPYDDPkRkEkBnvGN
        kdW0JcwqJFKbAynjcX2aZ8pdq0uyjfV+qt/sQ/TrZ7msaY2wB419SA3L+0Po3ODOqsTDVy
        O0NlNcKEyNaQMH4wBTuSK854fI/wc2g=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Commit 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction
path") incorrectly assumes that css_get() will always succeed. That may
not be true if there is no blkg associated with the blkcg. If css_get()
fails, the subsequent css_put() call may lead to data corruption as
was illustrated in a test system that it crashed on bootup when that
commit was included. Also blkcg may be freed at any time leading to
use-after-free. Fix it by using css_tryget() instead and bail out if
the tryget fails.

Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
Reported-by: Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 57941d2a8ba3..74fefc8cbcdf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1088,7 +1088,12 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 
 	might_sleep();
 
-	css_get(&blkcg->css);
+	/*
+	 * If css_tryget() fails, there is no blkg to destroy.
+	 */
+	if (!css_tryget(&blkcg->css))
+		return;
+
 	spin_lock_irq(&blkcg->lock);
 	while (!hlist_empty(&blkcg->blkg_list)) {
 		struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
-- 
2.31.1


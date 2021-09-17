From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.9] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date: Thu, 16 Sep 2021 22:35:08 -0400
Message-ID: <20210917023508.816980-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846110;
        bh=c3XCtVyOOmSN8//YWlQxWHyl3bALKGKJUAe/8BgASdE=;
        h=From:To:Cc:Subject:Date:From;
        b=WW56fg2DEIBXn6QuZKh5v44CDC+eBZrYk+P7TzbcmHtRKAPjrVK526CA3Vo9vRkl/
         d3j8ZZoTHmzw9eIxMn765ZrH275omKrfH+kuDTfXZSIxZTNx/k0QUdsONRqUUD8E/7
         nsckq/HSOwAYlRbLu2Yml9CaH4iDPRwXYv+YLT12dXaNeJEQgY6/fatXsI3My7yHXj
         +EUHkKZ8gZH4bt3jOpMXFClPptbscn2IBT+s3sqmB7LGiKiwIa/STu2TqG9Y4xToG5
         Ki6AZ3g7boIoR2JQL7M62lJ1Rq9LB77z1x+EDqJaktihdL7YXN2rtZXtgWuz97Bmh3
         vKBvx1nauHuOA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit 884f0e84f1e3195b801319c8ec3d5774e9bf2710 ]

The pending timer has been set up in blk_throtl_init(). However, the
timer is not deleted in blk_throtl_exit(). This means that the timer
handler may still be running after freeing the timer, which would
result in a use-after-free.

Fix by calling del_timer_sync() to delete the timer in blk_throtl_exit().

Signed-off-by: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Link: https://lore.kernel.org/r/20210907121242.2885564-1-lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3a4c9a3c1427..6435dc25be0a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1584,6 +1584,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	kfree(q->td);
-- 
2.30.2


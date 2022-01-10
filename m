From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 1/2] blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
Date: Mon, 10 Jan 2022 21:47:57 +0800
Message-ID: <20220110134758.2233758-2-yukuai3@huawei.com>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220110134758.2233758-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to reintroduce tg_drain_bios(), which will iterate until
throtl_rb_first() return NULL.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 39bb6e68a9a2..fdd57878e862 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -502,7 +502,6 @@ throtl_rb_first(struct throtl_service_queue *parent_sq)
 	struct rb_node *n;
 
 	n = rb_first_cached(&parent_sq->pending_tree);
-	WARN_ON_ONCE(!n);
 	if (!n)
 		return NULL;
 	return rb_entry_tg(n);
@@ -521,7 +520,7 @@ static void update_min_dispatch_time(struct throtl_service_queue *parent_sq)
 	struct throtl_grp *tg;
 
 	tg = throtl_rb_first(parent_sq);
-	if (!tg)
+	if (WARN_ON_ONCE(!tg))
 		return;
 
 	parent_sq->first_pending_disptime = tg->disptime;
@@ -1090,7 +1089,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 			break;
 
 		tg = throtl_rb_first(parent_sq);
-		if (!tg)
+		if (WARN_ON_ONCE(!tg))
 			break;
 
 		if (time_before(jiffies, tg->disptime))
-- 
2.31.1


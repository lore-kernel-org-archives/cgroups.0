From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] blk-throtl: don't warn in tg_drain_bios()
Date: Sat, 27 Nov 2021 18:10:57 +0800
Message-ID: <20211127101059.477405-3-yukuai3@huawei.com>
References: <20211127101059.477405-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211127101059.477405-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

tg_drain_bios() will iterate until throtl_rb_first() return NULL,
don't warn in such situation.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 230e300c5856..25822c88bea1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -497,12 +497,13 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 }
 
 static struct throtl_grp *
-throtl_rb_first(struct throtl_service_queue *parent_sq)
+throtl_rb_first(struct throtl_service_queue *parent_sq, bool warn)
 {
 	struct rb_node *n;
 
 	n = rb_first_cached(&parent_sq->pending_tree);
-	WARN_ON_ONCE(!n);
+	if (warn)
+		WARN_ON_ONCE(!n);
 	if (!n)
 		return NULL;
 	return rb_entry_tg(n);
@@ -520,7 +521,7 @@ static void update_min_dispatch_time(struct throtl_service_queue *parent_sq)
 {
 	struct throtl_grp *tg;
 
-	tg = throtl_rb_first(parent_sq);
+	tg = throtl_rb_first(parent_sq, true);
 	if (!tg)
 		return;
 
@@ -1089,7 +1090,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 		if (!parent_sq->nr_pending)
 			break;
 
-		tg = throtl_rb_first(parent_sq);
+		tg = throtl_rb_first(parent_sq, true);
 		if (!tg)
 			break;
 
@@ -2266,7 +2267,7 @@ static void tg_drain_bios(struct throtl_service_queue *parent_sq)
 {
 	struct throtl_grp *tg;
 
-	while ((tg = throtl_rb_first(parent_sq))) {
+	while ((tg = throtl_rb_first(parent_sq, false))) {
 		struct throtl_service_queue *sq = &tg->service_queue;
 		struct bio *bio;
 
-- 
2.31.1


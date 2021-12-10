From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC] block, bfq: update pos_root for idle bfq_queue in bfq_bfqq_move()
Date: Fri, 10 Dec 2021 16:16:41 +0800
Message-ID: <20211210081641.3025060-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

During code review, we found that if bfqq is not busy in
bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
thus bfqq->pos_root still points to the old bfqg. However, the ref
that bfqq hold for the old bfqg will be released, so it's possible
that the old bfqg can be freed. This is problematic because the freed
bfqg can still be accessed by bfqq->pos_root.

Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
as well.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-cgroup.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..85f34c29b909 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -645,6 +645,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		   struct bfq_group *bfqg)
 {
 	struct bfq_entity *entity = &bfqq->entity;
+	struct bfq_group *old_parent = bfqq_group(bfqq);
 
 	/*
 	 * Get extra reference to prevent bfqq from being freed in
@@ -666,7 +667,6 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
 	else if (entity->on_st_or_in_serv)
 		bfq_put_idle_entity(bfq_entity_service_tree(entity), entity);
-	bfqg_and_blkg_put(bfqq_group(bfqq));
 
 	if (entity->parent &&
 	    entity->parent->last_bfqq_created == bfqq)
@@ -679,11 +679,16 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	/* pin down bfqg and its associated blkg  */
 	bfqg_and_blkg_get(bfqg);
 
-	if (bfq_bfqq_busy(bfqq)) {
-		if (unlikely(!bfqd->nonrot_with_queueing))
-			bfq_pos_tree_add_move(bfqd, bfqq);
+	/*
+	 * Don't leave the pos_root to old bfqg, since the ref to old bfqg will
+	 * be released and the bfqg might be freed.
+	 */
+	if (unlikely(!bfqd->nonrot_with_queueing))
+		bfq_pos_tree_add_move(bfqd, bfqq);
+	bfqg_and_blkg_put(old_parent);
+
+	if (bfq_bfqq_busy(bfqq))
 		bfq_activate_bfqq(bfqd, bfqq);
-	}
 
 	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
 		bfq_schedule_dispatch(bfqd);
-- 
2.31.1


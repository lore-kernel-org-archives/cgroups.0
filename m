From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 07/11] block, bfq: only count parent bfqg when bfqq is activated
Date: Sat, 5 Mar 2022 17:12:01 +0800
Message-ID: <20220305091205.4188398-8-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Currently, bfqg will be counted into 'num_groups_with_pending_reqs'
once it's child cgroup is activated, even if the group doesn't have
any pending requests itself.

For example, if we issue sync io in cgroup /root/c1/c2, root, c1 and c2
will all be counted into 'num_groups_with_pending_reqs', which makes it
impossible to handle requests concurrently.

This patch doesn't count the group that doesn't have any pending
requests while it's child group has pending requests.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-wf2q.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 138a2950b841..db066ae35a71 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1123,13 +1123,7 @@ static void bfq_activate_requeue_entity(struct bfq_entity *entity,
 					bool non_blocking_wait_rq,
 					bool requeue, bool expiration)
 {
-	for_each_entity(entity) {
-		bfq_update_groups_with_pending_reqs(entity);
-
-		/* root group is not in service tree */
-		if (is_root_entity(entity))
-			break;
-
+	for_each_entity_not_root(entity) {
 		__bfq_activate_requeue_entity(entity, non_blocking_wait_rq);
 
 		if (!bfq_update_next_in_service(entity->sched_data, entity,
@@ -1640,6 +1634,7 @@ void bfq_activate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 {
 	struct bfq_entity *entity = &bfqq->entity;
 
+	bfq_update_groups_with_pending_reqs(bfqq->entity.parent);
 	bfq_activate_requeue_entity(entity, bfq_bfqq_non_blocking_wait_rq(bfqq),
 				    false, false);
 	bfq_clear_bfqq_non_blocking_wait_rq(bfqq);
-- 
2.31.1


From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next 02/11] block, bfq: apply news apis where root group is not expected
Date: Sat, 5 Mar 2022 17:11:56 +0800
Message-ID: <20220305091205.4188398-3-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

'entity->sched_data' is set to parent group's sched_data, thus it's NULL
for root group. And for_each_entity() is used widely to access
'entity->sched_data', thus aplly news apis if root group is not
expected. Prepare to count root group into 'num_groups_with_pending_reqs'.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c |  2 +-
 block/bfq-iosched.h | 22 ++++++++--------------
 block/bfq-wf2q.c    | 10 +++++-----
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 69ddf6b0f01d..3bc7a7686aad 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4393,7 +4393,7 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
 	 * service with the same budget.
 	 */
 	entity = entity->parent;
-	for_each_entity(entity)
+	for_each_entity_not_root(entity)
 		entity->service = 0;
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index d703492714e2..ddd8eff5c272 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1024,25 +1024,22 @@ extern struct blkcg_policy blkcg_policy_bfq;
 /* - interface of the internal hierarchical B-WF2Q+ scheduler - */
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
-/* both next loops stop at one of the child entities of the root group */
+/* stop at one of the child entities of the root group */
 #define for_each_entity(entity)	\
 	for (; entity ; entity = entity->parent)
 
-/*
- * For each iteration, compute parent in advance, so as to be safe if
- * entity is deallocated during the iteration. Such a deallocation may
- * happen as a consequence of a bfq_put_queue that frees the bfq_queue
- * containing entity.
- */
-#define for_each_entity_safe(entity, parent) \
-	for (; entity && ({ parent = entity->parent; 1; }); entity = parent)
-
 #define is_root_entity(entity) \
 	(entity->sched_data == NULL)
 
 #define for_each_entity_not_root(entity) \
 	for (; entity && !is_root_entity(entity); entity = entity->parent)
 
+/*
+ * For each iteration, compute parent in advance, so as to be safe if
+ * entity is deallocated during the iteration. Such a deallocation may
+ * happen as a consequence of a bfq_put_queue that frees the bfq_queue
+ * containing entity.
+ */
 #define for_each_entity_not_root_safe(entity, parent) \
 	for (; entity && !is_root_entity(entity) && \
 	       ({ parent = entity->parent; 1; }); entity = parent)
@@ -1050,16 +1047,13 @@ extern struct blkcg_policy blkcg_policy_bfq;
 #define is_root_entity(entity) (false)
 
 /*
- * Next four macros are fake loops when cgroups support is not
+ * Next three macros are fake loops when cgroups support is not
  * enabled. I fact, in such a case, there is only one level to go up
  * (to reach the root group).
  */
 #define for_each_entity(entity)	\
 	for (; entity ; entity = NULL)
 
-#define for_each_entity_safe(entity, parent) \
-	for (parent = NULL; entity ; entity = parent)
-
 #define for_each_entity_not_root(entity) \
 	for (; entity ; entity = NULL)
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index f8eb340381cf..c4cb935a615a 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -815,7 +815,7 @@ void bfq_bfqq_served(struct bfq_queue *bfqq, int served)
 		bfqq->service_from_wr += served;
 
 	bfqq->service_from_backlogged += served;
-	for_each_entity(entity) {
+	for_each_entity_not_root(entity) {
 		st = bfq_entity_service_tree(entity);
 
 		entity->service += served;
@@ -1201,7 +1201,7 @@ static void bfq_deactivate_entity(struct bfq_entity *entity,
 	struct bfq_sched_data *sd;
 	struct bfq_entity *parent = NULL;
 
-	for_each_entity_safe(entity, parent) {
+	for_each_entity_not_root_safe(entity, parent) {
 		sd = entity->sched_data;
 
 		if (!__bfq_deactivate_entity(entity, ins_into_idle_tree)) {
@@ -1270,7 +1270,7 @@ static void bfq_deactivate_entity(struct bfq_entity *entity,
 	 * is not the case.
 	 */
 	entity = parent;
-	for_each_entity(entity) {
+	for_each_entity_not_root(entity) {
 		/*
 		 * Invoke __bfq_requeue_entity on entity, even if
 		 * already active, to requeue/reposition it in the
@@ -1570,7 +1570,7 @@ struct bfq_queue *bfq_get_next_queue(struct bfq_data *bfqd)
 	 * We can finally update all next-to-serve entities along the
 	 * path from the leaf entity just set in service to the root.
 	 */
-	for_each_entity(entity) {
+	for_each_entity_not_root(entity) {
 		struct bfq_sched_data *sd = entity->sched_data;
 
 		if (!bfq_update_next_in_service(sd, NULL, false))
@@ -1597,7 +1597,7 @@ bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
 	 * execute the final step: reset in_service_entity along the
 	 * path from entity to the root.
 	 */
-	for_each_entity(entity)
+	for_each_entity_not_root(entity)
 		entity->sched_data->in_service_entity = NULL;
 
 	/*
-- 
2.31.1


From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH RFC 1/9] block, bfq: add new apis to iterate bfq entities
Date: Sat, 27 Nov 2021 18:11:24 +0800
Message-ID: <20211127101132.486806-2-yukuai3@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211127101132.486806-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

The old and the new apis are the same currently, prepare to count
root group into 'num_groups_with_pending_reqs'. The old apis will be
used to iterate with root group's entity, and the new apis will be
used to iterate without root group's entity.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index a73488eec8a4..f5afc80ff11c 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1034,9 +1034,20 @@ extern struct blkcg_policy blkcg_policy_bfq;
 #define for_each_entity_safe(entity, parent) \
 	for (; entity && ({ parent = entity->parent; 1; }); entity = parent)
 
+#define is_root_entity(entity) \
+	(entity->sched_data == NULL)
+
+#define for_each_entity_not_root(entity) \
+	for (; entity && !is_root_entity(entity); entity = entity->parent)
+
+#define for_each_entity_not_root_safe(entity, parent) \
+	for (; entity && !is_root_entity(entity) && \
+	       ({ parent = entity->parent; 1; }); entity = parent)
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
+#define is_root_entity(entity) (false)
+
 /*
- * Next two macros are fake loops when cgroups support is not
+ * Next four macros are fake loops when cgroups support is not
  * enabled. I fact, in such a case, there is only one level to go up
  * (to reach the root group).
  */
@@ -1045,6 +1056,12 @@ extern struct blkcg_policy blkcg_policy_bfq;
 
 #define for_each_entity_safe(entity, parent) \
 	for (parent = NULL; entity ; entity = parent)
+
+#define for_each_entity_not_root(entity) \
+	for (; entity ; entity = NULL)
+
+#define for_each_entity_not_root_safe(entity, parent) \
+	for (parent = NULL; entity ; entity = parent)
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
 struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq);
-- 
2.31.1


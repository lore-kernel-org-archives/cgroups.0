From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 01/11] block, bfq: add new apis to iterate bfq entities
Date: Sat, 5 Mar 2022 17:11:55 +0800
Message-ID: <20220305091205.4188398-2-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The old and the new apis are the same currently, prepare to count
root group into 'num_groups_with_pending_reqs'. The old apis will be
used to iterate with root group's entity, and the new apis will be
used to iterate without root group's entity.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 3b83e3d1c2e5..d703492714e2 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1037,9 +1037,20 @@ extern struct blkcg_policy blkcg_policy_bfq;
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
@@ -1048,6 +1059,12 @@ extern struct blkcg_policy blkcg_policy_bfq;
 
 #define for_each_entity_safe(entity, parent) \
 	for (parent = NULL; entity ; entity = parent)
+
+#define for_each_entity_not_root(entity) \
+	for (; entity ; entity = NULL)
+
+#define for_each_entity_not_root_safe(entity, parent) \
+	for (parent = NULL; entity ; entity = parent)
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
 struct bfq_queue *bfq_entity_to_bfqq(struct bfq_entity *entity);
-- 
2.31.1


From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 4/9] block, bfq: count root group into 'num_groups_with_pending_reqs'
Date: Sat, 27 Nov 2021 18:11:27 +0800
Message-ID: <20211127101132.486806-5-yukuai3@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Root group is not counted into 'num_groups_with_pending_reqs' because
'entity->parent' is set to NULL for child entities, thus
for_each_entity() can't access root group.

This patch set root_group's entity to 'entity->parent' for child
entities, It's okay with previous patches handle the case that
for_each_entity() access root group.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..9c36deda4ed4 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -436,7 +436,7 @@ void bfq_init_entity(struct bfq_entity *entity, struct bfq_group *bfqg)
 		 */
 		bfqg_and_blkg_get(bfqg);
 	}
-	entity->parent = bfqg->my_entity; /* NULL for root group */
+	entity->parent = &bfqg->entity;
 	entity->sched_data = &bfqg->sched_data;
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index ef875b8046e5..515eb2604a37 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1021,13 +1021,14 @@ extern struct blkcg_policy blkcg_policy_bfq;
 /* - interface of the internal hierarchical B-WF2Q+ scheduler - */
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
-/* stop at one of the child entities of the root group */
+/* stop at root group */
 #define for_each_entity(entity)	\
 	for (; entity ; entity = entity->parent)
 
 #define is_root_entity(entity) \
 	(entity->sched_data == NULL)
 
+/* stop at one of the child entities of the root group */
 #define for_each_entity_not_root(entity) \
 	for (; entity && !is_root_entity(entity); entity = entity->parent)
 
-- 
2.31.1


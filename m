From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 1/8] bfq: introduce bfq_entity_to_bfqg helper method
Date: Mon,  8 Mar 2021 20:00:14 +0800
Message-ID: <59c86d37fef3075827b0884ec3dbdc56d527366a.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=7aU87TbOL7pa/4cYXaJm7aQaYa0MM5avjjv9F0ZkTmY=;
        b=dYtvszeRqI7T2FE/C3qFppUXDuCb7TMCBlM9TqdHbR38e19zwlqSpW62ROXQd/TwXc
         QVEDLWSR2c16Doax47Fnkv+l61iFzX8SOIHjlI5eQldKFsaj1WqDQ+B1IEuRDEz50J84
         DVhxn4yo1gdG+8CMuVQz/SIA6lC1fzGwr9OnvR9P/rcjeWurz400cypgySNgc2+kL1bJ
         n2SOD9WVNfVRHYtQBSqAdp43+Ai+Tv2fGtemXFTgQF1liLg7s/WmABJU389gBbMrNsy4
         gAYe+/PfHVZ3QO+i0DG1QEDR4lTEz+RhwRAQHCA5TdpHJocPi7hbEULVwLUWZ1WNM03K
         axqg==
In-Reply-To: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Introduce bfq_entity_to_bfqg() to make it easier to obtain the
bfq_group corresponding to the entity.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-cgroup.c  |  6 ++----
 block/bfq-iosched.h |  1 +
 block/bfq-wf2q.c    | 16 ++++++++++++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index b791e2041e49..a5f544acaa61 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -309,8 +309,7 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
 {
 	struct bfq_entity *group_entity = bfqq->entity.parent;
 
-	return group_entity ? container_of(group_entity, struct bfq_group,
-					   entity) :
+	return group_entity ? bfq_entity_to_bfqg(group_entity) :
 			      bfqq->bfqd->root_group;
 }
 
@@ -610,8 +609,7 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
 	 */
 	entity = &bfqg->entity;
 	for_each_entity(entity) {
-		struct bfq_group *curr_bfqg = container_of(entity,
-						struct bfq_group, entity);
+		struct bfq_group *curr_bfqg = bfq_entity_to_bfqg(entity);
 		if (curr_bfqg != bfqd->root_group) {
 			parent = bfqg_parent(curr_bfqg);
 			if (!parent)
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index b8e793c34ff1..a6f98e9e14b5 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -941,6 +941,7 @@ struct bfq_group {
 #endif
 
 struct bfq_queue *bfq_entity_to_bfqq(struct bfq_entity *entity);
+struct bfq_group *bfq_entity_to_bfqg(struct bfq_entity *entity);
 
 /* --------------- main algorithm interface ----------------- */
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 070e34a7feb1..5ff0028920a2 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -149,7 +149,7 @@ struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq)
 	if (!group_entity)
 		group_entity = &bfqq->bfqd->root_group->entity;
 
-	return container_of(group_entity, struct bfq_group, entity);
+	return bfq_entity_to_bfqg(group_entity);
 }
 
 /*
@@ -208,7 +208,7 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	if (bfq_entity_to_bfqq(entity))
 		return true;
 
-	bfqg = container_of(entity, struct bfq_group, entity);
+	bfqg = bfq_entity_to_bfqg(entity);
 
 	/*
 	 * The field active_entities does not always contain the
@@ -266,6 +266,15 @@ struct bfq_queue *bfq_entity_to_bfqq(struct bfq_entity *entity)
 	return bfqq;
 }
 
+struct bfq_group *bfq_entity_to_bfqg(struct bfq_entity *entity)
+{
+	struct bfq_group *bfqg = NULL;
+
+	if (entity->my_sched_data)
+		bfqg = container_of(entity, struct bfq_group, entity);
+
+	return bfqg;
+}
 
 /**
  * bfq_delta - map service into the virtual time domain.
@@ -1001,8 +1010,7 @@ static void __bfq_activate_entity(struct bfq_entity *entity,
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 	if (!bfq_entity_to_bfqq(entity)) { /* bfq_group */
-		struct bfq_group *bfqg =
-			container_of(entity, struct bfq_group, entity);
+		struct bfq_group *bfqg = bfq_entity_to_bfqg(entity);
 		struct bfq_data *bfqd = bfqg->bfqd;
 
 		if (!entity->in_groups_with_pending_reqs) {
-- 
2.30.0


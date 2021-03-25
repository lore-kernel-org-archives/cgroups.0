From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 06/14] bfq: keep the minimun bandwidth for CLASS_BE
Date: Thu, 25 Mar 2021 14:57:50 +0800
Message-ID: <bc39271c5f3835e4782c7ecd53fb205aa9cc97a0.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=bSZL7kirn3ytucnGGJSGBi1K6j7tN0mB+xwGax7QE0Y=;
        b=cmCca1wwq8zjRNpdjae2qHgjfPHbVBjdywuM1tOtPlKfMmzaZnxQ6e3GVwbKNJKaVT
         Up55cWUaqfRohYZpnnlbJbT3JLf4zHGk56fPXxhCmyS3TJARXxFLeyInbRH0oQWftz2+
         2q8tZg/mGjCTy7PlPRPJxGWMIm7468fkAZzq3yRDy2vBZJVcvbiLkYJncyF4WC4DXBv/
         MwNXuSlodHn9mqrCmRmzFnJyblv6HMM6TSXx5a2WlXn1eYZQERxNEg2YLpsTSzxJzsJA
         TqWVPe7cYuJG81gU4BGDXafywDXxaxFKHaTm/jwkKa8Pa+vCtnl2yLlw+KneN1vaz86L
         EARg==
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

CLASS_RT will preempt other classes, which may starve. At
present, CLASS_IDLE has alleviated the starvation problem
through the minimum bandwidth mechanism. Similarly, we
should do the same for CLASS_BE.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-iosched.c |  6 ++++--
 block/bfq-iosched.h | 11 ++++++----
 block/bfq-wf2q.c    | 59 ++++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 8eaf0eb..ee8c457 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6560,9 +6560,11 @@ static void bfq_init_root_group(struct bfq_group *root_group,
 	root_group->bfqd = bfqd;
 #endif
 	root_group->rq_pos_tree = RB_ROOT;
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++)
+	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++) {
 		root_group->sched_data.service_tree[i] = BFQ_SERVICE_TREE_INIT;
-	root_group->sched_data.bfq_class_idle_last_service = jiffies;
+		root_group->sched_data.bfq_class_last_service[i] = jiffies;
+	}
+	root_group->sched_data.class_timeout_last_check = jiffies;
 }
 
 static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 29a56b8..f9ed1da 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -13,7 +13,7 @@
 #include "blk-cgroup-rwstat.h"
 
 #define BFQ_IOPRIO_CLASSES	3
-#define BFQ_CL_IDLE_TIMEOUT	(HZ/5)
+#define BFQ_CLASS_TIMEOUT	(HZ/5)
 
 #define BFQ_MIN_WEIGHT			1
 #define BFQ_MAX_WEIGHT			1000
@@ -97,9 +97,12 @@ struct bfq_sched_data {
 	struct bfq_entity *next_in_service;
 	/* array of service trees, one per ioprio_class */
 	struct bfq_service_tree service_tree[BFQ_IOPRIO_CLASSES];
-	/* last time CLASS_IDLE was served */
-	unsigned long bfq_class_idle_last_service;
-
+	/* last time the class was served */
+	unsigned long bfq_class_last_service[BFQ_IOPRIO_CLASSES];
+	/* last time class timeout was checked */
+	unsigned long class_timeout_last_check;
+	/* next index to check class timeout */
+	unsigned int next_class_index;
 };
 
 /**
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index c91109e..1f8f3c5 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1188,6 +1188,7 @@ bool __bfq_deactivate_entity(struct bfq_entity *entity, bool ins_into_idle_tree)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_service_tree *st;
+	int idx = bfq_class_idx(entity);
 	bool is_in_service;
 
 	if (!entity->on_st_or_in_serv) /*
@@ -1227,6 +1228,7 @@ bool __bfq_deactivate_entity(struct bfq_entity *entity, bool ins_into_idle_tree)
 	else
 		bfq_idle_insert(st, entity);
 
+	sd->bfq_class_last_service[idx] = jiffies;
 	return true;
 }
 
@@ -1455,6 +1457,45 @@ static struct bfq_entity *bfq_first_active_entity(struct bfq_service_tree *st,
 	return entity;
 }
 
+static int bfq_select_next_class(struct bfq_sched_data *sd)
+{
+	struct bfq_service_tree *st = sd->service_tree;
+	unsigned long last_check, last_serve;
+	int i, class_idx, next_class = 0;
+	bool found = false;
+
+	/*
+	 * we needed to guarantee a minimum bandwidth for each class (if
+	 * there is some active entity in this class). This should also
+	 * mitigate priority-inversion problems in case a low priority
+	 * task is holding file system resources.
+	 */
+	last_check = sd->class_timeout_last_check;
+	if (time_is_after_jiffies(last_check + BFQ_CLASS_TIMEOUT))
+		return next_class;
+
+	sd->class_timeout_last_check = jiffies;
+	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++) {
+		class_idx = (sd->next_class_index + i) % BFQ_IOPRIO_CLASSES;
+		last_serve = sd->bfq_class_last_service[class_idx];
+
+		if (time_is_after_jiffies(last_serve + BFQ_CLASS_TIMEOUT))
+			continue;
+
+		if (!RB_EMPTY_ROOT(&(st + class_idx)->active)) {
+			if (found)
+				continue;
+
+			next_class = class_idx++;
+			class_idx %= BFQ_IOPRIO_CLASSES;
+			sd->next_class_index = class_idx;
+			found = true;
+		}
+		sd->bfq_class_last_service[class_idx] = jiffies;
+	}
+	return next_class;
+}
+
 /**
  * bfq_lookup_next_entity - return the first eligible entity in @sd.
  * @sd: the sched_data.
@@ -1468,24 +1509,8 @@ static struct bfq_entity *bfq_lookup_next_entity(struct bfq_sched_data *sd,
 						 bool expiration)
 {
 	struct bfq_service_tree *st = sd->service_tree;
-	struct bfq_service_tree *idle_class_st = st + (BFQ_IOPRIO_CLASSES - 1);
 	struct bfq_entity *entity = NULL;
-	int class_idx = 0;
-
-	/*
-	 * Choose from idle class, if needed to guarantee a minimum
-	 * bandwidth to this class (and if there is some active entity
-	 * in idle class). This should also mitigate
-	 * priority-inversion problems in case a low priority task is
-	 * holding file system resources.
-	 */
-	if (time_is_before_jiffies(sd->bfq_class_idle_last_service +
-				   BFQ_CL_IDLE_TIMEOUT)) {
-		if (!RB_EMPTY_ROOT(&idle_class_st->active))
-			class_idx = BFQ_IOPRIO_CLASSES - 1;
-		/* About to be served if backlogged, or not yet backlogged */
-		sd->bfq_class_idle_last_service = jiffies;
-	}
+	int class_idx = bfq_select_next_class(sd);
 
 	/*
 	 * Find the next entity to serve for the highest-priority
-- 
1.8.3.1


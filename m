From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 04/14] bfq: introduce bfq_ioprio_class to get ioprio class
Date: Thu, 25 Mar 2021 14:57:48 +0800
Message-ID: <fd37b831bf65c2048047441ffeacd3494ab73224.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=hPH8DsECt5xnwFiwZHAUQb2WmzQbShnA545eG6/RNz0=;
        b=pMLWKUf1N40MVt0ryRnco5Yj9BGvy7Ncfvog0V1iIoT0pvsd7aHSkYh9c23lQRGTPt
         /Mu3GQo43nXXR+5WbJL3d9+ocRfBun29XfCLAHOzWzhkg/2eD/uVqiaJ5yFbS1ExerNO
         rbQ4AcH18A1zNagwBlVS6/fFFs5DcX3uRZee8xyVOHgVpngsi0Y4nwwdpEbeHCcXwnl0
         Js8hfcpxKnZgfgDPj3GDuYTT05Q7o4r5bg7iOCoqUw4ammVL6UTzdsTtImFgfwgwOxgc
         w8QNYfIWT5WzrmcHmVJLIyXjrCPhNJA1HkjFGIyWJzRuRskIedLtmtTTOZcwxUCaNxxT
         GNAA==
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Since the tasks inside the container itself have different
ioprio, in order to be compatible with the actual production
environment, when scheduling within a group, we use the task
ioprio class, but outside the group, we use the group ioprio
class. For example, when counting busy_queues, tasks from
the CLASS_IDLE group, regardless of their ioprio, are always
treated as CLASS_IDLE tasks.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-iosched.c | 29 ++++++++++++++++++++++++++---
 block/bfq-iosched.h |  1 +
 block/bfq-wf2q.c    |  4 ++--
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ec482e6..5f7a0cc 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -428,7 +428,30 @@ void bfq_schedule_dispatch(struct bfq_data *bfqd)
 	}
 }
 
-#define bfq_class_idle(bfqq)	((bfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
+unsigned short bfq_ioprio_class(struct bfq_entity *entity)
+{
+	struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
+	unsigned short class = BFQ_DEFAULT_GRP_CLASS;
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	struct bfq_group *bfqg;
+
+	if (bfqq) {
+		bfqg = bfqq_group(bfqq);
+		class = bfqg->ioprio_class?:bfqq->ioprio_class;
+	} else {
+		bfqg = bfq_entity_to_bfqg(entity);
+		class = bfqg->ioprio_class?:BFQ_DEFAULT_GRP_CLASS;
+	}
+#else
+	if (bfqq)
+		class = bfqq->ioprio_class;
+#endif
+	return class;
+}
+
+#define bfq_class(bfq)		(bfq_ioprio_class(&bfq->entity))
+#define bfq_class_rt(bfq)	(bfq_ioprio_class(&bfq->entity) == IOPRIO_CLASS_RT)
+#define bfq_class_idle(bfq)	(bfq_ioprio_class(&bfq->entity) == IOPRIO_CLASS_IDLE)
 
 #define bfq_sample_valid(samples)	((samples) > 80)
 
@@ -1635,7 +1658,7 @@ static bool bfq_bfqq_higher_class_or_weight(struct bfq_queue *bfqq,
 {
 	int bfqq_weight, in_serv_weight;
 
-	if (bfqq->ioprio_class < in_serv_bfqq->ioprio_class)
+	if (bfq_class(bfqq) < bfq_class(in_serv_bfqq))
 		return true;
 
 	if (in_serv_bfqq->entity.parent == bfqq->entity.parent) {
@@ -2600,7 +2623,7 @@ static bool bfq_may_be_close_cooperator(struct bfq_queue *bfqq,
 		return false;
 
 	if (bfq_class_idle(bfqq) || bfq_class_idle(new_bfqq) ||
-	    (bfqq->ioprio_class != new_bfqq->ioprio_class))
+	    (bfq_class(bfqq) != bfq_class(new_bfqq)))
 		return false;
 
 	/*
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 3416a75..29a56b8 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1071,6 +1071,7 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		       bool expiration);
 void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq);
+unsigned short bfq_ioprio_class(struct bfq_entity *entity);
 
 /* --------------- end of interface of B-WF2Q+ ---------------- */
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 7405be9..c91109e 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1702,7 +1702,7 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	bfq_clear_bfqq_busy(bfqq);
 
-	bfqd->busy_queues[bfqq->ioprio_class - 1]--;
+	bfqd->busy_queues[bfq_ioprio_class(&bfqq->entity) - 1]--;
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues--;
@@ -1725,7 +1725,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_activate_bfqq(bfqd, bfqq);
 
 	bfq_mark_bfqq_busy(bfqq);
-	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
+	bfqd->busy_queues[bfq_ioprio_class(&bfqq->entity) - 1]++;
 
 	if (!bfqq->dispatched)
 		if (bfqq->wr_coeff == 1)
-- 
1.8.3.1


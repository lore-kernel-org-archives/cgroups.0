From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 03/12] blkcg: convert blkg_lookup_create to find closest blkg
Date: Thu,  6 Sep 2018 17:10:36 -0400
Message-ID: <20180906211045.29055-4-dennisszhou@gmail.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GsrSo3YYCaTDgNImQTvjTcK+H+77PIQv1o+ghf7Ahqs=;
        b=QmBKY0NdXoF0ARRChPUg4DTo5DQZXZvHuL/dbTpZ2cJUeglw3itd1ywwtni2pmAHzU
         iA0O/kaqWA+ohPhxgl+U1HjPWhVdjQYSyu895+JVCcqD9AeE4+N/uayJcfsB9wYA5be4
         Il9ln3ho2OI4glGXLIbDvSfjoZfjjcc9qO09qTAZFwgEevO2mOHkfmp7QbkylSEwhClg
         tYfUVmsQwRQcwiHn6aI3CTyiBkoxCMqZ3alYv6FT5wsMJEM59lVkBDgP/NOa9j4P9SI+
         LPh0SXWA8LL39N8HPlsl3ND9wmcZWCN6N+Hb3+oTi2SRwtLmcVTIVbrQmLMtG6A2tBei
         ywzA==
In-Reply-To: <20180906211045.29055-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

There are several scenarios where blkg_lookup_create can fail. Examples
include the blkcg dying, request_queue is dying, or simply being OOM. At
the end of the day, most handle this by simply falling back to the
q->root_blkg and calling it a day.

This patch implements the notion of closest blkg. During
blkg_lookup_create, if it fails to create, return the closest blkg
found or the q->root_blkg. blkg_try_get_closest is introduced and used
during association so a bio is always attached to a blkg.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 block/bio.c                |  4 +---
 block/blk-cgroup.c         | 22 +++++++++++++++-------
 include/linux/blk-cgroup.h | 14 ++++++++++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 91c6b1458454..cd947ad4cf08 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2021,9 +2021,7 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
 	if (unlikely(bio->bi_blkg))
 		return -EBUSY;
-	if (!blkg_try_get(blkg))
-		return -ENODEV;
-	bio->bi_blkg = blkg;
+	bio->bi_blkg = blkg_try_get_closest(blkg);
 	return 0;
 }
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cd0d97bed83d..9f8aba29b7c1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -268,9 +268,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
  * that all non-root blkg's have access to the parent blkg.  This function
  * should be called under RCU read lock and @q->queue_lock.
  *
- * Returns pointer to the looked up or created blkg on success, ERR_PTR()
- * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
- * dead and bypassing, returns ERR_PTR(-EBUSY).
+ * Returns the blkg or the closest blkg if blkg_create fails as it walks
+ * down from root.
  */
 struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 				      struct request_queue *q)
@@ -285,7 +284,7 @@ struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	 * we shouldn't allow anything to go through for a bypassing queue.
 	 */
 	if (unlikely(blk_queue_bypass(q)))
-		return ERR_PTR(blk_queue_dying(q) ? -ENODEV : -EBUSY);
+		return q->root_blkg;
 
 	blkg = __blkg_lookup(blkcg, q, true);
 	if (blkg)
@@ -298,14 +297,23 @@ struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	while (true) {
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent = blkcg_parent(blkcg);
-
-		while (parent && !__blkg_lookup(parent, q, false)) {
+		struct blkcg_gq *ret_blkg = NULL;
+
+		while (parent) {
+			blkg = __blkg_lookup(parent, q, false);
+			if (blkg) {
+				/* remember closest blkg */
+				ret_blkg = blkg;
+				break;
+			}
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
 
 		blkg = blkg_create(pos, q, NULL);
-		if (pos == blkcg || IS_ERR(blkg))
+		if (IS_ERR(blkg))
+			return ret_blkg ?: q->root_blkg;
+		if (pos == blkcg)
 			return blkg;
 	}
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index cc0f238530f6..1fbff1bbb651 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -549,6 +549,20 @@ static inline struct blkcg_gq *blkg_try_get(struct blkcg_gq *blkg)
 	return NULL;
 }
 
+/**
+ * blkg_try_get_closest - try and get a blkg ref on the closet blkg
+ * @blkg: blkg to get
+ *
+ * This walks up the blkg tree to find the closest non-dying blkg and returns
+ * the blkg that it did association with as it may not be the passed in blkg.
+ */
+static inline struct blkcg_gq *blkg_try_get_closest(struct blkcg_gq *blkg)
+{
+	while (!atomic_inc_not_zero(&blkg->refcnt))
+		blkg = blkg->parent;
+
+	return blkg;
+}
 
 void __blkg_release_rcu(struct rcu_head *rcu);
 
-- 
2.17.1


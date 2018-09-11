From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 03/12] blkcg: convert blkg_lookup_create to find closest blkg
Date: Tue, 11 Sep 2018 14:41:28 -0400
Message-ID: <20180911184137.35897-4-dennisszhou@gmail.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0vFvSHzEg8C5aAk8MUn2HD/7B9Z1ZlOCDdmp1KeTvd0=;
        b=By7vpYN5SSFvh9S236XgvWLLPWN69zPWXl78tdPTVfQLdiOR8NXC1hauzGbN3WhaTG
         hM4ilN8GhwkkRSk10Lyf6XsJbs91J/BWivdQDesdPsEwS/xtvjHRDDenfGQJUlfefUWZ
         LGqDl2XlzQ/ZWZC/18n4QIZoAKPKCnWYGeO5fWps1ZYA2BnNFTAbZn0WiNGzxmPB7L0f
         8ra+5pBWbqB/oexvBStmAdOv3PeMsiKCD4vuFEofEe4sMB3o4QLWorFZomYZlyLftEZa
         MUrJArYE8XEjRpi5j9LlfspbFuXU4NdGghZUJZYhyIdcOazTTg8qqgmPa9utze8PYu51
         fQOg==
In-Reply-To: <20180911184137.35897-1-dennisszhou@gmail.com>
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
 block/bio.c                | 17 ++++++++++-------
 block/blk-cgroup.c         | 25 +++++++++++++++++--------
 include/linux/blk-cgroup.h | 14 ++++++++++++++
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6ca4dda481ca..49a28abd9772 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2008,21 +2008,24 @@ int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
 EXPORT_SYMBOL_GPL(bio_associate_blkcg);
 
 /**
- * bio_associate_blkg - associate a bio with the specified blkg
+ * bio_associate_blkg - associate a bio with the a blkg
  * @bio: target bio
  * @blkg: the blkg to associate
  *
- * Associate @bio with the blkg specified by @blkg.  This is the queue specific
- * blkcg information associated with the @bio, a reference will be taken on the
- * @blkg and will be freed when the bio is freed.
+ * This tries to associate @bio with the specified blkg.  Association failure
+ * is handled by walking up the blkg tree.  Therefore, the blkg associated can
+ * be anything between @blkg and the root_blkg.  This situation only happens
+ * when a cgroup is dying and then the remaining bios will spill to the closest
+ * alive blkg.
+ *
+ * A reference will be taken on the @blkg and will be released when @bio is
+ * freed.
  */
 int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
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
index cd0d97bed83d..e9e3a955f61a 100644
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
@@ -293,19 +292,29 @@ struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
-	 * non-root blkgs have access to their parents.
+	 * non-root blkgs have access to their parents.  Returns the closest
+	 * blkg to the intended blkg should blkg_create() fail.
 	 */
 	while (true) {
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent = blkcg_parent(blkcg);
-
-		while (parent && !__blkg_lookup(parent, q, false)) {
+		struct blkcg_gq *ret_blkg = q->root_blkg;
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
+			return ret_blkg;
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


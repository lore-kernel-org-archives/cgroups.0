From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 03/13] blkcg: convert blkg_lookup_create() to find closest blkg
Date: Mon, 26 Nov 2018 16:19:36 -0500
Message-ID: <20181126211946.77067-4-dennis@kernel.org>
References: <20181126211946.77067-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126211946.77067-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

There are several scenarios where blkg_lookup_create() can fail such as
the blkcg dying, request_queue is dying, or simply being OOM. Most
handle this by simply falling back to the q->root_blkg and calling it a
day.

This patch implements the notion of closest blkg. During
blkg_lookup_create(), if it fails to create, return the closest blkg
found or the q->root_blkg. blkg_try_get_closest() is introduced and used
during association so a bio is always attached to a blkg.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c                | 17 ++++++++++-------
 block/blk-cgroup.c         | 23 ++++++++++++++++-------
 block/blk-iolatency.c      | 14 ++------------
 block/blk-throttle.c       |  4 +---
 include/linux/blk-cgroup.h | 24 +++++++++++++++---------
 5 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7528c2324319..edc8a73b98d5 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2009,21 +2009,24 @@ int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
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
+ * This tries to associate @bio with the specified @blkg.  Association failure
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
index b1ec98eeeae0..dfd984bbed27 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -258,9 +258,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
  * that all non-root blkg's have access to the parent blkg.  This function
  * should be called under RCU read lock and @q->queue_lock.
  *
- * Returns pointer to the looked up or created blkg on success, ERR_PTR()
- * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
- * dead and bypassing, returns ERR_PTR(-EBUSY).
+ * Returns the blkg or the closest blkg if blkg_create() fails as it walks
+ * down from root.
  */
 struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 				      struct request_queue *q)
@@ -276,19 +275,29 @@ struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 
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
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index e6f68f15dee9..46e86c34cf79 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -483,21 +483,11 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 	rcu_read_lock();
 	bio_associate_blkcg(bio, NULL);
 	blkcg = bio_blkcg(bio);
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(!blkg)) {
-		spin_lock_irq(&q->queue_lock);
-		blkg = __blkg_lookup_create(blkcg, q);
-		if (IS_ERR(blkg))
-			blkg = NULL;
-		spin_unlock_irq(&q->queue_lock);
-	}
-	if (!blkg)
-		goto out;
-
+	blkg = blkg_lookup_create(blkcg, q);
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 	bio_associate_blkg(bio, blkg);
-out:
 	rcu_read_unlock();
+
 	while (blkg && blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg);
 		if (!iolat) {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8f0a104770ee..d648d6720f46 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2118,9 +2118,7 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 static void blk_throtl_assoc_bio(struct throtl_grp *tg, struct bio *bio)
 {
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	/* fallback to root_blkg if we fail to get a blkg ref */
-	if (bio->bi_css && (bio_associate_blkg(bio, tg_to_blkg(tg)) == -ENODEV))
-		bio_associate_blkg(bio, bio->bi_disk->queue->root_blkg);
+	bio_associate_blkg(bio, tg_to_blkg(tg));
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 #endif
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 49f399cfb0b6..9d796a4f8ef0 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -545,6 +545,20 @@ static inline struct blkcg_gq *blkg_try_get(struct blkcg_gq *blkg)
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
 
@@ -797,15 +811,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	/* associate blkcg if bio hasn't attached one */
 	bio_associate_blkcg(bio, NULL);
 	blkcg = bio_blkcg(bio);
-
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(!blkg)) {
-		spin_lock_irq(&q->queue_lock);
-		blkg = __blkg_lookup_create(blkcg, q);
-		if (IS_ERR(blkg))
-			blkg = NULL;
-		spin_unlock_irq(&q->queue_lock);
-	}
+	blkg = blkg_lookup_create(blkcg, q);
 
 	throtl = blk_throtl_bio(q, blkg, bio);
 
-- 
2.17.1


From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 04/14] blkcg: introduce common blkg association logic
Date: Wed,  5 Dec 2018 12:10:29 -0500
Message-ID: <20181205171039.73066-5-dennis@kernel.org>
References: <20181205171039.73066-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205171039.73066-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

There are 3 ways blkg association can happen: association with the
current css, with the page css (swap), or from the wbc css (writeback).

This patch handles how association is done for the first case where we
are associating bsaed on the current css. If there is already a blkg
associated, the css will be reused and association will be redone as the
request_queue may have changed.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c           | 62 ++++++++++++++++++++++++++++++++++++-------
 block/blk-iolatency.c | 10 ++-----
 block/blk-throttle.c  |  6 ++---
 include/linux/bio.h   |  5 +++-
 4 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5c9828524adc..452b8e79b998 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2009,7 +2009,21 @@ int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
 EXPORT_SYMBOL_GPL(bio_associate_blkcg);
 
 /**
- * bio_associate_blkg - associate a bio with the a blkg
+ * bio_disassociate_blkg - puts back the blkg reference if associated
+ * @bio: target bio
+ *
+ * Helper to disassociate the blkg from @bio if a blkg is associated.
+ */
+void bio_disassociate_blkg(struct bio *bio)
+{
+	if (bio->bi_blkg) {
+		blkg_put(bio->bi_blkg);
+		bio->bi_blkg = NULL;
+	}
+}
+
+/**
+ * __bio_associate_blkg - associate a bio with the a blkg
  * @bio: target bio
  * @blkg: the blkg to associate
  *
@@ -2022,12 +2036,42 @@ EXPORT_SYMBOL_GPL(bio_associate_blkcg);
  * A reference will be taken on the @blkg and will be released when @bio is
  * freed.
  */
-int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
+static void __bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
-	if (unlikely(bio->bi_blkg))
-		return -EBUSY;
+	bio_disassociate_blkg(bio);
+
 	bio->bi_blkg = blkg_try_get_closest(blkg);
-	return 0;
+}
+
+/**
+ * bio_associate_blkg - associate a bio with a blkg
+ * @bio: target bio
+ *
+ * Associate @bio with the blkg found from the bio's css and request_queue.
+ * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
+ * already associated, the css is reused and association redone as the
+ * request_queue may have changed.
+ */
+void bio_associate_blkg(struct bio *bio)
+{
+	struct request_queue *q = bio->bi_disk->queue;
+	struct blkcg *blkcg;
+	struct blkcg_gq *blkg;
+
+	rcu_read_lock();
+
+	bio_associate_blkcg(bio, NULL);
+	blkcg = bio_blkcg(bio);
+
+	if (!blkcg->css.parent) {
+		__bio_associate_blkg(bio, q->root_blkg);
+	} else {
+		blkg = blkg_lookup_create(blkcg, q);
+
+		__bio_associate_blkg(bio, blkg);
+	}
+
+	rcu_read_unlock();
 }
 
 /**
@@ -2040,10 +2084,7 @@ void bio_disassociate_task(struct bio *bio)
 		css_put(bio->bi_css);
 		bio->bi_css = NULL;
 	}
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
+	bio_disassociate_blkg(bio);
 }
 
 /**
@@ -2055,6 +2096,9 @@ void bio_clone_blkcg_association(struct bio *dst, struct bio *src)
 {
 	if (src->bi_css)
 		WARN_ON(bio_associate_blkcg(dst, src->bi_css));
+
+	if (src->bi_blkg)
+		__bio_associate_blkg(dst, src->bi_blkg);
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
 #endif /* CONFIG_BLK_CGROUP */
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 46e86c34cf79..cdbd10564e66 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -472,21 +472,15 @@ static void check_scale_change(struct iolatency_grp *iolat)
 static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 {
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
-	struct blkcg *blkcg;
 	struct blkcg_gq *blkg;
-	struct request_queue *q = rqos->q;
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 
 	if (!blk_iolatency_enabled(blkiolat))
 		return;
 
-	rcu_read_lock();
-	bio_associate_blkcg(bio, NULL);
-	blkcg = bio_blkcg(bio);
-	blkg = blkg_lookup_create(blkcg, q);
+	bio_associate_blkg(bio);
+	blkg = bio->bi_blkg;
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
-	bio_associate_blkg(bio, blkg);
-	rcu_read_unlock();
 
 	while (blkg && blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index d648d6720f46..228c3a007ebc 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2115,10 +2115,10 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
-static void blk_throtl_assoc_bio(struct throtl_grp *tg, struct bio *bio)
+static void blk_throtl_assoc_bio(struct bio *bio)
 {
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	bio_associate_blkg(bio, tg_to_blkg(tg));
+	bio_associate_blkg(bio);
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 #endif
 }
@@ -2143,7 +2143,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 
 	throtl_update_latency_buckets(td);
 
-	blk_throtl_assoc_bio(tg, bio);
+	blk_throtl_assoc_bio(bio);
 	blk_throtl_update_idletime(tg);
 
 	sq = &tg->service_queue;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 056fb627edb3..62715a5a4f32 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -511,12 +511,15 @@ static inline int bio_associate_blkcg_from_page(struct bio *bio,
 
 #ifdef CONFIG_BLK_CGROUP
 int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
-int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg);
+void bio_disassociate_blkg(struct bio *bio);
+void bio_associate_blkg(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
 static inline int bio_associate_blkcg(struct bio *bio,
 			struct cgroup_subsys_state *blkcg_css) { return 0; }
+static inline void bio_disassociate_blkg(struct bio *bio) { }
+static inline void bio_associate_blkg(struct bio *bio) { }
 static inline void bio_disassociate_task(struct bio *bio) { }
 static inline void bio_clone_blkcg_association(struct bio *dst,
 			struct bio *src) { }
-- 
2.17.1


From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 06/14] blkcg: associate blkg when associating a device
Date: Tue,  4 Dec 2018 13:35:52 -0500
Message-ID: <20181204183600.99746-7-dennis@kernel.org>
References: <20181204183600.99746-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181204183600.99746-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

Previously, blkg association was handled by controller specific code in
blk-throttle and blk-iolatency. However, because a blkg represents a
relationship between a blkcg and a request_queue, it makes sense to keep
the blkg->q and bio->bi_disk->queue consistent.

This patch moves association into the bio_set_dev macro(). This should
cover the majority of cases where the device is set/changed keeping the
two pointers consistent. Fallback code is added to
blkcg_bio_issue_check() to catch any missing paths.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 block/bio.c                |  1 +
 block/blk-iolatency.c      |  4 +---
 block/blk-throttle.c       |  1 -
 include/linux/bio.h        |  2 ++
 include/linux/blk-cgroup.h | 11 +++--------
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 41ebb3f8e2fc..1e852ab904aa 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2074,6 +2074,7 @@ void bio_associate_blkg(struct bio *bio)
 
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL_GPL(bio_associate_blkg);
 
 /**
  * bio_disassociate_task - undo bio_associate_current()
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cdbd10564e66..e6b47c255521 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -472,14 +472,12 @@ static void check_scale_change(struct iolatency_grp *iolat)
 static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 {
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
-	struct blkcg_gq *blkg;
+	struct blkcg_gq *blkg = bio->bi_blkg;
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 
 	if (!blk_iolatency_enabled(blkiolat))
 		return;
 
-	bio_associate_blkg(bio);
-	blkg = bio->bi_blkg;
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 
 	while (blkg && blkg->parent) {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 228c3a007ebc..1c6529df2002 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2118,7 +2118,6 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 static void blk_throtl_assoc_bio(struct bio *bio)
 {
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	bio_associate_blkg(bio);
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 #endif
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 62715a5a4f32..6ee2ea8b378a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -491,12 +491,14 @@ do {						\
 		bio_clear_flag(bio, BIO_THROTTLED);\
 	(bio)->bi_disk = (bdev)->bd_disk;	\
 	(bio)->bi_partno = (bdev)->bd_partno;	\
+	bio_associate_blkg(bio);		\
 } while (0)
 
 #define bio_copy_dev(dst, src)			\
 do {						\
 	(dst)->bi_disk = (src)->bi_disk;	\
 	(dst)->bi_partno = (src)->bi_partno;	\
+	bio_clone_blkcg_association(dst, src);	\
 } while (0)
 
 #define bio_dev(bio) \
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c08e96e521ed..3c87ae71156f 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -802,21 +802,17 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio)
 {
-	struct blkcg *blkcg;
 	struct blkcg_gq *blkg;
 	bool throtl = false;
 
-	rcu_read_lock();
+	if (!bio->bi_blkg)
+		bio_associate_blkg(bio);
 
-	/* associate blkcg if bio hasn't attached one */
-	bio_associate_blkcg(bio, NULL);
-	blkcg = bio_blkcg(bio);
-	blkg = blkg_lookup_create(blkcg, q);
+	blkg = bio->bi_blkg;
 
 	throtl = blk_throtl_bio(q, blkg, bio);
 
 	if (!throtl) {
-		blkg = blkg ?: q->root_blkg;
 		/*
 		 * If the bio is flagged with BIO_QUEUE_ENTERED it means this
 		 * is a split bio and we would have already accounted for the
@@ -828,7 +824,6 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
 	}
 
-	rcu_read_unlock();
 	return !throtl;
 }
 
-- 
2.17.1


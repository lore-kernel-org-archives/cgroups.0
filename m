From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 05/13] blkcg: associate blkg when associating a device
Date: Mon, 26 Nov 2018 16:19:38 -0500
Message-ID: <20181126211946.77067-6-dennis@kernel.org>
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

Previously, blkg association was handled by controller specific code in
blk-throttle and blk-iolatency. However, because a blkg represents a
relationship between a blkcg and a request_queue, it makes sense to keep
the blkg->q and bio->bi_disk->queue consistent.

This patch moves association into the bio_set_dev macro. This should
cover the majority of cases where the device is set/changed keeping the
two pointers consistent.

Fallback code is added to blkcg_bio_issue_check() to catch any missing
paths. The check is safe here because bio->bi_disk->queue must exist for
a request to have made it to generic_make_request_checks().

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 block/bio.c                |  1 +
 block/blk-iolatency.c      |  4 +---
 block/blk-throttle.c       |  1 -
 fs/buffer.c                |  2 +-
 fs/ext4/page-io.c          |  2 +-
 include/linux/bio.h        |  7 +++++++
 include/linux/blk-cgroup.h | 10 ++++------
 mm/page_io.c               |  2 +-
 8 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index de0133329b71..929fd3692e4a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2092,6 +2092,7 @@ void bio_associate_blkg(struct bio *bio)
 
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
diff --git a/fs/buffer.c b/fs/buffer.c
index 1286c2b95498..9661e5be87e2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3066,7 +3066,7 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 	}
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
-	bio_set_dev(bio, bh->b_bdev);
+	bio_set_dev_only(bio, bh->b_bdev);
 	bio->bi_write_hint = write_hint;
 
 	bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index db7590178dfc..cadf91a42fa5 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -376,7 +376,7 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 		return -ENOMEM;
 	wbc_init_bio(io->io_wbc, bio);
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
-	bio_set_dev(bio, bh->b_bdev);
+	bio_set_dev_only(bio, bh->b_bdev);
 	bio->bi_end_io = ext4_end_bio;
 	bio->bi_private = ext4_get_io_end(io->io_end);
 	io->io_bio = bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 62715a5a4f32..8bc9d9b29fd3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -486,6 +486,12 @@ extern unsigned int bvec_nr_vecs(unsigned short idx);
 extern const char *bio_devname(struct bio *bio, char *buffer);
 
 #define bio_set_dev(bio, bdev) 			\
+do {						\
+	bio_set_dev_only(bio, bdev);		\
+	bio_associate_blkg(bio);		\
+} while (0)
+
+#define bio_set_dev_only(bio, bdev)		\
 do {						\
 	if ((bio)->bi_disk != (bdev)->bd_disk)	\
 		bio_clear_flag(bio, BIO_THROTTLED);\
@@ -497,6 +503,7 @@ do {						\
 do {						\
 	(dst)->bi_disk = (src)->bi_disk;	\
 	(dst)->bi_partno = (src)->bi_partno;	\
+	bio_clone_blkcg_association(dst, src);	\
 } while (0)
 
 #define bio_dev(bio) \
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 9d796a4f8ef0..81b45943ce29 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -802,21 +802,19 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio)
 {
-	struct blkcg *blkcg;
 	struct blkcg_gq *blkg;
 	bool throtl = false;
 
 	rcu_read_lock();
 
-	/* associate blkcg if bio hasn't attached one */
-	bio_associate_blkcg(bio, NULL);
-	blkcg = bio_blkcg(bio);
-	blkg = blkg_lookup_create(blkcg, q);
+	if (!bio->bi_blkg)
+		bio_associate_blkg(bio);
+
+	blkg = bio->bi_blkg;
 
 	throtl = blk_throtl_bio(q, blkg, bio);
 
 	if (!throtl) {
-		blkg = blkg ?: q->root_blkg;
 		/*
 		 * If the bio is flagged with BIO_QUEUE_ENTERED it means this
 		 * is a split bio and we would have already accounted for the
diff --git a/mm/page_io.c b/mm/page_io.c
index 5bdfd21c1bd9..257fdd67308d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -37,7 +37,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 		struct block_device *bdev;
 
 		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
-		bio_set_dev(bio, bdev);
+		bio_set_dev_only(bio, bdev);
 		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
-- 
2.17.1


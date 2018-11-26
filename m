From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 06/13] blkcg: consolidate bio_issue_init() to be a part of core
Date: Mon, 26 Nov 2018 16:19:39 -0500
Message-ID: <20181126211946.77067-7-dennis@kernel.org>
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

bio_issue_init among other things initializes the timestamp for an IO.
Rather than have this logic handled by policies, this consolidates it to
be on the init paths (normal, clone, bounce clone).

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 block/bio.c                | 2 ++
 block/blk-iolatency.c      | 2 --
 block/blk-throttle.c       | 8 --------
 block/bounce.c             | 2 ++
 include/linux/blk-cgroup.h | 9 +++++++++
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 929fd3692e4a..efca5ae607a4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -611,6 +611,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	bio_clone_blkcg_association(bio, bio_src);
+
+	blkcg_bio_issue_init(bio);
 }
 EXPORT_SYMBOL(__bio_clone_fast);
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index e6b47c255521..5a79f06a730d 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -478,8 +478,6 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!blk_iolatency_enabled(blkiolat))
 		return;
 
-	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
-
 	while (blkg && blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg);
 		if (!iolat) {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 1c6529df2002..1b97a73d2fb1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2115,13 +2115,6 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
-static void blk_throtl_assoc_bio(struct bio *bio)
-{
-#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
-#endif
-}
-
 bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 		    struct bio *bio)
 {
@@ -2142,7 +2135,6 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 
 	throtl_update_latency_buckets(td);
 
-	blk_throtl_assoc_bio(bio);
 	blk_throtl_update_idletime(tg);
 
 	sq = &tg->service_queue;
diff --git a/block/bounce.c b/block/bounce.c
index 559c55bda040..e77a44a80ac2 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -279,6 +279,8 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 
 	bio_clone_blkcg_association(bio, bio_src);
 
+	blkcg_bio_issue_init(bio);
+
 	return bio;
 }
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 81b45943ce29..58eb91a9aa8d 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -799,6 +799,12 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg
 				  struct bio *bio) { return false; }
 #endif
 
+
+static inline void blkcg_bio_issue_init(struct bio *bio)
+{
+	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
+}
+
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio)
 {
@@ -826,6 +832,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
 	}
 
+	blkcg_bio_issue_init(bio);
+
 	rcu_read_unlock();
 	return !throtl;
 }
@@ -932,6 +940,7 @@ static inline char *blkg_path(struct blkcg_gq *blkg) { return NULL; }
 static inline void blkg_get(struct blkcg_gq *blkg) { }
 static inline void blkg_put(struct blkcg_gq *blkg) { }
 
+static inline void blkcg_bio_issue_init(struct bio *bio) { }
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio) { return true; }
 
-- 
2.17.1


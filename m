From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 05/12] blkcg: consolidate bio_issue_init to be a part of core
Date: Thu,  6 Sep 2018 17:10:38 -0400
Message-ID: <20180906211045.29055-6-dennisszhou@gmail.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A7oknpfBCZ28ZYcXI/hUlO4PlTV81jtdGOJ56zQQbeI=;
        b=lvd4+FQjMCmbE7A5/M7KBBrTkwC+8uf25hiBfpmG52KlvVc7vfdNjZiv0ORNVzgJTx
         O1y8nGlb2qTnIqODoFFTBWnFowhiKmJobZIdHLm1hO8tJTNX/0UzA/fVi3K+njyANc0W
         3pnWMCO44Rqn0XDkYv0rcg3VmfSMVYiV0O+U2xE8texSTwoKg2l2vlxeb2K2VfpFlR50
         0arrhbosssQMXfyxzQcw8459IqitgNb3qg+oHOtLI1OVD54/Mk2CslgWidaZMLPpEF8p
         GBf00srxk8jBTty0o48Mh3J6NGbzdrqXOdTJm+0F9EZJY6JyeLwn+/OAcAuy9PkfSe7C
         qyeQ==
In-Reply-To: <20180906211045.29055-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

bio_issue_init among other things initializes the timestamp for an IO.
Rather than have this logic handled by policies, this consolidates it to
be on the init paths (normal, clone, bounce clone).

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
v2: Association path consolidation was moved to the prior patch.

 block/bio.c                | 2 ++
 block/blk-iolatency.c      | 2 --
 block/blk-throttle.c       | 8 --------
 block/bounce.c             | 2 ++
 include/linux/blk-cgroup.h | 9 +++++++++
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b2b3fddfcd6f..a05997bdb967 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -610,6 +610,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	bio_clone_blkcg_association(bio, bio_src);
+
+	blkcg_bio_issue_init(bio);
 }
 EXPORT_SYMBOL(__bio_clone_fast);
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 79a7549e2062..9d7052bad6f7 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -401,8 +401,6 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio,
 	if (!blk_iolatency_enabled(blkiolat))
 		return;
 
-	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
-
 	while (blkg && blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg);
 		if (!iolat) {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b7b5cc4defc2..f2b355338894 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2126,13 +2126,6 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
-static void blk_throtl_assoc_bio(struct throtl_grp *tg, struct bio *bio)
-{
-#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
-#endif
-}
-
 bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 		    struct bio *bio)
 {
@@ -2156,7 +2149,6 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 	if (unlikely(blk_queue_bypass(q)))
 		goto out_unlock;
 
-	blk_throtl_assoc_bio(tg, bio);
 	blk_throtl_update_idletime(tg);
 
 	sq = &tg->service_queue;
diff --git a/block/bounce.c b/block/bounce.c
index bc63b3a2d18c..7a08703b1204 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -259,6 +259,8 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 
 	bio_clone_blkcg_association(bio, bio_src);
 
+	blkcg_bio_issue_init(bio);
+
 	return bio;
 }
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 6e33ad1d92b4..a6b6e741a75e 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -897,6 +897,12 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg
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
@@ -922,6 +928,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
 	}
 
+	blkcg_bio_issue_init(bio);
+
 	rcu_read_unlock();
 	return !throtl;
 }
@@ -1034,6 +1042,7 @@ static inline void blk_put_rl(struct request_list *rl) { }
 static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl) { }
 static inline struct request_list *blk_rq_rl(struct request *rq) { return &rq->q->root_rl; }
 
+static inline void blkcg_bio_issue_init(struct bio *bio) { }
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio) { return true; }
 
-- 
2.17.1


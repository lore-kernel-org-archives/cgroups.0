From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 10/15] blkcg: remove bio->bi_css and instead use bio->bi_blkg
Date: Thu, 30 Aug 2018 21:53:51 -0400
Message-ID: <20180831015356.69796-11-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=awg10XvAuGSDbfNPOY1xU77kPIpO9M7BU2YpkvZIb1I=;
        b=ABDCKk3KPEOyY7fnDUJ4TNehKkZjwWWuY7X1ga/PVeoXas8D/M9Of/1o5DkLmwLsih
         /uDx6sE9of73cHAg0z2YcwWjQhKIfOQbzYGIxcqYCwOcG6Vjr3lromGFoH+rTugismLQ
         u//leieRWyi1ckLYlQXEDSIEHuBXL1r5gSvIPWH2i9Ysfmck30AARrky4qFREX8tXFig
         6skFshTEKSCqdIP4eWu/B6d65AdoXacINS6ch6fsrCmCOUtXQShVcNhNp2Lhzz+82uXZ
         silmA0NIrnKtIqHs6cdRGKAiuGr+a+/PmBAu/OEVZouv8lKUQpqSkmIz0USESlHF2s5k
         zVyQ==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

Prior patches ensured that all bios are now associated with some blkg.
This now makes bio->bi_css unnecessary as blkg maintains a reference to
the blkcg already.

This patch removes the field bi_css and transfers corresponding uses to
access via bi_blkg.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 block/bio.c                | 56 ++++++++------------------------------
 block/bounce.c             |  2 +-
 drivers/block/loop.c       |  5 ++--
 drivers/md/raid0.c         |  2 +-
 include/linux/bio.h        |  7 ++---
 include/linux/blk-cgroup.h |  4 +--
 include/linux/blk_types.h  |  1 -
 kernel/trace/blktrace.c    |  4 +--
 8 files changed, 22 insertions(+), 59 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 97ef994a08b6..ec55ee810503 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -609,7 +609,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
 
-	bio_clone_blkcg_association(bio, bio_src);
+	bio_clone_blkg_association(bio, bio_src);
 
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 }
@@ -1930,34 +1930,6 @@ EXPORT_SYMBOL(bioset_init_from_src);
 
 #ifdef CONFIG_BLK_CGROUP
 
-/**
- * bio_associate_blkcg - associate a bio with the specified blkcg
- * @bio: target bio
- * @blkcg_css: css of the blkcg to associate
- *
- * Associate @bio with the blkcg specified by @blkcg_css.  Block layer will
- * treat @bio as if it were issued by a task which belongs to the blkcg.
- *
- * This function takes an extra reference of @blkcg_css which will be put
- * when @bio is released.  The caller must own @bio and is responsible for
- * synchronizing calls to this function.  If @blkcg_css is NULL, a call to
- * blkcg_get_css finds the current css from the kthread or task.
- */
-int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
-{
-	if (unlikely(bio->bi_css))
-		return -EBUSY;
-
-	if (blkcg_css)
-		css_get(blkcg_css);
-	else
-		blkcg_css = blkcg_get_css();
-
-	bio->bi_css = blkcg_css;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(bio_associate_blkcg);
-
 /**
  * bio_associate_blkg - associate a bio with the specified blkg
  * @bio: target bio
@@ -2004,7 +1976,6 @@ int bio_associate_blkg_from_css(struct bio *bio,
 				struct cgroup_subsys_state *css)
 {
 	css_get(css);
-	bio->bi_css = css;
 	return __bio_associate_blkg_from_css(bio, css);
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
@@ -2025,12 +1996,11 @@ int bio_associate_blkg_from_page(struct bio *bio, struct page *page)
 {
 	struct cgroup_subsys_state *css;
 
-	if (unlikely(bio->bi_css))
+	if (unlikely(bio->bi_blkg))
 		return -EBUSY;
 	if (!page->mem_cgroup)
 		return 0;
 	css = cgroup_get_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
-	bio->bi_css = css;
 
 	return __bio_associate_blkg_from_css(bio, css);
 }
@@ -2056,8 +2026,7 @@ int bio_associate_create_blkg(struct request_queue *q, struct bio *bio)
 
 	rcu_read_lock();
 
-	bio_associate_blkcg(bio, NULL);
-	blkcg = bio_blkcg(bio);
+	blkcg = css_to_blkcg(blkcg_get_css());
 
 	if (!blkcg->css.parent) {
 		ret = bio_associate_blkg(bio, q->root_blkg);
@@ -2084,30 +2053,27 @@ void bio_disassociate_task(struct bio *bio)
 		put_io_context(bio->bi_ioc);
 		bio->bi_ioc = NULL;
 	}
-	if (bio->bi_css) {
-		css_put(bio->bi_css);
-		bio->bi_css = NULL;
-	}
 	if (bio->bi_blkg) {
+		/* a ref is always taken on css */
+		css_put(&bio_blkcg(bio)->css);
 		blkg_put(bio->bi_blkg);
 		bio->bi_blkg = NULL;
 	}
 }
 
 /**
- * bio_clone_blkcg_association - clone blkcg association from src to dst bio
+ * bio_clone_blkg_association - clone blkg association from src to dst bio
  * @dst: destination bio
  * @src: source bio
  */
-void bio_clone_blkcg_association(struct bio *dst, struct bio *src)
+void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_css)
-		WARN_ON(bio_associate_blkcg(dst, src->bi_css));
-
-	if (src->bi_blkg)
+	if (src->bi_blkg) {
+		css_get(&bio_blkcg(src)->css);
 		bio_associate_blkg(dst, src->bi_blkg);
+	}
 }
-EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
+EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 #endif /* CONFIG_BLK_CGROUP */
 
 static void __init biovec_init_slabs(void)
diff --git a/block/bounce.c b/block/bounce.c
index bea3b0cbe4a7..9f7071e176a4 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -257,7 +257,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 		}
 	}
 
-	bio_clone_blkcg_association(bio, bio_src);
+	bio_clone_blkg_association(bio, bio_src);
 
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ea9debf59b22..abad6d15f956 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -77,6 +77,7 @@
 #include <linux/falloc.h>
 #include <linux/uio.h>
 #include <linux/ioprio.h>
+#include <linux/blk-cgroup.h>
 
 #include "loop.h"
 
@@ -1760,8 +1761,8 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	/* always use the first bio's css */
 #ifdef CONFIG_BLK_CGROUP
-	if (cmd->use_aio && rq->bio && rq->bio->bi_css) {
-		cmd->css = rq->bio->bi_css;
+	if (cmd->use_aio && rq->bio && rq->bio->bi_blkg) {
+		cmd->css = &bio_blkcg(rq->bio)->css;
 		css_get(cmd->css);
 	} else
 #endif
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ac1cffd2a09b..f3fb5bb8c82a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -542,7 +542,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 		    !discard_bio)
 			continue;
 		bio_chain(discard_bio, bio);
-		bio_clone_blkcg_association(discard_bio, bio);
+		bio_clone_blkg_association(discard_bio, bio);
 		if (mddev->gendisk)
 			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
 				discard_bio, disk_devt(mddev->gendisk),
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 81530d11d34d..175e5e349d30 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -554,16 +554,13 @@ static inline int bio_associate_blkg_from_page(struct bio *bio,
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
-int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
 int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg);
 int bio_associate_blkg_from_css(struct bio *bio,
 				struct cgroup_subsys_state *css);
 int bio_associate_create_blkg(struct request_queue *q, struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
-void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
+void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
-static inline int bio_associate_blkcg(struct bio *bio,
-			struct cgroup_subsys_state *blkcg_css) { return 0; }
 static inline int bio_associate_blkg(struct bio *bio,
 				     struct blkcg_gq *blkg) { return 0; }
 static inline int bio_associate_blkg_from_css(struct bio *bio,
@@ -572,7 +569,7 @@ static inline int bio_associate_blkg_from_css(struct bio *bio,
 static inline int bio_associate_create_blkg(struct request_queue *q,
 					    struct bio *bio) { return 0; }
 static inline void bio_disassociate_task(struct bio *bio) { }
-static inline void bio_clone_blkcg_association(struct bio *dst,
+static inline void bio_clone_blkg_association(struct bio *dst,
 			struct bio *src) { }
 #endif	/* CONFIG_BLK_CGROUP */
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 55c348d66372..3c66154709ed 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -275,8 +275,8 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
  */
 static inline struct blkcg *bio_blkcg(struct bio *bio)
 {
-	if (bio && bio->bi_css)
-		return css_to_blkcg(bio->bi_css);
+	if (bio && bio->bi_blkg)
+		return bio->bi_blkg->blkcg;
 	return NULL;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index f6dfb30737d8..9578c7ab1eb6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -178,7 +178,6 @@ struct bio {
 	 * release.  Read comment on top of bio_associate_current().
 	 */
 	struct io_context	*bi_ioc;
-	struct cgroup_subsys_state *bi_css;
 	struct blkcg_gq		*bi_blkg;
 	struct bio_issue	bi_issue;
 #endif
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b951aa1fac61..cd90f653c804 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -776,9 +776,9 @@ blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 	if (!bt || !(blk_tracer_flags.val & TRACE_BLK_OPT_CGROUP))
 		return NULL;
 
-	if (!bio->bi_css)
+	if (!bio->bi_blkg)
 		return NULL;
-	return cgroup_get_kernfs_id(bio->bi_css->cgroup);
+	return cgroup_get_kernfs_id(bio_blkcg(bio)->css.cgroup);
 }
 #else
 static union kernfs_node_id *
-- 
2.17.1


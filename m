From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 09/13] blkcg: remove bio->bi_css and instead use bio->bi_blkg
Date: Mon, 26 Nov 2018 16:19:42 -0500
Message-ID: <20181126211946.77067-10-dennis@kernel.org>
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

Prior patches ensured that any bio that interacts with a request_queue
is properly associated with a blkg. This makes bio->bi_css unnecessary
as blkg maintains a reference to blkcg already.

This removes the bio field bi_css and transfers corresponding uses to
access via bi_blkg.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c                | 56 +++++++-------------------------------
 block/bounce.c             |  2 +-
 drivers/block/loop.c       |  5 ++--
 drivers/md/raid0.c         |  2 +-
 include/linux/bio.h        | 11 +++-----
 include/linux/blk-cgroup.h |  8 +++---
 include/linux/blk_types.h  |  7 +++--
 kernel/trace/blktrace.c    |  4 +--
 8 files changed, 29 insertions(+), 66 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index e9e930b6a10c..94922069c3d8 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -610,7 +610,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
 
-	bio_clone_blkcg_association(bio, bio_src);
+	bio_clone_blkg_association(bio, bio_src);
 
 	blkcg_bio_issue_init(bio);
 }
@@ -1958,34 +1958,6 @@ EXPORT_SYMBOL(bioset_init_from_src);
 
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
- * blkcg_get_css() finds the current css from the kthread or task.
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
  * bio_has_queue - required check for blkg association
  * @bio: target bio
@@ -2008,6 +1980,8 @@ static inline bool bio_has_queue(struct bio *bio)
 void bio_disassociate_blkg(struct bio *bio)
 {
 	if (bio->bi_blkg) {
+		/* a ref is always taken on css */
+		css_put(&bio_blkcg(bio)->css);
 		blkg_put(bio->bi_blkg);
 		bio->bi_blkg = NULL;
 	}
@@ -2064,7 +2038,6 @@ void bio_associate_blkg_from_css(struct bio *bio,
 		return;
 
 	css_get(css);
-	bio->bi_css = css;
 	__bio_associate_blkg_from_css(bio, css);
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
@@ -2083,13 +2056,10 @@ void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
 {
 	struct cgroup_subsys_state *css;
 
-	if (unlikely(bio->bi_css))
-		return;
 	if (!bio_has_queue(bio) || !page->mem_cgroup)
 		return;
 
 	css = cgroup_get_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
-	bio->bi_css = css;
 	__bio_associate_blkg_from_css(bio, css);
 }
 #endif /* CONFIG_MEMCG */
@@ -2116,8 +2086,7 @@ void bio_associate_blkg(struct bio *bio)
 
 	rcu_read_lock();
 
-	bio_associate_blkcg(bio, NULL);
-	blkcg = bio_blkcg(bio);
+	blkcg = css_to_blkcg(blkcg_get_css());
 
 	if (!blkcg->css.parent) {
 		__bio_associate_blkg(bio, q->root_blkg);
@@ -2137,27 +2106,22 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_disassociate_task(struct bio *bio)
 {
-	if (bio->bi_css) {
-		css_put(bio->bi_css);
-		bio->bi_css = NULL;
-	}
 	bio_disassociate_blkg(bio);
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
 		__bio_associate_blkg(dst, src->bi_blkg);
+	}
 }
-EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
+EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 #endif /* CONFIG_BLK_CGROUP */
 
 static void __init biovec_init_slabs(void)
diff --git a/block/bounce.c b/block/bounce.c
index e77a44a80ac2..8f35c28a0cef 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -277,7 +277,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 		}
 	}
 
-	bio_clone_blkcg_association(bio, bio_src);
+	bio_clone_blkg_association(bio, bio_src);
 
 	blkcg_bio_issue_init(bio);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 176ab1f28eca..0770004616de 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -77,6 +77,7 @@
 #include <linux/falloc.h>
 #include <linux/uio.h>
 #include <linux/ioprio.h>
+#include <linux/blk-cgroup.h>
 
 #include "loop.h"
 
@@ -1820,8 +1821,8 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
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
index a9958f2bcb48..7b8bb1365977 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -503,7 +503,7 @@ do {						\
 do {						\
 	(dst)->bi_disk = (src)->bi_disk;	\
 	(dst)->bi_partno = (src)->bi_partno;	\
-	bio_clone_blkcg_association(dst, src);	\
+	bio_clone_blkg_association(dst, src);	\
 } while (0)
 
 #define bio_dev(bio) \
@@ -517,24 +517,21 @@ static inline void bio_associate_blkg_from_page(struct bio *bio,
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
-int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
 void bio_disassociate_blkg(struct bio *bio);
 void bio_associate_blkg(struct bio *bio);
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
 void bio_disassociate_task(struct bio *bio);
-void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
+void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
-static inline int bio_associate_blkcg(struct bio *bio,
-			struct cgroup_subsys_state *blkcg_css) { return 0; }
 static inline void bio_disassociate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg_from_css(struct bio *bio,
 					       struct cgroup_subsys_state *css)
 { }
 static inline void bio_disassociate_task(struct bio *bio) { }
-static inline void bio_clone_blkcg_association(struct bio *dst,
-			struct bio *src) { }
+static inline void bio_clone_blkg_association(struct bio *dst,
+					      struct bio *src) { }
 #endif	/* CONFIG_BLK_CGROUP */
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 58eb91a9aa8d..e777de0d45d1 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -308,8 +308,8 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
  */
 static inline struct blkcg *__bio_blkcg(struct bio *bio)
 {
-	if (bio && bio->bi_css)
-		return css_to_blkcg(bio->bi_css);
+	if (bio && bio->bi_blkg)
+		return bio->bi_blkg->blkcg;
 	return css_to_blkcg(blkcg_css());
 }
 
@@ -323,8 +323,8 @@ static inline struct blkcg *__bio_blkcg(struct bio *bio)
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
index c0ba1a038ff3..46c005d601ac 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -174,10 +174,11 @@ struct bio {
 	void			*bi_private;
 #ifdef CONFIG_BLK_CGROUP
 	/*
-	 * Optional css associated with this bio.  Put on bio
-	 * release.  Read comment on top of bio_associate_current().
+	 * Represents the association of the css and request_queue for the bio.
+	 * If a bio goes direct to device, it will not have a blkg as it will
+	 * not have a request_queue associated with it.  The reference is put
+	 * on release of the bio.
 	 */
-	struct cgroup_subsys_state *bi_css;
 	struct blkcg_gq		*bi_blkg;
 	struct bio_issue	bi_issue;
 #endif
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 2868d85f1fb1..fac0ddf8a8e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -764,9 +764,9 @@ blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
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


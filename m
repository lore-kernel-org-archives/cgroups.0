From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 11/13] blkcg: remove bio_disassociate_task()
Date: Mon, 26 Nov 2018 16:19:44 -0500
Message-ID: <20181126211946.77067-12-dennis@kernel.org>
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

Now that a bio only holds a blkg reference, so clean up is simply
putting back that reference. Remove bio_disassociate_task() as it just
calls bio_disassociate_blkg() and call the latter directly.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 block/bio.c         | 11 +----------
 include/linux/bio.h |  2 --
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f713aa236ac5..41cc2ead39f5 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -244,7 +244,7 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 
 void bio_uninit(struct bio *bio)
 {
-	bio_disassociate_task(bio);
+	bio_disassociate_blkg(bio);
 }
 EXPORT_SYMBOL(bio_uninit);
 
@@ -2108,15 +2108,6 @@ void bio_associate_blkg(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg);
 
-/**
- * bio_disassociate_task - undo bio_associate_current()
- * @bio: target bio
- */
-void bio_disassociate_task(struct bio *bio)
-{
-	bio_disassociate_blkg(bio);
-}
-
 /**
  * bio_clone_blkg_association - clone blkg association from src to dst bio
  * @dst: destination bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7b8bb1365977..419fdf5f8ab6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -521,7 +521,6 @@ void bio_disassociate_blkg(struct bio *bio);
 void bio_associate_blkg(struct bio *bio);
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
-void bio_disassociate_task(struct bio *bio);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
 static inline void bio_disassociate_blkg(struct bio *bio) { }
@@ -529,7 +528,6 @@ static inline void bio_associate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg_from_css(struct bio *bio,
 					       struct cgroup_subsys_state *css)
 { }
-static inline void bio_disassociate_task(struct bio *bio) { }
 static inline void bio_clone_blkg_association(struct bio *dst,
 					      struct bio *src) { }
 #endif	/* CONFIG_BLK_CGROUP */
-- 
2.17.1


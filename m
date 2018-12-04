From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 12/14] blkcg: remove bio_disassociate_task()
Date: Tue,  4 Dec 2018 13:35:58 -0500
Message-ID: <20181204183600.99746-13-dennis@kernel.org>
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

Now that a bio only holds a blkg reference, so clean up is simply
putting back that reference. Remove bio_disassociate_task() as it just
calls bio_disassociate_blkg() and call the latter directly.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c         | 11 +----------
 include/linux/bio.h |  2 --
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ce1e512dca5a..7ec5316e6ecc 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -244,7 +244,7 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 
 void bio_uninit(struct bio *bio)
 {
-	bio_disassociate_task(bio);
+	bio_disassociate_blkg(bio);
 }
 EXPORT_SYMBOL(bio_uninit);
 
@@ -2073,15 +2073,6 @@ void bio_associate_blkg(struct bio *bio)
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
index 84e1c4dc703a..7380b094dcca 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -516,7 +516,6 @@ void bio_disassociate_blkg(struct bio *bio);
 void bio_associate_blkg(struct bio *bio);
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
-void bio_disassociate_task(struct bio *bio);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
 static inline void bio_disassociate_blkg(struct bio *bio) { }
@@ -524,7 +523,6 @@ static inline void bio_associate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg_from_css(struct bio *bio,
 					       struct cgroup_subsys_state *css)
 { }
-static inline void bio_disassociate_task(struct bio *bio) { }
 static inline void bio_clone_blkg_association(struct bio *dst,
 					      struct bio *src) { }
 #endif	/* CONFIG_BLK_CGROUP */
-- 
2.17.1


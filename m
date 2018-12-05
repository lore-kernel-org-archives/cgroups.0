From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 14/14] blkcg: rename blkg_try_get() to blkg_tryget()
Date: Wed,  5 Dec 2018 12:10:39 -0500
Message-ID: <20181205171039.73066-15-dennis@kernel.org>
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

blkg reference counting now uses percpu_ref rather than atomic_t. Let's
make this consistent with css_tryget. This renames blkg_try_get to
blkg_tryget and now returns a bool rather than the blkg or %NULL.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c                |  2 +-
 block/blk-cgroup.c         |  3 +--
 block/blk-iolatency.c      |  2 +-
 include/linux/blk-cgroup.h | 12 +++++-------
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7ec5316e6ecc..06760543ec81 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1990,7 +1990,7 @@ static void __bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
 	bio_disassociate_blkg(bio);
 
-	bio->bi_blkg = blkg_try_get_closest(blkg);
+	bio->bi_blkg = blkg_tryget_closest(blkg);
 }
 
 /**
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2ca7611fe274..6bd0619a7d6e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1736,8 +1736,7 @@ void blkcg_maybe_throttle_current(void)
 	blkg = blkg_lookup(blkcg, q);
 	if (!blkg)
 		goto out;
-	blkg = blkg_try_get(blkg);
-	if (!blkg)
+	if (!blkg_tryget(blkg))
 		goto out;
 	rcu_read_unlock();
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 5a79f06a730d..0b14c3d57769 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -698,7 +698,7 @@ static void blkiolatency_timer_fn(struct timer_list *t)
 		 * We could be exiting, don't access the pd unless we have a
 		 * ref on the blkg.
 		 */
-		if (!blkg_try_get(blkg))
+		if (!blkg_tryget(blkg))
 			continue;
 
 		iolat = blkg_to_lat(blkg);
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index d19ef15a673d..752de1becb5c 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -491,27 +491,25 @@ static inline void blkg_get(struct blkcg_gq *blkg)
 }
 
 /**
- * blkg_try_get - try and get a blkg reference
+ * blkg_tryget - try and get a blkg reference
  * @blkg: blkg to get
  *
  * This is for use when doing an RCU lookup of the blkg.  We may be in the midst
  * of freeing this blkg, so we can only use it if the refcnt is not zero.
  */
-static inline struct blkcg_gq *blkg_try_get(struct blkcg_gq *blkg)
+static inline bool blkg_tryget(struct blkcg_gq *blkg)
 {
-	if (percpu_ref_tryget(&blkg->refcnt))
-		return blkg;
-	return NULL;
+	return percpu_ref_tryget(&blkg->refcnt);
 }
 
 /**
- * blkg_try_get_closest - try and get a blkg ref on the closet blkg
+ * blkg_tryget_closest - try and get a blkg ref on the closet blkg
  * @blkg: blkg to get
  *
  * This walks up the blkg tree to find the closest non-dying blkg and returns
  * the blkg that it did association with as it may not be the passed in blkg.
  */
-static inline struct blkcg_gq *blkg_try_get_closest(struct blkcg_gq *blkg)
+static inline struct blkcg_gq *blkg_tryget_closest(struct blkcg_gq *blkg)
 {
 	while (!percpu_ref_tryget(&blkg->refcnt))
 		blkg = blkg->parent;
-- 
2.17.1


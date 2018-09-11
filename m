From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 12/12] blkcg: rename blkg_try_get to blkg_tryget
Date: Tue, 11 Sep 2018 14:41:37 -0400
Message-ID: <20180911184137.35897-13-dennisszhou@gmail.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zhl/2Dyq9QvCeiNHqKLR3IjW7/h51nLcSK+lBauCWR0=;
        b=gdwOfXpUVXotNnENEC5Plz4ZaeFlcFnbenVx5eLjQXQUnNbYlwV7N8Qpyz6GpF8h56
         /s1+KnWao0oPn02D0hq7deBhx2teTphXM4eOl/c0JEmcrZCl2ZV/fycMaEdZjQSWTkqW
         Gh2iRQvB6ez/gkVNU+TtgbjPuT9bPXjwkz5+PNQiZ4Q+z5sjfEGjbLX2+McLy3whXxWH
         l0dauewPyU+OcbMxjdL3acVpVhXqVrij9B5gHzEHa1EmLzEYRRfBcDUGmX2fteDAJfb9
         YkEXu+/WRZcLPCZ8B7cjwMiIQhem4MKSR4jGmNmDbEiWRLafPk6vysEsHCroD6QMgKhz
         oAmA==
In-Reply-To: <20180911184137.35897-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

blkg reference counting now uses percpu_ref rather than atomic_t. Let's
make this consistent with css_tryget. This renames blkg_try_get to
blkg_tryget and now returns a bool rather than the blkg or NULL.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c                |  2 +-
 block/blk-cgroup.c         |  3 +--
 block/blk-iolatency.c      |  2 +-
 include/linux/blk-cgroup.h | 14 ++++++--------
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index a65ab3bacb4f..14351fac07cd 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1975,7 +1975,7 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
 	if (unlikely(bio->bi_blkg))
 		return -EBUSY;
-	bio->bi_blkg = blkg_try_get_closest(blkg);
+	bio->bi_blkg = blkg_tryget_closest(blkg);
 	return 0;
 }
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ab3676e1e15e..76136bea7a7f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1794,8 +1794,7 @@ void blkcg_maybe_throttle_current(void)
 	blkg = blkg_lookup(blkcg, q);
 	if (!blkg)
 		goto out;
-	blkg = blkg_try_get(blkg);
-	if (!blkg)
+	if (!blkg_tryget(blkg))
 		goto out;
 	rcu_read_unlock();
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 9d7052bad6f7..5a4cec54c998 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -628,7 +628,7 @@ static void blkiolatency_timer_fn(struct timer_list *t)
 		 * We could be exiting, don't access the pd unless we have a
 		 * ref on the blkg.
 		 */
-		if (!blkg_try_get(blkg))
+		if (!blkg_tryget(blkg))
 			continue;
 
 		iolat = blkg_to_lat(blkg);
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 7ff5d8ba8c7a..b7fd08013de2 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -494,27 +494,25 @@ static inline void blkg_get(struct blkcg_gq *blkg)
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
@@ -599,7 +597,7 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 	if (unlikely(!blkg))
 		blkg = __blkg_lookup_create(blkcg, q);
 
-	if (!blkg_try_get(blkg))
+	if (!blkg_tryget(blkg))
 		goto rl_use_root;
 
 	rcu_read_unlock();
-- 
2.17.1


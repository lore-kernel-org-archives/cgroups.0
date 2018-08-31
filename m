From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 14/15] blkcg: rename blkg_try_get to blkg_tryget
Date: Thu, 30 Aug 2018 21:53:55 -0400
Message-ID: <20180831015356.69796-15-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jit6SOP1wxl/niVnzyIL+oa21o0jJ66/5PbbODOSPhw=;
        b=jvuaj3y63F1UhmCB4n3qpwUWx85ghl8Qp3rHbvaiZhV2MoaZ3n59hWfHxTPvMLBk2T
         Xs6Mctg8koET+QLUfFJvO0LH0y+wh8UYIkhMX4+0Zc8Flk9bnjsm0UadHWDZYLgl26Sh
         OybWJoB6WwH6HyZIjwtZn0S6zkrNZP5sV6bff655gS+Hr7ylwkp7lc9EziCXybz2LTEs
         JVX+Ay0IX0fK/3CBQt+1ayRKLkqCLO5zTV+V3QyOduPWW/4spBVC5xrCUvHs94hC6Dja
         9Si00l79UGljdNgtxy5dAf9+hU13qo49ofhj+CaDtNVu+lvwbl5nUnAkJ3skVVewI8CM
         TI8A==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
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
---
 block/bio.c                |  2 +-
 block/blk-cgroup.c         |  3 +--
 block/blk-iolatency.c      |  2 +-
 include/linux/blk-cgroup.h | 10 ++++------
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b792bffecce1..a0b816811e7d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1943,7 +1943,7 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
 	if (unlikely(bio->bi_blkg))
 		return -EBUSY;
-	if (!blkg_try_get(blkg))
+	if (!blkg_tryget(blkg))
 		return -ENODEV;
 	bio->bi_blkg = blkg;
 	return 0;
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bbea4b44bd8f..1eaf097e38b0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1777,8 +1777,7 @@ void blkcg_maybe_throttle_current(void)
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
index b60d063fb0d7..0134cdd270b8 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -459,17 +459,15 @@ static inline void blkg_get(struct blkcg_gq *blkg)
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
@@ -560,7 +558,7 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 			}
 		}
 
-		if (blkg_try_get(blkg))
+		if (blkg_tryget(blkg))
 			break;
 		cpu_relax();
 	}
-- 
2.17.1


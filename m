From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH] blkcg: clean up blkg_tryget_closest()
Date: Wed, 19 Dec 2018 16:43:21 -0600
Message-ID: <20181219224321.32624-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

The implementation of blkg_tryget_closest() wasn't super obvious and
became a point of suspicion when debugging [1]. So let's clean it up so
it's obviously not the problem.

[1] https://lore.kernel.org/linux-block/a7e97e4b-0dd8-3a54-23b7-a0f27b17fde8@kernel.dk/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 include/linux/blk-cgroup.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index f025fd1e22e6..76c61318fda5 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -499,22 +499,33 @@ static inline void blkg_get(struct blkcg_gq *blkg)
  */
 static inline bool blkg_tryget(struct blkcg_gq *blkg)
 {
-	return percpu_ref_tryget(&blkg->refcnt);
+	return blkg && percpu_ref_tryget(&blkg->refcnt);
 }
 
 /**
  * blkg_tryget_closest - try and get a blkg ref on the closet blkg
  * @blkg: blkg to get
  *
- * This walks up the blkg tree to find the closest non-dying blkg and returns
- * the blkg that it did association with as it may not be the passed in blkg.
+ * This needs to be called rcu protected.  As the failure mode here is to walk
+ * up the blkg tree, this ensure that the blkg->parent pointers are always
+ * valid.  This returns the blkg that it ended up taking a reference on or %NULL
+ * if no reference was taken.
  */
 static inline struct blkcg_gq *blkg_tryget_closest(struct blkcg_gq *blkg)
 {
-	while (blkg && !percpu_ref_tryget(&blkg->refcnt))
+	struct blkcg_gq *ret_blkg = NULL;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	while (blkg) {
+		if (blkg_tryget(blkg)) {
+			ret_blkg = blkg;
+			break;
+		}
 		blkg = blkg->parent;
+	}
 
-	return blkg;
+	return ret_blkg;
 }
 
 /**
-- 
2.17.1


From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 18/19] blk-cgroup: pass a gendisk to blkg_lookup
Date: Wed,  1 Feb 2023 14:41:22 +0100
Message-ID: <20230201134123.2656505-19-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fOGOx7e997UyhE/H2aX4dIhpMik0QXhxCSAXCp1fhFo=; b=neXFBvgJcg/0jAQ9hmWEXZrTMS
        /3AC0Y9ww3y1Gh70aBC03aQ55PqLEbg7cY5whZr3E3AiC9fAHxiYbM5zG/gUoN0JomnkkEWrtSAeM
        GbknKq9H3TksuVz1nTtzNouo+U1QXibSpz6SRXIhuUwMLP18HwmrsHpGtOsXslKl9UMCbYwRIOyCw
        ispME693FZuuB9LZGlJud1GPU3a2Ey0zngUr+bsIUrh2JGW1NIrmjyC5PkGUxJe+YPRK1LZYIunBE
        nysA4I7jplhlHI7qrTbREv6iyscCrog/tNpIF6KHUXzxqQ66MiqQnxrsJAA0WIhu1LYqJ/lh2g9En
        Mnfz9+zg==;
In-Reply-To: <20230201134123.2656505-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

Pass a gendisk to blkg_lookup and use that to find the match as part
of phasing out usage of the request_queue in the blk-cgroup code.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
---
 block/blk-cgroup.c | 16 ++++++++--------
 block/blk-cgroup.h | 20 ++++++++++----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4fa727542571ea..9907d3c95f8f48 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -337,7 +337,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
-		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk->queue);
+		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk);
 		if (WARN_ON_ONCE(!blkg->parent)) {
 			ret = -ENODEV;
 			goto err_put_css;
@@ -409,12 +409,12 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	blkg = blkg_lookup(blkcg, q);
+	blkg = blkg_lookup(blkcg, disk);
 	if (blkg)
 		return blkg;
 
 	spin_lock_irqsave(&q->queue_lock, flags);
-	blkg = blkg_lookup(blkcg, q);
+	blkg = blkg_lookup(blkcg, disk);
 	if (blkg) {
 		if (blkcg != &blkcg_root &&
 		    blkg != rcu_dereference(blkcg->blkg_hint))
@@ -433,7 +433,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct blkcg_gq *ret_blkg = q->root_blkg;
 
 		while (parent) {
-			blkg = blkg_lookup(parent, q);
+			blkg = blkg_lookup(parent, disk);
 			if (blkg) {
 				/* remember closest blkg */
 				ret_blkg = blkg;
@@ -719,7 +719,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		goto fail_unlock;
 	}
 
-	blkg = blkg_lookup(blkcg, q);
+	blkg = blkg_lookup(blkcg, disk);
 	if (blkg)
 		goto success;
 
@@ -733,7 +733,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
-		while (parent && !blkg_lookup(parent, q)) {
+		while (parent && !blkg_lookup(parent, disk)) {
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
@@ -763,7 +763,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail_preloaded;
 		}
 
-		blkg = blkg_lookup(pos, q);
+		blkg = blkg_lookup(pos, disk);
 		if (blkg) {
 			blkg_free(new_blkg);
 		} else {
@@ -1841,7 +1841,7 @@ void blkcg_maybe_throttle_current(void)
 	blkcg = css_to_blkcg(blkcg_css());
 	if (!blkcg)
 		goto out;
-	blkg = blkg_lookup(blkcg, disk->queue);
+	blkg = blkg_lookup(blkcg, disk);
 	if (!blkg)
 		goto out;
 	if (!blkg_tryget(blkg))
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3d9e42c519db86..151f24de253985 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -234,30 +234,30 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
 }
 
 /**
- * blkg_lookup - lookup blkg for the specified blkcg - q pair
+ * blkg_lookup - lookup blkg for the specified blkcg - disk pair
  * @blkcg: blkcg of interest
- * @q: request_queue of interest
+ * @disk: gendisk of interest
  *
- * Lookup blkg for the @blkcg - @q pair.
+ * Lookup blkg for the @blkcg - @disk pair.
 
  * Must be called in a RCU critical section.
  */
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
-					   struct request_queue *q)
+					   struct gendisk *disk)
 {
 	struct blkcg_gq *blkg;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	if (blkcg == &blkcg_root)
-		return q->root_blkg;
+		return disk->queue->root_blkg;
 
 	blkg = rcu_dereference(blkcg->blkg_hint);
-	if (blkg && blkg->disk->queue == q)
+	if (blkg && blkg->disk == disk)
 		return blkg;
 
-	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
-	if (blkg && blkg->disk->queue != q)
+	blkg = radix_tree_lookup(&blkcg->blkg_tree, disk->queue->id);
+	if (blkg && blkg->disk != disk)
 		blkg = NULL;
 	return blkg;
 }
@@ -357,7 +357,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_pre((pos_css), &(p_blkg)->blkcg->css)	\
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
-					    (p_blkg)->disk->queue)))
+					    (p_blkg)->disk)))
 
 /**
  * blkg_for_each_descendant_post - post-order walk of a blkg's descendants
@@ -372,7 +372,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 #define blkg_for_each_descendant_post(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_post((pos_css), &(p_blkg)->blkcg->css)	\
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
-					    (p_blkg)->disk->queue)))
+					    (p_blkg)->disk)))
 
 bool __blkcg_punt_bio_submit(struct bio *bio);
 
-- 
2.39.0


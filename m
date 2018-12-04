From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 11/14] blkcg: remove additional reference to the css
Date: Tue,  4 Dec 2018 13:35:57 -0500
Message-ID: <20181204183600.99746-12-dennis@kernel.org>
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

The previous patch in this series removed carrying around a pointer to
the css in blkg. However, the blkg association logic still relied on
taking a reference on the css to ensure we wouldn't fail in getting a
reference for the blkg.

Here the implicit dependency on the css is removed. The association
continues to rely on the tryget logic walking up the blkg tree. This
streamlines the three ways that association can happen: normal, swap,
and writeback.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c                | 66 ++++++++++++++++----------------------
 include/linux/blk-cgroup.h | 41 -----------------------
 include/linux/cgroup.h     |  2 ++
 kernel/cgroup/cgroup.c     | 48 +++++++++++++++++++++------
 4 files changed, 69 insertions(+), 88 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2b6bc7b805ec..ce1e512dca5a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1966,8 +1966,6 @@ EXPORT_SYMBOL(bioset_init_from_src);
 void bio_disassociate_blkg(struct bio *bio)
 {
 	if (bio->bi_blkg) {
-		/* a ref is always taken on css */
-		css_put(&bio_blkcg(bio)->css);
 		blkg_put(bio->bi_blkg);
 		bio->bi_blkg = NULL;
 	}
@@ -1995,33 +1993,31 @@ static void __bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 	bio->bi_blkg = blkg_try_get_closest(blkg);
 }
 
-static void __bio_associate_blkg_from_css(struct bio *bio,
-					  struct cgroup_subsys_state *css)
-{
-	struct blkcg_gq *blkg;
-
-	rcu_read_lock();
-
-	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_disk->queue);
-	__bio_associate_blkg(bio, blkg);
-
-	rcu_read_unlock();
-}
-
 /**
  * bio_associate_blkg_from_css - associate a bio with a specified css
  * @bio: target bio
  * @css: target css
  *
  * Associate @bio with the blkg found by combining the css's blkg and the
- * request_queue of the @bio.  This takes a reference on the css that will
- * be put upon freeing of @bio.
+ * request_queue of the @bio.  This falls back to the queue's root_blkg if
+ * the association fails with the css.
  */
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css)
 {
-	css_get(css);
-	__bio_associate_blkg_from_css(bio, css);
+	struct request_queue *q = bio->bi_disk->queue;
+	struct blkcg_gq *blkg;
+
+	rcu_read_lock();
+
+	if (!css || !css->parent)
+		blkg = q->root_blkg;
+	else
+		blkg = blkg_lookup_create(css_to_blkcg(css), q);
+
+	__bio_associate_blkg(bio, blkg);
+
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
 
@@ -2032,8 +2028,8 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
  * @page: the page to lookup the blkcg from
  *
  * Associate @bio with the blkg from @page's owning memcg and the respective
- * request_queue.  This works like every other associate function wrt
- * references.
+ * request_queue.  If cgroup_e_css returns %NULL, fall back to the queue's
+ * root_blkg.
  */
 void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
 {
@@ -2042,8 +2038,12 @@ void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
 	if (!page->mem_cgroup)
 		return;
 
-	css = cgroup_get_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
-	__bio_associate_blkg_from_css(bio, css);
+	rcu_read_lock();
+
+	css = cgroup_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
+	bio_associate_blkg_from_css(bio, css);
+
+	rcu_read_unlock();
 }
 #endif /* CONFIG_MEMCG */
 
@@ -2058,24 +2058,16 @@ void bio_associate_blkg_from_page(struct bio *bio, struct page *page)
  */
 void bio_associate_blkg(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_disk->queue;
-	struct blkcg *blkcg;
-	struct blkcg_gq *blkg;
+	struct cgroup_subsys_state *css;
 
 	rcu_read_lock();
 
 	if (bio->bi_blkg)
-		blkcg = bio->bi_blkg->blkcg;
+		css = &bio_blkcg(bio)->css;
 	else
-		blkcg = css_to_blkcg(blkcg_get_css());
+		css = blkcg_css();
 
-	if (!blkcg->css.parent) {
-		__bio_associate_blkg(bio, q->root_blkg);
-	} else {
-		blkg = blkg_lookup_create(blkcg, q);
-
-		__bio_associate_blkg(bio, blkg);
-	}
+	bio_associate_blkg_from_css(bio, css);
 
 	rcu_read_unlock();
 }
@@ -2097,10 +2089,8 @@ void bio_disassociate_task(struct bio *bio)
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_blkg) {
-		css_get(&bio_blkcg(src)->css);
+	if (src->bi_blkg)
 		__bio_associate_blkg(dst, src->bi_blkg);
-	}
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 #endif /* CONFIG_BLK_CGROUP */
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 3674ff8d8e50..68cae7961060 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -246,47 +246,6 @@ static inline struct cgroup_subsys_state *blkcg_css(void)
 	return task_css(current, io_cgrp_id);
 }
 
-/**
- * blkcg_get_css - find and get a reference to the css
- *
- * Find the css associated with either the kthread or the current task.
- * This takes a reference on the blkcg which will need to be managed by the
- * caller.
- */
-static inline struct cgroup_subsys_state *blkcg_get_css(void)
-{
-	struct cgroup_subsys_state *css;
-
-	rcu_read_lock();
-
-	css = kthread_blkcg();
-	if (css) {
-		css_get(css);
-	} else {
-		/*
-		 * This is a bit complicated.  It is possible task_css() is
-		 * seeing an old css pointer here.  This is caused by the
-		 * current thread migrating away from this cgroup and this
-		 * cgroup dying.  css_tryget() will fail when trying to take a
-		 * ref on a cgroup that's ref count has hit 0.
-		 *
-		 * Therefore, if it does fail, this means current must have
-		 * been swapped away already and this is waiting for it to
-		 * propagate on the polling cpu.  Hence the use of cpu_relax().
-		 */
-		while (true) {
-			css = task_css(current, io_cgrp_id);
-			if (likely(css_tryget(css)))
-				break;
-			cpu_relax();
-		}
-	}
-
-	rcu_read_unlock();
-
-	return css;
-}
-
 static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
 {
 	return css ? container_of(css, struct blkcg, css) : NULL;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9d12757a65b0..9968332cceed 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -93,6 +93,8 @@ extern struct css_set init_css_set;
 
 bool css_has_online_children(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgroup,
+					 struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
 					     struct cgroup_subsys *ss);
 struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6aaf5dd5383b..8b79318810ad 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -493,7 +493,7 @@ static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
 }
 
 /**
- * cgroup_e_css - obtain a cgroup's effective css for the specified subsystem
+ * cgroup_e_css_by_mask - obtain a cgroup's effective css for the specified ss
  * @cgrp: the cgroup of interest
  * @ss: the subsystem of interest (%NULL returns @cgrp->self)
  *
@@ -502,8 +502,8 @@ static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
  * enabled.  If @ss is associated with the hierarchy @cgrp is on, this
  * function is guaranteed to return non-NULL css.
  */
-static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
-						struct cgroup_subsys *ss)
+static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
+							struct cgroup_subsys *ss)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -523,6 +523,35 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	return cgroup_css(cgrp, ss);
 }
 
+/**
+ * cgroup_e_css - obtain a cgroup's effective css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @ss: the subsystem of interest
+ *
+ * Find and get the effective css of @cgrp for @ss.  The effective css is
+ * defined as the matching css of the nearest ancestor including self which
+ * has @ss enabled.  If @ss is not mounted on the hierarchy @cgrp is on,
+ * the root css is returned, so this function always returns a valid css.
+ *
+ * The returned css is not guaranteed to be online, and therefore it is the
+ * callers responsiblity to tryget a reference for it.
+ */
+struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
+					 struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *css;
+
+	do {
+		css = cgroup_css(cgrp, ss);
+
+		if (css)
+			return css;
+		cgrp = cgroup_parent(cgrp);
+	} while (cgrp);
+
+	return init_css_set.subsys[ss->id];
+}
+
 /**
  * cgroup_get_e_css - get a cgroup's effective css for the specified subsystem
  * @cgrp: the cgroup of interest
@@ -605,10 +634,11 @@ EXPORT_SYMBOL_GPL(of_css);
  *
  * Should be called under cgroup_[tree_]mutex.
  */
-#define for_each_e_css(css, ssid, cgrp)					\
-	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	\
-		if (!((css) = cgroup_e_css(cgrp, cgroup_subsys[(ssid)]))) \
-			;						\
+#define for_each_e_css(css, ssid, cgrp)					    \
+	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	    \
+		if (!((css) = cgroup_e_css_by_mask(cgrp,		    \
+						   cgroup_subsys[(ssid)]))) \
+			;						    \
 		else
 
 /**
@@ -1007,7 +1037,7 @@ static struct css_set *find_existing_css_set(struct css_set *old_cset,
 			 * @ss is in this hierarchy, so we want the
 			 * effective css from @cgrp.
 			 */
-			template[i] = cgroup_e_css(cgrp, ss);
+			template[i] = cgroup_e_css_by_mask(cgrp, ss);
 		} else {
 			/*
 			 * @ss is not in this hierarchy, so we don't want
@@ -3024,7 +3054,7 @@ static int cgroup_apply_control(struct cgroup *cgrp)
 		return ret;
 
 	/*
-	 * At this point, cgroup_e_css() results reflect the new csses
+	 * At this point, cgroup_e_css_by_mask() results reflect the new csses
 	 * making the following cgroup_update_dfl_csses() properly update
 	 * css associations of all tasks in the subtree.
 	 */
-- 
2.17.1


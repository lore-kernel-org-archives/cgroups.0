From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 2/3] blkcg: delay blkg destruction until after writeback has finished
Date: Fri, 31 Aug 2018 16:22:43 -0400
Message-ID: <20180831202244.21678-3-dennisszhou@gmail.com>
References: <20180831202244.21678-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YFDuPP9E7I8d1EG/XHXWly2tlY10K1g0Rh4rNXi7iig=;
        b=TQgI5TKLPh7/kfY2uzGkWEHPcCZPyWIfPVJFBi5HI1qpdFIKwGePjD+8Jpshg7RXxK
         K9/3zJeJEZZQCzN8XbNWmey/zFeY1/e1EAvNFYQ7Z7HEYoB8ZYjGUw67MNNcLJdIrHTx
         RhAGdqGXizin+cF+PoFqg8eOG9taI4DSJyJkmaIg8afoeuVgecFhP5hRfrqfzir3cuIP
         exUVxPNDx0BhdWanLDaXSa3OVtXUFxLvYyTXdW9svn8zoan8Iup/EK/6DUiG4RmDr6qa
         LcaA3TmCacZVFQvxNAR4RWf5xDrjvIWDOLTqNI+s7Y52NdhvVsB2SdLyur4PswR0rrRg
         BBFg==
In-Reply-To: <20180831202244.21678-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Jiufei Xue <jiufei.xue@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

Currently, blkcg destruction relies on a sequence of events:
  1. Destruction starts. blkcg_css_offline() is called and blkgs
     release their reference to the blkcg. This immediately destroys
     the cgwbs (writeback).
  2. With blkgs giving up their reference, the blkcg ref count should
     become zero and eventually call blkcg_css_free() which finally
     frees the blkcg.

Jiufei Xue reported that there is a race between blkcg_bio_issue_check()
and cgroup_rmdir(). To remedy this, blkg destruction becomes contingent
on the completion of all writeback associated with the blkcg. A count of
the number of cgwbs is maintained and once that goes to zero, blkg
destruction can follow. This should prevent premature blkg destruction
related to writeback.

The new process for blkcg cleanup is as follows:
  1. Destruction starts. blkcg_css_offline() is called which offlines
     writeback. Blkg destruction is delayed on the cgwb_refcnt count to
     avoid punting potentially large amounts of outstanding writeback
     to root while maintaining any ongoing policies. Here, the base
     cgwb_refcnt is put back.
  2. When the cgwb_refcnt becomes zero, blkcg_destroy_blkgs() is called
     and handles destruction of blkgs. This is where the css reference
     held by each blkg is released.
  3. Once the blkcg ref count goes to zero, blkcg_css_free() is called.
     This finally frees the blkg.

It seems in the past blk-throttle didn't do the most understandable
things with taking data from a blkg while associating with current. So,
the simplification and unification of what blk-throttle is doing caused
this.

v2:
 - Changed nr_cgwbs to be an explicit refcnt.
 - Updated a few comments to be more clear.

Fixes: 08e18eab0c579 ("block: add bi_blkg to the bio for cgroups")
Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c         | 53 ++++++++++++++++++++++++++++++++------
 include/linux/blk-cgroup.h | 44 +++++++++++++++++++++++++++++++
 mm/backing-dev.c           |  5 ++++
 3 files changed, 94 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2998e4f095d1..c19f9078da1e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1042,21 +1042,59 @@ static struct cftype blkcg_legacy_files[] = {
 	{ }	/* terminate */
 };
 
+/*
+ * blkcg destruction is a three-stage process.
+ *
+ * 1. Destruction starts.  The blkcg_css_offline() callback is invoked
+ *    which offlines writeback.  Here we tie the next stage of blkg destruction
+ *    to the completion of writeback associated with the blkcg.  This lets us
+ *    avoid punting potentially large amounts of outstanding writeback to root
+ *    while maintaining any ongoing policies.  The next stage is triggered when
+ *    the nr_cgwbs count goes to zero.
+ *
+ * 2. When the nr_cgwbs count goes to zero, blkcg_destroy_blkgs() is called
+ *    and handles the destruction of blkgs.  Here the css reference held by
+ *    the blkg is put back eventually allowing blkcg_css_free() to be called.
+ *    This work may occur in cgwb_release_workfn() on the cgwb_release
+ *    workqueue.  Any submitted ios that fail to get the blkg ref will be
+ *    punted to the root_blkg.
+ *
+ * 3. Once the blkcg ref count goes to zero, blkcg_css_free() is called.
+ *    This finally frees the blkcg.
+ */
+
 /**
  * blkcg_css_offline - cgroup css_offline callback
  * @css: css of interest
  *
- * This function is called when @css is about to go away and responsible
- * for shooting down all blkgs associated with @css.  blkgs should be
- * removed while holding both q and blkcg locks.  As blkcg lock is nested
- * inside q lock, this function performs reverse double lock dancing.
- *
- * This is the blkcg counterpart of ioc_release_fn().
+ * This function is called when @css is about to go away.  Here the cgwbs are
+ * offlined first and only once writeback associated with the blkcg has
+ * finished do we start step 2 (see above).
  */
 static void blkcg_css_offline(struct cgroup_subsys_state *css)
 {
 	struct blkcg *blkcg = css_to_blkcg(css);
 
+	/* this prevents anyone from attaching or migrating to this blkcg */
+	wb_blkcg_offline(blkcg);
+
+	/* put the base cgwb reference allowing step 2 to be triggered */
+	blkcg_cgwb_put(blkcg);
+}
+
+/**
+ * blkcg_destroy_blkgs - responsible for shooting down blkgs
+ * @blkcg: blkcg of interest
+ *
+ * blkgs should be removed while holding both q and blkcg locks.  As blkcg lock
+ * is nested inside q lock, this function performs reverse double lock dancing.
+ * Destroying the blkgs releases the reference held on the blkcg's css allowing
+ * blkcg_css_free to eventually be called.
+ *
+ * This is the blkcg counterpart of ioc_release_fn().
+ */
+void blkcg_destroy_blkgs(struct blkcg *blkcg)
+{
 	spin_lock_irq(&blkcg->lock);
 
 	while (!hlist_empty(&blkcg->blkg_list)) {
@@ -1075,8 +1113,6 @@ static void blkcg_css_offline(struct cgroup_subsys_state *css)
 	}
 
 	spin_unlock_irq(&blkcg->lock);
-
-	wb_blkcg_offline(blkcg);
 }
 
 static void blkcg_css_free(struct cgroup_subsys_state *css)
@@ -1146,6 +1182,7 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
+	refcount_set(&blkcg->cgwb_refcnt, 1);
 #endif
 	list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 1615cdd4c797..6d766a19f2bb 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -56,6 +56,7 @@ struct blkcg {
 	struct list_head		all_blkcgs_node;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head		cgwb_list;
+	refcount_t			cgwb_refcnt;
 #endif
 };
 
@@ -386,6 +387,49 @@ static inline struct blkcg *cpd_to_blkcg(struct blkcg_policy_data *cpd)
 	return cpd ? cpd->blkcg : NULL;
 }
 
+extern void blkcg_destroy_blkgs(struct blkcg *blkcg);
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+
+/**
+ * blkcg_cgwb_get - get a reference for blkcg->cgwb_list
+ * @blkcg: blkcg of interest
+ *
+ * This is used to track the number of active wb's related to a blkcg.
+ */
+static inline void blkcg_cgwb_get(struct blkcg *blkcg)
+{
+	refcount_inc(&blkcg->cgwb_refcnt);
+}
+
+/**
+ * blkcg_cgwb_put - put a reference for @blkcg->cgwb_list
+ * @blkcg: blkcg of interest
+ *
+ * This is used to track the number of active wb's related to a blkcg.
+ * When this count goes to zero, all active wb has finished so the
+ * blkcg can continue destruction by calling blkcg_destroy_blkgs().
+ * This work may occur in cgwb_release_workfn() on the cgwb_release
+ * workqueue.
+ */
+static inline void blkcg_cgwb_put(struct blkcg *blkcg)
+{
+	if (refcount_dec_and_test(&blkcg->cgwb_refcnt))
+		blkcg_destroy_blkgs(blkcg);
+}
+
+#else
+
+static inline void blkcg_cgwb_get(struct blkcg *blkcg) { }
+
+static inline void blkcg_cgwb_put(struct blkcg *blkcg)
+{
+	/* wb isn't being accounted, so trigger destruction right away */
+	blkcg_destroy_blkgs(blkcg);
+}
+
+#endif
+
 /**
  * blkg_path - format cgroup path of blkg
  * @blkg: blkg of interest
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 2e5d3df0853d..dbae14986e04 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -494,6 +494,7 @@ static void cgwb_release_workfn(struct work_struct *work)
 {
 	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
 						release_work);
+	struct blkcg *blkcg = css_to_blkcg(wb->blkcg_css);
 
 	mutex_lock(&wb->bdi->cgwb_release_mutex);
 	wb_shutdown(wb);
@@ -502,6 +503,9 @@ static void cgwb_release_workfn(struct work_struct *work)
 	css_put(wb->blkcg_css);
 	mutex_unlock(&wb->bdi->cgwb_release_mutex);
 
+	/* triggers blkg destruction if cgwb_refcnt becomes zero */
+	blkcg_cgwb_put(blkcg);
+
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
@@ -600,6 +604,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
 			list_add(&wb->blkcg_node, blkcg_cgwb_list);
+			blkcg_cgwb_get(blkcg);
 			css_get(memcg_css);
 			css_get(blkcg_css);
 		}
-- 
2.17.1


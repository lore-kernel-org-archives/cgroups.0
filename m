From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/9] writeback: relocate wb[_try]_get(), wb_put(), inode_{attach|detach}_wb()
Date: Thu, 28 May 2015 14:50:49 -0400
Message-ID: <1432839057-17609-2-git-send-email-tj@kernel.org>
References: <1432839057-17609-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rSmYUOP7pafxtvu428Fo2bVFFyi5dZPegt23ofOG86I=;
        b=ddMclO6figETJf22spplSZRUTcZUoe9i2M9H/8LQgeOikWEKKKz40ZJbQ0gWr9ZD8y
         BtTBVaq/HLwYx6KQpS2k9cmo9MLtCmCaObGBXJ3wTCtiXg4dE9lXC6BhwmP2pozTvIiK
         Di9vu1k86kJ0fCVyQyN9HhkynBIL0z5zKVIhd+F4Y4K1henteNlALYq5f8CrODDjLhA3
         RtFbMJo3gUDrGdnDZMZb0bh0BFkMAKtSMl7WxdBh0AU/D2YL/SfmLkBlQpqHoDqG7RSL
         7l38WhGDgZRZqxvvMKY+gYpfIS3MILiKDS3Vc1gA6GyrzTWmA5/BssHp+Ze/DcbLCN2Z
         zGIw==
In-Reply-To: <1432839057-17609-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, majority of cgroup writeback support including all the
above functions are implemented in include/linux/backing-dev.h and
mm/backing-dev.c; however, the portion closely related to writeback
logic implemented in include/linux/writeback.h and mm/page-writeback.c
will expand to support foreign writeback detection and correction.

This patch moves wb[_try]_get() and wb_put() to
include/linux/backing-dev-defs.h so that they can be used from
writeback.h and inode_{attach|detach}_wb() to writeback.h and
page-writeback.c.

This is pure reorganization and doesn't introduce any functional
changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/fs-writeback.c                | 31 +++++++++++++++
 include/linux/backing-dev-defs.h | 50 ++++++++++++++++++++++++
 include/linux/backing-dev.h      | 82 ----------------------------------------
 include/linux/writeback.h        | 46 ++++++++++++++++++++++
 mm/backing-dev.c                 | 30 ---------------
 5 files changed, 127 insertions(+), 112 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index da35587..cf6ccfb 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
 #include <linux/device.h>
+#include <linux/memcontrol.h>
 #include "internal.h"
 
 /*
@@ -213,6 +214,36 @@ static void wb_wait_for_completion(struct backing_dev_info *bdi,
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 
+void __inode_attach_wb(struct inode *inode, struct page *page)
+{
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	struct bdi_writeback *wb = NULL;
+
+	if (inode_cgwb_enabled(inode)) {
+		struct cgroup_subsys_state *memcg_css;
+
+		if (page) {
+			memcg_css = mem_cgroup_css_from_page(page);
+			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+		} else {
+			/* must pin memcg_css, see wb_get_create() */
+			memcg_css = task_get_css(current, memory_cgrp_id);
+			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+			css_put(memcg_css);
+		}
+	}
+
+	if (!wb)
+		wb = &bdi->wb;
+
+	/*
+	 * There may be multiple instances of this function racing to
+	 * update the same inode.  Use cmpxchg() to tell the winner.
+	 */
+	if (unlikely(cmpxchg(&inode->i_wb, NULL, wb)))
+		wb_put(wb);
+}
+
 /**
  * inode_congested - test whether an inode is congested
  * @inode: inode to test for congestion
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 8d470b7..e047b49 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -186,4 +186,54 @@ static inline void set_bdi_congested(struct backing_dev_info *bdi, int sync)
 	set_wb_congested(bdi->wb.congested, sync);
 }
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+
+/**
+ * wb_tryget - try to increment a wb's refcount
+ * @wb: bdi_writeback to get
+ */
+static inline bool wb_tryget(struct bdi_writeback *wb)
+{
+	if (wb != &wb->bdi->wb)
+		return percpu_ref_tryget(&wb->refcnt);
+	return true;
+}
+
+/**
+ * wb_get - increment a wb's refcount
+ * @wb: bdi_writeback to get
+ */
+static inline void wb_get(struct bdi_writeback *wb)
+{
+	if (wb != &wb->bdi->wb)
+		percpu_ref_get(&wb->refcnt);
+}
+
+/**
+ * wb_put - decrement a wb's refcount
+ * @wb: bdi_writeback to put
+ */
+static inline void wb_put(struct bdi_writeback *wb)
+{
+	if (wb != &wb->bdi->wb)
+		percpu_ref_put(&wb->refcnt);
+}
+
+#else	/* CONFIG_CGROUP_WRITEBACK */
+
+static inline bool wb_tryget(struct bdi_writeback *wb)
+{
+	return true;
+}
+
+static inline void wb_get(struct bdi_writeback *wb)
+{
+}
+
+static inline void wb_put(struct bdi_writeback *wb)
+{
+}
+
+#endif	/* CONFIG_CGROUP_WRITEBACK */
+
 #endif	/* __LINUX_BACKING_DEV_DEFS_H */
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index e9d7373..5c978a9 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -243,7 +243,6 @@ void wb_congested_put(struct bdi_writeback_congested *congested);
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
 				    gfp_t gfp);
-void __inode_attach_wb(struct inode *inode, struct page *page);
 void wb_memcg_offline(struct mem_cgroup *memcg);
 void wb_blkcg_offline(struct blkcg *blkcg);
 int inode_congested(struct inode *inode, int cong_bits);
@@ -265,37 +264,6 @@ static inline bool inode_cgwb_enabled(struct inode *inode)
 }
 
 /**
- * wb_tryget - try to increment a wb's refcount
- * @wb: bdi_writeback to get
- */
-static inline bool wb_tryget(struct bdi_writeback *wb)
-{
-	if (wb != &wb->bdi->wb)
-		return percpu_ref_tryget(&wb->refcnt);
-	return true;
-}
-
-/**
- * wb_get - increment a wb's refcount
- * @wb: bdi_writeback to get
- */
-static inline void wb_get(struct bdi_writeback *wb)
-{
-	if (wb != &wb->bdi->wb)
-		percpu_ref_get(&wb->refcnt);
-}
-
-/**
- * wb_put - decrement a wb's refcount
- * @wb: bdi_writeback to put
- */
-static inline void wb_put(struct bdi_writeback *wb)
-{
-	if (wb != &wb->bdi->wb)
-		percpu_ref_put(&wb->refcnt);
-}
-
-/**
  * wb_find_current - find wb for %current on a bdi
  * @bdi: bdi of interest
  *
@@ -354,35 +322,6 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
 }
 
 /**
- * inode_attach_wb - associate an inode with its wb
- * @inode: inode of interest
- * @page: page being dirtied (may be NULL)
- *
- * If @inode doesn't have its wb, associate it with the wb matching the
- * memcg of @page or, if @page is NULL, %current.  May be called w/ or w/o
- * @inode->i_lock.
- */
-static inline void inode_attach_wb(struct inode *inode, struct page *page)
-{
-	if (!inode->i_wb)
-		__inode_attach_wb(inode, page);
-}
-
-/**
- * inode_detach_wb - disassociate an inode from its wb
- * @inode: inode of interest
- *
- * @inode is being freed.  Detach from its wb.
- */
-static inline void inode_detach_wb(struct inode *inode)
-{
-	if (inode->i_wb) {
-		wb_put(inode->i_wb);
-		inode->i_wb = NULL;
-	}
-}
-
-/**
  * inode_to_wb - determine the wb of an inode
  * @inode: inode of interest
  *
@@ -471,19 +410,6 @@ static inline void wb_congested_put(struct bdi_writeback_congested *congested)
 {
 }
 
-static inline bool wb_tryget(struct bdi_writeback *wb)
-{
-	return true;
-}
-
-static inline void wb_get(struct bdi_writeback *wb)
-{
-}
-
-static inline void wb_put(struct bdi_writeback *wb)
-{
-}
-
 static inline struct bdi_writeback *wb_find_current(struct backing_dev_info *bdi)
 {
 	return &bdi->wb;
@@ -495,14 +421,6 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
 	return &bdi->wb;
 }
 
-static inline void inode_attach_wb(struct inode *inode, struct page *page)
-{
-}
-
-static inline void inode_detach_wb(struct inode *inode)
-{
-}
-
 static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 {
 	return &inode_to_bdi(inode)->wb;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 3b73e97..6726b7e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -8,6 +8,7 @@
 #include <linux/workqueue.h>
 #include <linux/fs.h>
 #include <linux/flex_proportions.h>
+#include <linux/backing-dev-defs.h>
 
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
 
@@ -173,6 +174,51 @@ static inline void wait_on_inode(struct inode *inode)
 	wait_on_bit(&inode->i_state, __I_NEW, TASK_UNINTERRUPTIBLE);
 }
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+
+void __inode_attach_wb(struct inode *inode, struct page *page);
+
+/**
+ * inode_attach_wb - associate an inode with its wb
+ * @inode: inode of interest
+ * @page: page being dirtied (may be NULL)
+ *
+ * If @inode doesn't have its wb, associate it with the wb matching the
+ * memcg of @page or, if @page is NULL, %current.  May be called w/ or w/o
+ * @inode->i_lock.
+ */
+static inline void inode_attach_wb(struct inode *inode, struct page *page)
+{
+	if (!inode->i_wb)
+		__inode_attach_wb(inode, page);
+}
+
+/**
+ * inode_detach_wb - disassociate an inode from its wb
+ * @inode: inode of interest
+ *
+ * @inode is being freed.  Detach from its wb.
+ */
+static inline void inode_detach_wb(struct inode *inode)
+{
+	if (inode->i_wb) {
+		wb_put(inode->i_wb);
+		inode->i_wb = NULL;
+	}
+}
+
+#else	/* CONFIG_CGROUP_WRITEBACK */
+
+static inline void inode_attach_wb(struct inode *inode, struct page *page)
+{
+}
+
+static inline void inode_detach_wb(struct inode *inode)
+{
+}
+
+#endif	/* CONFIG_CGROUP_WRITEBACK */
+
 /*
  * mm/page-writeback.c
  */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 84ebf7c..887d72a8 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -660,36 +660,6 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	return wb;
 }
 
-void __inode_attach_wb(struct inode *inode, struct page *page)
-{
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
-	struct bdi_writeback *wb = NULL;
-
-	if (inode_cgwb_enabled(inode)) {
-		struct cgroup_subsys_state *memcg_css;
-
-		if (page) {
-			memcg_css = mem_cgroup_css_from_page(page);
-			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
-		} else {
-			/* must pin memcg_css, see wb_get_create() */
-			memcg_css = task_get_css(current, memory_cgrp_id);
-			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
-			css_put(memcg_css);
-		}
-	}
-
-	if (!wb)
-		wb = &bdi->wb;
-
-	/*
-	 * There may be multiple instances of this function racing to
-	 * update the same inode.  Use cmpxchg() to tell the winner.
-	 */
-	if (unlikely(cmpxchg(&inode->i_wb, NULL, wb)))
-		wb_put(wb);
-}
-
 static void cgwb_bdi_init(struct backing_dev_info *bdi)
 {
 	bdi->wb.memcg_css = mem_cgroup_root_css;
-- 
2.4.0

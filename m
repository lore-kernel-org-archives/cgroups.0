From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/9] writeback: add lockdep annotation to inode_to_wb()
Date: Thu, 28 May 2015 14:50:55 -0400
Message-ID: <1432839057-17609-8-git-send-email-tj@kernel.org>
References: <1432839057-17609-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v8WcMX3TrSfjH6Fc0Ep+cQQjBu5ll6We7XI0LLPmUUo=;
        b=JQltOalyEmuP5+xv2t5npdEyQDW3PL01iwaYS0xRPiioHemjhUICy7NpJLRgSWLnTN
         OYgLiR38z2+vSola70JAGyVjibdyF9CW06KbP//nclwFemiGv5UPqy9AW2d9PRP0LfHU
         DY/SgqiFyXCaw4gJV/7IbrJAd9zzPG6ordvH01u9LIkzBVyVI04gwrfWh/9A0a+4X5YF
         Nx4Z+GTvH4P+EV5xgPMHtSZWQeD/7Nobg4YPYFSK7o6Pcc+f2KMrrOdh+3uxjUBOxACf
         MONCMxlp4slrKfydAk28wlDnnXNNdPesC3YIvNs2kG3CWSyENE68GUDMuui3OU4aZc8I
         ZaLg==
In-Reply-To: <1432839057-17609-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

With the previous three patches, all operations which acquire wb from
inode are either under one of inode->i_lock, mapping->tree_lock or
wb->list_lock or protected by unlocked_inode_to_wb transaction.  This
will be depended upon by foreign inode wb switching.

This patch adds lockdep assertion to inode_to_wb() so that usages
outside the above list locks can be caught easily.  There are three
exceptions.

* locked_inode_to_wb_and_lock_list() is holding wb->list_lock but the
  wb may not be the inode's.  Ensuring that is the function's role
  after all.  Updated to deref inode->i_wb directly.

* inode_wb_stat_unlocked_begin() is usually protected by combination
  of !I_WB_SWITCH and rcu_read_lock().  Updated to deref inode->i_wb
  directly.

* inode_congested() wants to test whether inode->i_wb is set before
  starting the transaction.  Added inode_to_wb_is_valid() which tests
  inode->i_wb directly.

v5: might_lock() removed.  It annotates that the lock is grabbed w/
    irq enabled which isn't the case and triggering lockdep warning
    spuriously.

v4: might_lock() added to unlocked_inode_to_wb_begin().

v3: inode_congested() conversion added.

v2: locked_inode_to_wb_and_lock_list() was missing in the first
    version.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/fs-writeback.c           |  5 +++--
 include/linux/backing-dev.h | 34 ++++++++++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25458fa..6b99dee 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -285,7 +285,8 @@ locked_inode_to_wb_and_lock_list(struct inode *inode)
 		spin_lock(&wb->list_lock);
 		wb_put(wb);		/* not gonna deref it anymore */
 
-		if (likely(wb == inode_to_wb(inode)))
+		/* i_wb may have changed inbetween, can't use inode_to_wb() */
+		if (likely(wb == inode->i_wb))
 			return wb;	/* @inode already has ref */
 
 		spin_unlock(&wb->list_lock);
@@ -622,7 +623,7 @@ int inode_congested(struct inode *inode, int cong_bits)
 	 * Once set, ->i_wb never becomes NULL while the inode is alive.
 	 * Start transaction iff ->i_wb is visible.
 	 */
-	if (inode && inode_to_wb(inode)) {
+	if (inode && inode_to_wb_is_valid(inode)) {
 		struct bdi_writeback *wb;
 		bool locked, congested;
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 73ffa32..dfce808 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -322,13 +322,33 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
 }
 
 /**
+ * inode_to_wb_is_valid - test whether an inode has a wb associated
+ * @inode: inode of interest
+ *
+ * Returns %true if @inode has a wb associated.  May be called without any
+ * locking.
+ */
+static inline bool inode_to_wb_is_valid(struct inode *inode)
+{
+	return inode->i_wb;
+}
+
+/**
  * inode_to_wb - determine the wb of an inode
  * @inode: inode of interest
  *
- * Returns the wb @inode is currently associated with.
+ * Returns the wb @inode is currently associated with.  The caller must be
+ * holding either @inode->i_lock, @inode->i_mapping->tree_lock, or the
+ * associated wb's list_lock.
  */
 static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 {
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(debug_locks &&
+		     (!lockdep_is_held(&inode->i_lock) &&
+		      !lockdep_is_held(&inode->i_mapping->tree_lock) &&
+		      !lockdep_is_held(&inode->i_wb->list_lock)));
+#endif
 	return inode->i_wb;
 }
 
@@ -360,7 +380,12 @@ unlocked_inode_to_wb_begin(struct inode *inode, bool *lockedp)
 
 	if (unlikely(*lockedp))
 		spin_lock_irq(&inode->i_mapping->tree_lock);
-	return inode_to_wb(inode);
+
+	/*
+	 * Protected by either !I_WB_SWITCH + rcu_read_lock() or tree_lock.
+	 * inode_to_wb() will bark.  Deref directly.
+	 */
+	return inode->i_wb;
 }
 
 /**
@@ -459,6 +484,11 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
 	return &bdi->wb;
 }
 
+static inline bool inode_to_wb_is_valid(struct inode *inode)
+{
+	return true;
+}
+
 static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 {
 	return &inode_to_bdi(inode)->wb;
-- 
2.4.0

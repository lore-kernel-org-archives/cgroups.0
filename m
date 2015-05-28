From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 7/9] writeback: add lockdep annotation to inode_to_wb()
Date: Wed, 27 May 2015 20:03:09 -0400
Message-ID: <20150528000309.GU7099@htj.duckdns.org>
References: <1432334183-6324-1-git-send-email-tj@kernel.org>
 <1432334183-6324-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=r+UxFSG6gYUSiaFDVUr+wHT12imZvJGQZ1botsi3tzQ=;
        b=HAJKRJy8en2WGfqxcheZzhrFeM8tFzfF90MoHT4QjHtcZNXFhrssntKdYdP7euu0xv
         psul5XEMfxVBTJXTBzO9cg+X8T0SSEbaJc2UtnkDsqC8o7b89HlLt2/5KgE0vTixUYrb
         r71AfwbbDMe5G+fZkPoZLcgFk64zAytJgYYOjAcAMDRgMkG8Iys0kunR91pnU877pYVJ
         VqoiwSmYPcMtE+t3ULjnRLo0yEZT6oZyRx8fjFtjoYc3axraaSRNvrM96q45l2wybrCN
         LwPrjkMFkluPUkh98qC9D3hXtp616knG2G7YeYWXwyMHeajU9NI3xaq7cfOl0id+JotA
         GIjQ==
Content-Disposition: inline
In-Reply-To: <1432334183-6324-8-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

From d3559e62138f39402ca05f3906551b3cb610edad Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 27 May 2015 19:53:49 -0400

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
Hello, Jens.

might_lock() added on v4 had to be removed as it triggers locking
context warning spuriously.  All the git trees have been updated
accordingly.  All the posted updates are quite peripheral.

Thanks.

 fs/fs-writeback.c           |  5 +++--
 include/linux/backing-dev.h | 34 ++++++++++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index eb94b00..e468073 100644
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
@@ -613,7 +614,7 @@ int inode_congested(struct inode *inode, int cong_bits)
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

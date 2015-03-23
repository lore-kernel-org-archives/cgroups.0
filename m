From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] writeback: add lockdep annotation to inode_to_wb()
Date: Mon, 23 Mar 2015 01:25:43 -0400
Message-ID: <1427088344-17542-8-git-send-email-tj@kernel.org>
References: <1427088344-17542-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oAA0vczux2BkSbmkopgYUpuZlLP5H4dmLZElsAg2HMA=;
        b=jM6GJXK++xOfJP+gWYv6eCn2B7VZizi8QsKIa2qegmRuIOOR/qJghtwZCMOLh/pjEE
         MWmHwAdFfqtfBSI25JfFdy/gULk2x04tYoIkij9wzGlG2wV7LAEbc4L11ccAYRRmOgJp
         uHyQMBxqUJcDoPjOacgMoLTRbi4Wn52T778hn9ul9Iop6Jx6zVK3B0NeIjxt2qjrvGvX
         T51q9jJ+DbBcjvG1u/A9oIj83/7UhWrgQxBn0CyraYUwCwePYHB2B8Ird21Y1I+iUCmM
         5jbGu0aoU7UcWIY2MNRRgtKn0D6WGe7IhHZCrBfIN6uF3uJf6M1hKG29bjs5765WeQ68
         HQOg==
In-Reply-To: <1427088344-17542-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

With the previous two patches, all operations which acquire wb from
inode are either under one of inode->i_lock, mapping->tree_lock or
wb->list_lock, or protected by stat transaction, which will be
depended upon by foreign inode wb switching.

This patch adds lockdep assertion to inode_to_wb() so that usages
outside the above list locks can be caught easily.
inode_wb_stat_unlocked_begin() is an exception as it's usually
protected by combination of !I_WB_SWITCH and rcu_read_lock().  It's
updated to dereference inode->i_wb directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 include/linux/backing-dev.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 040be1a..b9937e5 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -326,10 +326,18 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
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
 
@@ -360,7 +368,12 @@ inode_wb_stat_unlocked_begin(struct inode *inode, bool *lockedp)
 
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
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

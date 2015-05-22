From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] writeback: add lockdep annotation to inode_to_wb()
Date: Fri, 22 May 2015 18:36:21 -0400
Message-ID: <1432334183-6324-8-git-send-email-tj@kernel.org>
References: <1432334183-6324-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mSzbqBbw0MH9YjBwkKojYC4HiK1c8qNK2ErtJXiqB/Y=;
        b=Y0UC6ehzOrWj+DZtawXCvvQYBeBH0wqqQuBoMHPAq2hwBXAix13lMGCmCyItR8D4lY
         gYOlPHdmyCL1C3NtRkPHwHmBcsBGfj2//cP8w1l11bz792WebbEzuy9ENe5Uk4gF5JRh
         uE3y8fSe1DSQZqNFs5DK92QHkyQ5TrYo4J3rO4qNbjOJyszRFxn061berqGoIKJO24Cn
         hE9xb4Q74iMIGxQ0bEW2lGHqiurA8cPgXIjIy4DJDXmh160oMROxpVBHWQRNHrUXuqVp
         qg7Q9LXxLkl92bzByVTDApww9p/lUPee6lA/16ssYrlwAnHdz7W1ppqI4IfQPK3YRiOK
         2CaA==
In-Reply-To: <1432334183-6324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

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

v4: might_lock() added to unlocked_inode_to_wb_begin().

v3: inode_congested() conversion added.

v2: locked_inode_to_wb_and_lock_list() was missing in the first
    version.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 fs/fs-writeback.c           |  5 +++--
 include/linux/backing-dev.h | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 4 deletions(-)

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
index 73ffa32..7aaebb9 100644
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
 
@@ -350,6 +370,8 @@ static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 static inline struct bdi_writeback *
 unlocked_inode_to_wb_begin(struct inode *inode, bool *lockedp)
 {
+	might_lock(&inode->i_mapping->tree_lock);
+
 	rcu_read_lock();
 
 	/*
@@ -360,7 +382,12 @@ unlocked_inode_to_wb_begin(struct inode *inode, bool *lockedp)
 
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
@@ -459,6 +486,11 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
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

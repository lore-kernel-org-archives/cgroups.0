From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/51] bdi: make inode_to_bdi() inline
Date: Fri, 22 May 2015 17:13:33 -0400
Message-ID: <1432329245-5844-20-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VYhCeHHtoBHBb8H6+xL3ppkP7PcEyNO7mNck/oKSLbo=;
        b=lTNKZdhF4nQYMf1niNfMY6ZpOi0p3q1Qj8R1IE6GETpydsXi88etoMnqOWC2ORO3cO
         QtDKgSeluMVoaIiPnz6CH8ggdZ4Os33i5AeUsMpkBKw5HFjxd3cco6GtlYQ0+lq0pi57
         C86czXoQ/B9JcrfRnD8C5ckiMWZ7s5GPhWescT8szz2KLJ0P4ed9PCTVwvIQo9OIabK1
         zEzFl5mPR5+/AQI0sJXeHnTuO3fH4PBcRfw75vPd+T25TMkgsAEuS42mcsNEzsd9s3XX
         6nufKTTyPfnbK6uevSKK6FsHi58qzwdgMvyQDEzJFSDNkjKzMxAAMBwP9Vom+owPUWbc
         QCnA==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

Now that bdi definitions are moved to backing-dev-defs.h,
backing-dev.h can include blkdev.h and inline inode_to_bdi() without
worrying about introducing circular include dependency.  The function
gets called from hot paths and fairly trivial.

This patch makes inode_to_bdi() and sb_is_blkdev_sb() that the
function calls inline.  blockdev_superblock and noop_backing_dev_info
are EXPORT_GPL'd to allow the inline functions to be used from
modules.

While at it, make sb_is_blkdev_sb() return bool instead of int.

v2: Fixed typo in description as suggested by Jan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/block_dev.c              |  8 ++------
 fs/fs-writeback.c           | 16 ----------------
 include/linux/backing-dev.h | 18 ++++++++++++++++--
 include/linux/fs.h          |  8 +++++++-
 mm/backing-dev.c            |  1 +
 5 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index e545cbf..f04c873 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -547,7 +547,8 @@ static struct file_system_type bd_type = {
 	.kill_sb	= kill_anon_super,
 };
 
-static struct super_block *blockdev_superblock __read_mostly;
+struct super_block *blockdev_superblock __read_mostly;
+EXPORT_SYMBOL_GPL(blockdev_superblock);
 
 void __init bdev_cache_init(void)
 {
@@ -688,11 +689,6 @@ static struct block_device *bd_acquire(struct inode *inode)
 	return bdev;
 }
 
-int sb_is_blkdev_sb(struct super_block *sb)
-{
-	return sb == blockdev_superblock;
-}
-
 /* Call when you free inode */
 
 void bd_forget(struct inode *inode)
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a69d2e1..34d1cb8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -78,22 +78,6 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL(writeback_in_progress);
 
-struct backing_dev_info *inode_to_bdi(struct inode *inode)
-{
-	struct super_block *sb;
-
-	if (!inode)
-		return &noop_backing_dev_info;
-
-	sb = inode->i_sb;
-#ifdef CONFIG_BLOCK
-	if (sb_is_blkdev_sb(sb))
-		return blk_get_backing_dev_info(I_BDEV(inode));
-#endif
-	return sb->s_bdi;
-}
-EXPORT_SYMBOL_GPL(inode_to_bdi);
-
 static inline struct inode *wb_inode(struct list_head *head)
 {
 	return list_entry(head, struct inode, i_wb_list);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5e39f7a..7857820 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -11,11 +11,10 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/blkdev.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev-defs.h>
 
-struct backing_dev_info *inode_to_bdi(struct inode *inode);
-
 int __must_check bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
@@ -149,6 +148,21 @@ extern struct backing_dev_info noop_backing_dev_info;
 
 int writeback_in_progress(struct backing_dev_info *bdi);
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb;
+
+	if (!inode)
+		return &noop_backing_dev_info;
+
+	sb = inode->i_sb;
+#ifdef CONFIG_BLOCK
+	if (sb_is_blkdev_sb(sb))
+		return blk_get_backing_dev_info(I_BDEV(inode));
+#endif
+	return sb->s_bdi;
+}
+
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {
 	if (bdi->congested_fn)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1ef6390..ce100b87 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2240,7 +2240,13 @@ extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
-extern int sb_is_blkdev_sb(struct super_block *sb);
+
+extern struct super_block *blockdev_superblock;
+
+static inline bool sb_is_blkdev_sb(struct super_block *sb)
+{
+	return sb == blockdev_superblock;
+}
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ff85ecb..b0707d1 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -18,6 +18,7 @@ struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
+EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
 static struct class *bdi_class;
 
-- 
2.4.0


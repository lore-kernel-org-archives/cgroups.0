From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v4 04/21] block_dev: Support checking inode permissions in
 lookup_bdev()
Date: Tue, 26 Apr 2016 14:30:27 -0500
Message-ID: <1461699046-30485-5-git-send-email-seth.forshee@canonical.com>
References: <1461699046-30485-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <1461699046-30485-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

When looking up a block device by path no permission check is
done to verify that the user has access to the block device inode
at the specified path. In some cases it may be necessary to
check permissions towards the inode, such as allowing
unprivileged users to mount block devices in user namespaces.

Add an argument to lookup_bdev() to optionally perform this
permission check. A value of 0 skips the permission check and
behaves the same as before. A non-zero value specifies the mask
of access rights required towards the inode at the specified
path. The check is always skipped if the user has CAP_SYS_ADMIN.

All callers of lookup_bdev() currently pass a mask of 0, so this
patch results in no functional change. Subsequent patches will
add permission checks where appropriate.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/md/bcache/super.c |  2 +-
 drivers/md/dm-table.c     |  2 +-
 drivers/mtd/mtdsuper.c    |  2 +-
 fs/block_dev.c            | 13 ++++++++++---
 fs/quota/quota.c          |  2 +-
 include/linux/fs.h        |  2 +-
 6 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a296425a7270..e169739a0253 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1950,7 +1950,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 				  sb);
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
-			bdev = lookup_bdev(strim(path));
+			bdev = lookup_bdev(strim(path), 0);
 			mutex_lock(&bch_register_lock);
 			if (!IS_ERR(bdev) && bch_is_open(bdev))
 				err = "device already registered";
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f9e8f0bef332..13f568d527b5 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -372,7 +372,7 @@ dev_t dm_get_dev_t(const char *path)
 	dev_t uninitialized_var(dev);
 	struct block_device *bdev;
 
-	bdev = lookup_bdev(path);
+	bdev = lookup_bdev(path, 0);
 	if (IS_ERR(bdev))
 		dev = name_to_dev_t(path);
 	else {
diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index 20c02a3b7417..b5b60e1af31c 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -176,7 +176,7 @@ struct dentry *mount_mtd(struct file_system_type *fs_type, int flags,
 	/* try the old way - the hack where we allowed users to mount
 	 * /dev/mtdblock$(n) but didn't actually _use_ the blockdev
 	 */
-	bdev = lookup_bdev(dev_name);
+	bdev = lookup_bdev(dev_name, 0);
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
 		pr_debug("MTDSB: lookup_bdev() returned %d\n", ret);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3e84d62d0a25..e9b937845bdb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1431,7 +1431,7 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 	struct block_device *bdev;
 	int err;
 
-	bdev = lookup_bdev(path);
+	bdev = lookup_bdev(path, 0);
 	if (IS_ERR(bdev))
 		return bdev;
 
@@ -1821,12 +1821,14 @@ EXPORT_SYMBOL(ioctl_by_bdev);
 /**
  * lookup_bdev  - lookup a struct block_device by name
  * @pathname:	special file representing the block device
+ * @mask:	rights to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
  * Get a reference to the blockdevice at @pathname in the current
  * namespace if possible and return it.  Return ERR_PTR(error)
- * otherwise.
+ * otherwise.  If @mask is non-zero, check for access rights to the
+ * inode at @pathname.
  */
-struct block_device *lookup_bdev(const char *pathname)
+struct block_device *lookup_bdev(const char *pathname, int mask)
 {
 	struct block_device *bdev;
 	struct inode *inode;
@@ -1841,6 +1843,11 @@ struct block_device *lookup_bdev(const char *pathname)
 		return ERR_PTR(error);
 
 	inode = d_backing_inode(path.dentry);
+	if (mask != 0 && !capable(CAP_SYS_ADMIN)) {
+		error = __inode_permission(inode, mask);
+		if (error)
+			goto fail;
+	}
 	error = -ENOTBLK;
 	if (!S_ISBLK(inode->i_mode))
 		goto fail;
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 0f10ee9892ce..59223384b22e 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -799,7 +799,7 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	bdev = lookup_bdev(tmp->name);
+	bdev = lookup_bdev(tmp->name, 0);
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 66a639ec1bc4..173b8adc6131 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2438,7 +2438,7 @@ static inline void unregister_chrdev(unsigned int major, const char *name)
 #define BLKDEV_MAJOR_HASH_SIZE	255
 extern const char *__bdevname(dev_t, char *buffer);
 extern const char *bdevname(struct block_device *bdev, char *buffer);
-extern struct block_device *lookup_bdev(const char *);
+extern struct block_device *lookup_bdev(const char *, int mask);
 extern void blkdev_show(struct seq_file *,off_t);
 
 #else
-- 
2.7.4

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org

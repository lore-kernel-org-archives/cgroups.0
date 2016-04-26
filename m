From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 04/21] block_dev: Support checking inode permissions in
 lookup_bdev()
Date: Tue, 26 Apr 2016 14:36:17 -0500
Message-ID: <1461699396-33000-5-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canonical-com.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=mXBhIoAqhrV6mpB/EUHfq7FSjviAQtSxLFyR7VtwsDY=;
 b=aBraqV+MxFa7AngXmhSzym6TQiilDEqIgOeq/nYQMyATiYI3gYrXsEWae/lFe4X2AA
 V1CxX4yynW0W7ER1BlQzuq0hzwcHTJrl/MXXQz3u/b9NUF8wssEMKouRfyoBtYSiYkDp
 B3nQ34jQbzvpHDp3G8c0q3uHiuuQzMw4LH82xYPpspFL0Gh4tRuuBFhgeOBgjcegLuob
 jNkc5yAuASgKtxmLKFRQ77pPII0NqW9BYkTJ1UMN3I3LLqTU0061eYKb9uIqVHUWOWq1
 od9jdsMY4NtyeDHT6jpQI5ymVis7WxO7pyTADSinxT2Qh+CHq9JmDeLgGqaEFS0Wp8wE
 OmPQ==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-bcache@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Seth Forshee <seth.forshee@canonical.com>, Miklos Szeredi <mszeredi@redhat.com>, Richard Weinberger <richard.weinberger@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

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

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
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


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

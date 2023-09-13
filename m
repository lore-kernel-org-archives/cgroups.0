From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 19/19] fs: remove ->kill_sb
Date: Wed, 13 Sep 2023 08:10:13 -0300
Message-ID: <20230913111013.77623-20-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=S1SFy87Tal1zjTMpG/B1YzaZjyHevEyx/Ud+hlEwuTk=; b=ZAxP4t/djhRJyUxTiB1g1/4wNn
        Jy/Xo+IIkj7ixqhSE1v83lesrSKtdCY7mtxiQpdDWaA47Ad++ERcNIAoDq2vVNzeVPvQbWXtvvLM6
        t/UO4IUIIeR8why07hc075q8lHsrKJI7D7mNsK+en+fXUEiPi0sUSYFaYxchkQ79W/EEUGGmwNJ+x
        DABx1LwgpU4GjE/l8YtCJy55AK2oNY5aPc3B1GTiJgyFJfms8hvozRaT9sViD54yzQ1nCUczSlOb4
        CHMuF0drthpu+kXBBjg9uc0tJgUiLZA97kWEUVl45SwGmIFrXSS/HTgtHdzV3aMao1S4jWOC29Yio
        34Xi/lzw==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Now that no instances are left, remove ->kill_sb and mark
generic_shutdown_super static.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 Documentation/filesystems/locking.rst |  5 -----
 Documentation/filesystems/vfs.rst     |  5 -----
 fs/super.c                            | 25 +++++++++----------------
 include/linux/fs.h                    |  2 --
 4 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index c33e2f03ed1f69..e4ca99c0828d00 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -221,7 +221,6 @@ prototypes::
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*shutdown_sb) (struct super_block *);
-	void (*kill_sb) (struct super_block *);
 	void (*free_sb) (struct super_block *);
 
 locking rules:
@@ -231,16 +230,12 @@ ops		may block
 =======		=========
 mount		yes
 shutdown_sb	yes
-kill_sb		yes
 free_sb		yes
 =======		=========
 
 ->mount() returns ERR_PTR or the root dentry; its superblock should be locked
 on return.
 
-->kill_sb() takes a write-locked superblock, does all shutdown work on it,
-unlocks and drops the reference.
-
 address_space_operations
 ========================
 prototypes::
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1a7c6926c31f34..29513ee1d34ede 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -120,7 +120,6 @@ members are defined:
 		struct dentry *(*mount) (struct file_system_type *, int,
 			const char *, void *);
 		void (*shutdown_sb) (struct super_block *);
-		void (*kill_sb) (struct super_block *);
 		void (*free_sb) (struct super_block *);
 		struct module *owner;
 		struct file_system_type * next;
@@ -164,10 +163,6 @@ members are defined:
 	Note: dentries and inodes are normally taken care of and do not need
 	specific handling unless they are pinned by kernel users.
 
-``kill_sb``
-	the method to call when an instance of this filesystem should be
-	shut down
-
 ``free_sb``
 	Free file system specific resources like sb->s_fs_info that are
 	still needed while inodes are freed during umount.
diff --git a/fs/super.c b/fs/super.c
index 805ca1dd1e23f2..d9c564e70ffcd5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -458,6 +458,8 @@ static void kill_super_notify(struct super_block *sb)
 	super_wake(sb, SB_DEAD);
 }
 
+static void generic_shutdown_super(struct super_block *sb);
+
 /**
  *	deactivate_locked_super	-	drop an active reference to superblock
  *	@s: superblock to deactivate
@@ -480,15 +482,11 @@ void deactivate_locked_super(struct super_block *s)
 
 	unregister_shrinker(&s->s_shrink);
 
-	if (fs->kill_sb) {
-		fs->kill_sb(s);
-	} else {
-		if (fs->shutdown_sb)
-			fs->shutdown_sb(s);
-		generic_shutdown_super(s);
-		if (fs->free_sb)
-			fs->free_sb(s);
-	}
+	if (fs->shutdown_sb)
+		fs->shutdown_sb(s);
+	generic_shutdown_super(s);
+	if (fs->free_sb)
+		fs->free_sb(s);
 
 	kill_super_notify(s);
 
@@ -661,16 +659,13 @@ EXPORT_SYMBOL(retire_super);
  *	@sb: superblock to kill
  *
  *	generic_shutdown_super() does all fs-independent work on superblock
- *	shutdown.  Typical ->kill_sb() should pick all fs-specific objects
- *	that need destruction out of superblock, call generic_shutdown_super()
- *	and release aforementioned objects.  Note: dentries and inodes _are_
- *	taken care of and do not need specific handling.
+ *	shutdown. 
  *
  *	Upon calling this function, the filesystem may no longer alter or
  *	rearrange the set of dentries belonging to this super_block, nor may it
  *	change the attachments of dentries to inodes.
  */
-void generic_shutdown_super(struct super_block *sb)
+static void generic_shutdown_super(struct super_block *sb)
 {
 	const struct super_operations *sop = sb->s_op;
 
@@ -743,8 +738,6 @@ void generic_shutdown_super(struct super_block *sb)
 	}
 }
 
-EXPORT_SYMBOL(generic_shutdown_super);
-
 bool mount_capable(struct fs_context *fc)
 {
 	if (!(fc->fs_type->fs_flags & FS_USERNS_MOUNT))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 302be5dfc1a04a..f57d3a27b488f7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2340,7 +2340,6 @@ struct file_system_type {
 	const struct fs_parameter_spec *parameters;
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
-	void (*kill_sb) (struct super_block *);
 	void (*shutdown_sb)(struct super_block *sb);
 	void (*free_sb)(struct super_block *sb);
 	struct module *owner;
@@ -2382,7 +2381,6 @@ extern struct dentry *mount_nodev(struct file_system_type *fs_type,
 	int (*fill_super)(struct super_block *, void *, int));
 extern struct dentry *mount_subtree(struct vfsmount *mnt, const char *path);
 void retire_super(struct super_block *sb);
-void generic_shutdown_super(struct super_block *sb);
 void block_free_sb(struct super_block *sb);
 void litter_shutdown_sb(struct super_block *sb);
 void deactivate_super(struct super_block *sb);
-- 
2.39.2


From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/19] fs: add new shutdown_sb and free_sb methods
Date: Wed, 13 Sep 2023 08:10:05 -0300
Message-ID: <20230913111013.77623-12-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gAQpn3abjr3bCkTLiF8aPyoqkxGk9OOm0IM5g63D6eE=; b=NdBTKNAaKwHERWBpvD3UHGHfWf
        zb1yuh/XGcMfDzj1uLx+u6lD7qnepKXrpO/pZmptTHoHtwVpXIcZshX4OUVEMjv7TFo69PbppmJ2S
        rlnKrkO75331r1G0LrzPr74Ld8r5vKU+AwChAsIjk83zQKmZMBIc84YOIDUSjkv5ZJvuC/IOK+E12
        WpSRWG3djGVWDuKbehP3xIldJ/rcOSFsLliI85QDerGS8G2MUpKUaT8chV07JMkBU1+2CEJsmDyZe
        wUX0ytw7XTGMjsPQ73ZLJ7fI2JwOsX3VvP93iP4mMmit4r7MmaYr4cQY0nPPcL0S7f0OQ64t+qePR
        HbqcSKpA==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently super_blocks are shut down using the ->kill_sb method, which
must call generic_shutdown_super, but allows the file system to
add extra work before or after the call to generic_shutdown_super.

File systems tend to get rather confused by this, so add an alternative
shutdown sequence where generic_shutdown_super is called by the core
code, and there are extra ->shutdown_sb and ->free_sb hooks before and
after it.  To remove the amount of boilerplate code ->shutdown_sb is only
called if the super has finished initialization and ->d_root is set.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 Documentation/filesystems/locking.rst |  4 ++++
 Documentation/filesystems/vfs.rst     | 12 ++++++++++++
 fs/super.c                            |  9 +++++++--
 include/linux/fs.h                    |  2 ++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 7be2900806c853..c33e2f03ed1f69 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -220,7 +220,9 @@ prototypes::
 
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
+	void (*shutdown_sb) (struct super_block *);
 	void (*kill_sb) (struct super_block *);
+	void (*free_sb) (struct super_block *);
 
 locking rules:
 
@@ -228,7 +230,9 @@ locking rules:
 ops		may block
 =======		=========
 mount		yes
+shutdown_sb	yes
 kill_sb		yes
+free_sb		yes
 =======		=========
 
 ->mount() returns ERR_PTR or the root dentry; its superblock should be locked
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 99acc2e9867391..1a7c6926c31f34 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -119,7 +119,9 @@ members are defined:
 		const struct fs_parameter_spec *parameters;
 		struct dentry *(*mount) (struct file_system_type *, int,
 			const char *, void *);
+		void (*shutdown_sb) (struct super_block *);
 		void (*kill_sb) (struct super_block *);
+		void (*free_sb) (struct super_block *);
 		struct module *owner;
 		struct file_system_type * next;
 		struct hlist_head fs_supers;
@@ -155,10 +157,20 @@ members are defined:
 	the method to call when a new instance of this filesystem should
 	be mounted
 
+``shutdown_sb``
+	Cleanup after a super_block has reached a zero active count, and before
+	the VFS level cleanup happens.  Typical picks all fs-specific objects
+	(if any) that need destruction out of superblock and releases them.
+	Note: dentries and inodes are normally taken care of and do not need
+	specific handling unless they are pinned by kernel users.
+
 ``kill_sb``
 	the method to call when an instance of this filesystem should be
 	shut down
 
+``free_sb``
+	Free file system specific resources like sb->s_fs_info that are
+	still needed while inodes are freed during umount.
 
 ``owner``
 	for internal VFS use: you should initialize this to THIS_MODULE
diff --git a/fs/super.c b/fs/super.c
index 5c685b4944c2d6..8e173eccc8c113 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -480,10 +480,15 @@ void deactivate_locked_super(struct super_block *s)
 
 	unregister_shrinker(&s->s_shrink);
 
-	if (fs->kill_sb)
+	if (fs->kill_sb) {
 		fs->kill_sb(s);
-	else
+	} else {
+		if (fs->shutdown_sb)
+			fs->shutdown_sb(s);
 		generic_shutdown_super(s);
+		if (fs->free_sb)
+			fs->free_sb(s);
+	}
 
 	kill_super_notify(s);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 31b6b235b36efa..12fff7df3cc46b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2341,6 +2341,8 @@ struct file_system_type {
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*kill_sb) (struct super_block *);
+	void (*shutdown_sb)(struct super_block *sb);
+	void (*free_sb)(struct super_block *sb);
 	struct module *owner;
 	struct file_system_type * next;
 	struct hlist_head fs_supers;
-- 
2.39.2


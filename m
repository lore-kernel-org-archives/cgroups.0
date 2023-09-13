From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 07/19] hypfs: use d_genocide to kill fs entries
Date: Wed, 13 Sep 2023 08:10:01 -0300
Message-ID: <20230913111013.77623-8-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4K7Zh6fs7L+RUXwEY56nuj8NrK8ZqJ3CZpGE4GdIplk=; b=0vjrb7/vV79SKhobktbmGhno7R
        uQUJDhbbppkzC/Mc8r3UT+FaZA1YB0Xfua6N1gf6iSPDvl8kslZB8TM8gHszsDPkxTrY7YUbuLOJO
        VRAXB8ljZ5udf6WgXlBV1DuASXDj/g8Gzaifk258EQPoQoZ/brf1erqpgdtR0+99/dUG5f67aKUeL
        6ZQjDJvQQy/1jSsX+qIgytJOkm+ExaLq70Xfvz5qTpfMeX2q2M2A8G2Oe8QwtufoNB+BPVid6toXr
        xidizbu5Jx0RIsBKv8xRBtURVuHrgwtPCKr1fFH/VCA7sH0xw8Te1AVNN9NAIbMBc3VHFMHlIGoH8
        8cZz1mZg==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hypfs is entirely synthetic and doesn't care about i_nlink when dropping
entries from the cache.  Switch to d_genocide instead of a home grown
file remove loop for unmount and write (yes, really!).

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 arch/s390/hypfs/inode.c | 37 ++-----------------------------------
 1 file changed, 2 insertions(+), 35 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index dbe8a7dcafa922..3261fb9cade648 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -64,33 +64,6 @@ static void hypfs_add_dentry(struct dentry *dentry)
 	hypfs_last_dentry = dentry;
 }
 
-static void hypfs_remove(struct dentry *dentry)
-{
-	struct dentry *parent;
-
-	parent = dentry->d_parent;
-	inode_lock(d_inode(parent));
-	if (simple_positive(dentry)) {
-		if (d_is_dir(dentry))
-			simple_rmdir(d_inode(parent), dentry);
-		else
-			simple_unlink(d_inode(parent), dentry);
-	}
-	d_drop(dentry);
-	dput(dentry);
-	inode_unlock(d_inode(parent));
-}
-
-static void hypfs_delete_tree(struct dentry *root)
-{
-	while (hypfs_last_dentry) {
-		struct dentry *next_dentry;
-		next_dentry = hypfs_last_dentry->d_fsdata;
-		hypfs_remove(hypfs_last_dentry);
-		hypfs_last_dentry = next_dentry;
-	}
-}
-
 static struct inode *hypfs_make_inode(struct super_block *sb, umode_t mode)
 {
 	struct inode *ret = new_inode(sb);
@@ -183,14 +156,14 @@ static ssize_t hypfs_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		rc = -EBUSY;
 		goto out;
 	}
-	hypfs_delete_tree(sb->s_root);
+	d_genocide(sb->s_root);
 	if (MACHINE_IS_VM)
 		rc = hypfs_vm_create_files(sb->s_root);
 	else
 		rc = hypfs_diag_create_files(sb->s_root);
 	if (rc) {
 		pr_err("Updating the hypfs tree failed\n");
-		hypfs_delete_tree(sb->s_root);
+		d_genocide(sb->s_root);
 		goto out;
 	}
 	hypfs_update_update(sb);
@@ -323,12 +296,6 @@ static int hypfs_init_fs_context(struct fs_context *fc)
 
 static void hypfs_kill_super(struct super_block *sb)
 {
-	struct hypfs_sb_info *sb_info = sb->s_fs_info;
-
-	if (sb->s_root)
-		hypfs_delete_tree(sb->s_root);
-	if (sb_info && sb_info->update_file)
-		hypfs_remove(sb_info->update_file);
 	kill_litter_super(sb);
 	kfree(sb->s_fs_info);
 }
-- 
2.39.2


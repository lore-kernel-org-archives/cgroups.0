From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] kernfs: implement custom exportfs ops and fid type
Date: Mon,  4 Nov 2019 15:59:42 -0800
Message-ID: <20191104235944.3470866-9-tj@kernel.org>
References: <20191104235944.3470866-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6eyC/Pr88JMkuUtE27lkcLMpRj73Ok1FRh3V2w/GO4I=;
        b=Q62vHfUhNt9gVSAnEvcyM8ffDXH8NhSIP3TqMk1IR19FwUBSa2gzv/2wfMDbMifc9H
         F+qLKdXYhgWGXSHtzTNJJwJi66burHZmdJ8PcQSmyfrLXkJp1LQ4W1+yayNvceoV5g8+
         uPW5TKW31CyyOARzDfc/1YHDXJkUQjsgSB6uf/743I3dTQXLu+3z5GTdmc0ZuNQeDuFw
         ojaHyff3gkoH3T5F0PCF1nBR68waleyWMp332PeCJmaaY5G/NNUAkzN5cLzG7G2cXTOh
         yyBke9TrRCMbslN7hYaNX4VbgPGetx5F/ZnhEbCWl/dhpZl17Rqwz2hnBeZamkvGtSz2
         uxvA==
In-Reply-To: <20191104235944.3470866-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net, Tejun Heo <tj@kernel.org>

The current kernfs exportfs implementation uses the generic_fh_*()
helpers and FILEID_INO32_GEN[_PARENT] which limits ino to 32bits.
Let's implement custom exportfs operations and fid type to remove the
restriction.

* FILEID_KERNFS is a single u64 value whose content is
  kernfs_node->id.  This is the only native fid type.

* For backward compatibility with blk_log_action() path which exposes
  (ino,gen) pairs which userland assembles into FILEID_INO32_GEN keys,
  combine the generic keys into 64bit IDs in the same order.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 fs/kernfs/mount.c        | 77 +++++++++++++++++++++++++++++++---------
 include/linux/exportfs.h |  5 +++
 2 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 8aed2cccd002..37a1e5df117a 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -53,40 +53,84 @@ const struct super_operations kernfs_sops = {
 	.show_path	= kernfs_sop_show_path,
 };
 
-static struct inode *kernfs_fh_get_inode(struct super_block *sb,
-		u64 ino, u32 generation)
+static int kernfs_encode_fh(struct inode *inode, __u32 *fh, int *max_len,
+			    struct inode *parent)
+{
+	struct kernfs_node *kn = inode->i_private;
+
+	if (*max_len < 2) {
+		*max_len = 2;
+		return FILEID_INVALID;
+	}
+
+	*max_len = 2;
+	*(u64 *)fh = kn->id;
+	return FILEID_KERNFS;
+}
+
+static struct dentry *__kernfs_fh_to_dentry(struct super_block *sb,
+					    struct fid *fid, int fh_len,
+					    int fh_type, bool get_parent)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
-	struct inode *inode;
 	struct kernfs_node *kn;
+	struct inode *inode;
+	u64 id;
 
-	if (ino == 0)
-		return ERR_PTR(-ESTALE);
+	if (fh_len < 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_KERNFS:
+		id = *(u64 *)fid;
+		break;
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		/*
+		 * blk_log_action() exposes (ino,gen) pair without type and
+		 * userland can call us with generic fid constructed from
+		 * them.  Combine it back to ID.  See blk_log_action().
+		 */
+		id = ((u64)fid->i32.gen << 32) | fid->i32.ino;
+		break;
+	default:
+		return NULL;
+	}
 
-	kn = kernfs_find_and_get_node_by_id(info->root,
-					    ino | ((u64)generation << 32));
+	kn = kernfs_find_and_get_node_by_id(info->root, id);
 	if (!kn)
 		return ERR_PTR(-ESTALE);
+
+	if (get_parent) {
+		struct kernfs_node *parent;
+
+		parent = kernfs_get_parent(kn);
+		kernfs_put(kn);
+		kn = parent;
+		if (!kn)
+			return ERR_PTR(-ESTALE);
+	}
+
 	inode = kernfs_get_inode(sb, kn);
 	kernfs_put(kn);
 	if (!inode)
 		return ERR_PTR(-ESTALE);
 
-	return inode;
+	return d_obtain_alias(inode);
 }
 
-static struct dentry *kernfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
+static struct dentry *kernfs_fh_to_dentry(struct super_block *sb,
+					  struct fid *fid, int fh_len,
+					  int fh_type)
 {
-	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
-				    kernfs_fh_get_inode);
+	return __kernfs_fh_to_dentry(sb, fid, fh_len, fh_type, false);
 }
 
-static struct dentry *kernfs_fh_to_parent(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
+static struct dentry *kernfs_fh_to_parent(struct super_block *sb,
+					  struct fid *fid, int fh_len,
+					  int fh_type)
 {
-	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
-				    kernfs_fh_get_inode);
+	return __kernfs_fh_to_dentry(sb, fid, fh_len, fh_type, true);
 }
 
 static struct dentry *kernfs_get_parent_dentry(struct dentry *child)
@@ -97,6 +141,7 @@ static struct dentry *kernfs_get_parent_dentry(struct dentry *child)
 }
 
 static const struct export_operations kernfs_export_ops = {
+	.encode_fh	= kernfs_encode_fh,
 	.fh_to_dentry	= kernfs_fh_to_dentry,
 	.fh_to_parent	= kernfs_fh_to_parent,
 	.get_parent	= kernfs_get_parent_dentry,
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index cf6571fc9c01..d896b8657085 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -104,6 +104,11 @@ enum fid_type {
 	 */
 	FILEID_LUSTRE = 0x97,
 
+	/*
+	 * 64 bit unique kernfs id
+	 */
+	FILEID_KERNFS = 0xfe,
+
 	/*
 	 * Filesystems must not use 0xff file ID.
 	 */
-- 
2.17.1


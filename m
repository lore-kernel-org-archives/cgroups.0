From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] kernfs: add kernfs_ops->open/release() callbacks
Date: Tue, 20 Dec 2016 11:12:19 -0500
Message-ID: <20161220161222.15234-3-tj@kernel.org>
References: <20161220161222.15234-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RuiEI+baSTNWm0y/B8ZREeSFFlfzB+k9yCwP8P1bKB4=;
        b=IbvQCEwEv+UcI46/y8RRrf5PcFb7RTymV/Kyc5C1XIgsGPB+HSgh6onafHO5nqfAIW
         /iLTwyafHVQXDwY2KeiLweVZXiPT3o/OmFHDJrx0NWn4Lr6oDURB8eFk476/d5uJJA6o
         P2jRSI/mCZQrqg5FLigJX+0YsSo8sxRM41JM6hg70w7KiIKACVdSg3hu1Q2sWLnizrux
         +/Mn4dyCGjRsSNdnQe2Krnr8A9CAunoMKy4NmSoK2Xp1MapN5eL8aV/Ip26t1P+SEQbz
         EhXSvvjMZl2XwqmMXiT7HD9U17F7aKNmyk5/DFAux79v5pjzS2ogCx+ObzyhRgwVFHtX
         cl+w==
In-Reply-To: <20161220161222.15234-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Add ->open/release() methods to kernfs_ops.  ->open() is called when
the file is opened and ->release() when the file is either released or
severed.  These callbacks can be used, for example, to manage
persistent caching objects over multiple seq_file iterations.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c             |  2 +-
 fs/kernfs/file.c            | 51 +++++++++++++++++++++++++++++++++++++++------
 fs/kernfs/kernfs-internal.h |  2 +-
 include/linux/kernfs.h      | 10 +++++++++
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index cf4c636..0b9d23b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -468,7 +468,7 @@ static void kernfs_drain(struct kernfs_node *kn)
 		rwsem_release(&kn->dep_map, 1, _RET_IP_);
 	}
 
-	kernfs_unmap_bin_file(kn);
+	kernfs_drain_open_files(kn);
 
 	mutex_lock(&kernfs_mutex);
 }
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index d0b6fb1..20c3962 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -708,7 +708,8 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	if (error)
 		goto err_free;
 
-	((struct seq_file *)file->private_data)->private = of;
+	of->seq_file = file->private_data;
+	of->seq_file->private = of;
 
 	/* seq_file clears PWRITE unconditionally, restore it if WRITE */
 	if (file->f_mode & FMODE_WRITE)
@@ -717,13 +718,22 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	/* make sure we have open node struct */
 	error = kernfs_get_open_node(kn, of);
 	if (error)
-		goto err_close;
+		goto err_seq_release;
+
+	if (ops->open) {
+		/* nobody has access to @of yet, skip @of->mutex */
+		error = ops->open(of);
+		if (error)
+			goto err_put_node;
+	}
 
 	/* open succeeded, put active references */
 	kernfs_put_active(kn);
 	return 0;
 
-err_close:
+err_put_node:
+	kernfs_put_open_node(kn, of);
+err_seq_release:
 	seq_release(inode, file);
 err_free:
 	kfree(of->prealloc_buf);
@@ -733,11 +743,32 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	return error;
 }
 
+/* used from release/drain to ensure that ->release() is called exactly once */
+static void kernfs_release_file(struct kernfs_node *kn,
+				struct kernfs_open_file *of)
+{
+	if (!(kn->flags & KERNFS_HAS_RELEASE))
+		return;
+
+	mutex_lock(&of->mutex);
+	if (!of->released) {
+		/*
+		 * A file is never detached without being released and we
+		 * need to be able to release files which are deactivated
+		 * and being drained.  Don't use kernfs_ops().
+		 */
+		kn->attr.ops->release(of);
+		of->released = true;
+	}
+	mutex_unlock(&of->mutex);
+}
+
 static int kernfs_fop_release(struct inode *inode, struct file *filp)
 {
 	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
 	struct kernfs_open_file *of = kernfs_of(filp);
 
+	kernfs_release_file(kn, of);
 	kernfs_put_open_node(kn, of);
 	seq_release(inode, filp);
 	kfree(of->prealloc_buf);
@@ -746,12 +777,12 @@ static int kernfs_fop_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-void kernfs_unmap_bin_file(struct kernfs_node *kn)
+void kernfs_drain_open_files(struct kernfs_node *kn)
 {
 	struct kernfs_open_node *on;
 	struct kernfs_open_file *of;
 
-	if (!(kn->flags & KERNFS_HAS_MMAP))
+	if (!(kn->flags & (KERNFS_HAS_MMAP | KERNFS_HAS_RELEASE)))
 		return;
 
 	spin_lock_irq(&kernfs_open_node_lock);
@@ -763,10 +794,16 @@ void kernfs_unmap_bin_file(struct kernfs_node *kn)
 		return;
 
 	mutex_lock(&kernfs_open_file_mutex);
+
 	list_for_each_entry(of, &on->files, list) {
 		struct inode *inode = file_inode(of->file);
-		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+		if (kn->flags & KERNFS_HAS_MMAP)
+			unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+		kernfs_release_file(kn, of);
 	}
+
 	mutex_unlock(&kernfs_open_file_mutex);
 
 	kernfs_put_open_node(kn, NULL);
@@ -965,6 +1002,8 @@ struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 		kn->flags |= KERNFS_HAS_SEQ_SHOW;
 	if (ops->mmap)
 		kn->flags |= KERNFS_HAS_MMAP;
+	if (ops->release)
+		kn->flags |= KERNFS_HAS_RELEASE;
 
 	rc = kernfs_add_one(kn);
 	if (rc) {
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index bfd551b..3100987 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -104,7 +104,7 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
  */
 extern const struct file_operations kernfs_file_fops;
 
-void kernfs_unmap_bin_file(struct kernfs_node *kn);
+void kernfs_drain_open_files(struct kernfs_node *kn);
 
 /*
  * symlink.c
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index afd4e5a..a9b11b8 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -46,6 +46,7 @@ enum kernfs_node_flag {
 	KERNFS_SUICIDAL		= 0x0400,
 	KERNFS_SUICIDED		= 0x0800,
 	KERNFS_EMPTY_DIR	= 0x1000,
+	KERNFS_HAS_RELEASE	= 0x2000,
 };
 
 /* @flags for kernfs_create_root() */
@@ -175,6 +176,7 @@ struct kernfs_open_file {
 	/* published fields */
 	struct kernfs_node	*kn;
 	struct file		*file;
+	struct seq_file		*seq_file;
 	void			*priv;
 
 	/* private fields, do not use outside kernfs proper */
@@ -186,11 +188,19 @@ struct kernfs_open_file {
 
 	size_t			atomic_write_len;
 	bool			mmapped:1;
+	bool			released:1;
 	const struct vm_operations_struct *vm_ops;
 };
 
 struct kernfs_ops {
 	/*
+	 * Optional open/release methods.  Both are called with
+	 * @of->seq_file populated.
+	 */
+	int (*open)(struct kernfs_open_file *of);
+	void (*release)(struct kernfs_open_file *of);
+
+	/*
 	 * Read is handled by either seq_file or raw_read().
 	 *
 	 * If seq_show() is present, seq_file path is active.  Other seq
-- 
2.9.3


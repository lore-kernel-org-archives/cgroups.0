Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043039;
	b=gipEBRXHi1D9Zl3hrjBZU/hWARDrXMTZPku8y4iPZRtPRoON5Fn3THF8qDqbnvanvTzM
	 yDOa1DyREnQLzgu0AUl2/Sx9/lmMqIw1TrzNtpZl5n8mFgpvM9mI+yfydSsLmWBXE3Qe9
	 Awv8boPuVkI7lZuLHePTwhSgEnDDzWzvRiUaJ9jM9LemtiUUcGas3jvCf5xje6U8kHJDT
	 zg4Pxh12IE0nXZOJzKU/r3lkR61jvcPAmbSKBqJk1rj7nBNLpTd1WP56ff+j1sn7rX2OS
	 LoatjTzAfRXhgr/CFD3W1NPQlQBzbU0rpDbDlUwY7nK++AYf1YaZDm0f4jL2hJ7W4Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043039;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LYuA5k8Q5G3bvObPmzEGjHYjfh5cZ3ol0+B9dG9s82g=;
	b=nx2SUN9zsG0bmYH2D3UKedIv9AbLtYJHk0iVjynKKF0SyZ2NbD1qKMNa71SHGWDygXIc
	 mvP2dETyFmbxnlGHo2zKBtGIQNLaTlkPmayKN4eW68mQ2mZdtp0E/PPAIXUAAOJW3v7C6
	 NCYLMYLVssOaiKZBxayA7fJJ6dG9fn5aKJk7ue5Js1nssb75f0RBPvgXNidqmt0SAhdhu
	 D5eHmuFMB2lCITm2n05mmtUsRxdK6qMSJECaJJLajPLZpS9VX+Ju8lGdypHJ4Anz/RJPO
	 32Mfes7+TjDfieJpsF4oTDKnTjufdWBjs4uLsbotz2pgINcjhGnjcaLQ5rUKt9Wx9Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LunTQyVz;
	arc=none smtp.remote-ip=91.218.175.172
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A9960A261C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 23:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30A9960A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LunTQyVz
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NrOhDzn+O03mDRkyeFyoOgZyaruzpXiA8SMQB9zY2vg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795043035; v=1; x=1795647835;
 b=LunTQyVzpfshMRtlK7gM2oJT3FI44XgmRE2wI21YLu/i63ahd7jEyAAYBGe0zNKH66gGnk4I
 BJHB8UTr5sCRPwJJlVY7gL+C3MVUfd59kpnfjvaOWF8qSg+c8mDe/Jf2lHHEJP5DRrxxyMCxho9
 S2zFFJM+6pLRSGvald5gfkco=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 343db22439ec49d2;
	Wed, 18 Nov 2026 23:03:55 +0000
X-Mizu-Trace-ID: 343db22439ec49d2
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: allocate the inode for cgroup_may_write() before cgroup_mutex
Date: Wed, 18 Nov 2026 15:03:45 -0800
Message-ID: <20261118230346.3700213-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Meta fleet, on 6.16 kernels, the memcg OOM killer ran from
cgroup_may_write() with cgroup_mutex and cgroup_threadgroup_rwsem held.
The callers were systemd in containers and build tools, short of memory
in their own cgroup.  Our lock monitor also saw cgroup_mutex held
across memcg reclaim there, for up to 152 ms.

cgroup_may_write() checks permission on the inode of a cgroup.procs
file.  kernfs frees that inode with its last reference, so it is often
not cached, and kernfs_get_inode() then allocates one, charged to the
caller's memory cgroup, with cgroup_mutex held.  A cgroup.procs write
usually holds cgroup_threadgroup_rwsem too.  While the allocation
reclaims, every cgroup operation, fork and exit on the host waits.
clone3(CLONE_INTO_CGROUP) allocates the same way.

Allocate the inode before taking cgroup_mutex, and add it under
kernfs_rwsem with kernfs_get_inode_locked(), as kernfs lookup does.
The cgroup.procs write allocates after dropping the file's active
reference, because rmdir waits for active references with cgroup_mutex
held.  clone3() checks that the fd is a cgroup2 directory before
allocating on its superblock.

Worst latency in a VM while a task in a full 256 MB memory cgroup moves
a process between two cgroups (60 s, worst of four runs):

                          before    after
  fork and exit            4.9 s     14 ms
  mkdir and rmdir          4.9 s    8.4 ms
  cgroup_mutex held        4.9 s    8.3 ms

Before, each run spent 2 to 16 s in memcg reclaim with cgroup_mutex
held.  After, none.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
This is based on my series "kernfs: stop taking kernfs_iattr_rwsem for
writing in mkdir/rmdir" [1], on top of vfs-7.5.kernfs, as both change
the comment of kernfs_get_inode().

[1] https://lore.kernel.org/all/20261118220154.2965621-1-shakeel.butt@linux.dev/

 fs/kernfs/inode.c      |  28 ++++-----
 include/linux/kernfs.h |   4 +-
 kernel/cgroup/cgroup.c | 128 +++++++++++++++++++++++++++--------------
 3 files changed, 98 insertions(+), 62 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 580095e0fad9..71e19d32e392 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -318,30 +318,24 @@ static void kernfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 }
 
 /**
- *	kernfs_get_inode - get inode for kernfs_node
- *	@sb: super block
- *	@kn: kernfs_node to allocate inode for
+ *	kernfs_get_inode - get the inode of a kernfs_node
+ *	@inode: inode allocated with new_inode() on the target superblock
+ *	@kn: kernfs_node to get the inode for
  *
- *	Get inode for @kn.  If such inode doesn't exist, a new inode is
- *	allocated and basics are initialized.  New inode is returned
- *	locked.
+ *	kernfs_get_inode_locked() for callers outside kernfs.  Allocate
+ *	@inode before taking your own locks, as the allocation can wait for
+ *	reclaim.  @inode is consumed.
  *
  *	Locking:
- *	Kernel thread context (may sleep).  Not for directories: kernfs
- *	sets up their inodes itself, with kernfs_rwsem held.
+ *	Kernel thread context (may sleep).  Takes kernfs_rwsem for reading.
  *
  *	Return:
- *	Pointer to allocated inode on success, %NULL on failure.
+ *	The inode of @kn, or %NULL if @kn is no longer active.
  */
-struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
+struct inode *kernfs_get_inode(struct inode *inode, struct kernfs_node *kn)
 {
-	struct inode *inode;
-
-	inode = iget_locked(sb, kernfs_ino(kn));
-	if (inode && (inode_state_read_once(inode) & I_NEW))
-		kernfs_init_inode(kn, inode);
-
-	return inode;
+	guard(rwsem_read)(&kernfs_root(kn)->kernfs_rwsem);
+	return kernfs_get_inode_locked(inode, kn);
 }
 
 static int kernfs_inode_test(struct inode *inode, void *data)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 803294a67e47..cda9467693da 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -429,7 +429,7 @@ void kernfs_put(struct kernfs_node *kn);
 
 struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
 struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
-struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
+struct inode *kernfs_get_inode(struct inode *inode, struct kernfs_node *kn);
 
 struct dentry *kernfs_node_dentry(struct kernfs_node *kn,
 				  struct super_block *sb);
@@ -528,7 +528,7 @@ static inline struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
 { return NULL; }
 
 static inline struct inode *
-kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
+kernfs_get_inode(struct inode *inode, struct kernfs_node *kn)
 { return NULL; }
 
 static inline struct kernfs_root *
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a284225f8dc9..15e03faedbbc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1664,6 +1664,32 @@ void cgroup_kn_unlock(struct kernfs_node *kn)
 	cgroup_put(cgrp);
 }
 
+/*
+ * Pin the cgroup of @kn and drop @kn's active reference: the part of
+ * cgroup_kn_lock_live() before cgroup_mutex is taken.  cgroup_kn_unlock()
+ * undoes it.
+ */
+static struct cgroup *cgroup_kn_break_active(struct kernfs_node *kn)
+{
+	struct cgroup *cgrp;
+
+	if (kernfs_type(kn) == KERNFS_DIR)
+		cgrp = kn->priv;
+	else
+		cgrp = kn_priv(kn);
+
+	/*
+	 * We're gonna grab cgroup_mutex which nests outside kernfs
+	 * active_ref.  cgroup liveliness check alone provides enough
+	 * protection against removal.  Ensure @cgrp stays accessible and
+	 * break the active_ref protection.
+	 */
+	if (!cgroup_tryget(cgrp))
+		return ERR_PTR(-ENODEV);
+	kernfs_break_active_protection(kn);
+	return cgrp;
+}
+
 /**
  * cgroup_kn_lock_live - locking helper for cgroup kernfs methods
  * @kn: the kernfs_node being serviced
@@ -1687,20 +1713,9 @@ struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn, bool drain_offline)
 	struct cgroup *cgrp;
 	int ret;
 
-	if (kernfs_type(kn) == KERNFS_DIR)
-		cgrp = kn->priv;
-	else
-		cgrp = kn_priv(kn);
-
-	/*
-	 * We're gonna grab cgroup_mutex which nests outside kernfs
-	 * active_ref.  cgroup liveliness check alone provides enough
-	 * protection against removal.  Ensure @cgrp stays accessible and
-	 * break the active_ref protection.
-	 */
-	if (!cgroup_tryget(cgrp))
-		return ERR_PTR(-ENODEV);
-	kernfs_break_active_protection(kn);
+	cgrp = cgroup_kn_break_active(kn);
+	if (IS_ERR(cgrp))
+		return cgrp;
 
 	if (drain_offline) {
 		ret = cgroup_lock_and_drain_offline(cgrp);
@@ -5424,16 +5439,23 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int cgroup_may_write(const struct cgroup *cgrp, struct super_block *sb)
+/*
+ * *@new is an inode from new_inode(), allocated before cgroup_mutex as the
+ * allocation can wait for reclaim.  This uses it up and sets *@new to NULL.
+ */
+static int cgroup_may_write(const struct cgroup *cgrp, struct inode **new)
 {
+	struct inode *inode = *new;
 	int ret;
-	struct inode *inode;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
+	*new = NULL;
 	if (!inode)
 		return -ENOMEM;
+	inode = kernfs_get_inode(inode, cgrp->procs_file.kn);
+	if (!inode)
+		return -ENODEV;
 
 	ret = inode_permission(&nop_mnt_idmap, inode, MAY_WRITE);
 	iput(inode);
@@ -5442,7 +5464,7 @@ static int cgroup_may_write(const struct cgroup *cgrp, struct super_block *sb)
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb,
+					 struct inode **new,
 					 struct cgroup_namespace *ns)
 {
 	struct cgroup *com_cgrp = src_cgrp;
@@ -5455,7 +5477,7 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 		com_cgrp = cgroup_parent(com_cgrp);
 
 	/* %current should be authorized to migrate to the common ancestor */
-	ret = cgroup_may_write(com_cgrp, sb);
+	ret = cgroup_may_write(com_cgrp, new);
 	if (ret)
 		return ret;
 
@@ -5473,12 +5495,12 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 
 static int cgroup_attach_permissions(struct cgroup *src_cgrp,
 				     struct cgroup *dst_cgrp,
-				     struct super_block *sb, bool threadgroup,
+				     struct inode **new, bool threadgroup,
 				     struct cgroup_namespace *ns)
 {
 	int ret = 0;
 
-	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb, ns);
+	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, new, ns);
 	if (ret)
 		return ret;
 
@@ -5498,12 +5520,25 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	struct inode *new;
 	ssize_t ret;
 	enum cgroup_attach_lock_mode lock_mode;
 
-	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
+	/*
+	 * Allocate the inode cgroup_may_write() may need before taking
+	 * cgroup_mutex and with the file's active reference dropped: the
+	 * allocation can wait for reclaim, and rmdir waits for active
+	 * references with cgroup_mutex held.
+	 */
+	dst_cgrp = cgroup_kn_break_active(of->kn);
 	if (IS_ERR(dst_cgrp))
 		return PTR_ERR(dst_cgrp);
+	new = new_inode(of->file->f_path.dentry->d_sb);
+	cgroup_lock();
+	if (cgroup_is_dead(dst_cgrp)) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
 
 	task = cgroup_procs_write_start(buf, threadgroup, &lock_mode);
 	ret = PTR_ERR_OR_ZERO(task);
@@ -5521,8 +5556,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	 * inherited fd attacks.
 	 */
 	scoped_with_creds(of->file->f_cred)
-		ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
-						of->file->f_path.dentry->d_sb,
+		ret = cgroup_attach_permissions(src_cgrp, dst_cgrp, &new,
 						threadgroup, ctx->ns);
 	if (ret)
 		goto out_finish;
@@ -5533,7 +5567,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	cgroup_procs_write_finish(task, lock_mode);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
-
+	iput(new);
 	return ret;
 }
 
@@ -6924,13 +6958,31 @@ static void cgroup_fork_child_unlock(struct task_struct *child)
 static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 	__acquires(&cgroup_mutex) __acquires(&cgroup_threadgroup_rwsem)
 {
+	struct inode *new_dst = NULL, *new_com = NULL;
+	struct file *file = NULL;
 	int ret;
 	struct cgroup *dst_cgrp = NULL;
 	struct css_set *cset;
-	struct super_block *sb;
 
-	if (kargs->flags & CLONE_INTO_CGROUP)
+	if (kargs->flags & CLONE_INTO_CGROUP) {
+		/*
+		 * Allocate the inodes cgroup_may_write() may need before
+		 * taking cgroup_mutex, as the allocation can wait for reclaim.
+		 * Check first that the fd is a cgroup2 directory, so they are
+		 * allocated on a cgroup2 superblock.
+		 */
+		file = fget_raw(kargs->cgroup);
+		if (!file)
+			return -EBADF;
+		dst_cgrp = cgroup_get_from_file(file);
+		if (IS_ERR(dst_cgrp)) {
+			fput(file);
+			return PTR_ERR(dst_cgrp);
+		}
+		new_dst = new_inode(file->f_path.dentry->d_sb);
+		new_com = new_inode(file->f_path.dentry->d_sb);
 		cgroup_lock();
+	}
 
 	cgroup_threadgroup_change_begin(current);
 
@@ -6945,20 +6997,6 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 		return 0;
 	}
 
-	CLASS(fd_raw, f)(kargs->cgroup);
-	if (fd_empty(f)) {
-		ret = -EBADF;
-		goto err;
-	}
-	sb = fd_file(f)->f_path.dentry->d_sb;
-
-	dst_cgrp = cgroup_get_from_file(fd_file(f));
-	if (IS_ERR(dst_cgrp)) {
-		ret = PTR_ERR(dst_cgrp);
-		dst_cgrp = NULL;
-		goto err;
-	}
-
 	if (cgroup_is_dead(dst_cgrp)) {
 		ret = -ENODEV;
 		goto err;
@@ -6969,7 +7007,7 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 	 * usually done by the vfs layer but since we're not going through
 	 * the vfs layer here we need to do it "manually".
 	 */
-	ret = cgroup_may_write(dst_cgrp, sb);
+	ret = cgroup_may_write(dst_cgrp, &new_dst);
 	if (ret)
 		goto err;
 
@@ -6987,7 +7025,7 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 	 * cgroup.procs of the cgroup indicated by @dfd_cgroup. This allows us
 	 * to always use the caller's credentials.
 	 */
-	ret = cgroup_attach_permissions(cset->dfl_cgrp, dst_cgrp, sb,
+	ret = cgroup_attach_permissions(cset->dfl_cgrp, dst_cgrp, &new_com,
 					!(kargs->flags & CLONE_THREAD),
 					current->nsproxy->cgroup_ns);
 	if (ret)
@@ -7002,11 +7040,15 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 	put_css_set(cset);
 	kargs->cgrp = dst_cgrp;
 	kargs->kill_seq = dst_cgrp->kill_seq;
+	fput(file);
 	return ret;
 
 err:
 	cgroup_threadgroup_change_end(current);
 	cgroup_unlock();
+	iput(new_dst);
+	iput(new_com);
+	fput(file);
 	if (dst_cgrp)
 		cgroup_put(dst_cgrp);
 	put_css_set(cset);

base-commit: ccf2a4692fed0fa77751d32d2690585127a152c5
-- 
2.53.1-Meta


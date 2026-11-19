Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.95
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115975;
	b=Ak5qdxt4ehNaRi/N2dHlPuCzgtcutT/umozG4lu2vHI+eHhojOdbyO3O0pBORDUgL7J6
	 BvoT2GIaH6Jx8KUpNGclNjBI8VngOKcqgP+PZb+d3wO3sxy65VqXZk+4A1IAjNNYC7guB
	 b1EnUK52az0meJlQl3ajXjaQry0n+Gk1KUSfNSVe/QQmDQzzmJ/QxlByqK5eBDZ+ro5tT
	 WrVZvil2fwMrFqV9FCCeIckGNselQxYeOA8N4B09sVr2w3mimxOmUEReawnDgjC++Equk
	 IqjwytecR7vRAcyx1RL2Dl36jroZ88xAUbocHpkL2il8kU6+DdNzuPUIiCibP/VGegA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115975;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=BZCkI+AJVrTn6rAyjDMACqLXCym//kL8/ECfN+OzY5g=;
	b=oM8TGtIQ9GLh+XWeK9wdofqddxlJGq+h4AHcPxD9V8CCpmlKRMud6qqeqQ6GX/oqSfjf
	 fXWrdj2F8VXZnAqgovXKDN7g1n+aZL/hw54iIHnkZpRYMErOYnlEhxnQq4vFLVlIK2w0T
	 Z92bZxC8OBayRPwsFibpsG3xP914D2Qk+bgNobJioAKOiTDOgfEd4Ql3mfcMi0Won/jmm
	 SRpikfh6M1gy+26+7+0fvzxr/8pISUhen8UfVFPCiTo3b9Mr+JTOlM/sLdUUTgOwHzvLb
	 M3A0HAwYZSgaVuQCupfkDJ8RZECIBFt/WLCUuNhTU4If2jy3VgkHYtO8xrru/mwoekg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CIsk0BJD;
	arc=none smtp.remote-ip=95.215.58.95
Received: from mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B1A606A325
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 19:19:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59B1A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CIsk0BJD
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ryss+itbMtDgDKKvNsoonliuWcCUhWr1JohLRFsYU4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795115972; v=1; x=1795720772;
 b=CIsk0BJD8ESIevYfaPxQkq53kBzG+UqePadU9vZN4hcRzpwkBDctK4+6HMG0PorHnym463ka
 1Umsdx4iHUmfyZ0IOqYV6KJ+Lra3U1zhD32BpWKjWiON8DWQZg2+8AwzwMIVXpl9CRIJ4QXUgqJ
 d7uf8I7cU5nAMXsVbCxA4MLo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f7ac90210d8047b6;
	Thu, 19 Nov 2026 19:19:32 +0000
X-Mizu-Trace-ID: f7ac90210d8047b6
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kernfs: allocate in open before taking the active reference
Date: Thu, 19 Nov 2026 11:19:22 -0800
Message-ID: <20261119191923.2223993-1-shakeel.butt@linux.dev>
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

kernfs_fop_open() allocates the open file, its seq_file and the open
node while holding the file's active reference.  The seq_file is
charged to the opener's memory cgroup, so in a cgroup at its limit the
allocation reclaims.  Removing the file waits for active references.
cgroup rmdir does that with cgroup_mutex held, so every cgroup
operation on the host waits for that reclaim.  Deleting a netdev waits
the same way with rtnl_lock held.

Allocate them before taking the active reference.  kn->flags already
says whether the file has ->seq_show, which is all seq_open() needs.
If the file is removed in the meantime, open fails with -ENODEV as
before.  Only the prealloc buffer, whose size comes from the ops, and
->open() still allocate under the active reference.

In a VM, eight tasks in a 256 MB memory cgroup at its limit, with swap
writes taking 500 ms, open and read small files of a cgroup that
another task removes and recreates every 20 ms (60 s, worst of four
runs):

                                           before    after
  reclaim with an active reference held     5.0 s        0
  rmdir waiting for it, cgroup_mutex held  377 ms   6.3 ms
  mkdir/rmdir of other cgroups             382 ms   125 ms

The rest of the mkdir/rmdir time is waiting for kernfs_rwsem.  Opening
and closing cgroup files in a loop is as fast as before.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
This applies on vfs-7.5.kernfs, with or without my kernfs_iattr_rwsem
series [1].

[1] https://lore.kernel.org/all/20261118220154.2965621-1-shakeel.butt@linux.dev/

 fs/kernfs/file.c | 106 ++++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 47 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 10ee357b388e..08c29eb3f435 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -512,9 +512,11 @@ static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
  *	kernfs_get_open_node - get or create kernfs_open_node
  *	@kn: target kernfs_node
  *	@of: kernfs_open_file for this instance of open
+ *	@new_on: kernfs_open_node allocated by the caller, or %NULL
  *
  *	If @kn->attr.open exists, increment its reference count; otherwise,
- *	create one.  @of is chained to the files list.
+ *	create one, from @new_on if given.  @of is chained to the files list.
+ *	@new_on is consumed.
  *
  *	Locking:
  *	Kernel thread context (may sleep).
@@ -523,19 +525,12 @@ static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
  *	%0 on success, -errno on failure.
  */
 static int kernfs_get_open_node(struct kernfs_node *kn,
-				struct kernfs_open_file *of)
+				struct kernfs_open_file *of,
+				struct kernfs_open_node *new_on)
 {
-	struct kernfs_open_node *on, *new_on = NULL;
+	struct kernfs_open_node *on;
 	struct mutex *mutex;
 
-	/*
-	 * Peek without the mutex: if nothing has this open, we will need a
-	 * node and can allocate before taking a mutex shared by every node
-	 * hashing to it.
-	 */
-	if (!rcu_access_pointer(kn->attr.open))
-		new_on = kzalloc_obj(*new_on);
-
 	mutex = kernfs_open_file_mutex_lock(kn);
 	on = kernfs_deref_open_node_locked(kn);
 
@@ -544,7 +539,7 @@ static int kernfs_get_open_node(struct kernfs_node *kn,
 		on = new_on;
 		new_on = NULL;
 		if (!on) {
-			/* the peek raced; rare, so allocate here */
+			/* the caller's peek raced; rare, so allocate here */
 			on = kzalloc_obj(*on);
 			if (!on) {
 				mutex_unlock(mutex);
@@ -618,13 +613,52 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 {
 	struct kernfs_node *kn = inode->i_private;
 	struct kernfs_root *root = kernfs_root(kn);
+	struct kernfs_open_node *new_on = NULL;
 	const struct kernfs_ops *ops;
 	struct kernfs_open_file *of;
 	bool has_read, has_write, has_mmap, no_splice_write;
-	int error = -EACCES;
+	int error;
+
+	/*
+	 * Allocate before taking the active reference.  Removing @kn waits
+	 * for active references, often with a global lock held (cgroup rmdir
+	 * holds cgroup_mutex), and the seq_file is charged to the opener's
+	 * memory cgroup, so allocating can wait for reclaim.  Only the
+	 * prealloc buffer, which needs @ops, and ->open() allocate under the
+	 * active reference.
+	 */
+	of = kzalloc_obj(struct kernfs_open_file);
+	if (!of)
+		return -ENOMEM;
+
+	/*
+	 * Always instantiate seq_file even if read access doesn't use
+	 * seq_file or is not requested.  This unifies private data access
+	 * and readable regular files are the vast majority anyway.
+	 * kn->flags tells whether there is ->seq_show, without @ops.  Other
+	 * bits of it can change meanwhile, hence READ_ONCE().
+	 */
+	if (READ_ONCE(kn->flags) & KERNFS_HAS_SEQ_SHOW)
+		error = seq_open(file, &kernfs_seq_ops);
+	else
+		error = seq_open(file, NULL);
+	if (error)
+		goto err_free;
 
+	of->seq_file = file->private_data;
+	of->seq_file->private = of;
+
+	/* seq_file clears PWRITE unconditionally, restore it if WRITE */
+	if (file->f_mode & FMODE_WRITE)
+		file->f_mode |= FMODE_PWRITE;
+
+	/* if nothing has @kn open, we will need a new open node too */
+	if (!rcu_access_pointer(kn->attr.open))
+		new_on = kzalloc_obj(*new_on);
+
+	error = -ENODEV;
 	if (!kernfs_get_active(kn))
-		return -ENODEV;
+		goto err_seq_release;
 
 	ops = kernfs_ops(kn);
 
@@ -633,22 +667,17 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	has_mmap = ops->mmap;
 
 	/* see the flag definition for details */
+	error = -EACCES;
 	if (root->flags & KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK) {
 		if ((file->f_mode & FMODE_WRITE) &&
 		    (!(inode->i_mode & S_IWUGO) || !has_write))
-			goto err_out;
+			goto err_put_active;
 
 		if ((file->f_mode & FMODE_READ) &&
 		    (!(inode->i_mode & S_IRUGO) || !has_read))
-			goto err_out;
+			goto err_put_active;
 	}
 
-	/* allocate a kernfs_open_file for the file */
-	error = -ENOMEM;
-	of = kzalloc_obj(struct kernfs_open_file);
-	if (!of)
-		goto err_out;
-
 	/*
 	 * Splice callbacks need this before the iter paths acquire an active
 	 * reference, so cache it while @kn is active.
@@ -707,31 +736,16 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	 * ->read must be used instead.
 	 */
 	if (ops->prealloc && ops->seq_show)
-		goto err_free;
+		goto err_put_active;
 	if (ops->prealloc) {
 		int len = of->atomic_write_len ?: PAGE_SIZE;
 		of->prealloc_buf = kmalloc(len + 1, GFP_KERNEL);
 		error = -ENOMEM;
 		if (!of->prealloc_buf)
-			goto err_free;
+			goto err_put_active;
 		mutex_init(&of->prealloc_mutex);
 	}
 
-	/*
-	 * Always instantiate seq_file even if read access doesn't use
-	 * seq_file or is not requested.  This unifies private data access
-	 * and readable regular files are the vast majority anyway.
-	 */
-	if (ops->seq_show)
-		error = seq_open(file, &kernfs_seq_ops);
-	else
-		error = seq_open(file, NULL);
-	if (error)
-		goto err_free;
-
-	of->seq_file = file->private_data;
-	of->seq_file->private = of;
-
 	/*
 	 * seq_read_iter() takes @of->mutex under the seq_file lock, whose key
 	 * is shared with seq_files that can be spliced. Separate it too.
@@ -742,14 +756,11 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 		lockdep_set_class(&of->seq_file->lock, &seq_no_splice_key);
 	}
 
-	/* seq_file clears PWRITE unconditionally, restore it if WRITE */
-	if (file->f_mode & FMODE_WRITE)
-		file->f_mode |= FMODE_PWRITE;
-
 	/* make sure we have open node struct */
-	error = kernfs_get_open_node(kn, of);
+	error = kernfs_get_open_node(kn, of, new_on);
+	new_on = NULL;
 	if (error)
-		goto err_seq_release;
+		goto err_put_active;
 
 	if (ops->open) {
 		/* nobody has access to @of yet, skip @of->mutex */
@@ -764,13 +775,14 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 
 err_put_node:
 	kernfs_unlink_open_file(kn, of, true);
+err_put_active:
+	kernfs_put_active(kn);
 err_seq_release:
+	kfree(new_on);
 	seq_release(inode, file);
 err_free:
 	kfree(of->prealloc_buf);
 	kfree(of);
-err_out:
-	kernfs_put_active(kn);
 	return error;
 }
 

base-commit: ccf2a4692fed0fa77751d32d2690585127a152c5
-- 
2.53.1-Meta


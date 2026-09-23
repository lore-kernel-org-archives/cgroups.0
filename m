Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5624156F9
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 05:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139735; cv=none; b=mHOjbcJWvV67RZad3iDpCLPhx1o7051jCdfQUX7CApljt31gQL9bHRq4oVbF04YZG8d/TAJTX71IMdm7hH20Y5q3l0utB+DL8J+4mt7cth8qc5s+v6Cvyouk39S03zN7VUcpwTk0LJbA/JrEkcpb8RxnkGeSPIZWCL6Asj0qouE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139735; c=relaxed/simple;
	bh=Ne424r/36je1ilOD3xcuRjIqebPC+88WgD6Zv6z4z2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tt/s6cQbpk0PERyzqg7WP3AmNfRc0bTUQjQp+ifttrsVxnjpXXm3SctzhxlmwGs79zgs57VS7HTT63zxwm7SJHBI9/0krxT0rIwPtX8+F/AEM/fOCYCk52ak3VHeo9WfxyUcXMsrX7f7MJi77ouxBUXuEapFhsS7mhjYf0N9hB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MqqukM1i; arc=none smtp.client-ip=95.215.58.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MqqukM1i"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ne424r/36je1ilOD3xcuRjIqebPC+88WgD6Zv6z4z2Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790139722; v=1; x=1790744522;
 b=MqqukM1iIkX8IkBIEf0Je2ojvZGcQG9vOPWG/aCg/t84hFTKtICfewFYpI2/duZAbHww/dGd
 BvG5Cqu6fmG95Ma/Tvzt22aMe2DDh6sSPlG4GZrXiM2ZtCKEM+ZalQ2V5BlHmMZzigU7ckvwLlX
 SZhQOFrUQVnndOwB7DR3bteo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 690595ff149c6af3;
	Wed, 23 Sep 2026 05:02:02 +0000
X-Mizu-Trace-ID: 690595ff149c6af3
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Paul McKenney <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] kernfs, cgroup: track holders of the cgroupfs locks
Date: Tue, 22 Sep 2026 22:01:24 -0700
Message-ID: <dc9606b5cf7cd2d6f326917db6a9bbc44dc88f9e.1790139577.git.shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790139577.git.shakeel.butt@linux.dev>
References: <cover.1790139577.git.shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Opt the cgroupfs kernfs rwsems, cgroup_mutex and cgroup_threadgroup_rwsem
in to lock holder tracking.

Add KERNFS_ROOT_TRACK_LOCK_HOLDERS, which opts in a root's kernfs_rwsem,
kernfs_iattr_rwsem and kernfs_supers_rwsem, and pass it from
cgroup_setup_root(). Other kernfs users have their own roots, so only
cgroupfs is affected. All three are held across work that can allocate,
so a holder stuck in reclaim can stall many other cgroupfs operations;
kernfs_iattr_rwsem is write-held across kernfs_iattrs(), which allocates
with GFP_KERNEL.

cgroup_mutex is taken by every cgroup create, destroy and migrate, and is
held across the same kind of work, so a stalled holder stalls the whole
cgroupfs control plane.

cgroup_threadgroup_rwsem is taken for read on every fork and exit, and
usually for write on migration, so a stalled holder can stall process
creation on the whole machine.

The last two are statically defined, so opt them in from cgroup_init().
That runs after jump_label_init() and before anything can take either
lock.

signal->cgroup_threadgroup_rwsem, used with favordynmods, is left alone.
Its readers also hold cgroup_threadgroup_rwsem, so they are counted
already, and its writer only blocks the process being migrated.

These opt-ins are for a policy that reads the count. On their own they
only turn on the static branch, so they should go in with that policy.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/kernfs/dir.c        |  5 +++++
 include/linux/kernfs.h |  7 +++++++
 kernel/cgroup/cgroup.c | 27 ++++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index cc6288d5b4cc..1116bb38c1ff 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1035,6 +1035,11 @@ struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 	init_rwsem(&root->kernfs_rwsem);
 	init_rwsem(&root->kernfs_iattr_rwsem);
 	init_rwsem(&root->kernfs_supers_rwsem);
+	if (flags & KERNFS_ROOT_TRACK_LOCK_HOLDERS) {
+		rwsem_track_holder(&root->kernfs_rwsem);
+		rwsem_track_holder(&root->kernfs_iattr_rwsem);
+		rwsem_track_holder(&root->kernfs_supers_rwsem);
+	}
 	INIT_LIST_HEAD(&root->supers);
 	rwlock_init(&root->kernfs_rename_lock);
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 73786b567ccd..ea2efdc5277e 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -156,6 +156,13 @@ enum kernfs_root_flag {
 	 * Renames must not change the parent node.
 	 */
 	KERNFS_ROOT_INVARIANT_PARENT		= 0x0010,
+
+	/*
+	 * Track the holders of this root's rwsems (see
+	 * CONFIG_TRACK_LOCK_HOLDERS).  Use it for roots whose locks are
+	 * shared so widely that a stalled holder stalls unrelated work.
+	 */
+	KERNFS_ROOT_TRACK_LOCK_HOLDERS		= 0x0020,
 };
 
 /* type-specific structures for kernfs_node union members */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 804318ae160e..87d66aae2558 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2191,11 +2191,18 @@ int cgroup_setup_root(struct cgroup_root *root, u32 ss_mask)
 	kf_sops = root == &cgrp_dfl_root ?
 		&cgroup_kf_syscall_ops : &cgroup1_kf_syscall_ops;
 
+	/*
+	 * Track the holders of the cgroupfs kernfs locks.  They are held
+	 * across work that can charge memory, so a holder stuck in reclaim
+	 * can stall many other cgroupfs operations.  Other kernfs users have
+	 * their own roots and are not affected.
+	 */
 	root->kf_root = kernfs_create_root(kf_sops,
 					   KERNFS_ROOT_CREATE_DEACTIVATED |
 					   KERNFS_ROOT_SUPPORT_EXPORTOP |
 					   KERNFS_ROOT_SUPPORT_USER_XATTR |
-					   KERNFS_ROOT_INVARIANT_PARENT,
+					   KERNFS_ROOT_INVARIANT_PARENT |
+					   KERNFS_ROOT_TRACK_LOCK_HOLDERS,
 					   root_cgrp);
 	if (IS_ERR(root->kf_root)) {
 		ret = PTR_ERR(root->kf_root);
@@ -6552,6 +6559,24 @@ int __init cgroup_init(void)
 	get_user_ns(init_cgroup_ns.user_ns);
 	cgroup_rt_init();
 
+	/*
+	 * cgroup_mutex is taken by every cgroup create, destroy and migrate
+	 * and is held across work that can allocate, so a holder stuck in
+	 * reclaim stalls the whole cgroupfs control plane.
+	 *
+	 * cgroup_threadgroup_rwsem is taken for read by fork and exit, and
+	 * usually for write by migration, so a stalled holder can stall
+	 * process creation on the whole machine.
+	 *
+	 * Neither can be held yet, as rest_init() has not run.
+	 *
+	 * signal->cgroup_threadgroup_rwsem is not tracked.  Its readers hold
+	 * cgroup_threadgroup_rwsem too, so they are counted already, and its
+	 * writer only blocks the process being migrated.
+	 */
+	mutex_track_holder(&cgroup_mutex);
+	percpu_rwsem_track_holder(&cgroup_threadgroup_rwsem);
+
 	cgroup_lock();
 
 	/*
-- 
2.53.0-Meta


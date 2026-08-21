Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ADB3F5BE4
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 05:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288733; cv=none; b=SQ4YVXseykNKYGqUcCMmXFjIVa4HH8dw7/gHVkTXLUq/oadPBIsggOh2sXWRgAt06+WF7aHHGLsji92AbNGJ/ZuRhf3LTKCoUROz/lYWlT7t3QkTpnFlYSBIWQ4muOtfV+kniDsE7aV2w3Ly+MGEliU9HpkTujMW/Nzq6E12xak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288733; c=relaxed/simple;
	bh=53i/STOUHRyVxCyimladd4nzeFEb3TLbeSjH6w1ciak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0K/Uf91/5IJC8Ng7uj/0gw5LxqkboXm9OBB+HciclOiUGlmf4IjhoufAMQj2cALUBtsX4GDA3l9L+x5nbnPzVk9SSxfioYTD660zkh/BsLBFXDyIid1v1CVTE853zXKJdFSGAqnbqYCPSE3zPrlO+YusKncl1XTDqar2//qw1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SEU4aZ9d; arc=none smtp.client-ip=91.218.175.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SEU4aZ9d"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=53i/STOUHRyVxCyimladd4nzeFEb3TLbeSjH6w1ciak=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787288729; v=1; x=1787893529;
 b=SEU4aZ9dMavPOOaxOZ0q/SrbIpW9XpJdDODXzx7XD5gmd4/N13PrudZriqwMuibno0xO3ERJ
 7Hi3AcXpZFfcjlICn/42NnDK7pDi3yrT+pSbNdrDocoCxf7qKwmRwcLXIlULBO9/uMNwGPHC775
 EpFesQPcFv+sFE0f0AryIkEU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:8::)
	by smtp.migadu.com with ESMTPS id cc4b1c61de8fdc04;
	Fri, 21 Aug 2026 05:05:29 +0000
X-Mizu-Trace-ID: cc4b1c61de8fdc04
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christian@brauner.io>,
	Meta kernel team <kernel-team@meta.com>,
	driver-core@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
Date: Thu, 20 Aug 2026 22:05:07 -0700
Message-ID: <20260821050507.2161607-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260821050507.2161607-1-shakeel.butt@linux.dev>
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kernfs_dop_revalidate() takes kernfs_rwsem for read once per path component
of every walk into a kernfs mount. Linux rwsems do not permit reader lock
stealing once a writer is queued, so a single writer parks the whole
incoming reader stream in uninterruptible sleep, stalling cgroup-polling
daemons for minutes.

Nothing the callback reads requires the semaphore. kn->active is an
atomic_t that kernfs_find_and_get_node_by_id() already tests through
__kernfs_active(); kn->__parent and kn->name are RCU pointers whose old
values are freed only after a grace period; kn->ns is now compared rather
than dereferenced; parent->dir.rev was annotated earlier in this series.

What the semaphore does provide is a coherent snapshot, and that is not
needed. ->d_revalidate() answers a question about a single instant, and the
answer is already stale when it returns: a rename landing just after
up_read() gives the same outcome as one observed mid-read. A lockless
reader can only return "valid" for the (parent, name, namespace) triple
identifying the dentry it was handed, and that triple was true when the
dentry was instantiated, so it reports a genuine past state exactly as the
locked version did. Removal is backstopped by kernfs_get_active() failing
in the subsequent open().

Take an RCU read lock instead. kernfs_parent() and kernfs_rcu_name() work
unchanged: the condition in their rcu_dereference_check() is an alternative
to holding the RCU read lock, not an extra requirement. The negative dentry
path needs nothing, as @dir pins the parent. The namespace check can use
@parent directly once the preceding check establishes it equals
kernfs_parent(kn), so the kn_parent local and its NULL test go away.

kernfs_ns_enabled() reads @parent->flags, which KERNFS_ACTIVATED and
KERNFS_REMOVING update as a plain read-modify-write under kernfs_rwsem.
Those bits are not read here and KERNFS_NS cannot change once the directory
has children, so mark the read data_race() rather than READ_ONCE(), which
would not silence KCSAN against the unmarked writers anyway.

kernfs_iop_permission() still forces every walk out of RCU-walk before
children are revalidated, so lifting the LOOKUP_RCU bail here would have no
observable effect; it is left to the series fixing that path.

Readers walking cgroupfs and sysfs against concurrent cgroup and netdev
churn: kernfs_rwsem read acquisitions drop from 48,593,360 to 1,280,280,
and kernfs_dop_revalidate() no longer appears among its contention sites.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/kernfs/dir.c | 49 ++++++++++++++++++++-----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 27949b0e027c..cd7a8ff8b6b2 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1171,9 +1171,8 @@ struct kernfs_node *kernfs_create_empty_dir(struct kernfs_node *parent,
 static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
 				 struct dentry *dentry, unsigned int flags)
 {
-	struct kernfs_node *kn, *kn_parent;
 	struct kernfs_node *parent = dir->i_private;
-	struct kernfs_root *root;
+	struct kernfs_node *kn;
 	const char *kn_name;
 
 	if (flags & LOOKUP_RCU)
@@ -1191,49 +1190,41 @@ static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
 		 * changes and the lookup re-done so that a new positive
 		 * dentry can be properly created.
 		 */
-		root = kernfs_root(parent);
-		down_read(&root->kernfs_rwsem);
-		if (kernfs_dir_changed(parent, dentry)) {
-			up_read(&root->kernfs_rwsem);
-			return 0;
-		}
-		up_read(&root->kernfs_rwsem);
-
-		/* The kernfs parent node hasn't changed, leave the
-		 * dentry negative and return success.
-		 */
-		return 1;
+		return !kernfs_dir_changed(parent, dentry);
 	}
 
 	kn = kernfs_dentry_node(dentry);
-	root = kernfs_root(kn);
-	down_read(&root->kernfs_rwsem);
+
+	guard(rcu)();
 
 	/* The kernfs node has been deactivated */
-	if (!kernfs_active(kn))
-		goto out_bad;
+	if (!__kernfs_active(kn))
+		return 0;
 
-	kn_parent = kernfs_parent(kn);
 	/* The kernfs node has been moved? */
-	if (parent != kn_parent)
-		goto out_bad;
+	if (kernfs_parent(kn) != parent)
+		return 0;
 
 	/* The kernfs node has been renamed */
 	kn_name = kernfs_rcu_name(kn);
 	if (name->len != strlen(kn_name) ||
 	    memcmp(name->name, kn_name, name->len))
-		goto out_bad;
+		return 0;
 
-	/* The kernfs node has been moved to a different namespace */
-	if (kn_parent && kernfs_ns_enabled(kn_parent) &&
+	/*
+	 * The kernfs node has been moved to a different namespace.
+	 *
+	 * KERNFS_NS is set by kernfs_enable_ns() while @parent still has no
+	 * children, so it cannot change while a child of @parent is being
+	 * revalidated. The other bits in that word, KERNFS_ACTIVATED and
+	 * KERNFS_REMOVING, are updated under kernfs_rwsem and are not read
+	 * here, so racing with them is intentional and harmless.
+	 */
+	if (data_race(kernfs_ns_enabled(parent)) &&
 	    kernfs_info(dir->i_sb)->ns != READ_ONCE(kn->ns))
-		goto out_bad;
+		return 0;
 
-	up_read(&root->kernfs_rwsem);
 	return 1;
-out_bad:
-	up_read(&root->kernfs_rwsem);
-	return 0;
 }
 
 const struct dentry_operations kernfs_dops = {
-- 
2.53.0-Meta


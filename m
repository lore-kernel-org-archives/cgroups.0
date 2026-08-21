Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D07E3EC817
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288724; cv=none; b=sM7hif05fUe/bDsbkE2dArvsciIC9cRU0cIwCvYQThPHbstYXzH/R3qfggWq8ionci5gdfXppRUpA1CVpZqUvp5aeB3ZWvehDWJz+zswx3w2czqD/P4q6zP0lvnGtxxR6bv8QjzvtMymhBqhJu8U74yPOeaNSBeegmRBU1VQ2Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288724; c=relaxed/simple;
	bh=acqatnoAVaMG9JAF5AWwMi2WJf4TI5Sdk+koVDC0QIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7W09yx8F10J0sUMWcHnPci+YGMmhVX30yDbwwLZfknFYjiJYVodEYB9bKOrZGS1eGJy/8VXiZrkCy6pY4aoRZTYjo8c5gKhDQ2sBxXn9PczsFaqcNK1h+QMLEy2NkSU807wDIhvxmKJAbdu+dTivzMcd56A7mhAsp0cuEw74pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bkl2Nx6h; arc=none smtp.client-ip=95.215.58.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bkl2Nx6h"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=acqatnoAVaMG9JAF5AWwMi2WJf4TI5Sdk+koVDC0QIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787288720; v=1; x=1787893520;
 b=Bkl2Nx6hP+8QZ1nAHKKXUKTzA0FEyMUT3yLSByJVKDSMo81anYtEsMli6PDOhxoZ4TRN43z8
 C5uLxhtE09/h3xGdtsMTXNsRJxHSRH7wT01kOOgSkkYmO78LY744oxqPGAODJX1hERwEJIM9T9A
 gh1ULiloP6r1qjS11eEPZ6vc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:4c::)
	by smtp.migadu.com with ESMTPS id bfa9432652a67ff2;
	Fri, 21 Aug 2026 05:05:19 +0000
X-Mizu-Trace-ID: bfa9432652a67ff2
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christian@brauner.io>,
	Meta kernel team <kernel-team@meta.com>,
	driver-core@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] kernfs: Use VFS lookup context in d_revalidate()
Date: Thu, 20 Aug 2026 22:05:04 -0700
Message-ID: <20260821050507.2161607-2-shakeel.butt@linux.dev>
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

The VFS supplies a stable parent inode and expected name to the
revalidation callback. Use them instead of recovering the same
information from mutable dentry fields.

Compare the name using its explicit length because it may point into the
pathname and need not be terminated at name->len. This also prepares the
callback for lockless operation.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/kernfs/dir.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 82bbaeb326aa..541bb5525437 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1171,23 +1171,19 @@ struct kernfs_node *kernfs_create_empty_dir(struct kernfs_node *parent,
 static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
 				 struct dentry *dentry, unsigned int flags)
 {
-	struct kernfs_node *kn, *parent;
+	struct kernfs_node *kn, *kn_parent;
+	struct kernfs_node *parent = dir->i_private;
 	struct kernfs_root *root;
+	const char *kn_name;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
 	/* Negative hashed dentry? */
 	if (d_really_is_negative(dentry)) {
-		/* If the kernfs parent node has changed discard and
-		 * proceed to ->lookup.
-		 *
-		 * There's nothing special needed here when getting the
-		 * dentry parent, even if a concurrent rename is in
-		 * progress. That's because the dentry is negative so
-		 * it can only be the target of the rename and it will
-		 * be doing a d_move() not a replace. Consequently the
-		 * dentry d_parent won't change over the d_move().
+		/*
+		 * If the kernfs parent node has changed discard and proceed to
+		 * ->lookup.
 		 *
 		 * Also kernfs negative dentries transitioning from
 		 * negative to positive during revalidate won't happen
@@ -1195,14 +1191,11 @@ static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
 		 * changes and the lookup re-done so that a new positive
 		 * dentry can be properly created.
 		 */
-		root = kernfs_root_from_sb(dentry->d_sb);
+		root = kernfs_root(parent);
 		down_read(&root->kernfs_rwsem);
-		parent = kernfs_dentry_node(dentry->d_parent);
-		if (parent) {
-			if (kernfs_dir_changed(parent, dentry)) {
-				up_read(&root->kernfs_rwsem);
-				return 0;
-			}
+		if (kernfs_dir_changed(parent, dentry)) {
+			up_read(&root->kernfs_rwsem);
+			return 0;
 		}
 		up_read(&root->kernfs_rwsem);
 
@@ -1220,18 +1213,20 @@ static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
 	if (!kernfs_active(kn))
 		goto out_bad;
 
-	parent = kernfs_parent(kn);
+	kn_parent = kernfs_parent(kn);
 	/* The kernfs node has been moved? */
-	if (kernfs_dentry_node(dentry->d_parent) != parent)
+	if (parent != kn_parent)
 		goto out_bad;
 
 	/* The kernfs node has been renamed */
-	if (strcmp(dentry->d_name.name, kernfs_rcu_name(kn)) != 0)
+	kn_name = kernfs_rcu_name(kn);
+	if (name->len != strlen(kn_name) ||
+	    memcmp(name->name, kn_name, name->len))
 		goto out_bad;
 
 	/* The kernfs node has been moved to a different namespace */
-	if (parent && kernfs_ns_enabled(parent) &&
-	    kernfs_ns_id(kernfs_info(dentry->d_sb)->ns) != kernfs_ns_id(kn->ns))
+	if (kn_parent && kernfs_ns_enabled(kn_parent) &&
+	    kernfs_ns_id(kernfs_info(dir->i_sb)->ns) != kernfs_ns_id(kn->ns))
 		goto out_bad;
 
 	up_read(&root->kernfs_rwsem);
-- 
2.53.0-Meta


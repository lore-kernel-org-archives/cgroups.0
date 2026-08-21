Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86493F4DDB
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 05:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288731; cv=none; b=L7vIqyClixUm1eW3SlPRJQQL6T201LI5FrqTqIsKiqDl1t7FbYAX+BujWTQYNX3NU49KKCS88SiVabZRtY7xVaQPLbhSegZCNRCD/jJpyekWSkjLoaPo7dSM/y0zsPj56cZYlCTsqEST2+A4BR4jQufri1HFdn9X8EZPm8wOCmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288731; c=relaxed/simple;
	bh=LIUw7uKUV9KhIrN1qzokJl5Rc/EjHIF80hcbDXs5RD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+Z0d3J9+X4UfH71XI2bouboafOIjK8/YupxiR0l+zvyPPyElEjCEtIrSwFoOUgMC7LyfBjVALKVSVEan+Wku0t78TnboRM6ohQcmkkAZ/dW2BsbAHURTwa585BFpD/FQefzAOr1QBwQb7bP5lxskOA2ZOU3JfJAzc2Rd4SB5tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZpnJkXFw; arc=none smtp.client-ip=95.215.58.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZpnJkXFw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LIUw7uKUV9KhIrN1qzokJl5Rc/EjHIF80hcbDXs5RD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787288727; v=1; x=1787893527;
 b=ZpnJkXFwxTnzV/HT1kRS2Qv1Mj3gEVRGJhOLrytTSI1otvj07C1OXyc7C7Gq4fBM0CH/2jO5
 M82s0klc/R4g1a38+Bsi8c26qvT25zY5ANPSqllU3K6w13rnJGyI78zndOcO1CDY5qTQhRiWlJo
 KMcyYuOAADd63r9fE8bgOBq8=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:4::)
	by smtp.migadu.com with ESMTPS id fc17124732d1a8a7;
	Fri, 21 Aug 2026 05:05:27 +0000
X-Mizu-Trace-ID: fc17124732d1a8a7
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christian@brauner.io>,
	Meta kernel team <kernel-team@meta.com>,
	driver-core@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] kernfs: Avoid namespace dereference in d_revalidate()
Date: Thu, 20 Aug 2026 22:05:06 -0700
Message-ID: <20260821050507.2161607-4-shakeel.butt@linux.dev>
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

Commit 1fe989e1c42a ("kernfs: use namespace id instead of pointer for
hashing and comparison") changed dentry revalidation to compare namespace
IDs along with the comparisons that determine visible directory ordering.

Dereferencing a namespace tag that kernfs_rename_ns() can replace is not
suitable once dentry revalidation stops taking kernfs_rwsem. Use pointer
equality for this non-user-visible equality check instead. Namespace IDs
uniquely identify namespace objects, so pointer and ID equality cannot
disagree for valid tags. Hashing and directory ordering continue to use
IDs.

kn->ns becomes a lockless read in the next commit, so mark both sides of
it now. The read is in kernfs_dop_revalidate(); the stores that can run
while the node is visible are the two in kernfs_rename_ns(). The remaining
stores, in kernfs_create_dir_ns(), kernfs_create_empty_dir() and
kernfs_create_link(), all precede kernfs_add_one() and need no marking.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/kernfs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 541bb5525437..27949b0e027c 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1226,7 +1226,7 @@ static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
 
 	/* The kernfs node has been moved to a different namespace */
 	if (kn_parent && kernfs_ns_enabled(kn_parent) &&
-	    kernfs_ns_id(kernfs_info(dir->i_sb)->ns) != kernfs_ns_id(kn->ns))
+	    kernfs_info(dir->i_sb)->ns != READ_ONCE(kn->ns))
 		goto out_bad;
 
 	up_read(&root->kernfs_rwsem);
@@ -1873,7 +1873,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 		rcu_assign_pointer(kn->__parent, new_parent);
 
-		kn->ns = new_ns;
+		WRITE_ONCE(kn->ns, new_ns);
 		if (new_name)
 			rcu_assign_pointer(kn->name, new_name);
 
@@ -1881,7 +1881,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		kernfs_put(old_parent);
 	} else {
 		/* name assignment is RCU protected, parent is the same */
-		kn->ns = new_ns;
+		WRITE_ONCE(kn->ns, new_ns);
 		if (new_name)
 			rcu_assign_pointer(kn->name, new_name);
 	}
-- 
2.53.0-Meta


Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDBE3EC817
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 05:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288729; cv=none; b=Sb1J8lNb+u223LB8XFwo8H8v551Q0k41ZIqzIJsy9T4zfkTOGtETaFq48kaI4TkjuCw085jfxd8IpU26lZxwaas8stPALgoilykB7drtiOmFsqqeKTy5m7cAo3k7tblfxkEVbK8fiTRkdLH6XXa58qkXLJIPPHx6MG1PxXxjbUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288729; c=relaxed/simple;
	bh=U1l/0x7ZD0ZfGu+oDn4yhMeqTklxKFrZPzWL2YzeyXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yq07hthXrmbiXlXjrN7cQRGY0rEhpxwQ9CILMNRwToMG6D3iGNAxHoTPc94PP3YQKDw6r/v16JV0yRJU8ADM+qBf5zv6hs9iHqK4tPXVQPa35Ip0TYA5qZsIPaA7QP/Zo7GvNTXOk0ygJgkb8Zw3Zfltm0GlPs1LBTmmLxnDOWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wF0yiLrV; arc=none smtp.client-ip=91.218.175.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wF0yiLrV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=U1l/0x7ZD0ZfGu+oDn4yhMeqTklxKFrZPzWL2YzeyXk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787288725; v=1; x=1787893525;
 b=wF0yiLrVOpnBsKe4eMBPDn3RBgWM3jufS+sCCLKrIJ4wsdWdZPM7HrReZCKmip1zCxDINRlU
 anE5Fa7dYk3NNwV0Q6focM73CgJqcVWBwKbaZyv4+mVBN1VP1nax9/fmPk38zSr4JejpCgoPzXQ
 o/4CUG3axHcv5Dif21GlM2xY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:2::)
	by smtp.migadu.com with ESMTPS id af484d0623c2cb60;
	Fri, 21 Aug 2026 05:05:25 +0000
X-Mizu-Trace-ID: af484d0623c2cb60
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christian@brauner.io>,
	Meta kernel team <kernel-team@meta.com>,
	driver-core@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kernfs: Prepare directory revisions for lockless reads
Date: Thu, 20 Aug 2026 22:05:05 -0700
Message-ID: <20260821050507.2161607-3-shakeel.butt@linux.dev>
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

Negative dentry revalidation only needs to sample the parent directory
generation and compare it with the value recorded at lookup time.
Annotate those accesses with READ_ONCE() and WRITE_ONCE() so the
comparison can safely move outside kernfs_rwsem.

Revision updates remain serialized by kernfs_rwsem. Assert that writer
contract in kernfs_inc_rev(); the read half of the increment stays plain
because the semaphore excludes other writers.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/kernfs/kernfs-internal.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index aa784b540b36..20a0cf42ba8d 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -147,20 +147,19 @@ static inline struct kernfs_node *kernfs_dentry_node(struct dentry *dentry)
 static inline void kernfs_set_rev(struct kernfs_node *parent,
 				  struct dentry *dentry)
 {
-	dentry->d_time = parent->dir.rev;
+	WRITE_ONCE(dentry->d_time, READ_ONCE(parent->dir.rev));
 }
 
 static inline void kernfs_inc_rev(struct kernfs_node *parent)
 {
-	parent->dir.rev++;
+	lockdep_assert_held_write(&parent->dir.root->kernfs_rwsem);
+	WRITE_ONCE(parent->dir.rev, parent->dir.rev + 1);
 }
 
 static inline bool kernfs_dir_changed(struct kernfs_node *parent,
 				      struct dentry *dentry)
 {
-	if (parent->dir.rev != dentry->d_time)
-		return true;
-	return false;
+	return READ_ONCE(parent->dir.rev) != READ_ONCE(dentry->d_time);
 }
 
 extern const struct super_operations kernfs_sops;
-- 
2.53.0-Meta


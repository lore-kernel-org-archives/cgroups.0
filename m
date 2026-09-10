Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6E3D9DD8
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033593; cv=none; b=X/+xfRMROWrWtX8i5jK2IeUizHrLenB/SvogrzL8wLdsoMtimuuMliCfqr+Bg3Wyg4wza4G8c65IAD4Geqx+61ievrBQaL1vExs0OPCAxRA2ALFdYKYFPhqi9sYsKZVv289x0bfBVKZGEQUZu/nprmhAj0T5iEi7lY8hOyn5smA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033593; c=relaxed/simple;
	bh=YuTbT0DX6xXRbrjkJTTCCjE2es60hrvQcLZ1FO2Jr6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6vTPrF8PMQizt46huOw7ZL8Z6qkYfGiu5aAK4iwJhuSG1shvCVlbP3eYzRQoQSahjWc/iqNOp7YUBBJrQ6pVFFe5Tq5XlN1Qr/+hNUez6fqB4L8rPVvE2nJ8Bm00DLgxyg7d4alWWfGhB695kZ/6uJK7uOGM1CLuUnHo5Bctq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pi1yv4+o; arc=none smtp.client-ip=95.215.58.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pi1yv4+o"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YuTbT0DX6xXRbrjkJTTCCjE2es60hrvQcLZ1FO2Jr6Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033586; v=1; x=1789638386;
 b=pi1yv4+oI0guX5frTMgjRDVicvB0w9gL0gLWVN7CsrG5K3Y7DTTlTM/TC6bwjBtSvjxWq63X
 SwY4drKQ67DQK4p+W9VH2ndiSTiWP3U3Lsx0SjvNw3hE32XLMt3zKgF+1eurHZj6qADlMMSGflc
 bma5d72ssofYjOCMYzvpWgTY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1f2f61f473892bfd;
	Thu, 10 Sep 2026 09:46:26 +0000
X-Mizu-Trace-ID: 1f2f61f473892bfd
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v4 1/7] cgroup/cpuset: Factor out child partition validation
Date: Thu, 10 Sep 2026 17:45:40 +0800
Message-ID: <20260910094546.5852-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910094546.5852-1-guopeng.zhang@linux.dev>
References: <20260910094546.5852-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

compute_partition_effective_cpumask() checks whether each valid child
partition remains covered by the parent exclusive CPU mask and whether it
would consume all remaining active CPUs of a populated parent.

Factor these two checks into cs_partition_error() so the same rules can be
reused when evaluating a proposed parent configuration. This is a
preparatory refactoring with no intended functional change.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 47 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f24171b6055..a2514fcb1144 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2085,6 +2085,37 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	return 0;
 }
 
+/**
+ * cs_partition_error - Return a cpuset partition invalidation error
+ * @cs: Partition being evaluated
+ * @parent_xcpus: Parent's complete effective exclusive CPU mask, including
+ *                offline CPUs
+ * @remaining_ecpus: Parent's active effective CPUs remaining before @cs is
+ *                   evaluated
+ * @parent_populated: Whether the parent partition contains tasks
+ *
+ * @remaining_ecpus may still contain active CPUs assigned to @cs and to
+ * children that have not yet been evaluated. It excludes only CPUs assigned
+ * to previously evaluated children that remain valid.
+ *
+ * Return: The error that would invalidate @cs, or PERR_NONE
+ */
+static enum prs_errcode
+cs_partition_error(struct cpuset *cs,
+		   const struct cpumask *parent_xcpus,
+		   const struct cpumask *remaining_ecpus,
+		   bool parent_populated)
+{
+	if (!cpumask_subset(cs->effective_xcpus, parent_xcpus))
+		return PERR_INVCPUS;
+
+	if (parent_populated &&
+	    cpumask_subset(remaining_ecpus, cs->effective_xcpus))
+		return PERR_NOCPUS;
+
+	return PERR_NONE;
+}
+
 /**
  * compute_partition_effective_cpumask - compute effective_cpus for partition
  * @cs: partition root cpuset
@@ -2121,6 +2152,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 
 	rcu_read_lock();
 	cpuset_for_each_child(child, css, cs) {
+		enum prs_errcode child_err;
+
 		if (!is_partition_valid(child))
 			continue;
 
@@ -2129,15 +2162,11 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 * partition root.
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
-		WRITE_ONCE(child->prs_err, 0);
-		if (!cpumask_subset(child->effective_xcpus,
-				    cs->effective_xcpus))
-			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
-		else if (populated &&
-			 cpumask_subset(new_ecpus, child->effective_xcpus))
-			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
-
-		if (child->prs_err) {
+		child_err = cs_partition_error(child, cs->effective_xcpus,
+					       new_ecpus, populated);
+		WRITE_ONCE(child->prs_err, child_err);
+
+		if (child_err) {
 			int old_prs = child->partition_root_state;
 
 			/*
-- 
2.43.0


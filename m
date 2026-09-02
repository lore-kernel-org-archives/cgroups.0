Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8443FD18
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 10:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344795; cv=none; b=mUdZKENOb91BdjNF6xW/LdlRJ8daVkktUSo2y4p5qfZJBE2mCaehxOrh5f4GJa92YZoksEvSKKwrZlwfQWVv7F6xlLf4o+oND2zPhAT4gke7Gp2qELgFxdBB3Z1DfAC3TAK+WCm/dPY4TCC7sMcNdaVvI7oSMGi+2QOXqZ2TtLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344795; c=relaxed/simple;
	bh=kQ4SUfFL7l6CK6D4M0vZTJ4yXI8I7EmpzCUw04y0Mtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ892CHUJGwo4pqFezx2O9I01x7M9L9o3IuQ+gji7FGo5TLkCEV+kfg9DfVZ3mJR+zu02rLHIYnNshaNaCj1z9anYN8BySPn2VUbGOrTFFae8zwVC56MgPv56FhQWBvl+GYZzwHziMZDJhqRsWTv2w0+wWR6oj2oAG5AqO002So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z4jLufZg; arc=none smtp.client-ip=91.218.175.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z4jLufZg"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kQ4SUfFL7l6CK6D4M0vZTJ4yXI8I7EmpzCUw04y0Mtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788344791; v=1; x=1788949591;
 b=Z4jLufZgUef4DIgbPPU1Cyw4/bpI5GGQ4RxQup3T3iPBT/hODAZJ5bWcRfB9J8VMbz9XpKDh
 zIjuasbPK8qlbmx5JK5IS46/8qBK4/gz9+U55zlXGOSMJpfU93aENvSChlBu2KMEt0zjjLR9cIi
 42LJzqKerGkBF9f9/rWnt11c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b319449c4d0dc839;
	Wed, 02 Sep 2026 10:26:31 +0000
X-Mizu-Trace-ID: b319449c4d0dc839
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: cgroups@vger.kernel.org,
	longman@redhat.com,
	ridong.chen@linux.dev
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition validation
Date: Wed,  2 Sep 2026 18:26:09 +0800
Message-ID: <20260902102615.79189-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902102615.79189-1-guopeng.zhang@linux.dev>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
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
would consume all remaining CPUs of a populated parent.

Factor these two checks into child_partition_error() so the same rules can
be reused when evaluating a proposed parent configuration. This is a
preparatory refactoring with no intended functional change.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f24171b6055..6994dc75d940 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	return 0;
 }
 
+/*
+ * Return the error that will invalidate a child partition under a proposed
+ * parent partition configuration.
+ */
+static enum prs_errcode
+child_partition_error(struct cpuset *child,
+		      const struct cpumask *partition_cpus,
+		      const struct cpumask *remaining_cpus,
+		      bool parent_populated)
+{
+	if (!cpumask_subset(child->effective_xcpus, partition_cpus))
+		return PERR_INVCPUS;
+
+	if (parent_populated &&
+	    cpumask_subset(remaining_cpus, child->effective_xcpus))
+		return PERR_NOCPUS;
+
+	return PERR_NONE;
+}
+
 /**
  * compute_partition_effective_cpumask - compute effective_cpus for partition
  * @cs: partition root cpuset
@@ -2121,6 +2141,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 
 	rcu_read_lock();
 	cpuset_for_each_child(child, css, cs) {
+		enum prs_errcode child_err;
+
 		if (!is_partition_valid(child))
 			continue;
 
@@ -2129,15 +2151,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
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
+		WRITE_ONCE(child->prs_err, PERR_NONE);
+		child_err = child_partition_error(child, cs->effective_xcpus,
+						  new_ecpus, populated);
+		if (child_err)
+			WRITE_ONCE(child->prs_err, child_err);
+
+		if (child_err) {
 			int old_prs = child->partition_root_state;
 
 			/*
-- 
2.43.0


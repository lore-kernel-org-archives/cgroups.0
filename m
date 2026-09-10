Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F323E0080
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033626; cv=none; b=LdFxN1ovwgfIBPFBOrEXwX+ZU1dlUtKRh3asd8CRKpAPuNP576uTnx6v7CKBXHWMRXhpqwrCm1ssT/Qkq64Fu66qgFWhNKS3asFO5MCXEn96/09HClElYeGVjJPOU0fRkuqzF6rJYEN4+pFjtVY9Jtc9KE8augd31UN2u5MCD6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033626; c=relaxed/simple;
	bh=E7gj/63wJoRVGssDCWIkzHFYWr734CVQs31WRFGmvas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUxeugxESyte0RRBWQK1cmEzBmdeRS/mZwZSFd3GqTqM4hJ+Rv2JDB5qDbO/vW5b5z2L8CxGoKMam3m4FjgKH0FJHrftRk6UTGeLBraN7HZanQIDoSEAVkZeS2hHXe5vX891lz997sOstvqGpSdHy+HG764jyhpP+44ENnpo6jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rWw30qnd; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rWw30qnd"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=E7gj/63wJoRVGssDCWIkzHFYWr734CVQs31WRFGmvas=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033617; v=1; x=1789638417;
 b=rWw30qndfv4+9cBmozJZEVdMx9tYUNyJqyDYTSG2pPCEIosJuXEhTJJGzaiHBU+3ju9WLLqw
 kyDm+W2dUoaH0SHvJjYG1RKyZ2AGfbj887SW454iSuzQ3YUe/45/ixyjgMCVcMLxmPEzwUyxbOd
 luMrWh0fCQXQwH4ibEBtiDlg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 06c6d75ab9332f78;
	Thu, 10 Sep 2026 09:46:56 +0000
X-Mizu-Trace-ID: 06c6d75ab9332f78
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
Subject: [PATCH v4 4/7] cgroup/cpuset: Fix child invalidation after parent CPU changes
Date: Thu, 10 Sep 2026 17:45:43 +0800
Message-ID: <20260910094546.5852-5-guopeng.zhang@linux.dev>
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

compute_partition_effective_cpumask() recomputes a partition's exclusive
CPU mask before walking its children, but checks child containment against
cs->effective_xcpus. During an update, that field can still describe an
earlier point in the update, allowing a child outside the newly computed
mask to remain valid.

Use the newly computed exclusive mask for the containment check. Keep this
mask separate from the active-only effective mask because offline CPUs
remain part of the partition's CPU ownership.

After a child is invalidated, update_cpumasks_hier() can revisit it by
calling update_parent_effective_cpumask() with partcmd_update. The
invalid-partition recovery path is currently entered only when the child's
CPUs are already a subset of its parent's effective exclusive mask.
Otherwise part_error remains clear and the subsequent state transition
makes the child valid again. Enter the recovery path for every non-empty
CPU mask and report PERR_INVCPUS when the child is still outside the parent
mask.

The invalidation path also calls make_partition_invalid() without updating
isolated_cpus for the CPUs released by the child. Account each released CPU
according to its new owner. When the parent remains valid and owns the CPU,
use its partition state; otherwise use the state of the nearest valid
partition ancestor. Use the unfiltered exclusive mask so offline CPUs are
included in the accounting.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 51 +++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7e8b167a29ed..7ba26b924086 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1281,6 +1281,17 @@ static bool isolated_cpu_update(int new_prs, int cpu)
 	return true;
 }
 
+/* Return the nearest valid partition ancestor of @cs. */
+static struct cpuset *partition_owner(struct cpuset *cs)
+{
+	struct cpuset *owner = parent_cs(cs);
+
+	lockdep_assert_held(&cpuset_mutex);
+	while (!is_partition_valid(owner))
+		owner = parent_cs(owner);
+	return owner;
+}
+
 /*
  * isolated_cpus_update - Update the isolated_cpus mask
  * @old_prs: old partition_root_state
@@ -1976,12 +1987,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 				adding = cpumask_and(tmp->addmask,
 						     cs->effective_xcpus,
 						     parent->effective_xcpus);
-		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
-			   cpumask_subset(xcpus, parent->effective_xcpus)) {
+		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
 			bool exclusive = true;
 
+			if (!cpumask_subset(xcpus, parent->effective_xcpus)) {
+				part_error = PERR_INVCPUS;
+				goto write_error;
+			}
+
 			/*
 			 * Convert invalid partition to valid has to
 			 * pass the cpu exclusivity test.
@@ -2120,6 +2135,7 @@ cs_partition_error(struct cpuset *cs,
  * compute_partition_effective_cpumask - compute effective_cpus for partition
  * @cs: partition root cpuset
  * @new_ecpus: previously computed effective_cpus to be updated
+ * @new_xcpus: scratch mask for the new effective_xcpus
  *
  * Compute the effective_cpus of a partition root by scanning effective_xcpus
  * of child partition roots and excluding their effective_xcpus.
@@ -2133,7 +2149,8 @@ cs_partition_error(struct cpuset *cs,
  * Note that rcu_read_lock() is assumed to be held.
  */
 static void compute_partition_effective_cpumask(struct cpuset *cs,
-						struct cpumask *new_ecpus)
+						struct cpumask *new_ecpus,
+						struct cpumask *new_xcpus)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *child;
@@ -2147,8 +2164,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	 *  2) All the effective_cpus will be used up and cp
 	 *     has tasks
 	 */
-	compute_excpus(cs, new_ecpus);
-	cpumask_and(new_ecpus, new_ecpus, cpu_active_mask);
+	compute_excpus(cs, new_xcpus);
+	cpumask_and(new_ecpus, new_xcpus, cpu_active_mask);
 
 	rcu_read_lock();
 	cpuset_for_each_child(child, css, cs) {
@@ -2162,17 +2179,31 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 * partition root.
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
-		child_err = cs_partition_error(child, cs->effective_xcpus,
+		child_err = cs_partition_error(child, new_xcpus,
 					       new_ecpus, populated);
 		WRITE_ONCE(child->prs_err, child_err);
 
 		if (child_err) {
 			int old_prs = child->partition_root_state;
+			int parent_prs = cs->partition_root_state;
+			int owner_prs = partition_owner(cs)->partition_root_state;
+			int cpu;
 
 			/*
-			 * Invalidate child partition
+			 * Account each released CPU according to whether it is now
+			 * owned by the parent or by the partition that owns the parent.
 			 */
 			spin_lock_irq(&callback_lock);
+			for_each_cpu(cpu, child->effective_xcpus) {
+				int new_prs = parent_prs > 0 &&
+					      cpumask_test_cpu(cpu, new_xcpus)
+					      ? parent_prs : owner_prs;
+
+				if (old_prs == new_prs)
+					continue;
+				if (isolated_cpu_update(new_prs, cpu))
+					update_housekeeping = true;
+			}
 			make_partition_invalid(child);
 			spin_unlock_irq(&callback_lock);
 			notify_partition_change(child, old_prs);
@@ -2274,7 +2305,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		}
 
 		if (remote || (is_partition_valid(parent) && is_partition_valid(cp)))
-			compute_partition_effective_cpumask(cp, tmp->new_cpus);
+			compute_partition_effective_cpumask(cp, tmp->new_cpus, tmp->addmask);
 		else
 			compute_effective_cpumask(tmp->new_cpus, cp, parent);
 
@@ -4111,7 +4142,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	 */
 	remote = is_remote_partition(cs);
 	if (remote || (is_partition_valid(cs) && is_partition_valid(parent)))
-		compute_partition_effective_cpumask(cs, &new_cpus);
+		compute_partition_effective_cpumask(cs, &new_cpus, tmp->addmask);
 
 	if (remote && (cpumask_empty(subpartitions_cpus) ||
 			(cpumask_empty(&new_cpus) &&
@@ -4146,7 +4177,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (partcmd >= 0) {
 		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
 		if ((partcmd == partcmd_invalidate) || is_partition_valid(cs)) {
-			compute_partition_effective_cpumask(cs, &new_cpus);
+			compute_partition_effective_cpumask(cs, &new_cpus, tmp->addmask);
 			cpuset_force_rebuild();
 		}
 	}
-- 
2.43.0


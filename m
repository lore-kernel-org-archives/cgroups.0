Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19564457DE
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229785; cv=none; b=dXYMT79Ff5vdvPb9ESYyal3ZgSL+O7k/nWdfvi9fIv+lTSH4ilWcfKxDIS9/kwZDEIVd8GxvluOErNbRnyZFlc+VrnKD3m3tfU61Itq8esmqCRBmSsptnm2KOuIof9YlmS+niWF/utjSv1RNjIeB4StlHxPt8A3ZqUai/gUZaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229785; c=relaxed/simple;
	bh=d9WDe4wXJmY5toV+OLSSo2p1bXJ84soOVNkR1vO/t9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPIcaKynj2/9WkNVbtArGYQCsgRRuNS1JwB20Ok8aNFxuXUkXsrz7UbTqbkmyI06qUt0oWUJx2FUwJOtysIZQ4ugjy1WA0eq9knFTg0AAcgSAG1p5ZeDSx3QSFpumf6iH6bI4znNjsKiD+XO5BVoi2JLOWIyWFTbxOppfi5glao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xsw42pEz; arc=none smtp.client-ip=95.215.58.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xsw42pEz"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=d9WDe4wXJmY5toV+OLSSo2p1bXJ84soOVNkR1vO/t9U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229781; v=1; x=1787834581;
 b=Xsw42pEzERDXcJ+bJcfbuWQmZm69AVctj9x5S2C63qHvWeC0vtQRV2ykPOmEXBkLqYcdP6sJ
 v1cnMEnzOG3GWfOyhDkNRq9F6ycQfqK2/PCd8ooIU3KzkXQp7jmeFsivi3bSpDwWdWHaWmt0Yk9
 Tya2OeBHgrhA6M0Tyfdd3F10=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 8cf7982b83d23293;
	Thu, 20 Aug 2026 12:43:01 +0000
X-Mizu-Trace-ID: 8cf7982b83d23293
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 10/17] cgroup/cpuset: Fix isolated accounting on direct child invalidation
Date: Thu, 20 Aug 2026 20:41:55 +0800
Message-ID: <20260820124202.517160-11-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

compute_partition_effective_cpumask() can invalidate a child whose CPUs
no longer fit in the parent or would leave a populated parent without an
active CPU. make_partition_invalid() changes the child state without
updating isolated_cpus for the CPUs returned by the child.

Keep the unfiltered result of compute_excpus() so that offline CPUs are
included in isolation accounting. For each CPU released by the child, use
the parent's state when the parent remains valid and owns the CPU.
Otherwise use the state of the nearest valid partition ancestor.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 43 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a616012927be..b9faadf4af6d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1281,6 +1281,17 @@ static bool isolated_cpu_update(int new_prs, int cpu)
 	return true;
 }
 
+/* Return the valid partition that owns CPUs released by @cs. */
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
@@ -2089,6 +2100,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
  * compute_partition_effective_cpumask - compute effective_cpus for partition
  * @cs: partition root cpuset
  * @new_ecpus: previously computed effective_cpus to be updated
+ * @new_xcpus: scratch mask for the new effective_xcpus
  *
  * Compute the effective_cpus of a partition root by scanning effective_xcpus
  * of child partition roots and excluding their effective_xcpus.
@@ -2102,7 +2114,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
  * Note that rcu_read_lock() is assumed to be held.
  */
 static void compute_partition_effective_cpumask(struct cpuset *cs,
-						struct cpumask *new_ecpus)
+						struct cpumask *new_ecpus,
+						struct cpumask *new_xcpus)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *child;
@@ -2116,8 +2129,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	 *  2) All the effective_cpus will be used up and cp
 	 *     has tasks
 	 */
-	compute_excpus(cs, new_ecpus);
-	cpumask_and(new_ecpus, new_ecpus, cpu_active_mask);
+	compute_excpus(cs, new_xcpus);
+	cpumask_and(new_ecpus, new_xcpus, cpu_active_mask);
 
 	rcu_read_lock();
 	cpuset_for_each_child(child, css, cs) {
@@ -2139,11 +2152,27 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 
 		if (child->prs_err) {
 			int old_prs = child->partition_root_state;
+			int parent_prs = cs->partition_root_state;
+			int owner_prs = partition_owner(cs)->partition_root_state;
+			int cpu;
 
 			/*
-			 * Invalidate child partition
+			 * CPUs in the parent's new exclusive mask return to the
+			 * parent. The other CPUs have already been released to the
+			 * partition that owns the parent. Account both destinations
+			 * before invalidating the child.
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
@@ -2231,7 +2260,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		}
 
 		if (remote || (is_partition_valid(parent) && is_partition_valid(cp)))
-			compute_partition_effective_cpumask(cp, tmp->new_cpus);
+			compute_partition_effective_cpumask(cp, tmp->new_cpus, tmp->addmask);
 		else
 			compute_effective_cpumask(tmp->new_cpus, cp, parent);
 
@@ -3996,7 +4025,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	 */
 	remote = is_remote_partition(cs);
 	if (remote || (is_partition_valid(cs) && is_partition_valid(parent)))
-		compute_partition_effective_cpumask(cs, &new_cpus);
+		compute_partition_effective_cpumask(cs, &new_cpus, tmp->addmask);
 
 	if (remote && (cpumask_empty(subpartitions_cpus) ||
 			(cpumask_empty(&new_cpus) &&
@@ -4031,7 +4060,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
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


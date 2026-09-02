Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04B442B2F
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344803; cv=none; b=AbAJxmt27QV1Qz0OW9N1s/jApgO1nLxwWH0FFLFaQIay2a/dJGefBQ3yrruLRW/BzVsNSoJg4LfTLGE8AxFiOmZnSinO8r0MS0TwBRQmlyuxHaSIz7e2jsRJYfbocCqVU3TXxxPVm1XmKipflMRerZvrwXLJnFHIQVsA2CpYkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344803; c=relaxed/simple;
	bh=76mSk235XDEvU0T6h3abZzmqTjj8sG7ZMLytmlitcUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxoS4QY3aMOO4KxeLN2FQDkgfmO5XRLa/wfUGhBA5UwVqbjlljmdRbcBH11MUIjiybu+6iByZQl1MB6nEh55YiYxfI/BiIZH9y1/CxQ5Nc1l3wZraAiTLPiz1sr5bzejWomkL0Ef4MMpLphxzft2d2ZyoL2QM3hi1t/7jdfR+cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YeH/d3B2; arc=none smtp.client-ip=95.215.58.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YeH/d3B2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=76mSk235XDEvU0T6h3abZzmqTjj8sG7ZMLytmlitcUI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788344797; v=1; x=1788949597;
 b=YeH/d3B20hJisSy6M2VGJ7qbHx4icTKbj5Tdpu3CyC6o2Qb3ICz6d8BD0z54w1uFKvx2o0zT
 YKXhpztC4dtt5HNlN9gGTI0w7agdPQS3h4k2W3M5jvr7nL1tcwrm6LfNdH1ITca/RLQgV/7xSi4
 8meyWIPGh5iw432ynSHR3ZV4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 00d23fc2425b8e67;
	Wed, 02 Sep 2026 10:26:37 +0000
X-Mizu-Trace-ID: 00d23fc2425b8e67
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
Subject: [PATCH v3 2/7] cgroup/cpuset: Account for child CPU ownership in partition changes
Date: Wed,  2 Sep 2026 18:26:10 +0800
Message-ID: <20260902102615.79189-3-guopeng.zhang@linux.dev>
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

effective_xcpus includes CPUs granted to valid child partitions. A change
to the parent must not apply its isolation state or housekeeping checks to
CPUs which remain owned by those children.

For example, on a cgroup v2 system with CPUs 0-3 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir type-repro
    echo 1-3 > type-repro/cpuset.cpus
    echo isolated > type-repro/cpuset.cpus.partition
    echo +cpuset > type-repro/cgroup.subtree_control
    mkdir type-repro/child
    echo 2-3 > type-repro/child/cpuset.cpus
    echo isolated > type-repro/child/cpuset.cpus.partition
    echo root > type-repro/cpuset.cpus.partition
    cat cpuset.cpus.isolated

The isolated mask should still contain CPUs 2-3 after the parent becomes a
root partition. Without this change, those CPUs are removed even though
the child remains isolated.

Compute the CPUs owned directly by a partition by excluding CPUs granted
to valid children. When validating a trial parent mask, exclude only CPUs
granted to children that will remain valid under that mask. Reuse the child
validation rules so PERR_INVCPUS and PERR_NOCPUS are handled consistently.

Use the directly owned mask for root/isolated type changes and housekeeping
validation. If a root child returns the last housekeeping CPU to an
isolated parent, invalidate the outermost isolated ancestor so the child
can still become a member without violating the housekeeping constraint.

Link: https://sashiko.dev/#/patchset/20260820124202.517160-1-guopeng.zhang%40linux.dev?part=6
Link: https://sashiko.dev/#/patchset/20260828095643.13395-1-guopeng.zhang@linux.dev?part=1
Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 138 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6994dc75d940..19efa62bb694 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2175,6 +2175,46 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	rcu_read_unlock();
 }
 
+/*
+ * Compute CPUs owned directly by a partition.
+ *
+ * effective_xcpus includes CPUs granted to valid child partitions. Exclude
+ * those CPUs when checking or changing this partition's type.
+ */
+static void compute_partition_owned_cpumask(struct cpuset *cs,
+					    const struct cpumask *partition_cpus,
+					    struct cpumask *owned_cpus,
+					    struct cpumask *remaining_cpus)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+	bool populated = partition_is_populated(cs, NULL);
+
+	lockdep_assert_held(&cpuset_mutex);
+	cpumask_copy(owned_cpus, partition_cpus);
+	cpumask_and(remaining_cpus, partition_cpus, cpu_active_mask);
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, cs) {
+		if (!is_partition_valid(child))
+			continue;
+
+		/*
+		 * A child that will become invalid under the proposed
+		 * configuration cannot retain ownership of its CPUs.
+		 */
+		if (child_partition_error(child, partition_cpus,
+					  remaining_cpus, populated))
+			continue;
+
+		cpumask_andnot(owned_cpus, owned_cpus,
+			       child->effective_xcpus);
+		cpumask_andnot(remaining_cpus, remaining_cpus,
+			       child->effective_xcpus);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2415,13 +2455,18 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
  * validate_partition - Validate a cpuset partition configuration
  * @cs: The cpuset to validate
  * @trialcs: The trial cpuset containing proposed configuration changes
+ * @owned_cpus: Scratch mask for CPUs owned directly by the trial partition
+ * @remaining_cpus: Scratch mask used to predict valid child partitions
  *
  * If any validation check fails, the appropriate error code is set in the
  * cpuset's prs_err field.
  *
  * Return: PRS error code (0 if valid, non-zero error code if invalid)
  */
-static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs)
+static enum prs_errcode validate_partition(struct cpuset *cs,
+					   struct cpuset *trialcs,
+					   struct cpumask *owned_cpus,
+					   struct cpumask *remaining_cpus)
 {
 	struct cpuset *parent = parent_cs(cs);
 
@@ -2431,8 +2476,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
+	compute_partition_owned_cpumask(cs, trialcs->effective_xcpus,
+					owned_cpus, remaining_cpus);
 	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
-					  trialcs->effective_xcpus))
+					  owned_cpus))
 		return PERR_HKEEPING;
 
 	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
@@ -2458,7 +2505,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 	if (cs_is_member(cs))
 		return;
 
-	prs_err = validate_partition(cs, trialcs);
+	prs_err = validate_partition(cs, trialcs, tmp->new_cpus,
+				     tmp->addmask);
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
@@ -2937,6 +2985,48 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	return err;
 }
 
+/*
+ * Invalidate the highest isolated partition that contains @cs.
+ *
+ * A root partition returning CPUs to an isolated parent can consume the last
+ * housekeeping CPU. Invalidating the whole chain returns the CPUs to a root
+ * partition instead.
+ */
+static struct cpuset *invalidate_isolated_ancestor(struct cpuset *cs,
+						   struct tmpmasks *tmp)
+{
+	struct cpuset *ancestor = parent_cs(cs);
+	struct cpuset *parent;
+	int err;
+
+	lockdep_assert_held(&cpuset_mutex);
+	if (WARN_ON_ONCE(!ancestor))
+		return NULL;
+
+	while ((ancestor != &top_cpuset) &&
+	       !is_remote_partition(ancestor)) {
+		parent = parent_cs(ancestor);
+		if (!parent ||
+		    parent->partition_root_state != PRS_ISOLATED)
+			break;
+		ancestor = parent;
+	}
+
+	if (WARN_ON_ONCE(ancestor == &top_cpuset))
+		return NULL;
+
+	WRITE_ONCE(ancestor->prs_err, PERR_HKEEPING);
+	if (is_remote_partition(ancestor)) {
+		remote_partition_disable(ancestor, tmp);
+	} else {
+		err = update_parent_effective_cpumask(ancestor,
+						      partcmd_invalidate, NULL, tmp);
+		WARN_ON_ONCE(err);
+	}
+
+	return ancestor;
+}
+
 /**
  * update_prstate - update partition_root_state
  * @cs: the cpuset to update
@@ -2949,6 +3039,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 {
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
+	struct cpuset *invalidated = NULL;
+	struct cpumask *isolcpus_update_cpus = cs->effective_xcpus;
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
 
@@ -3005,19 +3097,38 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	} else if (old_prs && new_prs) {
 		/*
 		 * A change in load balance state only, no change in cpumasks.
-		 * Need to update isolated_cpus.
+		 * Need to update isolated_cpus for CPUs owned by this partition,
+		 * excluding CPUs distributed to valid child partitions.
 		 */
+		compute_partition_owned_cpumask(cs, cs->effective_xcpus,
+						tmpmask.new_cpus,
+						tmpmask.addmask);
 		if (((new_prs == PRS_ISOLATED) &&
-		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
+		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
 			err = PERR_HKEEPING;
-		else
+		} else {
+			/*
+			 * Only directly owned CPUs change isolation state for a
+			 * successful root <-> isolated type change.
+			 */
+			isolcpus_update_cpus = tmpmask.new_cpus;
 			isolcpus_updated = true;
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
-		 * disables child partitions.
+		 * disables child partitions. If returning CPUs to an isolated
+		 * parent would consume the last housekeeping CPU, invalidate
+		 * the outermost isolated ancestor and return its CPUs instead.
 		 */
+		if (old_prs == PRS_ROOT &&
+		    parent->partition_root_state == PRS_ISOLATED &&
+		    !isolated_cpus_can_update(cs->effective_xcpus, NULL))
+			invalidated = invalidate_isolated_ancestor(cs, &tmpmask);
+		if (invalidated)
+			goto out;
+
 		if (is_remote_partition(cs))
 			remote_partition_disable(cs, &tmpmask);
 		else
@@ -3045,11 +3156,18 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (!is_partition_valid(cs))
 		reset_partition_data(cs);
 	else if (isolcpus_updated)
-		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
+		isolated_cpus_update(old_prs, new_prs,
+				     isolcpus_update_cpus);
 	spin_unlock_irq(&callback_lock);
 
 	/* Force update if switching back to member & update effective_xcpus */
-	update_cpumasks_hier(cs, &tmpmask, !new_prs);
+	if (invalidated) {
+		update_cpumasks_hier(invalidated, &tmpmask, false);
+		update_partition_sd_lb(invalidated, PRS_ISOLATED);
+		notify_partition_change(invalidated, PRS_ISOLATED);
+	} else {
+		update_cpumasks_hier(cs, &tmpmask, !new_prs);
+	}
 
 	/* A newly created partition must have effective_xcpus set */
 	WARN_ON_ONCE(!old_prs && (new_prs > 0)
-- 
2.43.0


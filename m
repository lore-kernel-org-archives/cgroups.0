Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8A338737B
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911025; cv=none; b=CjOscztecroxUnSDrEikK4o8Veo8de8nm3WRbJdr1WrjknmMRdQOugP/Bb93l4PE8fvWTrc5iqK6z0tvmOXa20uWihbbpN7/L7QarluQ0H5L4ajuYMq1kFoG/PPAoLj/HBhwhivusja/H8+httMUxIACUxNF8LJgQ6mCoznMNTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911025; c=relaxed/simple;
	bh=XJATRznWzRn3iqMXFzr10lEZZ4G3C50fagcm01Q2pv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVhCcJ5QiT9ZrylF/JaOrXXJkGvfYOa4Pta4uuUEXvy9djV8smDsX/CLZIDpYICM4EDTwYkk56nSHfU9uGp/Ld68Rk3SdTV03RoptpLd9wcDfBK+FPvTl/iyfwBO/BOQCXbwkGa0lurhEDjje17TkfjBVDPQwvVw6uifwOt9AI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WQ/8pBbR; arc=none smtp.client-ip=91.218.175.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WQ/8pBbR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XJATRznWzRn3iqMXFzr10lEZZ4G3C50fagcm01Q2pv8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911021; v=1; x=1788515821;
 b=WQ/8pBbRR6JaKMsSV/aySN9jIi8vFwMRBOp4caFp9DipJqDJHL4cIxlOByTin7zPod64TjBG
 pvGDvrmYW+UYAkOX5HiSlds3Mn/mAMtxjByOshqPY8reHTNW4WXnUEE3AfyiMp1AVFzpA/+N7L0
 nl23H6t5zHvPAMXNpg68EeD0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b5117d1f2e6d000b;
	Fri, 28 Aug 2026 09:57:01 +0000
X-Mizu-Trace-ID: b5117d1f2e6d000b
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
Subject: [PATCH v2 1/6] cgroup/cpuset: Respect child CPU ownership in type changes
Date: Fri, 28 Aug 2026 17:56:38 +0800
Message-ID: <20260828095643.13395-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828095643.13395-1-guopeng.zhang@linux.dev>
References: <20260828095643.13395-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

effective_xcpus includes CPUs granted to valid child partitions. Changing
a parent between root and isolated must not apply its new isolation state
or housekeeping constraints to those CPUs.

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

Compute the CPUs owned directly by a partition by subtracting the
effective_xcpus of valid children. Use this mask for type-change isolation
accounting and housekeeping checks. Apply the same ownership rule when
validating a trial CPU mask; otherwise a later CPU-mask update can mark a
parent invalid because of a boot-isolated CPU owned by a valid child.

Limiting the parent check to directly owned CPUs also allows a root child
to hold the last housekeeping CPU while its parent becomes isolated. If
the child then becomes a member, returning that CPU to the isolated parent
would violate the housekeeping constraint. The transition back to member
must remain allowed, so invalidate the outermost isolated ancestor and
return its CPUs to a root partition.

Sashiko pointed out the trial-validation and CPU-return gaps while
reviewing the original series.

Link: https://sashiko.dev/#/patchset/20260820124202.517160-1-guopeng.zhang%40linux.dev?part=6
Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 92 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 84 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f24171b6055..32a37d624c6b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2155,6 +2155,31 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
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
+					    struct cpumask *owned_cpus)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+
+	lockdep_assert_held(&cpuset_mutex);
+	cpumask_copy(owned_cpus, partition_cpus);
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, cs) {
+		if (is_partition_valid(child))
+			cpumask_andnot(owned_cpus, owned_cpus,
+				       child->effective_xcpus);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2401,7 +2426,9 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
  *
  * Return: PRS error code (0 if valid, non-zero error code if invalid)
  */
-static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs)
+static enum prs_errcode validate_partition(struct cpuset *cs,
+					   struct cpuset *trialcs,
+					   struct cpumask *owned_cpus)
 {
 	struct cpuset *parent = parent_cs(cs);
 
@@ -2411,8 +2438,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
+	compute_partition_owned_cpumask(cs, trialcs->effective_xcpus,
+					owned_cpus);
 	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
-					  trialcs->effective_xcpus))
+					  owned_cpus))
 		return PERR_HKEEPING;
 
 	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
@@ -2438,7 +2467,7 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 	if (cs_is_member(cs))
 		return;
 
-	prs_err = validate_partition(cs, trialcs);
+	prs_err = validate_partition(cs, trialcs, tmp->new_cpus);
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
@@ -2917,6 +2946,36 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
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
+	int err;
+
+	lockdep_assert_held(&cpuset_mutex);
+	while (!is_remote_partition(ancestor) &&
+	       (parent_cs(ancestor)->partition_root_state == PRS_ISOLATED))
+		ancestor = parent_cs(ancestor);
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
@@ -2929,6 +2988,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 {
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
+	struct cpuset *invalidated = NULL;
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
 
@@ -2985,11 +3045,14 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	} else if (old_prs && new_prs) {
 		/*
 		 * A change in load balance state only, no change in cpumasks.
-		 * Need to update isolated_cpus.
+		 * Need to update isolated_cpus for CPUs owned by this partition,
+		 * excluding CPUs distributed to valid child partitions.
 		 */
+		compute_partition_owned_cpumask(cs, cs->effective_xcpus,
+						tmpmask.new_cpus);
 		if (((new_prs == PRS_ISOLATED) &&
-		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
+		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;
@@ -2998,6 +3061,13 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Switching back to member is always allowed even if it
 		 * disables child partitions.
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
@@ -3025,11 +3095,17 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (!is_partition_valid(cs))
 		reset_partition_data(cs);
 	else if (isolcpus_updated)
-		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
+		isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
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


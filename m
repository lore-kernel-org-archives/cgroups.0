Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087A83E0080
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033608; cv=none; b=lMrIMqFRvPepfZ//q75A5kDpeymsHD/3KiVsFFwVrhcz/qp7vf/a8AY+Fw4kTj+TOPSoeQYkpt4Di96R1p/GZUbTpw16KsvU+M45FIHd6dpH0M2i3mZvOIXNUf8ZfJQRdpU43fgQ7GhHU88wnkGMbT5gw1dP7nihbpDJ1rude7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033608; c=relaxed/simple;
	bh=uLsBzrZ02U23AWa/sdqBVri8O333V2kXYUzwHBlUhu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG+A5d6XF97GqZgYjG9/GD8UPFNtvAGHcevhsGJp/ZC/KVEuew2VifxOkjIPoCWG22p1M7uYHJQzhC8cOmF5LS8gz6z9ziTSl70uDb0fQiG5baTLudwlTyRVA7CEQB4cphhYxQdhVPZnPbzs+Cn0OO6n+JnKGaoDNezSAiWJmqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oET3Itl0; arc=none smtp.client-ip=95.215.58.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oET3Itl0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uLsBzrZ02U23AWa/sdqBVri8O333V2kXYUzwHBlUhu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033596; v=1; x=1789638396;
 b=oET3Itl0kR1QgQ4zg7AMF8whCKxuMBcVTAvP/5qAsBfSBC2cTCoViM5IEx4E8NhNWP/6QS7k
 oooPb7Cm6eXb+LIE0ZS9KRs0ZpWaBobTYQmW2KI72FNhKZ0Z10EhQEBxmERx50xTkCaXkkW8uhG
 ht6gnv4yBUL0sZXc+EZyklRk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 55f262cd7e46dd25;
	Thu, 10 Sep 2026 09:46:35 +0000
X-Mizu-Trace-ID: 55f262cd7e46dd25
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
Subject: [PATCH v4 2/7] cgroup/cpuset: Account for child CPU ownership in partition changes
Date: Thu, 10 Sep 2026 17:45:41 +0800
Message-ID: <20260910094546.5852-3-guopeng.zhang@linux.dev>
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

Force the hierarchy update from the invalidated ancestor. Otherwise an
unchanged member cpuset can cause its subtree to be skipped, leaving task
CPU masks or descendant partition states stale.

Link: https://sashiko.dev/#/patchset/20260820124202.517160-1-guopeng.zhang%40linux.dev?part=6
Link: https://sashiko.dev/#/patchset/20260828095643.13395-1-guopeng.zhang@linux.dev?part=1
Link: https://sashiko.dev/#/patchset/20260902102615.79189-1-guopeng.zhang@linux.dev?part=2
Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 142 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 132 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a2514fcb1144..994ddb79272d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2184,6 +2184,44 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	rcu_read_unlock();
 }
 
+/*
+ * Compute CPUs owned directly by a partition under @parent_xcpus by excluding
+ * CPUs granted to children that remain valid under that mask.
+ */
+static void compute_partition_owned_cpumask(struct cpuset *cs,
+					    const struct cpumask *parent_xcpus,
+					    struct cpumask *owned_cpus,
+					    struct cpumask *remaining_ecpus)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+	bool populated = partition_is_populated(cs, NULL);
+
+	lockdep_assert_held(&cpuset_mutex);
+	cpumask_copy(owned_cpus, parent_xcpus);
+	cpumask_and(remaining_ecpus, parent_xcpus, cpu_active_mask);
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, cs) {
+		if (!is_partition_valid(child))
+			continue;
+
+		/*
+		 * A child that would become invalid under the proposed
+		 * configuration cannot retain ownership of its CPUs.
+		 */
+		if (cs_partition_error(child, parent_xcpus,
+				       remaining_ecpus, populated))
+			continue;
+
+		cpumask_andnot(owned_cpus, owned_cpus,
+			       child->effective_xcpus);
+		cpumask_andnot(remaining_ecpus, remaining_ecpus,
+			       child->effective_xcpus);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2424,13 +2462,18 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
  * validate_partition - Validate a cpuset partition configuration
  * @cs: The cpuset to validate
  * @trialcs: The trial cpuset containing proposed configuration changes
+ * @owned_cpus: Scratch mask for CPUs owned directly by the trial partition
+ * @remaining_ecpus: Scratch mask used to predict valid child partitions
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
+					   struct cpumask *remaining_ecpus)
 {
 	struct cpuset *parent = parent_cs(cs);
 
@@ -2440,8 +2483,10 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
+	compute_partition_owned_cpumask(cs, trialcs->effective_xcpus,
+					owned_cpus, remaining_ecpus);
 	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
-					  trialcs->effective_xcpus))
+					  owned_cpus))
 		return PERR_HKEEPING;
 
 	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
@@ -2467,7 +2512,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 	if (cs_is_member(cs))
 		return;
 
-	prs_err = validate_partition(cs, trialcs);
+	prs_err = validate_partition(cs, trialcs, tmp->new_cpus,
+				     tmp->addmask);
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
@@ -2946,6 +2992,49 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	return err;
 }
 
+/*
+ * Invalidate the highest isolated partition that contains @cs.
+ *
+ * A root partition returning CPUs to an isolated parent can consume the last
+ * housekeeping CPU. Invalidating the highest isolated ancestor lets the
+ * subsequent hierarchy update propagate invalidation down the chain and
+ * return the CPUs to a root partition.
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
@@ -2958,6 +3047,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 {
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
+	struct cpuset *invalidated = NULL;
+	struct cpumask *isolcpus_update_cpus = cs->effective_xcpus;
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
 
@@ -3014,19 +3105,38 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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
@@ -3054,11 +3164,23 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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
+		/*
+		 * Ancestor invalidation changes the partition hierarchy. Force the
+		 * traversal so an unchanged member cpuset does not cause its subtree
+		 * to be skipped.
+		 */
+		update_cpumasks_hier(invalidated, &tmpmask, true);
+		update_partition_sd_lb(invalidated, PRS_ISOLATED);
+		notify_partition_change(invalidated, PRS_ISOLATED);
+	} else {
+		update_cpumasks_hier(cs, &tmpmask, !new_prs);
+	}
 
 	/* A newly created partition must have effective_xcpus set */
 	WARN_ON_ONCE(!old_prs && (new_prs > 0)
-- 
2.43.0


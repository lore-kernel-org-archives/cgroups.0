Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645153;
	b=N9rAfy8zgVo5DZusH574oZxC9ibXyu3S7IoTJ6lUJX9zBSrvy/0JIBECffV+21d4R5Fl
	 RWMaYR7L1tpCWP+mC1PaFNr/f4HRw7VjV1xE2lB4HjYXs4+teHZWBAyETiaH9qsaTIxXG
	 ZkbDOVYHY4LA3LcAyf+MtKa1DutrADCdoY1YIkOe76GUS0LWW3wdW38N1SiItAAK9NfBC
	 /lexYdXbGlM+CEsgtzf++ASzB46Mt+/CYg5i0tckOBK5gw7pongk4ajLFhIoWbdWNYF7m
	 4Rb8cYnII3t5OH6rBcV6TJfkP6By/+vL1nHz2m2XKj+mrCCINiGPHVbi87zmTOB+fDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645153;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pnWBAGq7QnRT7rnFLvfkrF/u5wYkT/7vkiJDw0if6sk=;
	b=3JdVFiHo+tyYZcd7/z9dO+TeNJgZG2AjKnu1hfUWSQXsaMho3mcsSwwka/DVACX0g9wb
	 UN0TxLLvetZy7+xUJvOqZYBPwiRbEYiVVB+2cq3wMKLGSMkUWjsi2Kc2ChFf8yEVhuovZ
	 2oieE75Es13E3efBSAXpGqh2/WDhqeyVfB63EdtrOO8dwJRHW7zc9WowzRL7n48Wo6juw
	 lUHg/NNwQPcosW3/chXhWRpP3A7d6uKvBLo4GtNUPf0Rm3ceipnz5DCwZXIuRq3jdQAnI
	 9oqvre1xKGH9MuvBdeIFxlbk0Hg9D9TZnuchiuI5VMloLG9P+m1EEUfkSfADX7oNGyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gQumeoE5;
	arc=none smtp.remote-ip=95.215.58.92
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530A606A897
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8530A606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gQumeoE5
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jtzXoX9AeC88jZ8SFm2BmEx8hq2JyAJ8pYoL5KZFrXI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645150; v=1; x=1795249950;
 b=gQumeoE5iFU6emcspDgV8im9XuABDoAUC8LGC7luRbGqJ81o+bVbHruW5y5UJOx+vS5uAMBD
 Uq1IRAnXPWLez2WsI/HY67/4eBhW6Qoa8QFX5rGIq5eBf4dbGfoo2P6NW2akIsMkvBevRNP75Uq
 S1qzt9GL8eMaumQQhyfQVYhA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cf58ea9ff739a67e;
	Sat, 14 Nov 2026 08:32:30 +0000
X-Mizu-Trace-ID: cf58ea9ff739a67e
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 12/12] cpuset: remove update_parent_effective_cpumask
Date: Sat, 14 Nov 2026 16:31:24 +0800
Message-Id: <20261114083124.1340140-13-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261114083124.1340140-1-ridong.chen@linux.dev>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Clean up by removing the update_parent_effective_cpumask() function.
Its logic has now been fully replaced and centralized by the new
helper functions.

The partition_cmd enum type is removed as well, as it is no longer
referenced.

Update the comment about where subpartitions_cpus and isolated_cpus are
updated, which is now done in the common partition helpers for both
local and remote partitions.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 329 +----------------------------------------
 1 file changed, 6 insertions(+), 323 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1eb7d11e1cbf..b4255c033310 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -133,9 +133,9 @@ static DEFINE_MUTEX(cpuset_mutex);
  */
 
 /*
- * For local partitions, update to subpartitions_cpus & isolated_cpus is done
- * in update_parent_effective_cpumask(). For remote partitions, it is done in
- * the remote_partition_*() and remote_cpus_update() helpers.
+ * Updates to subpartitions_cpus & isolated_cpus for both local and remote
+ * partitions are done in the partition_enable(), partition_disable() and
+ * partition_update() helpers.
  */
 /*
  * Exclusive CPUs distributed out to local or remote sub-partitions of
@@ -1135,17 +1135,6 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 	css_task_iter_end(&it);
 }
 
-/*
- * Commands for update_parent_effective_cpumask
- */
-enum partition_cmd {
-	partcmd_enable,		/* Enable partition root	  */
-	partcmd_enablei,	/* Enable isolated partition root */
-	partcmd_disable,	/* Disable partition root	  */
-	partcmd_update,		/* Update parent's effective_cpus */
-	partcmd_invalidate,	/* Make partition invalid	  */
-};
-
 static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 				    struct tmpmasks *tmp);
 
@@ -1603,7 +1592,7 @@ static int compute_trialcs_excpus(struct cpuset *trialcs, struct cpuset *cs)
  * This has the side effect of invalidating valid child partition roots,
  * if necessary. Since it is called from either cpuset_hotplug_update_tasks()
  * or update_cpumasks_hier() where parent and children are modified
- * successively, we don't need to call update_parent_effective_cpumask()
+ * successively, we don't need to call local_partition_update()
  * and the child's effective_cpus will be updated in later iterations.
  */
 static void compute_partition_effective_cpumask(struct cpuset *cs,
@@ -2178,312 +2167,6 @@ static int local_partition_update(struct cpuset *cs, struct tmpmasks *tmp)
 					excl_check);
 }
 
-/**
- * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
- * @cs:      The cpuset that requests change in partition root state
- * @cmd:     Partition root state change command
- * @newmask: Optional new effective xcpus for partcmd_update
- * @tmp:     Temporary addmask and delmask
- * Return:   0 or a partition root state error code
- *
- * For partcmd_enable*, the cpuset is being transformed from a non-partition
- * root to a partition root. The effective_xcpus (cpus_allowed if
- * effective_xcpus not set) mask of the given cpuset will be taken away from
- * parent's effective_cpus. The function will return 0 if all the CPUs listed
- * in effective_xcpus can be granted or an error code will be returned.
- *
- * For partcmd_disable, the cpuset is being transformed from a partition
- * root back to a non-partition root. Any CPUs in effective_xcpus will be
- * given back to parent's effective_cpus. 0 will always be returned.
- *
- * For partcmd_update, if the optional newmask is specified, the cpu list is
- * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus
- * will be computed and a valid partition will be invalidated if it is the new
- * cpumask is empty. The cpuset should either be a valid or invalid partition
- * root. The partition root state may change from valid to invalid or vice
- * versa.
- *
- * For partcmd_invalidate, the current partition will be made invalid.
- *
- * The partcmd_enable* and partcmd_disable commands are used by
- * update_prstate(). An error code may be returned and the caller will check
- * for error.
- *
- * The partcmd_update command is used by update_cpumasks_hier() with newmask
- * NULL and update_cpumask() with newmask set. The partcmd_invalidate is used
- * by update_cpumask() with NULL newmask. In both cases, the callers won't
- * check for error and so partition_root_state and prs_err will be updated
- * directly.
- */
-static int __maybe_unused update_parent_effective_cpumask(struct cpuset *cs, int cmd,
-							  struct cpumask *newmask,
-							  struct tmpmasks *tmp)
-{
-	struct cpuset *parent = parent_cs(cs);
-	int adding;	/* Adding cpus to parent's effective_cpus	*/
-	int deleting;	/* Deleting cpus from parent's effective_cpus	*/
-	int old_prs, new_prs;
-	int part_error = PERR_NONE;	/* Partition error? */
-	int parent_prs = parent->partition_root_state;
-	bool nocpu;
-
-	lockdep_assert_cpuset_lock_held();
-	WARN_ON_ONCE(is_remote_partition(cs));	/* For local partition only */
-
-	/*
-	 * new_prs will only be changed for the partcmd_update and
-	 * partcmd_invalidate commands.
-	 */
-	adding = deleting = false;
-	old_prs = new_prs = cs->partition_root_state;
-
-	/*
-	 * The parent must be a partition root.
-	 * The new cpumask, if present, or the current cpus_allowed must
-	 * not be empty.
-	 */
-	if (!is_partition_valid(parent)) {
-		return is_partition_invalid(parent)
-		       ? PERR_INVPARENT : PERR_NOTPART;
-	}
-	if (!newmask && xcpus_empty(cs))
-		return PERR_CPUSEMPTY;
-
-	/*
-	 * Except for partcmd_disable and non-NULL newmask, use delmask
-	 * to compute the current effective xcpus value and use it for
-	 * tasks_nocpu_error check.
-	 */
-	if ((cmd != partcmd_disable) && !newmask) {
-		compute_excpus(cs, tmp->delmask);
-		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
-	}
-
-	if (newmask) {
-		/*
-		 * Empty cpumask is not allowed
-		 */
-		if (cpumask_empty(newmask)) {
-			part_error = PERR_CPUSEMPTY;
-			goto write_error;
-		}
-		if ((parent_prs == PRS_ISOLATED) && (old_prs == -PRS_ROOT)) {
-			part_error = PERR_ISOPARENT;
-			goto write_error;
-		}
-
-		/* Check newmask whether cpus are available for parent/cs */
-		nocpu = tasks_nocpu_error(parent, cs, newmask);
-
-		/*
-		 * partcmd_update with newmask:
-		 *
-		 * Compute add/delete mask to/from effective_cpus
-		 *
-		 * For valid partition:
-		 *   addmask = effective_xcpus & ~newmask
-		 *			      & parent->effective_xcpus
-		 *   delmask = newmask & ~effective_xcpus
-		 *		       & parent->effective_xcpus
-		 *
-		 * For invalid partition:
-		 *   delmask = newmask & parent->effective_xcpus
-		 *   The partition may become valid soon.
-		 */
-		if (is_partition_invalid(cs)) {
-			adding = false;
-			deleting = cpumask_and(tmp->delmask,
-					newmask, parent->effective_xcpus);
-		} else {
-			cpumask_andnot(tmp->addmask, cs->effective_xcpus, newmask);
-			adding = cpumask_and(tmp->addmask, tmp->addmask,
-					     parent->effective_xcpus);
-
-			cpumask_andnot(tmp->delmask, newmask, cs->effective_xcpus);
-			deleting = cpumask_and(tmp->delmask, tmp->delmask,
-					       parent->effective_xcpus);
-		}
-
-		/*
-		 * The new CPUs to be removed from parent's effective CPUs
-		 * must be present.
-		 */
-		if (deleting) {
-			cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
-			WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
-		}
-
-		/*
-		 * Make partition invalid if parent's effective_cpus could
-		 * become empty and there are tasks in the parent.
-		 */
-		if (nocpu && (!adding ||
-		    !cpumask_intersects(tmp->addmask, cpu_active_mask))) {
-			part_error = PERR_NOCPUS;
-			deleting = false;
-			adding = cpumask_and(tmp->addmask,
-					     cs->effective_xcpus, parent->effective_xcpus);
-		}
-	} else {
-		/*
-		 * partcmd_update w/o newmask
-		 *
-		 * delmask = newly computed effective xcpus value
-		 *
-		 * This can be called from:
-		 * 1) update_cpumasks_hier()
-		 * 2) cpuset_hotplug_update_tasks()
-		 *
-		 * Check to see if it can be transitioned from valid to
-		 * invalid partition or vice versa.
-		 *
-		 * A partition error happens when parent has tasks and all
-		 * its effective CPUs will have to be distributed out.
-		 */
-		nocpu |= cpumask_empty(tmp->delmask);
-		if (nocpu) {
-			part_error = PERR_NOCPUS;
-			if (is_partition_valid(cs))
-				adding = cpumask_and(tmp->addmask,
-						     cs->effective_xcpus,
-						     parent->effective_xcpus);
-		} else if ((parent_prs == PRS_ISOLATED) &&
-			   ((old_prs == PRS_ROOT) || (old_prs == -PRS_ROOT))) {
-			/* Parent partition state changed to PRS_ISOLATED */
-			part_error = PERR_ISOPARENT;
-			if (old_prs == PRS_ROOT) {
-				cpumask_copy(tmp->addmask, cs->effective_xcpus);
-				adding = true;
-			}
-		} else if (is_partition_valid(cs) &&
-			   !cpumask_equal(tmp->delmask, cs->effective_xcpus)) {
-			/*
-			 * If there is an expansion of parent's effective_xcpus,
-			 * we may take more xcpus from parent. The parent's
-			 * effective_cpus should still have active CPUs or nocpu
-			 * should have been set. We also need to do a
-			 * housekeeping check for an isolated child with root
-			 * parent to make sure that it won't exhaust all the
-			 * active housekeeping CPUs.
-			 */
-			cpumask_andnot(tmp->addmask, cs->effective_xcpus, tmp->delmask);
-			if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED) &&
-			    prstate_housekeeping_conflict(old_prs, parent_prs,
-							  tmp->delmask, tmp->addmask)) {
-				adding = cpumask_and(tmp->addmask, cs->effective_xcpus,
-						     tmp->delmask);
-				part_error = PERR_HKEEPING;
-			} else {
-				deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
-							  cs->effective_xcpus);
-			}
-		} else if (is_partition_invalid(cs)) {
-			struct cgroup_subsys_state *css;
-			struct cpuset *child;
-			bool exclusive = true;
-
-			/*
-			 * Convert invalid partition to valid has to pass the
-			 * cpu exclusivity test when cpuset.cpus.exclusive is
-			 * empty as well as the housekeeping check.
-			 */
-			if (prstate_housekeeping_conflict(cs->partition_root_state,
-							  parent_prs, tmp->delmask, NULL)) {
-				part_error = PERR_HKEEPING;
-				goto write_error;
-			}
-			if (cpumask_empty(cs->exclusive_cpus)) {
-				rcu_read_lock();
-				cpuset_for_each_child(child, css, parent) {
-					if (child == cs)
-						continue;
-					if (!cpusets_are_exclusive(cs, child)) {
-						exclusive = false;
-						break;
-					}
-				}
-				rcu_read_unlock();
-			}
-			if (exclusive)
-				deleting = !cpumask_empty(tmp->delmask);
-			else
-				part_error = PERR_NOTEXCL;
-		}
-	}
-
-write_error:
-	if (part_error)
-		WRITE_ONCE(cs->prs_err, part_error);
-
-	if (cmd == partcmd_update) {
-		/*
-		 * Check for possible transition between valid and invalid
-		 * partition root.
-		 */
-		switch (cs->partition_root_state) {
-		case PRS_ROOT:
-		case PRS_ISOLATED:
-			if (part_error)
-				new_prs = -old_prs;
-			break;
-		case PRS_INVALID_ROOT:
-		case PRS_INVALID_ISOLATED:
-			if (!part_error)
-				new_prs = -old_prs;
-			break;
-		}
-	}
-
-	if (!adding && !deleting && (new_prs == old_prs))
-		return 0;
-
-	/*
-	 * Change the parent's effective_cpus & effective_xcpus (top cpuset
-	 * only).
-	 *
-	 * Newly added CPUs will be removed from effective_cpus and
-	 * newly deleted ones will be added back to effective_cpus.
-	 */
-	if (old_prs < 0 && new_prs > 0) {
-		/*
-		 * An invalid partition becomes valid again, its effective_xcpus
-		 * was cleared or recomputed when it was invalidated.
-		 */
-		partition_enable(cs, parent, new_prs, tmp->delmask);
-	} else {
-		spin_lock_irq(&callback_lock);
-		if (old_prs != new_prs)
-			cs->partition_root_state = new_prs;
-
-		/*
-		 * Adding to parent's effective_cpus means deletion CPUs from cs
-		 * and vice versa.
-		 */
-		if (adding)
-			partition_xcpus_del(old_prs, parent, tmp->addmask);
-		if (deleting)
-			partition_xcpus_add(new_prs, parent, tmp->delmask);
-
-		spin_unlock_irq(&callback_lock);
-	}
-
-	if (adding || deleting) {
-		cpuset_update_tasks_cpumask(parent, tmp->addmask);
-		update_sibling_cpumasks(parent, cs, tmp);
-	}
-
-	/*
-	 * For partcmd_update without newmask, it is being called from
-	 * cpuset_handle_hotplug(). Update the load balance flag and
-	 * scheduling domain accordingly.
-	 */
-	if ((cmd == partcmd_update) && !newmask)
-		update_partition_sd_lb(cs, old_prs);
-
-	notify_partition_change(cs, old_prs);
-	return 0;
-}
-
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2546,7 +2229,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		/*
 		 * A partition with no effective_cpus is allowed as long as
 		 * there is no task associated with it. Call
-		 * update_parent_effective_cpumask() to check it.
+		 * local_partition_update() to check it.
 		 */
 		if (is_partition_valid(cp) && cpumask_empty(tmp->new_cpus)) {
 			update_parent = true;
@@ -2570,7 +2253,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 
 update_parent_effective:
 		/*
-		 * update_parent_effective_cpumask() should have been called
+		 * local_partition_update() should have been called
 		 * for cs already in update_cpumask(). We should also call
 		 * cpuset_update_tasks_cpumask() again for tasks in the parent
 		 * cpuset if the parent's effective_cpus changes.
-- 
2.34.1


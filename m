Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.85
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645150;
	b=ut1oNuiMmn8mc/Igdtxjx4NjTlRNAVWVQhtrZfW2dvpmgtu08qXvD6yopV8L7a5SEAmU
	 tXUvSW3ni5ORqFIjTwdcRfVgP2xHlFbLBauO9PnvN3z6MhZaNUhIsYj5Rfe76KVzH1eO/
	 H9SWIlXc8vnS3OdiqKdXZ+SHHGkpcXgk/kFUW2DftvsUrUNyD2bWYRQGHkLbuFXIXOXiZ
	 rxbJ3hWtpV6B5v8jchVmINXob51XsAO7nlDn5/y1PK3uJ1AdKVOVLUxrjOhEP9vYGdNUp
	 Wrmr1l8+BHQg0SaKvubHEvHE2EXPVzhbU6BsFqRNTsNC7HgOpbS5OpgBVlwF0DueVTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645150;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EnDFVXvGL6XT09GGgfazO38SKE/Eg+f4tGNPC60vKrU=;
	b=t8d8zux/ebBUaSSq3V7MO0YqJrte0E1GJW9d9AXWvyoWK3S+Rc+2WTTxd6qKrSpUwI30
	 n6bMrQSqYz9aoxwateO9TZtGuX6gQr/AbGqIe8jv7bALzlNZ4st87Kz6NCWAXwytlwj3h
	 Z+KfJFh33dN+ux1smyJfAeNbw9lPw19P9mtagOVBl0KuVmtlDbtq+dJ2FmH8jU4JtJHLo
	 80HL+Nw6JrYknfTuee1xDgLCXs+gZEMbEb6b8KSenAzOHdPx3S0bEw3OdZKMb2utTRzaX
	 VrQ2egiXbnrboW4KMbJDvPb4ue9bpB1ZtDpIGM+RXTmsGAnaGb314OyECXZvwAA8cGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="MZanP/6Y";
	arc=none smtp.remote-ip=95.215.58.85
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAFD606A334
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:32:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BAFD606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MZanP/6Y
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vcmXUwJsLiHk10oDycOz82S2MIIx3W7DrdArZml/2Fg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645147; v=1; x=1795249947;
 b=MZanP/6Ynn8LAerXJqaY4ecI9GrMs5hMLgktiQomi42OPAeyKycUpjAraIUMczVJl/6yPXCQ
 z4iDcqOvsILAOrodGDRKKn77s9qQ/oOZhPQwT5Yd6VpSJvsINrMgpcc1gLn8yCewCg6glOCSQ7A
 +wz/KUULmhSYBPYmHrHzUd7w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 75189bcc3a3d4a86;
	Sat, 14 Nov 2026 08:32:27 +0000
X-Mizu-Trace-ID: 75189bcc3a3d4a86
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
Subject: [PATCH v5 11/12] cpuset: introduce local_partition_update()
Date: Sat, 14 Nov 2026 16:31:23 +0800
Message-Id: <20261114083124.1340140-12-ridong.chen@linux.dev>
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

Factor the partcmd_update handling without a new cpumask out of
update_parent_effective_cpumask() into local_partition_update(), and
the one with a new cpumask, used by partition_cpus_change(), into
__local_partition_update().

__local_partition_update() validates the new effective exclusive CPUs
with validate_local_partition(), then:

 - if the validation fails, a valid partition is invalidated with
   partition_disable(), while an invalid partition only has its error
   code updated. The error code is kept if the parent is not a valid
   partition root, e.g. for a remote partition invalidated by hotplug,
   as the cpuset can't become a valid local partition anyway.
 - if the validation passes, an invalid partition becomes valid again
   with partition_enable(), and a valid partition has its CPUs updated
   with partition_update().

local_partition_update() computes the new effective exclusive CPUs
with compute_excpus() as before. As in the old partcmd_update path, the
sibling exclusivity check is only done for an invalid partition with an
empty cpuset.cpus.exclusive, as a valid partition has passed it
already.

cpuset_hotplug_update_tasks() now calls local_partition_update() for
both the invalidation and the revival of a local partition, instead of
open coding the invalidation conditions. The only exception is when
subpartitions_cpus becomes empty because no CPU is left for
top_cpuset, in which case the local partition is disabled directly
with PERR_HOTPLUG. A remote partition only needs the hotplug
invalidation check, so jump to update_tasks right after it. As
partition_disable() gives the CPUs back to the parent and updates
effective_cpus of the cpuset directly, effective_cpus is saved before
any partition state change and the new effective cpumask is compared
against it. Otherwise the tasks of a partition invalidated by hotplug
may be left with only the offlined CPUs.

In update_cpumasks_hier(), effective_cpus of the child is now updated
before local_partition_update() is called, as tmp->new_cpus is reused
by it. For the same reason, the effective cpumask is always recomputed
afterwards.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 201 +++++++++++++++++++++++++++++------------
 1 file changed, 143 insertions(+), 58 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 038bed1f4fb8..1eb7d11e1cbf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2084,6 +2084,100 @@ static int local_partition_enable(struct cpuset *cs,
 	return 0;
 }
 
+/**
+ * __local_partition_update - Update local partition configuration
+ * @cs: Target cpuset to update
+ * @xcpus: New exclusive CPU mask
+ * @excpus: New effective exclusive CPU mask
+ * @tmp: Temporary mask storage for intermediate calculations
+ * @excl_check: Flag to enable exclusivity validation
+ *
+ * Handles updates to local CPU partition configurations by validating
+ * changes, managing state transitions, and propagating updates through
+ * the cpuset hierarchy.
+ *
+ * Note on exclusivity checking: Exclusivity validation is required when
+ * transitioning from an invalid to valid partition state. However, when
+ * updating cpus_allowed or exclusive_cpus, exclusivity should have already
+ * been verified by validate_change(). In such cases, excl_check must be
+ * false since the cs cpumasks are not yet updated.
+ *
+ * Return: Partition error code (PERR_NONE indicates success)
+ */
+static int __local_partition_update(struct cpuset *cs, struct cpumask *xcpus,
+				    struct cpumask *excpus, struct tmpmasks *tmp,
+				    bool excl_check)
+{
+	struct cpuset *parent = parent_cs(cs);
+	int part_error = PERR_NONE;	/* Partition error? */
+	int old_prs, new_prs;
+
+	lockdep_assert_cpuset_lock_held();
+	/* For local partition only */
+	if (WARN_ON_ONCE(is_remote_partition(cs) || cs_is_member(cs)))
+		return PERR_NONE;
+
+	old_prs = cs->partition_root_state;
+	/*
+	 * If new_prs < 0, it might transition to valid partition state.
+	 * Use absolute value for validation checks.
+	 */
+	new_prs = old_prs < 0 ? -old_prs : old_prs;
+	cpumask_andnot(tmp->addmask, excpus, cs->effective_xcpus);
+	cpumask_andnot(tmp->delmask, cs->effective_xcpus, excpus);
+	part_error = validate_local_partition(cs, new_prs, excpus,
+					      excl_check, tmp);
+	if (part_error) {
+		/*
+		 * An invalid partition only needs to update its error code.
+		 * Keep the error code if the parent is not a valid partition
+		 * root, e.g. for an invalidated remote partition, as the
+		 * cpuset can't become a valid local partition anyway.
+		 */
+		if (is_partition_valid(cs))
+			partition_disable(cs, -new_prs, part_error, tmp);
+		else if (is_partition_valid(parent))
+			WRITE_ONCE(cs->prs_err, part_error);
+		return part_error;
+	}
+
+	/* Nothing changes, return PERR_NONE */
+	if (new_prs == old_prs &&
+	    (cpumask_empty(tmp->addmask) && cpumask_empty(tmp->delmask)))
+		return PERR_NONE;
+
+	/*
+	 * If partition was previously invalid but now passes checks,
+	 * re-enable it and update related flags.
+	 * Otherwise, partition state doesn't change, only cpumasks change.
+	 */
+	if (is_partition_invalid(cs)) {
+		partition_enable(cs, parent, new_prs, excpus);
+		update_partition_sd_lb(cs, old_prs);
+	} else {
+		partition_update(cs, new_prs, xcpus, excpus, tmp);
+	}
+
+	cpuset_update_tasks_cpumask(parent, tmp->addmask);
+	update_sibling_cpumasks(parent, cs, tmp);
+	return PERR_NONE;
+}
+
+static int local_partition_update(struct cpuset *cs, struct tmpmasks *tmp)
+{
+	/*
+	 * A valid partition has passed the exclusivity check already. An
+	 * invalid partition has to pass it before becoming valid again when
+	 * cpuset.cpus.exclusive is empty.
+	 */
+	bool excl_check = is_partition_invalid(cs) &&
+			  cpumask_empty(cs->exclusive_cpus);
+
+	compute_excpus(cs, tmp->new_cpus);
+	return __local_partition_update(cs, NULL, tmp->new_cpus, tmp,
+					excl_check);
+}
+
 /**
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
@@ -2121,9 +2215,9 @@ static int local_partition_enable(struct cpuset *cs,
  * check for error and so partition_root_state and prs_err will be updated
  * directly.
  */
-static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
-					   struct cpumask *newmask,
-					   struct tmpmasks *tmp)
+static int __maybe_unused update_parent_effective_cpumask(struct cpuset *cs, int cmd,
+							  struct cpumask *newmask,
+							  struct tmpmasks *tmp)
 {
 	struct cpuset *parent = parent_cs(cs);
 	int adding;	/* Adding cpus to parent's effective_cpus	*/
@@ -2143,23 +2237,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	adding = deleting = false;
 	old_prs = new_prs = cs->partition_root_state;
 
-	if (cmd == partcmd_invalidate) {
-		if (is_partition_invalid(cs))
-			return 0;
-
-		/*
-		 * Make the current partition invalid.
-		 */
-		if (is_partition_valid(parent))
-			adding = cpumask_and(tmp->addmask,
-					     cs->effective_xcpus,
-					     parent->effective_xcpus);
-		if (old_prs > 0)
-			new_prs = -old_prs;
-
-		goto write_error;
-	}
-
 	/*
 	 * The parent must be a partition root.
 	 * The new cpumask, if present, or the current cpus_allowed must
@@ -2527,14 +2604,21 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		if (!css_tryget_online(&cp->css))
 			continue;
 		rcu_read_unlock();
+		/*
+		 * The tmp->new_cpus may be modified.
+		 * Update effective_cpus before passing tmp to other functions.
+		 */
+		spin_lock_irq(&callback_lock);
+		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
+		spin_unlock_irq(&callback_lock);
 
 		if (update_parent) {
-			update_parent_effective_cpumask(cp, partcmd_update, NULL, tmp);
+			local_partition_update(cp, tmp);
 			/*
 			 * Capture current partition_root_state as it may have
 			 * changed. Always recompute effective cpumask as tmp->new_cpus
 			 * may be clobbered when update_sibling_cpumasks() is called
-			 * within update_parent_effective_cpumask().
+			 * within local_partition_update().
 			 */
 			new_prs = cp->partition_root_state;
 			compute_effective_cpumask(tmp->new_cpus, cp, parent);
@@ -2693,8 +2777,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 					   trialcs->effective_xcpus, tmp);
 	} else {
 		if (!trialcs->prs_err)
-			update_parent_effective_cpumask(cs, partcmd_update,
-							trialcs->effective_xcpus, tmp);
+			__local_partition_update(cs, trialcs->exclusive_cpus,
+						 trialcs->effective_xcpus, tmp, false);
 		else if (is_partition_valid(cs))
 			partition_disable(cs, -cs->partition_root_state,
 					  trialcs->prs_err, tmp);
@@ -4149,61 +4233,62 @@ void cpuset_force_rebuild(void)
  */
 static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 {
-	static cpumask_t new_cpus;
+	static cpumask_t new_cpus, old_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated;
 	bool mems_updated;
-	int partcmd = -1;
 	struct cpuset *parent;
 
 	wait_attach_done_lock();
 	parent = parent_cs(cs);
+	/*
+	 * Partition state changes below may update effective_cpus directly,
+	 * save it to check if tasks need to be updated.
+	 */
+	cpumask_copy(&old_cpus, cs->effective_cpus);
 	compute_effective_cpumask(&new_cpus, cs, parent);
 	compute_effective_nodemask(&new_mems, cs, parent);
 
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
 
-	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
-				       (cpumask_empty(&new_cpus) &&
-					partition_is_populated(cs, NULL)))) {
-		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
-		partition_disable(cs, -cs->partition_root_state, cs->prs_err,
-				  tmp);
-		compute_effective_cpumask(&new_cpus, cs, parent);
+	/*
+	 * Compute effective_cpus for valid partition root, may invalidate
+	 * child partition roots if necessary.
+	 */
+	if (is_remote_partition(cs)) {
+		if (cpumask_empty(subpartitions_cpus) ||
+		    (cpumask_empty(&new_cpus) &&
+		     partition_is_populated(cs, NULL))) {
+			WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
+			partition_disable(cs, -cs->partition_root_state,
+					  cs->prs_err, tmp);
+			compute_effective_cpumask(&new_cpus, cs, parent);
+		}
+		goto update_tasks;
 	}
 
 	/*
-	 * Force the partition to become invalid if either one of
-	 * the following conditions hold:
-	 * 1) empty effective cpus but not valid empty partition.
-	 * 2) parent is invalid or doesn't grant any cpus to child
-	 *    partitions.
-	 * 3) subpartitions_cpus is empty.
+	 * The subpartitions_cpus may be cleared if no CPUs remain available for
+	 * the top_cpuset. In this case, disable the local partition directly.
+	 * Otherwise, local_partition_update() will handle the automatic
+	 * transition between valid and invalid partition states.
 	 */
-	if (is_local_partition(cs) &&
-	    (!is_partition_valid(parent) ||
-	     tasks_nocpu_error(parent, cs, &new_cpus) ||
-	     cpumask_empty(subpartitions_cpus)))
-		partcmd = partcmd_invalidate;
+	if (is_local_partition(cs) && cpumask_empty(subpartitions_cpus))
+		partition_disable(cs, -cs->partition_root_state, PERR_HOTPLUG,
+				  tmp);
+	else
+		local_partition_update(cs, tmp);
+
 	/*
-	 * On the other hand, an invalid partition root may be transitioned
-	 * back to a regular one with a non-empty effective xcpus.
+	 * Recompute effective CPU mask after partition state update:
+	 * - For valid partitions: calculate partition-specific effective CPUs
+	 * - For invalid partitions: compute member effective CPU mask
 	 */
-	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
-		 !cpumask_empty(cs->effective_xcpus))
-		partcmd = partcmd_update;
-
-	if (partcmd >= 0) {
-		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
-		if (is_partition_valid(cs) || (partcmd == partcmd_invalidate)) {
-			compute_effective_cpumask(&new_cpus, cs, parent);
-			cpuset_force_rebuild();
-		}
-	}
+	compute_effective_cpumask(&new_cpus, cs, parent);
 
 update_tasks:
-	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
+	cpus_updated = !cpumask_equal(&new_cpus, &old_cpus);
 	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
 	if (!cpus_updated && !mems_updated)
 		goto unlock;	/* Hotplug doesn't affect this cpuset */
-- 
2.34.1


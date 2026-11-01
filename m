Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.109
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533450;
	b=hy/Tf27grydedvoUbGXq53MOGJV9sEg+lCnb0O1UpUgmGfC4JmlegxKWKaBcf3ANxI+J
	 CveTj8ZEZVm8h0CIjr8RtaLfX5vJ55Um8kXEqlIjyuHch4T0PW236hW1wq78+oLKtHa/1
	 z47UqOlWYT0cx7JL6l8Jqk/zPegw4fDq9t/NsIWmI2QkXB3u6WfxADAEqXhfdGUkNPVCN
	 0ZcfISYdpZc5nvZmAaHUNgiaqw2p42c+TNeEBaELsicu3dwS4zj11LSwykvJJ8mx3XwPW
	 AJxofMlp5iCLLOFpBkUdnYGdgsnEHFIpPi43plXGFUoBHVT/83UOKuefE8AkpbWfd6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533450;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RVVv3zgFkylUwF1PkhMtcoaycUKLJCLwjNAysmZyhV4=;
	b=3OAcdDyBtajJ3fk3MyjmZ6XDtETzb6PmGnJISvyKdWQZmpxVdViI45Xnil973jtQtgs3
	 UugW5jggcTaY8nuWVKww6+weNFAuysmmhtqCDF8Gj/3YznO/pg1byd5WkHOncaULB6w3f
	 287aDBp3+esG12JF49q5AOer616wf4lUr5p6Ev2JPvpvYhqYQoJOv9G1kPJU9CE/NDcrk
	 3VHa/f83YJpw4L9AuLpqYTVD5oam606OwR2hyJpKUbXu95FOUTAYIcwyfDec7q9KI+YRZ
	 RVnLhYz3OUYjqKBg84YB2fBApQOHjeCyvyHJxCnVbOXSr0PxlKd1etpdz8X4+riZHyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JtYdZPa4;
	arc=none smtp.remote-ip=91.218.175.109
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BB9606A324
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47BB9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JtYdZPa4
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qnpM/GcYOikB0LXEG9SLoFQIOm3AK7Pwq+k0WxQO19Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533448; v=1; x=1794138248;
 b=JtYdZPa4p8oyW6J9OE/md3mZqZFONkyM48O3SLjmliogQVaTvy/JJveOlfmO5rGDFXvJ+H6b
 WqgpInrtu0st4jOQtRlJe/09BD53GJRHqbwENeQp0erFOSBJ+0M4B6lfI5dDjdCEOUvWKvfhEbR
 jig14mJcGXRRzDlDxwt1J958=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e22b6dcfc44cb011;
	Sun, 01 Nov 2026 11:44:07 +0000
X-Mizu-Trace-ID: e22b6dcfc44cb011
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutn?" <mkoutny@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ridong <chenridong@huawei.com>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH -v4 13/22] cpuset: introduce local_partition_update()
Date: Sun,  1 Nov 2026 19:41:57 +0800
Message-Id: <20261101114206.2434398-14-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261101114206.2434398-1-ridong.chen@linux.dev>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
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

From: Chen Ridong <chenridong@huawei.com>

The local_partition_update() function replaces the command partcmd_update
previously handled within update_parent_effective_cpumask(). The update
logic follows a state-based approach:

1. Validation check: First verify if the local partition is currently valid
2. Invalidation handling: If the partition is invalid, trigger invalidation
3. State transition: If an invalid partition has no errors, transition to
   valid
4. cpumask updates: For a local partition whose cpumask only changes, use
   partition_update() to handle the change.

validate_local_partition() is added to check the local partition
specific requirements: the parent must be a valid partition root, a
root partition is not allowed under an isolated parent, and optionally
the user exclusive CPUs must not overlap with any sibling. It then
calls validate_partition() for the common checks.

local_partition_update() computes the new effective exclusive CPUs
with compute_excpus() as before. As in the old partcmd_update path, the
sibling exclusivity check is only done for an invalid partition with an
empty cpuset.cpus.exclusive, as a valid partition has passed it
already. If an invalid partition fails the validation again, only its
error code is updated, unless its parent is not a valid partition root.
In that case, e.g. for a remote partition invalidated by hotplug, the
original error code is kept as the cpuset can't become a valid local
partition anyway.

In update_cpumasks_hier(), effective_cpus of the child is now updated
before local_partition_update() is called, as tmp->new_cpus is reused
by it. For the same reason, the effective cpumask is always recomputed
afterwards.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 171 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 163 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 822cc1d97fca..d2cb989beab9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2074,6 +2074,155 @@ static void local_partition_disable(struct cpuset *cs, enum prs_errcode part_err
 	update_sibling_cpumasks(parent, cs, tmp);
 }
 
+static bool is_user_xcpus_exclusive(struct cpuset *cs)
+{
+	struct cpuset *parent = parent_cs(cs);
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+	bool exclusive = true;
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, parent) {
+		if (child == cs)
+			continue;
+		if (!cpusets_are_exclusive(cs, child)) {
+			exclusive = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return exclusive;
+}
+
+/**
+ * validate_local_partition - Validate for local partition
+ * @cs: Target cpuset to validate
+ * @new_prs: New partition root state to validate
+ * @excpus: New effective exclusive CPUs mask to validate
+ * @excl_check: Flag to enable exclusive CPUs ownership validation
+ * @tmp: Temporary masks
+ *
+ * Return: PERR_NONE if validation passes, appropriate error code otherwise
+ *
+ * Important: The caller must ensure that @cs's cpu mask is updated before
+ * invoking this function when exclusive CPU validation is required.
+ */
+static enum prs_errcode validate_local_partition(struct cpuset *cs, int new_prs,
+			struct cpumask *excpus, bool excl_check, struct tmpmasks *tmp)
+{
+	struct cpuset *parent = parent_cs(cs);
+
+	/* The parent must be a partition root */
+	if (!is_partition_valid(parent)) {
+		return is_partition_invalid(parent)
+			? PERR_INVPARENT : PERR_NOTPART;
+	}
+
+	/* A root partition is not allowed under an isolated parent */
+	if (new_prs == PRS_ROOT && parent->partition_root_state == PRS_ISOLATED)
+		return PERR_ISOPARENT;
+
+	if (excl_check && !is_user_xcpus_exclusive(cs))
+		return PERR_NOTEXCL;
+
+	return validate_partition(cs, parent, new_prs, excpus,
+				  tmp ? tmp->delmask : NULL);
+}
+
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
+			local_partition_disable(cs, part_error, tmp);
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
@@ -2483,17 +2632,23 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
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
-			 * changed. Recompute effective cpumask if changed.
+			 * changed. tmp->new_cpus is reused by
+			 * local_partition_update(), recompute effective cpumask.
 			 */
 			new_prs = cp->partition_root_state;
-			if (new_prs != old_prs) {
-				compute_effective_cpumask(tmp->new_cpus, cp, parent);
-			}
+			compute_effective_cpumask(tmp->new_cpus, cp, parent);
 		}
 
 		spin_lock_irq(&callback_lock);
@@ -2650,8 +2805,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		if (trialcs->prs_err)
 			local_partition_disable(cs, trialcs->prs_err, tmp);
 		else
-			update_parent_effective_cpumask(cs, partcmd_update,
-							trialcs->effective_xcpus, tmp);
+			__local_partition_update(cs, trialcs->exclusive_cpus,
+						 trialcs->effective_xcpus, tmp, false);
 	}
 }
 
@@ -4138,7 +4293,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
 		 !cpumask_empty(user_xcpus(cs))) {
 		partcmd = partcmd_update;
-		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
+		local_partition_update(cs, tmp);
 	}
 
 	if (partcmd >= 0) {
-- 
2.34.1


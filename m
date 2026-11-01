Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.186
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533500;
	b=BjP4lHccbBJO6Dt6O9c8OiL1zkXsbJxI9d8fckb9gJI5pxzvrFJXyrSMaF3y1C7Spwkq
	 F2tE4hekqXQFneYJ4fH2XoL+5FKiDz8EUaM7uyoVWTnHPmEu9HEX/z6Uwl5ArbpcTp8VO
	 VoVq6DGsXbrANIHDoQtIfAXMifM7mH7JqFngiye3SyADoExz2g0FZzNogYErSUAeU9mqM
	 84eY483uHAl38tChL3aIQyCvXgKcBqNYpGpBKgCo/vbVl6gBGVe76YARDUzfUZPsFdGaj
	 YLUtJIH619hhVtUeEHSN+wlKc+4LzCG7fHbdBSMjfaFtvvZ1rxWiPXI2HhYdhc7XBgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533500;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p44C7J5Y3qZdr2W9BHb9txSSPP0JZqhG+8YraQJaROY=;
	b=HrTFXM31Pmn6iF8nA3SJvBnri9JNKSfvUNv184MrEMkHH5ykKixATSQNgqtSigFXLgKZ
	 LHas3GYxom1K7mRylIc+ELW/DwntqPp54/x/FqQf4RlUQVv3WWzjLkyscZyh9Xpa/LEEu
	 Qn0aq5n/jh4YDmhzpDlP4Myas5L/LNdHrwIzQrBE6l214WYfgoQLSPQzvECvdRWE94kwq
	 cam0xPTCs77cjr1twfxYHF8xC1jtAzOKdPA6dW6GCR6Zmx6XH4I5ZjQsUIBUC8GXhDXHi
	 rpnw4iB5/KH/nwXnkHFa+Io8/qasI8S0Fc3Pqn7k1DzZzlZSOxo/EU2SlU2M1RuuVtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Wno+WXw+;
	arc=none smtp.remote-ip=95.215.58.186
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12153606A324
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12153606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Wno+WXw+
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=g7WWH7r5sfevRgfM8YrItzWLyXZIqza0pyW5W+1JVg8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533498; v=1; x=1794138298;
 b=Wno+WXw+NHPmqGUUlcLptFhTdgne2GUAVqbpg0kSBi7lUphbuBIcRYSn6d1qTAZNAK1clQi3
 4N9oqoQGfMuOGNnXUJso2yvDcr6mT3zh4i8Zx44VhNT1o3cZs4Ht2WHVts8H+FaS78IzhRspaEY
 7TZkrVjyR3ADednEB7LHxHIU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 560c75f26b013d0f;
	Sun, 01 Nov 2026 11:44:58 +0000
X-Mizu-Trace-ID: 560c75f26b013d0f
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
Subject: [RFC PATCH -v4 20/22] cpuset: simplify the update_prstate() function
Date: Sun,  1 Nov 2026 19:42:04 +0800
Message-Id: <20261101114206.2434398-21-ridong.chen@linux.dev>
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

This patch introduces partition_switch() to handle both local partition
and remote partition root state switches between "root" and "isolated".
It first validates the partition, via validate_local_partition() for a
local partition or validate_partition() for a remote one. If validation
fails, it returns an error and the partition is disabled; if validation
passes, it enables the partition with the new root state.

update_prstate_disable() is added to disable a partition from
update_prstate(). A valid partition gives back its CPUs through
remote_partition_disable() or local_partition_disable(), while a member
or an invalid partition only has its state updated through
partition_disable().

To support this, remote_partition_disable() and local_partition_disable()
now take the new partition root state from the caller instead of
deriving it from the error code.

With these helpers, update_prstate() can be simplified. The
partition-related assignments and the partition change notification in
update_prstate() are redundant, as these operations are already handled
by partition_enable() and partition_disable(). They are therefore
removed.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 141 ++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 64 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1ff5f9e4c2fb..29bce718ef92 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1919,6 +1919,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 /*
  * remote_partition_disable - Remove current cpuset from remote partition list
  * @cs: the cpuset to update
+ * @new_prs: new partition root state, PRS_MEMBER or an invalid state
  * @prs_err: partition error, PERR_NONE when switching back to member
  * @tmp: temporary masks
  *
@@ -1926,11 +1927,9 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
  *
  * cpuset_mutex must be held by the caller.
  */
-static void remote_partition_disable(struct cpuset *cs,
+static void remote_partition_disable(struct cpuset *cs, int new_prs,
 		enum prs_errcode prs_err, struct tmpmasks *tmp)
 {
-	int new_prs;
-
 	WARN_ON_ONCE(!is_remote_partition(cs));
 	/*
 	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
@@ -1941,7 +1940,6 @@ static void remote_partition_disable(struct cpuset *cs,
 	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
 		     !cpumask_empty(subpartitions_cpus));
 
-	new_prs = prs_err ? -cs->partition_root_state : PRS_MEMBER;
 	partition_disable(cs, NULL, new_prs, prs_err);
 
 	/*
@@ -1977,7 +1975,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	err = validate_remote_partition(cs, prs, excpus, tmp->addmask,
 					tmp->delmask);
 	if (err) {
-		remote_partition_disable(cs, err, tmp);
+		remote_partition_disable(cs, -prs, err, tmp);
 		return;
 	}
 
@@ -2090,14 +2088,15 @@ static int local_partition_enable(struct cpuset *cs,
 /**
  * local_partition_disable - Disable a local partition
  * @cs: Target cpuset (local partition root) to disable
+ * @new_prs: new partition root state, PRS_MEMBER or an invalid state
  * @part_error: partition error when @cs is disabled
  * @tmp: Temporary masks for CPU calculations
  */
-static void local_partition_disable(struct cpuset *cs, enum prs_errcode part_error,
+static void local_partition_disable(struct cpuset *cs, int new_prs,
+				    enum prs_errcode part_error,
 				    struct tmpmasks *tmp)
 {
 	struct cpuset *parent = parent_cs(cs);
-	int new_prs;
 
 	lockdep_assert_cpuset_lock_held();
 	WARN_ON_ONCE(is_remote_partition(cs));	/* For local partition only */
@@ -2105,7 +2104,6 @@ static void local_partition_disable(struct cpuset *cs, enum prs_errcode part_err
 	if (!is_partition_valid(cs))
 		return;
 
-	new_prs = part_error ? -cs->partition_root_state : PRS_MEMBER;
 	partition_disable(cs, parent, new_prs, part_error);
 
 	cpuset_update_tasks_cpumask(parent, tmp->addmask);
@@ -2163,7 +2161,7 @@ static int __local_partition_update(struct cpuset *cs, struct cpumask *xcpus,
 		 * cpuset can't become a valid local partition anyway.
 		 */
 		if (is_partition_valid(cs))
-			local_partition_disable(cs, part_error, tmp);
+			local_partition_disable(cs, -new_prs, part_error, tmp);
 		else if (is_partition_valid(parent))
 			WRITE_ONCE(cs->prs_err, part_error);
 		return part_error;
@@ -2489,13 +2487,15 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 
 	if (is_remote_partition(cs)) {
 		if (trialcs->prs_err)
-			remote_partition_disable(cs, trialcs->prs_err, tmp);
+			remote_partition_disable(cs, -cs->partition_root_state,
+						 trialcs->prs_err, tmp);
 		else
 			remote_cpus_update(cs, trialcs->exclusive_cpus,
 					   trialcs->effective_xcpus, tmp);
 	} else {
 		if (trialcs->prs_err)
-			local_partition_disable(cs, trialcs->prs_err, tmp);
+			local_partition_disable(cs, -cs->partition_root_state,
+						trialcs->prs_err, tmp);
 		else
 			__local_partition_update(cs, trialcs->exclusive_cpus,
 						 trialcs->effective_xcpus, tmp, false);
@@ -2906,6 +2906,56 @@ bool current_cpuset_is_being_rebound(void)
 	return ret;
 }
 
+/**
+ * partition_switch - Switch a valid partition between root and isolated
+ * @cs: The cpuset (local or remote partition root) to switch
+ * @new_prs: New partition root state, PRS_ROOT or PRS_ISOLATED
+ *
+ * Return: PERR_NONE if successful, error code otherwise
+ */
+static enum prs_errcode partition_switch(struct cpuset *cs, int new_prs)
+{
+	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
+	enum prs_errcode err;
+
+	lockdep_assert_cpuset_lock_held();
+	WARN_ON_ONCE(new_prs <= 0 || !is_partition_valid(cs));
+	WARN_ON_ONCE(!cpuset_v2());
+
+	if (parent)
+		err = validate_local_partition(cs, new_prs, cs->effective_xcpus,
+					       false, NULL);
+	else
+		err = validate_partition(cs, NULL, new_prs, cs->effective_xcpus,
+					 NULL);
+	if (err)
+		return err;
+
+	partition_enable(cs, parent, new_prs, cs->effective_xcpus);
+	return PERR_NONE;
+}
+
+/*
+ * update_prstate_disable - Disable a partition from update_prstate()
+ * @cs: the cpuset to disable
+ * @new_prs: new partition root state, PRS_MEMBER or an invalid state
+ * @err: partition error
+ * @tmp: temporary masks
+ *
+ * A valid partition gives back its CPUs, a member or an invalid partition
+ * only has its state updated.
+ */
+static void update_prstate_disable(struct cpuset *cs, int new_prs,
+				   enum prs_errcode err, struct tmpmasks *tmp)
+{
+	if (is_remote_partition(cs))
+		remote_partition_disable(cs, new_prs, err, tmp);
+	else if (is_partition_valid(cs))
+		local_partition_disable(cs, new_prs, err, tmp);
+	else
+		partition_disable(cs, parent_cs(cs), new_prs, err);
+}
+
 /**
  * update_prstate - update partition_root_state
  * @cs: the cpuset to update
@@ -2919,8 +2969,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
-	bool isolcpus_updated = false;
-	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -2966,68 +3014,31 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
 		}
 	} else if (old_prs && new_prs) {
-		int parent_prs = is_remote_partition(cs)
-				 ? PRS_ROOT : parent->partition_root_state;
-
-		/*
-		 * A change in load balance state only, no change in cpumasks.
-		 * Need to update isolated_cpus.
-		 */
-		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  cs->effective_xcpus, NULL))
-			err = PERR_HKEEPING;
-		else if (parent_prs == PRS_ISOLATED)
-			err = PERR_ISOPARENT;
-
-		if (!err)
-			isolcpus_updated = true;
-		else
-			disable_partition = true;
-	} else {
-		/*
-		 * Switching back to member is always allowed even if it
-		 * disables child partitions.
-		 */
-		disable_partition = true;
-	}
-
-	if (disable_partition) {
-		if (is_remote_partition(cs))
-			remote_partition_disable(cs, PERR_NONE, &tmpmask);
-		else
-			local_partition_disable(cs, PERR_NONE, &tmpmask);
-		/*
-		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier() below.
-		 */
+		/* Root state switches, eg, root --> isolated */
+		err = partition_switch(cs, new_prs);
 	}
-out:
 	/*
-	 * Make partition invalid if an error happens.
+	 * Switching back to member is always allowed even if it disables
+	 * child partitions. Invalidation of child partitions will be done in
+	 * update_cpumasks_hier() below.
 	 */
+	if (!new_prs)
+		update_prstate_disable(cs, PRS_MEMBER, PERR_NONE, &tmpmask);
+out:
+	/* Make partition invalid if an error happens */
 	if (err)
-		new_prs = -new_prs;
-
-	spin_lock_irq(&callback_lock);
-	cs->partition_root_state = new_prs;
-	WRITE_ONCE(cs->prs_err, err);
-	if (!is_partition_valid(cs))
-		reset_partition_data(cs);
-	else if (isolcpus_updated)
-		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
-	spin_unlock_irq(&callback_lock);
+		update_prstate_disable(cs, -new_prs, err, &tmpmask);
 
 	/* Force update if partition is disabled & update effective_xcpus */
-	update_cpumasks_hier(cs, &tmpmask, disable_partition);
+	update_cpumasks_hier(cs, &tmpmask, !new_prs || err);
 
 	/* A newly created partition must have effective_xcpus set */
-	WARN_ON_ONCE(!old_prs && (new_prs > 0)
+	WARN_ON_ONCE(!old_prs && (new_prs > 0) && !err
 			      && cpumask_empty(cs->effective_xcpus));
 
 	/* Update sched domains and load balance flag */
 	update_partition_sd_lb(cs, old_prs);
 
-	notify_partition_change(cs, old_prs);
 	free_tmpmasks(&tmpmask);
 	return 0;
 }
@@ -3939,7 +3950,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		if (cpumask_empty(subpartitions_cpus) ||
 		    (cpumask_empty(&new_cpus) &&
 		     partition_is_populated(cs, NULL))) {
-			remote_partition_disable(cs, PERR_HOTPLUG, tmp);
+			remote_partition_disable(cs, -cs->partition_root_state,
+						 PERR_HOTPLUG, tmp);
 			compute_effective_cpumask(&new_cpus, cs, parent);
 		}
 		goto update_tasks;
@@ -3952,7 +3964,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	 * transition between valid and invalid partition states.
 	 */
 	if (is_local_partition(cs) && cpumask_empty(subpartitions_cpus))
-		local_partition_disable(cs, PERR_HOTPLUG, tmp);
+		local_partition_disable(cs, -cs->partition_root_state,
+					PERR_HOTPLUG, tmp);
 	else
 		local_partition_update(cs, tmp);
 
-- 
2.34.1


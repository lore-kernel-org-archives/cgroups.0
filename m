Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533493;
	b=ayYzL5Qz+n4mYwVmVtDK4BueqVcuO/DPB0c2VelWVKj5krAJ99KU4gGZGCw6/f+DddnX
	 GPabU/vj4vgjfz1/7g+cbzOvYTTrqWPRJWiFNYLwHc5o1Y/YI7WJSNw4cTdgk4OuaRRj5
	 JPzoHTespdPM4bwy7TCgPS8WOpJAOJKnGIPbiKcOHjBnuQcrFcsiXADjlr0LO6TWNaR3W
	 IiyrTWI3JUXICtWvKVSv+v9hQQDFNQouUnJKiq/CbXOUNAUNJC0V+h+sdTfpXzI9RRqtB
	 IzVW0aT2YS/UY0hB15UygUIEVmYGEdy3G4YO8/AjDhEIdjfPpFABFUQZx/7M16Wfs3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533493;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SgPeae5FR8AKYR+cqJ8LniPaynZax+1NBzY1l0HxzXA=;
	b=usiWcV78wOj1Mn9bnb13n6y1gUm1txBcuc/uu3k+4Ptjhk77MsLZdccIAkhBkkjKeshr
	 nG0EhumItY1i/83hvnlgyQm87xPMqXhSpKp6pJGbMj58lbpuW6Er1GSF/Qpw6lG4y61kk
	 ChFa0rguXaULC2c9KGorPz1Iyyy8xsQn5I0LmvkAAoZi2aLVDYlcZERoqKxkXmWkhqcnC
	 jkSQbvK8jA9bQ2zj2YUyqlHa+HoVyxpmh1sflqtfksEWMCSDKmnhJPwhBlww/kDfQcVWc
	 cHgjSrW5ZufGQ10qleEcCnqZe4PmRLr0e3Xrj2buf4KFRYc2o68BRuJFrav+kWRfevg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Bmm5Cdw/";
	arc=none smtp.remote-ip=91.218.175.134
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CB3606A325
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81CB3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bmm5Cdw/
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mL+VSMKvosNWxodxBsZwD/158/cLUJtG4STuPcpFN7g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533490; v=1; x=1794138290;
 b=Bmm5Cdw/1KF4SQW4SY9X+5Nih3SDHkgcd7tKMns4r+YYbV+MLp4cC8KdBCPV9t/31kyt0tnt
 8nmLuQgUa8+7OtrbbCYL/OICC8KPv3N1bzJYcX9K7IMAIKuTZcxeSKTBWAH/bllVIrnmdf6iNIs
 bJjjyqPnoMupfPSr4hrSCrUA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ff244251a2aa9d47;
	Sun, 01 Nov 2026 11:44:50 +0000
X-Mizu-Trace-ID: ff244251a2aa9d47
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
Subject: [RFC PATCH -v4 19/22] cpuset: introduce validate_remote_partition
Date: Sun,  1 Nov 2026 19:42:03 +0800
Message-Id: <20261101114206.2434398-20-ridong.chen@linux.dev>
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

This introduces validate_remote_partition() to consolidate validation
logic for remote partition operations. It is used by both
remote_partition_enable() and remote_cpus_update().

The new function performs the following checks:
1. Empty check: the new effective exclusive CPUs must not be empty.
2. Privilege requirement: only CAP_SYS_ADMIN can add CPUs to a
   remote partition.
3. Online check: a new remote partition must have at least one
   active CPU. An existing remote partition is allowed to have all
   its CPUs offline, the same as before.
4. Resource check: the added CPUs can't use up all the top cpuset's
   effective CPUs, and must not be in any existing sub-partitions.
5. Common partition validation via validate_partition(), including
   the housekeeping conflict and tasks_nocpu_error() checks.

As a result, remote_cpus_update() reports PERR_INVCPUS instead of
PERR_NOCPUS when the added CPUs would use up the top cpuset's effective
CPUs, and checks housekeeping conflicts even when no CPU is added.

Additionally, remote_partition_disable() takes the partition error as
a parameter so that cs->prs_err can be updated centrally by
partition_disable(), instead of being written by each caller
beforehand.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 120 ++++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 55 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ecb7fd378a3f..1ff5f9e4c2fb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1837,6 +1837,51 @@ static void partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
 	cpuset_force_rebuild();
 }
 
+/**
+ * validate_remote_partition - Validate for remote partition
+ * @cs: Target cpuset to validate
+ * @new_prs: New partition root state to validate
+ * @excpus: New exclusive effective CPUs mask to validate
+ * @add: exclusive CPUs to be added
+ * @del: exclusive CPUs to be deleted, can be NULL
+ *
+ * Return: PERR_NONE if validation passes, appropriate error code otherwise
+ */
+static enum prs_errcode validate_remote_partition(struct cpuset *cs,
+	int new_prs, struct cpumask *excpus, struct cpumask *add, struct cpumask *del)
+{
+	if (cpumask_empty(excpus))
+		return PERR_CPUSEMPTY;
+
+	/*
+	 * The user must have sysadmin privilege.
+	 */
+	if (!cpumask_empty(add) && !capable(CAP_SYS_ADMIN))
+		return PERR_ACCESS;
+
+	/*
+	 * The effective_xcpus mask can contain offline CPUs, but there must
+	 * be at least one or more online CPUs present before it can be enabled.
+	 */
+	if (!is_remote_partition(cs) &&
+	    !cpumask_intersects(excpus, cpu_active_mask))
+		return PERR_INVCPUS;
+
+	/*
+	 * Additions of remote CPUs is only allowed if those CPUs are
+	 * not allocated to other partitions and there are effective_cpus
+	 * left in the top cpuset.
+	 */
+	if (!cpumask_empty(add)) {
+		if (cpumask_subset(top_cpuset.effective_cpus, add))
+			return PERR_INVCPUS;
+		if (cpumask_intersects(add, subpartitions_cpus))
+			return PERR_NOCPUS;
+	}
+
+	return validate_partition(cs, NULL, new_prs, excpus, del);
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
@@ -1850,30 +1895,17 @@ static void partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
 static int remote_partition_enable(struct cpuset *cs, int new_prs,
 				   struct tmpmasks *tmp)
 {
-	/*
-	 * The user must have sysadmin privilege.
-	 */
-	if (!capable(CAP_SYS_ADMIN))
-		return PERR_ACCESS;
+	enum prs_errcode err;
 
 	/*
-	 * The requested exclusive_cpus must not be allocated to other
-	 * partitions and it can't use up all the root's effective_cpus.
-	 *
-	 * The effective_xcpus mask can contain offline CPUs, but there must
-	 * be at least one or more online CPUs present before it can be enabled.
-	 *
 	 * Note that creating a remote partition with any local partition root
 	 * above it or remote partition root underneath it is not allowed.
 	 */
 	compute_excpus(cs, tmp->new_cpus);
-	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
-	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
-		return PERR_INVCPUS;
-	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
-		return PERR_NOCPUS;
-	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
-		return PERR_HKEEPING;
+	err = validate_remote_partition(cs, new_prs, tmp->new_cpus,
+					tmp->new_cpus, NULL);
+	if (err)
+		return err;
 
 	partition_enable(cs, NULL, new_prs, tmp->new_cpus);
 	/*
@@ -1887,13 +1919,15 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 /*
  * remote_partition_disable - Remove current cpuset from remote partition list
  * @cs: the cpuset to update
+ * @prs_err: partition error, PERR_NONE when switching back to member
  * @tmp: temporary masks
  *
  * The effective_cpus is also updated.
  *
  * cpuset_mutex must be held by the caller.
  */
-static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
+static void remote_partition_disable(struct cpuset *cs,
+		enum prs_errcode prs_err, struct tmpmasks *tmp)
 {
 	int new_prs;
 
@@ -1907,8 +1941,8 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
 		     !cpumask_empty(subpartitions_cpus));
 
-	new_prs = cs->prs_err ? -cs->partition_root_state : PRS_MEMBER;
-	partition_disable(cs, NULL, new_prs, cs->prs_err);
+	new_prs = prs_err ? -cs->partition_root_state : PRS_MEMBER;
+	partition_disable(cs, NULL, new_prs, prs_err);
 
 	/*
 	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
@@ -1931,37 +1965,20 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			       struct cpumask *excpus, struct tmpmasks *tmp)
 {
 	int prs = cs->partition_root_state;
+	enum prs_errcode err;
 
 	if (WARN_ON_ONCE(!is_remote_partition(cs)))
 		return;
 
 	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
-
-	if (cpumask_empty(excpus)) {
-		WRITE_ONCE(cs->prs_err, PERR_CPUSEMPTY);
-		goto invalidate;
-	}
-
 	cpumask_andnot(tmp->addmask, excpus, cs->effective_xcpus);
 	cpumask_andnot(tmp->delmask, cs->effective_xcpus, excpus);
 
-	/*
-	 * Additions of remote CPUs is only allowed if those CPUs are
-	 * not allocated to other partitions and there are effective_cpus
-	 * left in the top cpuset.
-	 */
-	if (!cpumask_empty(tmp->addmask)) {
-		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
-		if (!capable(CAP_SYS_ADMIN))
-			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
-		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
-			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
-			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
-		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
-						       excpus, tmp->delmask))
-			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
-		if (cs->prs_err)
-			goto invalidate;
+	err = validate_remote_partition(cs, prs, excpus, tmp->addmask,
+					tmp->delmask);
+	if (err) {
+		remote_partition_disable(cs, err, tmp);
+		return;
 	}
 
 	cs->remote_partition_updating = true;
@@ -1972,10 +1989,6 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
 	cs->remote_partition_updating = false;
-	return;
-
-invalidate:
-	remote_partition_disable(cs, tmp);
 }
 
 static bool is_user_xcpus_exclusive(struct cpuset *cs)
@@ -2471,14 +2484,12 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 
 	prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
 				     trialcs->effective_xcpus, tmp->delmask);
-	if (prs_err) {
-		WRITE_ONCE(cs->prs_err, prs_err);
+	if (prs_err)
 		trialcs->prs_err = prs_err;
-	}
 
 	if (is_remote_partition(cs)) {
 		if (trialcs->prs_err)
-			remote_partition_disable(cs, tmp);
+			remote_partition_disable(cs, trialcs->prs_err, tmp);
 		else
 			remote_cpus_update(cs, trialcs->exclusive_cpus,
 					   trialcs->effective_xcpus, tmp);
@@ -2982,7 +2993,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 	if (disable_partition) {
 		if (is_remote_partition(cs))
-			remote_partition_disable(cs, &tmpmask);
+			remote_partition_disable(cs, PERR_NONE, &tmpmask);
 		else
 			local_partition_disable(cs, PERR_NONE, &tmpmask);
 		/*
@@ -3928,8 +3939,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		if (cpumask_empty(subpartitions_cpus) ||
 		    (cpumask_empty(&new_cpus) &&
 		     partition_is_populated(cs, NULL))) {
-			WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
-			remote_partition_disable(cs, tmp);
+			remote_partition_disable(cs, PERR_HOTPLUG, tmp);
 			compute_effective_cpumask(&new_cpus, cs, parent);
 		}
 		goto update_tasks;
-- 
2.34.1


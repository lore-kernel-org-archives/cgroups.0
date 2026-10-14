Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1AD53F6B0
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986787; cv=none; b=pDnEVAh8dHJmjmedmkDWZIemFHvGLfSPrwInH1riqAUTXrwCuzAEpEXedFb2DKvdajfpR1eR+1SRYsk3kKk0IV1a+CzOTX9etbeXesJD17CpWOf8iuOKhdy1JPV0RS0yte9XMss9JYfQqlOJrpXbU7poRDV7bezENRQlis9+E+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986787; c=relaxed/simple;
	bh=N8zIMOCedQ1C/tANPqjiZldr8BoH584T8RXzOf+2HLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIBeY2at5VtpP+EVgpwOQdwLvQwV3lXP2CKlKJFk1Ry0uWgCWyFsNZ5RieZq/RLqDarKHS62olPSjXMgNOsXPfjMlT4kx4FG1ws7UTKc1HDhXhkZET7EGhrxC0RpTuZJrcT4jcs+10+lPTh53qrayQ7wZQay/TW6wPmd/p+7hhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=guOj09PT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="guOj09PT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ph8cvawjFpYXZHSj1MmMKWVSjAqJdMrkcgXnTU1Dufg=;
	b=guOj09PTolBrJ/3BKJaQmKha4yng5BxIs4n63DvtueGcUpDjl+eDpMTA0XkgpIddzO07aH
	V67HW7XPzCw0Uq+ZK1UVxF5tN/VBbdK1/BKzEROma+ncm6HDOI/nHPeWEToBUq4AEHN2SN
	i+C9i5fWEDOnFX9gDO3prDjeDtXt0LY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-uVsW3UdfMxGDoZukkX22IQ-1; Wed,
 14 Oct 2026 14:06:16 +0000
X-MC-Unique: uVsW3UdfMxGDoZukkX22IQ-1
X-Mimecast-MFC-AGG-ID: uVsW3UdfMxGDoZukkX22IQ_1791986774
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAF351955F12;
	Wed, 14 Oct 2026 14:06:13 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ACB74433;
	Wed, 14 Oct 2026 14:06:11 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 3/9] cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check
Date: Wed, 14 Oct 2026 10:05:42 -0400
Message-ID: <20261014140548.575122-4-longman@redhat.com>
In-Reply-To: <20261014140548.575122-1-longman@redhat.com>
References: <20261014140548.575122-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

When prstate_housekeeping_conflict() is called to perform housekeeping
check with cpumask changes, the cpumask changes are passed in via addmask
and delmask. With this arrangement, the exclusive CPUs owned by the child
partitions and not affected by the cpumask change, if any, are excluded
in the analysis. If the current cpuset is an isolated partition with
root partition children, it is possible the cpumask change will still
leave active housekeeping CPUs but then no housekeeping CPUs will be
left when the child partitions are disabled or invalidated.

As a first step to protect against this possibility, all the exclusive
CPUs of the cpuset should be considered to be owned by the current cpuset
when doing housekeeping check. As a result, there is no need to pass in
separate add_mask and del_mask parameters. They are combined into a single
new_cpus parameter. The parent_prs parameter can be removed as well.

With this change, the prstate_housekeeping_conflict() call in
update_parent_effective_cpumask() with partcmd_update and newmask
is now duplicative and can be removed. The housekeeping check in
remote_cpus_update(), however, will still be useful as this function can
be called directly from update_cpumasks_hier() without going through
partition_cpus_change(). The update_parent_effective_cpumask() call
from update_cpumasks_hier() is partcmd_update with no cpumask which
still have the housekeeping check and so is covered.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 77 ++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 47 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2b9aefc0edb8..b2684c98d8c0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1355,26 +1355,20 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
 /*
  * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
  * @new_prs: new partition root state to be checked
- * @parent_prs: Parent partition root state
- * @add_cpus: additional CPUs to be added to current cpuset
- * @del_cpus: CPUs to be removed from current cpuset, can be NULL
+ * @new_cpus: cpu mask to be checked
  * Return: true if there is conflict, false otherwise
  *
  * There are two different housekeeping conflicts to be checked:
- * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
- *    CPU. IOW, the whole @add_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
+ * 1) If new_prs is PRS_ROOT, none of the @new_cpus can be a boot-time isolated
+ *    CPU. IOW, the whole @new_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
  * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
- *    still leave housekeeping CPUs. This check is only needed if new_prs
- *    differs from parent_prs and one of them is PRS_ISOLATED.
+ *    still leave housekeeping CPUs.
  */
-static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
-					  struct cpumask *add_cpus,
-					  struct cpumask *del_cpus)
+static bool prstate_housekeeping_conflict(int new_prs, struct cpumask *new_cpus)
 {
 	cpumask_var_t full_hk_cpus;
 	int res;
 
-	WARN_ON_ONCE(parent_prs <= 0);
 	if (!new_prs)
 		return false;
 
@@ -1393,30 +1387,18 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		new_prs = -new_prs;
 
 	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
-	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
+	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
 	/*
 	 * Exit 2nd check early and return false if
 	 * 1) there is no boot time isolated nohz_full CPU
-	 * 2) new_prs is PRS_ROOT, parent_prs is PRS_ISOLATED and no CPU will
-	 *    be returned back to the parent.
+	 * 2) @new_prs is not PRS_ISOLATED
+	 * 3) @new_cpus is a subset of isolated_cpus
 	 */
 	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
-	    (!del_cpus && (new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)))
-		return false;
-
-	/*
-	 * Now make sure that @add_cpus contains new CPUs to be isolated and
-	 * @del_cpus contains isolated CPUs to be un-isolated.
-	 * With the guards above, @add_cpus can't be NULL after the swap.
-	 */
-	if (parent_prs == PRS_ISOLATED)
-		swap(add_cpus, del_cpus);
-
-	if (del_cpus &&
-	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
-				   cpu_active_mask) < nr_cpu_ids))
+	    (new_prs != PRS_ISOLATED) ||
+	    cpumask_subset(new_cpus, isolated_cpus))
 		return false;
 
 	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
@@ -1426,7 +1408,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
-	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
+	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
 
 	free_cpumask_var(full_hk_cpus);
 	return res;
@@ -1613,7 +1595,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 		return PERR_INVCPUS;
 	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
 		return PERR_NOCPUS;
-	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
+	if (prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
 		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
@@ -1715,8 +1697,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
-		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
-						       tmp->addmask, tmp->delmask))
+		else if (prstate_housekeeping_conflict(prs, excpus))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
@@ -1796,7 +1777,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	int old_prs, new_prs;
 	int part_error = PERR_NONE;	/* Partition error? */
 	struct cpumask *xcpus = user_xcpus(cs);
-	int parent_prs = parent->partition_root_state;
 	bool nocpu;
 
 	lockdep_assert_cpuset_lock_held();
@@ -1858,7 +1838,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (cpumask_empty(xcpus))
 			return PERR_INVCPUS;
 
-		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
+		if (prstate_housekeeping_conflict(new_prs, xcpus))
 			return PERR_HKEEPING;
 
 		if (tasks_nocpu_error(parent, cs, xcpus))
@@ -1930,14 +1910,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 					       parent->effective_xcpus);
 		}
 
-		/*
-		 * Check for housekeeping conflicts
-		 */
-		if (is_partition_valid(cs) &&
-		    prstate_housekeeping_conflict(old_prs, parent_prs,
-						  tmp->delmask, tmp->addmask))
-			part_error = PERR_HKEEPING;
-
 		/*
 		 * The new CPUs to be removed from parent's effective CPUs
 		 * must be present.
@@ -2430,6 +2402,21 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
+	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
+		int parent_prs = is_remote_partition(cs)
+			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+		/*
+		 * Check for housekeeping CPUs conflict assuming that all
+		 * the exclusive CPUs belong to the current cpuset. We rely
+		 * on the fact that effective_xcpus has been set up by
+		 * compute_trial_excpus() which is called previously in
+		 * update_cpumask() and update_exclusive_cpumask().
+		 */
+		if (parent_prs > 0 &&
+		    prstate_housekeeping_conflict(trialcs->partition_root_state,
+						  trialcs->effective_xcpus))
+			prs_err = PERR_HKEEPING;
+	}
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
@@ -2922,15 +2909,11 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
 		}
 	} else if (old_prs && new_prs) {
-		int parent_prs = is_remote_partition(cs)
-				 ? PRS_ROOT : parent->partition_root_state;
-
 		/*
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
-		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  cs->effective_xcpus, NULL))
+		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;
-- 
2.55.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351FA390600
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620968; cv=none; b=UMgNnLU+rfb1SZf8NhKvxyB9LGRZFbPvdhmXfWyidTcfWnsOy7QRMqC6vJKe8r4j51E9wCVT4kkeOF879g2I91d1VTRkpmKDPr9QkH4jREraUFlAE7C8e/qTOqt7u49KVsHc3N68pXPNN3egX51Q9+zUzXN2zRy+YIObNRmYC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620968; c=relaxed/simple;
	bh=1IRyNCQD4suM4oAQR4zeJ8VEa6YlUx75R0b02/nVMQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQF3hQ6B8cv3XMExXAywZg553qRZCap8DTSJkSKeU0gWK/sWapGJtl3TyJbrCXJwFJf/E+3K7N21Zm1XkRB00WTvORaWElKizk5cX7/W/dikrIgSu/IsscVqWzbjgjNY4s/boYE3Wx9L2OB/HgZKX98zF6VKvXHfYU0HxHozXhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3dCWE/R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3dCWE/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791620966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XsRkS1LYHAh+Eah20mbsVNKnu3zOvPKPyLDGhWEZ97U=;
	b=B3dCWE/R1OkwiXYtX6izrYiyBmVDZfcJ8PZjMhRQlx3sgRQj8iu6GL3gjkzqOYC3oKqsb3
	5VfWCiyXws8BdbrfowNuxPWV6qC7qVW+355PTR79e99BABZmKCMwstwvKQP0SkIAR461zb
	/VPtUY72q6U+pIGrlVZATCJWLpMiCaU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-9A-DN6fGPV6DF8FggZdX3g-1; Sat,
 10 Oct 2026 08:29:22 +0000
X-MC-Unique: 9A-DN6fGPV6DF8FggZdX3g-1
X-Mimecast-MFC-AGG-ID: 9A-DN6fGPV6DF8FggZdX3g_1791620961
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E8C31955E96;
	Sat, 10 Oct 2026 08:29:20 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2E491800351;
	Sat, 10 Oct 2026 08:29:17 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 1/5] cgroup/cpuset: Consolidate isolated_cpus_can_update() into prstate_housekeeping_conflict()
Date: Sat, 10 Oct 2026 04:28:44 -0400
Message-ID: <20261010082848.193182-2-longman@redhat.com>
In-Reply-To: <20261010082848.193182-1-longman@redhat.com>
References: <20261010082848.193182-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The isolated_cpus_can_update() and prstate_housekeeping_conflict() are
checking different aspects of upcoming cpumask changes that may conflict
with the current setting of the housekeeping cpumasks. There are places
where both are called together. There are also places where only one
of them is called. That inconsistency can contribute to missing check
where invalid cpumask changes may be allowed to move forward.

Fix that by consolidating isolated_cpus_can_update() into
prstate_housekeeping_conflict() and call prstate_housekeeping_conflict()
in all the places where either one of them or both are called. The
exception is the validate_partition() function where the
prstate_housekeeping_conflict() call is removed. It is because
validate_partition() is called only from partition_cpus_change()
where prstate_housekeeping_conflict() will be called from either
remote_cpus_update() or update_parent_effective_cpumask() with
partcmd_update if not for partition invalidatation or disablement.

Now prstate_housekeeping_conflict() will be called in the following
locations:
 - when a partition is enabled in remote_partition_enable() or in
   update_parent_effective_cpumask() with partcmd_enable*.
 - when a cpumask is updated in remote_cpus_update() or in
   update_parent_effective_cpumask() with partcmd_update.
 - when a partition state changes from root to isolated or vice versa
   in update_prstate().

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 123 +++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 71 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0ebba2d646c3..f3cebb277a68 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1353,65 +1353,62 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
 }
 
 /*
- * isolated_cpus_can_update - check for isolated & nohz_full conflicts
- * @add_cpus: cpu mask for cpus that are going to be isolated
- * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
- * Return: false if there is conflict, true otherwise
- *
- * If nohz_full is enabled and we have isolated CPUs, their combination must
- * still leave housekeeping CPUs.
+ * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
+ * @new_prs: new partition root state to be checked
+ * @parent_prs: Parent partition root state
+ * @add_cpus: additional CPUs to be added to current cpuset
+ * @del_cpus: CPUs to be removed from current cpuset, can be NULL
+ * Return: true if there is conflict, false otherwise
  *
- * TBD: Should consider merging this function into
- *      prstate_housekeeping_conflict().
+ * There are two different housekeeping conflicts to be checked:
+ * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
+ *    CPU. IOW, the whole @add_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
+ * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
+ *    still leave housekeeping CPUs. This check is only needed if new_prs
+ *    differs from parent_prs and one of them is PRS_ISOLATED.
  */
-static bool isolated_cpus_can_update(struct cpumask *add_cpus,
-				     struct cpumask *del_cpus)
+static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
+					  struct cpumask *add_cpus,
+					  struct cpumask *del_cpus)
 {
 	cpumask_var_t full_hk_cpus;
-	int res = true;
+	int res;
 
-	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
+	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
-	if (del_cpus && cpumask_weight_and(del_cpus,
-			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
-		return true;
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
+	    (new_prs == parent_prs) ||
+	    (!del_cpus && (new_prs != PRS_ISOLATED)) ||
+	    ((new_prs != PRS_ISOLATED) && (parent_prs != PRS_ISOLATED)))
+		return false;
 
-	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+	/*
+	 * Make sure that @add_cpus contains new CPUs to be isolated and
+	 * @del_cpus contains isolated CPUs to be un-isolated.
+	 */
+	if (parent_prs == PRS_ISOLATED)
+		swap(add_cpus, del_cpus);
+
+	if (del_cpus &&
+	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+				   cpu_active_mask) < nr_cpu_ids))
 		return false;
 
+	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+		return true;
+
 	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
-	if (!cpumask_weight_andnot(full_hk_cpus, add_cpus))
-		res = false;
+	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
 
 	free_cpumask_var(full_hk_cpus);
 	return res;
 }
 
-/*
- * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
- * @prstate: partition root state to be checked
- * @new_cpus: cpu mask
- * Return: true if there is conflict, false otherwise
- *
- * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
- * isolated partition.
- */
-static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
-{
-	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
-		return false;
-
-	if ((prstate != PRS_ISOLATED) &&
-	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
-		return true;
-
-	return false;
-}
-
 /*
  * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
  *
@@ -1593,9 +1590,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 		return PERR_INVCPUS;
 	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
 		return PERR_NOCPUS;
-	if (((new_prs == PRS_ISOLATED) &&
-	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
-	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
+	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
 		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
@@ -1697,8 +1692,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
-		else if ((prs == PRS_ISOLATED) &&
-			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
+		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
+						       tmp->addmask, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
@@ -1840,11 +1835,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (cpumask_empty(xcpus))
 			return PERR_INVCPUS;
 
-		if (prstate_housekeeping_conflict(new_prs, xcpus))
-			return PERR_HKEEPING;
-
-		if ((new_prs == PRS_ISOLATED) && (new_prs != parent_prs) &&
-		    !isolated_cpus_can_update(xcpus, NULL))
+		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
 			return PERR_HKEEPING;
 
 		if (tasks_nocpu_error(parent, cs, xcpus))
@@ -1917,20 +1908,12 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		}
 
 		/*
-		 * TBD: Invalidate a currently valid child root partition may
-		 * still break isolated_cpus_can_update() rule if parent is an
-		 * isolated partition.
+		 * Check for housekeeping conflicts
 		 */
-		if (is_partition_valid(cs) && (old_prs != parent_prs)) {
-			if ((parent_prs == PRS_ROOT) &&
-			    /* Adding to parent means removing isolated CPUs */
-			    !isolated_cpus_can_update(tmp->delmask, tmp->addmask))
-				part_error = PERR_HKEEPING;
-			if ((parent_prs == PRS_ISOLATED) &&
-			    /* Adding to parent means adding isolated CPUs */
-			    !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
-				part_error = PERR_HKEEPING;
-		}
+		if (is_partition_valid(cs) &&
+		    prstate_housekeeping_conflict(old_prs, parent_prs,
+						  tmp->delmask, tmp->addmask))
+			part_error = PERR_HKEEPING;
 
 		/*
 		 * The new CPUs to be removed from parent's effective CPUs
@@ -2391,10 +2374,6 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
-	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
-					  trialcs->effective_xcpus))
-		return PERR_HKEEPING;
-
 	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
 		return PERR_NOCPUS;
 
@@ -2411,7 +2390,7 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
  * CPU modifications may cause a partition to be disabled or require state updates.
  */
 static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
-					struct tmpmasks *tmp)
+				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
 
@@ -2911,13 +2890,15 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
 		}
 	} else if (old_prs && new_prs) {
+		int parent_prs = is_remote_partition(cs)
+				 ? PRS_ROOT : parent->partition_root_state;
+
 		/*
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
-		if (((new_prs == PRS_ISOLATED) &&
-		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		if (prstate_housekeeping_conflict(new_prs, parent_prs,
+						  cs->effective_xcpus, NULL))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;
-- 
2.55.0


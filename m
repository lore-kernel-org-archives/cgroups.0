Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792433446;
	b=HChZSvFsvsHBNTxVdSfT+1RS9tFn5x3upMXHNmejc7kKMAzT5iwmNbW2z66ABhVJXPOg
	 80hscxgNghOhE4ewzJyvidHOLfCrCwcTVJIXuxLFL+TMO7ihUL7O9ujW8wLU0JccbKvjg
	 1vuep/fyAAfmTynAQnyP3obywPpb5EKx8gQrWNukxqfpJNoEwQkVWAMaj7ESUpihxWc/v
	 GBzyCbYbV/6cPIOFmifI0pF5e1ygbbewvxOFV1+yOqeew9tPg4eAPBcRT9soTo+wT71XF
	 oMPUxz0/JpcvPhEDfy4JlNHDfymihEqJpMIt9GEZQ7Xwzr2oBxT5ttHcR/XQd+4VdQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433446;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=C6blcT2ReW2jYY81A8rdUS0lOFNgBtFPK12VxxmC0YE=;
	b=oDik2eiE84T485T3TALsODl0SbAD+69BbjF9SQyb2Aq6v5HBYmJgQR3jkKce/1qpC6fv
	 NZo00mIjNPvlF2M1erHZfaiAtRpSUEKLRxEYhXiEc18sr/YkhZA3NyGvcXmCps1l87CEp
	 p6eN9WhxKalierkd57OXWcUbqw/YJnrIIoImRF2AIPmvLJwBuDhz48dOR6dGhfU7Q/Nv0
	 GV93Gv7d9GutKs6jv3c+eEnMJttSn6o5toZuGu4CMJd0Sljuc2k8+iEYr2VroZ0ZpmSLv
	 MGctDmJc6bgcqzWwy+jjR/1orUsky9XNPRaxjUyGfmgRLTQwWBzGuSnoTGkVYjT3iUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YxPnjA1f;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FDF606A321
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3FDF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YxPnjA1f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792433443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6blcT2ReW2jYY81A8rdUS0lOFNgBtFPK12VxxmC0YE=;
	b=YxPnjA1fbjRnxoFys0dY2jYTQUf8W1aY4zePko65KTqzRrQ16Kp6uFAJwIDSHBND7Riytq
	79vvnD0QY6IcJejqdX+TSwBv/BefaOdeCAl7QTgf4Wv2cN/RIuoXvWK2tjk8HC6WY1d4u9
	eusEZwmlmDnEAjKDoq0CFF9MdfNPvdA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-PkYnwEugM5qEnpBtpUErtQ-1; Mon,
 19 Oct 2026 18:10:40 +0000
X-MC-Unique: PkYnwEugM5qEnpBtpUErtQ-1
X-Mimecast-MFC-AGG-ID: PkYnwEugM5qEnpBtpUErtQ_1792433438
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F83C19560B3;
	Mon, 19 Oct 2026 18:10:38 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44292418;
	Mon, 19 Oct 2026 18:10:35 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH-next v4 2/9] cgroup/cpuset: Consolidate isolated_cpus_can_update() into prstate_housekeeping_conflict()
Date: Mon, 19 Oct 2026 14:10:13 -0400
Message-ID: <20261019181020.1069325-3-longman@redhat.com>
In-Reply-To: <20261019181020.1069325-1-longman@redhat.com>
References: <20261019181020.1069325-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

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
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 148 +++++++++++++++++++++--------------------
 1 file changed, 77 insertions(+), 71 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e032ee1efeb7..5acdc3897ef2 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1353,65 +1353,87 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
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
-		return true;
+	WARN_ON_ONCE(parent_prs <= 0);
+	if (!new_prs)
+		return false;
+
+	/*
+	 * For a currently invalid partition root state, do the check assuming
+	 * that it may be converted back to valid.
+	 *
+	 * There are code paths where an invalid partition may be reverted back
+	 * to a valid partition but we still need to run the housekeeping check
+	 * before the conversion happens to make sure the switch is valid. We
+	 * can either do the negative to positive PRS switch individually in all
+	 * these code paths or do it here which I think will make the code a bit
+	 * easier to read.
+	 */
+	if (new_prs < 0)
+		new_prs = -new_prs;
 
-	if (del_cpus && cpumask_weight_and(del_cpus,
-			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
+	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
-	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+	/*
+	 * Exit 2nd check early and return false if
+	 * 1) there is no boot time isolated nohz_full CPU
+	 * 2) parent and child has the same partition state
+	 * 3) new_prs is PRS_ROOT, parent_prs is PRS_ISOLATED and no CPU will
+	 *    be returned back to the parent.
+	 */
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
+	    (new_prs == parent_prs) ||
+	    ((new_prs == PRS_ROOT) && (!del_cpus || cpumask_empty(del_cpus))))
+		return false;
+
+	/*
+	 * Now make sure that @add_cpus contains new CPUs to be isolated and
+	 * @del_cpus contains isolated CPUs to be un-isolated.
+	 * With the guards above, @add_cpus can't be NULL after the swap.
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
@@ -1593,9 +1615,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 		return PERR_INVCPUS;
 	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
 		return PERR_NOCPUS;
-	if (((new_prs == PRS_ISOLATED) &&
-	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
-	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
+	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
 		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
@@ -1697,8 +1717,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
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
@@ -1840,11 +1860,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
@@ -1917,20 +1933,12 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
@@ -2438,10 +2446,6 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
-	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
-					  trialcs->effective_xcpus))
-		return PERR_HKEEPING;
-
 	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
 		return PERR_NOCPUS;
 
@@ -2458,7 +2462,7 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
  * CPU modifications may cause a partition to be disabled or require state updates.
  */
 static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
-					struct tmpmasks *tmp)
+				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
 
@@ -2958,13 +2962,15 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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


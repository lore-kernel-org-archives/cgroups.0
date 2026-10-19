Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792433447;
	b=sHEDmtX6dkuXEi5epZsIa2GqNa/wThXKvpGRIjsL+xMcN6kfxB+9h5QOQ0//9SfP26D1
	 qIN2wwOeh+H+ZCAPjstxojXm8vV0YBbvV9hkpF8LtiNUdlOv4eOnqwpuc6CYtjnQgbxsb
	 D4bZYuEqESNGpY4tDn/xKw3MYBWl/JBbr+4PrX3ZgSER+JLRKZH7Fzt7Lt+hhlSOJqUuw
	 IO/tPGTdZSUV4fu62H1szPUl5ZXIeJR/1J19Kfrc48LiNHn6pAz2ZTDm3kMBbktSl1mLt
	 1AZB3T1CPyn0HSBQyNDohcm0ibliUtj9uz55r06ambD/M5MGeul4hGfnNXcL2AuXBsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433447;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=uFkQQEsey5nMywqpv8Gu9QV7T6PVhaqd/+P20TcJHwQ=;
	b=BE7l8cUvAB8rN96lu63z1lz+UhHdTHSgT6UIknlOmmG9nklzkn9EzqCBAOYmEmzPfIbA
	 l1LxoACdQSqU/sgMY1DdDmGEVODBAQtdvW+I5nqBijeL9ig/thTvFQQWlMGQCzjXe4bQ5
	 yJJT+VLNLNaH6sVLzbGwkU2esUJVxBx4fTFYEMO3nMhXJK9azBiUs/aB1zVdLKg2F2pXG
	 S5Uddvoge3bFeWNAoc/LKcK3BtnXSP8Uk9V1oIZ0m/cg+P1YbcVZVVbfCBo50wKoW3u94
	 Q5KTNMyqW4DV6xwmF1ncwc9BN6w4txH7vXDdtwd9X/NTCa3eOlMf6PxFSrKVaMJ9IUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hqpq3wZg;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE62F606A32E
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE62F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hqpq3wZg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792433446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFkQQEsey5nMywqpv8Gu9QV7T6PVhaqd/+P20TcJHwQ=;
	b=hqpq3wZglKDkpHWBN2ciJHjz2AEQbz457qz2jkIhlMr0KVq3Tb7OzZpWzBUxEcmVmzT6vz
	GhUUylEhSOdYrjTABJpRHm39blPNpBdBXHtnhE/XYOH8pbdb2fFKkLN9NFDbS6hRfNRn2k
	Yh/nzWLEk5fKyzKFQM7zx8F06xItDh0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-_8Cd_HIpMR-GTx65VGkt6A-1; Mon,
 19 Oct 2026 18:10:42 +0000
X-MC-Unique: _8Cd_HIpMR-GTx65VGkt6A-1
X-Mimecast-MFC-AGG-ID: _8Cd_HIpMR-GTx65VGkt6A_1792433440
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F79A195605A;
	Mon, 19 Oct 2026 18:10:40 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 76B08418;
	Mon, 19 Oct 2026 18:10:38 +0000 (UTC)
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
Subject: [PATCH-next v4 3/9] cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check
Date: Mon, 19 Oct 2026 14:10:14 -0400
Message-ID: <20261019181020.1069325-4-longman@redhat.com>
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

When prstate_housekeeping_conflict() is called to perform housekeeping
check with cpumask changes, the cpumask changes are passed in via add_cpus
and del_cpus parameters. With this arrangement, the exclusive CPUs owned
by the child partitions and not affected by the cpumask change, if any,
are excluded in the analysis. The only places where there are separate
add and delete masks are when the cpuset.cpus or cpuset.cpus.exclusive
is being changed. In both cases, partition_cpus_change() is a good place
to perform the housekeeping check.

If we allow a root partition to be created under an isolated partition,
it is possible the cpumask change will still leave active housekeeping
CPUs but then no housekeeping CPUs will be left when the child partitions
are disabled or invalidated.

As a first step to protect against this possibility, all the exclusive
CPUs of the cpuset should be considered to be owned by the current cpuset
when doing housekeeping check. At the same time, we do want to know if
some housekeeping CPUs are going to be removed from the isolated partition
that there will be no danger of losing all the active housekeeping CPUs.
So the current add_cpus paremeter is renamed as new_cpus to indicate
that it includes the complete set of effective xcpus.

With the new check in partition_cpus_change(), the housekeeping check
in update_parent_effective_cpumask() with partcmd_update and newmask
is now duplicative and can be removed. The housekeeping check in
remote_cpus_update(), however, will still be useful as this function can
be called directly from update_cpumasks_hier() without going through
partition_cpus_change(). The update_parent_effective_cpumask() call
from update_cpumasks_hier() is partcmd_update with no cpumask which
still have the housekeeping check and so is covered.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 46 +++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5acdc3897ef2..cef3cd0a6906 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1356,19 +1356,19 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
  * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
  * @new_prs: new partition root state to be checked
  * @parent_prs: Parent partition root state
- * @add_cpus: additional CPUs to be added to current cpuset
- * @del_cpus: CPUs to be removed from current cpuset, can be NULL
+ * @new_cpus: the set of new effective xcpus in the current cpuset
+ * @del_cpus: old CPUs going to be removed from current cpuset, can be NULL
  * Return: true if there is conflict, false otherwise
  *
  * There are two different housekeeping conflicts to be checked:
- * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
- *    CPU. IOW, the whole @add_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
+ * 1) If new_prs is PRS_ROOT, none of the @new_cpus can be a boot-time isolated
+ *    CPU. IOW, the whole @new_cpus must be a subset of HK_TYPE_DOMAIN_BOOT.
  * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
  *    still leave housekeeping CPUs. This check is only needed if new_prs
  *    differs from parent_prs and one of them is PRS_ISOLATED.
  */
 static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
-					  struct cpumask *add_cpus,
+					  struct cpumask *new_cpus,
 					  struct cpumask *del_cpus)
 {
 	cpumask_var_t full_hk_cpus;
@@ -1393,7 +1393,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		new_prs = -new_prs;
 
 	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT) && (new_prs == PRS_ROOT) &&
-	    !cpumask_subset(add_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
+	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
 	/*
@@ -1409,12 +1409,12 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		return false;
 
 	/*
-	 * Now make sure that @add_cpus contains new CPUs to be isolated and
+	 * Now make sure that @new_cpus contains new CPUs to be isolated and
 	 * @del_cpus contains isolated CPUs to be un-isolated.
-	 * With the guards above, @add_cpus can't be NULL after the swap.
+	 * With the guards above, @new_cpus can't be NULL after the swap.
 	 */
 	if (parent_prs == PRS_ISOLATED)
-		swap(add_cpus, del_cpus);
+		swap(new_cpus, del_cpus);
 
 	if (del_cpus &&
 	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
@@ -1428,7 +1428,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
-	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
+	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
 
 	free_cpumask_var(full_hk_cpus);
 	return res;
@@ -1718,7 +1718,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
 		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
-						       tmp->addmask, tmp->delmask))
+						       excpus, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
@@ -1932,14 +1932,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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
@@ -2470,6 +2462,22 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
+	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
+		int prs = cs->partition_root_state;
+		int parent_prs = is_remote_partition(cs)
+			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+		/*
+		 * Check for housekeeping conflict by passing the whole
+		 * effective_xcpus as well as those CPUs that are to be
+		 * removed from cs as delmask.
+		 */
+		cpumask_andnot(tmp->delmask, cs->effective_xcpus, trialcs->effective_xcpus);
+		if (parent_prs > 0 &&
+		    prstate_housekeeping_conflict(prs, parent_prs,
+						  trialcs->effective_xcpus, tmp->delmask))
+			prs_err = PERR_HKEEPING;
+	}
+
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
-- 
2.55.0


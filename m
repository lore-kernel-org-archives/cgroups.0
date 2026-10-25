Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964727;
	b=M3eA6+OiqEPJE9YLukG9mCFk/8qVR5mWecFAqRBhUAfk18m4z5J2MFlr8omLT9uNPHn0
	 rQyTNZUpJ58thJnMEn4He8/FI2U4pManAtAtgmzQi6eDpU2l/pys9TiX5OH5LRfmFlEHp
	 7nwBClkfg0d3dGnFfVQPFz7c8WAbHDFem2Jjue0tYOF2W2tyWO9seIn8g4JFbrEMS9jrH
	 FnV92N/R6QC615MMYbXnlhU5hSGmedUTiv/dGRZnWrnpbLvy01cCaF5Yxfnzasz9502ie
	 sjQDaCNYuyy8OxNa4DeVBola1aNrnanNnkY4JWm+A5GGzkow00GthDepUtt8sskZqaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964727;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=7/AU9fWERk3DZqrW4x1dwMTo1fMME8yop/dFbPn/Zcw=;
	b=ToT5SJcW0MSDw8VIO9AS/ancfFr+ckzWN1lMiYz8+GmftKX1FAd5sfiLRpxg4kpAwQL1
	 K1IVKct/s+KSqlVmMtnRorLGguFAz2/4J8OgQEatTzWcrCDHkvE/M/iqM8Qv22DBDnr0x
	 Dob3vXn/5A9F+A0hbrbcOrro37i22Jl661hvKQGeNoCOhemeESn2YfWP7h4Y1j6IRrZto
	 ZxfcpFG8QVtwrwAkRJVnfHyOVsza4hePtHyrRqTkOoV5Y7GwhiQd+lfBVTR0TEooccfiO
	 n7hvFiuyy27Lgcr5fX6mESTdm2eqW14FqoFxFwZIW2jekD0S2namV4tZFAAj1AuiZJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Iy7dIjHq;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2568606A320
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2568606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Iy7dIjHq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7/AU9fWERk3DZqrW4x1dwMTo1fMME8yop/dFbPn/Zcw=;
	b=Iy7dIjHqxRNn6neeJHz2nlARgr7fyT/Up5ZCE4p39sUfDNbUkzmnkye8+IYKKjNVkOQUIG
	vWOBzVrOQ3D4ZN8Bj6IeZG2vU4iJw0dsdFM9l+Yg8DElFrcMH2qQaoinC50m/28HT7z0UQ
	f8/hEH6H+hQ7quRWTOnxVTKycyDTsRc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-RQPa8o-EPsG9vU8PTNC9xQ-1; Sun,
 25 Oct 2026 17:45:20 -0400
X-MC-Unique: RQPa8o-EPsG9vU8PTNC9xQ-1
X-Mimecast-MFC-AGG-ID: RQPa8o-EPsG9vU8PTNC9xQ_1792964718
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 848E8180066E;
	Sun, 25 Oct 2026 21:45:18 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E74511956087;
	Sun, 25 Oct 2026 21:45:16 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 04/11] cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()
Date: Sun, 25 Oct 2026 17:44:42 -0400
Message-ID: <20261025214449.310715-5-longman@redhat.com>
In-Reply-To: <20261025214449.310715-1-longman@redhat.com>
References: <20261025214449.310715-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Commit 9527ff78a413 ("cgroup/cpuset: Consider all the exclusive CPUs when
doing housekeeping check") changes the way prstate_housekeeping_conflict()
is being used by considering all the exclusive xcpus to be owned by the
partition when doing housekeeping check. However there are two minor
issues reported by sashiko with that patch:

 1) In partition_cpus_change(), prstate_housekeeping_conflict() can
 be called with an invalid partition root. In that case, there are
 no isolated CPUs that are going to be returned back to the system to
 become housekeeping CPUs, so the calculation of the del_cpus cpumask
 is meaningless.

 2) The checking of del_cpus in prstate_housekeeping_conflict() to see
 if it can contain an active housekeeping CPU that can be returned to the
 system ignores the fact that an active CPU not in HK_TYPE_DOMAIN_BOOT HK
 cpumask will not become an active housekeeping CPU when it is released
 by an isolated partition.

Update the existing code to handle these two issues properly to make
prstate_housekeeping_conflict() produce more accurate result.

Fixes: 9527ff78a413 ("cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 45 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 37bc79d0c647..57e5334eb919 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1446,6 +1446,9 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
+	if (del_cpus && cpumask_empty(del_cpus))
+		del_cpus = NULL;
+
 	/*
 	 * Exit 2nd check early and return false if
 	 * 1) there is no boot time isolated nohz_full CPU
@@ -1454,8 +1457,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	 *    be returned back to the parent.
 	 */
 	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
-	    (new_prs == parent_prs) ||
-	    ((new_prs == PRS_ROOT) && (!del_cpus || cpumask_empty(del_cpus))))
+	    (new_prs == parent_prs) || (!del_cpus && (new_prs == PRS_ROOT)))
 		return false;
 
 	/*
@@ -1466,20 +1468,29 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	if (parent_prs == PRS_ISOLATED)
 		swap(new_cpus, del_cpus);
 
-	if (del_cpus &&
-	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
-				   cpu_active_mask) < nr_cpu_ids))
-		return false;
-
 	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
 		return true;
 
+	/*
+	 * Check if del_cpus may contain a CPU that can become an active
+	 * housekeeping CPU again.
+	 */
+	if (del_cpus) {
+		cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+		if (cpumask_first_and_and(del_cpus, full_hk_cpus,
+					  cpu_active_mask) < nr_cpu_ids) {
+			res = false;
+			goto out;
+		}
+	}
+
 	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
 	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
-
+out:
 	free_cpumask_var(full_hk_cpus);
 	return res;
 }
@@ -2486,23 +2497,29 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
+	int parent_prs = is_remote_partition(cs)
+		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
 
 	if (cs_is_member(cs))
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
-	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
+	if (!prs_err && (parent_prs > 0) &&
+	    !cpumask_empty(trialcs->effective_xcpus)) {
 		int prs = cs->partition_root_state;
-		int parent_prs = is_remote_partition(cs)
-			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+
 		/*
 		 * Check for housekeeping conflict by passing the whole
 		 * effective_xcpus as well as those CPUs that are to be
 		 * removed from cs as delmask.
 		 */
-		cpumask_andnot(tmp->delmask, cs->effective_xcpus, trialcs->effective_xcpus);
-		if (parent_prs > 0 &&
-		    prstate_housekeeping_conflict(prs, parent_prs,
+		if (prs > 0)
+			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
+				       trialcs->effective_xcpus);
+		else
+			cpumask_clear(tmp->delmask);
+
+		if (prstate_housekeeping_conflict(prs, parent_prs,
 						  trialcs->effective_xcpus, tmp->delmask))
 			prs_err = PERR_HKEEPING;
 	}
-- 
2.56.0


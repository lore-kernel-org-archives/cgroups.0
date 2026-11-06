Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962588;
	b=ErEjhQgqJ/+5BNt9teVvVybB6fxOCQKLmesRQj1YeRcwSE3Uq3EU6laFVNOLypgORZR4
	 0a8fJFBrCQRstTpZdZ/Tie/Qh02Va37fKfi/tP/BD4hXGq723NP5E+pku+JschrHPGsb1
	 Yov9gtYkck4IzsmZRCNNV4YufqwzvMvMM2pximyP/yqu7QlenKt28JkpWK2PlznJJ5BJg
	 MapJ6ab9yaTg+4fvQLR1NAilZON6NLubii9rBnBOtYqfmhKPyuEb2BFNE2ui+zCk8nfkL
	 zbuRjy4JL5kVj7aBALW2wMOA7ZSManqa8fkCRr1KcARWSGiK9zHHdmyeFEz/6NWZ46w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962588;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bi3IKqIUyGEPrpZA3dOlAN5KHpvQga9uYOwi+9H0Yb4=;
	b=HourZ9CTOTpWbZA+72oSluzcXZeS5MCqU5Df91NYD/PbIR2MDGtdK8zpILUgxThLviVw
	 uL0Ze603KYZ/9d5DgyHQRFeo8FYW18dtGDrM3k4fjANY2KJpXwmtMC/frRgXFmGIfuVu9
	 LqqflL72uSJYE7UtqMbU3vJkgsSH2d17cN7SvUmohYu0VZWDewq928hkVY0UviUkeMsm7
	 t66thbRnss7nXPjWsgrCU2YTVVIRcWr1TfIBamOr+Epr4S49Mi10I1UUxT6EtHbxIwXek
	 m0846vKtaaiXVDc0p8lbSLbpq3ZzQruVBvfjbku9svPvx0ClqHfUXv2Y/sIjQpb0kYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BS0UWPba;
	arc=none smtp.remote-ip=95.215.58.182
Received: from mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A17606A32D
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2A17606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BS0UWPba
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AWLLW7Uy/s4T7E9FPecPDz3V1rl29a7Rnr/Fax4shEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793962585; v=1; x=1794567385;
 b=BS0UWPbasE6+2icfuViHjejryOglQfSmidPJ2viBDE2F4S+RUUsU2r1VIWd7nBm2sQxS7y4n
 dviQlkSiNi5op1YrxWATFxGtvsFoZmHYNDz/l4BKdet4teel7l/E/tw9VwzwmVAV9PRrab5COEr
 9ducdQyIOzjYh3qLLcu4zqf0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ade68e5ef1a406f3;
	Fri, 06 Nov 2026 10:56:25 +0000
X-Mizu-Trace-ID: ade68e5ef1a406f3
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 3/4] cpuset: settle isolation state when CPUs are given back to parent
Date: Fri,  6 Nov 2026 18:55:37 +0800
Message-Id: <20261106105538.2915492-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261106105538.2915492-1-ridong.chen@linux.dev>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
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

partition_xcpus_del() only updates isolated_cpus when the partition that
gives back the CPUs has a different state than its parent. CPUs that were
further distributed to descendant isolated partitions are not taken into
account, so isolated_cpus_release() has to be called afterwards in
several places to walk up the ancestors and fix isolated_cpus.

Make partition_xcpus_del() always set the isolation state of the given
back CPUs to the state of the parent that receives them. As the
effective_xcpus of a partition covers the CPUs distributed to its
descendants, the isolation state of those CPUs is settled at the same
time. Boot-time isolated CPUs are still preserved by isolated_cpu_update().

compute_partition_effective_cpumask() invalidates a child partition
without going through partition_xcpus_del(), so do the same there: the
CPUs of the invalidated child take the isolation state of its parent.

As the parent may be shrunk and its effective_xcpus not updated yet,
only do so for the CPUs the parent still owns. This is to keep the
isolation state correct for now, the in-place invalidation here will be
removed later in the partition rework.

isolated_cpus_release() is no longer needed and is removed.

Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 86 +++++++++++-------------------------------
 1 file changed, 23 insertions(+), 63 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 85e5b529d144..a5ab9396eb61 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1264,42 +1264,21 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
 }
 
 /*
- * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
- * @cs: the current cpuset
- * @xcpus: the set of effective xcpus to be considered for removal
- *
- * This function is called when an isolated partition is invalidated or when
- * some of its effective xcpus are to be removed from isolated_cpus due to
- * changes in parent cpuset. The given @xcpus must be modifiable as the function
- * will update its value to determine the right set of CPUs to be removed.
+ * isolated_cpus_set_state - Set the isolation state of @xcpus
+ * @prs: partition root state that @xcpus will belong to
+ * @xcpus: exclusive CPUs whose isolation state may change
  */
-static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
+static void isolated_cpus_set_state(int prs, struct cpumask *xcpus)
 {
-	struct cpuset *ancestor = parent_cs(cs);
-	struct cpuset *iancestor = NULL;
-
-	/*
-	 * Search the furthest isolated partition root ancestor available
-	 * until top_cpuset or a remote partition root is hit.
-	 */
-	for (; ancestor; ancestor = parent_cs(ancestor)) {
-		if (ancestor->partition_root_state == PRS_ISOLATED)
-			iancestor = ancestor;
-		if (is_remote_partition(ancestor))
-			break;
-	}
-
-	/*
-	 * If a furthest isolated partition acnestor is found, use it to
-	 * determine which of the CPUs in @xcpus should be removed from
-	 * isolated_cpus. Otherwise, all of them will be removed.
-	 */
-	if (iancestor && !cpumask_andnot(xcpus, xcpus, iancestor->effective_xcpus))
-		return; /* No CPU should be removed from isolated_cpus */
+	bool updated = false;
+	int cpu;
 
-	spin_lock_irq(&callback_lock);
-	isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
-	spin_unlock_irq(&callback_lock);
+	lockdep_assert_held(&callback_lock);
+	lockdep_assert_held(&cpuset_mutex);
+	for_each_cpu(cpu, xcpus)
+		updated |= isolated_cpu_update(prs, cpu);
+	if (updated)
+		update_housekeeping = true;
 }
 
 /*
@@ -1355,9 +1334,8 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
 	if (parent == &top_cpuset)
 		cpumask_andnot(subpartitions_cpus, subpartitions_cpus, xcpus);
 
-	if (old_prs != parent->partition_root_state)
-		isolated_cpus_update(old_prs, parent->partition_root_state,
-				     xcpus);
+	/* CPUs given back, including those of descendants, take parent's state */
+	isolated_cpus_set_state(parent->partition_root_state, xcpus);
 
 	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
 	cpumask_and(parent->effective_cpus, parent->effective_cpus, cpu_active_mask);
@@ -1612,6 +1590,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	struct cgroup_subsys_state *css;
 	struct cpuset *child;
 	bool populated = partition_is_populated(cs, NULL);
+	static cpumask_t xcpus;		/* Protected by cpuset_mutex */
 
 	/*
 	 * Check child partition roots to see if they should be invalidated
@@ -1640,14 +1619,15 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 			int parent_prs = cs->partition_root_state;
 
 			/*
-			 * Invalidate child partition and update isolated_cpus
-			 * if necessary.
+			 * Invalidate child partition. Its CPUs still owned by
+			 * cs take the isolation state of cs. effective_xcpus
+			 * of cs may not be updated yet, so recompute it.
 			 */
 			spin_lock_irq(&callback_lock);
 			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
-			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
-				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
-						     child->effective_xcpus);
+			compute_excpus(cs, &xcpus);
+			cpumask_and(&xcpus, &xcpus, child->effective_xcpus);
+			isolated_cpus_set_state(parent_prs, &xcpus);
 			child->partition_root_state = -old_prs;
 			spin_unlock_irq(&callback_lock);
 			notify_partition_change(child, old_prs);
@@ -2080,22 +2060,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 *
 		 * A partition error happens when parent has tasks and all
 		 * its effective CPUs will have to be distributed out.
-		 *
-		 * For an isolated partition with a shrunk root partition parent
-		 * we may need to return some or all of its isolated CPUs.
 		 */
 		nocpu |= cpumask_empty(tmp->delmask);
-		if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
-			cpumask_clear(tmp->addmask);
-			if (nocpu)
-				cpumask_copy(tmp->addmask, cs->effective_xcpus);
-			else if (!cpumask_subset(cs->effective_xcpus, parent->effective_xcpus))
-				cpumask_andnot(tmp->addmask, cs->effective_xcpus,
-							     parent->effective_xcpus);
-			if (!cpumask_empty(tmp->addmask))
-				isolated_cpus_release(cs, tmp->addmask);
-			/* Expansion of parent's effective_xcpus is handled below */
-		}
 		if (nocpu) {
 			part_error = PERR_NOCPUS;
 			if (is_partition_valid(cs))
@@ -2341,18 +2307,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 				/*
 				 * When parent is not a valid partition root,
 				 * child partition roots become invalid too.
-				 *
-				 * For a to be invalidated isolated partition,
-				 * call return_isolated_cpus() to remove the
-				 * relevant CPUs from isolated_cpus.
+				 * The isolation state of their CPUs has been
+				 * settled when the parent gave them back.
 				 */
 				if (is_partition_valid(cp))
 					new_prs = -old_prs;
 
-				if (old_prs == PRS_ISOLATED) {
-					cpumask_copy(tmp->delmask, cp->effective_xcpus);
-					isolated_cpus_release(cp, tmp->delmask);
-				}
 				WRITE_ONCE(cp->prs_err,
 					   is_partition_invalid(parent)
 					   ? PERR_INVPARENT : PERR_NOTPART);
-- 
2.34.1


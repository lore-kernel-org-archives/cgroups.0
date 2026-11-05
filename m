Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883187;
	b=fLjSxb+jkrH4AHw+zjTJVCKAVmpjN9S4adl7pKPB8ycYQU8NGQmCQTT5ThnsIMk5TIyl
	 OepIlziBeGBEVMseNRgw37rFGKZwoASAfATETwVhc5yH/4jp3F8QROYUh6ZXgOPiXHQg+
	 mr/UXMxHFsM7JcSLcDWul4uaH6iSMGSCwzjl7IutlKTxtoRi5Mz3CBDUCyQKsKUghyXpJ
	 2uzslBTb6mtb5DOWM5GCsWbHdm8928Vdg6APDyumCqMc01RrhylKJtZgEZjXe56DC0lBr
	 lCa8dI0J31gjM93EJ4cQP6rJeXUbu2EJzyxJzpFb6/CH4gNQ6CWVrHyQylqeMO/tBzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883187;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OOe2wOdRYzgYf895f2GdYIAmm1NJd02rkrKWHj8Mr9w=;
	b=LKOUgSc5WsTTj0RBmXz47k9/FcApKo0fJRDxNiA9VzFqOJiuuSRZsPf6oz5/OBrCuXk5
	 lm/RmiMOYlwKTWjbDOqmf8R7RDTTbo/JsDNJfWYhBhmDaD4AJF447EOlP/7K+j9oZOPLs
	 /FUnbYD4pwwwTTLp0EITs4oLU1AZ54Rx4l0ZXjsDo4C2nKqPESMs4Tbvs7+IdeIuXwD+a
	 fQlWDMl82nx52bZ5sTGcgYndLqAONsseb1xdGQdcx84KgjUAr3c64X8rLcYK/6FFMn66s
	 AEVbjjMYe8WveB2Bk01OxKY30gmrV5p+bgSjiKpHoGVeLXsmASv1KJZP2K7gODLlJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iNisAD8h;
	arc=none smtp.remote-ip=91.218.175.197
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B94606A31B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 12:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1B94606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iNisAD8h
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oEXHCiJXXuF7SNbDxAcjbIE9Emi6sLExBzOZpK/oLZ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883184; v=1; x=1794487984;
 b=iNisAD8hmQzodKf7CuQKYvgSUK9ryD7qoJXwgFXxf/e3AjmdjoJnoojY0Yn5iiY4DKU2I1/F
 oFumKt1QyD3NV1GrpBKZrsn1XdhYcFIKDItp1I8ZyEz3kPx+yQuVmNXqLDUQnrl0ZqWBGClLkIV
 qzXje4/OjEt7xATs4pyMwV8w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cc509d0b5523b216;
	Thu, 05 Nov 2026 12:53:04 +0000
X-Mizu-Trace-ID: cc509d0b5523b216
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 3/4] cpuset: settle isolation state when CPUs are given back to parent
Date: Thu,  5 Nov 2026 20:52:14 +0800
Message-Id: <20261105125215.2205892-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105125215.2205892-1-ridong.chen@linux.dev>
References: <20261105125215.2205892-1-ridong.chen@linux.dev>
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
index 68b82dabbf38..02823b0c4a41 100644
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


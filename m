Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645126;
	b=BCs3rjd4LioxrAk/ZQo17B4hJ0qFzrmxwiaYMV7xTtTPX26Urv/8G4A4wxFkGkMs+2+Y
	 67furUbtZ1/lxhaJxr4yyy7/AtbhZ5UHKnzVrH6HGUC/PB//GE0Oe/+sULLLARJRx+NdA
	 bBzGSnEWLzOTy1QEmNLrGVC5qA55oSoRWC6IMZwOfSEKJQ0Oi3vmbE1Lf2yVyYURWO1KQ
	 6c+134SndHJhskgNNKOK8j6eGgJRoR9oyCWACd+m5nl62Krwmp9MovLpvG1n0ftudCWHz
	 kGguQsj/6ZxA2PbrWeYSu9RnDfmmZNbQ61HNZqFV558Wb1/clDZ4B2XRzw9Ph1eYbMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645126;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=35N676uAOJE5A2ntiWHFBCVo31ydxpqnPzGSpqIjn20=;
	b=UKLVO1EC0xFKj8uykDqcW4UCIamNqwz9IqqpEVq5tlGgsxiRTy+QraSMhyPALd99gVh2
	 9SK+4XN52/dKEtxlPc3eMPb+GIdKmbVd3diPUTmTtNyCvU8Ziq/z92vVi4T/TQ3c9FFaF
	 uWyFF2Kh56d/T9i1M4Agl5jZHUd5ZQaJDw7dV6l99Uh40GAaLGLyCKEoB/De37fJv3toP
	 CwWGJRRtLJVQeg70yUNXr6KSaUJYfw8h+exFXR7abJrFveSdeLwbR3pWvSEQ1QZD+sRKH
	 FVva0E3rlMt6FYk6kgh6y+B0t328IDK0qXXI/MF9NqEJLTY/zrFeOg86kDX7PSlksbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CFGSaNIb;
	arc=none smtp.remote-ip=95.215.58.54
Received: from mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E094606A337
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E094606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CFGSaNIb
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T9S5qzC5sgA5kZVnMZpO+ELcVJyi8be65q++KooQ0pM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645123; v=1; x=1795249923;
 b=CFGSaNIbuSv7LL5A64zydFc4GfkCB+2H/moOHuqayxgIG4iVMlORwXljCQoeFZvJaVbefeQU
 9xr1REEOOCS0zkYWwTu8VbQk0S58IC5N+3cgZ5Eva6XsDY9Rr3FxyTSqUzYwxJdO/mQx0Fhz/zV
 OJQ7uN5DsvOb63FZjT6RY7lo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e9f3765267d479db;
	Sat, 14 Nov 2026 08:32:03 +0000
X-Mizu-Trace-ID: e9f3765267d479db
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 05/12] cpuset: use partition_disable() for remote partition disablement
Date: Sat, 14 Nov 2026 16:31:17 +0800
Message-Id: <20261114083124.1340140-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261114083124.1340140-1-ridong.chen@linux.dev>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
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

Now that the partition_disable() helper is available, replace the
existing implementation for remote partition disablement with this
centralized function to unify the disablement logic.

remote_partition_disable() is removed and its callers call
partition_disable() directly. The new partition root state is passed
in by the caller instead of being derived from cs->prs_err, as only the
caller knows which state the partition is going to.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 57 ++++++------------------------------------
 1 file changed, 8 insertions(+), 49 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3702e43e95ef..681adcde10e8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1771,9 +1771,8 @@ static void partition_enable(struct cpuset *cs, struct cpuset *parent,
  * has its state updated. A valid partition under an invalid parent has
  * already given back its CPUs, so only the propagation is done.
  */
-static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
-					     enum prs_errcode prs_err,
-					     struct tmpmasks *tmp)
+static void partition_disable(struct cpuset *cs, int new_prs,
+			      enum prs_errcode prs_err, struct tmpmasks *tmp)
 {
 	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
 	int old_prs = cs->partition_root_state;
@@ -1923,48 +1922,6 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	return 0;
 }
 
-/*
- * remote_partition_disable - Remove current cpuset from remote partition list
- * @cs: the cpuset to update
- * @tmp: temporary masks
- *
- * The effective_cpus is also updated.
- *
- * cpuset_mutex must be held by the caller.
- */
-static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
-{
-	WARN_ON_ONCE(!is_remote_partition(cs));
-	/*
-	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
-	 * which should clear subpartitions_cpus. We should not emit a warning for this
-	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
-	 * may already be cleared when disabling the partition.
-	 */
-	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
-		     !cpumask_empty(subpartitions_cpus));
-
-	spin_lock_irq(&callback_lock);
-	cs->remote_partition = false;
-	partition_xcpus_del(cs->partition_root_state, NULL, cs->effective_xcpus);
-	if (cs->prs_err)
-		cs->partition_root_state = -cs->partition_root_state;
-	else
-		cs->partition_root_state = PRS_MEMBER;
-
-	/* effective_xcpus may need to be changed */
-	compute_excpus(cs, cs->effective_xcpus);
-	reset_partition_data(cs);
-	spin_unlock_irq(&callback_lock);
-	cpuset_force_rebuild();
-
-	/*
-	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
-	 */
-	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
-	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
-}
-
 /*
  * remote_cpus_update - cpus_exclusive change of remote partition
  * @cs: the cpuset to be updated
@@ -2039,7 +1996,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	return;
 
 invalidate:
-	remote_partition_disable(cs, tmp);
+	partition_disable(cs, -prs, cs->prs_err, tmp);
 }
 
 /**
@@ -2667,7 +2624,8 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 
 	if (is_remote_partition(cs)) {
 		if (trialcs->prs_err)
-			remote_partition_disable(cs, tmp);
+			partition_disable(cs, -cs->partition_root_state,
+					  cs->prs_err, tmp);
 		else
 			remote_cpus_update(cs, trialcs->exclusive_cpus,
 					   trialcs->effective_xcpus, tmp);
@@ -3215,7 +3173,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 	if (disable_partition) {
 		if (is_remote_partition(cs))
-			remote_partition_disable(cs, &tmpmask);
+			partition_disable(cs, PRS_MEMBER, PERR_NONE, &tmpmask);
 		else
 			update_parent_effective_cpumask(cs, partcmd_disable,
 							NULL, &tmpmask);
@@ -4164,7 +4122,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 				       (cpumask_empty(&new_cpus) &&
 					partition_is_populated(cs, NULL)))) {
 		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
-		remote_partition_disable(cs, tmp);
+		partition_disable(cs, -cs->partition_root_state, cs->prs_err,
+				  tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
 	}
 
-- 
2.34.1


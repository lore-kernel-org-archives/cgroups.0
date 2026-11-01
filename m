Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.105
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533443;
	b=RhcwcE8e50JdLfOkG2D3X21Q0rEW9PP+YoG0aHGAVjbhqeYJWhgpqn4IoDfgEmMAgF8K
	 3r+eoePMpiQWzXYnZjPcnUz4P8lICgxeF24qnYCzhRY+coQ04lBEOFj5C2apxyHQsuB7c
	 qNRUxw+KuRIiIXivnqqFUYnz7Ru4DhbQ+yqqxCYor4ZPQ0fXpVHMmc1c6Yp/couYF1xpK
	 a8P6rSAkfiD9B4+wlJPS8uLX6t1SrCJ+ERTfKl21+yQdci8hJiDSUm4ix98ICsWATtLd5
	 bbCpTDvE72KyY0N3izTe8UEehoe8rwznanldj65yB81uztd/qSc/m2N6wXwlZgYN+Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533443;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G/UXbDFUAKI6yXKdZsrScCYDKG6KU1R3KwD4w2NVjn4=;
	b=To2qKc/FVqOkWhbqUutfZqg/788HX7iu3DAHpQnLoEFVDSCbjFSsJvO2E9zo6b5DUyBS
	 ElfgShZ1gVQtcKctdK24jI2Q4E0WoeR7GaYs7uKrlrW5NuLDpF+tptAVORjIM311NkXf8
	 PvpGwXYX8f+tVVxl8/HFrILc5v+W9LmTEjNo1n4ENCuVI+sfXju/Sku5/0fF8E+6YvOdV
	 NnXn1VOr0bD6jMDi8b/OaSUtZHb6DnJju6+7Y4EM+ImRoRRPBKZXcJtCrOUFxlVTW9HKI
	 0gnYF9tNz0Rpg6Uk/hiKxGzAFgfuJPwQ6GLcMRweFs9sPrUZr4SAWZeEvdKgAIhrD7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xvUjDNb8;
	arc=none smtp.remote-ip=91.218.175.105
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C3C606A324
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C3C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xvUjDNb8
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1bGQCX4VUV/CdUrWa9l1pSx5Znb7pHwA++BFd3GfgvE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533440; v=1; x=1794138240;
 b=xvUjDNb8Xs/6RS7+nX/Rr6fK4MwCROw1ffr+AEdefN94pzcUfo8QE5RiRhiUgTfoaMvIrE9V
 n2oOjpmfcgVdBibm+kkuhYzZclwm7/THLVqLyDJGZj0YAhPqyo7Z8VVL+Flqlgc6jNx1MWNyBVU
 xFEduJkpPG6YZ8lUfUgwdIwk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1628ff46c5874095;
	Sun, 01 Nov 2026 11:44:00 +0000
X-Mizu-Trace-ID: 1628ff46c5874095
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
Subject: [RFC PATCH -v4 12/22] cpuset: use local_partition_disable() to invalidate local partition
Date: Sun,  1 Nov 2026 19:41:56 +0800
Message-Id: <20261101114206.2434398-13-ridong.chen@linux.dev>
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

Build on the local_partition_disable() infrastructure introduced in the
previous patch to handle local partition invalidation, replacing
partcmd_invalidate in partition_cpus_change() and
cpuset_hotplug_update_tasks().

In cpuset_hotplug_update_tasks(), the partition error is now derived
from the reason of the invalidation (PERR_INVPARENT, PERR_NOTPART,
PERR_HOTPLUG or PERR_NOCPUS) and passed to local_partition_disable(),
which sets prs_err together with the partition root state.

As local_partition_disable() resets the partition data, the
effective_xcpus of an invalid partition is no longer kept. When
update_parent_effective_cpumask() turns an invalid partition back into
a valid one, use partition_enable() to set up effective_xcpus and the
partition state again.

Additionally, correct the transition logic in cpuset_hotplug_update_tasks()
when determining whether to transition an invalid partition root, the check
should be based on non-empty user_xcpus rather than non-empty
effective_xcpus. This correction addresses the scenario where
exclusive_cpus is not set but cpus_allowed is configured. In this case,
effective_xcpus may be empty even though the partition should be considered
for re-enablement. The user_xcpus based check ensures proper partition
state transitions under these conditions.

Since partition_disable() gives the CPUs back to the parent and updates
effective_cpus of the cpuset directly, save effective_cpus before any
partition state change in cpuset_hotplug_update_tasks() and compare the
new effective cpumask against it. Otherwise the tasks of a partition
invalidated by hotplug may be left with only the offlined CPUs.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 81 +++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3d6ad6cd634a..822cc1d97fca 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2133,23 +2133,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	adding = deleting = false;
 	old_prs = new_prs = cs->partition_root_state;
 
-	if (cmd == partcmd_invalidate) {
-		if (is_partition_invalid(cs))
-			return 0;
-
-		/*
-		 * Make the current partition invalid.
-		 */
-		if (is_partition_valid(parent))
-			adding = cpumask_and(tmp->addmask,
-					     cs->effective_xcpus,
-					     parent->effective_xcpus);
-		if (old_prs > 0)
-			new_prs = -old_prs;
-
-		goto write_error;
-	}
-
 	/*
 	 * The parent must be a partition root.
 	 * The new cpumask, if present, or the current cpus_allowed must
@@ -2340,20 +2323,28 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	 * Newly added CPUs will be removed from effective_cpus and
 	 * newly deleted ones will be added back to effective_cpus.
 	 */
-	spin_lock_irq(&callback_lock);
-	if (old_prs != new_prs)
-		cs->partition_root_state = new_prs;
+	if ((old_prs < 0) && (new_prs > 0)) {
+		/*
+		 * An invalid partition becomes valid again, its effective_xcpus
+		 * was reset when it was invalidated.
+		 */
+		partition_enable(cs, parent, new_prs, tmp->delmask);
+	} else {
+		spin_lock_irq(&callback_lock);
+		if (old_prs != new_prs)
+			cs->partition_root_state = new_prs;
 
-	/*
-	 * Adding to parent's effective_cpus means deletion CPUs from cs
-	 * and vice versa.
-	 */
-	if (adding)
-		partition_xcpus_del(old_prs, parent, tmp->addmask);
-	if (deleting)
-		partition_xcpus_add(new_prs, parent, tmp->delmask);
+		/*
+		 * Adding to parent's effective_cpus means deletion CPUs from cs
+		 * and vice versa.
+		 */
+		if (adding)
+			partition_xcpus_del(old_prs, parent, tmp->addmask);
+		if (deleting)
+			partition_xcpus_add(new_prs, parent, tmp->delmask);
 
-	spin_unlock_irq(&callback_lock);
+		spin_unlock_irq(&callback_lock);
+	}
 
 	if (adding || deleting) {
 		cpuset_update_tasks_cpumask(parent, tmp->addmask);
@@ -2657,8 +2648,7 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 					   trialcs->effective_xcpus, tmp);
 	} else {
 		if (trialcs->prs_err)
-			update_parent_effective_cpumask(cs, partcmd_invalidate,
-							NULL, tmp);
+			local_partition_disable(cs, trialcs->prs_err, tmp);
 		else
 			update_parent_effective_cpumask(cs, partcmd_update,
 							trialcs->effective_xcpus, tmp);
@@ -4089,7 +4079,7 @@ void cpuset_force_rebuild(void)
  */
 static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 {
-	static cpumask_t new_cpus;
+	static cpumask_t new_cpus, old_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated;
 	bool mems_updated;
@@ -4098,6 +4088,11 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	wait_attach_done_lock();
 	parent = parent_cs(cs);
+	/*
+	 * Partition state changes below may update effective_cpus directly,
+	 * save it to check if tasks need to be updated.
+	 */
+	cpumask_copy(&old_cpus, cs->effective_cpus);
 	compute_effective_cpumask(&new_cpus, cs, parent);
 	compute_effective_nodemask(&new_mems, cs, parent);
 
@@ -4123,18 +4118,30 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (is_local_partition(cs) &&
 	    (!is_partition_valid(parent) ||
 	     tasks_nocpu_error(parent, cs, &new_cpus) ||
-	     cpumask_empty(subpartitions_cpus)))
+	     cpumask_empty(subpartitions_cpus))) {
+		enum prs_errcode prs_err;
+
+		if (!is_partition_valid(parent))
+			prs_err = is_partition_invalid(parent)
+				  ? PERR_INVPARENT : PERR_NOTPART;
+		else if (cpumask_empty(subpartitions_cpus))
+			prs_err = PERR_HOTPLUG;
+		else
+			prs_err = PERR_NOCPUS;
 		partcmd = partcmd_invalidate;
+		local_partition_disable(cs, prs_err, tmp);
+	}
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
-	 * back to a regular one with a non-empty effective xcpus.
+	 * back to a regular one with a non-empty user xcpus.
 	 */
 	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
-		 !cpumask_empty(cs->effective_xcpus))
+		 !cpumask_empty(user_xcpus(cs))) {
 		partcmd = partcmd_update;
+		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
+	}
 
 	if (partcmd >= 0) {
-		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
 		if (is_partition_valid(cs) || (partcmd == partcmd_invalidate)) {
 			compute_effective_cpumask(&new_cpus, cs, parent);
 			cpuset_force_rebuild();
@@ -4142,7 +4149,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	}
 
 update_tasks:
-	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
+	cpus_updated = !cpumask_equal(&new_cpus, &old_cpus);
 	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
 	if (!cpus_updated && !mems_updated)
 		goto unlock;	/* Hotplug doesn't affect this cpuset */
-- 
2.34.1


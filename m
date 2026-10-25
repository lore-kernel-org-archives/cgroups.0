Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964741;
	b=fKMOyJAe10QGXUCh4Hp4tXwLbtYKn3C9/A9xkUXvGKFikKNWKVfOV22E3zXXqyAbKeUj
	 IK/bYExpujC7U578I6p6WRL4PuINwTCrWUXFEy3UzBcaHix0/BUZlrBQ9FNjrfG6hiPbF
	 dHVxKT07yOwSeHNX/m00HlUt64wmNiznyn4ghXh64rUtYeTLbtT9/KSVF7ZBlP0LUYw59
	 hvzfjFFYQESkEASmNhsd7fQWGB/yy+KIfE6e1hAHF0dq4rz1MUTK0rRyyGxLyNt0HbraP
	 S6sTwfrOg4Y+uqw49GfGW9q9hO7E6OK3hiMbrHTp3omG1k9khMAGd86Ruh/+xWy+dww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964741;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=RmmiNxhQYzkoyzwzJ8ZlP6Znb5o4/dCzCPLyRTfCPp0=;
	b=Xcts2VcApQYIQ18k3sbteyD3f1nDD0KE+9iatNdlE78hbAbQ4EuwMqM62GNQOxfqh4Lc
	 aWDG3FkE30VivhA8wIH4evpX5HE0l2dHB6qlwWfE+dedtgIuBSMC6CwVSj2kcJOr0FpAD
	 2preqg/gCELHMTQm+lnkbnjaDR4U7gNpL/FMpBXsDMVOGb1bx+lUQk4QqXoTJDSk2D6jH
	 qgkvGFRV57dOMsnWFo6cKzyMW3eLJST2f+WPXQRolCVn3+zgW05d/WHeOqMCv2upfwpwY
	 wFhKQ9G456v59AiWdx333cHENS3hdZaHPIvCsMml6KPOygw3TGd9ioN4AluSqXpH2Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=emrw1J0+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D95606A339
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18D95606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=emrw1J0+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RmmiNxhQYzkoyzwzJ8ZlP6Znb5o4/dCzCPLyRTfCPp0=;
	b=emrw1J0+1DZNUF9SLZRVsNq5dluiX+HmlWtSLKTcAMMM5fBhdvhqrfKBhJ4KwWGA3fvI/S
	ELFdry0ABoBzxvR43U4U56D6GJ8LAd6b2sGKaL3JTDZTez3B0Dowh3hqLo/iQ3IeEn8zU6
	ZcWF4IuXvUxOWe6HZ50+7TLeD0RPMnU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-ja7uuJ1GO0qELHHIQOCwVg-1; Sun,
 25 Oct 2026 17:45:31 -0400
X-MC-Unique: ja7uuJ1GO0qELHHIQOCwVg-1
X-Mimecast-MFC-AGG-ID: ja7uuJ1GO0qELHHIQOCwVg_1792964730
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 437F81955E76;
	Sun, 25 Oct 2026 21:45:30 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A3BCD1956089;
	Sun, 25 Oct 2026 21:45:28 +0000 (UTC)
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
Subject: [PATCH-next v3 10/11] cgroup/cpuset: Relocate compute_*effective_cpumask() and compute_effective_nodemask()
Date: Sun, 25 Oct 2026 17:44:48 -0400
Message-ID: <20261025214449.310715-11-longman@redhat.com>
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

Relocate compute_partition_effective_cpumask(),
compute_effective_cpumask(), and compute_effective_nodemask() together so
that compute_effective_cpumask() and compute_partition_effective_cpumask()
can be further integrated together. There is no functional change.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 212 ++++++++++++++++++++---------------------
 1 file changed, 106 insertions(+), 106 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3daab2381f04..f37d929616a6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1135,43 +1135,6 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 	css_task_iter_end(&it);
 }
 
-/**
- * compute_effective_cpumask - Compute the effective cpumask of the cpuset
- * @new_cpus: the temp variable for the new effective_cpus mask
- * @cs: the cpuset the need to recompute the new effective_cpus mask
- * @parent: the parent cpuset
- *
- * For v2, the parent's effective_cpus is inherited if cpumask is empty.
- * The result is valid only if the given cpuset isn't a partition root.
- */
-static void compute_effective_cpumask(struct cpumask *new_cpus,
-				      struct cpuset *cs, struct cpuset *parent)
-{
-	bool has_cpus;
-
-	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
-	if (!has_cpus && is_in_v2_mode())
-		cpumask_copy(new_cpus, parent->effective_cpus);
-}
-
-/**
- * compute_effective_nodemask - Compute the effective nodemask of the cpuset
- * @new_mems: the temp variable for the new effective_mems mask
- * @cs: the cpuset the need to recompute the new effective_mems mask
- * @parent: the parent cpuset
- *
- * For v2, the parent's effective_mems is inherited if nodemask is empty.
- */
-static void compute_effective_nodemask(nodemask_t *new_mems,
-				       struct cpuset *cs, struct cpuset *parent)
-{
-	bool has_mems;
-
-	has_mems = nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
-	if (!has_mems && is_in_v2_mode())
-		nodes_copy(*new_mems, parent->effective_mems);
-}
-
 /*
  * Commands for update_parent_effective_cpumask
  */
@@ -1622,6 +1585,112 @@ static int compute_trialcs_excpus(struct cpuset *trialcs, struct cpuset *cs)
 	return rm_siblings_excl_cpus(parent, cs, excpus);
 }
 
+/**
+ * compute_partition_effective_cpumask - compute effective_cpus for partition
+ * @cs: partition root cpuset
+ * @new_ecpus: previously computed effective_cpus to be updated
+ *
+ * Compute the effective_cpus of a partition root by scanning effective_xcpus
+ * of child partition roots and excluding their effective_xcpus.
+ *
+ * This has the side effect of invalidating valid child partition roots,
+ * if necessary. Since it is called from either cpuset_hotplug_update_tasks()
+ * or update_cpumasks_hier() where parent and children are modified
+ * successively, we don't need to call update_parent_effective_cpumask()
+ * and the child's effective_cpus will be updated in later iterations.
+ */
+static void compute_partition_effective_cpumask(struct cpuset *cs,
+						struct cpumask *new_ecpus)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+	bool populated = partition_is_populated(cs, NULL);
+
+	WARN_ON_ONCE(!is_partition_valid(cs));
+
+	/*
+	 * Check child partition roots to see if they should be invalidated
+	 * when all the effective_cpus will be used up and cs is populated.
+	 * It is better to sacrifice a child partition root than invalidating
+	 * the whole subtree.
+	 *
+	 * Return early if the effective_cpus is already empty.
+	 */
+	compute_excpus(cs, new_ecpus);
+	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
+		return;
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, cs) {
+		if (!is_partition_valid(child))
+			continue;
+
+		/*
+		 * There shouldn't be a remote partition underneath another
+		 * partition root.
+		 */
+		WARN_ON_ONCE(is_remote_partition(child));
+		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
+			int old_prs = child->partition_root_state;
+			int parent_prs = cs->partition_root_state;
+
+			/*
+			 * Invalidate child partition and update isolated_cpus
+			 * if necessary.
+			 */
+			spin_lock_irq(&callback_lock);
+			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
+			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
+				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
+						     child->effective_xcpus);
+			child->partition_root_state = -old_prs;
+			spin_unlock_irq(&callback_lock);
+			notify_partition_change(child, old_prs);
+			continue;
+		}
+		cpumask_andnot(new_ecpus, new_ecpus,
+			       child->effective_xcpus);
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * compute_effective_cpumask - Compute the effective cpumask of the cpuset
+ * @new_cpus: the temp variable for the new effective_cpus mask
+ * @cs: the cpuset the need to recompute the new effective_cpus mask
+ * @parent: the parent cpuset
+ *
+ * For v2, the parent's effective_cpus is inherited if cpumask is empty.
+ * The result is valid only if the given cpuset isn't a partition root.
+ */
+static void compute_effective_cpumask(struct cpumask *new_cpus,
+				      struct cpuset *cs, struct cpuset *parent)
+{
+	bool has_cpus;
+
+	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
+	if (!has_cpus && is_in_v2_mode())
+		cpumask_copy(new_cpus, parent->effective_cpus);
+}
+
+/**
+ * compute_effective_nodemask - Compute the effective nodemask of the cpuset
+ * @new_mems: the temp variable for the new effective_mems mask
+ * @cs: the cpuset the need to recompute the new effective_mems mask
+ * @parent: the parent cpuset
+ *
+ * For v2, the parent's effective_mems is inherited if nodemask is empty.
+ */
+static void compute_effective_nodemask(nodemask_t *new_mems,
+				       struct cpuset *cs, struct cpuset *parent)
+{
+	bool has_mems;
+
+	has_mems = nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
+	if (!has_mems && is_in_v2_mode())
+		nodes_copy(*new_mems, parent->effective_mems);
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
@@ -2145,75 +2214,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	return 0;
 }
 
-/**
- * compute_partition_effective_cpumask - compute effective_cpus for partition
- * @cs: partition root cpuset
- * @new_ecpus: previously computed effective_cpus to be updated
- *
- * Compute the effective_cpus of a partition root by scanning effective_xcpus
- * of child partition roots and excluding their effective_xcpus.
- *
- * This has the side effect of invalidating valid child partition roots,
- * if necessary. Since it is called from either cpuset_hotplug_update_tasks()
- * or update_cpumasks_hier() where parent and children are modified
- * successively, we don't need to call update_parent_effective_cpumask()
- * and the child's effective_cpus will be updated in later iterations.
- */
-static void compute_partition_effective_cpumask(struct cpuset *cs,
-						struct cpumask *new_ecpus)
-{
-	struct cgroup_subsys_state *css;
-	struct cpuset *child;
-	bool populated = partition_is_populated(cs, NULL);
-
-	WARN_ON_ONCE(!is_partition_valid(cs));
-
-	/*
-	 * Check child partition roots to see if they should be invalidated
-	 * when all the effective_cpus will be used up and cs is populated.
-	 * It is better to sacrifice a child partition root than invalidating
-	 * the whole subtree.
-	 *
-	 * Return early if the effective_cpus is already empty.
-	 */
-	compute_excpus(cs, new_ecpus);
-	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
-		return;
-
-	rcu_read_lock();
-	cpuset_for_each_child(child, css, cs) {
-		if (!is_partition_valid(child))
-			continue;
-
-		/*
-		 * There shouldn't be a remote partition underneath another
-		 * partition root.
-		 */
-		WARN_ON_ONCE(is_remote_partition(child));
-		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
-			int old_prs = child->partition_root_state;
-			int parent_prs = cs->partition_root_state;
-
-			/*
-			 * Invalidate child partition and update isolated_cpus
-			 * if necessary.
-			 */
-			spin_lock_irq(&callback_lock);
-			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
-			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
-				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
-						     child->effective_xcpus);
-			child->partition_root_state = -old_prs;
-			spin_unlock_irq(&callback_lock);
-			notify_partition_change(child, old_prs);
-			continue;
-		}
-		cpumask_andnot(new_ecpus, new_ecpus,
-			       child->effective_xcpus);
-	}
-	rcu_read_unlock();
-}
-
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
-- 
2.56.0


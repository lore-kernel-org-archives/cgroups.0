Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B5A3BF68F
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526939; cv=none; b=N+IRlcMnLd6RJHRlKchY5ky3hPN2d6ClYHyIwor96AaJ6QAAJExGHiVUEKDov5KH2boWUi8Xym6cKOgdRvEerJJsPUeQzBh4gKeILeGi+F9lhuGD4+KTBLqULKU0u3Ad80lHwoQ0FLbib+2bEct+qkImSe7K2Q4pk/GG94r5cOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526939; c=relaxed/simple;
	bh=UtlM9bcM1dvwalsJgJ3cqzDrO/uTqo4TcKkSof2x81M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/ta5AxmqTjfZwzmWc2DKZHCu526OJnKl+2+Epw3GcJMzlquiTgK1ZXL9nbAJ0F9q33W7n/5lBjHuCW5NRp0LqPnzHIRHQ5qwOD2IHG/qkJ7Kelr/Tu8+SSyu/FLo/JM0bhQAXPsZSmc5Ss8If7NRrSjM2kyvYD1jaN4ixML8L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORuhDeIx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORuhDeIx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790526936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mraiSnZk6IQGMN5G7GboSUGP55GtudD9bzkvemI8zvA=;
	b=ORuhDeIxSD2q1F/IFjWcGKlL3h0WcheQ523ApkVJv8HzZKrRYxmbtXVBtlENISx6DeeTf5
	xkDt5ZO8Ms9jhM92pHrpniN2sJytfci6eLG52IITldMszwM3osQ4RA5XbHQpxCFJEK0PXy
	Y0828ykkZHuFORv3p47SmVJCXsbOmW8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-cmks5g1UNGCe7toRWEz4PA-1; Sun,
 27 Sep 2026 12:35:32 -0400
X-MC-Unique: cmks5g1UNGCe7toRWEz4PA-1
X-Mimecast-MFC-AGG-ID: cmks5g1UNGCe7toRWEz4PA_1790526931
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1D181955F1A;
	Sun, 27 Sep 2026 16:35:30 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5CD6D418;
	Sun, 27 Sep 2026 16:35:28 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 1/2] cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
Date: Sun, 27 Sep 2026 12:34:53 -0400
Message-ID: <20260927163454.345463-2-longman@redhat.com>
In-Reply-To: <20260927163454.345463-1-longman@redhat.com>
References: <20260927163454.345463-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Commit f82f80426f7a ("sched/deadline: Ensure that updates to exclusive
cpusets don't break AC") adds a check in validate_change() to make
sure that there is enough bandwidth for SCHED_DEADLINE tasks if we
shrink a v1 exclusive cpuset that has CS_CPU_EXCLUSIVE flag set.

With the introduction of cpuset partition in cgroup v2, we keep setting
the CS_CPU_EXCLUSIVE flag for a partition root so that the SCHED_DEADLINE
check will continue to work as intended. However it turns out that the
current code isn't perfect and there are cases where a cpuset isn't
a valid partition root, but the exclusive flag is still incorrectly
set. This can leads to SCHED_DEADLINE check being incorrectly triggered
when there are deadline tasks in the system. This can result in unexpected
-EBUSY failure when making changes to cpuset control files. Fix that
by checking for a valid partition root in the case of v2 and break out
the v1 specific check back into cpuset1_validate_change(). It is far
easier and less cumbersome than to make sure that the exclusive flag
is only set for valid partition roots.

The is_in_v2_mode() check guarding the call to cpuset1_validate_change()
is also moved to the appropriate place inside cpuset1_validate_change()
and a cpuset_v2() is now being used as a guard which should be more
accurate for the a v1 system with v2 mode enabled.

Even though commit a86ce68078b2 ("cgroup/cpuset: Extract out
CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling") is marked as a
commit to be fixed, the problem may exist before that.

Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset-v1.c | 20 ++++++++++++++++++--
 kernel/cgroup/cpuset.c    | 17 +++++------------
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
index 562ad35f00d0..c03ae8aac03a 100644
--- a/kernel/cgroup/cpuset-v1.c
+++ b/kernel/cgroup/cpuset-v1.c
@@ -61,6 +61,11 @@ struct cpuset_remove_tasks_struct {
 #define FM_MAXCNT 1000000	/* limit cnt to avoid overflow */
 #define FM_SCALE 1000		/* faux fixed point scale */
 
+static inline bool is_in_v2_mode(void)
+{
+	return cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE;
+}
+
 /* Initialize a frequency meter */
 static void fmeter_init(struct fmeter *fmp)
 {
@@ -357,10 +362,21 @@ int cpuset1_validate_change(struct cpuset *cur, struct cpuset *trial)
 		if (!is_cpuset_subset(c, trial))
 			goto out;
 
-	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
+	/*
+	 * We can't shrink if we won't have enough room for SCHED_DEADLINE
+	 * tasks in a scheduling partition.
+	 */
+	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
+	    !cpuset_cpumask_can_shrink(cur->cpus_allowed, trial->cpus_allowed))
+		goto out;
+
+	/*
+	 * On legacy hierarchy with v2 mode off, we must be a subset of our
+	 * parent cpuset.
+	 */
 	ret = -EACCES;
 	par = parent_cs(cur);
-	if (par && !is_cpuset_subset(trial, par))
+	if (par && !is_in_v2_mode() && !is_cpuset_subset(trial, par))
 		goto out;
 
 	/*
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 753aa65afcd7..5639c486c967 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -752,7 +752,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	rcu_read_lock();
 
-	if (!is_in_v2_mode())
+	if (!cpuset_v2())
 		ret = cpuset1_validate_change(cur, trial);
 	if (ret)
 		goto out;
@@ -765,23 +765,16 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	/*
 	 * We can't shrink if we won't have enough room for SCHED_DEADLINE
-	 * tasks. This check is not done when scheduling is disabled as the
-	 * users should know what they are doing.
-	 *
-	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
-	 * cpus_allowed.
-	 *
-	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
-	 * for non-isolated partition root. At this point, the target
-	 * effective_cpus isn't computed yet. user_xcpus() is the best
-	 * approximation.
+	 * tasks. This check is only done on non-isolated partition root.
+	 * At this point, the target effective_cpus isn't computed yet.
+	 * user_xcpus() is the best approximation.
 	 *
 	 * TBD: May need to precompute the real effective_cpus here in case
 	 * incorrect scheduling of SCHED_DEADLINE tasks in a partition
 	 * becomes an issue.
 	 */
 	ret = -EBUSY;
-	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
+	if (is_partition_valid(cur) && is_sched_load_balance(cur) &&
 	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
 		goto out;
 
-- 
2.55.0


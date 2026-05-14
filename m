Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F49C38946A
	for <cgroups@vger.kernel.org>; Thu, 14 May 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778778207; cv=none; b=G/ov8/e0iudrUyViZfAAtyBahLywdrEybWjZIWK/6xrCNHfUnoivTIcsRZo7J0g669NgGmF4GvDgbegG658uqM1uLlkpYrRZuxCQDV5cSNXpQ4eoE3q7acDMS+1r7NKBjY9sKVMJX3t2aQgpVWPBVR7BeYQD1FrUwx9EtLBUfEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778778207; c=relaxed/simple;
	bh=2CPgVrj0NT1gX38aqCa21xvtd73b37MX8+ApDO92tlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH88P6tBD72/Yd9k6fYcq4aUuARv4OeMUUd38zmXORRgts8+QZzrlKwIXQ9Urpghr/XXJ90A3pVPyz+ZspHmdPYsxz4Ia69gkiO6dmXtStgUGy4wo7uq7mL22XPFA+jJhULwnFtbQV3Y2wJSQMd+a2XHvoZ4SFAKZ9AlA+IeyQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O/y8EE4n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/y8EE4n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778778205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CqVFB9YopdZw9qu89CsUJQEJgWpqo6bFaKJu6uJdmm0=;
	b=O/y8EE4n8nUq7oVZ6oUgt2SBoDhGzDxJNug9bjYySg+NSepSY/vnFQhfo8G2LLXW1xaguu
	FOul8YejkAeISnILZMeInZcTluYfPnUWqlpSlmP5UQb17pvdziQSyLQ1hY0JYxpRdMo0lB
	Pb7B0t+nLAz5YPghccGvnjd4rI+OX1s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-fVFei_UKOyunT454G7CQhw-1; Thu,
 14 May 2026 13:03:22 -0400
X-MC-Unique: fVFei_UKOyunT454G7CQhw-1
X-Mimecast-MFC-AGG-ID: fVFei_UKOyunT454G7CQhw_1778778200
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 663E2195608E;
	Thu, 14 May 2026 17:03:20 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.73])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF7E730002DA;
	Thu, 14 May 2026 17:03:17 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH cgroup/for-next 3/4] cgroup/cpuset: Optimize cpuset_attach_task()
Date: Thu, 14 May 2026 13:02:39 -0400
Message-ID: <20260514170240.575156-4-longman@redhat.com>
In-Reply-To: <20260514170240.575156-1-longman@redhat.com>
References: <20260514170240.575156-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Within cpuset_attach(), cpuset_attach_task() is called only if either the
CPU and/or the memory setting are updated. If only one of the settings
is updated, cpuset_attach_task() still updates both CPU and memory node
setting of each task. Further optimize it by checking attach_cpus_updated
and attach_mems_updated for v2 to skip the unnecessary update.

While at it, also move the mpol_rebind_mm() call for mm group leader
to cpuset_attach_task(). This change shouldn't affect the cpuset_fork()
caller as the newly cloned task isn't the group leader. For that caller,
it is assumed that both CPU and memory nodes are updated to keep the
existing behavior.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 68392cf6429b..8ced1fa0900f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3132,8 +3132,13 @@ static nodemask_t cpuset_attach_nodemask_to;
 
 static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 {
+	struct mm_struct *mm;
+
 	lockdep_assert_cpuset_lock_held();
 
+	if (cpuset_v2() && !attach_cpus_updated)
+		goto update_mem;
+
 	if (cs != &top_cpuset)
 		guarantee_active_cpus(task, cpus_attach);
 	else
@@ -3145,8 +3150,21 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 	 */
 	WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
+update_mem:
+	if (cpuset_v2() && !attach_mems_updated)
+		return;
+
 	cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 	cpuset1_update_task_spread_flags(cs, task);
+
+	if (task != task->group_leader)
+		return;
+
+	mm = get_task_mm(task);
+	if (mm) {
+		mpol_rebind_mm(mm, &cs->effective_mems);
+		mmput(mm);
+	}
 }
 
 static void cpuset_attach(struct cgroup_taskset *tset)
@@ -3187,15 +3205,13 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	 * not set.
 	 */
 	cpuset_attach_nodemask_to = cs->effective_mems;
-	if (!is_memory_migrate(cs) && !attach_mems_updated)
+	if (!is_memory_migrate(cs))
 		goto out;
 
 	cgroup_taskset_for_each_leader(leader, css, tset) {
 		struct mm_struct *mm = get_task_mm(leader);
 
 		if (mm) {
-			mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
-
 			/*
 			 * old_mems_allowed is the same with mems_allowed
 			 * here, except if this task is being moved
@@ -3204,18 +3220,15 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 			 * @old_mems_allowed is the right nodesets that we
 			 * migrate mm from.
 			 */
-			if (is_memory_migrate(cs)) {
-				cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-						  &cpuset_attach_nodemask_to);
-				queue_task_work = true;
-			} else
-				mmput(mm);
+			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
+					  &cpuset_attach_nodemask_to);
+			queue_task_work = true;
 		}
 	}
 
-out:
 	if (queue_task_work)
 		schedule_flush_migrate_mm();
+out:
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
 
 	if (cs->nr_migrate_dl_tasks) {
@@ -3666,7 +3679,10 @@ static void cpuset_fork(struct task_struct *task)
 	/* CLONE_INTO_CGROUP */
 	mutex_lock(&cpuset_mutex);
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	/* Assume CPUs and memory nodes are updated */
+	attach_cpus_updated = attach_mems_updated = true;
 	cpuset_attach_task(cs, task);
+	attach_cpus_updated = attach_mems_updated = false;
 
 	dec_attach_in_progress_locked(cs);
 	mutex_unlock(&cpuset_mutex);
-- 
2.54.0


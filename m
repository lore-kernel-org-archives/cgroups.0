Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED0A3B3C1F
	for <cgroups@vger.kernel.org>; Thu,  2 Jul 2026 21:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783028944; cv=none; b=k+O7cbmZoWF/08QTzXuPc9/jBxlHzUVNgXzS9xOMYkrAcRqdmSf1Fo1ZbUJL9jpoTrFLCV35aFRw+KodsAFpxaptSaylTO5Wjwqpg4vxQsHety2hIoHihr7Xg2nhgrz1rxRLbD9OtTCV0l8BZrefX1aB7Ux+0olLecxhpP+jjiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783028944; c=relaxed/simple;
	bh=Fa2wZ1B3U76y8J4Cn8fgSJTRHwBANR6CHDDEqHxnsQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3HjRlRS0nobeQnGTlQC02vDARQpwF7uAgBNSuF1RnCY4bnUZUd98iiPtB8bg1LDIzVa2fVA9NyUPRAjf3i1ANc+vc4bAUVBwrDxagUj5wUfz8g6+avvf8pMbwIpYIm98Z4uK5hGIj9uldRKZlr85IsZ/hdJ+Syy95Rr2tcZusE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iIPWT8p7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iIPWT8p7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783028941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPUmj6/nPcbZYDJXqJezGo0QkuPHpdPuRY0qPcoPBFk=;
	b=iIPWT8p7rHO0xqhr8hwGS/05cHLJMRRwKWO6DMpoLPkFgdLTQbfnkZKHSpySDhSwzrrN0C
	jymm2o1+mWyMYMGiMEbSBXAERZjU8OdSiamIlhs+4LZ2fcxuU+nnOMq19G7Tne03EGuCXo
	wbbpUwDzEGsKDC2tYoqcVOgNBVONE7w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-CCQMH-KyNi2_ktTzDtuhNA-1; Thu,
 02 Jul 2026 17:49:00 -0400
X-MC-Unique: CCQMH-KyNi2_ktTzDtuhNA-1
X-Mimecast-MFC-AGG-ID: CCQMH-KyNi2_ktTzDtuhNA_1783028939
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A36819792F8;
	Thu,  2 Jul 2026 21:48:59 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.58])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4425E3189;
	Thu,  2 Jul 2026 21:48:56 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v10 08/11] cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside cpuset_attach_task()
Date: Thu,  2 Jul 2026 17:47:54 -0400
Message-ID: <20260702214757.579012-9-longman@redhat.com>
In-Reply-To: <20260702214757.579012-1-longman@redhat.com>
References: <20260702214757.579012-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

The cpuset_attach_task() was introduced in commit 42a11bf5c543
("cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly")
to enable the CLONE_INTO_CGROUP flag of clone(2) to behave more like
moving a task from one cpuset into another one. That commits didn't
move the mpol_rebind_mm() and cpuset_migrate_mm() calls for group leader
into cpuset_attach_task().

When the CLONE_INTO_CGROUP flag is used without CLONE_THREAD, the new
task is its own group leader. So it is still not equivalent to moving
task between cpusets in this case. Make CLONE_INTO_CGROUP behaves
more close to cpuset_attach() by moving the mpol_rebind_mm() and
cpuset_migrate_mm() calls inside cpuset_attach_task().

Also move the stack local cpus_updated, mems_updated and queue_task_work
flags into attach_ctx so that these flags can be accessed inside and
outside of cpuset_attach_task(). The cpuset_fork() function is updated
to set up these flags and do memory migration if necessary.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 103 +++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 44 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 55cd580373b7..9a9de47d52f4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -362,6 +362,9 @@ static DECLARE_WAIT_QUEUE_HEAD(cpuset_attach_wq);
  */
 static struct {
 	int in_progress;
+	bool cpus_updated;
+	bool mems_updated;
+	bool task_work_queued;
 	struct cpuset *old_cs;	/* Source cpuset */
 	nodemask_t nodemask_to;
 } attach_ctx;
@@ -3190,6 +3193,8 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 {
+	struct mm_struct *mm;
+
 	lockdep_assert_cpuset_lock_held();
 
 	if (cs != &top_cpuset)
@@ -3203,28 +3208,59 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 	 */
 	WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
+	if (cpuset_v2() && !attach_ctx.mems_updated)
+		return;
+
 	cpuset_change_task_nodemask(task, &attach_ctx.nodemask_to);
 	cpuset1_update_task_spread_flags(cs, task);
+
+	if ((task != task->group_leader) || !attach_ctx.mems_updated)
+		return;
+
+	/*
+	 * Change mm for threadgroup leader. This is expensive and may
+	 * sleep and should be moved outside migration path proper.
+	 */
+	mm = get_task_mm(task);
+	if (mm) {
+		struct cpuset *oldcs = attach_ctx.old_cs;
+
+		mpol_rebind_mm(mm, &cs->effective_mems);
+
+		/*
+		 * old_mems_allowed is the same with mems_allowed
+		 * here, except if this task is being moved
+		 * automatically due to hotplug.  In that case
+		 * @mems_allowed has been updated and is empty, so
+		 * @old_mems_allowed is the right nodesets that we
+		 * migrate mm from.
+		 */
+		if (is_memory_migrate(cs)) {
+			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
+					  &attach_ctx.nodemask_to);
+			attach_ctx.task_work_queued = true;
+		} else {
+			mmput(mm);
+		}
+	}
 }
 
 static void cpuset_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
-	struct task_struct *leader;
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
 	struct cpuset *oldcs = attach_ctx.old_cs;
-	bool cpus_updated, mems_updated;
-	bool queue_task_work = false;
 
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
 	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	mutex_lock(&cpuset_mutex);
-	cpus_updated = !cpumask_equal(cs->effective_cpus,
-				      oldcs->effective_cpus);
-	mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
+	attach_ctx.task_work_queued = false;
+
+	attach_ctx.cpus_updated = !cpumask_equal(cs->effective_cpus, oldcs->effective_cpus);
+	attach_ctx.mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
 	guarantee_online_mems(cs, &attach_ctx.nodemask_to);
 
 	/*
@@ -3233,46 +3269,14 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	 * and mems. In that case, we can optimize out by skipping the task
 	 * iteration and update.
 	 */
-	if (cpuset_v2() && !cpus_updated && !mems_updated)
+	if (cpuset_v2() && !attach_ctx.cpus_updated && !attach_ctx.mems_updated)
 		goto out;
 
 	cgroup_taskset_for_each(task, css, tset)
 		cpuset_attach_task(cs, task);
 
-	/*
-	 * Change mm for all threadgroup leaders. This is expensive and may
-	 * sleep and should be moved outside migration path proper. Skip it
-	 * if there is no change in effective_mems and CS_MEMORY_MIGRATE is
-	 * not set.
-	 */
-	if (!is_memory_migrate(cs) && !mems_updated)
-		goto out;
-
-	cgroup_taskset_for_each_leader(leader, css, tset) {
-		struct mm_struct *mm = get_task_mm(leader);
-
-		if (mm) {
-			mpol_rebind_mm(mm, &cs->effective_mems);
-
-			/*
-			 * old_mems_allowed is the same with mems_allowed
-			 * here, except if this task is being moved
-			 * automatically due to hotplug.  In that case
-			 * @mems_allowed has been updated and is empty, so
-			 * @old_mems_allowed is the right nodesets that we
-			 * migrate mm from.
-			 */
-			if (is_memory_migrate(cs)) {
-				cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-						  &attach_ctx.nodemask_to);
-				queue_task_work = true;
-			} else
-				mmput(mm);
-		}
-	}
-
 out:
-	if (queue_task_work)
+	if (attach_ctx.task_work_queued)
 		schedule_flush_migrate_mm();
 	cs->old_mems_allowed = attach_ctx.nodemask_to;
 
@@ -3708,15 +3712,14 @@ static void cpuset_cancel_fork(struct task_struct *task, struct css_set *cset)
  */
 static void cpuset_fork(struct task_struct *task)
 {
-	struct cpuset *cs;
-	bool same_cs;
+	struct cpuset *cs, *oldcs;
 
 	rcu_read_lock();
 	cs = task_cs(task);
-	same_cs = (cs == task_cs(current));
+	oldcs = task_cs(current);
 	rcu_read_unlock();
 
-	if (same_cs) {
+	if (cs == oldcs) {
 		if (cs == &top_cpuset)
 			return;
 
@@ -3728,7 +3731,19 @@ static void cpuset_fork(struct task_struct *task)
 	/* CLONE_INTO_CGROUP */
 	mutex_lock(&cpuset_mutex);
 	guarantee_online_mems(cs, &attach_ctx.nodemask_to);
+	cs->old_mems_allowed = attach_ctx.nodemask_to;
+
+	/*
+	 * Assume CPUs and memory nodes are updated
+	 * A CLONE_INTO_CGROUP operation should have taken the cgroup mutex
+	 * and so there shouldn't be a competing cpuset_attach() operation.
+	 */
+	attach_ctx.cpus_updated = attach_ctx.mems_updated = true;
+	attach_ctx.task_work_queued = false;
+	attach_ctx.old_cs = oldcs;
 	cpuset_attach_task(cs, task);
+	if (attach_ctx.task_work_queued)
+		schedule_flush_migrate_mm();
 
 	dec_attach_in_progress_locked();
 	mutex_unlock(&cpuset_mutex);
-- 
2.54.0


From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3 3/4] cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
Date: Thu,  6 Apr 2023 10:04:03 -0400
Message-ID: <20230406140404.2718574-4-longman@redhat.com>
References: <20230406140404.2718574-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680789862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dMo/PkUQpVPvNP5N/JYP8JDoaJqZJ0p/4b3QAb5N/o=;
        b=b6g/JqcqGa8o8vb/qS0CtKgMMA2EIamS4n9fIyve1al/1aaUyo50ehK0LGj7xSrpY24cUY
        PQojA/Qu+51/RFwcAWNaAxCh8rMxszTrLDnWpeKh+KQaBycpUO7j9kNYsssch3oHgkk0Jn
        WhhEbpQ9zLaqIPtJT8UcgS3Z0cCSIHA=
In-Reply-To: <20230406140404.2718574-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, gscrivan@redhat.com, Waiman Long <longman@redhat.com>

In the case of CLONE_INTO_CGROUP, not all cpusets are ready to accept
new tasks. It is too late to check that in cpuset_fork(). So we need
to add the cpuset_can_fork() and cpuset_cancel_fork() methods to
pre-check it before we can allow attachment to a different cpuset.

We also need to set the attach_in_progress flag to alert other code
that a new task is going to be added to the cpuset.

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 92 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 81 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e954d5abb784..a331e11e3d20 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2458,6 +2458,20 @@ static int fmeter_getrate(struct fmeter *fmp)
 
 static struct cpuset *cpuset_attach_old_cs;
 
+/*
+ * Check to see if a cpuset can accept a new task
+ * For v1, cpus_allowed and mems_allowed can't be empty.
+ * For v2, effective_cpus can't be empty.
+ * Note that in v1, effective_cpus = cpus_allowed.
+ */
+static int cpuset_can_attach_check(struct cpuset *cs)
+{
+	if (cpumask_empty(cs->effective_cpus) ||
+	   (!is_in_v2_mode() && nodes_empty(cs->mems_allowed)))
+		return -ENOSPC;
+	return 0;
+}
+
 /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
 static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
@@ -2472,16 +2486,9 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 
 	percpu_down_write(&cpuset_rwsem);
 
-	/* allow moving tasks into an empty cpuset if on default hierarchy */
-	ret = -ENOSPC;
-	if (!is_in_v2_mode() &&
-	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
-		goto out_unlock;
-
-	/*
-	 * Task cannot be moved to a cpuset with empty effective cpus.
-	 */
-	if (cpumask_empty(cs->effective_cpus))
+	/* Check to see if task is allowed in the cpuset */
+	ret = cpuset_can_attach_check(cs);
+	if (ret)
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, css, tset) {
@@ -2498,7 +2505,6 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 * changes which zero cpus/mems_allowed.
 	 */
 	cs->attach_in_progress++;
-	ret = 0;
 out_unlock:
 	percpu_up_write(&cpuset_rwsem);
 	return ret;
@@ -3269,6 +3275,63 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	percpu_up_write(&cpuset_rwsem);
 }
 
+/*
+ * In case the child is cloned into a cpuset different from its parent,
+ * additional checks are done to see if the move is allowed.
+ */
+static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
+{
+	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
+	bool same_cs;
+	int ret;
+
+	rcu_read_lock();
+	same_cs = (cs == task_cs(current));
+	rcu_read_unlock();
+
+	if (same_cs)
+		return 0;
+
+	lockdep_assert_held(&cgroup_mutex);
+	percpu_down_write(&cpuset_rwsem);
+
+	/* Check to see if task is allowed in the cpuset */
+	ret = cpuset_can_attach_check(cs);
+	if (ret)
+		goto out_unlock;
+
+	ret = task_can_attach(task, cs->effective_cpus);
+	if (ret)
+		goto out_unlock;
+
+	ret = security_task_setscheduler(task);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Mark attach is in progress.  This makes validate_change() fail
+	 * changes which zero cpus/mems_allowed.
+	 */
+	cs->attach_in_progress++;
+out_unlock:
+	percpu_up_write(&cpuset_rwsem);
+	return ret;
+}
+
+static void cpuset_cancel_fork(struct task_struct *task, struct css_set *cset)
+{
+	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
+
+	if (cs == task_cs(current))
+		return;
+
+	percpu_down_write(&cpuset_rwsem);
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
+	percpu_up_write(&cpuset_rwsem);
+}
+
 /*
  * Make sure the new task conform to the current state of its parent,
  * which could have been changed by cpuset just after it inherits the
@@ -3297,6 +3360,11 @@ static void cpuset_fork(struct task_struct *task)
 	percpu_down_write(&cpuset_rwsem);
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 	cpuset_attach_task(cs, task);
+
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
+
 	percpu_up_write(&cpuset_rwsem);
 }
 
@@ -3310,6 +3378,8 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.attach		= cpuset_attach,
 	.post_attach	= cpuset_post_attach,
 	.bind		= cpuset_bind,
+	.can_fork	= cpuset_can_fork,
+	.cancel_fork	= cpuset_cancel_fork,
 	.fork		= cpuset_fork,
 	.legacy_cftypes	= legacy_files,
 	.dfl_cftypes	= dfl_files,
-- 
2.31.1


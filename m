From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup/cpuset: Use cpuset_rwsem read lock in cpuset_can_attach()
Date: Thu,  8 Dec 2022 14:56:33 -0500
Message-ID: <20221208195634.2604362-2-longman@redhat.com>
References: <20221208195634.2604362-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670529421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o3RT2XE+xKZNyXg1+7HlKgY8RIpsHwoxTjw78hAkIis=;
        b=TObXH1gDs2BbRWgiSLwVD1SpEOZUYs9hKrmLNIz7kGiMBZSezZJqmseNr4y9aIhF7pnWq3
        SGohLqUbYQIFhdvUeD8xw6SX+WAN6a1thzlU5R5DHa/wkQJnlDiF5E+vdoR4xOtW6LhYsS
        vrMmNtyH4JQp4P4k/pqelU5EOf9Fxq0=
In-Reply-To: <20221208195634.2604362-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since commit 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to
percpu_rwsem"), cpuset_mutex is changed to cpuset_rwsem. This has the
undesirable side effect of increasing the latency to take cpuset_rwsem
write lock, potentially up to a RCU grace period later which can be
especially problematic on systems with a large number of CPU cores.

One particular pain point is moving a task from one cpuset to another
one. The locking sequence for such a task migration is as follow:

  cgroup_mutex => cgroup_threadgroup_rwsem => cpuset_rwsem

The cpuset_rwsem write lock has to be taken twice - at both
cpuset_can_attach() and cpuset_attach(). This can create significant
delay in blocking the fork/exit path while the task migration is in
progress.

Reduce that latency by using cpuset_rwsem read lock in
cpuset_can_attach() and cpuset_cancel_attach() as they don't need to
change anything in the cpuset except attach_in_progress which is now
changed to an atomic_t type to allow proper concurrent update while
holding cpuset_rwsem read lock. The attach_in_progress field is only read
while holding cpuset_rwsem write lock avoiding possible race condition.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b8..800c65de5daa 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -171,7 +171,7 @@ struct cpuset {
 	 * Tasks are being attached to this cpuset.  Used to prevent
 	 * zeroing cpus/mems_allowed between ->can_attach() and ->attach().
 	 */
-	int attach_in_progress;
+	atomic_t attach_in_progress;
 
 	/* partition number for rebuild_sched_domains() */
 	int pn;
@@ -369,11 +369,14 @@ static struct cpuset top_cpuset = {
  * There are two global locks guarding cpuset structures - cpuset_rwsem and
  * callback_lock. We also require taking task_lock() when dereferencing a
  * task's cpuset pointer. See "The task_lock() exception", at the end of this
- * comment.  The cpuset code uses only cpuset_rwsem write lock.  Other
- * kernel subsystems can use cpuset_read_lock()/cpuset_read_unlock() to
- * prevent change to cpuset structures.
- *
- * A task must hold both locks to modify cpusets.  If a task holds
+ * comment.  The cpuset code uses mostly cpuset_rwsem write lock with the
+ * exception of cpuset_can_attach() and cpuset_cancel_attach().  Other kernel
+ * subsystems can use cpuset_read_lock()/cpuset_read_unlock() to prevent
+ * change to cpuset structures.
+ *
+ * A task must hold both locks to modify cpusets except attach_in_progress
+ * which can be modified by either holding cpuset_rwsem read or write
+ * lock and to be read under cpuset_rwsem write lock.  If a task holds
  * cpuset_rwsem, it blocks others wanting that rwsem, ensuring that it
  * is the only task able to also acquire callback_lock and be able to
  * modify cpusets.  It can perform various checks on the cpuset structure
@@ -746,7 +749,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_is_populated(cur->css.cgroup) || cur->attach_in_progress)) {
+	if ((cgroup_is_populated(cur->css.cgroup) ||
+	     atomic_read(&cur->attach_in_progress))) {
 		if (!cpumask_empty(cur->cpus_allowed) &&
 		    cpumask_empty(trial->cpus_allowed))
 			goto out;
@@ -2448,7 +2452,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
 	cs = css_cs(css);
 
-	percpu_down_write(&cpuset_rwsem);
+	percpu_down_read(&cpuset_rwsem);
 
 	/* allow moving tasks into an empty cpuset if on default hierarchy */
 	ret = -ENOSPC;
@@ -2475,10 +2479,10 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 * Mark attach is in progress.  This makes validate_change() fail
 	 * changes which zero cpus/mems_allowed.
 	 */
-	cs->attach_in_progress++;
+	atomic_inc(&cs->attach_in_progress);
 	ret = 0;
 out_unlock:
-	percpu_up_write(&cpuset_rwsem);
+	percpu_up_read(&cpuset_rwsem);
 	return ret;
 }
 
@@ -2488,9 +2492,9 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 
 	cgroup_taskset_first(tset, &css);
 
-	percpu_down_write(&cpuset_rwsem);
-	css_cs(css)->attach_in_progress--;
-	percpu_up_write(&cpuset_rwsem);
+	percpu_down_read(&cpuset_rwsem);
+	atomic_dec(&css_cs(css)->attach_in_progress);
+	percpu_up_read(&cpuset_rwsem);
 }
 
 /*
@@ -2562,8 +2566,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
 
-	cs->attach_in_progress--;
-	if (!cs->attach_in_progress)
+	atomic_inc(&cs->attach_in_progress);
+	if (!atomic_read(&cs->attach_in_progress))
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
@@ -3072,6 +3076,7 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 	nodes_clear(cs->mems_allowed);
 	nodes_clear(cs->effective_mems);
 	fmeter_init(&cs->fmeter);
+	atomic_set(&cs->attach_in_progress, 0);
 	cs->relax_domain_level = -1;
 
 	/* Set CS_MEMORY_MIGRATE for default hierarchy */
@@ -3383,7 +3388,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	bool mems_updated;
 	struct cpuset *parent;
 retry:
-	wait_event(cpuset_attach_wq, cs->attach_in_progress == 0);
+	wait_event(cpuset_attach_wq, atomic_read(&cs->attach_in_progress) == 0);
 
 	percpu_down_write(&cpuset_rwsem);
 
@@ -3391,7 +3396,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	 * We have raced with task attaching. We wait until attaching
 	 * is finished, so we won't attach a task to an empty cpuset.
 	 */
-	if (cs->attach_in_progress) {
+	if (atomic_read(&cs->attach_in_progress)) {
 		percpu_up_write(&cpuset_rwsem);
 		goto retry;
 	}
-- 
2.31.1


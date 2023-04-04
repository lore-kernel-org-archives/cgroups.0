From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
Date: Tue,  4 Apr 2023 13:05:44 -0400
Message-ID: <20230404170546.2585050-3-longman@redhat.com>
References: <20230404170546.2585050-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680627986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4wgT1fYjYVeznO6I+FNrA2iUCmOb49EFy/x6QZ8ObU=;
        b=V6F6O4A8ODTLyKxsJJpJPjRlWA77Mj1pfexCkjuUkmX9lCdmddflxIMO2Kpu5pwJSDt0NK
        Pn9Ss+MnRcdcO8NFu85//xz6WIhKGQHMk0bOYAXe8wEiVZ0AQ5cXhQVS+6o7clZER8GwrR
        BaQSMy9VhM9qfH74jKFlOv5CdLfJe/M=
In-Reply-To: <20230404170546.2585050-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

By default, the clone(2) syscall spawn a child process into the same
cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
into cgroups"), the child will be spawned into a different cgroup which
is somewhat similar to writing the child's tid into "cgroup.threads".

The current cpuset_fork() method does not properly handle the
CLONE_INTO_CGROUP case where the cpuset of the child may be different
from that of its parent.  Update the cpuset_fork() method to treat the
CLONE_INTO_CGROUP case similar to cpuset_attach().

Since the newly cloned task has not been running yet, its actual
memory usage isn't known. So it is not necessary to make change to mm
in cpuset_fork().

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 56 +++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 066689a7dcc3..dc82f753373e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2520,16 +2520,33 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 }
 
 /*
- * Protected by cpuset_rwsem.  cpus_attach is used only by cpuset_attach()
+ * Protected by cpuset_rwsem. cpus_attach is used only by cpuset_attach_task()
  * but we can't allocate it dynamically there.  Define it global and
  * allocate from cpuset_init().
  */
 static cpumask_var_t cpus_attach;
+static nodemask_t cpuset_attach_nodemask_to;
+
+static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
+{
+	percpu_rwsem_assert_held(&cpuset_rwsem);
+
+	if (cs != &top_cpuset)
+		guarantee_online_cpus(task, cpus_attach);
+	else
+		cpumask_copy(cpus_attach, task_cpu_possible_mask(task));
+	/*
+	 * can_attach beforehand should guarantee that this doesn't
+	 * fail.  TODO: have a better way to handle failure here
+	 */
+	WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+
+	cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
+	cpuset_update_task_spread_flags(cs, task);
+}
 
 static void cpuset_attach(struct cgroup_taskset *tset)
 {
-	/* static buf protected by cpuset_rwsem */
-	static nodemask_t cpuset_attach_nodemask_to;
 	struct task_struct *task;
 	struct task_struct *leader;
 	struct cgroup_subsys_state *css;
@@ -2560,20 +2577,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
-	cgroup_taskset_for_each(task, css, tset) {
-		if (cs != &top_cpuset)
-			guarantee_online_cpus(task, cpus_attach);
-		else
-			cpumask_copy(cpus_attach, task_cpu_possible_mask(task));
-		/*
-		 * can_attach beforehand should guarantee that this doesn't
-		 * fail.  TODO: have a better way to handle failure here
-		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
-
-		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
-		cpuset_update_task_spread_flags(cs, task);
-	}
+	cgroup_taskset_for_each(task, css, tset)
+		cpuset_attach_task(cs, task);
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may
@@ -3271,11 +3276,22 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
  */
 static void cpuset_fork(struct task_struct *task)
 {
-	if (task_css_is_root(task, cpuset_cgrp_id))
+	struct cpuset *cs = task_cs(task);
+
+	if (cs == task_cs(current)) {
+		if (cs == &top_cpuset)
+			return;
+
+		set_cpus_allowed_ptr(task, current->cpus_ptr);
+		task->mems_allowed = current->mems_allowed;
 		return;
+	}
 
-	set_cpus_allowed_ptr(task, current->cpus_ptr);
-	task->mems_allowed = current->mems_allowed;
+	/* CLONE_INTO_CGROUP */
+	percpu_down_write(&cpuset_rwsem);
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	cpuset_attach_task(cs, task);
+	percpu_up_write(&cpuset_rwsem);
 }
 
 struct cgroup_subsys cpuset_cgrp_subsys = {
-- 
2.31.1


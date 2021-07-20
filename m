From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 7/9] cgroup/cpuset: Allow non-top parent partition root to distribute out all CPUs
Date: Tue, 20 Jul 2021 10:18:32 -0400
Message-ID: <20210720141834.10624-8-longman@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626790822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=HnHnB+rHkpfXclwaG6mW8kEj4fMYZUnHJrCjI3fhKPQ=;
        b=hZM88r2DXeF1qXdJL3sH2UjvNXo7dlvhQR2UApyUIvG8DQlddEMFFmdAdA1IUjBzurv5YD
        /kjq84vtfEhzYtenyNKqq5NM95PxDl1doQdrKvG6DmgwlXO20+GL3Scaxb7PKC/bnumuLt
        XktaEUe8h6s7+SGyi1UHJXmObsNCo+0=
In-Reply-To: <20210720141834.10624-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Currently, a parent partition root cannot distribute all its CPUs to
child partition roots with no CPUs left. However in some use cases,
a management application may want to create a parent partition root as
a management unit with no task associated with it and has all its CPUs
distributed to various child partition roots dynamically according to
their needs. Leaving a cpu in the parent partition root in such a case is
now a waste.

To accommodate such use cases, a parent partition root can now have
all its CPUs distributed to its child partition roots as long as:
 1) it is not the top cpuset; and
 2) there is no task directly associated with the parent.

Once an empty parent partition root is formed, no new task can be moved
into it.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 90 +++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 27 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 60562346ecc1..d4d0c091a0d3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -284,6 +284,11 @@ static inline void notify_partition_change(struct cpuset *cs,
 	cgroup_file_notify(&cs->partition_file);
 }
 
+static inline int cpuset_has_tasks(const struct cpuset *cs)
+{
+	return cs->css.cgroup->nr_populated_csets;
+}
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_ONLINE) | (1 << CS_CPU_EXCLUSIVE) |
 		  (1 << CS_MEM_EXCLUSIVE)),
@@ -1191,22 +1196,32 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	if ((cmd != partcmd_update) && css_has_online_children(&cpuset->css))
 		return -EBUSY;
 
-	/*
-	 * Enabling partition root is not allowed if not all the CPUs
-	 * can be granted from parent's effective_cpus or at least one
-	 * CPU will be left after that.
-	 */
-	if ((cmd == partcmd_enable) &&
-	   (!cpumask_subset(cpuset->cpus_allowed, parent->effective_cpus) ||
-	     cpumask_equal(cpuset->cpus_allowed, parent->effective_cpus)))
-		return -EINVAL;
-
 	/*
 	 * A cpumask update cannot make parent's effective_cpus become empty.
 	 */
 	adding = deleting = false;
 	old_prs = new_prs = cpuset->partition_root_state;
 	if (cmd == partcmd_enable) {
+		bool parent_is_top_cpuset = !parent_cs(parent);
+		bool no_cpu_in_parent = cpumask_equal(cpuset->cpus_allowed,
+						      parent->effective_cpus);
+		/*
+		 * Enabling partition root is not allowed if not all the CPUs
+		 * can be granted from parent's effective_cpus. If the parent
+		 * is the top cpuset, at least one CPU must be left after that.
+		 */
+		if (!cpumask_subset(cpuset->cpus_allowed, parent->effective_cpus) ||
+		    (parent_is_top_cpuset && no_cpu_in_parent))
+			return -EINVAL;
+
+		/*
+		 * A non-top parent can be left with no CPU as long as there
+		 * is no task directly associated with the parent. For such
+		 * a parent, no new task can be moved into it.
+		 */
+		if (no_cpu_in_parent && cpuset_has_tasks(parent))
+			return -EINVAL;
+
 		cpumask_copy(tmp->addmask, cpuset->cpus_allowed);
 		adding = true;
 	} else if (cmd == partcmd_disable) {
@@ -1237,9 +1252,10 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
 		/*
-		 * Return error if parent's effective_cpus could become empty.
+		 * Return error if parent's effective_cpus could become empty
+		 * and there are tasks in the parent.
 		 */
-		if (adding &&
+		if (adding && cpuset_has_tasks(parent) &&
 		    cpumask_equal(parent->effective_cpus, tmp->addmask)) {
 			if (!deleting)
 				return -EINVAL;
@@ -1255,12 +1271,13 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		}
 
 		/*
-		 * Return error if effective_cpus becomes empty or any CPU
-		 * distributed to child partitions is deleted.
+		 * Return error if effective_cpus becomes empty with tasks
+		 * or any CPU distributed to child partitions is deleted.
 		 */
 		if (deleting &&
 		   (cpumask_intersects(tmp->delmask, cpuset->subparts_cpus) ||
-		    cpumask_equal(tmp->delmask, cpuset->effective_cpus)))
+		   (cpumask_equal(tmp->delmask, cpuset->effective_cpus) &&
+		    cpuset_has_tasks(cpuset))))
 			return -EBUSY;
 	} else {
 		/*
@@ -1281,7 +1298,8 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 				     parent->effective_cpus);
 		part_error = (is_partition_root(cpuset) &&
 			      !parent->nr_subparts_cpus) ||
-			     cpumask_equal(tmp->addmask, parent->effective_cpus);
+			     (cpumask_equal(tmp->addmask, parent->effective_cpus) &&
+			      cpuset_has_tasks(parent));
 	}
 
 	if (cmd == partcmd_update) {
@@ -1388,9 +1406,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 
 		/*
 		 * If it becomes empty, inherit the effective mask of the
-		 * parent, which is guaranteed to have some CPUs.
+		 * parent, which is guaranteed to have some CPUs unless
+		 * it is a partition root that has explicitly distributed
+		 * out all its CPUs.
 		 */
 		if (is_in_v2_mode() && cpumask_empty(tmp->new_cpus)) {
+			if (is_partition_root(cp) &&
+			    cpumask_equal(cp->cpus_allowed, cp->subparts_cpus))
+				goto update_parent_subparts;
+
 			cpumask_copy(tmp->new_cpus, parent->effective_cpus);
 			if (!cp->use_parent_ecpus) {
 				cp->use_parent_ecpus = true;
@@ -1412,6 +1436,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 			continue;
 		}
 
+update_parent_subparts:
 		/*
 		 * update_parent_subparts_cpumask() should have been called
 		 * for cs already in update_cpumask(). We should also call
@@ -1482,7 +1507,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 			 */
 			cpumask_andnot(cp->effective_cpus, cp->effective_cpus,
 				       cp->subparts_cpus);
-			WARN_ON_ONCE(cpumask_empty(cp->effective_cpus));
+			WARN_ON_ONCE(cpumask_empty(cp->effective_cpus) &&
+				     cpuset_has_tasks(cp));
 		}
 
 		if (new_prs != old_prs)
@@ -1816,7 +1842,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
 
-		WARN_ON(!is_in_v2_mode() &&
+		WARN_ON_ONCE(!is_in_v2_mode() &&
 			!nodes_equal(cp->mems_allowed, cp->effective_mems));
 
 		update_tasks_nodemask(cp);
@@ -2231,6 +2257,13 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		goto out_unlock;
 
+	/*
+	 * On default hierarchy, task cannot be moved to a cpuset with empty
+	 * effective cpus.
+	 */
+	if (is_in_v2_mode() && cpumask_empty(cs->effective_cpus))
+		goto out_unlock;
+
 	cgroup_taskset_for_each(task, css, tset) {
 		ret = task_can_attach(task, cs->cpus_allowed);
 		if (ret)
@@ -3098,7 +3131,8 @@ hotplug_update_tasks(struct cpuset *cs,
 		     struct cpumask *new_cpus, nodemask_t *new_mems,
 		     bool cpus_updated, bool mems_updated)
 {
-	if (cpumask_empty(new_cpus))
+	/* A partition root is allowed to have empty effective cpus */
+	if (cpumask_empty(new_cpus) && !is_partition_root(cs))
 		cpumask_copy(new_cpus, parent_cs(cs)->effective_cpus);
 	if (nodes_empty(*new_mems))
 		*new_mems = parent_cs(cs)->effective_mems;
@@ -3167,22 +3201,24 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	/*
 	 * In the unlikely event that a partition root has empty
-	 * effective_cpus, we will have to force any child partitions,
-	 * if present, to become invalid by setting nr_subparts_cpus to 0
-	 * without causing itself to become invalid.
+	 * effective_cpus with tasks, we will have to force any child
+	 * partitions, if present, to become invalid by setting
+	 * nr_subparts_cpus to 0 without causing itself to become invalid.
 	 */
 	if (is_partition_root(cs) && cs->nr_subparts_cpus &&
-	    cpumask_empty(&new_cpus)) {
+	    cpumask_empty(&new_cpus) && cpuset_has_tasks(cs)) {
 		cs->nr_subparts_cpus = 0;
 		cpumask_clear(cs->subparts_cpus);
 		compute_effective_cpumask(&new_cpus, cs, parent);
 	}
 
 	/*
-	 * If empty effective_cpus or zero nr_subparts_cpus or its parent
-	 * becomes erroneous, we have to transition it to the erroneous state.
+	 * If empty effective_cpus with tasks or zero nr_subparts_cpus or
+	 * its parent becomes erroneous, we have to transition it to the
+	 * erroneous state.
 	 */
-	if (is_partition_root(cs) && (cpumask_empty(&new_cpus) ||
+	if (is_partition_root(cs) &&
+	   ((cpumask_empty(&new_cpus) && cpuset_has_tasks(cs)) ||
 	    (parent->partition_root_state == PRS_ERROR) ||
 	    !parent->nr_subparts_cpus)) {
 		int old_prs;
-- 
2.18.1


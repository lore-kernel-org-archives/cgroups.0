From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cgroup/cpuset: Allow non-top parent partition root to distribute out all CPUs
Date: Thu,  3 Jun 2021 17:24:14 -0400
Message-ID: <20210603212416.25934-4-longman@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622755501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=WUGY8sYtZzxYZSnhBIxuLuhJwQQu5J4ornFBXmTKadM=;
        b=Af/VFunv8bLg8P3LHrJXykFOPRhvACz2cpXYpnCb8Bbdb6UjXXYXR/EmhCnu13K9+vnX10
        AH683zInpi9ED/TNvgFB2inovknZvTrSNi9xMRQw0EbGqgZvYdImrLxfGQ/4z7WBltsnNW
        HE6yFS30M5QFKPcuqZHGbOrjGTDmHyI=
In-Reply-To: <20210603212416.25934-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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
 kernel/cgroup/cpuset.c | 44 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 78dd6c91dcd6..ef19eb317fef 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1117,7 +1117,7 @@ enum subparts_cmd {
  * cpus_allowed can be granted or an error code will be returned.
  *
  * For partcmd_disable, the cpuset is being transofrmed from a partition
- * root back to a non-partition root. any CPUs in cpus_allowed that are in
+ * root back to a non-partition root. Any CPUs in cpus_allowed that are in
  * parent's subparts_cpus will be taken away from that cpumask and put back
  * into parent's effective_cpus. 0 should always be returned.
  *
@@ -1172,21 +1172,31 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
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
+		if (no_cpu_in_parent && parent->css.cgroup->nr_populated_csets)
+			return -EINVAL;
+
 		cpumask_copy(tmp->addmask, cpuset->cpus_allowed);
 		adding = true;
 	} else if (cmd == partcmd_disable) {
@@ -1208,9 +1218,10 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
 		/*
-		 * Return error if the new effective_cpus could become empty.
+		 * Return error if the new effective_cpus could become empty
+		 * and there are tasks in the parent.
 		 */
-		if (adding &&
+		if (adding && parent->css.cgroup->nr_populated_csets &&
 		    cpumask_equal(parent->effective_cpus, tmp->addmask)) {
 			if (!deleting)
 				return -EINVAL;
@@ -2181,6 +2192,13 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
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
-- 
2.18.1


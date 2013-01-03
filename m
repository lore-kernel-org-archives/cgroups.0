From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] cpuset: remove cpuset->parent
Date: Thu,  3 Jan 2013 13:44:06 -0800
Message-ID: <1357249446-25075-4-git-send-email-tj@kernel.org>
References: <1357249446-25075-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
	:in-reply-to:references;
	bh=qQATlw9ViVS44LPZLuxOyqx6udVqoYLBwtz17QpixFA=;
	b=EiS3rPU8LygMh3OG10vGL+AaIjB3n65XsoNmqZ4wAAukjBVuZmZV9zVTHTXejrwCNL
	Xn3O9oGUREEGdysWLd2NrjVg3QO3FDu0p6sX9UlWn9j+xrLJwiIHv9ZQPIyCswxWTobX
	J2m69uYucX+TV+GpndqWe454a3A/Nrxw9lsx9jX57EUSZNxo24l4zhdY6M9dCaLmPuKV
	UN+KTBp8RPSrh6yLr8yXGwMdUzbtOCybp0VNbiI+nzEq5lBxIHgeJiB/9hCB0tay2yDx
	mviIH+Y0bWi6o2UOpA++JdfsFqDGdWl6FhhWuDMufr4HCHGxZG2H4DbsO0tkwpTuUpNd
	fzkA==
In-Reply-To: <1357249446-25075-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup already tracks the hierarchy.  Follow cgroup->parent to find
the parent and drop cpuset->parent.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 kernel/cpuset.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b2f8dad..afadbb99 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -87,8 +87,6 @@ struct cpuset {
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
-	struct cpuset *parent;		/* my parent */
-
 	struct fmeter fmeter;		/* memory_pressure filter */
 
 	/*
@@ -120,6 +118,15 @@ static inline struct cpuset *task_cs(struct task_struct *task)
 			    struct cpuset, css);
 }
 
+static inline struct cpuset *parent_cs(const struct cpuset *cs)
+{
+	struct cgroup *pcgrp = cs->css.cgroup->parent;
+
+	if (pcgrp)
+		return cgroup_cs(pcgrp);
+	return NULL;
+}
+
 #ifdef CONFIG_NUMA
 static inline bool task_has_mempolicy(struct task_struct *task)
 {
@@ -323,7 +330,7 @@ static void guarantee_online_cpus(const struct cpuset *cs,
 				  struct cpumask *pmask)
 {
 	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
-		cs = cs->parent;
+		cs = parent_cs(cs);
 	if (cs)
 		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 	else
@@ -348,7 +355,7 @@ static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 {
 	while (cs && !nodes_intersects(cs->mems_allowed,
 					node_states[N_MEMORY]))
-		cs = cs->parent;
+		cs = parent_cs(cs);
 	if (cs)
 		nodes_and(*pmask, cs->mems_allowed,
 					node_states[N_MEMORY]);
@@ -461,7 +468,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 	if (cur == &top_cpuset)
 		goto out;
 
-	par = cur->parent;
+	par = parent_cs(cur);
 
 	/* We must be a subset of our parent cpuset */
 	ret = -EACCES;
@@ -1866,7 +1873,6 @@ static struct cgroup_subsys_state *cpuset_css_alloc(struct cgroup *cont)
 	fmeter_init(&cs->fmeter);
 	INIT_WORK(&cs->hotplug_work, cpuset_propagate_hotplug_workfn);
 	cs->relax_domain_level = -1;
-	cs->parent = cgroup_cs(cont->parent);
 
 	return &cs->css;
 }
@@ -1874,7 +1880,7 @@ static struct cgroup_subsys_state *cpuset_css_alloc(struct cgroup *cont)
 static int cpuset_css_online(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
-	struct cpuset *parent = cs->parent;
+	struct cpuset *parent = parent_cs(cs);
 	struct cpuset *tmp_cs;
 	struct cgroup *pos_cg;
 
@@ -2058,10 +2064,10 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	 * Find its next-highest non-empty parent, (top cpuset
 	 * has online cpus, so can't be empty).
 	 */
-	parent = cs->parent;
+	parent = parent_cs(cs);
 	while (cpumask_empty(parent->cpus_allowed) ||
 			nodes_empty(parent->mems_allowed))
-		parent = parent->parent;
+		parent = parent_cs(parent);
 
 	move_member_tasks_to_cpuset(cs, parent);
 }
@@ -2373,8 +2379,8 @@ int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
  */
 static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
 {
-	while (!(is_mem_exclusive(cs) || is_mem_hardwall(cs)) && cs->parent)
-		cs = cs->parent;
+	while (!(is_mem_exclusive(cs) || is_mem_hardwall(cs)) && parent_cs(cs))
+		cs = parent_cs(cs);
 	return cs;
 }
 
-- 
1.8.0.2

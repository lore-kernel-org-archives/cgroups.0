From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: replace cgroup_on_dfl() tests in controllers with cgroup_subsys_on_dfl()
Date: Tue, 15 Sep 2015 21:51:25 -0400
Message-ID: <1442368285-16306-5-git-send-email-tj@kernel.org>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KIk00Gvc5dLhpgxrslY6SySbkdWXfm9b2bTLSEQnd48=;
        b=yaxeoiHy0HO9qeqw7RIz7/HIAsikcUmkoESyMzByPfC0M5ny5XTES9AFQkQebPgkIg
         nOHjT+3X2/p+dO595+toUZhMa+DvX2YcnX15PoolKLv3BYhzZjONQQB91WEl3DsNO9CA
         ABUA2CqRVKZlg950Pg3+77DbX0XYI2vGfq+3BIVmR6CNP6L60CcxwXAGukGbVC6UpPJe
         kHoGbwuYkJCyDx8MCSPlNZeeD2gvLPwYG8JL3bYu18IT4OKGi7uUcojKY/J/lPZ2RaXQ
         Ap0e5ti0d/r0En0uaWSUGQHF1DNEYxs4/9R27aMdhSWXOi0ABY6cBsuTPhOK8lzuUWud
         YPSA==
In-Reply-To: <1442368285-16306-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>, Michal Hocko <mhocko@kernel.org>

cgroup_on_dfl() tests whether the cgroup's root is the default
hierarchy; however, an individual controller is only interested in
whether the controller is attached to the default hierarchy and never
tests a cgroup which doesn't belong to the hierarchy that the
controller is attached to.

This patch replaces cgroup_on_dfl() tests in controllers with faster
static_key based cgroup_subsys_on_dfl().  This leaves cgroup core as
the only user of cgroup_on_dfl() and the function is moved from the
header file to cgroup.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
---
 block/blk-throttle.c   |  2 +-
 block/cfq-iosched.c    |  4 ++--
 include/linux/cgroup.h | 58 --------------------------------------------------
 kernel/cgroup.c        | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/cpuset.c        | 23 +++++++++++---------
 mm/memcontrol.c        |  4 ++--
 6 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c75a263..2149a1d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -369,7 +369,7 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
 	 * regardless of the position of the group in the hierarchy.
 	 */
 	sq->parent_sq = &td->service_queue;
-	if (cgroup_on_dfl(blkg->blkcg->css.cgroup) && blkg->parent)
+	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && blkg->parent)
 		sq->parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
 	tg->td = td;
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 04de884..1f9093e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1581,7 +1581,7 @@ static struct blkcg_policy_data *cfq_cpd_alloc(gfp_t gfp)
 static void cfq_cpd_init(struct blkcg_policy_data *cpd)
 {
 	struct cfq_group_data *cgd = cpd_to_cfqgd(cpd);
-	unsigned int weight = cgroup_on_dfl(blkcg_root.css.cgroup) ?
+	unsigned int weight = cgroup_subsys_on_dfl(io_cgrp_subsys) ?
 			      CGROUP_WEIGHT_DFL : CFQ_WEIGHT_LEGACY_DFL;
 
 	if (cpd_to_blkcg(cpd) == &blkcg_root)
@@ -1599,7 +1599,7 @@ static void cfq_cpd_free(struct blkcg_policy_data *cpd)
 static void cfq_cpd_bind(struct blkcg_policy_data *cpd)
 {
 	struct blkcg *blkcg = cpd_to_blkcg(cpd);
-	bool on_dfl = cgroup_on_dfl(blkcg_root.css.cgroup);
+	bool on_dfl = cgroup_subsys_on_dfl(io_cgrp_subsys);
 	unsigned int weight = on_dfl ? CGROUP_WEIGHT_DFL : CFQ_WEIGHT_LEGACY_DFL;
 
 	if (blkcg == &blkcg_root)
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c3a9f1e..355bf2e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -433,64 +433,6 @@ static inline struct cgroup *task_cgroup(struct task_struct *task,
 	return task_css(task, subsys_id)->cgroup;
 }
 
-/**
- * cgroup_on_dfl - test whether a cgroup is on the default hierarchy
- * @cgrp: the cgroup of interest
- *
- * The default hierarchy is the v2 interface of cgroup and this function
- * can be used to test whether a cgroup is on the default hierarchy for
- * cases where a subsystem should behave differnetly depending on the
- * interface version.
- *
- * The set of behaviors which change on the default hierarchy are still
- * being determined and the mount option is prefixed with __DEVEL__.
- *
- * List of changed behaviors:
- *
- * - Mount options "noprefix", "xattr", "clone_children", "release_agent"
- *   and "name" are disallowed.
- *
- * - When mounting an existing superblock, mount options should match.
- *
- * - Remount is disallowed.
- *
- * - rename(2) is disallowed.
- *
- * - "tasks" is removed.  Everything should be at process granularity.  Use
- *   "cgroup.procs" instead.
- *
- * - "cgroup.procs" is not sorted.  pids will be unique unless they got
- *   recycled inbetween reads.
- *
- * - "release_agent" and "notify_on_release" are removed.  Replacement
- *   notification mechanism will be implemented.
- *
- * - "cgroup.clone_children" is removed.
- *
- * - "cgroup.subtree_populated" is available.  Its value is 0 if the cgroup
- *   and its descendants contain no task; otherwise, 1.  The file also
- *   generates kernfs notification which can be monitored through poll and
- *   [di]notify when the value of the file changes.
- *
- * - cpuset: tasks will be kept in empty cpusets when hotplug happens and
- *   take masks of ancestors with non-empty cpus/mems, instead of being
- *   moved to an ancestor.
- *
- * - cpuset: a task can be moved into an empty cpuset, and again it takes
- *   masks of ancestors.
- *
- * - memcg: use_hierarchy is on by default and the cgroup file for the flag
- *   is not created.
- *
- * - blkcg: blk-throttle becomes properly hierarchical.
- *
- * - debug: disallowed on the default hierarchy.
- */
-static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
-{
-	return cgrp->root == &cgrp_dfl_root;
-}
-
 /* no synchronization, the result can only be used as a hint */
 static inline bool cgroup_has_tasks(struct cgroup *cgrp)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5703ba7..c24f929 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -237,6 +237,64 @@ static bool cgroup_ssid_enabled(int ssid)
 	return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
 }
 
+/**
+ * cgroup_on_dfl - test whether a cgroup is on the default hierarchy
+ * @cgrp: the cgroup of interest
+ *
+ * The default hierarchy is the v2 interface of cgroup and this function
+ * can be used to test whether a cgroup is on the default hierarchy for
+ * cases where a subsystem should behave differnetly depending on the
+ * interface version.
+ *
+ * The set of behaviors which change on the default hierarchy are still
+ * being determined and the mount option is prefixed with __DEVEL__.
+ *
+ * List of changed behaviors:
+ *
+ * - Mount options "noprefix", "xattr", "clone_children", "release_agent"
+ *   and "name" are disallowed.
+ *
+ * - When mounting an existing superblock, mount options should match.
+ *
+ * - Remount is disallowed.
+ *
+ * - rename(2) is disallowed.
+ *
+ * - "tasks" is removed.  Everything should be at process granularity.  Use
+ *   "cgroup.procs" instead.
+ *
+ * - "cgroup.procs" is not sorted.  pids will be unique unless they got
+ *   recycled inbetween reads.
+ *
+ * - "release_agent" and "notify_on_release" are removed.  Replacement
+ *   notification mechanism will be implemented.
+ *
+ * - "cgroup.clone_children" is removed.
+ *
+ * - "cgroup.subtree_populated" is available.  Its value is 0 if the cgroup
+ *   and its descendants contain no task; otherwise, 1.  The file also
+ *   generates kernfs notification which can be monitored through poll and
+ *   [di]notify when the value of the file changes.
+ *
+ * - cpuset: tasks will be kept in empty cpusets when hotplug happens and
+ *   take masks of ancestors with non-empty cpus/mems, instead of being
+ *   moved to an ancestor.
+ *
+ * - cpuset: a task can be moved into an empty cpuset, and again it takes
+ *   masks of ancestors.
+ *
+ * - memcg: use_hierarchy is on by default and the cgroup file for the flag
+ *   is not created.
+ *
+ * - blkcg: blk-throttle becomes properly hierarchical.
+ *
+ * - debug: disallowed on the default hierarchy.
+ */
+static bool cgroup_on_dfl(const struct cgroup *cgrp)
+{
+	return cgrp->root == &cgrp_dfl_root;
+}
+
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 			    gfp_t gfp_mask)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f0acff0..20eedd8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -473,7 +473,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	/* On legacy hiearchy, we must be a subset of our parent cpuset. */
 	ret = -EACCES;
-	if (!cgroup_on_dfl(cur->css.cgroup) && !is_cpuset_subset(trial, par))
+	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    !is_cpuset_subset(trial, par))
 		goto out;
 
 	/*
@@ -879,7 +880,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some CPUs.
 		 */
-		if (cgroup_on_dfl(cp->css.cgroup) && cpumask_empty(new_cpus))
+		if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+		    cpumask_empty(new_cpus))
 			cpumask_copy(new_cpus, parent->effective_cpus);
 
 		/* Skip the whole subtree if the cpumask remains the same. */
@@ -896,7 +898,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		cpumask_copy(cp->effective_cpus, new_cpus);
 		spin_unlock_irq(&callback_lock);
 
-		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
+		WARN_ON(!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
 		update_tasks_cpumask(cp);
@@ -1135,7 +1137,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (cgroup_on_dfl(cp->css.cgroup) && nodes_empty(*new_mems))
+		if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+		    nodes_empty(*new_mems))
 			*new_mems = parent->effective_mems;
 
 		/* Skip the whole subtree if the nodemask remains the same. */
@@ -1152,7 +1155,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
 
-		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
+		WARN_ON(!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
 			!nodes_equal(cp->mems_allowed, cp->effective_mems));
 
 		update_tasks_nodemask(cp);
@@ -1440,7 +1443,7 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 
 	/* allow moving tasks into an empty cpuset if on default hierarchy */
 	ret = -ENOSPC;
-	if (!cgroup_on_dfl(css->cgroup) &&
+	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
 	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		goto out_unlock;
 
@@ -1952,7 +1955,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	cpuset_inc();
 
 	spin_lock_irq(&callback_lock);
-	if (cgroup_on_dfl(cs->css.cgroup)) {
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 		cs->effective_mems = parent->effective_mems;
 	}
@@ -2029,7 +2032,7 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	mutex_lock(&cpuset_mutex);
 	spin_lock_irq(&callback_lock);
 
-	if (cgroup_on_dfl(root_css->cgroup)) {
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
 		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
 		top_cpuset.mems_allowed = node_possible_map;
 	} else {
@@ -2210,7 +2213,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs)
 	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
 	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
 
-	if (cgroup_on_dfl(cs->css.cgroup))
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
 		hotplug_update_tasks(cs, &new_cpus, &new_mems,
 				     cpus_updated, mems_updated);
 	else
@@ -2241,7 +2244,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
-	bool on_dfl = cgroup_on_dfl(top_cpuset.css.cgroup);
+	bool on_dfl = cgroup_subsys_on_dfl(cpuset_cgrp_subsys);
 
 	mutex_lock(&cpuset_mutex);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6ddaeba..b35c4cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -434,7 +434,7 @@ struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
 
 	memcg = page->mem_cgroup;
 
-	if (!memcg || !cgroup_on_dfl(memcg->css.cgroup))
+	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		memcg = root_mem_cgroup;
 
 	rcu_read_unlock();
@@ -5059,7 +5059,7 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
 	 * guarantees that @root doesn't have any children, so turning it
 	 * on for the root memcg is enough.
 	 */
-	if (cgroup_on_dfl(root_css->cgroup))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		root_mem_cgroup->use_hierarchy = true;
 	else
 		root_mem_cgroup->use_hierarchy = false;
-- 
2.4.3

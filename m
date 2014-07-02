From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] cgroup: remove sane_behavior support on non-default hierarchies
Date: Wed,  2 Jul 2014 19:45:46 -0400
Message-ID: <1404344747-7957-4-git-send-email-tj@kernel.org>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c7QBZdxCW9skTUehgOI9GXm8V8r3YmoAe6CjOKIUUXg=;
        b=AT3NCNSF0DSNVeJY4u0zgvJ+NIFGfQ9Xmd0lnpxA/kCvwgY5okRkpei7ONCGaxFfsM
         PNH8z75ZolPZ6L4rvx5rOkaJiD3MmgbWt9m+nhruxtgqzzxpQcMfl0dGfB/CzSTjAC/P
         5Aa2/s60Wu4GJ1ZhJkclD5Q7SoBcKof4B5fge4sMdI20S0zrOuV/tG1bgM5KQy9zy1V+
         FBP1iDm58WG9xwGTvGhz5T52jAZVtD8+ZMu8FUXRLtW9ysoYq1t5ycTTHdbtCW/gL7ry
         QV1cHrd3eZrcdZnxvZkj6i9TQSVnb0L+Q/zwLD6efS/ECZtqakMOhRFky0tgHyGg5Y64
         eldA==
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

sane_behavior has been used as a development vehicle for the default
unified hierarchy.  Now that the default hierarchy is in place, the
flag became redundant and confusing as its usage is allowed on all
hierarchies.  There are gonna be either the default hierarchy or
legacy ones.  Let's make that clear by removing sane_behavior support
on non-default hierarchies.

This patch replaces cgroup_sane_behavior() with cgroup_on_dfl().  The
comment on top of CGRP_ROOT_SANE_BEHAVIOR is moved to on top of
cgroup_on_dfl() with sane_behavior specific part dropped.

On the default and legacy hierarchies w/o sane_behavior, this
shouldn't cause any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 block/blk-throttle.c   |   6 +--
 include/linux/cgroup.h | 125 +++++++++++++++++++++----------------------------
 kernel/cgroup.c        |  19 ++++----
 kernel/cpuset.c        |  33 ++++++-------
 mm/memcontrol.c        |   7 +--
 5 files changed, 86 insertions(+), 104 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3fdb21a..9273d09 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -412,13 +412,13 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	int rw;
 
 	/*
-	 * If sane_hierarchy is enabled, we switch to properly hierarchical
+	 * If on the default hierarchy, we switch to properly hierarchical
 	 * behavior where limits on a given throtl_grp are applied to the
 	 * whole subtree rather than just the group itself.  e.g. If 16M
 	 * read_bps limit is set on the root group, the whole system can't
 	 * exceed 16M for the device.
 	 *
-	 * If sane_hierarchy is not enabled, the broken flat hierarchy
+	 * If not on the default hierarchy, the broken flat hierarchy
 	 * behavior is retained where all throtl_grps are treated as if
 	 * they're all separate root groups right below throtl_data.
 	 * Limits of a group don't interact with limits of other groups
@@ -426,7 +426,7 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	 */
 	parent_sq = &td->service_queue;
 
-	if (cgroup_sane_behavior(blkg->blkcg->css.cgroup) && blkg->parent)
+	if (cgroup_on_dfl(blkg->blkcg->css.cgroup) && blkg->parent)
 		parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
 
 	throtl_service_queue_init(&tg->service_queue, parent_sq);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7748e5b..46e4661 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -248,68 +248,7 @@ struct cgroup {
 
 /* cgroup_root->flags */
 enum {
-	/*
-	 * Unfortunately, cgroup core and various controllers are riddled
-	 * with idiosyncrasies and pointless options.  The following flag,
-	 * when set, will force sane behavior - some options are forced on,
-	 * others are disallowed, and some controllers will change their
-	 * hierarchical or other behaviors.
-	 *
-	 * The set of behaviors affected by this flag are still being
-	 * determined and developed and the mount option for this flag is
-	 * prefixed with __DEVEL__.  The prefix will be dropped once we
-	 * reach the point where all behaviors are compatible with the
-	 * planned unified hierarchy, which will automatically turn on this
-	 * flag.
-	 *
-	 * The followings are the behaviors currently affected this flag.
-	 *
-	 * - Mount options "noprefix", "xattr", "clone_children",
-	 *   "release_agent" and "name" are disallowed.
-	 *
-	 * - When mounting an existing superblock, mount options should
-	 *   match.
-	 *
-	 * - Remount is disallowed.
-	 *
-	 * - rename(2) is disallowed.
-	 *
-	 * - "tasks" is removed.  Everything should be at process
-	 *   granularity.  Use "cgroup.procs" instead.
-	 *
-	 * - "cgroup.procs" is not sorted.  pids will be unique unless they
-	 *   got recycled inbetween reads.
-	 *
-	 * - "release_agent" and "notify_on_release" are removed.
-	 *   Replacement notification mechanism will be implemented.
-	 *
-	 * - "cgroup.clone_children" is removed.
-	 *
-	 * - "cgroup.subtree_populated" is available.  Its value is 0 if
-	 *   the cgroup and its descendants contain no task; otherwise, 1.
-	 *   The file also generates kernfs notification which can be
-	 *   monitored through poll and [di]notify when the value of the
-	 *   file changes.
-	 *
-	 * - If mount is requested with sane_behavior but without any
-	 *   subsystem, the default unified hierarchy is mounted.
-	 *
-	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
-	 *   and take masks of ancestors with non-empty cpus/mems, instead of
-	 *   being moved to an ancestor.
-	 *
-	 * - cpuset: a task can be moved into an empty cpuset, and again it
-	 *   takes masks of ancestors.
-	 *
-	 * - memcg: use_hierarchy is on by default and the cgroup file for
-	 *   the flag is not created.
-	 *
-	 * - blkcg: blk-throttle becomes properly hierarchical.
-	 *
-	 * - debug: disallowed on the default hierarchy.
-	 */
-	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0),
-
+	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0), /* __DEVEL__sane_behavior specified */
 	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
 	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
 };
@@ -523,20 +462,64 @@ struct cftype {
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
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
 static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
 	return cgrp->root == &cgrp_dfl_root;
 }
 
-/*
- * See the comment above CGRP_ROOT_SANE_BEHAVIOR for details.  This
- * function can be called as long as @cgrp is accessible.
- */
-static inline bool cgroup_sane_behavior(const struct cgroup *cgrp)
-{
-	return cgrp->root->flags & CGRP_ROOT_SANE_BEHAVIOR;
-}
-
 /* no synchronization, the result can only be used as a hint */
 static inline bool cgroup_has_tasks(struct cgroup *cgrp)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index be701d9..2d7057e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1414,8 +1414,8 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	struct cgroup_sb_opts opts;
 	unsigned int added_mask, removed_mask;
 
-	if (root->flags & CGRP_ROOT_SANE_BEHAVIOR) {
-		pr_err("sane_behavior: remount is not allowed\n");
+	if (root == &cgrp_dfl_root) {
+		pr_err("remount is not allowed\n");
 		return -EINVAL;
 	}
 
@@ -2833,9 +2833,9 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 	/*
 	 * This isn't a proper migration and its usefulness is very
-	 * limited.  Disallow if sane_behavior.
+	 * limited.  Disallow on the default hierarchy.
 	 */
-	if (cgroup_sane_behavior(cgrp))
+	if (cgroup_on_dfl(cgrp))
 		return -EPERM;
 
 	/*
@@ -2921,7 +2921,7 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 		/* does cft->flags tell us to skip this file on @cgrp? */
 		if ((cft->flags & CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
 			continue;
-		if ((cft->flags & CFTYPE_INSANE) && cgroup_sane_behavior(cgrp))
+		if ((cft->flags & CFTYPE_INSANE) && cgroup_on_dfl(cgrp))
 			continue;
 		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgroup_parent(cgrp))
 			continue;
@@ -3654,8 +3654,9 @@ after:
  *
  * All this extra complexity was caused by the original implementation
  * committing to an entirely unnecessary property.  In the long term, we
- * want to do away with it.  Explicitly scramble sort order if
- * sane_behavior so that no such expectation exists in the new interface.
+ * want to do away with it.  Explicitly scramble sort order if on the
+ * default hierarchy so that no such expectation exists in the new
+ * interface.
  *
  * Scrambling is done by swapping every two consecutive bits, which is
  * non-identity one-to-one mapping which disturbs sort order sufficiently.
@@ -3670,7 +3671,7 @@ static pid_t pid_fry(pid_t pid)
 
 static pid_t cgroup_pid_fry(struct cgroup *cgrp, pid_t pid)
 {
-	if (cgroup_sane_behavior(cgrp))
+	if (cgroup_on_dfl(cgrp))
 		return pid_fry(pid);
 	else
 		return pid;
@@ -3773,7 +3774,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	css_task_iter_end(&it);
 	length = n;
 	/* now sort & (if procs) strip out duplicates */
-	if (cgroup_sane_behavior(cgrp))
+	if (cgroup_on_dfl(cgrp))
 		sort(array, length, sizeof(pid_t), fried_cmppid, NULL);
 	else
 		sort(array, length, sizeof(pid_t), cmppid, NULL);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f6b33c6..f9d4807 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1383,12 +1383,9 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 
 	mutex_lock(&cpuset_mutex);
 
-	/*
-	 * We allow to move tasks into an empty cpuset if sane_behavior
-	 * flag is set.
-	 */
+	/* allow moving tasks into an empty cpuset if on default hierarchy */
 	ret = -ENOSPC;
-	if (!cgroup_sane_behavior(css->cgroup) &&
+	if (!cgroup_on_dfl(css->cgroup) &&
 	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		goto out_unlock;
 
@@ -2030,7 +2027,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs)
 	static cpumask_t off_cpus;
 	static nodemask_t off_mems;
 	bool is_empty;
-	bool sane = cgroup_sane_behavior(cs->css.cgroup);
+	bool on_dfl = cgroup_on_dfl(cs->css.cgroup);
 
 retry:
 	wait_event(cpuset_attach_wq, cs->attach_in_progress == 0);
@@ -2054,12 +2051,12 @@ retry:
 	mutex_unlock(&callback_mutex);
 
 	/*
-	 * If sane_behavior flag is set, we need to update tasks' cpumask
-	 * for empty cpuset to take on ancestor's cpumask. Otherwise, don't
-	 * call update_tasks_cpumask() if the cpuset becomes empty, as
-	 * the tasks in it will be migrated to an ancestor.
+	 * If on_dfl, we need to update tasks' cpumask for empty cpuset to
+	 * take on ancestor's cpumask. Otherwise, don't call
+	 * update_tasks_cpumask() if the cpuset becomes empty, as the tasks
+	 * in it will be migrated to an ancestor.
 	 */
-	if ((sane && cpumask_empty(cs->cpus_allowed)) ||
+	if ((on_dfl && cpumask_empty(cs->cpus_allowed)) ||
 	    (!cpumask_empty(&off_cpus) && !cpumask_empty(cs->cpus_allowed)))
 		update_tasks_cpumask(cs);
 
@@ -2068,12 +2065,12 @@ retry:
 	mutex_unlock(&callback_mutex);
 
 	/*
-	 * If sane_behavior flag is set, we need to update tasks' nodemask
-	 * for empty cpuset to take on ancestor's nodemask. Otherwise, don't
-	 * call update_tasks_nodemask() if the cpuset becomes empty, as
-	 * the tasks in it will be migratd to an ancestor.
+	 * If on_dfl, we need to update tasks' nodemask for empty cpuset to
+	 * take on ancestor's nodemask. Otherwise, don't call
+	 * update_tasks_nodemask() if the cpuset becomes empty, as the
+	 * tasks in it will be migratd to an ancestor.
 	 */
-	if ((sane && nodes_empty(cs->mems_allowed)) ||
+	if ((on_dfl && nodes_empty(cs->mems_allowed)) ||
 	    (!nodes_empty(off_mems) && !nodes_empty(cs->mems_allowed)))
 		update_tasks_nodemask(cs);
 
@@ -2083,13 +2080,13 @@ retry:
 	mutex_unlock(&cpuset_mutex);
 
 	/*
-	 * If sane_behavior flag is set, we'll keep tasks in empty cpusets.
+	 * If on_dfl, we'll keep tasks in empty cpusets.
 	 *
 	 * Otherwise move tasks to the nearest ancestor with execution
 	 * resources.  This is full cgroup operation which will
 	 * also call back into cpuset.  Should be done outside any lock.
 	 */
-	if (!sane && is_empty)
+	if (!on_dfl && is_empty)
 		remove_tasks_in_empty_cpuset(cs);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb..f986671 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7001,16 +7001,17 @@ static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
 
 /*
  * Cgroup retains root cgroups across [un]mount cycles making it necessary
- * to verify sane_behavior flag on each mount attempt.
+ * to verify whether we're attached to the default hierarchy on each mount
+ * attempt.
  */
 static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
 {
 	/*
-	 * use_hierarchy is forced with sane_behavior.  cgroup core
+	 * use_hierarchy is forced on the default hierarchy.  cgroup core
 	 * guarantees that @root doesn't have any children, so turning it
 	 * on for the root memcg is enough.
 	 */
-	if (cgroup_sane_behavior(root_css->cgroup))
+	if (cgroup_on_dfl(root_css->cgroup))
 		mem_cgroup_from_css(root_css)->use_hierarchy = true;
 }
 
-- 
1.9.3

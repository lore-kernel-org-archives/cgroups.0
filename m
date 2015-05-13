From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] cgroup: separate out include/linux/cgroup-defs.h
Date: Wed, 13 May 2015 15:38:40 -0400
Message-ID: <20150513193840.GC11388@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=s++zj8NBzcia1S1t4Gm1CjNOWN5/xBCcYqroxHXuzes=;
        b=dMjjHFcSERh+XO+XGhgOpc6/Zdd4RBjV6tnXY4QmdHzpg8m9oroihpAT/PzgA/74j8
         bT3lgnTi9CwyZm1gBL4wkLbRUoOiJU1Dsg4fHuFDAB8p6w15PGrt04ehMOfUuNcRfOiI
         htuYxD30NoNEEuK6fFbJppX3YqvXabFVCvrxzTAIF4Is1VtsTYvArlAB8HzYeIvlQBZK
         N77jo8fFOrM5nB3JQFaHNffKKeDmekAqBY/taWROQAb05qVe2TKoQzlJlN/Rkopm1mmA
         mCibrEl21a0o75D9s7iqAA/yLCaBW9Wl7IQ9SY67RWRZBWLXqoIRrxTAY/7sqGr9OpIj
         6h1A==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From 2d728f74bfc071df06773e2fd7577dd5dab6425d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 13 May 2015 15:37:01 -0400

This patch separates out cgroup-defs.h from cgroup.h which has grown a
lot of dependencies.  cgroup-defs.h currently only contains constant
and type definitions and can be used to break circular include
dependency.  While moving, definitions are reordered so that
cgroup-defs.h has consistent logical structure.

This patch is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
cgroup-defs.h will be used by a following patchset.

Thanks.

 include/linux/cgroup-defs.h | 464 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cgroup.h      | 455 +------------------------------------------
 2 files changed, 466 insertions(+), 453 deletions(-)
 create mode 100644 include/linux/cgroup-defs.h

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
new file mode 100644
index 0000000..55f3120
--- /dev/null
+++ b/include/linux/cgroup-defs.h
@@ -0,0 +1,464 @@
+/*
+ * linux/cgroup-defs.h - basic definitions for cgroup
+ *
+ * This file provides basic type and interface.  Include this file directly
+ * only if necessary to avoid cyclic dependencies.
+ */
+#ifndef _LINUX_CGROUP_DEFS_H
+#define _LINUX_CGROUP_DEFS_H
+
+#include <linux/limits.h>
+#include <linux/list.h>
+#include <linux/idr.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/percpu-refcount.h>
+#include <linux/workqueue.h>
+
+#ifdef CONFIG_CGROUPS
+
+struct cgroup;
+struct cgroup_root;
+struct cgroup_subsys;
+struct cgroup_taskset;
+struct kernfs_node;
+struct kernfs_ops;
+struct kernfs_open_file;
+
+#define MAX_CGROUP_TYPE_NAMELEN 32
+#define MAX_CGROUP_ROOT_NAMELEN 64
+#define MAX_CFTYPE_NAME		64
+
+/* define the enumeration of all cgroup subsystems */
+#define SUBSYS(_x) _x ## _cgrp_id,
+enum cgroup_subsys_id {
+#include <linux/cgroup_subsys.h>
+	CGROUP_SUBSYS_COUNT,
+};
+#undef SUBSYS
+
+/* bits in struct cgroup_subsys_state flags field */
+enum {
+	CSS_NO_REF	= (1 << 0), /* no reference counting for this css */
+	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
+	CSS_RELEASED	= (1 << 2), /* refcnt reached zero, released */
+};
+
+/* bits in struct cgroup flags field */
+enum {
+	/* Control Group requires release notifications to userspace */
+	CGRP_NOTIFY_ON_RELEASE,
+	/*
+	 * Clone the parent's configuration when creating a new child
+	 * cpuset cgroup.  For historical reasons, this option can be
+	 * specified at mount time and thus is implemented here.
+	 */
+	CGRP_CPUSET_CLONE_CHILDREN,
+};
+
+/* cgroup_root->flags */
+enum {
+	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0), /* __DEVEL__sane_behavior specified */
+	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
+	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
+};
+
+/* cftype->flags */
+enum {
+	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
+	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
+	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
+
+	/* internal flags, do not use outside cgroup core proper */
+	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
+	__CFTYPE_NOT_ON_DFL	= (1 << 17),	/* not on default hierarchy */
+};
+
+/*
+ * Per-subsystem/per-cgroup state maintained by the system.  This is the
+ * fundamental structural building block that controllers deal with.
+ *
+ * Fields marked with "PI:" are public and immutable and may be accessed
+ * directly without synchronization.
+ */
+struct cgroup_subsys_state {
+	/* PI: the cgroup that this css is attached to */
+	struct cgroup *cgroup;
+
+	/* PI: the cgroup subsystem that this css is attached to */
+	struct cgroup_subsys *ss;
+
+	/* reference count - access via css_[try]get() and css_put() */
+	struct percpu_ref refcnt;
+
+	/* PI: the parent css */
+	struct cgroup_subsys_state *parent;
+
+	/* siblings list anchored at the parent's ->children */
+	struct list_head sibling;
+	struct list_head children;
+
+	/*
+	 * PI: Subsys-unique ID.  0 is unused and root is always 1.  The
+	 * matching css can be looked up using css_from_id().
+	 */
+	int id;
+
+	unsigned int flags;
+
+	/*
+	 * Monotonically increasing unique serial number which defines a
+	 * uniform order among all csses.  It's guaranteed that all
+	 * ->children lists are in the ascending order of ->serial_nr and
+	 * used to allow interrupting and resuming iterations.
+	 */
+	u64 serial_nr;
+
+	/* percpu_ref killing and RCU release */
+	struct rcu_head rcu_head;
+	struct work_struct destroy_work;
+};
+
+/*
+ * A css_set is a structure holding pointers to a set of
+ * cgroup_subsys_state objects. This saves space in the task struct
+ * object and speeds up fork()/exit(), since a single inc/dec and a
+ * list_add()/del() can bump the reference count on the entire cgroup
+ * set for a task.
+ */
+struct css_set {
+	/* Reference count */
+	atomic_t refcount;
+
+	/*
+	 * List running through all cgroup groups in the same hash
+	 * slot. Protected by css_set_lock
+	 */
+	struct hlist_node hlist;
+
+	/*
+	 * Lists running through all tasks using this cgroup group.
+	 * mg_tasks lists tasks which belong to this cset but are in the
+	 * process of being migrated out or in.  Protected by
+	 * css_set_rwsem, but, during migration, once tasks are moved to
+	 * mg_tasks, it can be read safely while holding cgroup_mutex.
+	 */
+	struct list_head tasks;
+	struct list_head mg_tasks;
+
+	/*
+	 * List of cgrp_cset_links pointing at cgroups referenced from this
+	 * css_set.  Protected by css_set_lock.
+	 */
+	struct list_head cgrp_links;
+
+	/* the default cgroup associated with this css_set */
+	struct cgroup *dfl_cgrp;
+
+	/*
+	 * Set of subsystem states, one for each subsystem. This array is
+	 * immutable after creation apart from the init_css_set during
+	 * subsystem registration (at boot time).
+	 */
+	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
+
+	/*
+	 * List of csets participating in the on-going migration either as
+	 * source or destination.  Protected by cgroup_mutex.
+	 */
+	struct list_head mg_preload_node;
+	struct list_head mg_node;
+
+	/*
+	 * If this cset is acting as the source of migration the following
+	 * two fields are set.  mg_src_cgrp is the source cgroup of the
+	 * on-going migration and mg_dst_cset is the destination cset the
+	 * target tasks on this cset should be migrated to.  Protected by
+	 * cgroup_mutex.
+	 */
+	struct cgroup *mg_src_cgrp;
+	struct css_set *mg_dst_cset;
+
+	/*
+	 * On the default hierarhcy, ->subsys[ssid] may point to a css
+	 * attached to an ancestor instead of the cgroup this css_set is
+	 * associated with.  The following node is anchored at
+	 * ->subsys[ssid]->cgroup->e_csets[ssid] and provides a way to
+	 * iterate through all css's attached to a given cgroup.
+	 */
+	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
+
+	/* For RCU-protected deletion */
+	struct rcu_head rcu_head;
+};
+
+struct cgroup {
+	/* self css with NULL ->ss, points back to this cgroup */
+	struct cgroup_subsys_state self;
+
+	unsigned long flags;		/* "unsigned long" so bitops work */
+
+	/*
+	 * idr allocated in-hierarchy ID.
+	 *
+	 * ID 0 is not used, the ID of the root cgroup is always 1, and a
+	 * new cgroup will be assigned with a smallest available ID.
+	 *
+	 * Allocating/Removing ID must be protected by cgroup_mutex.
+	 */
+	int id;
+
+	/*
+	 * If this cgroup contains any tasks, it contributes one to
+	 * populated_cnt.  All children with non-zero popuplated_cnt of
+	 * their own contribute one.  The count is zero iff there's no task
+	 * in this cgroup or its subtree.
+	 */
+	int populated_cnt;
+
+	struct kernfs_node *kn;		/* cgroup kernfs entry */
+	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
+
+	/*
+	 * The bitmask of subsystems enabled on the child cgroups.
+	 * ->subtree_control is the one configured through
+	 * "cgroup.subtree_control" while ->child_subsys_mask is the
+	 * effective one which may have more subsystems enabled.
+	 * Controller knobs are made available iff it's enabled in
+	 * ->subtree_control.
+	 */
+	unsigned int subtree_control;
+	unsigned int child_subsys_mask;
+
+	/* Private pointers for each registered subsystem */
+	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
+
+	struct cgroup_root *root;
+
+	/*
+	 * List of cgrp_cset_links pointing at css_sets with tasks in this
+	 * cgroup.  Protected by css_set_lock.
+	 */
+	struct list_head cset_links;
+
+	/*
+	 * On the default hierarchy, a css_set for a cgroup with some
+	 * susbsys disabled will point to css's which are associated with
+	 * the closest ancestor which has the subsys enabled.  The
+	 * following lists all css_sets which point to this cgroup's css
+	 * for the given subsystem.
+	 */
+	struct list_head e_csets[CGROUP_SUBSYS_COUNT];
+
+	/*
+	 * list of pidlists, up to two for each namespace (one for procs, one
+	 * for tasks); created on demand.
+	 */
+	struct list_head pidlists;
+	struct mutex pidlist_mutex;
+
+	/* used to wait for offlining of csses */
+	wait_queue_head_t offline_waitq;
+
+	/* used to schedule release agent */
+	struct work_struct release_agent_work;
+};
+
+/*
+ * A cgroup_root represents the root of a cgroup hierarchy, and may be
+ * associated with a kernfs_root to form an active hierarchy.  This is
+ * internal to cgroup core.  Don't access directly from controllers.
+ */
+struct cgroup_root {
+	struct kernfs_root *kf_root;
+
+	/* The bitmask of subsystems attached to this hierarchy */
+	unsigned int subsys_mask;
+
+	/* Unique id for this hierarchy. */
+	int hierarchy_id;
+
+	/* The root cgroup.  Root is destroyed on its release. */
+	struct cgroup cgrp;
+
+	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
+	atomic_t nr_cgrps;
+
+	/* A list running through the active hierarchies */
+	struct list_head root_list;
+
+	/* Hierarchy-specific flags */
+	unsigned int flags;
+
+	/* IDs for cgroups in this hierarchy */
+	struct idr cgroup_idr;
+
+	/* The path to use for release notifications. */
+	char release_agent_path[PATH_MAX];
+
+	/* The name for this hierarchy - may be empty */
+	char name[MAX_CGROUP_ROOT_NAMELEN];
+};
+
+/*
+ * struct cftype: handler definitions for cgroup control files
+ *
+ * When reading/writing to a file:
+ *	- the cgroup to use is file->f_path.dentry->d_parent->d_fsdata
+ *	- the 'cftype' of the file is file->f_path.dentry->d_fsdata
+ */
+struct cftype {
+	/*
+	 * By convention, the name should begin with the name of the
+	 * subsystem, followed by a period.  Zero length string indicates
+	 * end of cftype array.
+	 */
+	char name[MAX_CFTYPE_NAME];
+	int private;
+	/*
+	 * If not 0, file mode is set to this value, otherwise it will
+	 * be figured out automatically
+	 */
+	umode_t mode;
+
+	/*
+	 * The maximum length of string, excluding trailing nul, that can
+	 * be passed to write.  If < PAGE_SIZE-1, PAGE_SIZE-1 is assumed.
+	 */
+	size_t max_write_len;
+
+	/* CFTYPE_* flags */
+	unsigned int flags;
+
+	/*
+	 * Fields used for internal bookkeeping.  Initialized automatically
+	 * during registration.
+	 */
+	struct cgroup_subsys *ss;	/* NULL for cgroup core files */
+	struct list_head node;		/* anchored at ss->cfts */
+	struct kernfs_ops *kf_ops;
+
+	/*
+	 * read_u64() is a shortcut for the common case of returning a
+	 * single integer. Use it in place of read()
+	 */
+	u64 (*read_u64)(struct cgroup_subsys_state *css, struct cftype *cft);
+	/*
+	 * read_s64() is a signed version of read_u64()
+	 */
+	s64 (*read_s64)(struct cgroup_subsys_state *css, struct cftype *cft);
+
+	/* generic seq_file read interface */
+	int (*seq_show)(struct seq_file *sf, void *v);
+
+	/* optional ops, implement all or none */
+	void *(*seq_start)(struct seq_file *sf, loff_t *ppos);
+	void *(*seq_next)(struct seq_file *sf, void *v, loff_t *ppos);
+	void (*seq_stop)(struct seq_file *sf, void *v);
+
+	/*
+	 * write_u64() is a shortcut for the common case of accepting
+	 * a single integer (as parsed by simple_strtoull) from
+	 * userspace. Use in place of write(); return 0 or error.
+	 */
+	int (*write_u64)(struct cgroup_subsys_state *css, struct cftype *cft,
+			 u64 val);
+	/*
+	 * write_s64() is a signed version of write_u64()
+	 */
+	int (*write_s64)(struct cgroup_subsys_state *css, struct cftype *cft,
+			 s64 val);
+
+	/*
+	 * write() is the generic write callback which maps directly to
+	 * kernfs write operation and overrides all other operations.
+	 * Maximum write size is determined by ->max_write_len.  Use
+	 * of_css/cft() to access the associated css and cft.
+	 */
+	ssize_t (*write)(struct kernfs_open_file *of,
+			 char *buf, size_t nbytes, loff_t off);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key	lockdep_key;
+#endif
+};
+
+/*
+ * Control Group subsystem type.
+ * See Documentation/cgroups/cgroups.txt for details
+ */
+struct cgroup_subsys {
+	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
+	int (*css_online)(struct cgroup_subsys_state *css);
+	void (*css_offline)(struct cgroup_subsys_state *css);
+	void (*css_released)(struct cgroup_subsys_state *css);
+	void (*css_free)(struct cgroup_subsys_state *css);
+	void (*css_reset)(struct cgroup_subsys_state *css);
+	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
+
+	int (*can_attach)(struct cgroup_subsys_state *css,
+			  struct cgroup_taskset *tset);
+	void (*cancel_attach)(struct cgroup_subsys_state *css,
+			      struct cgroup_taskset *tset);
+	void (*attach)(struct cgroup_subsys_state *css,
+		       struct cgroup_taskset *tset);
+	void (*fork)(struct task_struct *task);
+	void (*exit)(struct cgroup_subsys_state *css,
+		     struct cgroup_subsys_state *old_css,
+		     struct task_struct *task);
+	void (*bind)(struct cgroup_subsys_state *root_css);
+
+	int disabled;
+	int early_init;
+
+	/*
+	 * If %false, this subsystem is properly hierarchical -
+	 * configuration, resource accounting and restriction on a parent
+	 * cgroup cover those of its children.  If %true, hierarchy support
+	 * is broken in some ways - some subsystems ignore hierarchy
+	 * completely while others are only implemented half-way.
+	 *
+	 * It's now disallowed to create nested cgroups if the subsystem is
+	 * broken and cgroup core will emit a warning message on such
+	 * cases.  Eventually, all subsystems will be made properly
+	 * hierarchical and this will go away.
+	 */
+	bool broken_hierarchy;
+	bool warned_broken_hierarchy;
+
+	/* the following two fields are initialized automtically during boot */
+	int id;
+	const char *name;
+
+	/* link to parent, protected by cgroup_lock() */
+	struct cgroup_root *root;
+
+	/* idr for css->id */
+	struct idr css_idr;
+
+	/*
+	 * List of cftypes.  Each entry is the first entry of an array
+	 * terminated by zero length name.
+	 */
+	struct list_head cfts;
+
+	/*
+	 * Base cftypes which are automatically registered.  The two can
+	 * point to the same array.
+	 */
+	struct cftype *dfl_cftypes;	/* for the default hierarchy */
+	struct cftype *legacy_cftypes;	/* for the legacy hierarchies */
+
+	/*
+	 * A subsystem may depend on other subsystems.  When such subsystem
+	 * is enabled on a cgroup, the depended-upon subsystems are enabled
+	 * together if available.  Subsystems enabled due to dependency are
+	 * not visible to userland until explicitly enabled.  The following
+	 * specifies the mask of subsystems that this one depends on.
+	 */
+	unsigned int depends_on;
+};
+
+#endif	/* CONFIG_CGROUPS */
+#endif	/* _LINUX_CGROUP_DEFS_H */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..96a2ecd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -11,23 +11,16 @@
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
-#include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/cgroupstats.h>
 #include <linux/rwsem.h>
-#include <linux/idr.h>
-#include <linux/workqueue.h>
 #include <linux/fs.h>
-#include <linux/percpu-refcount.h>
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
-#include <linux/wait.h>
 
-#ifdef CONFIG_CGROUPS
+#include <linux/cgroup-defs.h>
 
-struct cgroup_root;
-struct cgroup_subsys;
-struct cgroup;
+#ifdef CONFIG_CGROUPS
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
@@ -40,66 +33,6 @@ extern int cgroupstats_build(struct cgroupstats *stats,
 extern int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			    struct pid *pid, struct task_struct *tsk);
 
-/* define the enumeration of all cgroup subsystems */
-#define SUBSYS(_x) _x ## _cgrp_id,
-enum cgroup_subsys_id {
-#include <linux/cgroup_subsys.h>
-	CGROUP_SUBSYS_COUNT,
-};
-#undef SUBSYS
-
-/*
- * Per-subsystem/per-cgroup state maintained by the system.  This is the
- * fundamental structural building block that controllers deal with.
- *
- * Fields marked with "PI:" are public and immutable and may be accessed
- * directly without synchronization.
- */
-struct cgroup_subsys_state {
-	/* PI: the cgroup that this css is attached to */
-	struct cgroup *cgroup;
-
-	/* PI: the cgroup subsystem that this css is attached to */
-	struct cgroup_subsys *ss;
-
-	/* reference count - access via css_[try]get() and css_put() */
-	struct percpu_ref refcnt;
-
-	/* PI: the parent css */
-	struct cgroup_subsys_state *parent;
-
-	/* siblings list anchored at the parent's ->children */
-	struct list_head sibling;
-	struct list_head children;
-
-	/*
-	 * PI: Subsys-unique ID.  0 is unused and root is always 1.  The
-	 * matching css can be looked up using css_from_id().
-	 */
-	int id;
-
-	unsigned int flags;
-
-	/*
-	 * Monotonically increasing unique serial number which defines a
-	 * uniform order among all csses.  It's guaranteed that all
-	 * ->children lists are in the ascending order of ->serial_nr and
-	 * used to allow interrupting and resuming iterations.
-	 */
-	u64 serial_nr;
-
-	/* percpu_ref killing and RCU release */
-	struct rcu_head rcu_head;
-	struct work_struct destroy_work;
-};
-
-/* bits in struct cgroup_subsys_state flags field */
-enum {
-	CSS_NO_REF	= (1 << 0), /* no reference counting for this css */
-	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
-	CSS_RELEASED	= (1 << 2), /* refcnt reached zero, released */
-};
-
 /**
  * css_get - obtain a reference on the specified css
  * @css: target css
@@ -185,307 +118,6 @@ static inline void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
 		percpu_ref_put_many(&css->refcnt, n);
 }
 
-/* bits in struct cgroup flags field */
-enum {
-	/* Control Group requires release notifications to userspace */
-	CGRP_NOTIFY_ON_RELEASE,
-	/*
-	 * Clone the parent's configuration when creating a new child
-	 * cpuset cgroup.  For historical reasons, this option can be
-	 * specified at mount time and thus is implemented here.
-	 */
-	CGRP_CPUSET_CLONE_CHILDREN,
-};
-
-struct cgroup {
-	/* self css with NULL ->ss, points back to this cgroup */
-	struct cgroup_subsys_state self;
-
-	unsigned long flags;		/* "unsigned long" so bitops work */
-
-	/*
-	 * idr allocated in-hierarchy ID.
-	 *
-	 * ID 0 is not used, the ID of the root cgroup is always 1, and a
-	 * new cgroup will be assigned with a smallest available ID.
-	 *
-	 * Allocating/Removing ID must be protected by cgroup_mutex.
-	 */
-	int id;
-
-	/*
-	 * If this cgroup contains any tasks, it contributes one to
-	 * populated_cnt.  All children with non-zero popuplated_cnt of
-	 * their own contribute one.  The count is zero iff there's no task
-	 * in this cgroup or its subtree.
-	 */
-	int populated_cnt;
-
-	struct kernfs_node *kn;		/* cgroup kernfs entry */
-	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
-
-	/*
-	 * The bitmask of subsystems enabled on the child cgroups.
-	 * ->subtree_control is the one configured through
-	 * "cgroup.subtree_control" while ->child_subsys_mask is the
-	 * effective one which may have more subsystems enabled.
-	 * Controller knobs are made available iff it's enabled in
-	 * ->subtree_control.
-	 */
-	unsigned int subtree_control;
-	unsigned int child_subsys_mask;
-
-	/* Private pointers for each registered subsystem */
-	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
-
-	struct cgroup_root *root;
-
-	/*
-	 * List of cgrp_cset_links pointing at css_sets with tasks in this
-	 * cgroup.  Protected by css_set_lock.
-	 */
-	struct list_head cset_links;
-
-	/*
-	 * On the default hierarchy, a css_set for a cgroup with some
-	 * susbsys disabled will point to css's which are associated with
-	 * the closest ancestor which has the subsys enabled.  The
-	 * following lists all css_sets which point to this cgroup's css
-	 * for the given subsystem.
-	 */
-	struct list_head e_csets[CGROUP_SUBSYS_COUNT];
-
-	/*
-	 * list of pidlists, up to two for each namespace (one for procs, one
-	 * for tasks); created on demand.
-	 */
-	struct list_head pidlists;
-	struct mutex pidlist_mutex;
-
-	/* used to wait for offlining of csses */
-	wait_queue_head_t offline_waitq;
-
-	/* used to schedule release agent */
-	struct work_struct release_agent_work;
-};
-
-#define MAX_CGROUP_ROOT_NAMELEN 64
-
-/* cgroup_root->flags */
-enum {
-	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0), /* __DEVEL__sane_behavior specified */
-	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
-	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
-};
-
-/*
- * A cgroup_root represents the root of a cgroup hierarchy, and may be
- * associated with a kernfs_root to form an active hierarchy.  This is
- * internal to cgroup core.  Don't access directly from controllers.
- */
-struct cgroup_root {
-	struct kernfs_root *kf_root;
-
-	/* The bitmask of subsystems attached to this hierarchy */
-	unsigned int subsys_mask;
-
-	/* Unique id for this hierarchy. */
-	int hierarchy_id;
-
-	/* The root cgroup.  Root is destroyed on its release. */
-	struct cgroup cgrp;
-
-	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
-	atomic_t nr_cgrps;
-
-	/* A list running through the active hierarchies */
-	struct list_head root_list;
-
-	/* Hierarchy-specific flags */
-	unsigned int flags;
-
-	/* IDs for cgroups in this hierarchy */
-	struct idr cgroup_idr;
-
-	/* The path to use for release notifications. */
-	char release_agent_path[PATH_MAX];
-
-	/* The name for this hierarchy - may be empty */
-	char name[MAX_CGROUP_ROOT_NAMELEN];
-};
-
-/*
- * A css_set is a structure holding pointers to a set of
- * cgroup_subsys_state objects. This saves space in the task struct
- * object and speeds up fork()/exit(), since a single inc/dec and a
- * list_add()/del() can bump the reference count on the entire cgroup
- * set for a task.
- */
-
-struct css_set {
-
-	/* Reference count */
-	atomic_t refcount;
-
-	/*
-	 * List running through all cgroup groups in the same hash
-	 * slot. Protected by css_set_lock
-	 */
-	struct hlist_node hlist;
-
-	/*
-	 * Lists running through all tasks using this cgroup group.
-	 * mg_tasks lists tasks which belong to this cset but are in the
-	 * process of being migrated out or in.  Protected by
-	 * css_set_rwsem, but, during migration, once tasks are moved to
-	 * mg_tasks, it can be read safely while holding cgroup_mutex.
-	 */
-	struct list_head tasks;
-	struct list_head mg_tasks;
-
-	/*
-	 * List of cgrp_cset_links pointing at cgroups referenced from this
-	 * css_set.  Protected by css_set_lock.
-	 */
-	struct list_head cgrp_links;
-
-	/* the default cgroup associated with this css_set */
-	struct cgroup *dfl_cgrp;
-
-	/*
-	 * Set of subsystem states, one for each subsystem. This array is
-	 * immutable after creation apart from the init_css_set during
-	 * subsystem registration (at boot time).
-	 */
-	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
-
-	/*
-	 * List of csets participating in the on-going migration either as
-	 * source or destination.  Protected by cgroup_mutex.
-	 */
-	struct list_head mg_preload_node;
-	struct list_head mg_node;
-
-	/*
-	 * If this cset is acting as the source of migration the following
-	 * two fields are set.  mg_src_cgrp is the source cgroup of the
-	 * on-going migration and mg_dst_cset is the destination cset the
-	 * target tasks on this cset should be migrated to.  Protected by
-	 * cgroup_mutex.
-	 */
-	struct cgroup *mg_src_cgrp;
-	struct css_set *mg_dst_cset;
-
-	/*
-	 * On the default hierarhcy, ->subsys[ssid] may point to a css
-	 * attached to an ancestor instead of the cgroup this css_set is
-	 * associated with.  The following node is anchored at
-	 * ->subsys[ssid]->cgroup->e_csets[ssid] and provides a way to
-	 * iterate through all css's attached to a given cgroup.
-	 */
-	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
-
-	/* For RCU-protected deletion */
-	struct rcu_head rcu_head;
-};
-
-/*
- * struct cftype: handler definitions for cgroup control files
- *
- * When reading/writing to a file:
- *	- the cgroup to use is file->f_path.dentry->d_parent->d_fsdata
- *	- the 'cftype' of the file is file->f_path.dentry->d_fsdata
- */
-
-/* cftype->flags */
-enum {
-	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
-	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
-	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
-
-	/* internal flags, do not use outside cgroup core proper */
-	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
-	__CFTYPE_NOT_ON_DFL	= (1 << 17),	/* not on default hierarchy */
-};
-
-#define MAX_CFTYPE_NAME		64
-
-struct cftype {
-	/*
-	 * By convention, the name should begin with the name of the
-	 * subsystem, followed by a period.  Zero length string indicates
-	 * end of cftype array.
-	 */
-	char name[MAX_CFTYPE_NAME];
-	int private;
-	/*
-	 * If not 0, file mode is set to this value, otherwise it will
-	 * be figured out automatically
-	 */
-	umode_t mode;
-
-	/*
-	 * The maximum length of string, excluding trailing nul, that can
-	 * be passed to write.  If < PAGE_SIZE-1, PAGE_SIZE-1 is assumed.
-	 */
-	size_t max_write_len;
-
-	/* CFTYPE_* flags */
-	unsigned int flags;
-
-	/*
-	 * Fields used for internal bookkeeping.  Initialized automatically
-	 * during registration.
-	 */
-	struct cgroup_subsys *ss;	/* NULL for cgroup core files */
-	struct list_head node;		/* anchored at ss->cfts */
-	struct kernfs_ops *kf_ops;
-
-	/*
-	 * read_u64() is a shortcut for the common case of returning a
-	 * single integer. Use it in place of read()
-	 */
-	u64 (*read_u64)(struct cgroup_subsys_state *css, struct cftype *cft);
-	/*
-	 * read_s64() is a signed version of read_u64()
-	 */
-	s64 (*read_s64)(struct cgroup_subsys_state *css, struct cftype *cft);
-
-	/* generic seq_file read interface */
-	int (*seq_show)(struct seq_file *sf, void *v);
-
-	/* optional ops, implement all or none */
-	void *(*seq_start)(struct seq_file *sf, loff_t *ppos);
-	void *(*seq_next)(struct seq_file *sf, void *v, loff_t *ppos);
-	void (*seq_stop)(struct seq_file *sf, void *v);
-
-	/*
-	 * write_u64() is a shortcut for the common case of accepting
-	 * a single integer (as parsed by simple_strtoull) from
-	 * userspace. Use in place of write(); return 0 or error.
-	 */
-	int (*write_u64)(struct cgroup_subsys_state *css, struct cftype *cft,
-			 u64 val);
-	/*
-	 * write_s64() is a signed version of write_u64()
-	 */
-	int (*write_s64)(struct cgroup_subsys_state *css, struct cftype *cft,
-			 s64 val);
-
-	/*
-	 * write() is the generic write callback which maps directly to
-	 * kernfs write operation and overrides all other operations.
-	 * Maximum write size is determined by ->max_write_len.  Use
-	 * of_css/cft() to access the associated css and cft.
-	 */
-	ssize_t (*write)(struct kernfs_open_file *of,
-			 char *buf, size_t nbytes, loff_t off);
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lock_class_key	lockdep_key;
-#endif
-};
-
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
@@ -612,11 +244,6 @@ int cgroup_rm_cftypes(struct cftype *cfts);
 
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 
-/*
- * Control Group taskset, used to pass around set of tasks to cgroup_subsys
- * methods.
- */
-struct cgroup_taskset;
 struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset);
 struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
 
@@ -629,84 +256,6 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
 	for ((task) = cgroup_taskset_first((tset)); (task);		\
 	     (task) = cgroup_taskset_next((tset)))
 
-/*
- * Control Group subsystem type.
- * See Documentation/cgroups/cgroups.txt for details
- */
-
-struct cgroup_subsys {
-	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
-	int (*css_online)(struct cgroup_subsys_state *css);
-	void (*css_offline)(struct cgroup_subsys_state *css);
-	void (*css_released)(struct cgroup_subsys_state *css);
-	void (*css_free)(struct cgroup_subsys_state *css);
-	void (*css_reset)(struct cgroup_subsys_state *css);
-	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
-
-	int (*can_attach)(struct cgroup_subsys_state *css,
-			  struct cgroup_taskset *tset);
-	void (*cancel_attach)(struct cgroup_subsys_state *css,
-			      struct cgroup_taskset *tset);
-	void (*attach)(struct cgroup_subsys_state *css,
-		       struct cgroup_taskset *tset);
-	void (*fork)(struct task_struct *task);
-	void (*exit)(struct cgroup_subsys_state *css,
-		     struct cgroup_subsys_state *old_css,
-		     struct task_struct *task);
-	void (*bind)(struct cgroup_subsys_state *root_css);
-
-	int disabled;
-	int early_init;
-
-	/*
-	 * If %false, this subsystem is properly hierarchical -
-	 * configuration, resource accounting and restriction on a parent
-	 * cgroup cover those of its children.  If %true, hierarchy support
-	 * is broken in some ways - some subsystems ignore hierarchy
-	 * completely while others are only implemented half-way.
-	 *
-	 * It's now disallowed to create nested cgroups if the subsystem is
-	 * broken and cgroup core will emit a warning message on such
-	 * cases.  Eventually, all subsystems will be made properly
-	 * hierarchical and this will go away.
-	 */
-	bool broken_hierarchy;
-	bool warned_broken_hierarchy;
-
-	/* the following two fields are initialized automtically during boot */
-	int id;
-#define MAX_CGROUP_TYPE_NAMELEN 32
-	const char *name;
-
-	/* link to parent, protected by cgroup_lock() */
-	struct cgroup_root *root;
-
-	/* idr for css->id */
-	struct idr css_idr;
-
-	/*
-	 * List of cftypes.  Each entry is the first entry of an array
-	 * terminated by zero length name.
-	 */
-	struct list_head cfts;
-
-	/*
-	 * Base cftypes which are automatically registered.  The two can
-	 * point to the same array.
-	 */
-	struct cftype *dfl_cftypes;	/* for the default hierarchy */
-	struct cftype *legacy_cftypes;	/* for the legacy hierarchies */
-
-	/*
-	 * A subsystem may depend on other subsystems.  When such subsystem
-	 * is enabled on a cgroup, the depended-upon subsystems are enabled
-	 * together if available.  Subsystems enabled due to dependency are
-	 * not visible to userland until explicitly enabled.  The following
-	 * specifies the mask of subsystems that this one depends on.
-	 */
-	unsigned int depends_on;
-};
-
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _cgrp_subsys;
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
-- 
2.1.0

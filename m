From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v4 4/7] cgroup: cgroup v2 freezer
Date: Fri, 30 Nov 2018 15:47:42 -0800
Message-ID: <20181130234745.6756-5-guro@fb.com>
References: <20181130234745.6756-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XpnNaTBsNlK+/pTPIn6n7ZwsdRMZ8dv3FChryZCs3gU=;
        b=vZYx47AYCXQVZxjFfXxyM8QHnyvHJe1ePl46/exMe9OVeKlRQH/+AOJnMBDIL3/ehC
         6Jlait6n5ijOkI+D47ZXRrLn/+MGQte6y+jw9lqUJWNGpAXZndL2OM7qI6SWEfSTkmbF
         cpaV3OlxTN1dLKWHovt0wkO1HU3kSQR54weA4g9oE3THIHcFPQY5Nn7dVD+TVbS2JFcG
         vBmsH7+QtV1LjyeFx5rP3z/0RiOEIsJSDszFJ2f8U/xKd5yhnmm5rfd1c3MaXvc/izY2
         vlfucnHyjvdvEmQTXu+dXtknk6dHP/7hH2oYaKl2F0hugZ0vb3AMuke3aOYql2Jgegfz
         VwFA==
In-Reply-To: <20181130234745.6756-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

Cgroup v1 implements the freezer controller, which provides an ability
to stop the workload in a cgroup and temporarily free up some
resources (cpu, io, network bandwidth and, potentially, memory)
for some other tasks. Cgroup v2 lacks this functionality.

This patch implements freezer for cgroup v2.

Cgroup v2 freezer tries to put tasks into a state similar to jobctl
stop. This means that tasks can be killed, ptraced (using
PTRACE_SEIZE*), and interrupted. It is possible to attach to
a frozen task, get some information (e.g. read registers) and detach.
It's also possible to migrate a frozen tasks to another cgroup.

This differs cgroup v2 freezer from cgroup v1 freezer, which mostly
tried to imitate the system-wide freezer. However uninterruptible
sleep is fine when all tasks are going to be frozen (hibernation case),
it's not the acceptable state for some subset of the system.

Cgroup v2 freezer is not supporting freezing kthreads.
If a non-root cgroup contains kthread, the cgroup still can be frozen,
but the kthread will remain running, the cgroup will be shown
as non-frozen, and the notification will not be delivered.

* PTRACE_ATTACH is not working because non-fatal signal delivery
is blocked in frozen state.

There are some interface differences between cgroup v1 and cgroup v2
freezer too, which are required to conform the cgroup v2 interface
design principles:
1) There is no separate controller, which has to be turned on:
the functionality is always available and is represented by
cgroup.freeze and cgroup.events cgroup control files.
2) The desired state is defined by the cgroup.freeze control file.
Any hierarchical configuration is allowed.
3) The interface is asynchronous. The actual state is available
using cgroup.events control file ("frozen" field). There are no
dedicated transitional states.
4) It's allowed to make any changes with the cgroup hierarchy
(create new cgroups, remove old cgroups, move tasks between cgroups)
no matter if some cgroups are frozen.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com
---
 include/linux/cgroup-defs.h  |  28 +++
 include/linux/cgroup.h       |  42 +++++
 include/linux/sched.h        |   2 +
 include/linux/sched/jobctl.h |   2 +
 include/linux/sched/signal.h |   3 +
 kernel/cgroup/Makefile       |   2 +-
 kernel/cgroup/cgroup.c       | 112 +++++++++++-
 kernel/cgroup/freezer.c      | 318 +++++++++++++++++++++++++++++++++++
 kernel/ptrace.c              |   7 +
 kernel/signal.c              |  58 +++++--
 10 files changed, 556 insertions(+), 18 deletions(-)
 create mode 100644 kernel/cgroup/freezer.c

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 4327fd6e8121..23a99be114b8 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -64,6 +64,12 @@ enum {
 	 * specified at mount time and thus is implemented here.
 	 */
 	CGRP_CPUSET_CLONE_CHILDREN,
+
+	/* Control group has to be frozen. */
+	CGRP_FREEZE,
+
+	/* Cgroup is frozen. */
+	CGRP_FROZEN,
 };
 
 /* cgroup_root->flags */
@@ -316,6 +322,25 @@ struct cgroup_rstat_cpu {
 	struct cgroup *updated_next;		/* NULL iff not on the list */
 };
 
+struct cgroup_freezer_state {
+	/* Should the cgroup and its descendants be frozen. */
+	bool freeze;
+
+	/* Should the cgroup actually be frozen? */
+	int e_freeze;
+
+	/* Fields below are protected by css_set_lock */
+
+	/* Number of frozen descendant cgroups */
+	int nr_frozen_descendants;
+
+	/* Number of tasks to freeze */
+	int nr_tasks_to_freeze;
+
+	/* Number of frozen tasks */
+	int nr_frozen_tasks;
+};
+
 struct cgroup {
 	/* self css with NULL ->ss, points back to this cgroup */
 	struct cgroup_subsys_state self;
@@ -450,6 +475,9 @@ struct cgroup {
 	/* If there is block congestion on this cgroup. */
 	atomic_t congestion_count;
 
+	/* Used to store internal freezer state */
+	struct cgroup_freezer_state freezer;
+
 	/* ids of the ancestors at each level including self */
 	int ancestor_ids[];
 };
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9d12757a65b0..dc25b321ae1c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -877,4 +877,46 @@ static inline void put_cgroup_ns(struct cgroup_namespace *ns)
 		free_cgroup_ns(ns);
 }
 
+#ifdef CONFIG_CGROUPS
+
+void cgroup_enter_frozen(void);
+void cgroup_leave_frozen(void);
+void cgroup_freeze(struct cgroup *cgrp, bool freeze);
+void cgroup_update_frozen(struct cgroup *cgrp, bool frozen);
+void cgroup_freezer_migrate_task(struct task_struct *task, struct cgroup *src,
+				 struct cgroup *dst);
+static inline bool cgroup_task_freeze(struct task_struct *task)
+{
+	bool ret;
+
+	if (task->flags & PF_KTHREAD)
+		return false;
+
+	rcu_read_lock();
+	ret = test_bit(CGRP_FREEZE, &task_dfl_cgroup(task)->flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline bool cgroup_task_frozen(struct task_struct *task)
+{
+	return task->frozen;
+}
+
+#else /* !CONFIG_CGROUPS */
+
+static inline void cgroup_enter_frozen(void) { }
+static inline void cgroup_leave_frozen(void) { }
+static inline bool cgroup_task_freeze(struct task_struct *task)
+{
+	return false;
+}
+static inline bool cgroup_task_frozen(struct task_struct *task)
+{
+	return false;
+}
+
+#endif /* !CONFIG_CGROUPS */
+
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a51c13c2b1a0..6e82c88998f5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -731,6 +731,8 @@ struct task_struct {
 #ifdef CONFIG_CGROUPS
 	/* disallow userland-initiated cgroup migration */
 	unsigned			no_cgroup_migration:1;
+	/* task is frozen by the cgroup freezer */
+	unsigned			frozen:1;
 #endif
 #ifdef CONFIG_BLK_CGROUP
 	/* to be used once the psi infrastructure lands upstream. */
diff --git a/include/linux/sched/jobctl.h b/include/linux/sched/jobctl.h
index 98228bd48aee..fa067de9f1a9 100644
--- a/include/linux/sched/jobctl.h
+++ b/include/linux/sched/jobctl.h
@@ -18,6 +18,7 @@ struct task_struct;
 #define JOBCTL_TRAP_NOTIFY_BIT	20	/* trap for NOTIFY */
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
+#define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
 
 #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
@@ -26,6 +27,7 @@ struct task_struct;
 #define JOBCTL_TRAP_NOTIFY	(1UL << JOBCTL_TRAP_NOTIFY_BIT)
 #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
 #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
+#define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 13789d10a50e..c02dd6c782cc 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -8,6 +8,7 @@
 #include <linux/sched/jobctl.h>
 #include <linux/sched/task.h>
 #include <linux/cred.h>
+#include <linux/cgroup.h>
 
 /*
  * Types defining task->signal and task->sighand and APIs using them:
@@ -368,6 +369,8 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 		return 0;
 	if (!signal_pending(p))
 		return 0;
+	if (unlikely(cgroup_task_frozen(p)))
+		return __fatal_signal_pending(p);
 
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 8d5689ca94b9..5d7a76bfbbb7 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o
+obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o freezer.o
 
 obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f89dde50f693..42782285ddd3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2361,6 +2361,12 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 			get_css_set(to_cset);
 			to_cset->nr_tasks++;
 			css_set_move_task(task, from_cset, to_cset, true);
+			/*
+			 * If the source or destination cgroup is frozen,
+			 * the task might require to change its state.
+			 */
+			cgroup_freezer_migrate_task(task, from_cset->dfl_cgrp,
+						    to_cset->dfl_cgrp);
 			put_css_set_locked(from_cset);
 			from_cset->nr_tasks--;
 		}
@@ -3406,8 +3412,11 @@ static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
 
 static int cgroup_events_show(struct seq_file *seq, void *v)
 {
-	seq_printf(seq, "populated %d\n",
-		   cgroup_is_populated(seq_css(seq)->cgroup));
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+
+	seq_printf(seq, "populated %d\n", cgroup_is_populated(cgrp));
+	seq_printf(seq, "frozen %d\n", test_bit(CGRP_FROZEN, &cgrp->flags));
+
 	return 0;
 }
 
@@ -3469,6 +3478,40 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 }
 #endif
 
+static int cgroup_freeze_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+
+	seq_printf(seq, "%d\n", cgrp->freezer.freeze);
+
+	return 0;
+}
+
+static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
+				   char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *cgrp;
+	ssize_t ret;
+	int freeze;
+
+	ret = kstrtoint(strstrip(buf), 0, &freeze);
+	if (ret)
+		return ret;
+
+	if (freeze < 0 || freeze > 1)
+		return -ERANGE;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENOENT;
+
+	cgroup_freeze(cgrp, freeze);
+
+	cgroup_kn_unlock(of->kn);
+
+	return nbytes;
+}
+
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
@@ -4595,6 +4638,12 @@ static struct cftype cgroup_base_files[] = {
 		.name = "cgroup.stat",
 		.seq_show = cgroup_stat_show,
 	},
+	{
+		.name = "cgroup.freeze",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cgroup_freeze_show,
+		.write = cgroup_freeze_write,
+	},
 	{
 		.name = "cpu.stat",
 		.flags = CFTYPE_NOT_ON_ROOT,
@@ -4945,12 +4994,29 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	if (ret)
 		goto out_psi_free;
 
+	/*
+	 * New cgroup inherits effective freeze counter, and
+	 * if the parent has to be frozen, the child has too.
+	 */
+	cgrp->freezer.e_freeze = parent->freezer.e_freeze;
+	if (cgrp->freezer.e_freeze)
+		set_bit(CGRP_FROZEN, &cgrp->flags);
+
 	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		cgrp->ancestor_ids[tcgrp->level] = tcgrp->id;
 
-		if (tcgrp != cgrp)
+		if (tcgrp != cgrp) {
 			tcgrp->nr_descendants++;
+
+			/*
+			 * If the new cgroup is frozen, all ancestor cgroups
+			 * get a new frozen descendant, but their state can't
+			 * change because of this.
+			 */
+			if (cgrp->freezer.e_freeze)
+				tcgrp->freezer.nr_frozen_descendants++;
+		}
 	}
 	spin_unlock_irq(&css_set_lock);
 
@@ -5241,6 +5307,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		tcgrp->nr_descendants--;
 		tcgrp->nr_dying_descendants++;
+		/*
+		 * If the dying cgroup is frozen, decrease frozen descendants
+		 * counters of ancestor cgroups.
+		 */
+		if (test_bit(CGRP_FROZEN, &cgrp->flags))
+			tcgrp->freezer.nr_frozen_descendants--;
 	}
 	spin_unlock_irq(&css_set_lock);
 
@@ -5694,6 +5766,23 @@ void cgroup_post_fork(struct task_struct *child)
 			cset->nr_tasks++;
 			css_set_move_task(child, NULL, cset, false);
 		}
+
+		/*
+		 * If the cgroup has to be frozen, the new task has too.
+		 * Let's update cgroup freezer counter and set the
+		 * JOBCTL_TRAP_FREEZE jobctl bit to get the tack into
+		 * the frozen state.
+		 */
+		if (unlikely(cgroup_task_freeze(child))) {
+			struct cgroup *cgrp;
+
+			spin_lock(&child->sighand->siglock);
+			cgrp = cset->dfl_cgrp;
+			cgrp->freezer.nr_tasks_to_freeze++;
+			child->jobctl |= JOBCTL_TRAP_FREEZE;
+			spin_unlock(&child->sighand->siglock);
+		}
+
 		spin_unlock_irq(&css_set_lock);
 	}
 
@@ -5742,6 +5831,23 @@ void cgroup_exit(struct task_struct *tsk)
 		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
 		cset->nr_tasks--;
+
+		if (unlikely(test_bit(CGRP_FROZEN, &cset->dfl_cgrp->flags))) {
+			struct cgroup *frozen_cgrp = cset->dfl_cgrp;
+
+			/*
+			 * Task frozen bit should be cleared at this moment,
+			 * as well as nr_frozen_task should be decreased.
+			 * Let's update nr_tasks_to_freeze, and check if
+			 * the cgroup is actually frozen.
+			 */
+			WARN_ON_ONCE(tsk->frozen);
+			frozen_cgrp->freezer.nr_tasks_to_freeze--;
+			WARN_ON_ONCE(frozen_cgrp->freezer.nr_tasks_to_freeze <
+				     frozen_cgrp->freezer.nr_frozen_tasks);
+			cgroup_update_frozen(frozen_cgrp, true);
+		}
+
 		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
new file mode 100644
index 000000000000..d16cfc5bc1b7
--- /dev/null
+++ b/kernel/cgroup/freezer.c
@@ -0,0 +1,318 @@
+//SPDX-License-Identifier: GPL-2.0
+#include <linux/cgroup.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
+#include <linux/sched/signal.h>
+
+#include "cgroup-internal.h"
+
+/*
+ * Propagate the cgroup frozen state upwards by the cgroup tree.
+ */
+void cgroup_propagate_frozen(struct cgroup *cgrp, bool frozen)
+{
+	int desc = 1;
+
+	/*
+	 * If the new state is frozen, some freezing ancestor cgroups may change
+	 * their state too, depending on if all their descendants are frozen.
+	 *
+	 * Otherwise, all ancestor cgroups are forced into the non-frozen state.
+	 */
+	while ((cgrp = cgroup_parent(cgrp))) {
+		if (frozen) {
+			cgrp->freezer.nr_frozen_descendants += desc;
+			if (!test_bit(CGRP_FROZEN, &cgrp->flags) &&
+			    test_bit(CGRP_FREEZE, &cgrp->flags) &&
+			    cgrp->freezer.nr_frozen_descendants ==
+			    cgrp->nr_descendants) {
+				set_bit(CGRP_FROZEN, &cgrp->flags);
+				cgroup_file_notify(&cgrp->events_file);
+				desc++;
+			}
+		} else {
+			cgrp->freezer.nr_frozen_descendants -= desc;
+			if (test_bit(CGRP_FROZEN, &cgrp->flags)) {
+				clear_bit(CGRP_FROZEN, &cgrp->flags);
+				cgroup_file_notify(&cgrp->events_file);
+				desc++;
+			}
+		}
+	}
+}
+
+/*
+ * Revisit the cgroup frozen state.
+ * Checks if the cgroup is really frozen if necessary and performs
+ * all state transitions.
+ */
+void cgroup_update_frozen(struct cgroup *cgrp, bool frozen)
+{
+	lockdep_assert_held(&css_set_lock);
+
+	if (frozen) {
+		/*
+		 * If some tasks are still running, the cgroup
+		 * isn't ready for the state transitioning.
+		 */
+		if (cgrp->freezer.nr_frozen_tasks <
+		    cgrp->freezer.nr_tasks_to_freeze)
+			return;
+
+		/* Already there? */
+		if (test_bit(CGRP_FROZEN, &cgrp->flags))
+			return;
+
+		set_bit(CGRP_FROZEN, &cgrp->flags);
+	} else {
+		/* Already there? */
+		if (!test_bit(CGRP_FROZEN, &cgrp->flags))
+			return;
+
+		clear_bit(CGRP_FROZEN, &cgrp->flags);
+	}
+	cgroup_file_notify(&cgrp->events_file);
+
+	/* Update the state of ancestor cgroups. */
+	cgroup_propagate_frozen(cgrp, frozen);
+}
+
+/*
+ * Entry path into frozen state.
+ * If the task was not frozen before, counters are updated and the cgroup state
+ * is revisited. Otherwise, the task is put into the TASK_KILLABLE sleep.
+ */
+void cgroup_enter_frozen(void)
+{
+	if (!current->frozen) {
+		struct cgroup *cgrp;
+
+		spin_lock_irq(&css_set_lock);
+		current->frozen = true;
+		cgrp = task_dfl_cgroup(current);
+		cgrp->freezer.nr_frozen_tasks++;
+		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks >
+			     cgrp->freezer.nr_tasks_to_freeze);
+		cgroup_update_frozen(cgrp, true);
+		spin_unlock_irq(&css_set_lock);
+	}
+
+	__set_current_state(TASK_INTERRUPTIBLE);
+	schedule();
+	__set_current_state(TASK_RUNNING);
+}
+
+/*
+ * Exit path from the frozen state.
+ * Counters are updated, but the cgroup state is not revisited.
+ * If the frozen task is dying or migrating to a running cgroup, the original
+ * cgroup should remain frozen.
+ * Otherwise it already has been unfrozen by a user.
+ */
+void cgroup_leave_frozen(void)
+{
+	struct cgroup *cgrp;
+
+	spin_lock_irq(&css_set_lock);
+	cgrp = task_dfl_cgroup(current);
+	cgrp->freezer.nr_frozen_tasks--;
+	WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks < 0);
+	current->frozen = false;
+	spin_unlock_irq(&css_set_lock);
+}
+
+/*
+ * Freeze or unfreeze the task by setting or clearing the JOBCTL_TRAP_FREEZE
+ * jobctl bit.
+ */
+static void cgroup_freeze_task(struct task_struct *task, bool freeze)
+{
+	unsigned long flags;
+
+	/* If the task is about to die, don't bother with freezing it. */
+	if (!lock_task_sighand(task, &flags))
+		return;
+
+	if (freeze) {
+		task->jobctl |= JOBCTL_TRAP_FREEZE;
+		signal_wake_up(task, false);
+	} else {
+		task->jobctl &= ~JOBCTL_TRAP_FREEZE;
+		wake_up_process(task);
+	}
+
+	unlock_task_sighand(task, &flags);
+}
+
+/*
+ * Freeze or unfreeze all tasks in the given cgroup.
+ */
+static void cgroup_do_freeze(struct cgroup *cgrp, bool freeze)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	spin_lock_irq(&css_set_lock);
+	if (freeze) {
+		cgrp->freezer.nr_tasks_to_freeze = __cgroup_task_count(cgrp);
+		set_bit(CGRP_FREEZE, &cgrp->flags);
+	} else {
+		clear_bit(CGRP_FREEZE, &cgrp->flags);
+		/*
+		 * As soon as the CGRP_FREEZE bit has been cleared, the cgroup
+		 * can't be considered as frozen anymore (e.g. a task migrating
+		 * to it will remain/become running), so let's mark the cgroup
+		 * as non-frozen immediately.
+		 */
+		cgroup_update_frozen(cgrp, false);
+	}
+	spin_unlock_irq(&css_set_lock);
+
+	css_task_iter_start(&cgrp->self, 0, &it);
+	while ((task = css_task_iter_next(&it))) {
+		/*
+		 * Ignore kernel threads here. Freezing cgroups containing
+		 * kthreads isn't supported.
+		 */
+		if (task->flags & PF_KTHREAD)
+			continue;
+		cgroup_freeze_task(task, freeze);
+	}
+	css_task_iter_end(&it);
+
+	if (!freeze)
+		return;
+
+	spin_lock_irq(&css_set_lock);
+	/*
+	 * If all descendants are frozen (if there are any), let's check
+	 * if the cgroup can be considered frozen at this moment.
+	 * If a leaf cgroup is empty, it's the only moment when it can be
+	 * recognized and marked as frozen.
+	 */
+	if (cgrp->nr_descendants == cgrp->freezer.nr_frozen_descendants)
+		cgroup_update_frozen(cgrp, true);
+	spin_unlock_irq(&css_set_lock);
+}
+
+void cgroup_freezer_migrate_task(struct task_struct *task,
+				 struct cgroup *src, struct cgroup *dst)
+{
+	lockdep_assert_held(&css_set_lock);
+
+	/*
+	 * Kernel threads are not supposed to be frozen at all.
+	 */
+	if (task->flags & PF_KTHREAD)
+		return;
+
+	/*
+	 * Adjust counters of freezing and frozen tasks.
+	 */
+	if (test_bit(CGRP_FREEZE, &src->flags)) {
+		src->freezer.nr_tasks_to_freeze--;
+		WARN_ON_ONCE(src->freezer.nr_tasks_to_freeze < 0);
+	}
+
+	/*
+	 * If the task is frozen, let's bump nr_tasks_to_freeze even
+	 * if the target cgroup isn't frozen: the counter will be decreased
+	 * in cgroup_leave_frozen().
+	 */
+	if (test_bit(CGRP_FREEZE, &dst->flags) || task->frozen)
+		dst->freezer.nr_tasks_to_freeze++;
+
+	if (task->frozen) {
+		src->freezer.nr_frozen_tasks--;
+		dst->freezer.nr_frozen_tasks++;
+		WARN_ON_ONCE(src->freezer.nr_frozen_tasks < 0);
+		WARN_ON_ONCE(dst->freezer.nr_frozen_tasks >
+			     dst->freezer.nr_tasks_to_freeze);
+	}
+
+	/*
+	 * If the migrating task was the last non-frozen task in the source
+	 * cgroup, the cgroup should be considered frozen now.
+	 */
+	if (test_bit(CGRP_FREEZE, &src->flags) &&
+	    src->freezer.nr_frozen_tasks == src->freezer.nr_tasks_to_freeze)
+		cgroup_update_frozen(src, true);
+
+	/*
+	 * If the migrating task is not frozen, the destination cgroup can't
+	 * be considered frozen anymore.
+	 */
+	if (test_bit(CGRP_FROZEN, &src->flags) &&
+	    dst->freezer.nr_frozen_tasks < dst->freezer.nr_tasks_to_freeze)
+		cgroup_update_frozen(dst, false);
+
+	/*
+	 * If the task isn't in the desired state, force it to it.
+	 */
+	if (task->frozen != test_bit(CGRP_FREEZE, &dst->flags))
+		cgroup_freeze_task(task, test_bit(CGRP_FREEZE, &dst->flags));
+}
+
+void cgroup_freeze(struct cgroup *cgrp, bool freeze)
+{
+	struct cgroup_subsys_state *css;
+	struct cgroup *dsct;
+	bool applied = false;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	/*
+	 * Nothing changed? Just exit.
+	 */
+	if (cgrp->freezer.freeze == freeze)
+		return;
+
+	cgrp->freezer.freeze = freeze;
+
+	/*
+	 * Propagate changes downwards the cgroup tree.
+	 */
+	css_for_each_descendant_pre(css, &cgrp->self) {
+		dsct = css->cgroup;
+
+		if (cgroup_is_dead(dsct))
+			continue;
+
+		if (freeze) {
+			dsct->freezer.e_freeze++;
+			/*
+			 * Already frozen because of ancestor's settings?
+			 */
+			if (dsct->freezer.e_freeze > 1)
+				continue;
+		} else {
+			dsct->freezer.e_freeze--;
+			/*
+			 * Still frozen because of ancestor's settings?
+			 */
+			if (dsct->freezer.e_freeze > 0)
+				continue;
+
+			WARN_ON_ONCE(dsct->freezer.e_freeze < 0);
+		}
+
+		/*
+		 * Do change actual state: freeze or unfreeze.
+		 */
+		cgroup_do_freeze(dsct, freeze);
+		applied = true;
+	}
+
+	/*
+	 * Even if the actual state hasn't changed, let's notify a user.
+	 * The state can be enforced by an ancestor cgroup: the cgroup
+	 * can already be in the desired state or it can be locked in the
+	 * opposite state, so that the transition will never happen.
+	 * In both cases it's better to notify a user, that there is
+	 * nothing to wait.
+	 */
+	if (!applied)
+		cgroup_file_notify(&cgrp->events_file);
+}
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 80b34dffdfb9..5dfd2bd09fab 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -410,6 +410,13 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	spin_lock(&task->sighand->siglock);
 
+	/*
+	 * If the process is frozen, let's wake it up to give it a chance
+	 * to enter the ptrace trap.
+	 */
+	if (cgroup_task_frozen(task))
+		wake_up_process(task);
+
 	/*
 	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
diff --git a/kernel/signal.c b/kernel/signal.c
index 9a32bc2088c9..e41be317d417 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -41,6 +41,7 @@
 #include <linux/compiler.h>
 #include <linux/posix-timers.h>
 #include <linux/livepatch.h>
+#include <linux/cgroup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
@@ -172,7 +173,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
 void recalc_sigpending(void)
 {
 	if (!recalc_sigpending_tsk(current) && !freezing(current) &&
-	    !klp_patch_pending(current))
+	    !klp_patch_pending(current) && !cgroup_task_frozen(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
@@ -2256,7 +2257,7 @@ static bool do_signal_stop(int signr)
 }
 
 /**
- * do_jobctl_trap - take care of ptrace jobctl traps
+ * do_jobctl_trap - take care of ptrace and cgroup freezer jobctl traps
  *
  * When PT_SEIZED, it's used for both group stop and explicit
  * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap with
@@ -2266,26 +2267,44 @@ static bool do_signal_stop(int signr)
  * When !PT_SEIZED, it's used only for group stop trap with stop signal
  * number as exit_code and no siginfo.
  *
+ * When used with JOBCTL_TRAP_FREEZE, it puts the task into an interruptible
+ * sleep if only no fatal signals are pending.
+ *
  * CONTEXT:
  * Must be called with @current->sighand->siglock held, which may be
  * released and re-acquired before returning with intervening sleep.
  */
 static void do_jobctl_trap(void)
 {
+	struct sighand_struct *sighand = current->sighand;
 	struct signal_struct *signal = current->signal;
 	int signr = current->jobctl & JOBCTL_STOP_SIGMASK;
 
-	if (current->ptrace & PT_SEIZED) {
-		if (!signal->group_stop_count &&
-		    !(signal->flags & SIGNAL_STOP_STOPPED))
-			signr = SIGTRAP;
-		WARN_ON_ONCE(!signr);
-		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
-				 CLD_STOPPED);
-	} else {
-		WARN_ON_ONCE(!signr);
-		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
-		current->exit_code = 0;
+	if (current->jobctl & (JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)) {
+		if (current->ptrace & PT_SEIZED) {
+			if (!signal->group_stop_count &&
+			    !(signal->flags & SIGNAL_STOP_STOPPED))
+				signr = SIGTRAP;
+			WARN_ON_ONCE(!signr);
+			ptrace_do_notify(signr,
+					 signr | (PTRACE_EVENT_STOP << 8),
+					 CLD_STOPPED);
+		} else {
+			WARN_ON_ONCE(!signr);
+			ptrace_stop(signr, CLD_STOPPED, 0, NULL);
+			current->exit_code = 0;
+		}
+	} else if (current->jobctl & JOBCTL_TRAP_FREEZE) {
+		/*
+		 * Enter the frozen state, unless the task is about to exit.
+		 */
+		if (fatal_signal_pending(current)) {
+			current->jobctl &= ~JOBCTL_TRAP_FREEZE;
+		} else {
+			spin_unlock_irq(&sighand->siglock);
+			cgroup_enter_frozen();
+			spin_lock_irq(&sighand->siglock);
+		}
 	}
 }
 
@@ -2401,12 +2420,23 @@ bool get_signal(struct ksignal *ksig)
 		    do_signal_stop(0))
 			goto relock;
 
-		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
+		if (unlikely(current->jobctl &
+			     (JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE))) {
 			do_jobctl_trap();
 			spin_unlock_irq(&sighand->siglock);
 			goto relock;
 		}
 
+		/*
+		 * If the task is leaving the frozen state, let's update
+		 * cgroup counters and reset the frozen bit.
+		 */
+		if (unlikely(cgroup_task_frozen(current))) {
+			spin_unlock_irq(&sighand->siglock);
+			cgroup_leave_frozen();
+			spin_lock_irq(&sighand->siglock);
+		}
+
 		signr = dequeue_signal(current, &current->blocked, &ksig->info);
 
 		if (!signr)
-- 
2.17.2


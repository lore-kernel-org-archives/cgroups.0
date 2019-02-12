From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v7 4/7] cgroup: cgroup v2 freezer
Date: Tue, 12 Feb 2019 10:48:04 -0800
Message-ID: <20190212184807.20304-5-guro@fb.com>
References: <20190212184807.20304-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FMuZADqUzd/vhqvz2s8z9QHoH+AJNWZBnV3l2b2iFsw=;
        b=DC6IizKZmdcfKmIs1H7T2y4CNW1bkRDFQPc6TtuWLz3mZ9JSFcb1vM4Qfq4TW4OWyO
         u0fyhda94xW7O9GuIqKStP3r/virSslu8cDmps+49dJphJVoSsJJ4h44Q5582yfFZl2Y
         55/fM19Z1vuqIjC+qDrKRaQkeaTvFJKovSh+IDAEXQK2aFFL2MG4lRicqPuh/GLaGj2M
         bv8aEUa4oaM0SyTHUtd/1QwT2bXjUMv47tqkcV952GCqPk21wloAnJtrGygofuwbuBdb
         TvTI7GXtBlIKYqc+bjAyHclsGCcO0Xp90ZeWQ+CqPwurEVD/p5mBXVjCqfF1ct1rKgaU
         SAmA==
In-Reply-To: <20190212184807.20304-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

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
 include/linux/cgroup-defs.h  |  34 ++++
 include/linux/cgroup.h       |  46 +++++
 include/linux/sched.h        |   4 +
 include/linux/sched/jobctl.h |   2 +
 kernel/cgroup/Makefile       |   2 +-
 kernel/cgroup/cgroup.c       | 106 ++++++++++-
 kernel/cgroup/freezer.c      | 331 +++++++++++++++++++++++++++++++++++
 kernel/signal.c              |  93 +++++++++-
 8 files changed, 609 insertions(+), 9 deletions(-)
 create mode 100644 kernel/cgroup/freezer.c

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 319c07305500..dd6ea971f37c 100644
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
@@ -316,6 +322,31 @@ struct cgroup_rstat_cpu {
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
+
+	/*
+	 * Number of tasks, which are counted as frozen:
+	 * SIGSTOPped, and PTRACEd.
+	 */
+	int nr_stopped_tasks;
+};
+
 struct cgroup {
 	/* self css with NULL ->ss, points back to this cgroup */
 	struct cgroup_subsys_state self;
@@ -452,6 +483,9 @@ struct cgroup {
 	/* If there is block congestion on this cgroup. */
 	atomic_t congestion_count;
 
+	/* Used to store internal freezer state */
+	struct cgroup_freezer_state freezer;
+
 	/* ids of the ancestors at each level including self */
 	int ancestor_ids[];
 };
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 81f58b4a5418..b227ac104c58 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -881,4 +881,50 @@ static inline void put_cgroup_ns(struct cgroup_namespace *ns)
 		free_cgroup_ns(ns);
 }
 
+#ifdef CONFIG_CGROUPS
+
+void cgroup_enter_frozen(void);
+void cgroup_leave_frozen(void);
+void cgroup_enter_stopped(void);
+void cgroup_leave_stopped(void);
+void cgroup_dec_tasks_to_freeze(struct cgroup *cgrp);
+void cgroup_freeze(struct cgroup *cgrp, bool freeze);
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
+static inline void cgroup_enter_stopped(void) { }
+static inline void cgroup_leave_stopped(void) { }
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
index d2f90fa92468..c1b6b352573a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -733,6 +733,10 @@ struct task_struct {
 #ifdef CONFIG_CGROUPS
 	/* disallow userland-initiated cgroup migration */
 	unsigned			no_cgroup_migration:1;
+	/* task is frozen by the cgroup freezer */
+	unsigned			frozen:1;
+	/* task is stopped (used by cgroup freezer) */
+	unsigned			stopped:1;
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
index 7438c24297d4..0dd5c9dac365 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2391,6 +2391,12 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
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
@@ -3436,8 +3442,11 @@ static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
 
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
 
@@ -3499,6 +3508,40 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
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
@@ -4630,6 +4673,12 @@ static struct cftype cgroup_base_files[] = {
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
@@ -4980,12 +5029,29 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
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
 
@@ -5276,6 +5342,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
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
 
@@ -5729,6 +5801,23 @@ void cgroup_post_fork(struct task_struct *child)
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
 
@@ -5777,6 +5866,17 @@ void cgroup_exit(struct task_struct *tsk)
 		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
 		cset->nr_tasks--;
+
+		if (unlikely(cgroup_task_freeze(tsk))) {
+			/*
+			 * Task frozen bit should be cleared at this moment,
+			 * and nr_frozen_task should be decreased.
+			 * Let's update nr_tasks_to_freeze.
+			 */
+			WARN_ON_ONCE(tsk->frozen);
+			cgroup_dec_tasks_to_freeze(cset->dfl_cgrp);
+		}
+
 		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
new file mode 100644
index 000000000000..140fdb5c5913
--- /dev/null
+++ b/kernel/cgroup/freezer.c
@@ -0,0 +1,331 @@
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
+static void cgroup_propagate_frozen(struct cgroup *cgrp, bool frozen)
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
+ * Checks if the cgroup is really frozen and performs
+ * all state transitions.
+ */
+static void cgroup_update_frozen(struct cgroup *cgrp)
+{
+	bool frozen;
+
+	lockdep_assert_held(&css_set_lock);
+
+	/*
+	 * If the cgroup has to be frozen (CGRP_FREEZE bit set),
+	 * and all tasks are frozen and/or stopped, let's consider
+	 * the cgroup frozen. Otherwise it's not frozen.
+	 */
+	frozen = test_bit(CGRP_FREEZE, &cgrp->flags) &&
+		cgrp->freezer.nr_frozen_tasks +
+		cgrp->freezer.nr_stopped_tasks >=
+		cgrp->freezer.nr_tasks_to_freeze;
+
+	if (frozen) {
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
+ * Increment cgroup's nr_tasks_to_freeze, nr_frozen_tasks
+ * and nr_stopped_tasks counters. Revisit cgroup state if necessary.
+ */
+static void cgroup_inc_frozen_cnt(struct cgroup *cgrp, bool to_freeze,
+				  bool frozen, bool stopped)
+{
+	if (!to_freeze && !frozen && !stopped)
+		return;
+	if (to_freeze)
+		cgrp->freezer.nr_tasks_to_freeze++;
+	if (frozen) {
+		cgrp->freezer.nr_frozen_tasks++;
+		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks >
+			     cgrp->freezer.nr_tasks_to_freeze);
+	}
+	if (stopped)
+		cgrp->freezer.nr_stopped_tasks++;
+
+	cgroup_update_frozen(cgrp);
+}
+
+/*
+ * Decrement cgroup's nr_tasks_to_freeze, nr_frozen_tasks
+ * and nr_stopped_tasks counters. Revisit cgroup state if necessary.
+ */
+static void cgroup_dec_frozen_cnt(struct cgroup *cgrp, bool to_freeze,
+				  bool frozen, bool stopped)
+{
+	if (!to_freeze && !frozen && !stopped)
+		return;
+	if (frozen) {
+		cgrp->freezer.nr_frozen_tasks--;
+		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks < 0);
+	}
+	if (to_freeze) {
+		cgrp->freezer.nr_tasks_to_freeze--;
+		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze < 0);
+		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks >
+			     cgrp->freezer.nr_tasks_to_freeze);
+	}
+	if (stopped) {
+		cgrp->freezer.nr_stopped_tasks--;
+		WARN_ON_ONCE(cgrp->freezer.nr_stopped_tasks < 0);
+	}
+
+	cgroup_update_frozen(cgrp);
+}
+
+void cgroup_dec_tasks_to_freeze(struct cgroup *cgrp)
+{
+	cgroup_dec_frozen_cnt(cgrp, true, false, false);
+}
+
+/*
+ * Entry path into the frozen state.
+ * If the task was not frozen before, counters are updated and the cgroup state
+ * is revisited, if necessary.
+ */
+void cgroup_enter_frozen(void)
+{
+	spin_lock_irq(&css_set_lock);
+	current->frozen = true;
+	cgroup_inc_frozen_cnt(task_dfl_cgroup(current), false, true, false);
+	spin_unlock_irq(&css_set_lock);
+}
+
+/*
+ * Exit path from the frozen state.
+ * Counters are updated and the cgroup state is revisited, if necessary.
+ */
+void cgroup_leave_frozen(void)
+{
+	spin_lock_irq(&css_set_lock);
+	cgroup_dec_frozen_cnt(task_dfl_cgroup(current), false, true, false);
+	current->frozen = false;
+	spin_unlock_irq(&css_set_lock);
+}
+
+void cgroup_enter_stopped(void)
+{
+	spin_lock_irq(&css_set_lock);
+	current->stopped = true;
+	cgroup_inc_frozen_cnt(task_dfl_cgroup(current), false, false, true);
+	spin_unlock_irq(&css_set_lock);
+}
+
+void cgroup_leave_stopped(void)
+{
+	spin_lock_irq(&css_set_lock);
+	cgroup_dec_frozen_cnt(task_dfl_cgroup(current), false, false, true);
+	current->stopped = false;
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
+	/*
+	 * Cgroup state should be revisited here to cover empty leaf cgroups
+	 * and cgroups which descendants are already in the desired state.
+	 */
+	spin_lock_irq(&css_set_lock);
+	if (cgrp->nr_descendants == cgrp->freezer.nr_frozen_descendants)
+		cgroup_update_frozen(cgrp);
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
+	 * Note, that if the task is frozen, but the destination cgroup is not
+	 * frozen, we bump both counters to keep them balanced.
+	 */
+	cgroup_dec_frozen_cnt(src, test_bit(CGRP_FREEZE, &src->flags),
+			      task->frozen, task->stopped);
+	cgroup_inc_frozen_cnt(dst, test_bit(CGRP_FREEZE, &dst->flags) ||
+			      task->frozen, task->frozen, task->stopped);
+
+	/*
+	 * If the task isn't in the desired state, force it to the state.
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
diff --git a/kernel/signal.c b/kernel/signal.c
index e1d7ad8e6ab1..f303153ddd2e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -41,6 +41,7 @@
 #include <linux/compiler.h>
 #include <linux/posix-timers.h>
 #include <linux/livepatch.h>
+#include <linux/cgroup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
@@ -144,7 +145,7 @@ static inline bool has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 static bool recalc_sigpending_tsk(struct task_struct *t)
 {
-	if ((t->jobctl & JOBCTL_PENDING_MASK) ||
+	if ((t->jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE)) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -2065,7 +2066,9 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
 		preempt_disable();
 		read_unlock(&tasklist_lock);
 		preempt_enable_no_resched();
+		cgroup_enter_stopped();
 		freezable_schedule();
+		cgroup_leave_stopped();
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.
@@ -2243,7 +2246,9 @@ static bool do_signal_stop(int signr)
 		}
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
+		cgroup_enter_stopped();
 		freezable_schedule();
+		cgroup_leave_stopped();
 		return true;
 	} else {
 		/*
@@ -2266,6 +2271,9 @@ static bool do_signal_stop(int signr)
  * When !PT_SEIZED, it's used only for group stop trap with stop signal
  * number as exit_code and no siginfo.
  *
+ * When used with JOBCTL_TRAP_FREEZE, it puts the task into an interruptible
+ * sleep if only no fatal signals are pending.
+ *
  * CONTEXT:
  * Must be called with @current->sighand->siglock held, which may be
  * released and re-acquired before returning with intervening sleep.
@@ -2280,7 +2288,8 @@ static void do_jobctl_trap(void)
 		    !(signal->flags & SIGNAL_STOP_STOPPED))
 			signr = SIGTRAP;
 		WARN_ON_ONCE(!signr);
-		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
+		ptrace_do_notify(signr,
+				 signr | (PTRACE_EVENT_STOP << 8),
 				 CLD_STOPPED);
 	} else {
 		WARN_ON_ONCE(!signr);
@@ -2289,6 +2298,65 @@ static void do_jobctl_trap(void)
 	}
 }
 
+/**
+ * do_freezer_trap - handle the freezer jobctl trap
+ *
+ * Puts the task into frozen state, if only the task is not about to quit.
+ * In this case it drops JOBCTL_TRAP_FREEZE.
+ *
+ * CONTEXT:
+ * Must be called with @current->sighand->siglock held,
+ * which is always released before returning.
+ */
+static void do_freezer_trap(void)
+	__releases(&current->sighand->siglock)
+{
+	/*
+	 * If a fatal signal is pending, there is no way back for the process,
+	 * so let it escape from the freezer trap and exit.
+	 * If the task has been frozen, cgroup_leave_frozen() will be invoked
+	 * to update the cgroup state, if necessary.
+	 */
+	if (fatal_signal_pending(current)) {
+		current->jobctl &= ~JOBCTL_TRAP_FREEZE;
+		spin_unlock_irq(&current->sighand->siglock);
+		return;
+	}
+
+	/*
+	 * If task hasn't been marked frozen before, let's mark it as frozen,
+	 * and revisit the cgroup state. From this point the task is considered
+	 * frozen until it will reach cgroup_leave_frozen().
+	 */
+	if (!(cgroup_task_frozen(current))) {
+		spin_unlock_irq(&current->sighand->siglock);
+		cgroup_enter_frozen();
+		spin_lock_irq(&current->sighand->siglock);
+	}
+
+	/*
+	 * If there are other trap bits pending except JOBCTL_TRAP_FREEZE,
+	 * let's make another loop to give it a chance to be handled.
+	 * In any case, we'll return back.
+	 */
+	if (((current->jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE)) !=
+	     JOBCTL_TRAP_FREEZE) || fatal_signal_pending(current)) {
+		spin_unlock_irq(&current->sighand->siglock);
+		return;
+	}
+
+	/*
+	 * Now we're sure that there is no pending fatal signal and no
+	 * pending traps. Clear TIF_SIGPENDING to not get out of schedule()
+	 * immediately (if there is a non-fatal signal pending), and
+	 * put the task into sleep.
+	 */
+	__set_current_state(TASK_INTERRUPTIBLE);
+	clear_thread_flag(TIF_SIGPENDING);
+	spin_unlock_irq(&current->sighand->siglock);
+	freezable_schedule();
+}
+
 static int ptrace_signal(int signr, kernel_siginfo_t *info)
 {
 	/*
@@ -2401,12 +2469,27 @@ bool get_signal(struct ksignal *ksig)
 		    do_signal_stop(0))
 			goto relock;
 
-		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
-			do_jobctl_trap();
-			spin_unlock_irq(&sighand->siglock);
+		if (unlikely(current->jobctl &
+			     (JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE))) {
+			if (current->jobctl & JOBCTL_TRAP_MASK) {
+				do_jobctl_trap();
+				spin_unlock_irq(&sighand->siglock);
+			} else if (current->jobctl & JOBCTL_TRAP_FREEZE)
+				do_freezer_trap();
+
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
2.20.1


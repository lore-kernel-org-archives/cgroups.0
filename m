From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH 3/5] cgroup: cgroup v2 freezer
Date: Thu,  8 Nov 2018 15:15:58 -0500
Message-ID: <20181108201600.9129-4-guro@fb.com>
References: <20181108201600.9129-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+I3ALMt7zJJmybqZaz7L0tH/rMwRLH4QhV+Ygy+6N70=;
        b=ey1pIc2UCwrBVnHMQWjQ+px4bJE5/z7QuruCRxKRgvQSl0M9ycK5XN53uqFzHTNGdD
         j/OtKtJzbu2OKP6IjFKa8Tah6CrEkJtpgztWWeu1o8JIRD4QtsVBP2oWlbDBoxUQzCTI
         1GFS0bRTbg9IqD9ErusppMQf3R197eiEd714xn0rssoBuqTepyF3vmruui6lpMKpLUoq
         E/9XmEViBforzl6KAXuG3xQUf1OhV+6G0SxNN6enwW3eNlXKHjgjsp/+LwgpAQbik16D
         lC+a7O3pKX7YhDaTqHFQgHc57HJOniWIrafpzM9YBr6EA0pzO7Tt6X7s9zM6L2YB3n1w
         mr6w==
In-Reply-To: <20181108201600.9129-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>

Cgroup v1 implements the freezer controller, which provides an ability
to stop the workload in a cgroup and temporarily free up some
resources (cpu, io, network bandwidth and, potentially, memory)
for some other tasks. Cgroup v2 lacks this functionality.

This patch implements freezer for cgroup v2. However the functionality
is similar, the interface is different to cgroup v1: it follows
cgroup v2 interface principles.

Key differences are:
1) There is no separate controller: the functionality is always
available and is represented by cgroup.freeze and cgroup.events
cgroup control files.
2) The desired state is defined by the cgroup.freeze control file.
Any hierarchical configuration is allowed.
3) The interface is asynchronous. The actual state is available
using cgroup.events control file ("frozen" field). There are no
dedicated transitional states.
4) It's allowed to make any changes with the cgroup hierarchy
(create new cgroups, remove old cgroups, move tasks between cgroups)
no matter if some cgroups are frozen.
5) Tasks in a frozen cgroup can be killed.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
---
 include/linux/cgroup-defs.h  |  33 +++++
 include/linux/cgroup.h       |  42 ++++++
 include/linux/sched.h        |   5 +-
 include/linux/sched/jobctl.h |   5 +-
 kernel/cgroup/Makefile       |   2 +-
 kernel/cgroup/cgroup.c       |  99 +++++++++++++-
 kernel/cgroup/freezer.c      | 247 +++++++++++++++++++++++++++++++++++
 kernel/ptrace.c              |   6 +
 kernel/signal.c              |  51 ++++++--
 9 files changed, 472 insertions(+), 18 deletions(-)
 create mode 100644 kernel/cgroup/freezer.c

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 22254c1fe1c5..600165d0f5a2 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -63,6 +63,12 @@ enum {
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
@@ -314,6 +320,27 @@ struct cgroup_rstat_cpu {
 	struct cgroup *updated_next;		/* NULL iff not on the list */
 };
 
+struct cgroup_freezer_state {
+	/* Should the cgroup actually be frozen?
+	 * (protected by cgroup_mutex)
+	 */
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
+	/* Used for delayed notifications */
+	struct work_struct notify_work;
+};
+
 struct cgroup {
 	/* self css with NULL ->ss, points back to this cgroup */
 	struct cgroup_subsys_state self;
@@ -442,6 +469,12 @@ struct cgroup {
 	/* If there is block congestion on this cgroup. */
 	atomic_t congestion_count;
 
+	/* Should the cgroup and its descendants be frozen. */
+	bool freeze;
+
+	/* Used to store internal freezer state */
+	struct cgroup_freezer_state freezer;
+
 	/* ids of the ancestors at each level including self */
 	int ancestor_ids[];
 };
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 32c553556bbd..8f7e82b05bf8 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -871,4 +871,46 @@ static inline void put_cgroup_ns(struct cgroup_namespace *ns)
 		free_cgroup_ns(ns);
 }
 
+#ifdef CONFIG_CGROUPS
+
+static inline bool cgroup_frozen(struct task_struct *task)
+{
+	bool ret;
+
+	rcu_read_lock();
+	ret = test_bit(CGRP_FREEZE, &task_dfl_cgroup(task)->flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline bool cgroup_task_in_freezer(struct task_struct *task)
+{
+	return task->frozen;
+}
+
+void cgroup_freezer_enter(void);
+void cgroup_freezer_leave(void);
+void cgroup_freeze(struct cgroup *cgrp, bool freeze);
+void cgroup_notify_frozen_fn(struct work_struct *work);
+void cgroup_notify_frozen(struct cgroup *cgrp, bool frozen);
+void cgroup_queue_notify_frozen(struct cgroup *cgrp);
+void cgroup_freezer_migrate_task(struct task_struct *task, struct cgroup *src,
+				 struct cgroup *dst);
+
+#else /* !CONFIG_CGROUPS */
+
+static inline bool cgroup_task_in_freezer(struct task_struct *task)
+{
+	return false;
+}
+static inline void cgroup_freezer_enter(void) { }
+static inline void cgroup_freezer_leave(void) { }
+static inline bool cgroup_frozen(struct task_struct *task)
+{
+	return false;
+}
+
+#endif /* !CONFIG_CGROUPS */
+
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 977cb57d7bc9..8ef5d3174e50 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -83,7 +83,8 @@ struct task_group;
 #define TASK_WAKING			0x0200
 #define TASK_NOLOAD			0x0400
 #define TASK_NEW			0x0800
-#define TASK_STATE_MAX			0x1000
+#define TASK_FROZEN			0x1000
+#define TASK_STATE_MAX			0x2000
 
 /* Convenience macros for the sake of set_current_state: */
 #define TASK_KILLABLE			(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
@@ -733,6 +734,8 @@ struct task_struct {
 #ifdef CONFIG_CGROUPS
 	/* disallow userland-initiated cgroup migration */
 	unsigned			no_cgroup_migration:1;
+	/* task is in the cgroup freezer loop */
+	unsigned			frozen:1;
 #endif
 #ifdef CONFIG_BLK_CGROUP
 	/* to be used once the psi infrastructure lands upstream. */
diff --git a/include/linux/sched/jobctl.h b/include/linux/sched/jobctl.h
index 98228bd48aee..6c49455dcfe6 100644
--- a/include/linux/sched/jobctl.h
+++ b/include/linux/sched/jobctl.h
@@ -18,6 +18,7 @@ struct task_struct;
 #define JOBCTL_TRAP_NOTIFY_BIT	20	/* trap for NOTIFY */
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
+#define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
 
 #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
@@ -26,8 +27,10 @@ struct task_struct;
 #define JOBCTL_TRAP_NOTIFY	(1UL << JOBCTL_TRAP_NOTIFY_BIT)
 #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
 #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
+#define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
 
-#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
+#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY | \
+				 JOBCTL_TRAP_FREEZE)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask);
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
index ef3442555b32..4cffaae075af 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2358,6 +2358,10 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 			css_set_move_task(task, from_cset, to_cset, true);
 			put_css_set_locked(from_cset);
 			from_cset->nr_tasks--;
+
+			cgroup_freezer_migrate_task(task,
+						    from_cset->dfl_cgrp,
+						    to_cset->dfl_cgrp);
 		}
 	}
 	spin_unlock_irq(&css_set_lock);
@@ -3401,8 +3405,11 @@ static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
 
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
 
@@ -3449,6 +3456,40 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 	return ret;
 }
 
+static int cgroup_freeze_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+
+	seq_printf(seq, "%d\n", cgrp->freeze);
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
@@ -4574,6 +4615,12 @@ static struct cftype cgroup_base_files[] = {
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
@@ -4899,11 +4946,20 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	if (ret)
 		goto out_idr_free;
 
+	INIT_WORK(&cgrp->freezer.notify_work, cgroup_notify_frozen_fn);
+	cgrp->freezer.e_freeze = parent->freezer.e_freeze;
+	if (cgrp->freezer.e_freeze)
+		set_bit(CGRP_FROZEN, &cgrp->flags);
+
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		cgrp->ancestor_ids[tcgrp->level] = tcgrp->id;
 
-		if (tcgrp != cgrp)
+		if (tcgrp != cgrp) {
 			tcgrp->nr_descendants++;
+
+			if (cgrp->freezer.e_freeze)
+				tcgrp->freezer.nr_frozen_descendants++;
+		}
 	}
 
 	if (notify_on_release(parent))
@@ -5190,6 +5246,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		tcgrp->nr_descendants--;
 		tcgrp->nr_dying_descendants++;
+		if (cgrp->freezer.e_freeze)
+			tcgrp->freezer.nr_frozen_descendants--;
 	}
 
 	cgroup1_check_for_release(parent);
@@ -5642,6 +5700,23 @@ void cgroup_post_fork(struct task_struct *child)
 			cset->nr_tasks++;
 			css_set_move_task(child, NULL, cset, false);
 		}
+
+		if (unlikely(cgroup_frozen(child) &&
+			     (child->flags & ~PF_KTHREAD))) {
+			struct cgroup *cgrp;
+			unsigned long flags;
+
+			if (lock_task_sighand(child, &flags)) {
+				cgrp = cset->dfl_cgrp;
+				cgrp->freezer.nr_tasks_to_freeze++;
+				WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
+					     cgrp->freezer.nr_frozen_tasks);
+				child->jobctl |= JOBCTL_TRAP_FREEZE;
+				signal_wake_up(child, false);
+				unlock_task_sighand(child, &flags);
+			}
+		}
+
 		spin_unlock_irq(&css_set_lock);
 	}
 
@@ -5690,6 +5765,24 @@ void cgroup_exit(struct task_struct *tsk)
 		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
 		cset->nr_tasks--;
+
+		if (unlikely(cgroup_frozen(tsk) &&
+			     (tsk->flags & ~PF_KTHREAD))) {
+			struct cgroup *frozen_cgrp = cset->dfl_cgrp;
+
+			frozen_cgrp->freezer.nr_tasks_to_freeze--;
+
+			WARN_ON(tsk->frozen);
+			WARN_ON_ONCE(frozen_cgrp->freezer.nr_tasks_to_freeze <
+				     0);
+			WARN_ON_ONCE(frozen_cgrp->freezer.nr_tasks_to_freeze <
+				     frozen_cgrp->freezer.nr_frozen_tasks);
+
+			if (frozen_cgrp->freezer.nr_frozen_tasks ==
+			    frozen_cgrp->freezer.nr_tasks_to_freeze)
+				cgroup_queue_notify_frozen(frozen_cgrp);
+		}
+
 		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
new file mode 100644
index 000000000000..b81e215e2cce
--- /dev/null
+++ b/kernel/cgroup/freezer.c
@@ -0,0 +1,247 @@
+//SPDX-License-Identifier: GPL-2.0
+#include <linux/cgroup.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
+#include <linux/sched/signal.h>
+
+#include "cgroup-internal.h"
+
+void cgroup_notify_frozen(struct cgroup *cgrp, bool frozen)
+{
+	int delta = 1;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	/*
+	 * Did we race with fork() or exit()? Np, everything is still frozen.
+	 */
+	if (frozen == test_bit(CGRP_FROZEN, &cgrp->flags))
+		return;
+
+	if (frozen)
+		set_bit(CGRP_FROZEN, &cgrp->flags);
+	else
+		clear_bit(CGRP_FROZEN, &cgrp->flags);
+	cgroup_file_notify(&cgrp->events_file);
+
+	while ((cgrp = cgroup_parent(cgrp))) {
+		if (frozen) {
+			cgrp->freezer.nr_frozen_descendants += delta;
+			if (!test_bit(CGRP_FROZEN, &cgrp->flags) &&
+			    test_bit(CGRP_FREEZE, &cgrp->flags) &&
+			    cgrp->freezer.nr_frozen_descendants ==
+			    cgrp->nr_descendants) {
+				set_bit(CGRP_FROZEN, &cgrp->flags);
+				cgroup_file_notify(&cgrp->events_file);
+				delta++;
+			}
+		} else {
+			cgrp->freezer.nr_frozen_descendants -= delta;
+			if (test_bit(CGRP_FROZEN, &cgrp->flags)) {
+				clear_bit(CGRP_FROZEN, &cgrp->flags);
+				cgroup_file_notify(&cgrp->events_file);
+				delta++;
+			}
+		}
+	}
+}
+
+void cgroup_notify_frozen_fn(struct work_struct *work)
+{
+	struct cgroup *cgrp = container_of(work, struct cgroup,
+					   freezer.notify_work);
+
+	mutex_lock(&cgroup_mutex);
+	cgroup_notify_frozen(cgrp, true);
+	mutex_unlock(&cgroup_mutex);
+
+	css_put(&cgrp->self);
+}
+
+void cgroup_queue_notify_frozen(struct cgroup *cgrp)
+{
+	if (work_pending(&cgrp->freezer.notify_work))
+		return;
+
+	css_get(&cgrp->self);
+	schedule_work(&cgrp->freezer.notify_work);
+}
+
+void cgroup_freezer_enter(void)
+{
+	long state = current->state;
+	struct cgroup *cgrp;
+
+	if (!current->frozen) {
+		spin_lock_irq(&css_set_lock);
+		current->frozen = true;
+		cgrp = task_dfl_cgroup(current);
+		cgrp->freezer.nr_frozen_tasks++;
+
+		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
+			     cgrp->freezer.nr_frozen_tasks);
+
+		if (cgrp->freezer.nr_tasks_to_freeze ==
+		    cgrp->freezer.nr_frozen_tasks)
+			cgroup_queue_notify_frozen(cgrp);
+		spin_unlock_irq(&css_set_lock);
+	}
+
+	/* refrigerator */
+	set_current_state(TASK_WAKEKILL | TASK_INTERRUPTIBLE | TASK_FROZEN);
+	clear_thread_flag(TIF_SIGPENDING);
+	schedule();
+	recalc_sigpending();
+
+	set_current_state(state);
+}
+
+void cgroup_freezer_leave(void)
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
+static void cgroup_do_freeze(struct cgroup *cgrp, bool freeze)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+	unsigned long flags;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	spin_lock_irq(&css_set_lock);
+	if (freeze) {
+		cgrp->freezer.nr_tasks_to_freeze = __cgroup_task_count(cgrp);
+		set_bit(CGRP_FREEZE, &cgrp->flags);
+	} else {
+		clear_bit(CGRP_FREEZE, &cgrp->flags);
+		cgroup_notify_frozen(cgrp, false);
+	}
+	spin_unlock_irq(&css_set_lock);
+
+	css_task_iter_start(&cgrp->self, 0, &it);
+	while ((task = css_task_iter_next(&it))) {
+		if (task->flags & PF_KTHREAD)
+			continue;
+
+		if (!lock_task_sighand(task, &flags))
+			continue;
+
+		if (freeze) {
+			task->jobctl |= JOBCTL_TRAP_FREEZE;
+			signal_wake_up(task, false);
+		} else {
+			task->jobctl &= ~JOBCTL_TRAP_FREEZE;
+			wake_up_process(task);
+		}
+
+		unlock_task_sighand(task, &flags);
+	}
+	css_task_iter_end(&it);
+
+	if (freeze && cgrp->nr_descendants ==
+	    cgrp->freezer.nr_frozen_descendants) {
+		spin_lock_irq(&css_set_lock);
+		WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
+			     cgrp->freezer.nr_frozen_tasks);
+		if (cgrp->freezer.nr_tasks_to_freeze ==
+		    cgrp->freezer.nr_frozen_tasks)
+			cgroup_notify_frozen(cgrp, true);
+		spin_unlock_irq(&css_set_lock);
+	}
+}
+
+void cgroup_freezer_migrate_task(struct task_struct *task,
+				 struct cgroup *src, struct cgroup *dst)
+{
+	unsigned long flags;
+
+	lockdep_assert_held(&css_set_lock);
+
+	if (task->flags & PF_KTHREAD)
+		return;
+
+	if (test_bit(CGRP_FREEZE, &src->flags) || task->frozen)
+		src->freezer.nr_tasks_to_freeze--;
+	if (test_bit(CGRP_FREEZE, &dst->flags) || task->frozen)
+		dst->freezer.nr_tasks_to_freeze++;
+
+	if (task->frozen) {
+		src->freezer.nr_frozen_tasks--;
+		dst->freezer.nr_frozen_tasks++;
+	}
+
+	if (test_bit(CGRP_FREEZE, &src->flags) ==
+	    test_bit(CGRP_FREEZE, &dst->flags))
+		return;
+
+	if (lock_task_sighand(task, &flags)) {
+		if (test_bit(CGRP_FREEZE, &dst->flags))
+			task->jobctl |= JOBCTL_TRAP_FREEZE;
+		else
+			task->jobctl &= ~JOBCTL_TRAP_FREEZE;
+		signal_wake_up(task, false);
+		unlock_task_sighand(task, &flags);
+	}
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
+	if (cgrp->freeze == freeze)
+		return;
+
+	cgrp->freeze = freeze;
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
+	if (!applied)
+		cgroup_file_notify(&cgrp->events_file);
+}
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 21fec73d45d4..5e484e2480e5 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -400,6 +400,12 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	spin_lock(&task->sighand->siglock);
 
+	/*
+	 * Kick the process to get it out of the refrigerator.
+	 */
+	if (cgroup_frozen(task))
+		wake_up_process(task);
+
 	/*
 	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
diff --git a/kernel/signal.c b/kernel/signal.c
index 5843c541fda9..41fee9a38201 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -326,6 +326,11 @@ void task_clear_jobctl_pending(struct task_struct *task, unsigned long mask)
 	if (mask & JOBCTL_STOP_PENDING)
 		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
 
+	/*
+	 * JOBCTL_TRAP_FREEZE is set and cleared from cgroup side,
+	 * don't touch it here.
+	 */
+	mask &= ~JOBCTL_TRAP_FREEZE;
 	task->jobctl &= ~mask;
 
 	if (!(task->jobctl & JOBCTL_PENDING_MASK))
@@ -2252,7 +2257,7 @@ static bool do_signal_stop(int signr)
 }
 
 /**
- * do_jobctl_trap - take care of ptrace jobctl traps
+ * do_jobctl_trap - take care of ptrace and cgroup freezer jobctl traps
  *
  * When PT_SEIZED, it's used for both group stop and explicit
  * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap with
@@ -2268,20 +2273,35 @@ static bool do_signal_stop(int signr)
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
+		 * Enter the freezer, unless the task is about to exit.
+		 */
+		if (fatal_signal_pending(current)) {
+			current->jobctl &= ~JOBCTL_TRAP_FREEZE;
+		} else {
+			spin_unlock_irq(&sighand->siglock);
+			cgroup_freezer_enter();
+			spin_lock_irq(&sighand->siglock);
+		}
 	}
 }
 
@@ -2403,6 +2423,13 @@ bool get_signal(struct ksignal *ksig)
 			goto relock;
 		}
 
+		/*
+		 * If the task is leaving the freezer look, let's notify
+		 * the cgroup and reset the frozen mark.
+		 */
+		if (unlikely(cgroup_task_in_freezer(current)))
+			cgroup_freezer_leave();
+
 		signr = dequeue_signal(current, &current->blocked, &ksig->info);
 
 		if (!signr)
-- 
2.17.2


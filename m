From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v3 2/2] cgroups: add a pids subsystem
Date: Thu,  5 Mar 2015 07:23:19 +1100
Message-ID: <1425500599-21676-3-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425500599-21676-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425500599-21676-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Adds a new single-purpose pids subsystem to limit the number of
tasks that can run inside a cgroup. Essentially this is an
implementation of RLIMIT_NPROC that will applies to a cgroup rather than
a process tree.

PIDs are fundamentally a global resource, and it is possible to reach
PID exhaustion inside a cgroup without hitting any reasonable kmemcg
policy. Once you've hit PID exhaustion, you're only in a marginally
better state than OOM. This subsystem allows PID exhaustion inside a
cgroup to be prevented.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  12 ++
 kernel/Makefile               |   1 +
 kernel/cgroup_pids.c          | 281 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 298 insertions(+)
 create mode 100644 kernel/cgroup_pids.c

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index e4a96fb..a198822 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -47,6 +47,10 @@ SUBSYS(net_prio)
 SUBSYS(hugetlb)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_PIDS)
+SUBSYS(pids)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index f5dbc6d..58f104a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1054,6 +1054,18 @@ config CGROUP_HUGETLB
 	  control group is tracked in the third page lru pointer. This means
 	  that we cannot use the controller with huge page less than 3 pages.
 
+config CGROUP_PIDS
+	bool "Process number limiting on cgroups"
+	depends on PAGE_COUNTER
+	help
+	  This options enables the setting of process number limits in the scope
+	  of a cgroup. Any attempt to fork more processes than is allowed in the
+	  cgroup will fail. PIDs are fundamentally a global resource because it
+	  is fairly trivial to reach PID exhaustion before you reach even a
+	  conservative kmemcg limit. As a result, it is possible to grind a
+	  system to halt without being limited by other cgroup policies. The pids
+	  cgroup subsystem is designed to stop this from happening.
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff --git a/kernel/Makefile b/kernel/Makefile
index 1408b33..e823592 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_PIDS) += cgroup_pids.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
new file mode 100644
index 0000000..65cbab3
--- /dev/null
+++ b/kernel/cgroup_pids.c
@@ -0,0 +1,281 @@
+/*
+ * Process number limiting subsys for cgroups.
+ *
+ * Copyright (C) 2015 Aleksa Sarai <cyphar@cyphar.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/atomic.h>
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+
+#define PIDS_UNLIMITED -1
+
+struct pids {
+	struct pids *parent;
+	struct cgroup_subsys_state css;
+
+	atomic_long_t counter;
+	long limit;
+};
+
+static inline struct pids *css_pids(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct pids, css) : NULL;
+}
+
+static inline struct pids *task_pids(struct task_struct *task)
+{
+	return css_pids(task_css(task, pids_cgrp_id));
+}
+
+static struct pids *parent_pids(struct pids *pids)
+{
+	return css_pids(pids->css.parent);
+}
+
+static struct cgroup_subsys_state *
+pids_css_alloc(struct cgroup_subsys_state *parent)
+{
+	struct pids *pids;
+
+	pids = kzalloc(sizeof(struct pids), GFP_KERNEL);
+	if (!pids)
+		return ERR_PTR(-ENOMEM);
+
+	return &pids->css;
+}
+
+static int pids_css_online(struct cgroup_subsys_state *css)
+{
+	struct pids *pids = css_pids(css);
+	long limit = -1;
+
+	pids->parent = parent_pids(pids);
+	if (pids->parent)
+		limit = pids->parent->limit;
+
+	pids->limit = limit;
+	atomic_long_set(&pids->counter, 0);
+	return 0;
+}
+
+static void pids_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_pids(css));
+}
+
+/**
+ * pids_cancel - uncharge the local pid count
+ * @pids: the pid cgroup state
+ * @num: the number of pids to cancel
+ *
+ * This function will WARN if the pid count goes under 0,
+ * but will not prevent it.
+ */
+static void pids_cancel(struct pids *pids, int num)
+{
+	long new;
+
+	new = atomic_long_sub_return(num, &pids->counter);
+
+	/*
+	 * A negative count is invalid, but pids_cancel() can't fail.
+	 * So just emit a WARN.
+	 */
+	WARN_ON(new < 0);
+}
+
+/**
+ * pids_charge - hierarchically uncharge the pid count
+ * @pids: the pid cgroup state
+ * @num: the number of pids to uncharge
+ *
+ * This function will not allow the pid count to go under 0,
+ * and will WARN if a caller attempts to do so.
+ */
+static void pids_uncharge(struct pids *pids, int num)
+{
+	struct pids *p;
+
+	for(p = pids; p; p = p->parent)
+		pids_cancel(p, num);
+}
+
+/**
+ * pids_charge - hierarchically charge the pid count
+ * @pids: the pid cgroup state
+ * @num: the number of pids to charge
+ *
+ * This function does *not* follow the pid limit set. It will not
+ * fail and the new pid count may exceed the limit.
+ */
+static void pids_charge(struct pids *pids, int num)
+{
+	struct pids *p;
+
+	for(p = pids; p; p = p->parent)
+		atomic_long_add(num, &p->counter);
+}
+
+/**
+ * pids_try_charge - hierarchically try to charge the pid count
+ * @pids: the pid cgroup state
+ * @num: the number of pids to charge
+ *
+ * This function follows the set limit. It can fail if the charge
+ * would cause the new value to exceed the limit.
+ * Returns 0 if the charge succeded, otherwise -EAGAIN.
+ */
+static int pids_try_charge(struct pids *pids, int num)
+{
+	struct pids *p, *fail;
+
+	for(p = pids; p; p = p->parent) {
+		long new;
+
+		new = atomic_long_add_return(num, &p->counter);
+
+		if (p->limit == PIDS_UNLIMITED)
+			continue;
+
+		if (new > p->limit) {
+			atomic_long_sub(num, &p->counter);
+			fail = p;
+			goto revert;
+		}
+	}
+
+	return 0;
+
+revert:
+	for(p = pids; p != fail; p = p->parent)
+		pids_cancel(pids, num);
+
+	return -EAGAIN;
+}
+
+static int pids_can_attach(struct cgroup_subsys_state *css,
+			   struct cgroup_taskset *tset)
+{
+	struct pids *pids = css_pids(css);
+	unsigned long num_tasks = 0;
+	struct task_struct *task;
+
+	cgroup_taskset_for_each(task, tset)
+		num_tasks++;
+
+	/*
+	 * Attaching to a cgroup is allowed to overcome the
+	 * the PID limit, so that organisation operations aren't
+	 * blocked by the `pids` cgroup controller.
+	 */
+	pids_charge(pids, num_tasks);
+	return 0;
+}
+
+static void pids_cancel_attach(struct cgroup_subsys_state *css,
+			       struct cgroup_taskset *tset)
+{
+	struct pids *pids = css_pids(css);
+	unsigned long num_tasks = 0;
+	struct task_struct *task;
+
+	cgroup_taskset_for_each(task, tset)
+		num_tasks++;
+
+	pids_uncharge(pids, num_tasks);
+}
+
+static int pids_can_fork(struct task_struct *task)
+{
+	struct pids *pids = task_pids(task);
+
+	return pids_try_charge(pids, 1);
+}
+
+static void pids_cancel_fork(struct task_struct *task)
+{
+	struct pids *pids = task_pids(task);
+
+	pids_uncharge(pids, 1);
+}
+
+static void pids_exit(struct cgroup_subsys_state *css,
+		      struct cgroup_subsys_state *old_css,
+		      struct task_struct *task)
+{
+	struct pids *pids = css_pids(old_css);
+
+	/*
+	 * cgroup_exit() gets called as part of the cleanup code when copy_process()
+	 * fails. This should ignored, because the pids_cancel_fork callback already
+	 * deals with the cgroup failed fork case.
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
+	pids_uncharge(pids, 1);
+}
+
+static int pids_write_max(struct cgroup_subsys_state *css,
+			  struct cftype *cft, s64 val)
+{
+	struct pids *pids = css_pids(css);
+
+	/* PIDS_UNLIMITED is the only legal negative value. */
+	if (val < 0 && val != PIDS_UNLIMITED)
+		return -EINVAL;
+
+	/*
+	 * Limit updates don't need to be mutex'd, since they
+	 * are more of a "soft" limit in the sense that you can
+	 * set a limit which is smaller than the current count
+	 * to stop any *new* processes from spawning.
+	 */
+	pids->limit = val;
+	return 0;
+}
+
+static s64 pids_read_max(struct cgroup_subsys_state *css,
+			 struct cftype *cft)
+{
+	struct pids *pids = css_pids(css);
+
+	return pids->limit;
+}
+
+static s64 pids_read_current(struct cgroup_subsys_state *css,
+			     struct cftype *cft)
+{
+	struct pids *pids = css_pids(css);
+
+	return atomic_long_read(&pids->counter);
+}
+
+static struct cftype files[] = {
+	{
+		.name = "max",
+		.write_s64 = pids_write_max,
+		.read_s64 = pids_read_max,
+	},
+	{
+		.name = "current",
+		.read_s64 = pids_read_current,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys pids_cgrp_subsys = {
+	.css_alloc	= pids_css_alloc,
+	.css_online	= pids_css_online,
+	.css_free	= pids_css_free,
+	.can_attach	= pids_can_attach,
+	.cancel_attach	= pids_cancel_attach,
+	.can_fork	= pids_can_fork,
+	.cancel_fork	= pids_cancel_fork,
+	.exit		= pids_exit,
+	.legacy_cftypes	= files,
+	.early_init	= 0,
+};
-- 
2.3.1

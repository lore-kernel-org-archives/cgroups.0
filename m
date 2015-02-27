From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2 2/2] cgroups: add an nproc subsystem
Date: Fri, 27 Feb 2015 15:17:19 +1100
Message-ID: <1425010639-16492-3-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Adds a new single-purpose nproc subsystem to limit the number of
tasks that can run inside a cgroup. Essentially this is an
implementation of RLIMIT_NPROC that will applies to a cgroup rather than
a process tree.

This is a step to being able to limit the global impact of a fork bomb
inside a cgroup, allowing for cgroups to perform fairly basic resource
limitation which it currently doesn't have the capability to do.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  10 +++
 kernel/Makefile               |   1 +
 kernel/cgroup_nproc.c         | 198 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 213 insertions(+)
 create mode 100644 kernel/cgroup_nproc.c

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 98c4f9b..e83e0ac 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -47,6 +47,10 @@ SUBSYS(net_prio)
 SUBSYS(hugetlb)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_NPROC)
+SUBSYS(nproc)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index 9afb971..d6315fe 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1047,6 +1047,16 @@ config CGROUP_HUGETLB
 	  control group is tracked in the third page lru pointer. This means
 	  that we cannot use the controller with huge page less than 3 pages.
 
+config CGROUP_NPROC
+	bool "Process number limiting on cgroups"
+	depends on PAGE_COUNTER
+	help
+	  This options enables the setting of process number limits in the scope
+	  of a cgroup. Any attempt to fork more processes than is allowed in the
+	  cgroup will fail. This allows for more basic resource limitation that
+	  applies to a cgroup, similar to RLIMIT_NPROC (except that instead of
+	  applying to a process tree it applies to a cgroup).
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff --git a/kernel/Makefile b/kernel/Makefile
index a59481a..10c4b40 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_NPROC) += cgroup_nproc.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_nproc.c b/kernel/cgroup_nproc.c
new file mode 100644
index 0000000..86de0fe
--- /dev/null
+++ b/kernel/cgroup_nproc.c
@@ -0,0 +1,198 @@
+/*
+ * Process number limiting subsys for cgroups.
+ *
+ * Copyright (C) 2015 Aleksa Sarai <cyphar@cyphar.com>
+ *
+ * Thanks to Frederic Weisbecker for creating the seminal patches which lead to
+ * this being written.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/page_counter.h>
+
+struct nproc {
+	struct page_counter		proc_counter;
+	struct cgroup_subsys_state	css;
+};
+
+static inline struct nproc *css_nproc(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct nproc, css) : NULL;
+}
+
+static inline struct nproc *task_nproc(struct task_struct *task)
+{
+	return css_nproc(task_css(task, nproc_cgrp_id));
+}
+
+static struct nproc *parent_nproc(struct nproc *nproc)
+{
+	return css_nproc(nproc->css.parent);
+}
+
+static struct cgroup_subsys_state *nproc_css_alloc(struct cgroup_subsys_state *parent)
+{
+	struct nproc *nproc;
+
+	nproc = kzalloc(sizeof(struct nproc), GFP_KERNEL);
+	if (!nproc)
+		return ERR_PTR(-ENOMEM);
+
+	return &nproc->css;
+}
+
+static int nproc_css_online(struct cgroup_subsys_state *css)
+{
+	struct nproc *nproc = css_nproc(css);
+	struct nproc *parent = parent_nproc(nproc);
+
+	if (!parent) {
+		page_counter_init(&nproc->proc_counter, NULL);
+		return 0;
+	}
+
+	page_counter_init(&nproc->proc_counter, &parent->proc_counter);
+	return page_counter_limit(&nproc->proc_counter, parent->proc_counter.limit);
+}
+
+static void nproc_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_nproc(css));
+}
+
+static inline void nproc_remove_procs(struct nproc *nproc, int num_procs)
+{
+	page_counter_uncharge(&nproc->proc_counter, num_procs);
+}
+
+static inline int nproc_add_procs(struct nproc *nproc, int num_procs)
+{
+	struct page_counter *fail_at;
+	int errcode;
+
+	errcode = page_counter_try_charge(&nproc->proc_counter, num_procs, &fail_at);
+	if (errcode)
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int nproc_can_attach(struct cgroup_subsys_state *css,
+			    struct cgroup_taskset *tset)
+{
+	struct nproc *nproc = css_nproc(css);
+	unsigned long num_tasks = 0;
+	struct task_struct *task;
+
+	cgroup_taskset_for_each(task, tset)
+		num_tasks++;
+
+	return nproc_add_procs(nproc, num_tasks);
+}
+
+static void nproc_cancel_attach(struct cgroup_subsys_state *css,
+				struct cgroup_taskset *tset)
+{
+	struct nproc *nproc = css_nproc(css);
+	unsigned long num_tasks = 0;
+	struct task_struct *task;
+
+	cgroup_taskset_for_each(task, tset)
+		num_tasks++;
+
+	nproc_remove_procs(nproc, num_tasks);
+}
+
+static int nproc_can_fork(struct task_struct *task)
+{
+	struct nproc *nproc = task_nproc(task);
+
+	return nproc_add_procs(nproc, 1);
+}
+
+static void nproc_cancel_fork(struct task_struct *task)
+{
+	struct nproc *nproc = task_nproc(task);
+
+	nproc_remove_procs(nproc, 1);
+}
+
+static void nproc_exit(struct cgroup_subsys_state *css,
+		       struct cgroup_subsys_state *old_css,
+		       struct task_struct *task)
+{
+	struct nproc *nproc = css_nproc(old_css);
+
+	/*
+	 * cgroup_exit() gets called as part of the cleanup code when copy_process()
+	 * fails. This should ignored, because the nproc_cancel_fork callback already
+	 * deals with the cgroup failed fork case.
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
+	nproc_remove_procs(nproc, 1);
+}
+
+static int nproc_write_limit(struct cgroup_subsys_state *css,
+			     struct cftype *cft, u64 val)
+{
+	struct nproc *nproc = css_nproc(css);
+
+	return page_counter_limit(&nproc->proc_counter, val);
+}
+
+static u64 nproc_read_limit(struct cgroup_subsys_state *css,
+			    struct cftype *cft)
+{
+	struct nproc *nproc = css_nproc(css);
+
+	return nproc->proc_counter.limit;
+}
+
+static u64 nproc_read_max_limit(struct cgroup_subsys_state *css,
+				       struct cftype *cft)
+{
+	return PAGE_COUNTER_MAX;
+}
+
+static u64 nproc_read_usage(struct cgroup_subsys_state *css,
+			    struct cftype *cft)
+{
+	struct nproc *nproc = css_nproc(css);
+
+	return page_counter_read(&nproc->proc_counter);
+}
+
+static struct cftype files[] = {
+	{
+		.name = "limit",
+		.write_u64 = nproc_write_limit,
+		.read_u64 = nproc_read_limit,
+	},
+	{
+		.name = "max_limit",
+		.read_u64 = nproc_read_max_limit,
+	},
+	{
+		.name = "usage",
+		.read_u64 = nproc_read_usage,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys nproc_cgrp_subsys = {
+	.css_alloc	= nproc_css_alloc,
+	.css_online	= nproc_css_online,
+	.css_free	= nproc_css_free,
+	.can_attach	= nproc_can_attach,
+	.cancel_attach	= nproc_cancel_attach,
+	.can_fork	= nproc_can_fork,
+	.cancel_fork	= nproc_cancel_fork,
+	.exit		= nproc_exit,
+	.legacy_cftypes	= files,
+	.early_init	= 0,
+};
-- 
2.3.1

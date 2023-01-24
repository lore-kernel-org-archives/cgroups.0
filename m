From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 24 Jan 2023 16:42:43 +1100
Message-ID: <183372b80aac73e640d9f5ac3c742d505fc6c1f2.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYENaESUmkouh77B5LvetjBP009/977IJw8aWG3YGvY=;
 b=DZuLdAMwy1AlNDFcAukTIVBL2yrLQknf/VrgFP5xxffSlS22dm4r2ydYi27XErd8sffS51YQv6AHLQ0Ri7f+2Zu0OTuqafHOFr62th2AhBnMcnmbAnEy5yswKnkkZPGfZxMoA/mco/nIrQOZ1VknYcbokGBtJI+dxyaE1VYHu4yhkeKEz0N2ssTUF1CvkW3q/FKIbXI9iZ3u+xTiJtkMnj8f8oBPFb0m9Drl/SyABWMiqZvJ5athhjHx1/HCE4iv/C9fdUuJHTyKnFE6S+1v1IEPOEn2aEmwve3pZF138fYKdchB/SQdGD9F/+Mya7BBbKe/xUh0PQizUTUNwqjh9A==
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

If too much memory in a system is pinned or locked it can lead to
problems such as performance degredation or in the worst case
out-of-memory errors as such memory cannot be moved or paged out.

In order to prevent users without CAP_IPC_LOCK from causing these
issues the amount of memory that can be pinned is typically limited by
RLIMIT_MEMLOCK. However this is inflexible as limits can't be shared
between tasks and the enforcement of these limits is inconsistent
between in-kernel users of pinned memory such as mlock() and device
drivers which may also pin pages with pin_user_pages().

To allow for a single limit to be set introduce a cgroup controller
which can be used to limit the number of pages being pinned by all
tasks in the cgroup.

Signed-off-by: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 MAINTAINERS                   |   7 +-
 include/linux/cgroup.h        |  20 +++-
 include/linux/cgroup_subsys.h |   4 +-
 mm/Kconfig                    |  11 +-
 mm/Makefile                   |   1 +-
 mm/pins_cgroup.c              | 273 +++++++++++++++++++++++++++++++++++-
 6 files changed, 316 insertions(+)
 create mode 100644 mm/pins_cgroup.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f781f93..f8526e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5381,6 +5381,13 @@ F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_kmem.c
 F:	tools/testing/selftests/cgroup/test_memcontrol.c
 
+CONTROL GROUP - PINNED AND LOCKED MEMORY
+M:	Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
+L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
+S:	Maintained
+F:	mm/pins_cgroup.c
+
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 L:	linux-hwmon-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3410aec..440f299 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -857,4 +857,24 @@ static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
 
 #endif /* CONFIG_CGROUP_BPF */
 
+#ifdef CONFIG_CGROUP_PINS
+
+struct pins_cgroup *get_pins_cg(struct task_struct *task);
+void put_pins_cg(struct pins_cgroup *cg);
+void pins_uncharge(struct pins_cgroup *pins, int num);
+int pins_try_charge(struct pins_cgroup *pins, int num);
+
+#else /* CONFIG_CGROUP_PINS */
+
+static inline struct pins_cgroup *get_pins_cg(struct task_struct *task)
+{
+	return NULL;
+}
+
+static inline void put_pins_cg(struct pins_cgroup *cg) {}
+static inline void pins_uncharge(struct pins_cgroup *pins, int num) {}
+static inline int pins_try_charge(struct pins_cgroup *pins, int num) { return 0; }
+
+#endif /* CONFIG_CGROUP_PINS */
+
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 4452354..c1b4aab 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,6 +65,10 @@ SUBSYS(rdma)
 SUBSYS(misc)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_PINS)
+SUBSYS(pins)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/mm/Kconfig b/mm/Kconfig
index ff7b209..7a32b98 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1183,6 +1183,17 @@ config LRU_GEN_STATS
 	  This option has a per-memcg and per-node memory overhead.
 # }
 
+config CGROUP_PINS
+    bool "Cgroup for pinned and locked memory"
+    default y
+
+    help
+      Having too much memory pinned or locked can lead to system
+      instability due to increased likelihood of encountering
+      out-of-memory conditions. Select this option to enable a cgroup
+      which can be used to limit the overall number of pages locked or
+      pinned by drivers.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 8e105e5..81db189 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -138,3 +138,4 @@ obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
+obj-$(CONFIG_CGROUP_PINS) += pins_cgroup.o
diff --git a/mm/pins_cgroup.c b/mm/pins_cgroup.c
new file mode 100644
index 0000000..cc310d5
--- /dev/null
+++ b/mm/pins_cgroup.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Controller for cgroups limiting number of pages pinned for FOLL_LONGETERM.
+ *
+ * Copyright (C) 2022 Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/threads.h>
+#include <linux/atomic.h>
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/sched/task.h>
+
+#define PINS_MAX (-1ULL)
+#define PINS_MAX_STR "max"
+
+struct pins_cgroup {
+	struct cgroup_subsys_state	css;
+
+	atomic64_t			counter;
+	atomic64_t			limit;
+
+	struct cgroup_file		events_file;
+	atomic64_t			events_limit;
+};
+
+static struct pins_cgroup *css_pins(struct cgroup_subsys_state *css)
+{
+	return container_of(css, struct pins_cgroup, css);
+}
+
+static struct pins_cgroup *parent_pins(struct pins_cgroup *pins)
+{
+	return css_pins(pins->css.parent);
+}
+
+struct pins_cgroup *get_pins_cg(struct task_struct *task)
+{
+	return css_pins(task_get_css(task, pins_cgrp_id));
+}
+
+void put_pins_cg(struct pins_cgroup *cg)
+{
+	css_put(&cg->css);
+}
+
+static struct cgroup_subsys_state *
+pins_css_alloc(struct cgroup_subsys_state *parent)
+{
+	struct pins_cgroup *pins;
+
+	pins = kzalloc(sizeof(struct pins_cgroup), GFP_KERNEL);
+	if (!pins)
+		return ERR_PTR(-ENOMEM);
+
+	atomic64_set(&pins->counter, 0);
+	atomic64_set(&pins->limit, PINS_MAX);
+	atomic64_set(&pins->events_limit, 0);
+	return &pins->css;
+}
+
+static void pins_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_pins(css));
+}
+
+/**
+ * pins_cancel - uncharge the local pin count
+ * @pins: the pin cgroup state
+ * @num: the number of pins to cancel
+ *
+ * This function will WARN if the pin count goes under 0, because such a case is
+ * a bug in the pins controller proper.
+ */
+void pins_cancel(struct pins_cgroup *pins, int num)
+{
+	/*
+	 * A negative count (or overflow for that matter) is invalid,
+	 * and indicates a bug in the `pins` controller proper.
+	 */
+	WARN_ON_ONCE(atomic64_add_negative(-num, &pins->counter));
+}
+
+/**
+ * pins_uncharge - hierarchically uncharge the pin count
+ * @pins: the pin cgroup state
+ * @num: the number of pins to uncharge
+ */
+void pins_uncharge(struct pins_cgroup *pins, int num)
+{
+	struct pins_cgroup *p;
+
+	for (p = pins; parent_pins(p); p = parent_pins(p))
+		pins_cancel(p, num);
+}
+
+/**
+ * pins_charge - hierarchically charge the pin count
+ * @pins: the pin cgroup state
+ * @num: the number of pins to charge
+ *
+ * This function does *not* follow the pin limit set. It cannot fail and the new
+ * pin count may exceed the limit. This is only used for reverting failed
+ * attaches, where there is no other way out than violating the limit.
+ */
+static void pins_charge(struct pins_cgroup *pins, int num)
+{
+	struct pins_cgroup *p;
+
+	for (p = pins; parent_pins(p); p = parent_pins(p))
+		atomic64_add(num, &p->counter);
+}
+
+/**
+ * pins_try_charge - hierarchically try to charge the pin count
+ * @pins: the pin cgroup state
+ * @num: the number of pins to charge
+ *
+ * This function follows the set limit. It will fail if the charge would cause
+ * the new value to exceed the hierarchical limit. Returns 0 if the charge
+ * succeeded, otherwise -EAGAIN.
+ */
+int pins_try_charge(struct pins_cgroup *pins, int num)
+{
+	struct pins_cgroup *p, *q;
+
+	for (p = pins; parent_pins(p); p = parent_pins(p)) {
+		uint64_t new = atomic64_add_return(num, &p->counter);
+		uint64_t limit = atomic64_read(&p->limit);
+
+		if (limit != PINS_MAX && new > limit)
+			goto revert;
+	}
+
+	return 0;
+
+revert:
+	for (q = pins; q != p; q = parent_pins(q))
+		pins_cancel(q, num);
+	pins_cancel(p, num);
+
+	return -EAGAIN;
+}
+
+static int pins_can_attach(struct cgroup_taskset *tset)
+{
+	struct cgroup_subsys_state *dst_css;
+	struct task_struct *task;
+
+	cgroup_taskset_for_each(task, dst_css, tset) {
+		struct pins_cgroup *pins = css_pins(dst_css);
+		struct cgroup_subsys_state *old_css;
+		struct pins_cgroup *old_pins;
+
+		old_css = task_css(task, pins_cgrp_id);
+		old_pins = css_pins(old_css);
+
+		pins_charge(pins, task->mm->locked_vm);
+		pins_uncharge(old_pins, task->mm->locked_vm);
+	}
+
+	return 0;
+}
+
+static void pins_cancel_attach(struct cgroup_taskset *tset)
+{
+	struct cgroup_subsys_state *dst_css;
+	struct task_struct *task;
+
+	cgroup_taskset_for_each(task, dst_css, tset) {
+		struct pins_cgroup *pins = css_pins(dst_css);
+		struct cgroup_subsys_state *old_css;
+		struct pins_cgroup *old_pins;
+
+		old_css = task_css(task, pins_cgrp_id);
+		old_pins = css_pins(old_css);
+
+		pins_charge(old_pins, task->mm->locked_vm);
+		pins_uncharge(pins, task->mm->locked_vm);
+	}
+}
+
+
+static ssize_t pins_max_write(struct kernfs_open_file *of, char *buf,
+			      size_t nbytes, loff_t off)
+{
+	struct cgroup_subsys_state *css = of_css(of);
+	struct pins_cgroup *pins = css_pins(css);
+	uint64_t limit;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, PINS_MAX_STR)) {
+		limit = PINS_MAX;
+		goto set_limit;
+	}
+
+	err = kstrtoll(buf, 0, &limit);
+	if (err)
+		return err;
+
+	if (limit < 0 || limit >= PINS_MAX)
+		return -EINVAL;
+
+set_limit:
+	/*
+	 * Limit updates don't need to be mutex'd, since it isn't
+	 * critical that any racing fork()s follow the new limit.
+	 */
+	atomic64_set(&pins->limit, limit);
+	return nbytes;
+}
+
+static int pins_max_show(struct seq_file *sf, void *v)
+{
+	struct cgroup_subsys_state *css = seq_css(sf);
+	struct pins_cgroup *pins = css_pins(css);
+	uint64_t limit = atomic64_read(&pins->limit);
+
+	if (limit >= PINS_MAX)
+		seq_printf(sf, "%s\n", PINS_MAX_STR);
+	else
+		seq_printf(sf, "%lld\n", limit);
+
+	return 0;
+}
+
+static s64 pins_current_read(struct cgroup_subsys_state *css,
+			     struct cftype *cft)
+{
+	struct pins_cgroup *pins = css_pins(css);
+
+	return atomic64_read(&pins->counter);
+}
+
+static int pins_events_show(struct seq_file *sf, void *v)
+{
+	struct pins_cgroup *pins = css_pins(seq_css(sf));
+
+	seq_printf(sf, "max %lld\n", (s64)atomic64_read(&pins->events_limit));
+	return 0;
+}
+
+static struct cftype pins_files[] = {
+	{
+		.name = "max",
+		.write = pins_max_write,
+		.seq_show = pins_max_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "current",
+		.read_s64 = pins_current_read,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "events",
+		.seq_show = pins_events_show,
+		.file_offset = offsetof(struct pins_cgroup, events_file),
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys pins_cgrp_subsys = {
+	.css_alloc = pins_css_alloc,
+	.css_free = pins_css_free,
+	.legacy_cftypes = pins_files,
+	.dfl_cftypes = pins_files,
+	.can_attach = pins_can_attach,
+	.cancel_attach = pins_cancel_attach,
+};
-- 
git-series 0.9.1

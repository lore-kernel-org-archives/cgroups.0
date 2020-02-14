From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 01/11] cgroup: Introduce cgroup for drm subsystem
Date: Fri, 14 Feb 2020 10:56:40 -0500
Message-ID: <20200214155650.21203-2-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IE8lLucDYfCrdS9utv/BkKHREyx2rBrFyW9gbmx+UyI=;
 b=EB1T3tPfKYaLCKOYfeK0VTXNJx+lzUCXoJVwUOVPrpbG7K6oUN0eaXUYGqd642r0Eht8eof6ozsl+BuU8X8wbllSuc2CMWaSPVi0XUPfRqI03j0wC1Kx7yQa5mCzKT8JWuLU/psjojDoNivFBa7x+CQ3ZAF6JXzJOXzUjgei2DE=
In-Reply-To: <20200214155650.21203-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

With the increased importance of machine learning, data science and
other cloud-based applications, GPUs are already in production use in
data centers today.  Existing GPU resource management is very coarse
grain, however, as sysadmins are only able to distribute workload on a
per-GPU basis.  An alternative is to use GPU virtualization (with or
without SRIOV) but it generally acts on the entire GPU instead of the
specific resources in a GPU.  With a drm cgroup controller, we can
enable alternate, fine-grain, sub-GPU resource management (in addition
to what may be available via GPU virtualization.)

Change-Id: Ia90aed8c4cb89ff20d8216a903a765655b44fc9a
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 ++++-
 Documentation/cgroup-v1/drm.rst         |  1 +
 include/linux/cgroup_drm.h              | 92 +++++++++++++++++++++++++
 include/linux/cgroup_subsys.h           |  4 ++
 init/Kconfig                            |  5 ++
 kernel/cgroup/Makefile                  |  1 +
 kernel/cgroup/drm.c                     | 42 +++++++++++
 7 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/cgroup-v1/drm.rst
 create mode 100644 include/linux/cgroup_drm.h
 create mode 100644 kernel/cgroup/drm.c

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 5361ebec3361..384db8df0f30 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -61,8 +61,10 @@ v1 is available under Documentation/admin-guide/cgroup-v1/.
      5-6. Device
      5-7. RDMA
        5-7-1. RDMA Interface Files
-     5-8. Misc
-       5-8-1. perf_event
+     5-8. DRM
+       5-8-1. DRM Interface Files
+     5-9. Misc
+       5-9-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -2051,6 +2053,18 @@ RDMA Interface Files
 	  ocrdma1 hca_handle=1 hca_object=23
 
 
+DRM
+---
+
+The "drm" controller regulates the distribution and accounting of
+of DRM (Direct Rendering Manager) and GPU-related resources.
+
+DRM Interface Files
+~~~~~~~~~~~~~~~~~~~~
+
+TODO
+
+
 Misc
 ----
 
diff --git a/Documentation/cgroup-v1/drm.rst b/Documentation/cgroup-v1/drm.rst
new file mode 100644
index 000000000000..5f5658e1f5ed
--- /dev/null
+++ b/Documentation/cgroup-v1/drm.rst
@@ -0,0 +1 @@
+Please see ../cgroup-v2.rst for details
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
new file mode 100644
index 000000000000..ba7981ac3afc
--- /dev/null
+++ b/include/linux/cgroup_drm.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: MIT
+ * Copyright 2019 Advanced Micro Devices, Inc.
+ */
+#ifndef _CGROUP_DRM_H
+#define _CGROUP_DRM_H
+
+#include <linux/cgroup.h>
+
+#ifdef CONFIG_CGROUP_DRM
+
+/**
+ * The DRM cgroup controller data structure.
+ */
+struct drmcg {
+	struct cgroup_subsys_state	css;
+};
+
+/**
+ * css_to_drmcg - get the corresponding drmcg ref from a cgroup_subsys_state
+ * @css: the target cgroup_subsys_state
+ *
+ * Return: DRM cgroup that contains the @css
+ */
+static inline struct drmcg *css_to_drmcg(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct drmcg, css) : NULL;
+}
+
+/**
+ * drmcg_get - get the drmcg reference that a task belongs to
+ * @task: the target task
+ *
+ * This increase the reference count of the css that the @task belongs to
+ *
+ * Return: reference to the DRM cgroup the task belongs to
+ */
+static inline struct drmcg *drmcg_get(struct task_struct *task)
+{
+	return css_to_drmcg(task_get_css(task, drm_cgrp_id));
+}
+
+/**
+ * drmcg_put - put a drmcg reference
+ * @drmcg: the target drmcg
+ *
+ * Put a reference obtained via drmcg_get
+ */
+static inline void drmcg_put(struct drmcg *drmcg)
+{
+	if (drmcg)
+		css_put(&drmcg->css);
+}
+
+/**
+ * drmcg_parent - find the parent of a drm cgroup
+ * @cg: the target drmcg
+ *
+ * This does not increase the reference count of the parent cgroup
+ *
+ * Return: parent DRM cgroup of @cg
+ */
+static inline struct drmcg *drmcg_parent(struct drmcg *cg)
+{
+	return css_to_drmcg(cg->css.parent);
+}
+
+#else /* CONFIG_CGROUP_DRM */
+
+struct drmcg {
+};
+
+static inline struct drmcg *css_to_drmcg(struct cgroup_subsys_state *css)
+{
+	return NULL;
+}
+
+static inline struct drmcg *drmcg_get(struct task_struct *task)
+{
+	return NULL;
+}
+
+static inline void drmcg_put(struct drmcg *drmcg)
+{
+}
+
+static inline struct drmcg *drmcg_parent(struct drmcg *cg)
+{
+	return NULL;
+}
+
+#endif	/* CONFIG_CGROUP_DRM */
+#endif	/* _CGROUP_DRM_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index acb77dcff3b4..ddedad809e8b 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -61,6 +61,10 @@ SUBSYS(pids)
 SUBSYS(rdma)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_DRM)
+SUBSYS(drm)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index b4daad2bac23..8ea6bcfbe5e9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -981,6 +981,11 @@ config CGROUP_RDMA
 	  Attaching processes with active RDMA resources to the cgroup
 	  hierarchy is allowed even if can cross the hierarchy's limit.
 
+config CGROUP_DRM
+	bool "DRM controller (EXPERIMENTAL)"
+	help
+	  Provides accounting and enforcement of resources in the DRM subsystem.
+
 config CGROUP_FREEZER
 	bool "Freezer controller"
 	help
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 5d7a76bfbbb7..31f186f58121 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -4,5 +4,6 @@ obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o freezer.o
 obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
+obj-$(CONFIG_CGROUP_DRM) += drm.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_DEBUG) += debug.o
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
new file mode 100644
index 000000000000..e97861b3cb30
--- /dev/null
+++ b/kernel/cgroup/drm.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: MIT
+// Copyright 2019 Advanced Micro Devices, Inc.
+#include <linux/slab.h>
+#include <linux/cgroup.h>
+#include <linux/cgroup_drm.h>
+
+static struct drmcg *root_drmcg __read_mostly;
+
+static void drmcg_css_free(struct cgroup_subsys_state *css)
+{
+	struct drmcg *drmcg = css_to_drmcg(css);
+
+	kfree(drmcg);
+}
+
+static struct cgroup_subsys_state *
+drmcg_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct drmcg *parent = css_to_drmcg(parent_css);
+	struct drmcg *drmcg;
+
+	drmcg = kzalloc(sizeof(struct drmcg), GFP_KERNEL);
+	if (!drmcg)
+		return ERR_PTR(-ENOMEM);
+
+	if (!parent)
+		root_drmcg = drmcg;
+
+	return &drmcg->css;
+}
+
+struct cftype files[] = {
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys drm_cgrp_subsys = {
+	.css_alloc	= drmcg_css_alloc,
+	.css_free	= drmcg_css_free,
+	.early_init	= false,
+	.legacy_cftypes	= files,
+	.dfl_cftypes	= files,
+};
-- 
2.25.0

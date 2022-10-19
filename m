From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC 01/17] cgroup: Add the DRM cgroup controller
Date: Wed, 19 Oct 2022 18:32:38 +0100
Message-ID: <20221019173254.3361334-2-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666200803; x=1697736803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QHrhf+AzAmghP60cmLV+8/AQtnNJCeogCK+jfUMlLc8=;
  b=Nfa62ouY6u2xXa2nrXHT5p5uTjcNv9prYRy5TVnMGykGlgNvePoRi3Ls
   /cwMoDbfHElzScVpQVclDkTPgpGhDfoBn9rxXTPsRqcg32uVr5PJfKNCl
   xI2R7GpiX3dqtIHrG/kZetZk53YfT7r/hszNJdSN0vYc7wuCb8mrNE3Wi
   wtj8BRy0B0YQhdR7ENfqfmVBQrhgUYdMeHp1RXrOwGSLDbwlN+ID1c3Tv
   89QddjMG6dM/f6FXN3tYjdjeW+dKzaU5b7VOgMRk20mGus7wCv04Sow8G
   Px7Zl0Ip5FEmuVuOkC2qvBBstwFudVKKrfNMOVQeWwyZ2rNc4pW0kf/M9
   Q==;
In-Reply-To: <20221019173254.3361334-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Skeleton controller without any functionality.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup_drm.h    |  9 ++++++
 include/linux/cgroup_subsys.h |  4 +++
 init/Kconfig                  |  7 +++++
 kernel/cgroup/Makefile        |  1 +
 kernel/cgroup/drm.c           | 54 +++++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+)
 create mode 100644 include/linux/cgroup_drm.h
 create mode 100644 kernel/cgroup/drm.c

diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
new file mode 100644
index 000000000000..bf8abc6b8ebf
--- /dev/null
+++ b/include/linux/cgroup_drm.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2022 Intel Corporation
+ */
+
+#ifndef _CGROUP_DRM_H
+#define _CGROUP_DRM_H
+
+#endif	/* _CGROUP_DRM_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 445235487230..49460494a010 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -65,6 +65,10 @@ SUBSYS(rdma)
 SUBSYS(misc)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_DRM)
+SUBSYS(drm)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index 694f7c160c9c..6dd7faca7749 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1087,6 +1087,13 @@ config CGROUP_RDMA
 	  Attaching processes with active RDMA resources to the cgroup
 	  hierarchy is allowed even if can cross the hierarchy's limit.
 
+config CGROUP_DRM
+	bool "DRM controller"
+	help
+	  Provides the DRM subsystem controller.
+
+	  ...
+
 config CGROUP_FREEZER
 	bool "Freezer controller"
 	help
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 12f8457ad1f9..849bd2917477 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_MISC) += misc.o
+obj-$(CONFIG_CGROUP_DRM) += drm.o
 obj-$(CONFIG_CGROUP_DEBUG) += debug.o
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
new file mode 100644
index 000000000000..b88c93661df3
--- /dev/null
+++ b/kernel/cgroup/drm.c
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2022 Intel Corporation
+ */
+
+#include <linux/slab.h>
+#include <linux/cgroup.h>
+#include <linux/cgroup_drm.h>
+#include <linux/sched.h>
+
+struct drm_cgroup_state {
+	struct cgroup_subsys_state css;
+};
+
+static inline struct drm_cgroup_state *
+css_to_drmcs(struct cgroup_subsys_state *css)
+{
+	return container_of(css, struct drm_cgroup_state, css);
+}
+
+static void drmcs_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_to_drmcs(css));
+}
+
+static struct drm_cgroup_state root_drmcs = {
+};
+
+static struct cgroup_subsys_state *
+drmcs_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct drm_cgroup_state *drmcs;
+
+	if (!parent_css)
+		return &root_drmcs.css;
+
+	drmcs = kzalloc(sizeof(*drmcs), GFP_KERNEL);
+	if (!drmcs)
+		return ERR_PTR(-ENOMEM);
+
+	return &drmcs->css;
+}
+
+struct cftype files[] = {
+	{ } /* Zero entry terminates. */
+};
+
+struct cgroup_subsys drm_cgrp_subsys = {
+	.css_alloc	= drmcs_alloc,
+	.css_free	= drmcs_free,
+	.early_init	= false,
+	.legacy_cftypes	= files,
+	.dfl_cftypes	= files,
+};
-- 
2.34.1


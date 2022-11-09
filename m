From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 04/13] cgroup: Add the DRM cgroup controller
Date: Wed,  9 Nov 2022 16:11:32 +0000
Message-ID: <20221109161141.2987173-5-tvrtko.ursulin@linux.intel.com>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668010334; x=1699546334;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2BMu5cQFprtCxtPp+oUiMxCkYO0RYwczmemKP8KDzJQ=;
  b=WTKMsaYJ0KnqM1xg3jzS6hlD5dGy951FBSilNa2goOgtiB84Q9IOC1MC
   Wf7EgABXbjbtyJiY/zQkNM1q5wrCeNC8soTSC6/r1suN6dSX2z5HLpc68
   PcHiohgCp62NSr39OFYqa3NaHsW7RP1NW79Nxay4Qk4RXKl9kj7mGOGH3
   XRUrYKUj3WoW2cNKCEPVXwbdr9K5mWX7e8L18ghPEp1SblHeYCv9iomfr
   mB3cuidkTFymGArlO6bHqiGC6eFxx97rPnv7YmkKCv92gspXlTcOJKueF
   4SglUyBw9DXi6WtnOG6qWSINDFvfkyPdF98ZWirFYjub06yUPdZepXoiU
   w==;
In-Reply-To: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Intel-gfx@lists.freedesktop.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robdclark@chromium.org>, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, "T . J . Mercier" <tjmercier@google.com>, Kenny.Ho@amd.com, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Brian Welty <brian.welty@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@intel.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Skeleton controller without any functionality.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
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
index abf65098f1b6..70c08f340961 100644
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


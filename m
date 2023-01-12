From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 03/12] cgroup: Add the DRM cgroup controller
Date: Thu, 12 Jan 2023 16:56:00 +0000
Message-ID: <20230112165609.1083270-4-tvrtko.ursulin@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1673542662; x=1705078662;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=5tUTxI03m+NTLtcglmz0tTkp8uvuUcMX2wFEFmhnCZQ=;
 b=BvXX0qtsyc/qd94CBSUtJC0DR/b/WslwBBN39pCYK12q1xNfKJh6jfx+
 rJO2oy8QqHGt1/sRDtj/QVMd0x4bHlS+OM3jg1ZlM+vvf3UoUItJZ/G7E
 /zuX0A9nPs9MPmaZdvThXq8zCOPV4cGEafwWxJsOo/Xl4ZitsIe8LJSOX
 LuqTRs+7yp/cKevIL+/RzqzU9PpeUneKeQOIr0fAXW8W2qlm3ungNU3FS
 /Kgqsv5Vm9RPHvlS+mSaWt1HZt3Pjg+1TYrowHd1veCmcRK+goVogpvjs
 cNqhUCbW0KHExtkZ2st9GsWYV3TL5cPv7I9WjTITHUpG5LuKQVV52M4/5 g==;
In-Reply-To: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="utf-8"
To: Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Skeleton controller without any functionality.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 include/linux/cgroup_drm.h    |  9 ++++++
 include/linux/cgroup_subsys.h |  4 +++
 init/Kconfig                  |  7 +++++
 kernel/cgroup/Makefile        |  1 +
 kernel/cgroup/drm.c           | 59 +++++++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+)
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
index 7e5c3ddc341d..c5ace0d57007 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1089,6 +1089,13 @@ config CGROUP_RDMA
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
index 000000000000..48a8d646a094
--- /dev/null
+++ b/kernel/cgroup/drm.c
@@ -0,0 +1,59 @@
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
+struct drm_root_cgroup_state {
+	struct drm_cgroup_state drmcs;
+};
+
+static inline struct drm_cgroup_state *
+css_to_drmcs(struct cgroup_subsys_state *css)
+{
+	return container_of(css, struct drm_cgroup_state, css);
+}
+
+static struct drm_root_cgroup_state root_drmcs;
+
+static void drmcs_free(struct cgroup_subsys_state *css)
+{
+	if (css != &root_drmcs.drmcs.css)
+		kfree(css_to_drmcs(css));
+}
+
+static struct cgroup_subsys_state *
+drmcs_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct drm_cgroup_state *drmcs;
+
+	if (!parent_css) {
+		drmcs = &root_drmcs.drmcs;
+	} else {
+		drmcs = kzalloc(sizeof(*drmcs), GFP_KERNEL);
+		if (!drmcs)
+			return ERR_PTR(-ENOMEM);
+	}
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


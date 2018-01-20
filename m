From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 8/9] drm/i915: Allow default context priority to be set via cgroup parameter
Date: Fri, 19 Jan 2018 17:51:40 -0800
Message-ID: <20180120015141.10118-9-matthew.d.roper@intel.com>
References: <20180120015141.10118-1-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180120015141.10118-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

GPU contexts are usually created with "normal" priority as a starting point=
 and
then may be adjusted from their either via explicit methods (context_set_pa=
ram)
or implicit methods (boosts/penalization due to runtime behavior).  Let's a=
llow
a system integrator to override this starting GPU priority for a group of
processes by setting a parameter on the cgroup that these processes belong =
to.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gm=
ane.org>
---
 drivers/gpu/drm/i915/Makefile           |   1 +
 drivers/gpu/drm/i915/i915_cgroups.c     | 162 ++++++++++++++++++++++++++++=
++++
 drivers/gpu/drm/i915/i915_drv.c         |   4 +
 drivers/gpu/drm/i915/i915_drv.h         |  32 +++++++
 drivers/gpu/drm/i915/i915_gem_context.c |   2 +-
 include/uapi/drm/i915_drm.h             |   9 ++
 6 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/i915/i915_cgroups.c

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 3bddd8a06806..b9f00a6c1e64 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -47,6 +47,7 @@ i915-y :=3D i915_drv.o \
 i915-$(CONFIG_COMPAT)   +=3D i915_ioc32.o
 i915-$(CONFIG_DEBUG_FS) +=3D i915_debugfs.o intel_pipe_crc.o
 i915-$(CONFIG_PERF_EVENTS) +=3D i915_pmu.o
+i915-$(CONFIG_CGROUPS)  +=3D i915_cgroups.o
=20
 # GEM code
 i915-y +=3D i915_cmd_parser.o \
diff --git a/drivers/gpu/drm/i915/i915_cgroups.c b/drivers/gpu/drm/i915/i91=
5_cgroups.c
new file mode 100644
index 000000000000..6e42ba01b8e8
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_cgroups.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright =C2=A9 2018 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software=
"),
+ * to deal in the Software without restriction, including without limitati=
on
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the ne=
xt
+ * paragraph) shall be included in all copies or substantial portions of t=
he
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS=
 OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OT=
HER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+/**
+ * DOC: cgroups integration
+ *
+ * i915 makes use of the DRM cgroup helper library.  Currently i915 only
+ * supports a single cgroup parameter:
+ *
+ * I915_CGRP_DEF_CONTEXT_PRIORITY -
+ *   Setting this parameter on a cgroup will cause GPU contexts created by
+ *   processes in the cgroup to start with the specified default priority =
(in
+ *   the range of I915_CONTEXT_MIN_USER_PRIORITY to
+ *   I915_CONTEXT_MAX_USER_PRIORITY) instead of the usual priority of
+ *   I915_CONTEXT_DEFAULT_PRIORITY.  This cgroup parameter only provides
+ *   a default starting point; the context priorities may still be overrid=
den
+ *   by other mechanisms (e.g., I915_CONTEXT_PARAM_PRIORITY) or adjusted at
+ *   runtime due to system behavior.
+ */
+
+#include <linux/cgroup.h>
+#include <drm/drm_cgroup.h>
+
+#include "i915_drv.h"
+
+static struct drm_cgroup_funcs i915_cgrp =3D {
+	.set_param =3D drm_cgrp_helper_set_param,
+};
+
+static struct drm_cgroup_helper_data *
+i915_cgrp_alloc_params(void)
+{
+	struct i915_cgroup_data *data;
+
+	data =3D kzalloc(sizeof *data, GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	return &data->base;
+}
+
+static int
+i915_cgrp_update_param(struct drm_cgroup_helper_data *data,
+		       uint64_t param, int64_t val)
+{
+	struct i915_cgroup_data *idata =3D
+		container_of(data, struct i915_cgroup_data, base);
+
+	if (param !=3D I915_CGRP_DEF_CONTEXT_PRIORITY) {
+		DRM_DEBUG_DRIVER("Invalid cgroup parameter %llu\n", param);
+		return -EINVAL;
+	}
+
+	if (val > I915_CONTEXT_MAX_USER_PRIORITY ||
+	    val < I915_CONTEXT_MIN_USER_PRIORITY) {
+		DRM_DEBUG_DRIVER("Context priority must be in range (%d,%d)\n",
+				 I915_CONTEXT_MIN_USER_PRIORITY,
+				 I915_CONTEXT_MAX_USER_PRIORITY);
+		return -EINVAL;
+	}
+
+	idata->priority =3D val;
+
+	return 0;
+}
+
+static int
+i915_cgrp_read_param(struct drm_cgroup_helper_data *data,
+		     uint64_t param, int64_t *val)
+{
+	struct i915_cgroup_data *idata =3D
+		container_of(data, struct i915_cgroup_data, base);
+
+	switch (param)
+	{
+	case I915_CGRP_DEF_CONTEXT_PRIORITY:
+		*val =3D idata->priority;
+		break;
+	default:
+		DRM_DEBUG_DRIVER("Invalid cgroup parameter %llu\n", param);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct drm_cgroup_helper i915_cgrp_helper =3D {
+	.alloc_params =3D i915_cgrp_alloc_params,
+	.update_param =3D i915_cgrp_update_param,
+	.read_param =3D i915_cgrp_read_param,
+};
+
+void
+i915_cgroup_init(struct drm_i915_private *dev_priv)
+{
+	dev_priv->drm.cgroup =3D &i915_cgrp;
+
+	drm_cgrp_helper_init(&dev_priv->drm,
+			     &i915_cgrp_helper);
+}
+
+void
+i915_cgroup_shutdown(struct drm_i915_private *dev_priv)
+{
+	drm_cgrp_helper_shutdown(&i915_cgrp_helper);
+}
+
+/**
+ * i915_cgroup_get_prio() - get priority associated with current proc's cg=
roup
+ * @dev_priv: drm device
+ * @file_priv: file handle for calling process
+ *
+ * RETURNS:
+ * Priority associated with the calling process' cgroup in the default (v2)
+ * hierarchy, otherwise I915_PRIORITY_NORMAL if no explicit priority has
+ * been assigned.
+ */
+int
+i915_cgroup_get_prio(struct drm_i915_private *dev_priv,
+		     struct drm_i915_file_private *file_priv)
+{
+	struct cgroup *cgrp;
+	int64_t prio;
+	int ret;
+
+	/* Ignore internally-created contexts not associated with a process */
+	if (!file_priv)
+		return I915_PRIORITY_NORMAL;
+
+	cgrp =3D drm_file_get_cgroup(file_priv->file, &cgrp_dfl_root);
+	if (WARN_ON(!cgrp))
+		return I915_PRIORITY_NORMAL;
+
+	ret =3D drm_cgrp_helper_get_param(&dev_priv->drm, cgrp,
+					I915_CGRP_DEF_CONTEXT_PRIORITY,
+					&prio);
+	if (ret)
+		/* No default priority has been associated with cgroup */
+		return I915_PRIORITY_NORMAL;
+	else
+		return prio;
+}
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index 173d0095e3b2..0a11e4b31c2f 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1394,6 +1394,8 @@ int i915_driver_load(struct pci_dev *pdev, const stru=
ct pci_device_id *ent)
=20
 	intel_runtime_pm_put(dev_priv);
=20
+	i915_cgroup_init(dev_priv);
+
 	i915_welcome_messages(dev_priv);
=20
 	return 0;
@@ -1422,6 +1424,8 @@ void i915_driver_unload(struct drm_device *dev)
=20
 	i915_driver_unregister(dev_priv);
=20
+	i915_cgroup_shutdown(dev_priv);
+
 	if (i915_gem_suspend(dev_priv))
 		DRM_ERROR("failed to idle hardware; continuing to unload!\n");
=20
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index 2b1d2f802c39..f3991ab847da 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -51,6 +51,7 @@
 #include <drm/drm_gem.h>
 #include <drm/drm_auth.h>
 #include <drm/drm_cache.h>
+#include <drm/drm_cgroup_helper.h>
=20
 #include "i915_params.h"
 #include "i915_reg.h"
@@ -4078,4 +4079,35 @@ static inline int intel_hws_csb_write_index(struct d=
rm_i915_private *i915)
 		return I915_HWS_CSB_WRITE_INDEX;
 }
=20
+/* i915_cgroups.c */
+#ifdef CONFIG_CGROUPS
+void i915_cgroup_init(struct drm_i915_private *dev_priv);
+void i915_cgroup_shutdown(struct drm_i915_private *dev_priv);
+int i915_cgroup_get_prio(struct drm_i915_private *dev_priv,
+			 struct drm_i915_file_private *file_priv);
+#else
+static inline void
+i915_cgroup_init(struct drm_i915_private *dev_priv) { return; }
+static inline void
+i915_cgroup_shutdown(struct drm_i915_private *dev_priv) { return; }
+
+static inline int
+i915_cgroup_get_prio(struct drm_i915_private *dev_priv,
+		     struct drm_i915_private *file_priv)
+{
+	return I915_PRIORITY_NORMAL;
+}
+#endif
+
+enum i915_cgroup_param {
+	I915_CGRP_DEF_CONTEXT_PRIORITY =3D 1,
+};
+
+/* Driver-specific per-cgroup parameters to track */
+struct i915_cgroup_data {
+	struct drm_cgroup_helper_data base;
+
+	int priority;
+};
+
 #endif
diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915=
/i915_gem_context.c
index 648e7536ff51..ee30f90ae5b2 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -274,7 +274,7 @@ __create_hw_context(struct drm_i915_private *dev_priv,
 	kref_init(&ctx->ref);
 	list_add_tail(&ctx->link, &dev_priv->contexts.list);
 	ctx->i915 =3D dev_priv;
-	ctx->priority =3D I915_PRIORITY_NORMAL;
+	ctx->priority =3D i915_cgroup_get_prio(dev_priv, file_priv);
=20
 	INIT_RADIX_TREE(&ctx->handles_vma, GFP_KERNEL);
 	INIT_LIST_HEAD(&ctx->handles_list);
diff --git a/include/uapi/drm/i915_drm.h b/include/uapi/drm/i915_drm.h
index 536ee4febd74..07cab6eefaba 100644
--- a/include/uapi/drm/i915_drm.h
+++ b/include/uapi/drm/i915_drm.h
@@ -1613,6 +1613,15 @@ struct drm_i915_perf_oa_config {
 	__u64 flex_regs_ptr;
 };
=20
+/**
+ * Structure to supply driver-specific cgroup parameters
+ */
+struct drm_i915_cgroup_param {
+	__u32 cgroup_fd;
+	__u64 param;
+	__u64 value;
+};
+
 #if defined(__cplusplus)
 }
 #endif
--=20
2.14.3

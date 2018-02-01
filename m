From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC v2 6/7] drm/i915: Introduce 'priority offset' for GPU contexts
Date: Thu,  1 Feb 2018 11:53:14 -0800
Message-ID: <20180201195315.4956-7-matthew.d.roper@intel.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201195315.4956-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There are cases where a system integrator may wish to raise/lower the
priority of GPU workloads being submitted by specific OS process(es),
independently of how the software self-classifies its own priority.
Exposing "priority offset" as an i915-specific cgroup parameter will
enable such system-level configuration.

Normally GPU contexts start with a priority value of 0
(I915_CONTEXT_DEFAULT_PRIORITY) and then may be adjusted up/down from
there via other mechanisms.  We'd like to provide a system-level input
to the priority decision that will be taken into consideration, even
when userspace later attempts to set an absolute priority value via
I915_CONTEXT_PARAM_PRIORITY.  The priority offset introduced here
provides a base value that will always be added to (or subtracted from)
the software's self-assigned priority value.

This patch makes priority offset a cgroup-specific value; contexts will
be created with a priority offset based on the cgroup membership of the
process creating the context at the time the context is created.  Note
that priority offset is assigned at context creation time; migrating a
process to a different cgroup or changing the offset associated with a
cgroup will only affect new context creation and will not alter the
behavior of existing contexts previously created by the process.

Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/i915/i915_cgroup.c      | 46 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h         |  7 +++++
 drivers/gpu/drm/i915/i915_gem_context.c |  6 +++--
 drivers/gpu/drm/i915/i915_gem_context.h |  9 +++++++
 include/uapi/drm/i915_drm.h             |  1 +
 5 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_cgroup.c b/drivers/gpu/drm/i915/i915_cgroup.c
index 778af895fc00..73f3cfe31d66 100644
--- a/drivers/gpu/drm/i915/i915_cgroup.c
+++ b/drivers/gpu/drm/i915/i915_cgroup.c
@@ -11,6 +11,8 @@
 
 struct i915_cgroup_data {
 	struct cgroup_driver_data base;
+
+	int priority_offset;
 };
 
 static inline struct i915_cgroup_data *
@@ -72,6 +74,8 @@ i915_cgroup_setparam_ioctl(struct drm_device *dev, void *data,
 	struct cgroup *cgrp;
 	struct file *f;
 	struct inode *inode = NULL;
+	struct cgroup_driver_data *cgrpdata;
+	struct i915_cgroup_data *i915data;
 	int ret;
 
 	if (!dev_priv->i915_cgroups) {
@@ -125,6 +129,17 @@ i915_cgroup_setparam_ioctl(struct drm_device *dev, void *data,
 		return ret;
 
 	switch (req->param) {
+	case I915_CGROUP_PARAM_PRIORITY_OFFSET:
+		cgrpdata = cgroup_driver_get_data(dev_priv->i915_cgroups, cgrp,
+						  NULL);
+		if (IS_ERR(cgrpdata))
+			return PTR_ERR(cgrpdata);
+
+		DRM_DEBUG_DRIVER("Setting cgroup priority offset to %lld\n",
+				 req->value);
+		i915data = cgrp_to_i915(cgrpdata);
+		i915data->priority_offset = req->value;
+		break;
 	default:
 		DRM_DEBUG_DRIVER("Invalid cgroup parameter %lld\n", req->param);
 		return -EINVAL;
@@ -132,3 +147,34 @@ i915_cgroup_setparam_ioctl(struct drm_device *dev, void *data,
 
 	return 0;
 }
+
+/**
+ * i915_cgroup_get_prio_offset() - get prio offset for current proc's cgroup
+ * @dev_priv: drm device
+ * @file_priv: file handle for calling process
+ *
+ * RETURNS:
+ * Priority offset associated with the calling process' cgroup in the default
+ * (v2) hierarchy, otherwise 0 if no explicit priority has been assigned.
+ */
+int
+i915_cgroup_get_prio_offset(struct drm_i915_private *dev_priv,
+			    struct drm_i915_file_private *file_priv)
+{
+       struct cgroup *cgrp;
+       struct cgroup_driver_data *cgrpdata;
+
+       /* Ignore internally-created contexts not associated with a process */
+       if (!file_priv)
+               return 0;
+
+       cgrp = drm_file_get_cgroup(file_priv->file);
+       if (WARN_ON(!cgrp))
+               return 0;
+
+       cgrpdata = cgroup_driver_get_data(dev_priv->i915_cgroups, cgrp, NULL);
+       if (IS_ERR(cgrpdata))
+	       return 0;
+
+       return cgrp_to_i915(cgrpdata)->priority_offset;
+}
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 60e3ff6a48bb..313191e5278a 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -2920,6 +2920,8 @@ int i915_cgroup_init(struct drm_i915_private *dev_priv);
 int i915_cgroup_setparam_ioctl(struct drm_device *dev, void *data,
 			       struct drm_file *file);
 void i915_cgroup_shutdown(struct drm_i915_private *dev_priv);
+int i915_cgroup_get_prio_offset(struct drm_i915_private *dev_priv,
+				struct drm_i915_file_private *file_priv);
 #else
 static inline int
 i915_cgroup_init(struct drm_i915_private *dev_priv)
@@ -2933,6 +2935,11 @@ i915_cgroup_setparam_ioctl(struct drm_device *dev, void *data,
 {
 	return -EINVAL;
 }
+static inline int
+i915_cgroup_get_prio_offset(struct drm_i915_private *dev_priv,
+			    struct drm_i915_file_private *file_priv) {
+	return 0;
+}
 #endif
 
 /* i915_drv.c */
diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index 648e7536ff51..700d7bc7cfc8 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -274,7 +274,9 @@ __create_hw_context(struct drm_i915_private *dev_priv,
 	kref_init(&ctx->ref);
 	list_add_tail(&ctx->link, &dev_priv->contexts.list);
 	ctx->i915 = dev_priv;
-	ctx->priority = I915_PRIORITY_NORMAL;
+	ctx->priority_offset =
+		i915_cgroup_get_prio_offset(dev_priv, file_priv);
+	ctx->priority = I915_PRIORITY_NORMAL + ctx->priority_offset;
 
 	INIT_RADIX_TREE(&ctx->handles_vma, GFP_KERNEL);
 	INIT_LIST_HEAD(&ctx->handles_list);
@@ -816,7 +818,7 @@ int i915_gem_context_setparam_ioctl(struct drm_device *dev, void *data,
 				 !capable(CAP_SYS_NICE))
 				ret = -EPERM;
 			else
-				ctx->priority = priority;
+				ctx->priority = priority + ctx->priority_offset;
 		}
 		break;
 
diff --git a/drivers/gpu/drm/i915/i915_gem_context.h b/drivers/gpu/drm/i915/i915_gem_context.h
index 4bfb72f8e1cb..4f1c95fca5c2 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.h
+++ b/drivers/gpu/drm/i915/i915_gem_context.h
@@ -147,6 +147,15 @@ struct i915_gem_context {
 	 */
 	int priority;
 
+	/**
+	 * @priority_offset: priority offset
+	 *
+	 * A value, configured via cgroup, that sets the starting priority
+	 * of the context.  Any priority set explicitly via context parameter
+	 * will be added to the priority offset.
+	 */
+	int priority_offset;
+
 	/** ggtt_offset_bias: placement restriction for context objects */
 	u32 ggtt_offset_bias;
 
diff --git a/include/uapi/drm/i915_drm.h b/include/uapi/drm/i915_drm.h
index fe333ae1f0c6..1c1988e9fba5 100644
--- a/include/uapi/drm/i915_drm.h
+++ b/include/uapi/drm/i915_drm.h
@@ -1622,6 +1622,7 @@ struct drm_i915_cgroup_param {
 	__s32 cgroup_fd;
 	__u32 flags;
 	__u64 param;
+#define I915_CGROUP_PARAM_PRIORITY_OFFSET	0x1
 	__s64 value;
 };
 
-- 
2.14.3

From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 02/11] drm, cgroup: Bind drm and cgroup subsystem
Date: Fri, 14 Feb 2020 10:56:41 -0500
Message-ID: <20200214155650.21203-3-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DltWDmUoat4C6/gr1wh/v/rSEdrfM7FwlqNY9LzYxuU=;
 b=HIbR4fNS0VXt3PLHnFqh3JyfBN6gmCzzE9pnqfUuef1mEffYKkLvg9hajzpKdvjdplEd4kVXBndOharzZu1gBn2TeRNZqzpslj1HBQ0lq3e8Lowy6nIwmtv56vE0Bvx1i5gjV1kBhSADRYtFcoqws6gKcI3dTSWm2pELM2dXCbw=
In-Reply-To: <20200214155650.21203-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

Since the drm subsystem can be compiled as a module and drm devices can
be added and removed during run time, add several functions to bind the
drm subsystem as well as drm devices with drmcg.

Two pairs of functions:
drmcg_bind/drmcg_unbind - used to bind/unbind the drm subsystem to the
cgroup subsystem as the drm core initialize/exit.

drmcg_register_dev/drmcg_unregister_dev - used to register/unregister
drm devices to the cgroup subsystem as the devices are presented/removed
from userspace.

Change-Id: I1cb6b2080fc7d27979d886ef23e784341efafb41
---
 drivers/gpu/drm/drm_drv.c  |   8 +++
 include/drm/drm_cgroup.h   |  39 +++++++++++
 include/linux/cgroup_drm.h |   4 ++
 kernel/cgroup/drm.c        | 131 +++++++++++++++++++++++++++++++++++++
 4 files changed, 182 insertions(+)
 create mode 100644 include/drm/drm_cgroup.h

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 1b9b40a1c7c9..8e59cc5a5bde 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -41,6 +41,7 @@
 #include <drm/drm_file.h>
 #include <drm/drm_mode_object.h>
 #include <drm/drm_print.h>
+#include <drm/drm_cgroup.h>
 
 #include "drm_crtc_internal.h"
 #include "drm_internal.h"
@@ -972,6 +973,8 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 
 	ret = 0;
 
+	drmcg_register_dev(dev);
+
 	DRM_INFO("Initialized %s %d.%d.%d %s for %s on minor %d\n",
 		 driver->name, driver->major, driver->minor,
 		 driver->patchlevel, driver->date,
@@ -1006,6 +1009,8 @@ EXPORT_SYMBOL(drm_dev_register);
  */
 void drm_dev_unregister(struct drm_device *dev)
 {
+	drmcg_unregister_dev(dev);
+
 	if (drm_core_check_feature(dev, DRIVER_LEGACY))
 		drm_lastclose(dev);
 
@@ -1112,6 +1117,7 @@ static const struct file_operations drm_stub_fops = {
 
 static void drm_core_exit(void)
 {
+	drmcg_unbind();
 	unregister_chrdev(DRM_MAJOR, "drm");
 	debugfs_remove(drm_debugfs_root);
 	drm_sysfs_destroy();
@@ -1138,6 +1144,8 @@ static int __init drm_core_init(void)
 	if (ret < 0)
 		goto error;
 
+	drmcg_bind(&drm_minor_acquire, &drm_dev_put);
+
 	drm_core_init_complete = true;
 
 	DRM_DEBUG("Initialized\n");
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
new file mode 100644
index 000000000000..530c9a0b3238
--- /dev/null
+++ b/include/drm/drm_cgroup.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: MIT
+ * Copyright 2019 Advanced Micro Devices, Inc.
+ */
+#ifndef __DRM_CGROUP_H__
+#define __DRM_CGROUP_H__
+
+#ifdef CONFIG_CGROUP_DRM
+
+void drmcg_bind(struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
+		void (*put_ddev)(struct drm_device *dev));
+
+void drmcg_unbind(void);
+
+void drmcg_register_dev(struct drm_device *dev);
+
+void drmcg_unregister_dev(struct drm_device *dev);
+
+#else
+
+static inline void drmcg_bind(
+		struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
+		void (*put_ddev)(struct drm_device *dev))
+{
+}
+
+static inline void drmcg_unbind(void)
+{
+}
+
+static inline void drmcg_register_dev(struct drm_device *dev)
+{
+}
+
+static inline void drmcg_unregister_dev(struct drm_device *dev)
+{
+}
+
+#endif /* CONFIG_CGROUP_DRM */
+#endif /* __DRM_CGROUP_H__ */
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index ba7981ac3afc..854591bbb430 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -5,6 +5,10 @@
 #define _CGROUP_DRM_H
 
 #include <linux/cgroup.h>
+#include <drm/drm_file.h>
+
+/* limit defined per the way drm_minor_alloc operates */
+#define MAX_DRM_DEV (64 * DRM_MINOR_RENDER)
 
 #ifdef CONFIG_CGROUP_DRM
 
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index e97861b3cb30..37f98dc47268 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -1,11 +1,142 @@
 // SPDX-License-Identifier: MIT
 // Copyright 2019 Advanced Micro Devices, Inc.
+#include <linux/bitmap.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/cgroup.h>
 #include <linux/cgroup_drm.h>
+#include <drm/drm_file.h>
+#include <drm/drm_device.h>
+#include <drm/drm_cgroup.h>
 
 static struct drmcg *root_drmcg __read_mostly;
 
+/* global mutex for drmcg across all devices */
+static DEFINE_MUTEX(drmcg_mutex);
+
+static DECLARE_BITMAP(known_devs, MAX_DRM_DEV);
+
+static struct drm_minor (*(*acquire_drm_minor)(unsigned int minor_id));
+
+static void (*put_drm_dev)(struct drm_device *dev);
+
+/**
+ * drmcg_bind - Bind DRM subsystem to cgroup subsystem
+ * @acq_dm: function pointer to the drm_minor_acquire function
+ * @put_ddev: function pointer to the drm_dev_put function
+ *
+ * This function binds some functions from the DRM subsystem and make
+ * them available to the drmcg subsystem.
+ *
+ * drmcg_unbind does the opposite of this function
+ */
+void drmcg_bind(struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
+		void (*put_ddev)(struct drm_device *dev))
+{
+	mutex_lock(&drmcg_mutex);
+	acquire_drm_minor = acq_dm;
+	put_drm_dev = put_ddev;
+	mutex_unlock(&drmcg_mutex);
+}
+EXPORT_SYMBOL(drmcg_bind);
+
+/**
+ * drmcg_unbind - Unbind DRM subsystem from cgroup subsystem
+ *
+ * drmcg_bind does the opposite of this function
+ */
+void drmcg_unbind(void)
+{
+	mutex_lock(&drmcg_mutex);
+	acquire_drm_minor = NULL;
+	put_drm_dev = NULL;
+	mutex_unlock(&drmcg_mutex);
+}
+EXPORT_SYMBOL(drmcg_unbind);
+
+/**
+ * drmcg_register_dev - register a DRM device for usage in drm cgroup
+ * @dev: DRM device
+ *
+ * This function make a DRM device visible to the cgroup subsystem.
+ * Once the drmcg is aware of the device, drmcg can start tracking and
+ * control resource usage for said device.
+ *
+ * drmcg_unregister_dev reverse the operation of this function
+ */
+void drmcg_register_dev(struct drm_device *dev)
+{
+	if (WARN_ON(dev->primary->index >= MAX_DRM_DEV))
+		return;
+
+	mutex_lock(&drmcg_mutex);
+	set_bit(dev->primary->index, known_devs);
+	mutex_unlock(&drmcg_mutex);
+}
+EXPORT_SYMBOL(drmcg_register_dev);
+
+/**
+ * drmcg_unregister_dev - Iterate through all stored DRM minors
+ * @dev: DRM device
+ *
+ * Unregister @dev so that drmcg no longer control resource usage
+ * of @dev.  The @dev was registered to drmcg using
+ * drmcg_register_dev function
+ */
+void drmcg_unregister_dev(struct drm_device *dev)
+{
+	if (WARN_ON(dev->primary->index >= MAX_DRM_DEV))
+		return;
+
+	mutex_lock(&drmcg_mutex);
+	clear_bit(dev->primary->index, known_devs);
+	mutex_unlock(&drmcg_mutex);
+}
+EXPORT_SYMBOL(drmcg_unregister_dev);
+
+/**
+ * drm_minor_for_each - Iterate through all stored DRM minors
+ * @fn: Function to be called for each pointer.
+ * @data: Data passed to callback function.
+ *
+ * The callback function will be called for each registered device, passing
+ * the minor, the @drm_minor entry and @data.
+ *
+ * If @fn returns anything other than %0, the iteration stops and that
+ * value is returned from this function.
+ */
+static int drm_minor_for_each(int (*fn)(int id, void *p, void *data),
+		void *data)
+{
+	int rc = 0;
+
+	mutex_lock(&drmcg_mutex);
+	if (acquire_drm_minor) {
+		unsigned int minor;
+		struct drm_minor *dm;
+
+		minor = find_next_bit(known_devs, MAX_DRM_DEV, 0);
+		while (minor < MAX_DRM_DEV) {
+			dm = acquire_drm_minor(minor);
+
+			if (IS_ERR(dm))
+				continue;
+
+			rc = fn(minor, (void *)dm, data);
+
+			put_drm_dev(dm->dev); /* release from acquire_drm_minor */
+
+			if (rc)
+				break;
+
+			minor = find_next_bit(known_devs, MAX_DRM_DEV, minor+1);
+		}
+	}
+	mutex_unlock(&drmcg_mutex);
+
+	return rc;
+}
+
 static void drmcg_css_free(struct cgroup_subsys_state *css)
 {
 	struct drmcg *drmcg = css_to_drmcg(css);
-- 
2.25.0


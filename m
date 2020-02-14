From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 03/11] drm, cgroup: Initialize drmcg properties
Date: Fri, 14 Feb 2020 10:56:42 -0500
Message-ID: <20200214155650.21203-4-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CV7hGKAQeTmH37PsOyv+FEVbtbyZ1TJI7sXBsy6xaBQ=;
 b=uIWnIxTcOFpBfiPcqKacFI19Kf+Wa31RvTsYiNGnMeORaE/yoeLkidMNg95XyOPLXUPETTymHFanVCM8X81aYyHQ0Qr+pTQMQoGb9dcfnNP3GZ6iNxDybtlEROnwueuLyyBGUFB7+0L8WAf8ut7MmZ6AGE+tBkYI4k1jkEJbkVg=
In-Reply-To: <20200214155650.21203-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

drmcg initialization involves allocating a per cgroup, per device data
structure and setting the defaults.  There are two entry points for
drmcg init:

1) When struct drmcg is created via css_alloc, initialization is done
for each device

2) When DRM devices are created after drmcgs are created
  a) Per device drmcg data structure is allocated at the beginning of
  DRM device creation such that drmcg can begin tracking usage
  statistics
  b) At the end of DRM device creation, drmcg_register_dev will update in
  case device specific defaults need to be applied.

Entry point #2 usually applies to the root cgroup since it can be
created before DRM devices are available.  The drmcg controller will go
through all existing drm cgroups and initialize them with the new device
accordingly.

Change-Id: I64e421d8dfcc22ee8282cc1305960e20c2704db7
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 drivers/gpu/drm/drm_drv.c  |   4 ++
 include/drm/drm_cgroup.h   |  18 +++++++
 include/drm/drm_device.h   |   7 +++
 include/drm/drm_drv.h      |   9 ++++
 include/linux/cgroup_drm.h |  12 +++++
 kernel/cgroup/drm.c        | 105 +++++++++++++++++++++++++++++++++++++
 6 files changed, 155 insertions(+)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 8e59cc5a5bde..44a66edc81c2 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -643,6 +643,7 @@ int drm_dev_init(struct drm_device *dev,
 	mutex_init(&dev->filelist_mutex);
 	mutex_init(&dev->clientlist_mutex);
 	mutex_init(&dev->master_mutex);
+	mutex_init(&dev->drmcg_mutex);
 
 	dev->anon_inode = drm_fs_inode_new();
 	if (IS_ERR(dev->anon_inode)) {
@@ -679,6 +680,7 @@ int drm_dev_init(struct drm_device *dev,
 	if (ret)
 		goto err_setunique;
 
+	drmcg_device_early_init(dev);
 	return 0;
 
 err_setunique:
@@ -693,6 +695,7 @@ int drm_dev_init(struct drm_device *dev,
 	drm_fs_inode_free(dev->anon_inode);
 err_free:
 	put_device(dev->dev);
+	mutex_destroy(&dev->drmcg_mutex);
 	mutex_destroy(&dev->master_mutex);
 	mutex_destroy(&dev->clientlist_mutex);
 	mutex_destroy(&dev->filelist_mutex);
@@ -769,6 +772,7 @@ void drm_dev_fini(struct drm_device *dev)
 
 	put_device(dev->dev);
 
+	mutex_destroy(&dev->drmcg_mutex);
 	mutex_destroy(&dev->master_mutex);
 	mutex_destroy(&dev->clientlist_mutex);
 	mutex_destroy(&dev->filelist_mutex);
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index 530c9a0b3238..fda426fba035 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -4,8 +4,17 @@
 #ifndef __DRM_CGROUP_H__
 #define __DRM_CGROUP_H__
 
+#include <linux/cgroup_drm.h>
+
 #ifdef CONFIG_CGROUP_DRM
 
+/**
+ * Per DRM device properties for DRM cgroup controller for the purpose
+ * of storing per device defaults
+ */
+struct drmcg_props {
+};
+
 void drmcg_bind(struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
 		void (*put_ddev)(struct drm_device *dev));
 
@@ -15,8 +24,13 @@ void drmcg_register_dev(struct drm_device *dev);
 
 void drmcg_unregister_dev(struct drm_device *dev);
 
+void drmcg_device_early_init(struct drm_device *device);
+
 #else
 
+struct drmcg_props {
+};
+
 static inline void drmcg_bind(
 		struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
 		void (*put_ddev)(struct drm_device *dev))
@@ -35,5 +49,9 @@ static inline void drmcg_unregister_dev(struct drm_device *dev)
 {
 }
 
+static inline void drmcg_device_early_init(struct drm_device *device)
+{
+}
+
 #endif /* CONFIG_CGROUP_DRM */
 #endif /* __DRM_CGROUP_H__ */
diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
index 1acfc3bbd3fb..a94598b8f670 100644
--- a/include/drm/drm_device.h
+++ b/include/drm/drm_device.h
@@ -8,6 +8,7 @@
 
 #include <drm/drm_hashtab.h>
 #include <drm/drm_mode_config.h>
+#include <drm/drm_cgroup.h>
 
 struct drm_driver;
 struct drm_minor;
@@ -308,6 +309,12 @@ struct drm_device {
 	 */
 	struct drm_fb_helper *fb_helper;
 
+        /** \name DRM Cgroup */
+	/*@{ */
+	struct mutex drmcg_mutex;
+	struct drmcg_props drmcg_props;
+	/*@} */
+
 	/* Everything below here is for legacy driver, never use! */
 	/* private: */
 #if IS_ENABLED(CONFIG_DRM_LEGACY)
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index cf13470810a5..1f65ac4d9bbf 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -715,6 +715,15 @@ struct drm_driver {
 			    struct drm_device *dev,
 			    uint32_t handle);
 
+	/**
+	 * @drmcg_custom_init
+	 *
+	 * Optional callback used to initialize drm cgroup per device properties
+	 * such as resource limit defaults.
+	 */
+	void (*drmcg_custom_init)(struct drm_device *dev,
+			struct drmcg_props *props);
+
 	/**
 	 * @gem_vm_ops: Driver private ops for this object
 	 *
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 854591bbb430..2014097eb75c 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -4,6 +4,7 @@
 #ifndef _CGROUP_DRM_H
 #define _CGROUP_DRM_H
 
+#include <linux/mutex.h>
 #include <linux/cgroup.h>
 #include <drm/drm_file.h>
 
@@ -12,11 +13,19 @@
 
 #ifdef CONFIG_CGROUP_DRM
 
+/**
+ * Per DRM cgroup, per device resources (such as statistics and limits)
+ */
+struct drmcg_device_resource {
+	/* for per device stats */
+};
+
 /**
  * The DRM cgroup controller data structure.
  */
 struct drmcg {
 	struct cgroup_subsys_state	css;
+	struct drmcg_device_resource	*dev_resources[MAX_DRM_DEV];
 };
 
 /**
@@ -70,6 +79,9 @@ static inline struct drmcg *drmcg_parent(struct drmcg *cg)
 
 #else /* CONFIG_CGROUP_DRM */
 
+struct drmcg_device_resource {
+};
+
 struct drmcg {
 };
 
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 37f98dc47268..30fd9aeffbe7 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -1,11 +1,17 @@
 // SPDX-License-Identifier: MIT
 // Copyright 2019 Advanced Micro Devices, Inc.
 #include <linux/bitmap.h>
+#include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/cgroup.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/mutex.h>
+#include <linux/kernel.h>
 #include <linux/cgroup_drm.h>
 #include <drm/drm_file.h>
+#include <drm/drm_drv.h>
 #include <drm/drm_device.h>
 #include <drm/drm_cgroup.h>
 
@@ -54,6 +60,47 @@ void drmcg_unbind(void)
 }
 EXPORT_SYMBOL(drmcg_unbind);
 
+/* caller must hold dev->drmcg_mutex */
+static inline int init_drmcg_single(struct drmcg *drmcg, struct drm_device *dev)
+{
+	int minor = dev->primary->index;
+	struct drmcg_device_resource *ddr = drmcg->dev_resources[minor];
+
+	if (ddr == NULL) {
+		ddr = kzalloc(sizeof(struct drmcg_device_resource),
+			GFP_KERNEL);
+
+		if (!ddr)
+			return -ENOMEM;
+	}
+
+	drmcg->dev_resources[minor] = ddr;
+
+	/* set defaults here */
+
+	return 0;
+}
+
+static inline void drmcg_update_cg_tree(struct drm_device *dev)
+{
+	struct cgroup_subsys_state *pos;
+	struct drmcg *child;
+
+	if (root_drmcg == NULL)
+		return;
+
+	/* init cgroups created before registration (i.e. root cgroup) */
+
+	/* use cgroup_mutex instead of rcu_read_lock because
+	 * init_drmcg_single has alloc which may sleep */
+	mutex_lock(&cgroup_mutex);
+	css_for_each_descendant_pre(pos, &root_drmcg->css) {
+		child = css_to_drmcg(pos);
+		init_drmcg_single(child, dev);
+	}
+	mutex_unlock(&cgroup_mutex);
+}
+
 /**
  * drmcg_register_dev - register a DRM device for usage in drm cgroup
  * @dev: DRM device
@@ -71,6 +118,13 @@ void drmcg_register_dev(struct drm_device *dev)
 
 	mutex_lock(&drmcg_mutex);
 	set_bit(dev->primary->index, known_devs);
+
+	if (dev->driver->drmcg_custom_init)
+	{
+		dev->driver->drmcg_custom_init(dev, &dev->drmcg_props);
+
+		drmcg_update_cg_tree(dev);
+	}
 	mutex_unlock(&drmcg_mutex);
 }
 EXPORT_SYMBOL(drmcg_register_dev);
@@ -137,23 +191,61 @@ static int drm_minor_for_each(int (*fn)(int id, void *p, void *data),
 	return rc;
 }
 
+static int drmcg_css_free_fn(int id, void *ptr, void *data)
+{
+	struct drm_minor *minor = ptr;
+	struct drmcg *drmcg = data;
+
+	if (minor->type != DRM_MINOR_PRIMARY)
+		return 0;
+
+	kfree(drmcg->dev_resources[minor->index]);
+
+	return 0;
+}
+
 static void drmcg_css_free(struct cgroup_subsys_state *css)
 {
 	struct drmcg *drmcg = css_to_drmcg(css);
 
+	drm_minor_for_each(&drmcg_css_free_fn, drmcg);
+
 	kfree(drmcg);
 }
 
+static int init_drmcg_fn(int id, void *ptr, void *data)
+{
+	struct drm_minor *minor = ptr;
+	struct drmcg *drmcg = data;
+	int rc;
+
+	if (minor->type != DRM_MINOR_PRIMARY)
+		return 0;
+
+	mutex_lock(&minor->dev->drmcg_mutex);
+	rc = init_drmcg_single(drmcg, minor->dev);
+	mutex_unlock(&minor->dev->drmcg_mutex);
+
+	return rc;
+}
+
 static struct cgroup_subsys_state *
 drmcg_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct drmcg *parent = css_to_drmcg(parent_css);
 	struct drmcg *drmcg;
+	int rc;
 
 	drmcg = kzalloc(sizeof(struct drmcg), GFP_KERNEL);
 	if (!drmcg)
 		return ERR_PTR(-ENOMEM);
 
+	rc = drm_minor_for_each(&init_drmcg_fn, drmcg);
+	if (rc) {
+		drmcg_css_free(&drmcg->css);
+		return ERR_PTR(rc);
+	}
+
 	if (!parent)
 		root_drmcg = drmcg;
 
@@ -171,3 +263,16 @@ struct cgroup_subsys drm_cgrp_subsys = {
 	.legacy_cftypes	= files,
 	.dfl_cftypes	= files,
 };
+
+/**
+ * drmcg_device_early_init - initialize device specific resources for DRM cgroups
+ * @dev: the target DRM device
+ *
+ * Allocate and initialize device specific resources for existing DRM cgroups.
+ * Typically only the root cgroup exists before the initialization of @dev.
+ */
+void drmcg_device_early_init(struct drm_device *dev)
+{
+	drmcg_update_cg_tree(dev);
+}
+EXPORT_SYMBOL(drmcg_device_early_init);
-- 
2.25.0


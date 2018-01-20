From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 6/9] drm: Add cgroup helper library
Date: Fri, 19 Jan 2018 17:51:38 -0800
Message-ID: <20180120015141.10118-7-matthew.d.roper@intel.com>
References: <20180120015141.10118-1-matthew.d.roper@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180120015141.10118-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Most DRM drivers will want to handle the CGROUP_SETPARAM ioctl by looking up a
driver-specific per-cgroup data structure (or allocating a new one) and storing
the supplied parameter value into the data structure (possibly after doing some
checking and sanitization on the provided value).  Let's provide a helper
library for drivers that will take care of the details of storing per-cgroup
data structures in a hashtable and destroying those structures if/when the
cgroup itself is removed.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/Makefile            |   1 +
 drivers/gpu/drm/drm_cgroup_helper.c | 244 ++++++++++++++++++++++++++++++++++++
 include/drm/drm_cgroup_helper.h     | 153 ++++++++++++++++++++++
 include/drm/drm_device.h            |   5 +
 4 files changed, 403 insertions(+)
 create mode 100644 drivers/gpu/drm/drm_cgroup_helper.c
 create mode 100644 include/drm/drm_cgroup_helper.h

diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 351f3817bc27..45cd58d66658 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -31,6 +31,7 @@ drm-$(CONFIG_AGP) += drm_agpsupport.o
 drm-$(CONFIG_DEBUG_FS) += drm_debugfs.o drm_debugfs_crc.o
 drm-$(CONFIG_DRM_LOAD_EDID_FIRMWARE) += drm_edid_load.o
 drm-$(CONFIG_CGROUPS) += drm_cgroup.o
+drm-$(CONFIG_CGROUPS) += drm_cgroup_helper.o
 
 drm_kms_helper-y := drm_crtc_helper.o drm_dp_helper.o drm_probe_helper.o \
 		drm_plane_helper.o drm_dp_mst_topology.o drm_atomic_helper.o \
diff --git a/drivers/gpu/drm/drm_cgroup_helper.c b/drivers/gpu/drm/drm_cgroup_helper.c
new file mode 100644
index 000000000000..b62843456f63
--- /dev/null
+++ b/drivers/gpu/drm/drm_cgroup_helper.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright (c) 2018 Intel Corporation
+ *
+ * Permission to use, copy, modify, distribute, and sell this software and its
+ * documentation for any purpose is hereby granted without fee, provided that
+ * the above copyright notice appear in all copies and that both that copyright
+ * notice and this permission notice appear in supporting documentation, and
+ * that the name of the copyright holders not be used in advertising or
+ * publicity pertaining to distribution of the software without specific,
+ * written prior permission.  The copyright holders make no representations
+ * about the suitability of this software for any purpose.  It is provided "as
+ * is" without express or implied warranty.
+ *
+ * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
+ * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
+ * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
+ * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
+ * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
+ * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
+ * OF THIS SOFTWARE.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_cgroup_helper.h>
+
+/**
+ * DOC: cgroup helper library
+ *
+ * This helper library provides implementations for the DRM cgroup parameter
+ * entry points.  Most drivers will wish to store driver-specific data
+ * associated with individual cgroups; this helper will manage the storage
+ * and lookup of these data structures and will ensure that they are properly
+ * destroyed when the corresponding cgroup is destroyed.
+ *
+ * This helper library should be initialized by calling drm_cgrp_helper_init()
+ * and torn down (on driver unload) by calling drm_cgrp_helper_shutdown().
+ * Drivers wishing to make use of this helper library should subclass the
+ * &drm_cgroup_helper_data structure to store values for any driver-specific
+ * cgroup parameters and provide implementations of at least
+ * &drm_cgroup_helper.alloc_params, &drm_cgroup_helper.update_param, and
+ * &drm_cgroup_helper.read_param.
+ */
+
+/**
+ * drm_cgrp_helper_set_param - set parameter value for cgroup
+ * @dev: DRM device
+ * @cgrp: cgroup to set parameter for
+ * @param: parameter to set
+ * @val: value to assign to parameter
+ *
+ * Provides a default handler for the CGROUP_SETPARAM ioctl.  At this time
+ * parameters may only be set on cgroups in the v2 hierarchy.
+ *
+ * RETURNS:
+ * Zero on success, error code on failure
+ */
+int
+drm_cgrp_helper_set_param(struct drm_device *dev,
+			  struct cgroup *cgrp,
+			  uint64_t param,
+			  int64_t val)
+{
+	struct drm_cgroup_helper *helper = dev->cgroup_helper;
+	struct drm_cgroup_helper_data *data;
+	int ret;
+
+	if (WARN_ON(!helper))
+		return -EINVAL;
+
+	mutex_lock(&helper->hash_mutex);
+
+	/*
+	 * Search for an existing parameter set for this cgroup and update
+	 * it if found.
+	 */
+	hash_for_each_possible(helper->param_hash, data, node, cgrp->id) {
+		if (data->cgroup == cgrp) {
+			DRM_DEBUG("Updating existing data for cgroup %d\n",
+				  cgrp->id);
+			ret = helper->update_param(data, param, val);
+			goto out;
+		}
+	}
+
+	/*
+	 * Looks like this is the first time we've tried to set a parameter
+	 * on this cgroup.  We need to allocate a new parameter storage
+	 * structure.  Note that we'll still allocate the structure and
+	 * associate it with the cgroup even if the setting of the specific
+	 * parameter fails.
+	 */
+	DRM_DEBUG("Allocating new data for cgroup %d\n", cgrp->id);
+	data = helper->alloc_params();
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
+		goto out;
+	}
+
+	data->dev = dev;
+	data->cgroup = cgrp;
+	hash_add(helper->param_hash, &data->node, cgrp->id);
+
+	ret = helper->update_param(data, param, val);
+
+out:
+	mutex_unlock(&helper->hash_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(drm_cgrp_helper_set_param);
+
+/**
+ * drm_cgrp_helper_get_param - retrieve parameter value for cgroup
+ * @dev: DRM device
+ * @cgrp: cgroup to set parameter for
+ * @param: parameter to retrieve
+ * @val: parameter value returned by reference
+ *
+ * Helper function that drivers may call to lookup a parameter associated
+ * with a specific cgroup.
+ *
+ * RETURNS:
+ * If a parameter value is found for this cgroup, returns zero and sets
+ * 'val' to the value retrieved.  If no parameters have been explicitly
+ * set for this cgroup in the past, returns -EINVAL and does not update
+ * 'val.'  If other errors occur, a negative error code will be returned
+ * and 'val' will not be modified.
+ */
+int
+drm_cgrp_helper_get_param(struct drm_device *dev,
+			  struct cgroup *cgrp,
+			  uint64_t param,
+			  int64_t *val)
+{
+	struct drm_cgroup_helper *helper = dev->cgroup_helper;
+	struct drm_cgroup_helper_data *data;
+	int ret;
+
+	if (WARN_ON(!helper))
+		return -EINVAL;
+
+	mutex_lock(&helper->hash_mutex);
+
+	ret = -EINVAL;
+	hash_for_each_possible(helper->param_hash, data, node, cgrp->id) {
+		if (data->cgroup == cgrp) {
+			ret = helper->read_param(data, param, val);
+			break;
+		}
+	}
+
+	mutex_unlock(&helper->hash_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(drm_cgrp_helper_get_param);
+
+/*
+ * Notifier callback for cgroup destruction.  Search for any driver-specific
+ * data associated with the cgroup and free it.
+ */
+static int
+cgrp_destroyed(struct notifier_block *nb,
+	       unsigned long val,
+	       void *ptr)
+{
+	struct cgroup *cgrp = ptr;
+	struct drm_cgroup_helper *helper = container_of(nb,
+							struct drm_cgroup_helper,
+							cgrp_notifier);
+	struct drm_cgroup_helper_data *data;
+	struct hlist_node *tmp;
+
+	mutex_lock(&helper->hash_mutex);
+
+	hash_for_each_possible_safe(helper->param_hash, data, tmp, node,
+				    cgrp->id) {
+		if (data->cgroup == cgrp) {
+			if (helper->remove_params)
+				helper->remove_params(data);
+			else
+				kfree(data);
+
+			DRM_DEBUG("Destroyed DRM parameters for cgroup %d\n",
+				  cgrp->id);
+
+			break;
+		}
+	}
+
+	mutex_unlock(&helper->hash_mutex);
+
+	return 0;
+}
+
+/**
+ * drm_cgrp_helper_init - initialize cgroup helper library
+ * @dev: DRM device
+ *
+ * Drivers that wish to make use of the cgroup helper library should
+ * call this function during driver load.
+ */
+void
+drm_cgrp_helper_init(struct drm_device *dev,
+		     struct drm_cgroup_helper *helper)
+{
+	dev->cgroup_helper = helper;
+	helper->dev = dev;
+
+	hash_init(helper->param_hash);
+	mutex_init(&helper->hash_mutex);
+
+	helper->cgrp_notifier.notifier_call = cgrp_destroyed;
+	blocking_notifier_chain_register(&cgroup_destroy_notifier_list,
+					 &helper->cgrp_notifier);
+}
+EXPORT_SYMBOL(drm_cgrp_helper_init);
+
+/**
+ * drm_cgrp_helper_shutdown - tear down cgroup helper library
+ * @helper: cgroup helper structure
+ *
+ * Drivers making use of the cgroup helper library should call this function
+ * when unloaded.
+ */
+void
+drm_cgrp_helper_shutdown(struct drm_cgroup_helper *helper)
+{
+	struct drm_cgroup_helper_data *data;
+	struct hlist_node *tmp;
+	int i;
+
+	mutex_lock(&helper->hash_mutex);
+	hash_for_each_safe(helper->param_hash, i, tmp, data, node) {
+		hash_del(&data->node);
+		if (helper->remove_params)
+			helper->remove_params(data);
+		else
+			kfree(data);
+	}
+	mutex_unlock(&helper->hash_mutex);
+
+	blocking_notifier_chain_unregister(&cgroup_destroy_notifier_list,
+					   &helper->cgrp_notifier);
+}
+EXPORT_SYMBOL(drm_cgrp_helper_shutdown);
diff --git a/include/drm/drm_cgroup_helper.h b/include/drm/drm_cgroup_helper.h
new file mode 100644
index 000000000000..435973fadd32
--- /dev/null
+++ b/include/drm/drm_cgroup_helper.h
@@ -0,0 +1,153 @@
+/*
+ * Copyright (c) 2018 Intel Corporation
+ *
+ * Permission to use, copy, modify, distribute, and sell this software and its
+ * documentation for any purpose is hereby granted without fee, provided that
+ * the above copyright notice appear in all copies and that both that copyright
+ * notice and this permission notice appear in supporting documentation, and
+ * that the name of the copyright holders not be used in advertising or
+ * publicity pertaining to distribution of the software without specific,
+ * written prior permission.  The copyright holders make no representations
+ * about the suitability of this software for any purpose.  It is provided "as
+ * is" without express or implied warranty.
+ *
+ * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
+ * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
+ * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
+ * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
+ * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
+ * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
+ * OF THIS SOFTWARE.
+ */
+
+#ifndef __DRM_CGROUP_HELPER_H__
+
+#include <linux/cgroup.h>
+#include <linux/hashtable.h>
+
+#ifdef CONFIG_CGROUPS
+
+/**
+ * struct drm_cgroup_helper_data - storage of cgroup-specific information
+ * @dev: DRM device
+ * @node: hashtable node
+ * @cgroup: individual cgroup that this structure instance is associated with
+ *
+ * Drivers should subclass this structure and add fields for all parameters
+ * that they wish to track on a per-cgroup basis.  The cgroup helper library
+ * will allocate a new instance of this structure the first time the
+ * CGROUP_SETPARAM ioctl is called for a cgroup and will destroy this structure
+ * if the corresponding cgroup is destroyed or if the DRM driver is unloaded.
+ */
+struct drm_cgroup_helper_data {
+	struct drm_device *dev;
+	struct hlist_node node;
+	struct cgroup *cgroup;
+};
+
+/**
+ * struct drm_cgroup_helper - main cgroup helper data structure
+ * @dev: DRM device
+ * @param_hash: hashtable used to store per-cgroup parameter data
+ * @hash_mutex: mutex to protect access to hash_mutex
+ * @cgrp_notifier: blocking notifier for cgroup destruction
+ */
+struct drm_cgroup_helper {
+	struct drm_device *dev;
+
+	DECLARE_HASHTABLE(param_hash, 5);
+	struct mutex hash_mutex;
+
+	struct notifier_block cgrp_notifier;
+
+	/**
+	 * @alloc_params:
+	 *
+	 * Driver callback to allocate driver-specific parameter data
+	 * associated with a single cgroup.  This callback will be called if
+	 * CGROUP_SETPARAM is issued for a cgroup that does not already have
+	 * driver-specific storage allocated.
+	 *
+	 * This callback is mandatory.
+	 *
+	 * RETURNS:
+	 *
+	 * The driver should allocate and return a driver-specific subclass
+	 * of drm_cgroup_helper_data.  Returns -ENOMEM on allocation failure.
+	 */
+	struct drm_cgroup_helper_data *(*alloc_params)(void);
+
+	/**
+	 * @update_param:
+	 *
+	 * Driver callback to update a parameter's value in a specific
+	 * cgroup's driver-side storage structure.
+	 *
+	 * This callback is mandatory.
+	 *
+	 * RETURNS:
+	 *
+	 * The driver should return 0 on success or a negative error code
+	 * on failure.
+	 */
+	int (*update_param)(struct drm_cgroup_helper_data *data,
+			    uint64_t param, int64_t val);
+
+	/**
+	 * @read_param:
+	 *
+	 * Driver callback to read a parameter's value from a specific
+	 * cgroup's driver-side storage structure.  If successful, the
+	 * parameter val will be updated with the appropriate value.
+	 *
+	 * This callback is mandatory.
+	 *
+	 * RETURNS:
+	 *
+	 * The driver should return 0 on success or a negative error code
+	 * on failure.
+	 */
+	int (*read_param)(struct drm_cgroup_helper_data *data,
+			  uint64_t param, int64_t *val);
+
+	/**
+	 * @remove_params:
+	 *
+	 * Driver callback to reap the driver-specific data structure
+	 * after the corresponding cgroup has been removed.
+	 *
+	 * This callback is optional.  If not provided, the helper library
+	 * will call kfree() on the driver-specific structure.
+	 */
+	void (*remove_params)(struct drm_cgroup_helper_data *data);
+};
+
+
+void drm_cgrp_helper_init(struct drm_device *dev,
+			  struct drm_cgroup_helper *helper);
+void drm_cgrp_helper_shutdown(struct drm_cgroup_helper *helper);
+int drm_cgrp_helper_set_param(struct drm_device *dev,
+			      struct cgroup *cgrp,
+			      uint64_t param,
+			      int64_t val);
+int drm_cgrp_helper_get_param(struct drm_device *dev,
+			      struct cgroup *cgrp,
+			      uint64_t param,
+			      int64_t *val);
+
+#else /* CGROUPS */
+
+void drm_cgrp_helper_init(struct drm_device *dev) {}
+void drm_cgrp_helper_shutdown(struct drm_device *dev) {}
+int drm_cgrp_helper_set_param(struct drm_device *dev,
+			      struct cgroup *cgrp,
+			      uint64_t param,
+			      int64_t val) { return -EINVAL; }
+int drm_cgrp_helper_get_param(struct drm_device *dev,
+			      struct cgroup *cgrp,
+			      uint64_t param,
+			      int64_t *val) { return -EINVAL; }
+
+#endif
+
+#endif
diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
index 6eee7bbee602..609c1528d681 100644
--- a/include/drm/drm_device.h
+++ b/include/drm/drm_device.h
@@ -201,6 +201,11 @@ struct drm_device {
 	 * @cgroup: Per-driver cgroup handlers.
 	 */
 	struct drm_cgroup_funcs *cgroup;
+
+	/**
+	 * @cgrp_helper: cgroup helper handlers and data
+	 */
+	struct drm_cgroup_helper *cgroup_helper;
 #endif /* CONFIG_CGROUPS */
 };
 
-- 
2.14.3

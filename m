From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 07/11] drm, cgroup: Add total GEM buffer allocation limit
Date: Wed, 26 Feb 2020 14:01:48 -0500
Message-ID: <20200226190152.16131-8-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
 <20200226190152.16131-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtbIUCcTEiB8r0n5RAMV9tMcF6GnAvzY3cASx+IKURY=;
 b=y7I620llbdPyqeDCZVflQsR5Az+01WIJSNOa2yO4Ma9KoomvHIwlUQ/p/An1Wf2zT1muXlsvvv8cHcxkN5qD/orj5l5cU2ozNPIH3P2pOBKdH0rUG0KaY0dXzJm5sReTXfGYaQnc/ra4xN7ozusuUovf8p2+PIr+zkcsDzVVnVU=
In-Reply-To: <20200226190152.16131-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

The drm resource being limited here is the GEM buffer objects.  User
applications allocate and free these buffers.  In addition, a process
can allocate a buffer and share it with another process.  The consumer
of a shared buffer can also outlive the allocator of the buffer.

For the purpose of cgroup accounting and limiting, ownership of the
buffer is deemed to be the cgroup for which the allocating process
belongs to.  There is one cgroup limit per drm device.

The limiting functionality is added to the previous stats collection
function.  The drm_gem_private_object_init is modified to have a return
value to allow failure due to cgroup limit.

The try_chg function only fails if the DRM cgroup properties has
limit_enforced set to true for the DRM device.  This is to allow the DRM
cgroup controller to collect usage stats without enforcing the limits.

gpu.buffer.default
        A read-only flat-keyed file which exists on the root cgroup.
        Each entry is keyed by the drm device's major:minor.

        Default limits on the total GEM buffer allocation in bytes.

gpu.buffer.max
        A read-write flat-keyed file which exists on all cgroups.  Each
        entry is keyed by the drm device's major:minor.

        Per device limits on the total GEM buffer allocation in byte.
        This is a hard limit.  Attempts in allocating beyond the cgroup
        limit will result in ENOMEM.  Shorthand understood by memparse
        (such as k, m, g) can be used.

        Set allocation limit for /dev/dri/card1 to 1GB
        echo "226:1 1g" > gpu.buffer.total.max

        Set allocation limit for /dev/dri/card0 to 512MB
        echo "226:0 512m" > gpu.buffer.total.max

Change-Id: Id3265bbd0fafe84a16b59617df79bd32196160be
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst    |  21 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |  19 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |   6 +-
 drivers/gpu/drm/drm_gem.c                  |  11 +-
 include/drm/drm_cgroup.h                   |   8 +-
 include/drm/drm_gem.h                      |   2 +-
 include/linux/cgroup_drm.h                 |   1 +
 kernel/cgroup/drm.c                        | 227 ++++++++++++++++++++-
 8 files changed, 278 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 065f2b52da57..f2d7abf5c783 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2087,6 +2087,27 @@ GPU Interface Files
 
 	Total number of GEM buffer allocated.
 
+  gpu.buffer.default
+	A read-only flat-keyed file which exists on the root cgroup.
+	Each entry is keyed by the drm device's major:minor.
+
+	Default limits on the total GEM buffer allocation in bytes.
+
+  gpu.buffer.max
+	A read-write flat-keyed file which exists on all cgroups.  Each
+	entry is keyed by the drm device's major:minor.
+
+	Per device limits on the total GEM buffer allocation in byte.
+	This is a hard limit.  Attempts in allocating beyond the cgroup
+	limit will result in ENOMEM.  Shorthand understood by memparse
+	(such as k, m, g) can be used.
+
+	Set allocation limit for /dev/dri/card1 to 1GB
+	echo "226:1 1g" > gpu.buffer.total.max
+
+	Set allocation limit for /dev/dri/card0 to 512MB
+	echo "226:0 512m" > gpu.buffer.total.max
+
 GEM Buffer Ownership
 ~~~~~~~~~~~~~~~~~~~~
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 6e1faf8a2bca..171397708855 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1413,6 +1413,23 @@ amdgpu_get_crtc_scanout_position(struct drm_device *dev, unsigned int pipe,
 						  stime, etime, mode);
 }
 
+#ifdef CONFIG_CGROUP_DRM
+
+static void amdgpu_drmcg_custom_init(struct drm_device *dev,
+	struct drmcg_props *props)
+{
+	props->limit_enforced = true;
+}
+
+#else
+
+static void amdgpu_drmcg_custom_init(struct drm_device *dev,
+	struct drmcg_props *props)
+{
+}
+
+#endif /* CONFIG_CGROUP_DRM */
+
 static struct drm_driver kms_driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_ATOMIC |
@@ -1444,6 +1461,8 @@ static struct drm_driver kms_driver = {
 	.gem_prime_vunmap = amdgpu_gem_prime_vunmap,
 	.gem_prime_mmap = amdgpu_gem_prime_mmap,
 
+	.drmcg_custom_init = amdgpu_drmcg_custom_init,
+
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
 	.date = DRIVER_DATE,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 5766d20f29d8..4d08ccbc541a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -34,6 +34,7 @@
 
 #include <drm/amdgpu_drm.h>
 #include <drm/drm_cache.h>
+#include <drm/drm_cgroup.h>
 #include "amdgpu.h"
 #include "amdgpu_trace.h"
 #include "amdgpu_amdkfd.h"
@@ -551,7 +552,10 @@ static int amdgpu_bo_do_create(struct amdgpu_device *adev,
 	bo = kzalloc(sizeof(struct amdgpu_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
-	drm_gem_private_object_init(adev->ddev, &bo->tbo.base, size);
+	if (!drm_gem_private_object_init(adev->ddev, &bo->tbo.base, size)) {
+		kfree(bo);
+		return -ENOMEM;
+	}
 	INIT_LIST_HEAD(&bo->shadow_list);
 	bo->vm_bo = NULL;
 	bo->preferred_domains = bp->preferred_domain ? bp->preferred_domain :
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 589f8f6bde2c..30adf730da0f 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -150,11 +150,17 @@ EXPORT_SYMBOL(drm_gem_object_init);
  * no GEM provided backing store. Instead the caller is responsible for
  * backing the object and handling it.
  */
-void drm_gem_private_object_init(struct drm_device *dev,
+bool drm_gem_private_object_init(struct drm_device *dev,
 				 struct drm_gem_object *obj, size_t size)
 {
 	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
 
+	obj->drmcg = drmcg_get(current);
+	if (!drmcg_try_chg_bo_alloc(obj->drmcg, dev, size)) {
+		drmcg_put(obj->drmcg);
+		obj->drmcg = NULL;
+		return false;
+	}
 	obj->dev = dev;
 	obj->filp = NULL;
 
@@ -167,8 +173,7 @@ void drm_gem_private_object_init(struct drm_device *dev,
 
 	drm_vma_node_reset(&obj->vma_node);
 
-	obj->drmcg = drmcg_get(current);
-	drmcg_chg_bo_alloc(obj->drmcg, dev, size);
+	return true;
 }
 EXPORT_SYMBOL(drm_gem_private_object_init);
 
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index 1eb3012e16a1..2783e56690db 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -13,6 +13,9 @@
  * of storing per device defaults
  */
 struct drmcg_props {
+	bool			limit_enforced;
+
+	s64			bo_limits_total_allocated_default;
 };
 
 void drmcg_bind(struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
@@ -26,7 +29,7 @@ void drmcg_unregister_dev(struct drm_device *dev);
 
 void drmcg_device_early_init(struct drm_device *device);
 
-void drmcg_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
+bool drmcg_try_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
 		size_t size);
 
 void drmcg_unchg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
@@ -59,9 +62,10 @@ static inline void drmcg_device_early_init(struct drm_device *device)
 {
 }
 
-static inline void drmcg_chg_bo_alloc(struct drmcg *drmcg,
+static inline bool drmcg_try_chg_bo_alloc(struct drmcg *drmcg,
 		struct drm_device *dev,	size_t size)
 {
+	return true;
 }
 
 static inline void drmcg_unchg_bo_alloc(struct drmcg *drmcg,
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 9c588c329da0..ef073a5e7d67 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -352,7 +352,7 @@ void drm_gem_object_release(struct drm_gem_object *obj);
 void drm_gem_object_free(struct kref *kref);
 int drm_gem_object_init(struct drm_device *dev,
 			struct drm_gem_object *obj, size_t size);
-void drm_gem_private_object_init(struct drm_device *dev,
+bool drm_gem_private_object_init(struct drm_device *dev,
 				 struct drm_gem_object *obj, size_t size);
 void drm_gem_vm_open(struct vm_area_struct *vma);
 void drm_gem_vm_close(struct vm_area_struct *vma);
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index 103868d972d0..71023654fb77 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -26,6 +26,7 @@ enum drmcg_res_type {
 struct drmcg_device_resource {
 	/* for per device stats */
 	s64			bo_stats_total_allocated;
+	s64			bo_limits_total_allocated;
 
 	s64			bo_stats_peak_allocated;
 
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 5a700833a304..4b19e533941d 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -37,6 +37,8 @@ static void (*put_drm_dev)(struct drm_device *dev);
 
 enum drmcg_file_type {
 	DRMCG_FTYPE_STATS,
+	DRMCG_FTYPE_LIMIT,
+	DRMCG_FTYPE_DEFAULT,
 };
 
 /**
@@ -90,6 +92,8 @@ static inline int init_drmcg_single(struct drmcg *drmcg, struct drm_device *dev)
 	drmcg->dev_resources[minor] = ddr;
 
 	/* set defaults here */
+	ddr->bo_limits_total_allocated =
+		dev->drmcg_props.bo_limits_total_allocated_default;
 
 	return 0;
 }
@@ -289,6 +293,38 @@ static void drmcg_print_stats(struct drmcg_device_resource *ddr,
 	}
 }
 
+static void drmcg_print_limits(struct drmcg_device_resource *ddr,
+		struct seq_file *sf, enum drmcg_res_type type)
+{
+	if (ddr == NULL) {
+		seq_puts(sf, "\n");
+		return;
+	}
+
+	switch (type) {
+	case DRMCG_TYPE_BO_TOTAL:
+		seq_printf(sf, "%lld\n", ddr->bo_limits_total_allocated);
+		break;
+	default:
+		seq_puts(sf, "\n");
+		break;
+	}
+}
+
+static void drmcg_print_default(struct drmcg_props *props,
+		struct seq_file *sf, enum drmcg_res_type type)
+{
+	switch (type) {
+	case DRMCG_TYPE_BO_TOTAL:
+		seq_printf(sf, "%lld\n",
+			props->bo_limits_total_allocated_default);
+		break;
+	default:
+		seq_puts(sf, "\n");
+		break;
+	}
+}
+
 static int drmcg_seq_show_fn(int id, void *ptr, void *data)
 {
 	struct drm_minor *minor = ptr;
@@ -311,6 +347,12 @@ static int drmcg_seq_show_fn(int id, void *ptr, void *data)
 	case DRMCG_FTYPE_STATS:
 		drmcg_print_stats(ddr, sf, type);
 		break;
+	case DRMCG_FTYPE_LIMIT:
+		drmcg_print_limits(ddr, sf, type);
+		break;
+	case DRMCG_FTYPE_DEFAULT:
+		drmcg_print_default(&minor->dev->drmcg_props, sf, type);
+		break;
 	default:
 		seq_puts(sf, "\n");
 		break;
@@ -324,6 +366,130 @@ int drmcg_seq_show(struct seq_file *sf, void *v)
 	return drm_minor_for_each(&drmcg_seq_show_fn, sf);
 }
 
+static void drmcg_pr_cft_err(const struct drmcg *drmcg,
+		int rc, const char *cft_name, int minor)
+{
+	pr_err("drmcg: error parsing %s, minor %d, rc %d ",
+			cft_name, minor, rc);
+	pr_cont_cgroup_name(drmcg->css.cgroup);
+	pr_cont("\n");
+}
+
+static int drmcg_process_limit_s64_val(char *sval, bool is_mem,
+			s64 def_val, s64 max_val, s64 *ret_val)
+{
+	int rc = strcmp("max", sval);
+
+
+	if (!rc)
+		*ret_val = max_val;
+	else {
+		rc = strcmp("default", sval);
+
+		if (!rc)
+			*ret_val = def_val;
+	}
+
+	if (rc) {
+		if (is_mem) {
+			*ret_val = memparse(sval, NULL);
+			rc = 0;
+		} else {
+			rc = kstrtoll(sval, 0, ret_val);
+		}
+	}
+
+	if (*ret_val > max_val)
+		rc = -EINVAL;
+
+	return rc;
+}
+
+/**
+ * drmcg_limit_write - parse cgroup interface files to obtain user config
+ *
+ * Minimal value check to keep track of user intent.  For example, user
+ * can specify limits greater than the values allowed by the parents.
+ * This way, the user configuration is kept and comes into effect if and
+ * when parents' limits are relaxed.
+ */
+static ssize_t drmcg_limit_write(struct kernfs_open_file *of, char *buf,
+		size_t nbytes, loff_t off)
+{
+	struct drmcg *drmcg = css_to_drmcg(of_css(of));
+	enum drmcg_res_type type =
+		DRMCG_CTF_PRIV2RESTYPE(of_cft(of)->private);
+	char *cft_name = of_cft(of)->name;
+	char *limits = strstrip(buf);
+	struct drmcg_device_resource *ddr;
+	struct drmcg_props *props;
+	struct drm_minor *dm;
+	char *line;
+	char sattr[256];
+	s64 val;
+	int rc;
+	int minor;
+
+	while (limits != NULL) {
+		line =  strsep(&limits, "\n");
+
+		if (sscanf(line,
+			__stringify(DRM_MAJOR)":%u %255[^\t\n]",
+							&minor, sattr) != 2) {
+			pr_err("drmcg: error parsing %s ", cft_name);
+			pr_cont_cgroup_name(drmcg->css.cgroup);
+			pr_cont("\n");
+
+			continue;
+		}
+
+		mutex_lock(&drmcg_mutex);
+		if (acquire_drm_minor)
+			dm = acquire_drm_minor(minor);
+		else
+			dm = NULL;
+		mutex_unlock(&drmcg_mutex);
+
+		if (IS_ERR_OR_NULL(dm)) {
+			pr_err("drmcg: invalid minor %d for %s ",
+					minor, cft_name);
+			pr_cont_cgroup_name(drmcg->css.cgroup);
+			pr_cont("\n");
+
+			continue;
+		}
+
+		mutex_lock(&dm->dev->drmcg_mutex);
+		ddr = drmcg->dev_resources[minor];
+		props = &dm->dev->drmcg_props;
+		switch (type) {
+		case DRMCG_TYPE_BO_TOTAL:
+			rc = drmcg_process_limit_s64_val(sattr, true,
+				props->bo_limits_total_allocated_default,
+				S64_MAX,
+				&val);
+
+			if (rc || val < 0) {
+				drmcg_pr_cft_err(drmcg, rc, cft_name, minor);
+				break;
+			}
+
+			ddr->bo_limits_total_allocated = val;
+			break;
+		default:
+			break;
+		}
+		mutex_unlock(&dm->dev->drmcg_mutex);
+
+		mutex_lock(&drmcg_mutex);
+		if (put_drm_dev)
+			put_drm_dev(dm->dev); /* release from acquire */
+		mutex_unlock(&drmcg_mutex);
+	}
+
+	return nbytes;
+}
+
 struct cftype files[] = {
 	{
 		.name = "buffer.total.stats",
@@ -331,6 +497,20 @@ struct cftype files[] = {
 		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_TOTAL,
 						DRMCG_FTYPE_STATS),
 	},
+	{
+		.name = "buffer.total.default",
+		.seq_show = drmcg_seq_show,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_TOTAL,
+						DRMCG_FTYPE_DEFAULT),
+	},
+	{
+		.name = "buffer.total.max",
+		.write = drmcg_limit_write,
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_TOTAL,
+						DRMCG_FTYPE_LIMIT),
+	},
 	{
 		.name = "buffer.peak.stats",
 		.seq_show = drmcg_seq_show,
@@ -363,12 +543,16 @@ struct cgroup_subsys gpu_cgrp_subsys = {
  */
 void drmcg_device_early_init(struct drm_device *dev)
 {
+	dev->drmcg_props.limit_enforced = false;
+
+	dev->drmcg_props.bo_limits_total_allocated_default = S64_MAX;
+
 	drmcg_update_cg_tree(dev);
 }
 EXPORT_SYMBOL(drmcg_device_early_init);
 
 /**
- * drmcg_chg_bo_alloc - charge GEM buffer usage for a device and cgroup
+ * drmcg_try_chg_bo_alloc - charge GEM buffer usage for a device and cgroup
  * @drmcg: the DRM cgroup to be charged to
  * @dev: the device the usage should be charged to
  * @size: size of the GEM buffer to be accounted for
@@ -377,29 +561,52 @@ EXPORT_SYMBOL(drmcg_device_early_init);
  * for the utilization.  This should not be called when the buffer is shared (
  * the GEM buffer's reference count being incremented.)
  */
-void drmcg_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
+bool drmcg_try_chg_bo_alloc(struct drmcg *drmcg, struct drm_device *dev,
 		size_t size)
 {
 	struct drmcg_device_resource *ddr;
 	int devIdx = dev->primary->index;
+	struct drmcg_props *props = &dev->drmcg_props;
+	struct drmcg *drmcg_cur = drmcg;
+	bool result = true;
+	s64 delta = 0;
 
 	if (drmcg == NULL)
-		return;
+		return true;
 
 	mutex_lock(&dev->drmcg_mutex);
-	for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg)) {
-		ddr = drmcg->dev_resources[devIdx];
+	if (props->limit_enforced) {
+		for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg)) {
+			ddr = drmcg->dev_resources[devIdx];
+			delta = ddr->bo_limits_total_allocated -
+					ddr->bo_stats_total_allocated;
+
+			if (delta <= 0 || size > delta) {
+				result = false;
+				break;
+			}
+		}
+	}
+
+	drmcg = drmcg_cur;
+
+	if (result || !props->limit_enforced) {
+		for ( ; drmcg != NULL; drmcg = drmcg_parent(drmcg)) {
+			ddr = drmcg->dev_resources[devIdx];
 
-		ddr->bo_stats_total_allocated += (s64)size;
+			ddr->bo_stats_total_allocated += (s64)size;
 
-		if (ddr->bo_stats_peak_allocated < (s64)size)
-			ddr->bo_stats_peak_allocated = (s64)size;
+			if (ddr->bo_stats_peak_allocated < (s64)size)
+				ddr->bo_stats_peak_allocated = (s64)size;
 
-		ddr->bo_stats_count_allocated++;
+			ddr->bo_stats_count_allocated++;
+		}
 	}
 	mutex_unlock(&dev->drmcg_mutex);
+
+	return result;
 }
-EXPORT_SYMBOL(drmcg_chg_bo_alloc);
+EXPORT_SYMBOL(drmcg_try_chg_bo_alloc);
 
 /**
  * drmcg_unchg_bo_alloc -
-- 
2.25.0


From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 09/11] drm, cgroup: Add compute as gpu cgroup resource
Date: Wed, 26 Feb 2020 14:01:50 -0500
Message-ID: <20200226190152.16131-10-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
 <20200226190152.16131-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZS7Y5c64/ZEFBwFzkh5BDxJTRdiicRP1BQpcSK8Pf4=;
 b=PIMxun9I+kyJMFzZGLPIWePdBPuyMJDae3MkHwey25jHG2DWdowd1GYYUveoGs4+gHT80yORKBy+3zlv+p9CCKqs8m31uaGVMDku0dOCpfALlCyUg6V/EbivxK7sXR19Nx59/IIQgSjxgJk2Bq0lwHRWXamiQxBKMAypfFAAYjA=
In-Reply-To: <20200226190152.16131-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

gpu.compute.weight
      A read-write flat-keyed file which exists on all cgroups.  The
      default weight is 100.  Each entry is keyed by the DRM device's
      major:minor (the primary minor).  The weights are in the range [1,
      10000] and specifies the relative amount of physical partitions
      the cgroup can use in relation to its siblings.  The partition
      concept here is analogous to the subdevice of OpenCL.

gpu.compute.effective
      A read-only nested-keyed file which exists on all cgroups.  Each
      entry is keyed by the DRM device's major:minor.

      It lists the GPU subdevices that are actually granted to this
      cgroup by its parent.  These subdevices are allowed to be used by
      tasks within the current cgroup.

      =====     ==============================================
      count     The total number of granted subdevices
      list      Enumeration of the subdevices
      =====     ==============================================

Change-Id: Idde0ef9a331fd67bb9c7eb8ef9978439e6452488
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  21 +++
 include/drm/drm_cgroup.h                |   3 +
 include/linux/cgroup_drm.h              |  16 +++
 kernel/cgroup/drm.c                     | 177 +++++++++++++++++++++++-
 4 files changed, 215 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 581343472651..f92f1f4a64d4 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2126,6 +2126,27 @@ GPU Interface Files
 	Set largest allocation for /dev/dri/card1 to 4MB
 	echo "226:1 4m" > gpu.buffer.peak.max
 
+  gpu.compute.weight
+	A read-write flat-keyed file which exists on all cgroups.  The
+	default weight is 100.  Each entry is keyed by the DRM device's
+	major:minor (the primary minor).  The weights are in the range
+	[1, 10000] and specifies the relative amount of physical partitions 
+	the cgroup can use in relation to its siblings.  The partition
+	concept here is analogous to the subdevice concept of OpenCL.
+
+  gpu.compute.effective
+  	A read-only nested-keyed file which exists on all cgroups.
+	Each entry is keyed by the DRM device's major:minor.
+
+	It lists the GPU subdevices that are actually granted to this
+	cgroup by its parent.  These subdevices are allowed to be used
+	by tasks within the current cgroup.
+
+	  =====		==============================================
+	  count		The total number of granted subdevices
+	  list		Enumeration of the subdevices
+	  =====		==============================================
+
 GEM Buffer Ownership
 ~~~~~~~~~~~~~~~~~~~~
 
diff --git a/include/drm/drm_cgroup.h b/include/drm/drm_cgroup.h
index 2b41d4d22e33..5aac47ca536f 100644
--- a/include/drm/drm_cgroup.h
+++ b/include/drm/drm_cgroup.h
@@ -17,6 +17,9 @@ struct drmcg_props {
 
 	s64			bo_limits_total_allocated_default;
 	s64			bo_limits_peak_allocated_default;
+
+	int			compute_capacity;
+	DECLARE_BITMAP(compute_slots, MAX_DRMCG_COMPUTE_CAPACITY);
 };
 
 void drmcg_bind(struct drm_minor (*(*acq_dm)(unsigned int minor_id)),
diff --git a/include/linux/cgroup_drm.h b/include/linux/cgroup_drm.h
index aba3b26718c0..fd02f59cabab 100644
--- a/include/linux/cgroup_drm.h
+++ b/include/linux/cgroup_drm.h
@@ -11,10 +11,14 @@
 /* limit defined per the way drm_minor_alloc operates */
 #define MAX_DRM_DEV (64 * DRM_MINOR_RENDER)
 
+#define MAX_DRMCG_COMPUTE_CAPACITY 256
+
 enum drmcg_res_type {
 	DRMCG_TYPE_BO_TOTAL,
 	DRMCG_TYPE_BO_PEAK,
 	DRMCG_TYPE_BO_COUNT,
+	DRMCG_TYPE_COMPUTE,
+	DRMCG_TYPE_COMPUTE_EFF,
 	__DRMCG_TYPE_LAST,
 };
 
@@ -32,6 +36,18 @@ struct drmcg_device_resource {
 	s64			bo_limits_peak_allocated;
 
 	s64			bo_stats_count_allocated;
+
+        /* compute_stg is used to calculate _eff before applying to _eff
+	 * after considering the entire hierarchy
+	 */
+	DECLARE_BITMAP(compute_stg, MAX_DRMCG_COMPUTE_CAPACITY);
+	/* user configurations */
+	s64			compute_weight;
+	/* effective compute for the cgroup after considering
+	 * relationship with other cgroup
+	 */
+	s64			compute_count_eff;
+	DECLARE_BITMAP(compute_eff, MAX_DRMCG_COMPUTE_CAPACITY);
 };
 
 /**
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 62d2a9d33d0c..2eadabebdfea 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <linux/bitmap.h>
 #include <linux/cgroup_drm.h>
 #include <drm/drm_file.h>
 #include <drm/drm_drv.h>
@@ -98,6 +99,11 @@ static inline int init_drmcg_single(struct drmcg *drmcg, struct drm_device *dev)
 	ddr->bo_limits_peak_allocated =
 		dev->drmcg_props.bo_limits_peak_allocated_default;
 
+	bitmap_copy(ddr->compute_stg, dev->drmcg_props.compute_slots,
+			MAX_DRMCG_COMPUTE_CAPACITY);
+
+	ddr->compute_weight = CGROUP_WEIGHT_DFL;
+
 	return 0;
 }
 
@@ -121,6 +127,104 @@ static inline void drmcg_update_cg_tree(struct drm_device *dev)
 	mutex_unlock(&cgroup_mutex);
 }
 
+static void drmcg_calculate_effective_compute(struct drm_device *dev,
+		const unsigned long *free_weighted,
+		struct drmcg *parent_drmcg)
+{
+	int capacity = dev->drmcg_props.compute_capacity;
+	DECLARE_BITMAP(compute_unused, MAX_DRMCG_COMPUTE_CAPACITY);
+	DECLARE_BITMAP(compute_by_weight, MAX_DRMCG_COMPUTE_CAPACITY);
+	struct drmcg_device_resource *parent_ddr;
+	struct drmcg_device_resource *ddr;
+	int minor = dev->primary->index;
+	struct cgroup_subsys_state *pos;
+	struct drmcg *child;
+	s64 weight_sum = 0;
+	s64 unused;
+
+	parent_ddr = parent_drmcg->dev_resources[minor];
+
+	/* no static cfg, use weight for calculating the effective */
+	bitmap_copy(parent_ddr->compute_stg, free_weighted, capacity);
+
+	/* calculate compute available for dist by weight for children */
+	bitmap_copy(compute_unused, parent_ddr->compute_stg, capacity);
+	unused = bitmap_weight(compute_unused, capacity);
+	css_for_each_child(pos, &parent_drmcg->css) {
+		child = css_to_drmcg(pos);
+		ddr = child->dev_resources[minor];
+
+		/* no static allocation, participate in weight dist */
+		weight_sum += ddr->compute_weight;
+	}
+
+	css_for_each_child(pos, &parent_drmcg->css) {
+		int c;
+		int p = 0;
+		child = css_to_drmcg(pos);
+		ddr = child->dev_resources[minor];
+
+		bitmap_zero(compute_by_weight, capacity);
+		for (c = ddr->compute_weight * unused / weight_sum;
+				c > 0; c--) {
+			p = find_next_bit(compute_unused, capacity, p);
+			if (p < capacity) {
+				clear_bit(p, compute_unused);
+				set_bit(p, compute_by_weight);
+			}
+		}
+
+		drmcg_calculate_effective_compute(dev, compute_by_weight, child);
+	}
+}
+
+static void drmcg_apply_effective_compute(struct drm_device *dev)
+{
+	int capacity = dev->drmcg_props.compute_capacity;
+	int minor = dev->primary->index;
+	struct drmcg_device_resource *ddr;
+	struct cgroup_subsys_state *pos;
+	struct drmcg *drmcg;
+
+	if (root_drmcg == NULL) {
+		WARN_ON(root_drmcg == NULL);
+		return;
+	}
+
+	rcu_read_lock();
+
+	/* process the entire cgroup tree from root to simplify the algorithm */
+	drmcg_calculate_effective_compute(dev, dev->drmcg_props.compute_slots,
+                                            root_drmcg);
+
+	/* apply changes to effective only if there is a change */
+	css_for_each_descendant_pre(pos, &root_drmcg->css) {
+		drmcg = css_to_drmcg(pos);
+		ddr = drmcg->dev_resources[minor];
+
+		if (!bitmap_equal(ddr->compute_stg,
+                            ddr->compute_eff, capacity)) {
+			bitmap_copy(ddr->compute_eff, ddr->compute_stg,
+                                capacity);
+			ddr->compute_count_eff =
+				bitmap_weight(ddr->compute_eff, capacity);
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void drmcg_apply_effective(enum drmcg_res_type type,
+		struct drm_device *dev, struct drmcg *changed_drmcg)
+{
+	switch (type) {
+	case DRMCG_TYPE_COMPUTE:
+		drmcg_apply_effective_compute(dev);
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  * drmcg_register_dev - register a DRM device for usage in drm cgroup
  * @dev: DRM device
@@ -143,7 +247,13 @@ void drmcg_register_dev(struct drm_device *dev)
 	{
 		dev->driver->drmcg_custom_init(dev, &dev->drmcg_props);
 
+		WARN_ON(dev->drmcg_props.compute_capacity !=
+				bitmap_weight(dev->drmcg_props.compute_slots,
+					MAX_DRMCG_COMPUTE_CAPACITY));
+
 		drmcg_update_cg_tree(dev);
+
+		drmcg_apply_effective(DRMCG_TYPE_COMPUTE, dev, root_drmcg);
 	}
 	mutex_unlock(&drmcg_mutex);
 }
@@ -297,7 +407,8 @@ static void drmcg_print_stats(struct drmcg_device_resource *ddr,
 }
 
 static void drmcg_print_limits(struct drmcg_device_resource *ddr,
-		struct seq_file *sf, enum drmcg_res_type type)
+		struct seq_file *sf, enum drmcg_res_type type,
+		struct drm_device *dev)
 {
 	if (ddr == NULL) {
 		seq_puts(sf, "\n");
@@ -311,6 +422,17 @@ static void drmcg_print_limits(struct drmcg_device_resource *ddr,
 	case DRMCG_TYPE_BO_PEAK:
 		seq_printf(sf, "%lld\n", ddr->bo_limits_peak_allocated);
 		break;
+	case DRMCG_TYPE_COMPUTE:
+		seq_printf(sf, "%lld\n", ddr->compute_weight);
+		break;
+	case DRMCG_TYPE_COMPUTE_EFF:
+		seq_printf(sf, "%s=%lld %s=%*pbl\n",
+				"count",
+				ddr->compute_count_eff,
+				"list",
+				dev->drmcg_props.compute_capacity,
+				ddr->compute_eff);
+		break;
 	default:
 		seq_puts(sf, "\n");
 		break;
@@ -358,7 +480,7 @@ static int drmcg_seq_show_fn(int id, void *ptr, void *data)
 		drmcg_print_stats(ddr, sf, type);
 		break;
 	case DRMCG_FTYPE_LIMIT:
-		drmcg_print_limits(ddr, sf, type);
+		drmcg_print_limits(ddr, sf, type, minor->dev);
 		break;
 	case DRMCG_FTYPE_DEFAULT:
 		drmcg_print_default(&minor->dev->drmcg_props, sf, type);
@@ -499,9 +621,25 @@ static ssize_t drmcg_limit_write(struct kernfs_open_file *of, char *buf,
 
 			ddr->bo_limits_peak_allocated = val;
 			break;
+		case DRMCG_TYPE_COMPUTE:
+			rc = drmcg_process_limit_s64_val(sattr, true,
+				CGROUP_WEIGHT_DFL, CGROUP_WEIGHT_MAX,
+				&val);
+
+			if (rc || val < CGROUP_WEIGHT_MIN ||
+						val > CGROUP_WEIGHT_MAX) {
+				drmcg_pr_cft_err(drmcg, rc, cft_name, minor);
+				break;
+			}
+
+			ddr->compute_weight = val;
+			break;
 		default:
 			break;
 		}
+
+		drmcg_apply_effective(type, dm->dev, drmcg);
+
 		mutex_unlock(&dm->dev->drmcg_mutex);
 
 		mutex_lock(&drmcg_mutex);
@@ -560,12 +698,44 @@ struct cftype files[] = {
 		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_BO_COUNT,
 						DRMCG_FTYPE_STATS),
 	},
+	{
+		.name = "compute.weight",
+		.seq_show = drmcg_seq_show,
+		.write = drmcg_limit_write,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_COMPUTE,
+						DRMCG_FTYPE_LIMIT),
+	},
+	{
+		.name = "compute.effective",
+		.seq_show = drmcg_seq_show,
+		.private = DRMCG_CTF_PRIV(DRMCG_TYPE_COMPUTE_EFF,
+						DRMCG_FTYPE_LIMIT),
+	},
 	{ }	/* terminate */
 };
 
+static int drmcg_online_fn(int id, void *ptr, void *data)
+{
+	struct drm_minor *minor = ptr;
+	struct drmcg *drmcg = data;
+
+	if (minor->type != DRM_MINOR_PRIMARY)
+		return 0;
+
+	drmcg_apply_effective(DRMCG_TYPE_COMPUTE, minor->dev, drmcg);
+
+	return 0;
+}
+
+static int drmcg_css_online(struct cgroup_subsys_state *css)
+{
+	return drm_minor_for_each(&drmcg_online_fn, css_to_drmcg(css));
+}
+
 struct cgroup_subsys gpu_cgrp_subsys = {
 	.css_alloc	= drmcg_css_alloc,
 	.css_free	= drmcg_css_free,
+	.css_online	= drmcg_css_online,
 	.early_init	= false,
 	.legacy_cftypes	= files,
 	.dfl_cftypes	= files,
@@ -585,6 +755,9 @@ void drmcg_device_early_init(struct drm_device *dev)
 	dev->drmcg_props.bo_limits_total_allocated_default = S64_MAX;
 	dev->drmcg_props.bo_limits_peak_allocated_default = S64_MAX;
 
+	dev->drmcg_props.compute_capacity = MAX_DRMCG_COMPUTE_CAPACITY;
+	bitmap_fill(dev->drmcg_props.compute_slots, MAX_DRMCG_COMPUTE_CAPACITY);
+
 	drmcg_update_cg_tree(dev);
 }
 EXPORT_SYMBOL(drmcg_device_early_init);
-- 
2.25.0


From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 10/11] drm, cgroup: add update trigger after limit change
Date: Wed, 26 Feb 2020 14:01:51 -0500
Message-ID: <20200226190152.16131-11-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
 <20200226190152.16131-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpbplLFkHuHULlyRgLQceVq8WbBsfo1Ixm0Kgnaxgfw=;
 b=TBwDjCjaVT982ve+94KXrgKUqBUIQzOymIyCDzHnPK1DX0hGCuTzyWasF/UBhAb2mKX2kc/lLjWepdZqqotWjvpGdesf0hN3cx4q89dmVJRs6khcBBwo1HOlSIxjLd46eetq8rviU4L4dnZJswU7sGPD7iblZcimLP/4fIwYBXE=
In-Reply-To: <20200226190152.16131-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

Before this commit, drmcg limits are updated but enforcement is delayed
until the next time the driver check against the new limit.  While this
is sufficient for certain resources, a more proactive enforcement may be
needed for other resources.

Introducing an optional drmcg_limit_updated callback for the DRM
drivers.  When defined, it will be called in two scenarios:
1) When limits are updated for a particular cgroup, the callback will be
triggered for each task in the updated cgroup.
2) When a task is migrated from one cgroup to another, the callback will
be triggered for each resource type for the migrated task.

Change-Id: I0ce7c4e5a04c31bd0f8d9853a383575d4bc9a3fa
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 include/drm/drm_drv.h | 10 ++++++++
 kernel/cgroup/drm.c   | 58 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index 1f65ac4d9bbf..e7333143e722 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -724,6 +724,16 @@ struct drm_driver {
 	void (*drmcg_custom_init)(struct drm_device *dev,
 			struct drmcg_props *props);
 
+	/**
+	 * @drmcg_limit_updated
+	 *
+	 * Optional callback
+	 */
+	void (*drmcg_limit_updated)(struct drm_device *dev,
+			struct task_struct *task,
+			struct drmcg_device_resource *ddr,
+			enum drmcg_res_type res_type);
+
 	/**
 	 * @gem_vm_ops: Driver private ops for this object
 	 *
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 2eadabebdfea..da439a351b07 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -127,6 +127,26 @@ static inline void drmcg_update_cg_tree(struct drm_device *dev)
 	mutex_unlock(&cgroup_mutex);
 }
 
+static void drmcg_limit_updated(struct drm_device *dev, struct drmcg *drmcg,
+		enum drmcg_res_type res_type)
+{
+	struct drmcg_device_resource *ddr =
+		drmcg->dev_resources[dev->primary->index];
+	struct css_task_iter it;
+	struct task_struct *task;
+
+	if (dev->driver->drmcg_limit_updated == NULL)
+		return;
+
+	css_task_iter_start(&drmcg->css.cgroup->self,
+			CSS_TASK_ITER_PROCS, &it);
+	while ((task = css_task_iter_next(&it))) {
+		dev->driver->drmcg_limit_updated(dev, task,
+				ddr, res_type);
+	}
+	css_task_iter_end(&it);
+}
+
 static void drmcg_calculate_effective_compute(struct drm_device *dev,
 		const unsigned long *free_weighted,
 		struct drmcg *parent_drmcg)
@@ -208,6 +228,8 @@ static void drmcg_apply_effective_compute(struct drm_device *dev)
                                 capacity);
 			ddr->compute_count_eff =
 				bitmap_weight(ddr->compute_eff, capacity);
+
+			drmcg_limit_updated(dev, drmcg, DRMCG_TYPE_COMPUTE);
 		}
 	}
 	rcu_read_unlock();
@@ -732,10 +754,46 @@ static int drmcg_css_online(struct cgroup_subsys_state *css)
 	return drm_minor_for_each(&drmcg_online_fn, css_to_drmcg(css));
 }
 
+static int drmcg_attach_fn(int id, void *ptr, void *data)
+{
+	struct drm_minor *minor = ptr;
+	struct task_struct *task = data;
+	struct drm_device *dev;
+
+	if (minor->type != DRM_MINOR_PRIMARY)
+		return 0;
+
+	dev = minor->dev;
+
+	if (dev->driver->drmcg_limit_updated) {
+		struct drmcg *drmcg = drmcg_get(task);
+		struct drmcg_device_resource *ddr =
+			drmcg->dev_resources[minor->index];
+		enum drmcg_res_type type;
+
+		for (type = 0; type < __DRMCG_TYPE_LAST; type++)
+			dev->driver->drmcg_limit_updated(dev, task, ddr, type);
+
+		drmcg_put(drmcg);
+	}
+
+	return 0;
+}
+
+static void drmcg_attach(struct cgroup_taskset *tset)
+{
+	struct task_struct *task;
+	struct cgroup_subsys_state *css;
+
+	cgroup_taskset_for_each(task, css, tset)
+		drm_minor_for_each(&drmcg_attach_fn, task);
+}
+
 struct cgroup_subsys gpu_cgrp_subsys = {
 	.css_alloc	= drmcg_css_alloc,
 	.css_free	= drmcg_css_free,
 	.css_online	= drmcg_css_online,
+	.attach		= drmcg_attach,
 	.early_init	= false,
 	.legacy_cftypes	= files,
 	.dfl_cftypes	= files,
-- 
2.25.0


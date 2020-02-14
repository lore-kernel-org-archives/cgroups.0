From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH 10/11] drm, cgroup: add update trigger after limit change
Date: Fri, 14 Feb 2020 10:56:49 -0500
Message-ID: <20200214155650.21203-11-Kenny.Ho@amd.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCod5hSt1K1BbXJXcf/RSS+TJFsOmI14u7cdB2jdZBE=;
 b=dFb/Wyln4S2Lzy7ma7V6qQOMWEdmNWNOvtUdLJ8UxOTWqUL6rBYoGK2iy4v3swBGGGKedfu+dhSpvKRB4km+RbU2zqyaSIrKWnasLnZaw0rmz6OabnCNAAwnBrf5CVeJdSKsCaZSJ5y23uEYLcTp4Kwq8A7Tx8MGIwJLyH0zAIQ=
In-Reply-To: <20200214155650.21203-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org
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
 kernel/cgroup/drm.c   | 59 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

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
index a4e88a3704bb..d3fa23b71f5f 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -133,6 +133,26 @@ static inline void drmcg_update_cg_tree(struct drm_device *dev)
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
 static void drmcg_calculate_effective_lgpu(struct drm_device *dev,
 		const unsigned long *free_static,
 		const unsigned long *free_weighted,
@@ -230,6 +250,8 @@ static void drmcg_apply_effective_lgpu(struct drm_device *dev)
 			bitmap_copy(ddr->lgpu_eff, ddr->lgpu_stg, capacity);
 			ddr->lgpu_count_eff =
 				bitmap_weight(ddr->lgpu_eff, capacity);
+
+			drmcg_limit_updated(dev, drmcg, DRMCG_TYPE_LGPU);
 		}
 	}
 	rcu_read_unlock();
@@ -686,7 +708,6 @@ static void drmcg_nested_limit_parse(struct kernfs_open_file *of,
 	}
 }
 
-
 /**
  * drmcg_limit_write - parse cgroup interface files to obtain user config
  *
@@ -879,10 +900,46 @@ static int drmcg_css_online(struct cgroup_subsys_state *css)
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
 struct cgroup_subsys drm_cgrp_subsys = {
 	.css_alloc	= drmcg_css_alloc,
 	.css_free	= drmcg_css_free,
 	.css_online	= drmcg_css_online,
+	.attach		= drmcg_attach,
 	.early_init	= false,
 	.legacy_cftypes	= files,
 	.dfl_cftypes	= files,
-- 
2.25.0

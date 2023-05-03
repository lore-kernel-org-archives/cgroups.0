From: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 4/4] drm/xe: Add support for the drm cgroup
Date: Wed,  3 May 2023 10:35:00 +0200
Message-ID: <20230503083500.645848-5-maarten.lankhorst@linux.intel.com>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20230503083500.645848-1-maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-xe-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add some code to implement basic support for the vram0, vram1 and stolen
memory regions.

I fear the try_charge code should probably be done inside TTM. This
code should interact with the shrinker, but for a simple RFC it's good
enough.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/gpu/drm/xe/xe_device.c             |  4 ++++
 drivers/gpu/drm/xe/xe_device_types.h       |  4 ++++
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c       | 21 +++++++++++++++++++--
 drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h |  5 +++++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 45d6e5ff47fd..f0a5af15a662 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -291,6 +291,10 @@ int xe_device_probe(struct xe_device *xe)
 	/* Allocate and map stolen after potential VRAM resize */
 	xe_ttm_stolen_mgr_init(xe);
 
+	err = drmmcg_register_device(&xe->drm, &xe->cg);
+	if (err)
+		goto err_irq_shutdown;
+
 	/*
 	 * Now that GT is initialized (TTM in particular),
 	 * we can try to init display, and inherit the initial fb.
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index 1cb404e48aaa..04b85060cbec 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -12,6 +12,8 @@
 #include <drm/drm_file.h>
 #include <drm/ttm/ttm_device.h>
 
+#include <linux/cgroup_drm.h>
+
 #include "xe_gt_types.h"
 #include "xe_platform_types.h"
 #include "xe_step_types.h"
@@ -55,6 +57,8 @@ struct xe_device {
 	/** @drm: drm device */
 	struct drm_device drm;
 
+	struct drmcgroup_device cg;
+
 	/** @info: device info */
 	struct intel_device_info {
 		/** @graphics_name: graphics IP name */
diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index 73836b9b7fed..263cd4ef7b6d 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -50,6 +50,7 @@ static int xe_ttm_vram_mgr_new(struct ttm_resource_manager *man,
 			       struct ttm_resource **res)
 {
 	struct xe_ttm_vram_mgr *mgr = to_xe_ttm_vram_mgr(man);
+	struct xe_device *xe = ttm_to_xe_device(tbo->bdev);
 	struct xe_ttm_vram_mgr_resource *vres;
 	struct drm_buddy *mm = &mgr->mm;
 	u64 size, remaining_size, min_page_size;
@@ -116,9 +117,8 @@ static int xe_ttm_vram_mgr_new(struct ttm_resource_manager *man,
 
 	mutex_lock(&mgr->lock);
 	if (lpfn <= mgr->visible_size >> PAGE_SHIFT && size > mgr->visible_avail) {
-		mutex_unlock(&mgr->lock);
 		err = -ENOSPC;
-		goto error_fini;
+		goto error_unlock;
 	}
 
 	if (place->fpfn + (size >> PAGE_SHIFT) != place->lpfn &&
@@ -129,6 +129,10 @@ static int xe_ttm_vram_mgr_new(struct ttm_resource_manager *man,
 		lpfn = max_t(unsigned long, place->fpfn + (size >> PAGE_SHIFT), lpfn);
 	}
 
+	err = drmcg_try_charge(&vres->cg, &xe->cg, mgr->mem_type, vres->base.size);
+	if (err)
+		goto error_unlock;
+
 	remaining_size = size;
 	do {
 		/*
@@ -197,6 +201,8 @@ static int xe_ttm_vram_mgr_new(struct ttm_resource_manager *man,
 
 error_free_blocks:
 	drm_buddy_free_list(mm, &vres->blocks);
+	drmcg_uncharge(vres->cg, &xe->cg, mgr->mem_type, vres->base.size);
+error_unlock:
 	mutex_unlock(&mgr->lock);
 error_fini:
 	ttm_resource_fini(man, &vres->base);
@@ -211,6 +217,7 @@ static void xe_ttm_vram_mgr_del(struct ttm_resource_manager *man,
 	struct xe_ttm_vram_mgr_resource *vres =
 		to_xe_ttm_vram_mgr_resource(res);
 	struct xe_ttm_vram_mgr *mgr = to_xe_ttm_vram_mgr(man);
+	struct xe_device *xe = ttm_to_xe_device(man->bdev);
 	struct drm_buddy *mm = &mgr->mm;
 
 	mutex_lock(&mgr->lock);
@@ -218,6 +225,7 @@ static void xe_ttm_vram_mgr_del(struct ttm_resource_manager *man,
 	mgr->visible_avail += vres->used_visible_size;
 	mutex_unlock(&mgr->lock);
 
+	drmcg_uncharge(vres->cg, &xe->cg, mgr->mem_type, vres->base.size);
 	ttm_resource_fini(man, res);
 
 	kfree(vres);
@@ -337,6 +345,15 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 	struct ttm_resource_manager *man = &mgr->manager;
 	int err;
 
+	xe->cg.regions[mem_type].size = size;
+
+	if (mem_type == XE_PL_STOLEN) {
+		xe->cg.regions[mem_type].name = "stolen";
+	} else {
+		xe->cg.regions[mem_type].name =
+			mem_type == XE_PL_VRAM0 ? "vram0" : "vram1";
+	}
+
 	man->func = &xe_ttm_vram_mgr_func;
 	mgr->mem_type = mem_type;
 	mutex_init(&mgr->lock);
diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h b/drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h
index 3d9417ff7434..232585d7ae69 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr_types.h
@@ -9,6 +9,8 @@
 #include <drm/drm_buddy.h>
 #include <drm/ttm/ttm_device.h>
 
+struct drmcgroup_state;
+
 struct xe_gt;
 
 /**
@@ -47,6 +49,9 @@ struct xe_ttm_vram_mgr_resource {
 	u64 used_visible_size;
 	/** @flags: flags associated with the resource */
 	unsigned long flags;
+
+	/** @cg: cgroup this resource is charged to */
+	struct drmcgroup_state *cg;
 };
 
 #endif
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1876396579;
	Sat, 25 Jul 2026 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784973699; cv=none; b=GC6SX9roGeaQpS7Ppin7HqzDbWb3/diOfTGvss1B7W2hR8aBKUpYQmBx8a52xEso6qSxpaVCveo4ZvnGdxDaoexO2abX6OUQPA11XsnHsq+gV8LsZSp3yTl/POKCbwNBv51rLZSNaxBYAI0jDOtZiNII9aNXSJbKNvAz97/RdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784973699; c=relaxed/simple;
	bh=8gvh4jf7C/btDDdZmeDuKTUGz6dEQF8JqLOcoLuudiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QC3DJmeMYJl6zd0as0S6MBHE3TCgxaXy9Rc3FqjkzeBKeoFu+uUA3toSqTzIlptl1VAf3kXpeHhR9zikztrug6ONIS0Lr7kzwJV25mGdLEIvRvse/ixUCjW4YvKP0tbzU+cUe5riQ/xsu2AborGXS4riO4M1e9uwXoqh2+Al7PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TfwIdKMo; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TfwIdKMo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784973698; x=1816509698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8gvh4jf7C/btDDdZmeDuKTUGz6dEQF8JqLOcoLuudiU=;
  b=TfwIdKMokD6Yu9TyxXSP/L5xkXYAA2BpjPayWamiymSwwl7c3EKQxipJ
   BGorNgPyLiVMFIgGLkEYFiyG9SN+E4n6KYR1aftEJv0O9OB+kmhZmzsHC
   6PBnyIpAm1uWsxy/CL59xYH5nMaHLdwe5jQCG4lC0SELIlLlHPiVC+SCo
   +teD/phGaU3WU/Td1LF9zZIQve6/VhwOSNb/bGpd3hYQIJTqVC9ZGGpxn
   Utf0AOxbarDBJhpPgIeZ7oOJbCzI4UiRnlmDRmNhDcQLrD3UAqc6NwihL
   4CDFIVM/YPEf7t72FEW5znt9w1iGeydJSQDCpHNOiDrcIB9DlbxqsGUUZ
   Q==;
X-CSE-ConnectionGUID: RHVXiFDER+W9STie8gq2ww==
X-CSE-MsgGUID: 9mS1niXeQXelMUbGGmdSwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85565994"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="85565994"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:38 -0700
X-CSE-ConnectionGUID: iEYUlmxjTxeID17CyTddow==
X-CSE-MsgGUID: 6I8y7BemSuaQ3GCZZ6DY/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="255014030"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.106])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:32 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	Huang Rui <ray.huang@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	dri-devel@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 6/6] drm/amdgpu: Wire up dmem cgroup reclaim for VRAM manager
Date: Sat, 25 Jul 2026 12:00:36 +0200
Message-ID: <20260725100036.2372-7-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260725100036.2372-1-thomas.hellstrom@linux.intel.com>
References: <20260725100036.2372-1-thomas.hellstrom@linux.intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Register the VRAM manager with the dmem cgroup reclaim infrastructure
so that lowering dmem.max below current VRAM usage triggers TTM
eviction rather than failing with -EBUSY.

Guard place->flags in amdgpu_ttm_bo_eviction_valuable() against NULL,
as the TTM reclaim path passes a NULL place in cgroup drain mode.

Use drmm_cgroup_register_region() so that the region is automatically
unregistered at DRM device release, after drm_dev_unplug() has already
made drm_dev_enter() return false.  The drm_dev_enter/exit guard in the
reclaim callback ensures no reclaim work touches the TTM manager after
driver unbind, closing the window between vram_mgr_fini() (called from
drm_driver.release) and the drmm cleanup that unregisters the region.

v3:
- Rebased on fix for uninitialized list and buddy allocator on the
  drmm_cgroup_register_region() error path.

v5:
- Rebased on the introduction of struct dmem_cgroup_init.
- Clear the reclaim callback in amdgpu_vram_mgr_fini() to prevent
  use-after-free if cgroup reclaim is triggered after driver unbind
  while userspace holds an open DRM file descriptor. (Sashiko-bot)
- Switch from drmm_cgroup_register_region() to the raw
  dmem_cgroup_register_region() and store the region in
  amdgpu_vram_mgr.cg_region. Call dmem_cgroup_unregister_region()
  in amdgpu_vram_mgr_fini() after ttm_resource_manager_evict_all()
  to drain in-flight reclaim callbacks, and clear man->cg afterwards.
  This is required because amdgpu's vram manager fini is called
  explicitly during driver unbind, which may precede the DRM device
  release and thus precede any drmm-based cleanup. (Sashiko-bot)

v6:
- Fix mgr->cg_region never being assigned, so
  dmem_cgroup_unregister_region() in fini silently no-ops on NULL
  and leaks the region. (Sashiko-bot)
- Reorder fini to call set_used(false) and evict_all() before
  dmem_cgroup_unregister_region(), so ttm_resource_free() can
  uncharge via man->cg during eviction; clear man->cg after
  unregister. (Sashiko-bot)

v7:
- Move dmem_cgroup_unregister_region() before the early return on
  evict_all() failure; not doing so leaves a dangling reclaim callback
  pointing to the partially-torn-down VRAM manager, causing a
  use-after-free when the cgroup later triggers reclaim. (Sashiko-bot)
- Switch back to drmm_cgroup_register_region() with a drm_dev_enter/
  exit guard in the reclaim callback (matching xe), rather than manual
  register/unregister.  drm_dev_unplug() fires before vram_mgr_fini(),
  so drm_dev_enter() returning false prevents any reclaim from touching
  the manager during teardown.  This also fixes the "vram" name
  collision on multi-GPU systems, since drmm_cgroup_register_region()
  automatically prefixes with "drm/<pci-addr>/". (Sashiko-bot)

v8:
- Move the dmem cgroup region teardown back into
  amdgpu_vram_mgr_fini(): register the region with
  dmem_cgroup_register_region() (keeping the "drm/<unique>/vram"
  prefix), store it in amdgpu_vram_mgr.cg_region, and unregister it
  explicitly after ttm_resource_manager_evict_all(). The v7
  drmm-only approach left a use-after-free on the probe-error
  teardown path: drm_dev_unplug() is not called there, so the
  drm_dev_enter() guard stays open while drm_driver.release destroys
  the manager before the drmm action unregisters the region. The
  explicit unregister drains in-flight reclaim on every teardown
  path; the drm_dev_enter() guard is kept as defense against reclaim
  after unplug. (Sashiko-bot)

v9:
- Don't leak a gpu buddy manager on cgroup init failure. (Sashiko-bot)
- Acquire a runtime PM reference (pm_runtime_get_sync/put_autosuspend)
  around the TTM reclaim call in amdgpu_vram_mgr_dmem_reclaim().
  (Sashiko-bot)

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c      |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 64 ++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h |  3 +
 3 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 7920675af1d1..b46b1d19349e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1507,7 +1507,7 @@ static bool amdgpu_ttm_bo_eviction_valuable(struct ttm_buffer_object *bo,
 	dma_resv_for_each_fence(&resv_cursor, bo->base.resv,
 				DMA_RESV_USAGE_BOOKKEEP, f) {
 		if (amdkfd_fence_check_mm(f, current->mm) &&
-		    !(place->flags & TTM_PL_FLAG_CONTIGUOUS))
+		    !(place && (place->flags & TTM_PL_FLAG_CONTIGUOUS)))
 			return false;
 	}
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 08f05c3aed1d..249f07f30951 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -24,6 +24,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/cgroup_dmem.h>
+#include <linux/pm_runtime.h>
 #include <drm/ttm/ttm_range_manager.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_buddy.h>
@@ -906,6 +907,38 @@ static const struct ttm_resource_manager_func amdgpu_vram_mgr_func = {
 	.debug	= amdgpu_vram_mgr_debug
 };
 
+static const struct dmem_cgroup_ops amdgpu_vram_mgr_dmem_ops;
+
+static int amdgpu_vram_mgr_dmem_reclaim(struct dmem_cgroup_pool_state *pool,
+					u64 target_bytes, void *priv)
+{
+	struct ttm_resource_manager *man = priv;
+	struct amdgpu_device *adev = amdgpu_ttm_adev(man->bdev);
+	int ret, idx;
+
+	if (!drm_dev_enter(adev_to_drm(adev), &idx))
+		return -ENODEV;
+
+	ret = pm_runtime_get_sync(adev_to_drm(adev)->dev);
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
+		goto out;
+	}
+
+	ret = ttm_resource_manager_dmem_reclaim(pool, target_bytes, priv);
+
+	pm_runtime_mark_last_busy(adev_to_drm(adev)->dev);
+	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
+
+out:
+	drm_dev_exit(idx);
+	return ret;
+}
+
+static const struct dmem_cgroup_ops amdgpu_vram_mgr_dmem_ops = {
+	.reclaim = amdgpu_vram_mgr_dmem_reclaim,
+};
+
 /**
  * amdgpu_vram_mgr_init - init VRAM manager and DRM MM
  *
@@ -917,6 +950,7 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
 {
 	struct amdgpu_vram_mgr *mgr = &adev->mman.vram_mgr;
 	struct ttm_resource_manager *man = &mgr->manager;
+	struct dmem_cgroup_region *cg;
 	int err;
 
 	ttm_resource_manager_init(man, &adev->mman.bdev,
@@ -933,12 +967,19 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
 	if (err)
 		return err;
 
-	man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram",
-					      &(struct dmem_cgroup_init){
+	cg = dmem_cgroup_register_region(&(struct dmem_cgroup_init){
 						.size = adev->gmc.real_vram_size,
-					      });
-	if (IS_ERR(man->cg))
-		return PTR_ERR(man->cg);
+						.ops = &amdgpu_vram_mgr_dmem_ops,
+						.reclaim_priv = man,
+					 },
+					 "drm/%s/vram", adev_to_drm(adev)->unique);
+	if (IS_ERR(cg)) {
+		gpu_buddy_fini(&mgr->mm);
+		return PTR_ERR(cg);
+	}
+
+	mgr->cg_region = cg;
+	ttm_resource_manager_set_dmem_region(man, cg);
 
 	ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM, &mgr->manager);
 	ttm_resource_manager_set_used(man, true);
@@ -963,6 +1004,19 @@ void amdgpu_vram_mgr_fini(struct amdgpu_device *adev)
 	ttm_resource_manager_set_used(man, false);
 
 	ret = ttm_resource_manager_evict_all(&adev->mman.bdev, man);
+
+	/*
+	 * Unregister the dmem cgroup region regardless of the evict_all()
+	 * result and before any further teardown.  This drains in-flight
+	 * reclaim callbacks and blocks new ones, so no reclaim can reference
+	 * the manager once we start freeing it.  It must run after evict_all()
+	 * so that ttm_resource_free() can still uncharge via man->cg during
+	 * eviction.  Clear man->cg afterwards.
+	 */
+	dmem_cgroup_unregister_region(mgr->cg_region);
+	mgr->cg_region = NULL;
+	ttm_resource_manager_set_dmem_region(man, NULL);
+
 	if (ret)
 		return;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h
index 429a21a2e9b2..e581cbf52fcb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h
@@ -26,6 +26,8 @@
 
 #include <linux/gpu_buddy.h>
 
+struct dmem_cgroup_region;
+
 struct amdgpu_vram_mgr {
 	struct ttm_resource_manager manager;
 	struct gpu_buddy mm;
@@ -36,6 +38,7 @@ struct amdgpu_vram_mgr {
 	atomic64_t vis_usage;
 	u64 default_page_size;
 	struct list_head allocated_vres_list;
+	struct dmem_cgroup_region *cg_region;
 };
 
 struct amdgpu_vres_task {
-- 
2.55.0


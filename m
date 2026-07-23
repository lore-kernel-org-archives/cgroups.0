Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A09B43747E;
	Thu, 23 Jul 2026 10:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801089; cv=none; b=LvN2xFKTs4YeNepXymzgMkK1faZDxmSAc8Byq/2/9xjHtxJjPA7WPqFshOaQZE768Zl7REh08FPsYRXmc9hGpskeWYK6wjvHn2zJZg0EGu9ssVj6MZquFR7dBv5h0lRkoAbnPfILxu55RNWrlCMS5nXiKKHdwHSuxZOiGre3flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801089; c=relaxed/simple;
	bh=6XV+TYjbHbxeu/gbWXCTEltxt54qZbHDSHfKubeIWxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpJXaK+oM/6GMoBWujfBxSAN9wAp4R1VM+ehFDLpe5QxAYvBvRD2iMvuyV+x4wvd5ps+i78/1fnWDOJmuKUf0K/AiNWZjplXjlmlztN3TihWQ209w4SkcoadRmppQqOcYC2j0Z12Efeor6P0dlgJGeW073Y6CDCySjAFmhMf6UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aBG2ZUce; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aBG2ZUce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784801088; x=1816337088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6XV+TYjbHbxeu/gbWXCTEltxt54qZbHDSHfKubeIWxU=;
  b=aBG2ZUcewFHEsAUm0KZQQFY0e2f4kGe8wtQFU+t8uM8mV5dYmJk1xNIh
   EicyC3XhhMJLXrpbfeWBnP9kl+DttBSSeGDD8x0Q5qJg0+LZjBwk2JITO
   /SNAIZMFChvwVtunpzrCXHj1I1YP947Ghw6Xm2hPNMZhKPuwovRCEqPNt
   wMWAa99KLZKiZvJS0Bpdfd7jo8ULDwkp43oh4ox8Q4dpjYMqyA7myVmUv
   7TeSUoDnDgEE2d30BrRrjbGGMkYzmrkqvPUr4fBYMNtb8LGvLZxwu4V46
   Ed9BkjF+TOUI4Oj1LxuqiPVyjGu6Ug3J66Fo/iziqGjRH3Jt+1Fzml9X7
   Q==;
X-CSE-ConnectionGUID: AYmUqQbzQr2EiMKYZ5erMw==
X-CSE-MsgGUID: LpICEiAaTg+N4i9tVm2dhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="87991945"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="87991945"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:04:47 -0700
X-CSE-ConnectionGUID: mdznlXyOQYy6I39AlxNwTw==
X-CSE-MsgGUID: SieKGp3kRY6Ws+PNs+jM9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="254985029"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO fedora) ([10.245.244.122])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:04:43 -0700
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
Subject: [PATCH v8 6/6] drm/amdgpu: Wire up dmem cgroup reclaim for VRAM manager
Date: Thu, 23 Jul 2026 12:03:50 +0200
Message-ID: <20260723100350.16895-7-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723100350.16895-1-thomas.hellstrom@linux.intel.com>
References: <20260723100350.16895-1-thomas.hellstrom@linux.intel.com>
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

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c      |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 51 ++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h |  3 ++
 3 files changed, 50 insertions(+), 6 deletions(-)

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
index 08f05c3aed1d..8c62f4681d65 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -906,6 +906,28 @@ static const struct ttm_resource_manager_func amdgpu_vram_mgr_func = {
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
+	ret = ttm_resource_manager_dmem_reclaim(pool, target_bytes, priv);
+
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
@@ -917,6 +939,7 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
 {
 	struct amdgpu_vram_mgr *mgr = &adev->mman.vram_mgr;
 	struct ttm_resource_manager *man = &mgr->manager;
+	struct dmem_cgroup_region *cg;
 	int err;
 
 	ttm_resource_manager_init(man, &adev->mman.bdev,
@@ -933,12 +956,17 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
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
+	if (IS_ERR(cg))
+		return PTR_ERR(cg);
+
+	mgr->cg_region = cg;
+	ttm_resource_manager_set_dmem_region(man, cg);
 
 	ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM, &mgr->manager);
 	ttm_resource_manager_set_used(man, true);
@@ -963,6 +991,19 @@ void amdgpu_vram_mgr_fini(struct amdgpu_device *adev)
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


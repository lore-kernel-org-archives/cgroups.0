Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F777395DAA;
	Sat, 25 Jul 2026 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784973670; cv=none; b=fKEa0gibO6alR7VcaTSo0qPXHMtqe0cL3zrV/6taHR827fMt38/TNsbP4B3Sb/ZF/nd/pWfbgOjPvsazOR5eJ07S42rO8AwLzO/zVssxZFs7R9+WJzqH0FIaVZm7doOaTvHtzlI8LAYJLQYYdMrCLIs+XNYPs7yoIoxKJoMUktY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784973670; c=relaxed/simple;
	bh=gA50c+CvwdAGairtCEkeJ9X3yri7ssvixrrKg9NkZJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F2+srQfMhAESr59qvzz/odI84iWJ9GpHQg4t4ULLuYkobb/dPzwKQ311aCImX38i0VD+4Uh9mf6C5++p0eiSKs42sE+l3jTZIG6J93ZMaf+tiQe6/rNcr1mxq+AqMsdUOpq4nCfVdQK/vHdX0xUzdV+BrD5k3D26eLlhsr0d+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHKSiv+N; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHKSiv+N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784973668; x=1816509668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gA50c+CvwdAGairtCEkeJ9X3yri7ssvixrrKg9NkZJs=;
  b=HHKSiv+N8KzybaLO0/ia+yr6waSeRBFP9pBPpXDSeKOrnmchEs9xc5Fq
   PjNPqrUygLoU+SdhvhltR7PybXvKO44y94P04Hqt+4kHsgdlcuB+PEc0Q
   LRKceZERFd01qCv9xc8JeUHGCzJ5so1xYCsmTR/G5hztKKuXIsWYJjLVn
   pS4D6s9quBosRsHMNUCm0UcReOihBO3rsT/bIsYPzqjtVeTuPCFCl6N0r
   CVC6+0WBGJSrPyhSq8S7MEozBTUWz8/kA+TacSfT8gNe4dwzpmc6urj1u
   3bsyK+ckYjiSUWmRD8FLTyKkJt5uzgdyCgHwzG9uGM+vPNVsvCIa4WAtm
   A==;
X-CSE-ConnectionGUID: oTntUcWcQv6o0HT3a1qbyA==
X-CSE-MsgGUID: RLcGZCpjT92n1556h004aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85565895"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="85565895"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:07 -0700
X-CSE-ConnectionGUID: dPG/7mkzSyyZk/5tQg5YkQ==
X-CSE-MsgGUID: GU1qqqzdTCWLaL8wS2fhQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="255013954"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.106])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:01 -0700
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
Subject: [PATCH v9 0/6] Add reclaim to the dmem cgroup controller
Date: Sat, 25 Jul 2026 12:00:30 +0200
Message-ID: <20260725100036.2372-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When writing a "max" limit lower than the current usage, the
existing code silently failed. This series aims to improve
on that by returning -EBUSY on failure and also attempt
to synchronously reclaim device memory to push the usage
under the new max limit to avoid the error.

Patch 1 fixes a pre-existing amdgpu_vram_mgr_init() error path
Patch 2 introduces struct dmem_cgroup_init for extensible region
      registration.
Patch 3 implements and documents a reclaim callback interface
      for the dmem controller.
Patch 4 implements a TTM reclaim callback.
Patches 5-6 hook up the reclaim callback to the dmem cgroup-aware
      drivers xe and amdgpu.

v2:
- Remove the error propagation that was in a previous series (Maarten)
- A number of updates in patch 1. See its commit message for
  details (Maarten)

v3:
- Add patch 1 fixing a pre-existing amdgpu_vram_mgr_init() error path
  bug where drmm_cgroup_register_region() was called before
  INIT_LIST_HEAD() and gpu_buddy_init(), causing a kernel panic on
  failure. (Sashiko-bot)
- Use an rwsem to protect reclaim callback registration and region
  unregister against concurrent reclaim invocations. (Sashiko-bot)
- Fix ttm_resource_manager_set_dmem_region() storing an error pointer
  in man->cg unconditionally. (Sashiko-bot)
- Fix kernel-doc function name format for ttm_bo_evict_cgroup() and
  ttm_resource_manager_set_dmem_region().

v4:
- Rebased on drm-tip; dropped the XE_PL_STOLEN guard in the xe patch
  as stolen memory uses a separate TTM manager.

v5:
- Add patch 2 introducing struct dmem_cgroup_init to make the
  dmem_cgroup_register_region() API extensible without adding positional
  arguments in the future.
- Use nonblock=true in reset_all_resource_limits() to avoid sleeping
  inside rcu_read_lock() in dmemcs_offline(). (Sashiko-bot)
- Compare usage against the truncated limit stored in cnt.max, not the
  original u64. (Sashiko-bot)
- Use DMEM_MAX_RECLAIM_RETRIES (16) retry budget instead of 5, matching
  the memcg controller; only -ENOSPC (no progress) counts against the
  budget, other errors abort immediately.
- Handle NULL region in ttm_resource_manager_set_dmem_region() to clear
  the reclaim callback, preventing use-after-free when the manager is
  torn down while the dmem region outlives it. (Sashiko-bot)
- Return 0 on any eviction progress; reserve -ENOSPC for zero progress.
- Clear the reclaim callback in xe and amdgpu fini paths to prevent
  use-after-free after driver unbind with open DRM file descriptors.
  (Sashiko-bot)
- Register xe fini devres action before drmm_cgroup_register_region()
  so LIFO teardown runs unregister first, draining callbacks before the
  manager is destroyed. (Sashiko-bot)
- Switch amdgpu to explicit dmem_cgroup_unregister_region() at the top
  of amdgpu_vram_mgr_fini() before any manager teardown, since amdgpu's
  fini is called explicitly during driver unbind before drmm cleanup.
  (Sashiko-bot)
- Wrap the xe reclaim callback with drm_dev_enter()/drm_dev_exit() to
  prevent TTM reclaim from running after driver unbind.

v6:
- Move the ops check inside down_read() in set_resource_max(), guarded
  by region->unregistered, to close a UAF race against
  dmem_cgroup_unregister_region(). (Sashiko-bot)
- Fix dmem_cgroup_ops->reclaim docstring: -ENOSPC is retried up to
  DMEM_MAX_RECLAIM_RETRIES times, not an immediate stop. (Sashiko-bot)
- Fix mgr->cg_region never being assigned in amdgpu_vram_mgr_init(),
  causing dmem_cgroup_unregister_region() in fini to silently no-op.
  (Sashiko-bot)
- Reorder amdgpu_vram_mgr_fini() to call set_used(false) and
  evict_all() before dmem_cgroup_unregister_region(), so
  ttm_resource_free() can uncharge via man->cg during eviction; clear
  man->cg after unregister. (Sashiko-bot)

v7:
- Replace the per-region rw_semaphore with a static SRCU domain
  (dmemcg_srcu). SRCU is a better fit: it avoids per-region lock
  overhead on every reclaim call, and synchronize_srcu() at unregister
  time is a rare, shutdown-time operation. (Maarten)
- Trim in-function comments to focus on what rather than how.
- Switch back to drmm_cgroup_register_region() with a drm_dev_enter/
  exit guard in the reclaim callback (matching xe), rather than manual
  register/unregister.  drm_dev_unplug() fires before vram_mgr_fini(),
  so drm_dev_enter() returning false prevents any reclaim from touching
  the manager during teardown.  This also fixes the "vram" name
  collision on multi-GPU systems, since drmm_cgroup_register_region()
  automatically prefixes with "drm/<pci-addr>/". (Sashiko-bot)

v8:
- Fix ttm_resource_manager_set_dmem_region() using IS_ERR_OR_NULL(),
  which skipped the assignment for a NULL region and thus never cleared
  man->cg. Use IS_ERR() so that a NULL region detaches the region as the
  kernel-doc and the v5 changelog intended. (Sashiko-bot)
- Move the amdgpu dmem cgroup region teardown back into
  amdgpu_vram_mgr_fini() with an explicit dmem_cgroup_unregister_region()
  after evict_all(), keeping the drm_dev_enter() guard. The v7 drmm-only
  approach left a use-after-free on the probe-error teardown path, where
  drm_dev_unplug() is never called so the drm_dev_enter() guard stays
  open while drm_driver.release destroys the manager before the drmm
  action unregisters the region. (Sashiko-bot)

v9:
- Init / fini race fixes. (Sashiko-bot, Thomas)
- Drop a misleading comment. (Maarten)
- Acquire runtime PM before reclaim. (Sashiko-bot) 

User-space tests are at
https://patchwork.freedesktop.org/series/163935/

Test-with: 20260428065411.4222-1-thomas.hellstrom@linux.intel.com

Thomas Hellström (6):
  drm/amdgpu: Fix init ordering in amdgpu_vram_mgr_init()
  cgroup/dmem: Introduce struct dmem_cgroup_init for region
    initialization
  cgroup/dmem: Add reclaim callback for lowering max below current usage
  drm/ttm: Hook up a cgroup-aware reclaim callback for the dmem
    controller
  drm/xe: Wire up dmem cgroup reclaim for VRAM manager
  drm/amdgpu: Wire up dmem cgroup reclaim for VRAM manager

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c      |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 65 +++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h |  3 +
 drivers/gpu/drm/drm_drv.c                    |  8 +-
 drivers/gpu/drm/ttm/ttm_bo.c                 | 94 +++++++++++++++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c            |  3 +-
 drivers/gpu/drm/ttm/ttm_resource.c           | 54 ++++++++++-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c         | 71 +++++++++++++--
 include/drm/drm_drv.h                        |  4 +-
 include/drm/ttm/ttm_bo.h                     | 10 +++
 include/drm/ttm/ttm_resource.h               |  7 ++
 include/linux/cgroup_dmem.h                  | 38 +++++++-
 kernel/cgroup/dmem.c                         | 90 +++++++++++++++----
 13 files changed, 408 insertions(+), 41 deletions(-)

-- 
2.55.0


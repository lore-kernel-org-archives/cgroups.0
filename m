Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272941325B;
	Thu, 11 Jun 2026 14:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781187788; cv=none; b=Qcgq8rIipZXRDGIkvzo9NODJxLa72h6Ots2QinoPjjuQmub6hYQUtrG/0cRWNQDkdn140DcEvS+8LXI24eKnvVqDUWXH+iJqas8ExwZ9TuxSbSC4tAbOfuZoEE6u+8Mo47RAH4YsV8kPmTGvUef12OXLr1zK8DojGdQDGmrJ+Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781187788; c=relaxed/simple;
	bh=UXxdt4IUKP8xvjJVsf/LNyew/umC4+Tm2mlOnXMpnvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fnQREiHL4Z5pnEPeTMW2U7JQLC+KKWYIjdGivZc1vo+wjTly5mkWdibV+EDYb1stdsnTbAhc+36HHjntt8p+Q+oaYq10hkIWZOfDUCuCtZ+p5nCQ+sbgIvfRocudyftbKJGaLNC++VULyXgxZRu4RX8bniqGpWCsS8ev5QJoo9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+anoEcO; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+anoEcO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781187786; x=1812723786;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UXxdt4IUKP8xvjJVsf/LNyew/umC4+Tm2mlOnXMpnvo=;
  b=f+anoEcOb1ElnPkmlx6GJEicotjtrBkpD+YfXA+SO6k3vxN9x54CoANO
   0DZ0AVqQwM3KvbV9EzrIYb46ARwMQmHj1CnpICeJ0ZOaBszJtBlbXzuCQ
   CfJaDUFXZoZQieK25QjCtz4SAToTYTVnNnLHkADT14LOPfyh8k3if5ROg
   9ooLKX3g6yfpcDnqdr2BtXWucYxld5UWtVldUo9UADiWWn/ttIL7Bpe7E
   RYjvttt7r7kWHiZ+DwZrGDaQE2cJQT34evYBZLheDeA2cPv23dq+Riv0F
   IMrZ3IRn/QgQDWRbBmBZ6IoBbbw8ouw1U5agimcYU6Lq8ZK+v7IfFhQJg
   w==;
X-CSE-ConnectionGUID: yQ2HLt6uSaOCK1TIRxjIFw==
X-CSE-MsgGUID: zgfRSRYQRL+n2xda/s3b8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81983370"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="81983370"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 07:23:05 -0700
X-CSE-ConnectionGUID: qf+/glCfT9KDnDvlcai7Rg==
X-CSE-MsgGUID: 1rG2v9+vRsuge1w/VQwaJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="284574282"
Received: from amilburn-desk.amilburn-desk (HELO fedora) ([10.245.244.169])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 07:23:01 -0700
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
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	dri-devel@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/6] [PATCH v5 0/6] Add reclaim to the dmem cgroup controller
Date: Thu, 11 Jun 2026 16:22:36 +0200
Message-ID: <20260611142242.2529-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.54.0
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
- Register xe fini devres action before drmm_cgroup_register_region()
  so LIFO teardown runs unregister first, draining callbacks before the
  manager is destroyed. (Sashiko-bot)
- Switch amdgpu to explicit dmem_cgroup_unregister_region() at the top
  of amdgpu_vram_mgr_fini() before any manager teardown, since amdgpu's
  fini is called explicitly during driver unbind before drmm cleanup.
  (Sashiko-bot)
- Wrap the xe reclaim callback with drm_dev_enter()/drm_dev_exit() to
  prevent TTM reclaim from running after driver unbind.

User-space tests are at
https://patchwork.freedesktop.org/series/163935/

Test-with: 20260428065411.4222-1-thomas.hellstrom@linux.intel.com

Thomas Hellström (6):
  drm/amdgpu: Fix init ordering in amdgpu_vram_mgr_init()
  cgroup/dmem: Introduce struct dmem_cgroup_init for region initialization
  cgroup/dmem: Add reclaim callback for lowering max below current usage
  drm/ttm: Hook up a cgroup-aware reclaim callback for the dmem
    controller
  drm/xe: Wire up dmem cgroup reclaim for VRAM manager
  drm/amdgpu: Wire up dmem cgroup reclaim for VRAM manager

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c      |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |  10 +-
 drivers/gpu/drm/ttm/ttm_bo.c                 |  95 ++++++++++++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c            |   3 +-
 drivers/gpu/drm/ttm/ttm_resource.c           |  37 +++++++
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c         |  19 ++--
 include/drm/ttm/ttm_bo.h                     |  10 ++
 include/drm/ttm/ttm_resource.h               |   4 +
 include/linux/cgroup_dmem.h                  |  24 +++++
 kernel/cgroup/dmem.c                         | 106 +++++++++++++++++--
 10 files changed, 286 insertions(+), 24 deletions(-)

-- 
2.54.0

Thomas Hellström (6):
  drm/amdgpu: Fix init ordering in amdgpu_vram_mgr_init()
  cgroup/dmem: Introduce struct dmem_cgroup_init for region
    initialization
  cgroup/dmem: Add reclaim callback for lowering max below current usage
  drm/ttm: Hook up a cgroup-aware reclaim callback for the dmem
    controller
  drm/xe: Wire up dmem cgroup reclaim for VRAM manager
  drm/amdgpu: Wire up dmem cgroup reclaim for VRAM manager

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c      |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |  28 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.h |   2 +
 drivers/gpu/drm/drm_drv.c                    |   8 +-
 drivers/gpu/drm/ttm/ttm_bo.c                 |  95 +++++++++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c            |   3 +-
 drivers/gpu/drm/ttm/ttm_resource.c           |  50 +++++++
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c         |  53 +++++++-
 include/drm/drm_drv.h                        |   4 +-
 include/drm/ttm/ttm_bo.h                     |  10 ++
 include/drm/ttm/ttm_resource.h               |   7 +
 include/linux/cgroup_dmem.h                  |  37 +++++-
 kernel/cgroup/dmem.c                         | 129 +++++++++++++++++--
 13 files changed, 393 insertions(+), 35 deletions(-)

-- 
2.54.0


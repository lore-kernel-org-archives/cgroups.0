Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537AB43F0B5;
	Thu, 23 Jul 2026 10:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801084; cv=none; b=RwoNYlNg2T0XcxMmUlTVWSUDOe9kXlD/MpsU0WFcevh0eDdpiwAp+fEj1jOXjPVbaTYoiE0HPubVy25RcM9eCJjExpVSyPR/J0O1HTRsuwU9uUPezPBAfOEnExc3i0KNUXCEzskPrWZBNDKe+ycXXGlAdjjGoEi/c6Qp0TNu3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801084; c=relaxed/simple;
	bh=immw9j+wRL/8+zdMSCwNs52RN80M1OXW0UJJZfpWJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEnFlbZEZ+4tInj9WsKoj+COTdBpuYVZcZ/xtJkbPAyPgh9VvmOik+K+QRJ423aHbD7hOzTqvPV9joLFu2onqpJf0NuQhWIRDe1h8+0a82rHI5YOvk5bBDo/aV3Yr7Sol2s2kvhAs77Y9sPVdCNsUIduHj9b71PEWn1Rx56Z/Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i1f9/Ya3; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i1f9/Ya3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784801083; x=1816337083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=immw9j+wRL/8+zdMSCwNs52RN80M1OXW0UJJZfpWJvI=;
  b=i1f9/Ya38DvSOQV4AlX8B3HkKhz/UP385pBf6m5IcUBXdx7U1VXidNav
   NcINVdhlaeeqLJkAyTQWBG+9jK7OF6N7SbA31sYz3i3btkT/jiTK893sY
   Ng8rGfuJmBppxp78IyhoeWJOyGnF+1iYNGiJaVIp09faZpLET5CaNEwS9
   XJij9eKdXO32BGkGdWHK7AB/sdpY8hR8Q/ZUoq8iyg3UwtDlhcEBOYkjN
   AikjtUOwsw56ViyXPUps4Yj1Dbe0zBRYKcMRCr3aHwUaEz0eWrgrup8Pd
   4tPP1/gPQrGB9zr1786cuUMEWMtD9IkuTLJUbJ0u6152SzHJIOGdt/z7Z
   w==;
X-CSE-ConnectionGUID: SLmQyzsUQESeO3s1PfaEYQ==
X-CSE-MsgGUID: ILXc/2qnSMyGwDqoMtXwBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="87991930"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="87991930"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:04:42 -0700
X-CSE-ConnectionGUID: 2BdhgGmAQVuo4mfF4WS7Cg==
X-CSE-MsgGUID: /JZ9lmZFRXunQVIdk+Z0Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="254984947"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO fedora) ([10.245.244.122])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:04:38 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	Huang Rui <ray.huang@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
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
Subject: [PATCH v8 5/6] drm/xe: Wire up dmem cgroup reclaim for VRAM manager
Date: Thu, 23 Jul 2026 12:03:49 +0200
Message-ID: <20260723100350.16895-6-thomas.hellstrom@linux.intel.com>
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

v4:
- Rebased on drm-tip; dropped the XE_PL_STOLEN guard as stolen memory
  uses a separate TTM manager and never calls __xe_ttm_vram_mgr_init().

v5:
- Rebased on the introduction of struct dmem_cgroup_init.
- Register the fini drmm action before drmm_cgroup_register_region() so
  that devres LIFO teardown runs unregister_region() first (draining any
  in-flight reclaim callbacks via the rwsem) and xe_ttm_vram_mgr_fini()
  second, ensuring the manager is never accessed by a reclaim callback
  after teardown. (Sashiko-bot)
- Wrap the reclaim callback in xe_ttm_vram_mgr_dmem_reclaim() using
  drm_dev_enter()/drm_dev_exit() to prevent TTM reclaim from running
  after driver unbind.

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c | 54 +++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index 308fda4248eb..b2500344cd57 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -276,6 +276,28 @@ static const struct ttm_resource_manager_func xe_ttm_vram_mgr_func = {
 	.debug	= xe_ttm_vram_mgr_debug
 };
 
+static const struct dmem_cgroup_ops xe_ttm_vram_mgr_dmem_ops;
+
+static int xe_ttm_vram_mgr_dmem_reclaim(struct dmem_cgroup_pool_state *pool,
+					 u64 target_bytes, void *priv)
+{
+	struct ttm_resource_manager *man = priv;
+	struct xe_device *xe = ttm_to_xe_device(man->bdev);
+	int ret, idx;
+
+	if (!drm_dev_enter(&xe->drm, &idx))
+		return -ENODEV;
+
+	ret = ttm_resource_manager_dmem_reclaim(pool, target_bytes, priv);
+
+	drm_dev_exit(idx);
+	return ret;
+}
+
+static const struct dmem_cgroup_ops xe_ttm_vram_mgr_dmem_ops = {
+	.reclaim = xe_ttm_vram_mgr_dmem_reclaim,
+};
+
 static void xe_ttm_vram_mgr_fini(struct drm_device *dev, void *arg)
 {
 	struct xe_device *xe = to_xe_device(dev);
@@ -301,17 +323,10 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 			   u64 default_page_size)
 {
 	struct ttm_resource_manager *man = &mgr->manager;
+	struct dmem_cgroup_region *cg;
 	const char *name;
 	int err;
 
-	name = mem_type == XE_PL_VRAM0 ? "vram0" : "vram1";
-	man->cg = drmm_cgroup_register_region(&xe->drm, name,
-					      &(struct dmem_cgroup_init){
-						.size = size,
-					      });
-	if (IS_ERR(man->cg))
-		return PTR_ERR(man->cg);
-
 	man->func = &xe_ttm_vram_mgr_func;
 	mgr->mem_type = mem_type;
 	err = drmm_mutex_init(&xe->drm, &mgr->lock);
@@ -330,7 +345,28 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 	ttm_set_driver_manager(&xe->ttm, mem_type, &mgr->manager);
 	ttm_resource_manager_set_used(&mgr->manager, true);
 
-	return drmm_add_action_or_reset(&xe->drm, xe_ttm_vram_mgr_fini, mgr);
+	/*
+	 * Register the fini action before the cgroup region so that devres
+	 * LIFO teardown runs unregister_region first (draining any in-flight
+	 * reclaim callbacks) and the manager fini second.
+	 */
+	err = drmm_add_action_or_reset(&xe->drm, xe_ttm_vram_mgr_fini, mgr);
+	if (err)
+		return err;
+
+	name = mem_type == XE_PL_VRAM0 ? "vram0" : "vram1";
+	cg = drmm_cgroup_register_region(&xe->drm, name,
+					 &(struct dmem_cgroup_init){
+						.size = size,
+						.ops = &xe_ttm_vram_mgr_dmem_ops,
+						.reclaim_priv = man,
+					 });
+	if (IS_ERR(cg))
+		return PTR_ERR(cg);
+
+	ttm_resource_manager_set_dmem_region(man, cg);
+
+	return 0;
 }
 
 /**
-- 
2.55.0


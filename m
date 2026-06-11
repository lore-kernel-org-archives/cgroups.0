Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DED4183CC;
	Thu, 11 Jun 2026 14:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781187811; cv=none; b=CAdSr209J+K8oJJRJu6YdEHCEXP6b6AZJjHL1lkDLNyLtoIKpVoNFzuiUWeQ8SyyV7G1UXh6220/q+M32uF0kyUZiGhBvo/IFfmv+fd4nSA6UlHZXCWo2OWQwo+KSclZSPFjldqB72ZRxTSX/dSWKKH5aFZ+Ci8whRFDUaMt90c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781187811; c=relaxed/simple;
	bh=FsvkI3LOasYuprXDVfPJVH1qnNqYfZwMGOjwjiJ3aL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVNArXTe9253YyptXQ3sVKqbCxjaboX6Za+NppcRFf93ivzLvUSRxKClhj9O/FgR+TsT/XGzBfAUoWcn//C4BgVOq/LWSnmu9Ly14oc7hyG6IjamX//JeMTPe48S92FZRBFSrKBhPXMIyTMOuC4xYPaMjyLK3P3pOjLYm3eVuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=llPrgSha; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="llPrgSha"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781187810; x=1812723810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FsvkI3LOasYuprXDVfPJVH1qnNqYfZwMGOjwjiJ3aL0=;
  b=llPrgShaQTkXJC2HcU9eQw1WeMtMWzbqWVJULS+OcNl2qBCuFAgPfP6M
   nUmmr1/OQdo68+rzSE48YB8bRgMQ7H25iv14z5DRZUy04MKVL2pB1n2ML
   FzqCUBeZQ7qL1WB4Jqcqm45B21M8O9OnKAUA3QdOlOb/SKqnb01l1I2a5
   ZHjJRkMC15Kh007nABBSle9566ZX8Om7+5B8Ky5V6hhAAE5DNoO6vgw0g
   +lAC03CSpnkm4ZpHWhWJiGspS/Wv73XdSOma3MqQKGsfUOS4QUE31Xd55
   YJxQ4We/7KOgKmENI8yqhe2ZJDgM6EDEPyLg2pf1owFa82SwRCSIUnAUP
   g==;
X-CSE-ConnectionGUID: waLMmPqBQaO24s7axQZ7Mg==
X-CSE-MsgGUID: QrBv77R+Qg6a4NWLqEElvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81983445"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="81983445"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 07:23:30 -0700
X-CSE-ConnectionGUID: iEq5kIJUSpuBvxUHauSL0w==
X-CSE-MsgGUID: eefaeiGmRd+c6DId46Vv1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="284574360"
Received: from amilburn-desk.amilburn-desk (HELO fedora) ([10.245.244.169])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 07:23:26 -0700
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
Subject: [PATCH v5 5/6] drm/xe: Wire up dmem cgroup reclaim for VRAM manager
Date: Thu, 11 Jun 2026 16:22:41 +0200
Message-ID: <20260611142242.2529-6-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611142242.2529-1-thomas.hellstrom@linux.intel.com>
References: <20260611142242.2529-1-thomas.hellstrom@linux.intel.com>
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
2.54.0


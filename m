Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABA339D6E8;
	Sat, 25 Jul 2026 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784973693; cv=none; b=Nyd020WA9pjTldpzIDzBeBPkMPb5tP3a+AX42gHL8of+4oTym8/YkVs86g5Yt8TifsY/kQlZFpZFY8p3fxuwvpREDV/GKcyrwBNVsqoBVAdMi4Ov73FlZeCq0TMAjWlxwEUYDfIpyHi5Rmn9zOz8lLg8PuHRE27i5l74gtWwBO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784973693; c=relaxed/simple;
	bh=A089Xrl4LydqWjfXNje59Qydma1e+xtvFMWXywph2F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIyJe/+/9PQ+RpUHKF/tMNlrSrG7W0QJvCG8iCWxKBsyWoWSnDrxvKv16Tz9HB3EMnQXeOl+81uZbfcHZZo1qAkpGj2oEDu2DOJEVfKnz+ajsIJDSKcj3GsR0L8vIEM2r1NzT/e7Rg0VT7hJGXdEyr7aW8D6DXYYSLF4bPXR8KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JFcZrEpj; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JFcZrEpj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784973693; x=1816509693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A089Xrl4LydqWjfXNje59Qydma1e+xtvFMWXywph2F0=;
  b=JFcZrEpjsIKKehMRVPwcjXCCT1TquC6AGt/pGDP+DmwSLKUDnxnyz6Ps
   3PlTxPj5ROUrJSZotIarES1qNIni66s4IIZd6zz/32JMQ5IWB3FE171YO
   bOLPmc2EfXGhrbDkII7g5Ic1hZMvRi6EEmWRuyg5GQota11dLZSBDVSOo
   +irieDOLuj6GkL7kv8oFUKhgnBPZrUE+fd2L8+l011zH9ocPvTW2RDPJi
   pLWFOrM+/+Xl2kWH0N5HpzFg3+IBYJ1Rzhrjd44Igpj7k00m6bI7FeklV
   JkJlU1V85WxLhYAoBo0Qlvd9xGLG6WJNzPM0T3/AidGzzSu6xX6zflvZO
   A==;
X-CSE-ConnectionGUID: 38gbe4nWR/+PQRWw6Cy5LA==
X-CSE-MsgGUID: xfKPDkBmTJqSCjsvUYCT+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85565980"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="85565980"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:33 -0700
X-CSE-ConnectionGUID: EueYbREdRwucWeOgATIbXg==
X-CSE-MsgGUID: f++LQchzTpCoN+13dUcAKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="255014021"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.106])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:27 -0700
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
Subject: [PATCH v9 5/6] drm/xe: Wire up dmem cgroup reclaim for VRAM manager
Date: Sat, 25 Jul 2026 12:00:35 +0200
Message-ID: <20260725100036.2372-6-thomas.hellstrom@linux.intel.com>
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

v9:
- Close ttm_resource_manager_set_used() races around vram manager
  init and fini.
- Formatting fix.
- Acquire a runtime PM reference around the TTM reclaim call in
  xe_ttm_vram_mgr_dmem_reclaim(). (Sashiko-bot)

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com> #v8
---
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c | 72 +++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index 308fda4248eb..05911904c1f9 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -15,6 +15,7 @@
 
 #include "xe_bo.h"
 #include "xe_device.h"
+#include "xe_pm.h"
 #include "xe_res_cursor.h"
 #include "xe_ttm_vram_mgr.h"
 #include "xe_vram_types.h"
@@ -276,14 +277,47 @@ static const struct ttm_resource_manager_func xe_ttm_vram_mgr_func = {
 	.debug	= xe_ttm_vram_mgr_debug
 };
 
+static const struct dmem_cgroup_ops xe_ttm_vram_mgr_dmem_ops;
+
+static int xe_ttm_vram_mgr_dmem_reclaim(struct dmem_cgroup_pool_state *pool,
+					u64 target_bytes, void *priv)
+{
+	struct ttm_resource_manager *man = priv;
+	struct xe_device *xe = ttm_to_xe_device(man->bdev);
+	int ret, idx;
+
+	if (!drm_dev_enter(&xe->drm, &idx))
+		return -ENODEV;
+
+	{
+		ACQUIRE(xe_pm_runtime_ioctl, pm)(xe);
+
+		ret = ACQUIRE_ERR(xe_pm_runtime_ioctl, &pm);
+		if (ret >= 0)
+			ret = ttm_resource_manager_dmem_reclaim(pool, target_bytes, priv);
+	}
+
+	drm_dev_exit(idx);
+	return ret;
+}
+
+static const struct dmem_cgroup_ops xe_ttm_vram_mgr_dmem_ops = {
+	.reclaim = xe_ttm_vram_mgr_dmem_reclaim,
+};
+
+static void xe_ttm_vram_mgr_set_unused(struct drm_device *dev, void *arg)
+{
+	struct ttm_resource_manager *man = arg;
+
+	ttm_resource_manager_set_used(man, false);
+}
+
 static void xe_ttm_vram_mgr_fini(struct drm_device *dev, void *arg)
 {
 	struct xe_device *xe = to_xe_device(dev);
 	struct xe_ttm_vram_mgr *mgr = arg;
 	struct ttm_resource_manager *man = &mgr->manager;
 
-	ttm_resource_manager_set_used(man, false);
-
 	if (ttm_resource_manager_evict_all(&xe->ttm, man))
 		return;
 
@@ -301,17 +335,10 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
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
@@ -328,9 +355,30 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 
 	gpu_buddy_driver_set_lock(&mgr->mm, &mgr->lock);
 	ttm_set_driver_manager(&xe->ttm, mem_type, &mgr->manager);
-	ttm_resource_manager_set_used(&mgr->manager, true);
 
-	return drmm_add_action_or_reset(&xe->drm, xe_ttm_vram_mgr_fini, mgr);
+	/*
+	 * Register the fini action before the cgroup region so that devres
+	 * LIFO teardown runs unregister_region before manager teardown
+	 * (draining any in-flight reclaim callbacks) and the manager fini second.
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
+	ttm_resource_manager_set_used(man, true);
+
+	return drmm_add_action_or_reset(&xe->drm, xe_ttm_vram_mgr_set_unused, man);
 }
 
 /**
-- 
2.55.0


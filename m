Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78022436361;
	Thu, 23 Jul 2026 10:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801070; cv=none; b=fbNRYb+MvTwH9Q4C1WDdjBHfO7b1NBBAh6RxEcTwm4C9AMSXD1Q1PlTYnh6uVdnpRfNemScbufxok+lkRh7smXusaFsILKsC6/cekCmujKIqTtV97rFjPskz4XEUd+FlPNHKKetKDwMY5Qnx8p25t0KjqPlvCtWVfsCmN9PjaJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801070; c=relaxed/simple;
	bh=1pcYpkpE8wTUGzh/ZJa9ebzBIY1MUPZSxx/EPaeAW5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=loDm9zkvuknBk3RmV151sSfxskeKtxk+/x3g/2hwxkigFCdb3W51rZHGV3H/mYUbuqbyGuh+TCt5jsaz+zpO8T6YtYpBzAJlEaaiiYmqY2hCeFyJ94vjm9iQHcTfxF1SimEAgDhfcJGOUairuGA92w+44YdkmQNz1564UrUNpe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fSQMCNbt; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fSQMCNbt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784801068; x=1816337068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1pcYpkpE8wTUGzh/ZJa9ebzBIY1MUPZSxx/EPaeAW5s=;
  b=fSQMCNbt6Ksaq5+GqbMFmrl1r7wUfbL81vYooHiZUb1cOUWWZfphBp+Q
   8Pn/nrkR+xTP2wyX8t9jZsyGmE83SUHcc7b8GpbllInNiEdAg5xHOUrok
   fNceW2p4bA6hduJczdxd+n55YZsynaEGv1ehC5i1LqOgrQbJVCbgpjU60
   VelGAqudOQUpWIf2nGUYPoI/GUhca8slQsXhKMw7hKaCQhpvUJ+SgA+1C
   3aFh6ArYu7m5F90JkaRvveJTswnx+MGW7KjluxqM6V5vE+YEO7QqIYuJU
   HGoDYWp1stMbiAB7TA5sxF2P5XXxc48H39evPINviC1CtbPPFg/0poMzR
   A==;
X-CSE-ConnectionGUID: NbpNweYqQv+fKMUJcWU99g==
X-CSE-MsgGUID: efSMTndxSL2yr34vC4jlww==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="87991869"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="87991869"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:04:28 -0700
X-CSE-ConnectionGUID: btwOzsPMRiaZc8PcA+0j5Q==
X-CSE-MsgGUID: SSngbzlFSsWSC/K2DSTfuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="254984888"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO fedora) ([10.245.244.122])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:04:23 -0700
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
Subject: [PATCH v8 2/6] cgroup/dmem: Introduce struct dmem_cgroup_init for region initialization
Date: Thu, 23 Jul 2026 12:03:46 +0200
Message-ID: <20260723100350.16895-3-thomas.hellstrom@linux.intel.com>
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

Replace the bare u64 size argument to dmem_cgroup_register_region() and
drmm_cgroup_register_region() with a const struct dmem_cgroup_init *
pointer. The struct currently carries only the size field, but using a
struct makes the API extensible: future callers can supply additional
initialization parameters without adding more positional arguments.

Update all in-tree callers (amdgpu, xe) to use a compound-literal
initializer.

v5:
- Commit introduced.

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |  6 +++++-
 drivers/gpu/drm/drm_drv.c                    |  8 +++++---
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c         |  7 ++++++-
 include/drm/drm_drv.h                        |  4 +++-
 include/linux/cgroup_dmem.h                  | 16 +++++++++++++---
 kernel/cgroup/dmem.c                         | 10 ++++++----
 6 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index ac3f71d77140..08f05c3aed1d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/cgroup_dmem.h>
 #include <drm/ttm/ttm_range_manager.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_buddy.h>
@@ -932,7 +933,10 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
 	if (err)
 		return err;
 
-	man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram", adev->gmc.real_vram_size);
+	man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram",
+					      &(struct dmem_cgroup_init){
+						.size = adev->gmc.real_vram_size,
+					      });
 	if (IS_ERR(man->cg))
 		return PTR_ERR(man->cg);
 
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index e51ed959da89..c808958a2188 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -968,17 +968,19 @@ static void drmm_cg_unregister_region(struct drm_device *dev, void *arg)
  * drmm_cgroup_register_region - Register a region of a DRM device to cgroups
  * @dev: device for region
  * @region_name: Region name for registering
- * @size: Size of region in bytes
+ * @init: Initialization parameters for the region.
  *
  * This decreases the ref-count of @dev by one. The device is destroyed if the
  * ref-count drops to zero.
  */
-struct dmem_cgroup_region *drmm_cgroup_register_region(struct drm_device *dev, const char *region_name, u64 size)
+struct dmem_cgroup_region *
+drmm_cgroup_register_region(struct drm_device *dev, const char *region_name,
+			    const struct dmem_cgroup_init *init)
 {
 	struct dmem_cgroup_region *region;
 	int ret;
 
-	region = dmem_cgroup_register_region(size, "drm/%s/%s", dev->unique, region_name);
+	region = dmem_cgroup_register_region(init, "drm/%s/%s", dev->unique, region_name);
 	if (IS_ERR_OR_NULL(region))
 		return region;
 
diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index b518f7dec680..308fda4248eb 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2021-2022 Red Hat
  */
 
+#include <linux/cgroup_dmem.h>
+
 #include <drm/drm_managed.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_buddy.h>
@@ -303,7 +305,10 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 	int err;
 
 	name = mem_type == XE_PL_VRAM0 ? "vram0" : "vram1";
-	man->cg = drmm_cgroup_register_region(&xe->drm, name, size);
+	man->cg = drmm_cgroup_register_region(&xe->drm, name,
+					      &(struct dmem_cgroup_init){
+						.size = size,
+					      });
 	if (IS_ERR(man->cg))
 		return PTR_ERR(man->cg);
 
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index e09559495c5b..b23830494ed4 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -34,6 +34,7 @@
 
 #include <drm/drm_device.h>
 
+struct dmem_cgroup_init;
 struct dmem_cgroup_region;
 struct drm_fb_helper;
 struct drm_fb_helper_surface_size;
@@ -433,7 +434,8 @@ void *__devm_drm_dev_alloc(struct device *parent,
 
 struct dmem_cgroup_region *
 drmm_cgroup_register_region(struct drm_device *dev,
-			    const char *region_name, u64 size);
+			    const char *region_name,
+			    const struct dmem_cgroup_init *init);
 
 /**
  * devm_drm_dev_alloc - Resource managed allocation of a &drm_device instance
diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
index dd4869f1d736..d9eab8a2c1ee 100644
--- a/include/linux/cgroup_dmem.h
+++ b/include/linux/cgroup_dmem.h
@@ -14,8 +14,18 @@ struct dmem_cgroup_pool_state;
 /* Opaque definition of a cgroup region, used internally */
 struct dmem_cgroup_region;
 
+/**
+ * struct dmem_cgroup_init - Initialization parameters for a dmem cgroup region.
+ * @size: Size of the region in bytes.
+ */
+struct dmem_cgroup_init {
+	u64 size;
+};
+
 #if IS_ENABLED(CONFIG_CGROUP_DMEM)
-struct dmem_cgroup_region *dmem_cgroup_register_region(u64 size, const char *name_fmt, ...) __printf(2,3);
+struct dmem_cgroup_region *
+dmem_cgroup_register_region(const struct dmem_cgroup_init *init,
+			    const char *name_fmt, ...) __printf(2, 3);
 void dmem_cgroup_unregister_region(struct dmem_cgroup_region *region);
 int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 			   struct dmem_cgroup_pool_state **ret_pool,
@@ -27,8 +37,8 @@ bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 
 void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
 #else
-static inline __printf(2,3) struct dmem_cgroup_region *
-dmem_cgroup_register_region(u64 size, const char *name_fmt, ...)
+static inline __printf(2, 3) struct dmem_cgroup_region *
+dmem_cgroup_register_region(const struct dmem_cgroup_init *init, const char *name_fmt, ...)
 {
 	return NULL;
 }
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 39930c59cb76..eb46e99b7366 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -502,7 +502,7 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_unregister_region);
 
 /**
  * dmem_cgroup_register_region() - Register a regions for dev cgroup.
- * @size: Size of region to register, in bytes.
+ * @init: Initialization parameters for the region.
  * @fmt: Region parameters to register
  *
  * This function registers a node in the dmem cgroup with the
@@ -511,13 +511,15 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_unregister_region);
  *
  * Return: NULL or a struct on success, PTR_ERR on failure.
  */
-struct dmem_cgroup_region *dmem_cgroup_register_region(u64 size, const char *fmt, ...)
+struct dmem_cgroup_region *
+dmem_cgroup_register_region(const struct dmem_cgroup_init *init,
+			    const char *fmt, ...)
 {
 	struct dmem_cgroup_region *ret;
 	char *region_name;
 	va_list ap;
 
-	if (!size)
+	if (!init || !init->size)
 		return NULL;
 
 	va_start(ap, fmt);
@@ -534,7 +536,7 @@ struct dmem_cgroup_region *dmem_cgroup_register_region(u64 size, const char *fmt
 
 	INIT_LIST_HEAD(&ret->pools);
 	ret->name = region_name;
-	ret->size = size;
+	ret->size = init->size;
 	kref_init(&ret->ref);
 
 	spin_lock(&dmemcg_lock);
-- 
2.55.0


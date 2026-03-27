Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869D73D47D7;
	Fri, 27 Mar 2026 08:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774599418; cv=none; b=pvSTK6Pr57qtALb3XU2jDFfsz6MVmk4qKl/cqSM0YWkawiP6QEO52BM3Ub2nMhQnJBLAhVKFWR6X8dpLHAM1yc1aScWaqF4O0QwatSp8B8CpSPsVEhJTiRo4EQybok9WX/dm4ibQi28rxct38K03GqKMLKZSeIr6q6vyzKPUenw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774599418; c=relaxed/simple;
	bh=VCXy79fbBAt5QnmrzmMMuvOq3FMqVb404fQrx6b1TDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jr5SLU1nYJG0w0lCJ3dZdndslks/XWcM2sCsxPpYAF6YEdQOmHBxEvjEPj1gqYUAFa1wwOmrRlUz8FHYqRE2BUcg/O0+0pjyXr6RDWFiduDQmUkCldCtuFY4tLjST3BpUTGdDfgtgRtbAXEk41Qh1a2ueGmp58nZUZpZISHhDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QDTMBDSo; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDTMBDSo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774599415; x=1806135415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VCXy79fbBAt5QnmrzmMMuvOq3FMqVb404fQrx6b1TDI=;
  b=QDTMBDSo+YVdfWrmBy6I2uEOHZG4R7CD/mjMERNQn+xzvIEHMrhzDW08
   Zw4md3MFqOtZG6XkKZjpvSqi3lgU7TyH0Zjr9vsFpiX1wK+EhlbzD3q2P
   CSFZRNmBWCYsj4LdKDUHQF2IDNrx+hYyCo4MTjfo/HEd+xhV/39BeNrGo
   nJ/2L3KptwZTBTn0NbA12pVdSXZFzXSLWeofIOgP8g+wXtr6c8hDCmLR5
   6OopA5f7MsJAOQ/kiX/fxcsMPvHJv1Zon6hsKDPcYo8mvXZAE3fAlQTO7
   Vt9cf7qrRLBakHkla0iRWc06dLsJmTEDwLypbfxNRp5YWYeGMh7TYpZmr
   A==;
X-CSE-ConnectionGUID: KE4WAniPQiigw785XtatlA==
X-CSE-MsgGUID: fKY6JmBTRXW7BHO9R8COMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75784087"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="75784087"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 01:16:55 -0700
X-CSE-ConnectionGUID: ZgzMJUUlRuaca/H2RVQkBQ==
X-CSE-MsgGUID: 6pQoZOSvTGyqbF/NpGiVaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="255747944"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO fedora) ([10.245.244.146])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 01:16:50 -0700
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
Subject: [PATCH 4/5] drm/xe: Wire up dmem cgroup reclaim for VRAM manager
Date: Fri, 27 Mar 2026 09:15:59 +0100
Message-ID: <20260327081600.4885-5-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327081600.4885-1-thomas.hellstrom@linux.intel.com>
References: <20260327081600.4885-1-thomas.hellstrom@linux.intel.com>
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

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index 5fd0d5506a7e..1bdcb3fee901 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -303,13 +303,6 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 	struct ttm_resource_manager *man = &mgr->manager;
 	int err;
 
-	if (mem_type != XE_PL_STOLEN) {
-		const char *name = mem_type == XE_PL_VRAM0 ? "vram0" : "vram1";
-		man->cg = drmm_cgroup_register_region(&xe->drm, name, size);
-		if (IS_ERR(man->cg))
-			return PTR_ERR(man->cg);
-	}
-
 	man->func = &xe_ttm_vram_mgr_func;
 	mgr->mem_type = mem_type;
 	mutex_init(&mgr->lock);
@@ -318,6 +311,18 @@ int __xe_ttm_vram_mgr_init(struct xe_device *xe, struct xe_ttm_vram_mgr *mgr,
 	mgr->visible_avail = io_size;
 
 	ttm_resource_manager_init(man, &xe->ttm, size);
+
+	if (mem_type != XE_PL_STOLEN) {
+		const char *name = mem_type == XE_PL_VRAM0 ? "vram0" : "vram1";
+		struct dmem_cgroup_region *cg =
+			drmm_cgroup_register_region(&xe->drm, name, size);
+
+		if (IS_ERR(cg))
+			return PTR_ERR(cg);
+
+		ttm_resource_manager_set_dmem_region(man, cg);
+	}
+
 	err = gpu_buddy_init(&mgr->mm, man->size, default_page_size);
 	if (err)
 		return err;
-- 
2.53.0


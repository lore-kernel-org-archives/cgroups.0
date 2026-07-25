Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD70F396579;
	Sat, 25 Jul 2026 10:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784973689; cv=none; b=O1wxK2Pta3a1MJ6Tbn6c1bpRelAlyQ6vtiHHcNYBu0YtWg2LVnBVWtNDIaiik0jTHqyTB1jqqsYnWOCbmKO/Y9h051FifYrC9jRSZk5Tov/S80b8/gY2y/+dbqopr8TA6tt/J8C5hMMTPr1CjkkaHLYHFVGGXFzh5YsyKs9L+Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784973689; c=relaxed/simple;
	bh=lwgce21kkCxLfftNlAOIx8NHuhIx/npbxNLtz6VFRjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgysAx7UvKFTdmRn9J/eycQjZscriOLzjhx/cz7qqrR89yQo7Y6RQgQtQ0/7wj9ZrXsPh8awAfMHKzZMQbuOXWxATSgpbZqn4X3w+belYK14O0CSyohXt8VUuY1t0U/a7DEVfJ5C4x5x8ZiPKQU4rglYucER7GmdsNXgAoQm/DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NnE2+9gF; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NnE2+9gF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784973688; x=1816509688;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lwgce21kkCxLfftNlAOIx8NHuhIx/npbxNLtz6VFRjY=;
  b=NnE2+9gFtikh7Zj4OnveNGfiTT3kyOHMDDKVDw/D9aIHgT2O/cQ9kbKq
   +osYeCl2gdKDoSOHAj3xaE9IFWJDiJw5vmGodgsiBRH4I01UWXAyDM1Xs
   y2wD0xFqed9zAvmc5RNJ1+k5gmmx8Up9u1siTC5gv7IhpTp9zdZCg/sT4
   SEy+I9YpNjD9rW55tdSxy3jvzezM+/ks2jglf3rItjrv6Uxs0y0w4T0uM
   0fLnGoNSVfsJbfBk9HyoJaRSinBq2pqB9M5K1Y0pasu8tAtPUrJwcpUGS
   3QUjxhmVbR7bROkAt3iOKFuyyIwe9KRTrKYZdp2Zit95m4ZvWuFPOcPHh
   w==;
X-CSE-ConnectionGUID: zQAhSg+WRuKaocoC9LUsWw==
X-CSE-MsgGUID: 8kJIA/JtRN2QKef7uyWLgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85565965"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="85565965"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:28 -0700
X-CSE-ConnectionGUID: AMzCswoFRgOG2BFKJ8zqbQ==
X-CSE-MsgGUID: HuncUMutTC2+lD0GFleXaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="255014003"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.106])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 03:01:22 -0700
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
Subject: [PATCH v9 4/6] drm/ttm: Hook up a cgroup-aware reclaim callback for the dmem controller
Date: Sat, 25 Jul 2026 12:00:34 +0200
Message-ID: <20260725100036.2372-5-thomas.hellstrom@linux.intel.com>
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

Add ttm_bo_evict_cgroup() to evict buffer objects charged to a specific
dmem cgroup pool from a resource manager's LRU until a byte target is
met.  Add ttm_resource_manager_set_dmem_region() to associate a dmem
cgroup region with a resource manager; drivers supply their own
dmem_cgroup_ops with ttm_resource_manager_dmem_reclaim as the reclaim
function and the manager pointer as reclaim_priv in the dmem_cgroup_init
to wire up TTM eviction as the reclaim callback.

The eviction context is interruptible; signals abort the operation and
propagate back through the write() syscall.

Introduce a new mode for the bo LRU walker so that sleeping locks
can be taken. This can be used when the caller doesn't hold any
previous dma_resv locks, and where it intends to hold at most
one lock at a time.

Like the rest of the TTM eviction this should sooner than later
be converted to full WW transactions.

v3:
- Fix ttm_resource_manager_set_dmem_region() storing an error pointer
  in man->cg unconditionally. (Sashiko-bot)
- Fix kernel-doc function name format for ttm_bo_evict_cgroup() and
  ttm_resource_manager_set_dmem_region().

v5:
- Rebased on the introduction of struct dmem_cgroup_init.
- Handle NULL region in ttm_resource_manager_set_dmem_region() to clear
  the reclaim callback, preventing use-after-free when the manager is
  torn down while the dmem region outlives it. (Sashiko-bot)
- Return 0 on any progress (even partial eviction), -ENOSPC only when
  nothing was freed; fixes callers that expected 0 on partial success.
- Document that the reclaim callback should return 0 if some progress
  was made, -ENOSPC if no progress at all, or another error for fatal
  failures.

v8:
- Fix ttm_resource_manager_set_dmem_region() using IS_ERR_OR_NULL(),
  which skipped the assignment for a NULL region and thus never
  cleared man->cg. Use IS_ERR() so that a NULL region detaches the
  region as the kernel-doc and the v5 changelog intended. (Sashiko-bot)

v9:
- Don't leak cgroup charges for bos that may have survived dmemcg
  region fini.
- Drop the misleading "Capture size before eviction in case res is
  cleared" comment in ttm_bo_evict_cb(). (Maarten Lankhorst)

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com> #v7
---
 drivers/gpu/drm/ttm/ttm_bo.c       | 94 +++++++++++++++++++++++++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c  |  3 +-
 drivers/gpu/drm/ttm/ttm_resource.c | 54 ++++++++++++++++-
 include/drm/ttm/ttm_bo.h           | 10 ++++
 include/drm/ttm/ttm_resource.h     |  7 +++
 5 files changed, 163 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 3980f376e3ba..8d7403c714cf 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -515,12 +515,19 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *
 {
 	struct ttm_bo_evict_walk *evict_walk =
 		container_of(walk, typeof(*evict_walk), walk);
+	s64 bo_size = bo->base.size;
 	s64 lret;
 
 	if (!dmem_cgroup_state_evict_valuable(evict_walk->limit_pool, bo->resource->css,
 					      evict_walk->try_low, &evict_walk->hit_low))
 		return 0;
 
+	/*
+	 * evict_walk->place is NULL in cgroup drain mode.  Drivers'
+	 * eviction_valuable() callbacks must handle a NULL place, treating it
+	 * as "any placement": the TTM base implementation already does so via
+	 * ttm_resource_intersects().
+	 */
 	if (bo->pin_count || !bo->bdev->funcs->eviction_valuable(bo, evict_walk->place))
 		return 0;
 
@@ -536,11 +543,15 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *
 		goto out;
 
 	evict_walk->evicted++;
-	if (evict_walk->res)
+	if (evict_walk->res) {
 		lret = ttm_resource_alloc(evict_walk->evictor, evict_walk->place,
 					  evict_walk->res, NULL);
-	if (lret == 0)
-		return 1;
+		if (lret == 0)
+			return 1;
+	} else {
+		/* Cgroup drain: return bytes freed for byte-denominated progress. */
+		return bo_size;
+	}
 out:
 	/* Errors that should terminate the walk. */
 	if (lret == -ENOSPC)
@@ -614,6 +625,83 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 	return 0;
 }
 
+/**
+ * ttm_bo_evict_cgroup() - Evict buffer objects charged to a specific cgroup.
+ * @bdev: The TTM device.
+ * @man: The resource manager whose LRU to walk.
+ * @limit_pool: The cgroup pool state whose members should be evicted.
+ * @target_bytes: Number of bytes to free.
+ * @ctx: The TTM operation context.
+ *
+ * Walk the LRU of @man and evict buffer objects that are charged to the
+ * cgroup identified by @limit_pool, until at least @target_bytes have been
+ * freed.  Mirrors the two-pass (trylock -> sleeping-lock, low-watermark)
+ * strategy used by ttm_bo_evict_alloc().
+ *
+ * Return: >= @target_bytes on full success, 0..target_bytes-1 if partial,
+ *         negative error code on fatal error.
+ */
+s64 ttm_bo_evict_cgroup(struct ttm_device *bdev,
+			struct ttm_resource_manager *man,
+			struct dmem_cgroup_pool_state *limit_pool,
+			s64 target_bytes,
+			struct ttm_operation_ctx *ctx)
+{
+	struct ttm_bo_evict_walk evict_walk = {
+		.walk = {
+			.ops = &ttm_evict_walk_ops,
+			.arg = { .ctx = ctx },
+		},
+		.limit_pool = limit_pool,
+		/* place, evictor, res left NULL: selects cgroup drain mode */
+	};
+	s64 lret, pass;
+
+	evict_walk.walk.arg.trylock_only = true;
+	lret = ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, target_bytes);
+	if (lret < 0 || lret >= target_bytes)
+		return lret;
+
+	/* Second pass: also evict BOs at the low watermark. */
+	if (evict_walk.hit_low) {
+		evict_walk.try_low = true;
+		pass = ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man,
+					      target_bytes - lret);
+		if (pass < 0)
+			return pass;
+		lret += pass;
+		if (lret >= target_bytes)
+			return lret;
+	}
+
+	/* Full sleeping-lock pass for remaining target. */
+	evict_walk.try_low = evict_walk.hit_low = false;
+	evict_walk.walk.arg.trylock_only = false;
+
+retry:
+	evict_walk.walk.arg.sleeping_lock = true;
+	do {
+		evict_walk.evicted = 0;
+		pass = ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man,
+					      target_bytes - lret);
+		if (pass < 0) {
+			lret = pass;
+			goto out;
+		}
+		lret += pass;
+	} while (lret < target_bytes && evict_walk.evicted);
+
+	/* One more attempt if we hit the low limit during sleeping-lock pass. */
+	if (lret < target_bytes && evict_walk.hit_low && !evict_walk.try_low) {
+		evict_walk.try_low = true;
+		goto retry;
+	}
+
+out:
+	return lret;
+}
+EXPORT_SYMBOL(ttm_bo_evict_cgroup);
+
 /**
  * ttm_bo_pin - Pin the buffer object.
  * @bo: The buffer object to pin
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 3e3c201a0222..bd0b23ac2cc4 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -999,7 +999,8 @@ __ttm_bo_lru_cursor_next(struct ttm_bo_lru_cursor *curs)
 		bo = res->bo;
 		if (ttm_lru_walk_trylock(curs, bo))
 			bo_locked = true;
-		else if (!arg->ticket || arg->ctx->no_wait_gpu || arg->trylock_only)
+		else if ((!arg->ticket && !arg->sleeping_lock) || arg->ctx->no_wait_gpu ||
+			 arg->trylock_only)
 			continue;
 
 		if (!ttm_bo_get_unless_zero(bo)) {
diff --git a/drivers/gpu/drm/ttm/ttm_resource.c b/drivers/gpu/drm/ttm/ttm_resource.c
index 154d6739256f..1417a09b767c 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -437,7 +437,7 @@ void ttm_resource_free(struct ttm_buffer_object *bo, struct ttm_resource **res)
 	man = ttm_manager_type(bo->bdev, (*res)->mem_type);
 	man->func->free(man, *res);
 	*res = NULL;
-	if (man->cg)
+	if (pool)
 		dmem_cgroup_uncharge(pool, bo->base.size);
 }
 EXPORT_SYMBOL(ttm_resource_free);
@@ -953,3 +953,55 @@ void ttm_resource_manager_create_debugfs(struct ttm_resource_manager *man,
 #endif
 }
 EXPORT_SYMBOL(ttm_resource_manager_create_debugfs);
+
+/**
+ * ttm_resource_manager_dmem_reclaim() - dmem cgroup reclaim callback for TTM
+ *                                       resource managers.
+ * @pool: The dmem cgroup pool state for the cgroup being reclaimed.
+ * @target_bytes: Number of bytes to try to free.
+ * @priv: The &ttm_resource_manager pointer, passed as @init.reclaim_priv to
+ *        dmem_cgroup_register_region().
+ *
+ * Drivers should use this as the @reclaim member of their own
+ * &struct dmem_cgroup_ops, with the &ttm_resource_manager pointer as
+ * @init.reclaim_priv.
+ *
+ * Return: 0 if some memory was freed, -ENOSPC if nothing was freed, or
+ *         another negative error code on fatal failure.
+ */
+int ttm_resource_manager_dmem_reclaim(struct dmem_cgroup_pool_state *pool,
+				      u64 target_bytes, void *priv)
+{
+	struct ttm_resource_manager *man = priv;
+	struct ttm_operation_ctx ctx = { .interruptible = true };
+	s64 freed;
+
+	freed = ttm_bo_evict_cgroup(man->bdev, man, pool, target_bytes, &ctx);
+	if (freed < 0)
+		return freed;
+
+	return freed > 0 ? 0 : -ENOSPC;
+}
+EXPORT_SYMBOL(ttm_resource_manager_dmem_reclaim);
+
+/**
+ * ttm_resource_manager_set_dmem_region() - Associate a dmem cgroup region with a
+ *                                        resource manager.
+ * @man: The resource manager.
+ * @region: The dmem cgroup region to associate, may be NULL or IS_ERR().
+ *
+ * When @region is valid, stores it in @man->cg so that TTM can look up the
+ * associated pool during charging and eviction-target selection.  When
+ * @region is %NULL, clears @man->cg to detach the region before teardown.
+ * An IS_ERR() @region is ignored, leaving @man->cg unchanged.
+ * The reclaim callback must be wired up using ttm_resource_manager_dmem_reclaim()
+ * in the driver's own &struct dmem_cgroup_ops, with the manager pointer as
+ * @init.reclaim_priv.
+ */
+void ttm_resource_manager_set_dmem_region(struct ttm_resource_manager *man,
+					  struct dmem_cgroup_region *region)
+{
+	if (!IS_ERR(region))
+		man->cg = region;
+}
+EXPORT_SYMBOL(ttm_resource_manager_set_dmem_region);
diff --git a/include/drm/ttm/ttm_bo.h b/include/drm/ttm/ttm_bo.h
index 8310bc3d55f9..32791c4db2a9 100644
--- a/include/drm/ttm/ttm_bo.h
+++ b/include/drm/ttm/ttm_bo.h
@@ -226,6 +226,11 @@ struct ttm_lru_walk_arg {
 	struct ww_acquire_ctx *ticket;
 	/** @trylock_only: Only use trylock for locking. */
 	bool trylock_only;
+	/**
+	 * @sleeping_lock: Use sleeping locks even with %NULL @ticket.
+	 * @trylock_only has precedence over this field.
+	 */
+	bool sleeping_lock;
 };
 
 /**
@@ -431,6 +436,11 @@ void ttm_bo_unpin(struct ttm_buffer_object *bo);
 int ttm_bo_evict_first(struct ttm_device *bdev,
 		       struct ttm_resource_manager *man,
 		       struct ttm_operation_ctx *ctx);
+s64 ttm_bo_evict_cgroup(struct ttm_device *bdev,
+			struct ttm_resource_manager *man,
+			struct dmem_cgroup_pool_state *limit_pool,
+			s64 target_bytes,
+			struct ttm_operation_ctx *ctx);
 int ttm_bo_access(struct ttm_buffer_object *bo, unsigned long offset,
 		  void *buf, int len, int write);
 vm_fault_t ttm_bo_vm_reserve(struct ttm_buffer_object *bo,
diff --git a/include/drm/ttm/ttm_resource.h b/include/drm/ttm/ttm_resource.h
index a5d386583fb6..32e485fdce9a 100644
--- a/include/drm/ttm/ttm_resource.h
+++ b/include/drm/ttm/ttm_resource.h
@@ -39,6 +39,7 @@
 
 struct dentry;
 struct dmem_cgroup_device;
+struct dmem_cgroup_region;
 struct drm_printer;
 struct ttm_device;
 struct ttm_resource_manager;
@@ -477,6 +478,12 @@ void ttm_resource_manager_init(struct ttm_resource_manager *man,
 			       struct ttm_device *bdev,
 			       uint64_t size);
 
+void ttm_resource_manager_set_dmem_region(struct ttm_resource_manager *man,
+					  struct dmem_cgroup_region *region);
+
+int ttm_resource_manager_dmem_reclaim(struct dmem_cgroup_pool_state *pool,
+				      u64 target_bytes, void *priv);
+
 int ttm_resource_manager_evict_all(struct ttm_device *bdev,
 				   struct ttm_resource_manager *man);
 
-- 
2.55.0


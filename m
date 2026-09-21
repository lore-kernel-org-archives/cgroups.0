Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DB3AB5DC
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 07:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974178; cv=none; b=E4rZej8UOp0gQ7wGGDVOqJ5EtMCdB/mQrJsNqjTSejz1ylooCI94Fq/9BO8XnuhJoevp0yS1X3dB3dj/OYU4QqkdvbwwP+RenBHBNhLioke+Sve7VEQ52yn5GEazwVXM4CM5Oar2uNjsj1cFXK59UqLrAJuUnet/zp+GSgWruzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974178; c=relaxed/simple;
	bh=fPPd+cJbanctsU5CNjyaiFUSQ9iHlOs8Ne0x1fFDgRI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Povd0ch/p+3cx2ogCWdohGvSqkvWUVrzMcgBdOzZsRZlSlFHDwnpORXONIP28knwMJIdCpS72U3riM+512dRiZP2UocO6znwry/3EbB85XY374RzRe8/Vuke1dknBVjmMvjZrJp99kWGqUJDlUwqvSuNMtp4t7PB4J4K+JgNvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=haW2G+rL; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haW2G+rL"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so2241415a91.2
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789974175; x=1790578975; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f7M/3WgnkjNmz5jsd3r+HUKAFE/cGfRfVAo+hBGgOOc=;
        b=haW2G+rLQKduu+iC1TEJeEanTqDQqrND/VwgC3ReStqWk6I7XkUHQIrwZ3gLlQBr+X
         r2BXO6pqqAUSdWOUg+aP36SjFqwvcT2TsHLX2hIBJML+L3rCRaZX2ErWtDtFd0CJGtY4
         dGj9n3/VKTyrOcWkgbCvCPHTDckWlhLko0sknT0Mp6ECzB+goT3mGmpiNcC+GlxfPT6C
         CybM64j0gAVBGcuCnqnNhl4GxK/F4RQpczfFyJv+7R9rabNUV/Wi/cwTRnEBRUddKuMn
         GpATCA9brLStzVx4PpJQU/9ftFyZSKCs5ToOv5+C5+FbvC/CrAsTxM7L9fBosFVRwAT5
         R2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789974175; x=1790578975;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=f7M/3WgnkjNmz5jsd3r+HUKAFE/cGfRfVAo+hBGgOOc=;
        b=RvHUSSBoq6l/KG8EMgWENYDQl/DL/FyeCFFMuWi0xyerLX2X37bqFuH4wro1LYSruu
         GO3YQc2zMXCH+0HQ5Tf8sRyC3TIJ9XUpztNrRIx0RfcGOHHEI9JsHucF7SMz+cq318qT
         h3UtnoIwBznKLTy4r70kqOnXAY4YUN8yEQ1FbZVN4jaaDfuszPTPxieGRPKhcjClLR4D
         7SyFitQ/PX1hAGvpkz5qLLyY0kTp+vlqV+kfeHwa5ol01l7LzSHnvx67s0Bh0a12ZqrU
         9idOSfkDJWKM6Vg4MX7N7/ZL63+H+mTNo/J1XB7mgZpCIyKhoQXbcU9w6/GS12JMFtDI
         0nzQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDFmjT/fmJ6r83uW5QOLcZC2aQ4sN7e/U4sKJJxRC//2yrGtipqeJvFkq76YhtPqOPu5w/P6R9@vger.kernel.org
X-Gm-Message-State: AFuF++nmsF5ZMV9lQziUj9uU4QlmOq0iwuADkk/kUa7u0Fn9KuTKrRCx
	ejsXF396u09LL7KATaLMcqL7okDWKLXGnGyAdGewOMqr7KqLbHei2L9n
X-Gm-Gg: AYBFou1BjG2zlpW51+ysWjpSFIuQNbo2akhCdydwfJnEHQ9xCT3M2vg7gJIx7a3mVI0
	GHOBknAAELvM8zc90nY4cDw6Xftnmzm2//5haZYO1kTbiEc48IBp2nMkC6FrxK+n6Mi4qR921oq
	4UoMYH0dkSVgRZoNCC5RqgkyXsPyAVpYW89XRRCG+E5/XrTx7U8/MvbBvJwpKr33RvAtcb/8Cb4
	4Dy4xWOavtvOddn+6K1PvMCp5UKuEgFza3muOxsjtTbTXlLYSAmjuWb/3pARmP3XO5ptuo7/IWK
	/1aoWXRh8p8VLCcXTXp7wLcqdLaNzI3CrduP69bu/2t4TB/EO+lPMcGTUdnNmZ6gCm5GTC/7LAJ
	y0e2ID7zfwh72QgGoNh2jR2cIQ+CJyfBTU2wi4NJ7VBHSWYw7iy1VA5t+qbGUZZtcf28fSKOTgR
	o6ErzLiSi55V6fchSYepSmiGe8wKHckZSO2cW7P88b+ncEKWM7vBo=
X-Received: by 2002:a17:90b:5690:b0:398:bee5:61d6 with SMTP id 98e67ed59e1d1-39e54cfabf6mr15482916a91.24.1789974174358;
        Mon, 21 Sep 2026 00:02:54 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d55d45a6sm15558694c88.9.2026.09.21.00.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 00:02:53 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 21 Sep 2026 15:02:48 +0800
Subject: [PATCH v8] cgroup/dmem: implement dmem.high soft limit with
 proactive reclaim
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260921-feature-dmem-high-v8-1-6371fa83d6c3@gmail.com>
X-B4-Tracking: v=1; b=H4sIAJfWsGoC/23OwQ7CIAyA4VdZOIuBTSh48j2MhwW6QSKbgUk0y
 95dtpjoYce/Sb92Jgmjx0TO1UwiZp/8OJRQh4oY1w49Um9Lk5rVkgmuaYft9IxIbcBAne8d5VJ
 r4CdlTaNI2XtE7PxrM6+30s6naYzv7USW6/SrNXxHy5JyWjMhGzRWWgOXPrT+fjRjIKuW4ScA2
 /snQxEsCqEREECqf2FZlg//Aitk9AAAAA==
To: Christian Koenig <christian.koenig@amd.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Natalie Vock <natalie.vock@gmx.de>
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-mm@kvack.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

The dmem cgroup v2 controller only provides a hard "max" limit, which
fails allocations outright once a cgroup's device memory usage hits
its quota.  GPU-bound AI workloads need smoother over-subscription: a
soft limit that applies backpressure through reclaim before the hard
limit is hit.

Implement dmem.high as a soft limit following memory.high semantics.
Check the limit in the charge path on every successful allocation and
trigger proactive reclaim as soon as usage crosses the threshold,
instead of waiting for a dmem.max hit to drive eviction.  Expose
"high" as a new cgroupfs control file per region via
set_resource_high() and get_resource_high(), initialized to
PAGE_COUNTER_MAX like the existing "max" file.

Extend dmem_cgroup_try_charge() with a ret_over_high_pool output
parameter.  After a successful charge, walk the page_counter parent
chain from the charged pool upward and set ret_over_high_pool to the
first pool, self or ancestor, whose usage exceeds its dmem.high
threshold.  Walking the chain, instead of checking only the charged
pool, keeps a descendant cgroup from dodging a limit that an ancestor
is actually violating, and mirrors the ancestor walk already used by
dmem_cgroup_state_evict_valuable().  Propagate the signal through
ttm_resource_alloc() up to ttm_bo_alloc_resource().  On
ttm_resource_alloc()'s allocation-failure path, clear
*ret_over_high_pool right after dropping its reference, so the
caller's unconditional put on the same pointer cannot free it twice.

Add ttm_bo_proactive_evict_high() in TTM to walk the LRU and evict one
BO from the over-limit cgroup, reusing the try_high logic already in
dmem_cgroup_state_evict_valuable().  Treat this as best-effort, since
the allocation already succeeded and dmem.high is a soft limit: take
a blocking lock when a ww_acquire_ctx ticket is available, trylock
otherwise.  Propagate the walk's return value to the caller instead
of discarding it, because a ticket-based walk can fail with -EDEADLK
on a cyclic lock dependency, and the ww_mutex backoff protocol needs
that error to reach the ticket owner; on this path, free the resource
ttm_bo_alloc_resource() already allocated and return the error to its
own caller.

Remove the try_high first pass from ttm_bo_evict_alloc(): that pass
tied the soft-limit semantics to a specific eviction ordering detail.
Enforcing dmem.high in the charge path is the correct place for it.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
Implement dmem.high as a proper soft limit for the dmem cgroup v2
controller, following memory.high semantics: the limit is checked in
the charge path on every successful allocation, and proactive reclaim
is triggered when usage crosses the threshold.

The dmem cgroup currently only supports a hard "max" limit, which causes
allocation failures for GPU-bound workloads.  A soft limit enables
smoother over-subscription by providing backpressure through reclaim
before the hard limit is reached.

The implementation extends dmem_cgroup_try_charge() with a
ret_over_high_pool output parameter that signals callers when a
successful charge pushes usage above the dmem.high threshold.
ttm_resource_alloc() propagates this signal up to
ttm_bo_alloc_resource(), where ttm_bo_proactive_evict_high() evicts
one BO from the over-limit cgroup on a best-effort basis.
---
V7 -> V8:
- Clear *ret_over_high_pool after ttm_resource_alloc() drops the
  reference on the allocation-failure path, fixing a double-free when
  the caller unconditionally puts the same pointer afterwards.
- Walk the page_counter ancestor chain in dmem_cgroup_try_charge()'s
  dmem.high check, matching dmem_cgroup_state_evict_valuable(), so a
  descendant cgroup cannot dodge proactive reclaim while an ancestor
  is over its own dmem.high.
- Propagate the ttm_lru_walk_for_evict() result out of
  ttm_bo_proactive_evict_high() instead of discarding it: a
  ticket-based walk can return -EDEADLK, and swallowing it broke the
  ww_mutex backoff protocol.
- Add Thomas Hellström to Cc: his dmem.max reclaim-callback series
  overlaps in file but not in purpose; we agreed to coordinate merge
  ordering on the v7 thread.

V6 -> V7:
- Replace prioritized eviction (eviction-time ordering) with proactive
  reclaim (charge-time enforcement): dmem.high is now checked in
  dmem_cgroup_try_charge() on every successful allocation, matching
  memory.high semantics as requested by Tejun Heo.
- Add ret_over_high_pool output parameter to dmem_cgroup_try_charge()
  to signal callers when a successful charge crosses the high threshold.
- Add ttm_bo_proactive_evict_high() to evict one BO from the over-limit
  cgroup on each allocation that crosses dmem.high (best-effort; the
  allocation already succeeded since dmem.high is a soft limit).
- Remove the try_high first pass from ttm_bo_evict_alloc(): the high
  limit is no longer enforced via eviction ordering in the max path.
- Propagate ret_over_high_pool through ttm_resource_alloc() and update
  all callers (including TTM test files) to pass the new parameter.
- Add Michal Hocko, Roman Gushchin, Shakeel Butt, Muchun Song to Cc
  per Tejun's request for memcg input on soft limit semantics.

V5 -> V6:
- Guard the try_high dereference of test_pool->cnt with a NULL check
  to prevent a kernel panic during global memory pressure eviction
  when a BO has no associated cgroup.
- Make the disabled-cgroup stub for dmem_cgroup_state_evict_valuable()
  return false in try_high mode so the stub does not incorrectly
  enable Pass 1 when CONFIG_CGROUP_DMEM=n.

V4 -> V5:
- Restore the original control flow in dmem_cgroup_state_evict_valuable():
  test_pool is no longer dereferenced before the ancestry checks, fixing
  a NULL pointer dereference on BOs without a cgroup.  The limit_pool
  NULL-to-root-cgroup resolution is now performed before the try_high
  block, fixing a panic during global memory pressure eviction.
- Keep the try_high check for limit_pool == test_pool inside the existing
  early-return branch to avoid bypassing the hierarchy constraint check
  that prevents cross-cgroup eviction.
- Use a blocking lock in Pass 1 only when a ticket is available
  (trylock otherwise), addressing the deadlock risk of blocking without
  a valid ww_acquire_ctx.
- Explicitly reset trylock_only to true before Pass 2 so it does not
  inherit Pass 1's blocking behavior.

V3 -> V4:
- Use a blocking lock in Pass 1 instead of trylock to ensure
  over-limit cgroups are penalized even when their BOs are actively
  in use, as requested by Maarten Lankhorst.
- Evaluate the try_high condition before the limit_pool == test_pool
  early-return so that the limit-hitting cgroup's own BOs are also
  filtered by dmem.high.
- Remove the high-priority compensation retry at the start of Pass 3,
  which is no longer needed now that Pass 1 uses a blocking lock.

V2 -> V3:
- Walk the page_counter parent chain in the try_high pass to prevent
  child cgroups from evading the penalty when a parent cgroup exceeds
  its dmem.high limit.
- Check dmem.min protection in the try_high pass to avoid evicting
  BOs below the effective minimum.
- Add a properly-locked high-priority retry at the beginning of Pass 3
  so that actively-used over-limit BOs (which failed trylock in Pass 1)
  are not skipped while innocent cgroups are evicted.
- Fix get_resource_high(NULL) returning 0 instead of PAGE_COUNTER_MAX
  to match the behavior of get_resource_max().

V1 -> V2:
- Replace sleep-on-allocation throttling with prioritized eviction.
- Remove task throttling entirely.
- Add dmem.high cgroupfs control file per region.
- Extend dmem_cgroup_state_evict_valuable() with try_high parameter.
- Refactor ttm_bo_evict_alloc() into a 3-pass eviction strategy.
- Initialize high to PAGE_COUNTER_MAX in reset_all_resource_limits().

v7: https://lore.kernel.org/r/20260709-feature-dmem-high-v7-1-de559e7e7768@gmail.com
v6: https://lore.kernel.org/r/20260531-feature-dmem-high-v6-1-20563ecd6dc7@gmail.com
v5: https://lore.kernel.org/r/20260531-feature-dmem-high-v5-1-1c6c532b26a9@gmail.com
v4: https://lore.kernel.org/r/20260530-feature-dmem-high-v4-1-ee7c6ec1c8da@gmail.com
v3: https://lore.kernel.org/r/20260528-feature-dmem-high-v3-1-c642b34bcb2f@gmail.com
v2: https://lore.kernel.org/r/20260522-feature-dmem-high-v2-1-1d7d4a0fa5da@gmail.com
v1: https://lore.kernel.org/all/20260520-feature-dmem-high-v1-1-97ca0cb7f95a@gmail.com
---
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c          |  18 ++--
 drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c |   4 +-
 drivers/gpu/drm/ttm/tests/ttm_resource_test.c    |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                     |  73 ++++++++++++--
 drivers/gpu/drm/ttm/ttm_resource.c               |  10 +-
 include/drm/ttm/ttm_resource.h                   |   3 +-
 include/linux/cgroup_dmem.h                      |  15 ++-
 kernel/cgroup/dmem.c                             | 117 +++++++++++++++++++++--
 8 files changed, 207 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
index f3103307b5df9..7a03f6a04f4e8 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
@@ -258,13 +258,13 @@ static void ttm_bo_unreserve_basic(struct kunit *test)
 	bo = ttm_bo_kunit_init(test, test->priv, BO_SIZE, NULL);
 	bo->priority = bo_prio;
 
-	err = ttm_resource_alloc(bo, place, &res1, NULL);
+	err = ttm_resource_alloc(bo, place, &res1, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 
 	bo->resource = res1;
 
 	/* Add a dummy resource to populate LRU */
-	ttm_resource_alloc(bo, place, &res2, NULL);
+	ttm_resource_alloc(bo, place, &res2, NULL, NULL);
 
 	dma_resv_lock(bo->base.resv, NULL);
 	ttm_bo_unreserve(bo);
@@ -300,12 +300,12 @@ static void ttm_bo_unreserve_pinned(struct kunit *test)
 	dma_resv_lock(bo->base.resv, NULL);
 	ttm_bo_pin(bo);
 
-	err = ttm_resource_alloc(bo, place, &res1, NULL);
+	err = ttm_resource_alloc(bo, place, &res1, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	bo->resource = res1;
 
 	/* Add a dummy resource to the pinned list */
-	err = ttm_resource_alloc(bo, place, &res2, NULL);
+	err = ttm_resource_alloc(bo, place, &res2, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	KUNIT_ASSERT_EQ(test,
 			list_is_last(&res2->lru.link, &priv->ttm_dev->unevictable), 1);
@@ -355,7 +355,7 @@ static void ttm_bo_unreserve_bulk(struct kunit *test)
 	ttm_bo_set_bulk_move(bo1, &lru_bulk_move);
 	dma_resv_unlock(bo1->base.resv);
 
-	err = ttm_resource_alloc(bo1, place, &res1, NULL);
+	err = ttm_resource_alloc(bo1, place, &res1, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	bo1->resource = res1;
 
@@ -363,7 +363,7 @@ static void ttm_bo_unreserve_bulk(struct kunit *test)
 	ttm_bo_set_bulk_move(bo2, &lru_bulk_move);
 	dma_resv_unlock(bo2->base.resv);
 
-	err = ttm_resource_alloc(bo2, place, &res2, NULL);
+	err = ttm_resource_alloc(bo2, place, &res2, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	bo2->resource = res2;
 
@@ -401,7 +401,7 @@ static void ttm_bo_fini_basic(struct kunit *test)
 	bo = ttm_bo_kunit_init(test, test->priv, BO_SIZE, NULL);
 	bo->type = ttm_bo_type_device;
 
-	err = ttm_resource_alloc(bo, place, &res, NULL);
+	err = ttm_resource_alloc(bo, place, &res, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	bo->resource = res;
 
@@ -518,7 +518,7 @@ static void ttm_bo_pin_unpin_resource(struct kunit *test)
 
 	bo = ttm_bo_kunit_init(test, test->priv, BO_SIZE, NULL);
 
-	err = ttm_resource_alloc(bo, place, &res, NULL);
+	err = ttm_resource_alloc(bo, place, &res, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	bo->resource = res;
 
@@ -569,7 +569,7 @@ static void ttm_bo_multiple_pin_one_unpin(struct kunit *test)
 
 	bo = ttm_bo_kunit_init(test, test->priv, BO_SIZE, NULL);
 
-	err = ttm_resource_alloc(bo, place, &res, NULL);
+	err = ttm_resource_alloc(bo, place, &res, NULL, NULL);
 	KUNIT_ASSERT_EQ(test, err, 0);
 	bo->resource = res;
 
diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
index 2db221f6fc3a1..cd40f5b2ab4f1 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
@@ -547,7 +547,7 @@ static void ttm_bo_validate_no_placement_signaled(struct kunit *test)
 
 	ttm_bo_reserve(bo, false, false, NULL);
 
-	err = ttm_resource_alloc(bo, place, &bo->resource, NULL);
+	err = ttm_resource_alloc(bo, place, &bo->resource, NULL, NULL);
 	KUNIT_EXPECT_EQ(test, err, 0);
 	KUNIT_ASSERT_EQ(test, man->usage, size);
 
@@ -604,7 +604,7 @@ static void ttm_bo_validate_no_placement_not_signaled(struct kunit *test)
 	bo = ttm_bo_kunit_init(test, test->priv, size, NULL);
 	bo->type = params->bo_type;
 
-	err = ttm_resource_alloc(bo, place, &bo->resource, NULL);
+	err = ttm_resource_alloc(bo, place, &bo->resource, NULL, NULL);
 	KUNIT_EXPECT_EQ(test, err, 0);
 
 	placement = kunit_kzalloc(test, sizeof(*placement), GFP_KERNEL);
diff --git a/drivers/gpu/drm/ttm/tests/ttm_resource_test.c b/drivers/gpu/drm/ttm/tests/ttm_resource_test.c
index c0e4e35e04426..41fe4d89cd714 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_resource_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_resource_test.c
@@ -303,7 +303,7 @@ static void ttm_sys_man_free_basic(struct kunit *test)
 	res = kunit_kzalloc(test, sizeof(*res), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, res);
 
-	ttm_resource_alloc(bo, place, &res, NULL);
+	ttm_resource_alloc(bo, place, &res, NULL, NULL);
 
 	man = ttm_manager_type(priv->devs->ttm_dev, mem_type);
 	man->func->free(man, res);
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index bcd76f6bb7f02..91f9889b3d079 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -505,6 +505,8 @@ struct ttm_bo_evict_walk {
 
 	/** @limit_pool: Which pool limit we should test against */
 	struct dmem_cgroup_pool_state *limit_pool;
+	/** @try_high: Whether to only evict BO's above the high watermark (first pass) */
+	bool try_high;
 	/** @try_low: Whether we should attempt to evict BO's with low watermark threshold */
 	bool try_low;
 	/** @hit_low: If we cannot evict a bo when @try_low is false (first pass) */
@@ -518,7 +520,8 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *
 	s64 lret;
 
 	if (!dmem_cgroup_state_evict_valuable(evict_walk->limit_pool, bo->resource->css,
-					      evict_walk->try_low, &evict_walk->hit_low))
+					      evict_walk->try_high, evict_walk->try_low,
+					      &evict_walk->hit_low))
 		return 0;
 
 	if (bo->pin_count || !bo->bdev->funcs->eviction_valuable(bo, evict_walk->place))
@@ -538,7 +541,7 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *
 	evict_walk->evicted++;
 	if (evict_walk->res)
 		lret = ttm_resource_alloc(evict_walk->evictor, evict_walk->place,
-					  evict_walk->res, NULL);
+					  evict_walk->res, NULL, NULL);
 	if (lret == 0)
 		return 1;
 out:
@@ -553,6 +556,42 @@ static const struct ttm_lru_walk_ops ttm_evict_walk_ops = {
 	.process_bo = ttm_bo_evict_cb,
 };
 
+/*
+ * Proactive reclaim: evict one BO from a cgroup that exceeds its dmem.high
+ * soft limit.  Called after a successful charge that pushed usage over the
+ * high threshold.  Best-effort; allocation already succeeded (soft limit).
+ *
+ * Returns the ttm_lru_walk_for_evict() result so callers using a ww_mutex
+ * ticket can detect -EDEADLK and run the required backoff instead of it
+ * being silently swallowed.
+ */
+static s64 ttm_bo_proactive_evict_high(struct ttm_device *bdev,
+				       struct ttm_resource_manager *man,
+				       const struct ttm_place *place,
+				       struct ttm_buffer_object *evictor,
+				       struct ttm_operation_ctx *ctx,
+				       struct ww_acquire_ctx *ticket,
+				       struct dmem_cgroup_pool_state *over_high_pool)
+{
+	struct ttm_bo_evict_walk evict_walk = {
+		.walk = {
+			.ops = &ttm_evict_walk_ops,
+			.arg = {
+				.ctx = ctx,
+				.ticket = ticket,
+				.trylock_only = !ticket,
+			}
+		},
+		.place = place,
+		.evictor = evictor,
+		.res = NULL,
+		.limit_pool = over_high_pool,
+		.try_high = true,
+	};
+
+	return ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
+}
+
 static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 			      struct ttm_resource_manager *man,
 			      const struct ttm_place *place,
@@ -579,29 +618,24 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 
 	evict_walk.walk.arg.trylock_only = true;
 	lret = ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
-
-	/* One more attempt if we hit low limit? */
 	if (!lret && evict_walk.hit_low) {
 		evict_walk.try_low = true;
 		lret = ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
 	}
+
 	if (lret || !ticket)
 		goto out;
 
-	/* Reset low limit */
 	evict_walk.try_low = evict_walk.hit_low = false;
-	/* If ticket-locking, repeat while making progress. */
 	evict_walk.walk.arg.trylock_only = false;
 
 retry:
 	do {
-		/* The walk may clear the evict_walk.walk.ticket field */
 		evict_walk.walk.arg.ticket = ticket;
 		evict_walk.evicted = 0;
 		lret = ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
 	} while (!lret && evict_walk.evicted);
 
-	/* We hit the low limit? Try once more */
 	if (!lret && evict_walk.hit_low && !evict_walk.try_low) {
 		evict_walk.try_low = true;
 		goto retry;
@@ -737,7 +771,26 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_object *bo,
 			continue;
 
 		may_evict = (force_space && place->mem_type != TTM_PL_SYSTEM);
-		ret = ttm_resource_alloc(bo, place, res, force_space ? &limit_pool : NULL);
+		{
+			struct dmem_cgroup_pool_state *over_high_pool = NULL;
+
+			ret = ttm_resource_alloc(bo, place, res,
+						 force_space ? &limit_pool : NULL,
+						 &over_high_pool);
+			if (!ret && over_high_pool) {
+				s64 evict_ret;
+
+				evict_ret = ttm_bo_proactive_evict_high(bdev, man, place,
+									bo, ctx, ticket,
+									over_high_pool);
+				if (evict_ret < 0) {
+					dmem_cgroup_pool_state_put(over_high_pool);
+					ttm_resource_free(bo, res);
+					return evict_ret;
+				}
+			}
+			dmem_cgroup_pool_state_put(over_high_pool);
+		}
 		if (ret) {
 			if (ret != -ENOSPC) {
 				dmem_cgroup_pool_state_put(limit_pool);
@@ -1152,7 +1205,7 @@ ttm_bo_swapout_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *bo)
 
 		memset(&hop, 0, sizeof(hop));
 		place.mem_type = TTM_PL_SYSTEM;
-		ret = ttm_resource_alloc(bo, &place, &evict_mem, NULL);
+		ret = ttm_resource_alloc(bo, &place, &evict_mem, NULL, NULL);
 		if (ret)
 			goto out;
 
diff --git a/drivers/gpu/drm/ttm/ttm_resource.c b/drivers/gpu/drm/ttm/ttm_resource.c
index 154d6739256f8..aca133a331063 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -389,7 +389,8 @@ EXPORT_SYMBOL(ttm_resource_fini);
 int ttm_resource_alloc(struct ttm_buffer_object *bo,
 		       const struct ttm_place *place,
 		       struct ttm_resource **res_ptr,
-		       struct dmem_cgroup_pool_state **ret_limit_pool)
+		       struct dmem_cgroup_pool_state **ret_limit_pool,
+		       struct dmem_cgroup_pool_state **ret_over_high_pool)
 {
 	struct ttm_resource_manager *man =
 		ttm_manager_type(bo->bdev, place->mem_type);
@@ -397,7 +398,8 @@ int ttm_resource_alloc(struct ttm_buffer_object *bo,
 	int ret;
 
 	if (man->cg) {
-		ret = dmem_cgroup_try_charge(man->cg, bo->base.size, &pool, ret_limit_pool);
+		ret = dmem_cgroup_try_charge(man->cg, bo->base.size, &pool,
+					     ret_limit_pool, ret_over_high_pool);
 		if (ret) {
 			if (ret == -EAGAIN)
 				ret = -ENOSPC;
@@ -409,6 +411,10 @@ int ttm_resource_alloc(struct ttm_buffer_object *bo,
 	if (ret) {
 		if (pool)
 			dmem_cgroup_uncharge(pool, bo->base.size);
+		if (ret_over_high_pool) {
+			dmem_cgroup_pool_state_put(*ret_over_high_pool);
+			*ret_over_high_pool = NULL;
+		}
 		return ret;
 	}
 
diff --git a/include/drm/ttm/ttm_resource.h b/include/drm/ttm/ttm_resource.h
index a5d386583fb6e..88fb402acfdc6 100644
--- a/include/drm/ttm/ttm_resource.h
+++ b/include/drm/ttm/ttm_resource.h
@@ -461,7 +461,8 @@ void ttm_resource_fini(struct ttm_resource_manager *man,
 int ttm_resource_alloc(struct ttm_buffer_object *bo,
 		       const struct ttm_place *place,
 		       struct ttm_resource **res,
-		       struct dmem_cgroup_pool_state **ret_limit_pool);
+		       struct dmem_cgroup_pool_state **ret_limit_pool,
+		       struct dmem_cgroup_pool_state **ret_over_high_pool);
 void ttm_resource_free(struct ttm_buffer_object *bo, struct ttm_resource **res);
 bool ttm_resource_intersects(struct ttm_device *bdev,
 			     struct ttm_resource *res,
diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
index dd4869f1d736e..1808bfbbc9a31 100644
--- a/include/linux/cgroup_dmem.h
+++ b/include/linux/cgroup_dmem.h
@@ -19,11 +19,12 @@ struct dmem_cgroup_region *dmem_cgroup_register_region(u64 size, const char *nam
 void dmem_cgroup_unregister_region(struct dmem_cgroup_region *region);
 int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 			   struct dmem_cgroup_pool_state **ret_pool,
-			   struct dmem_cgroup_pool_state **ret_limit_pool);
+			   struct dmem_cgroup_pool_state **ret_limit_pool,
+			   struct dmem_cgroup_pool_state **ret_over_high_pool);
 void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size);
 bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 				      struct dmem_cgroup_pool_state *test_pool,
-				      bool ignore_low, bool *ret_hit_low);
+				      bool try_high, bool ignore_low, bool *ret_hit_low);
 
 void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
 #else
@@ -38,13 +39,17 @@ static inline void dmem_cgroup_unregister_region(struct dmem_cgroup_region *regi
 
 static inline int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 					 struct dmem_cgroup_pool_state **ret_pool,
-					 struct dmem_cgroup_pool_state **ret_limit_pool)
+					 struct dmem_cgroup_pool_state **ret_limit_pool,
+					 struct dmem_cgroup_pool_state **ret_over_high_pool)
 {
 	*ret_pool = NULL;
 
 	if (ret_limit_pool)
 		*ret_limit_pool = NULL;
 
+	if (ret_over_high_pool)
+		*ret_over_high_pool = NULL;
+
 	return 0;
 }
 
@@ -54,8 +59,10 @@ static inline void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64
 static inline
 bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 				      struct dmem_cgroup_pool_state *test_pool,
-				      bool ignore_low, bool *ret_hit_low)
+				      bool try_high, bool ignore_low, bool *ret_hit_low)
 {
+	if (try_high)
+		return false;
 	return true;
 }
 
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4753a67d0f0f2..e314943290612 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -156,6 +156,12 @@ set_resource_low(struct dmem_cgroup_pool_state *pool, u64 val)
 	page_counter_set_low(&pool->cnt, val);
 }
 
+static void
+set_resource_high(struct dmem_cgroup_pool_state *pool, u64 val)
+{
+	page_counter_set_high(&pool->cnt, val);
+}
+
 static void
 set_resource_max(struct dmem_cgroup_pool_state *pool, u64 val)
 {
@@ -167,6 +173,11 @@ static u64 get_resource_low(struct dmem_cgroup_pool_state *pool)
 	return pool ? READ_ONCE(pool->cnt.low) : 0;
 }
 
+static u64 get_resource_high(struct dmem_cgroup_pool_state *pool)
+{
+	return pool ? READ_ONCE(pool->cnt.high) : PAGE_COUNTER_MAX;
+}
+
 static u64 get_resource_min(struct dmem_cgroup_pool_state *pool)
 {
 	return pool ? READ_ONCE(pool->cnt.min) : 0;
@@ -186,6 +197,7 @@ static void reset_all_resource_limits(struct dmem_cgroup_pool_state *rpool)
 {
 	set_resource_min(rpool, 0);
 	set_resource_low(rpool, 0);
+	set_resource_high(rpool, PAGE_COUNTER_MAX);
 	set_resource_max(rpool, PAGE_COUNTER_MAX);
 }
 
@@ -289,10 +301,13 @@ dmem_cgroup_calculate_protection(struct dmem_cgroup_pool_state *limit_pool,
  * dmem_cgroup_state_evict_valuable() - Check if we should evict from test_pool
  * @limit_pool: The pool for which we hit limits
  * @test_pool: The pool for which to test
+ * @try_high: Only evict BOs whose usage exceeds the high limit (first pass)
  * @ignore_low: Whether we have to respect low watermarks.
  * @ret_hit_low: Pointer to whether it makes sense to consider low watermark.
  *
  * This function returns true if we can evict from @test_pool, false if not.
+ * When @try_high is set, only pools with usage above their high limit are
+ * evictable, enabling prioritized eviction of over-limit cgroups.
  * When returning false and @ignore_low is false, @ret_hit_low may
  * be set to true to indicate this function can be retried with @ignore_low
  * set to true.
@@ -301,15 +316,26 @@ dmem_cgroup_calculate_protection(struct dmem_cgroup_pool_state *limit_pool,
  */
 bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 				      struct dmem_cgroup_pool_state *test_pool,
-				      bool ignore_low, bool *ret_hit_low)
+				      bool try_high, bool ignore_low, bool *ret_hit_low)
 {
 	struct dmem_cgroup_pool_state *pool = test_pool;
 	struct page_counter *ctest;
 	u64 used, min, low;
 
-	/* Can always evict from current pool, despite limits */
-	if (limit_pool == test_pool)
+	/*
+	 * When the limit-hitting cgroup's own BOs are being considered
+	 * in try_high mode, only evict them if their pool exceeds its
+	 * own dmem.high limit.  For non-try_high mode, maintain the
+	 * existing behavior: always evict from the limit-hitting pool.
+	 */
+	if (limit_pool == test_pool) {
+		if (try_high && test_pool) {
+			ctest = &test_pool->cnt;
+			used = page_counter_read(ctest);
+			return used > READ_ONCE(ctest->high);
+		}
 		return true;
+	}
 
 	if (limit_pool) {
 		if (!parent_dmemcs(limit_pool->cs))
@@ -330,10 +356,38 @@ bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 	}
 
 	ctest = &test_pool->cnt;
+	used = page_counter_read(ctest);
+
+	if (try_high) {
+		struct page_counter *c;
+
+		/*
+		 * Walk the page_counter parent chain to check whether any
+		 * ancestor cgroup exceeds its dmem.high limit.  This prevents
+		 * child cgroups from evading the penalty when a parent cgroup
+		 * is over its high limit.
+		 */
+		if (used <= READ_ONCE(ctest->high)) {
+			for (c = ctest->parent; c; c = c->parent) {
+				if (page_counter_read(c) > READ_ONCE(c->high))
+					break;
+			}
+			if (!c)
+				return false;
+		}
+
+		/*
+		 * Respect dmem.min protection: do not evict BOs below the
+		 * effective minimum even during the high-priority pass.
+		 */
+		dmem_cgroup_calculate_protection(limit_pool, test_pool);
+		min = READ_ONCE(ctest->emin);
+
+		return used > min;
+	}
 
 	dmem_cgroup_calculate_protection(limit_pool, test_pool);
 
-	used = page_counter_read(ctest);
 	min = READ_ONCE(ctest->emin);
 
 	if (used <= min)
@@ -634,8 +688,9 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  * dmem_cgroup_try_charge() - Try charging a new allocation to a region.
  * @region: dmem region to charge
  * @size: Size (in bytes) to charge.
- * @ret_pool: On succesfull allocation, the pool that is charged.
+ * @ret_pool: On successful allocation, the pool that is charged.
  * @ret_limit_pool: On a failed allocation, the limiting pool.
+ * @ret_over_high_pool: On successful allocation, set if usage exceeds dmem.high.
  *
  * This function charges the @region region for a size of @size bytes.
  *
@@ -647,11 +702,17 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  * eviction as argument to dmem_cgroup_evict_valuable(). This reference must be freed
  * with @dmem_cgroup_pool_state_put().
  *
+ * When the function succeeds and @ret_over_high_pool is non-null, it will be
+ * set if the charged pool's usage now exceeds its dmem.high soft limit. The
+ * caller should trigger proactive eviction to bring usage back under the limit.
+ * This reference must be freed with @dmem_cgroup_pool_state_put().
+ *
  * Return: 0 on success, -EAGAIN on hitting a limit, or a negative errno on failure.
  */
 int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 			  struct dmem_cgroup_pool_state **ret_pool,
-			  struct dmem_cgroup_pool_state **ret_limit_pool)
+			  struct dmem_cgroup_pool_state **ret_limit_pool,
+			  struct dmem_cgroup_pool_state **ret_over_high_pool)
 {
 	struct dmemcg_state *cg;
 	struct dmem_cgroup_pool_state *pool;
@@ -661,6 +722,8 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 	*ret_pool = NULL;
 	if (ret_limit_pool)
 		*ret_limit_pool = NULL;
+	if (ret_over_high_pool)
+		*ret_over_high_pool = NULL;
 
 	/*
 	 * hold on to css, as cgroup can be removed but resource
@@ -685,6 +748,31 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		goto err;
 	}
 
+	/*
+	 * Charge succeeded. Check if usage now exceeds the soft high limit on
+	 * this pool or on any ancestor, so the caller can trigger proactive
+	 * reclaim to bring the hierarchy back under its dmem.high threshold.
+	 * Walking the page_counter parent chain (as dmem_cgroup_state_evict_valuable()
+	 * does) keeps a descendant from dodging a limit that an ancestor is
+	 * actually violating.
+	 */
+	if (ret_over_high_pool) {
+		struct page_counter *c;
+
+		for (c = &pool->cnt; c; c = c->parent) {
+			struct dmem_cgroup_pool_state *over_pool;
+
+			if (page_counter_read(c) <= READ_ONCE(c->high))
+				continue;
+
+			over_pool = container_of(c, struct dmem_cgroup_pool_state, cnt);
+			*ret_over_high_pool = over_pool;
+			css_get(&over_pool->cs->css);
+			dmemcg_pool_get(over_pool);
+			break;
+		}
+	}
+
 	/* On success, reference from get_current_dmemcs is transferred to *ret_pool */
 	*ret_pool = pool;
 	return 0;
@@ -835,6 +923,17 @@ static ssize_t dmem_cgroup_region_low_write(struct kernfs_open_file *of,
 	return dmemcg_limit_write(of, buf, nbytes, off, set_resource_low);
 }
 
+static int dmem_cgroup_region_high_show(struct seq_file *sf, void *v)
+{
+	return dmemcg_limit_show(sf, v, get_resource_high);
+}
+
+static ssize_t dmem_cgroup_region_high_write(struct kernfs_open_file *of,
+					  char *buf, size_t nbytes, loff_t off)
+{
+	return dmemcg_limit_write(of, buf, nbytes, off, set_resource_high);
+}
+
 static int dmem_cgroup_region_max_show(struct seq_file *sf, void *v)
 {
 	return dmemcg_limit_show(sf, v, get_resource_max);
@@ -868,6 +967,12 @@ static struct cftype files[] = {
 		.seq_show = dmem_cgroup_region_low_show,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "high",
+		.write = dmem_cgroup_region_high_write,
+		.seq_show = dmem_cgroup_region_high_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{
 		.name = "max",
 		.write = dmem_cgroup_region_max_write,

---
base-commit: ab5fce87a778cb780a05984a2ca448f2b41aafbf
change-id: 20260519-feature-dmem-high-16997148dc38

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


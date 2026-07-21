Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87076385D67
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663073; cv=none; b=hrksWrXxUL2o/FOQFXuHPVUe6/4CsLSaXJj5qkvLa0Aa29TUGtT7KUs2dpIzk4xjp6IY/qO3Dozq2x7KH1WWKMuztSNDnrZtoGU8ONsCrV4e0wfjlzKcLUWewrXXfDBAFECSB1AGiu/OfAVn8SrTfGVFNCGxo5VJFd5+mCmtnDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663073; c=relaxed/simple;
	bh=YV6DE1ohFSO9PNBxRbr76byY/GXzsIvQ8RCehjiO/30=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=neY83w6dnd4HLVVzCSqtvPrEbWHzx9zZPgI7F9wON8l6sU44MEqzrToR085VCevrL7Ri36lJ7JVbjhnirDwjP2m6Tz5sQtwzoDidiHt8Ph8VlNf9WenELrEkilFawAjbeGO5Utfi4fuuctcjIw0Y8vJ6o7TSJWLZT85a5bVufuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=TpBZuiQf; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="TpBZuiQf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663046; x=1785267846; i=natalie.vock@gmx.de;
	bh=+72QWSEg6d1V9bVDKZYyCwt69OZh3UHuwA5VQ86J03I=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=TpBZuiQfyxqSwEvl43MVALtOltb57215gbwooPTCIZpzCbtIzixoPCEaZUfK7ZpW
	 bzY56bfB6UVcga/iGpdMBNeimPmbt4G2USQfbk6L3fCpfcJ7DHRDx7VXNLJFREqt8
	 Tdr4rX2PX4plO5PWD9sIJO157Fy7Z0sDXNtt2924PrEGDU7uzCvVGv5XPGscrGINc
	 8DiyT501kvSczr3ZJxS/NwRG0AIyEGyGe+ML1mHgH11ca4hknMa9+Lhv0SSFpBkMH
	 FpjYzBtZN9qZkTBxZ29HU8xZrZBspNsJLRRnHMA1uLeqTGOq923j+9zSZ8DiJ+Y+p
	 Gx+zTcDUmBUguVA3mQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M6ll8-1we1Jw0yD8-00510m; Tue, 21
 Jul 2026 21:44:06 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 21 Jul 2026 21:43:22 +0200
Subject: [PATCH v7 3/6] drm/ttm: Extract code for attempting allocation in
 a place
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260721-dmemcg-aggressive-protect-v7-3-97c4b1014315@gmx.de>
References: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
In-Reply-To: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
To: Maarten Lankhorst <dev@lankhorst.se>, 
 Maxime Ripard <mripard@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 =?utf-8?q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Natalie Vock <natalie.vock@gmx.de>, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:1Ksn7EvU3goxQYbbNoTCfA8DAc4t4VNf7cHXPDM6ArSPGDc4u5i
 eDqCq6bnRQ7cGHT45ZMCZT0UZvHyrczsY33U23N1njh3sIRPgoS1UhgYKLe+johy6REyY2Y
 KxVoVGgPQv0r3MLqQBYZt8vCGvW694+pcSzKKqdhzpyYG8DzXt8dM7yPorolzVGJ0XL7ibK
 8hoFJW2OhWffKV+NTb6zQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:O02mwlnGiFM=;9ZYsELJrjQkebSyrRxcdNJzgtsg
 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

Move all code for attempting allocation for a specific place to
ttm_bo_alloc_place. With subsequent patches, this logic is going to get
more complicated, so it helps readability to have this separate.

ttm_bo_alloc_at_place takes a pointer to a struct ttm_bo_alloc_state.
This struct holds various state produced by the allocation (e.g. cgroup
resource associated with the allocation) that the caller needs to keep
track of (and potentially dispose of). This is just the limiting cgroup
pool for now, but future patches will add more state needing to be tracked=
.

ttm_bo_alloc_at_place also communicates via return codes if eviction
using ttm_bo_evict_alloc should be attempted. This is preparation for
attempting eviction in more cases than just force_space being set.

No functional change intended.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
=2D--
 drivers/gpu/drm/ttm/ttm_bo.c | 101 +++++++++++++++++++++++++++++++++-----=
=2D----
 1 file changed, 79 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 3980f376e3ba4..7192c15f2fcef 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -488,6 +488,62 @@ int ttm_bo_evict_first(struct ttm_device *bdev, struc=
t ttm_resource_manager *man
 	return ret;
 }
=20
+struct ttm_bo_alloc_state {
+	/** @limit_pool: Which pool limit we should test against */
+	struct dmem_cgroup_pool_state *limit_pool;
+};
+
+/**
+ * ttm_bo_alloc_at_place - Attempt allocating a BO's backing store in a p=
lace
+ *
+ * @bo: The buffer to allocate the backing store of
+ * @place: The place to attempt allocation in
+ * @ctx: ttm_operation_ctx associated with this allocation
+ * @force_space: If we should evict buffers to force space
+ * @res: On allocation success, the resulting struct ttm_resource.
+ * @alloc_state: Object holding allocation state such as charged cgroups.
+ *
+ * Returns:
+ * -EBUSY: No space available, but allocation should be retried with ttm_=
bo_evict_alloc.
+ * -ENOSPC: No space available, allocation should not be retried.
+ * -ERESTARTSYS: An interruptible sleep was interrupted by a signal.
+ *
+ */
+static int ttm_bo_alloc_at_place(struct ttm_buffer_object *bo,
+				 const struct ttm_place *place,
+				 struct ttm_operation_ctx *ctx,
+				 bool force_space,
+				 struct ttm_resource **res,
+				 struct ttm_bo_alloc_state *alloc_state)
+{
+	bool may_evict;
+	int ret;
+
+	may_evict =3D force_space && place->mem_type !=3D TTM_PL_SYSTEM;
+
+	ret =3D ttm_resource_alloc(bo, place, res,
+				 force_space ? &alloc_state->limit_pool : NULL);
+
+	if (ret) {
+		/*
+		 * -EAGAIN means the charge failed, which we treat like an
+		 * allocation failure. Therefore, return an error code indicating
+		 * the allocation failed - either -EBUSY if the allocation should
+		 * be retried with eviction, or -ENOSPC if there should be no second
+		 * attempt.
+		 */
+		if (ret =3D=3D -EAGAIN)
+			return may_evict ? -EBUSY : -ENOSPC;
+
+		if (ret =3D=3D -ENOSPC && may_evict)
+			return -EBUSY;
+
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * struct ttm_bo_evict_walk - Parameters for the evict walk.
  */
@@ -503,12 +559,13 @@ struct ttm_bo_evict_walk {
 	/** @evicted: Number of successful evictions. */
 	unsigned long evicted;
=20
-	/** @limit_pool: Which pool limit we should test against */
-	struct dmem_cgroup_pool_state *limit_pool;
 	/** @try_low: Whether we should attempt to evict BO's with low watermark=
 threshold */
 	bool try_low;
 	/** @hit_low: If we cannot evict a bo when @try_low is false (first pass=
) */
 	bool hit_low;
+
+	/** @alloc_state: State associated with the allocation attempt. */
+	struct ttm_bo_alloc_state *alloc_state;
 };
=20
 static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_o=
bject *bo)
@@ -517,8 +574,9 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, =
struct ttm_buffer_object *
 		container_of(walk, typeof(*evict_walk), walk);
 	s64 lret;
=20
-	if (!dmem_cgroup_state_evict_valuable(evict_walk->limit_pool, bo->resour=
ce->css,
-					      evict_walk->try_low, &evict_walk->hit_low))
+	if (!dmem_cgroup_state_evict_valuable(evict_walk->alloc_state->limit_poo=
l,
+					      bo->resource->css, evict_walk->try_low,
+					      &evict_walk->hit_low))
 		return 0;
=20
 	if (bo->pin_count || !bo->bdev->funcs->eviction_valuable(bo, evict_walk-=
>place))
@@ -560,7 +618,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 			      struct ttm_operation_ctx *ctx,
 			      struct ww_acquire_ctx *ticket,
 			      struct ttm_resource **res,
-			      struct dmem_cgroup_pool_state *limit_pool)
+			      struct ttm_bo_alloc_state *state)
 {
 	struct ttm_bo_evict_walk evict_walk =3D {
 		.walk =3D {
@@ -573,7 +631,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 		.place =3D place,
 		.evictor =3D evictor,
 		.res =3D res,
-		.limit_pool =3D limit_pool,
+		.alloc_state =3D state,
 	};
 	s64 lret;
=20
@@ -724,9 +782,8 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_obj=
ect *bo,
=20
 	for (i =3D 0; i < placement->num_placement; ++i) {
 		const struct ttm_place *place =3D &placement->placement[i];
-		struct dmem_cgroup_pool_state *limit_pool =3D NULL;
+		struct ttm_bo_alloc_state alloc_state =3D {};
 		struct ttm_resource_manager *man;
-		bool may_evict;
=20
 		man =3D ttm_manager_type(bdev, place->mem_type);
 		if (!man || !ttm_resource_manager_used(man))
@@ -736,25 +793,25 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_o=
bject *bo,
 				    TTM_PL_FLAG_FALLBACK))
 			continue;
=20
-		may_evict =3D (force_space && place->mem_type !=3D TTM_PL_SYSTEM);
-		ret =3D ttm_resource_alloc(bo, place, res, force_space ? &limit_pool : =
NULL);
-		if (ret) {
-			if (ret !=3D -ENOSPC) {
-				dmem_cgroup_pool_state_put(limit_pool);
-				return ret;
-			}
-			if (!may_evict) {
-				dmem_cgroup_pool_state_put(limit_pool);
-				continue;
-			}
+		ret =3D ttm_bo_alloc_at_place(bo, place, ctx, force_space,
+				res, &alloc_state);
=20
+		if (ret =3D=3D -ENOSPC) {
+			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
+			continue;
+		} else if (ret =3D=3D -EBUSY) {
 			ret =3D ttm_bo_evict_alloc(bdev, man, place, bo, ctx,
-						 ticket, res, limit_pool);
-			dmem_cgroup_pool_state_put(limit_pool);
+						 ticket, res, &alloc_state);
+
+			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
+
 			if (ret =3D=3D -EBUSY)
 				continue;
-			if (ret)
+			else if (ret)
 				return ret;
+		} else if (ret) {
+			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
+			return ret;
 		}
=20
 		ret =3D ttm_bo_add_pipelined_eviction_fences(bo, man, ctx->no_wait_gpu)=
;

=2D-=20
2.55.0


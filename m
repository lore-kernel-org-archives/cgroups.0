Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A8C42047F
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831956; cv=none; b=gAL5nZox7S7CDz5KdD3aEEafddfCkdoQ99kpyNcM6o9RNFMr54S9a1sUc8Ca5j07g9Um+UPkdaNfdCaBiendX4sxU92XSt9wvREYMDyFDism12+fksWilF4+fnkH1OM3+YrGR+bWFReGVbTEZmdbCqW6go6t3dreMPiNC+LeMQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831956; c=relaxed/simple;
	bh=QuzYLdOe756H64vcR2XUvkO5F/JFFQHdbVCUzRb9I2A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DE1iKDJtpj2vEroNEVrGFcbtm18iMLuiAcpxESta5D3URHUV3gC4opC0O+fljai68Ehrzv/dIIUG72TGVOMhfROP6/E7ixCjcSprepJXk9iswgjZeqP4myz0iBB2YqulpR0vKswTyjjtbXtucqQnT2uyyM95EJpWB2lyLCmcsbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=RMOfdgz3; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="RMOfdgz3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831946; x=1786436746; i=natalie.vock@gmx.de;
	bh=iCc5YuvtDHFK5mc0cntp+m4h+SYl/t+MnLT+mQNWEWc=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=RMOfdgz3S9cmLDTq/FQ8XF4eKw2of6HE5bmBXf/z/kpF0uH2xpuQCj8hCKWPkvdp
	 E4MXqq9q1qqqaIIm7TFdypyg2sGp5/q7CGH/Dh5WkNXoHr+4cq+aMAhPGuQfQjwDG
	 uKCQ2n9tJ+WxgD8rKCUoCCn8c+Gm5BJg8k9qYPYOpSBrdoHlQS2fMGxuwli60VCkZ
	 FxL5N6gOZ7DNjQsfjvQjGiPyJ220JlWoZsyPaAnvNUz6WEdZWU0rohEUtgUwWuEjU
	 g9shU5AwS+LC2BuQla+Bh1wiNnW49N3GUEaCXoEfFad2Ht9ZN0FTZlogxZXJq8yFV
	 tDkk/JpT16UFJsEYcw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M1HZo-1wtvM01Dr8-00BUdW; Tue, 04
 Aug 2026 10:25:46 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 04 Aug 2026 10:25:18 +0200
Subject: [PATCH v8 3/6] drm/ttm: Extract code for attempting allocation in
 a place
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260804-dmemcg-aggressive-protect-v8-3-07af96681bf8@gmx.de>
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
In-Reply-To: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
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
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:t4q3v+Ng9JI6IW8pq55u1JNvwM0mn9gSC70mNAS24Jshqpn24OR
 EgzlRgZjUnmNt/kY0YkEmoRwjSgmjYZHqs1vs2ny9UYDIAz8nO0EWHLwNnP9z9vSSorSux7
 7MpZpAG5t4BxXagf1O/RQIJB1d0PDGxCb9u8f8XT/rUi/yhKmI0AF4wfTVVoK99mWQDDKVj
 HGDCB03n++rvmQ5CZ/0Mg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Q8jTc+gz+6M=;26qq0JAjLUkMLGNkD0tyDKLnYC6
 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
 qVuzL1Z3kLj/sJBZHBQiZ7P9aCVvxLBzbnK8Q=

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
 drivers/gpu/drm/ttm/ttm_bo.c | 90 +++++++++++++++++++++++++++++++++------=
=2D----
 1 file changed, 68 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 3980f376e3ba4..1cdb2172d5924 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -488,6 +488,51 @@ int ttm_bo_evict_first(struct ttm_device *bdev, struc=
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
@@ -503,12 +548,13 @@ struct ttm_bo_evict_walk {
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
@@ -517,8 +563,9 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, =
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
@@ -560,7 +607,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 			      struct ttm_operation_ctx *ctx,
 			      struct ww_acquire_ctx *ticket,
 			      struct ttm_resource **res,
-			      struct dmem_cgroup_pool_state *limit_pool)
+			      struct ttm_bo_alloc_state *state)
 {
 	struct ttm_bo_evict_walk evict_walk =3D {
 		.walk =3D {
@@ -573,7 +620,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 		.place =3D place,
 		.evictor =3D evictor,
 		.res =3D res,
-		.limit_pool =3D limit_pool,
+		.alloc_state =3D state,
 	};
 	s64 lret;
=20
@@ -724,9 +771,8 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_obj=
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
@@ -736,25 +782,25 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_o=
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
+		ret =3D ttm_bo_alloc_at_place(bo, place, force_space, res,
+					    &alloc_state);
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


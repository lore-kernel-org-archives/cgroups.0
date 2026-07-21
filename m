Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E1B470454
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663074; cv=none; b=cKBSqtFxZRmXqAeOotcKxBefh4J/0VBfQE5HNn9UwWEr5KoQw02r+VKYVUUQodQH4847mH8Uhv9puSOc/3KkjJAJYK4aXVssVUIMTFi1liCvtmSzMnf6o3nKIGorx/zCACjafRDIM3e85XzMetMvf101uSHznINL59gbgKLONkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663074; c=relaxed/simple;
	bh=m6GDvOlhTBF67YCpWbCvzaRIN0eY8oK6WS2mU7obXAI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ay5SDdWT9EiUHiXxvZtl62Buq2nkpnIWatwYsQAT+vu8zfEQZd8PDwtQBwJCQXcgau8ofkdyr225DqnKF1VLDux+wi3v0Cguy1bh/FkaOZMj/F/TWMsRfDPB57ZxqcYtcFOa+72ZatSt7vFTNIaL0v2UlcqAemn23KK6ECx3cfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=SGj0Syye; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="SGj0Syye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663047; x=1785267847; i=natalie.vock@gmx.de;
	bh=/Yu6sODFVd/Oz75r2qVCHeOVZU7mmuD6Ud80nceXAhc=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=SGj0SyyeFHEjmKkwk4w2Ud3DIvh2UkJ8RJiugiduMEo3EZ6rFgAFm7pOA7S0upqO
	 /WuLn8n0lgeFB1dmhQlb6OeUjn5+lLDx7urS6OFmfDlr+CkEgquw3svrZmhpsYuYR
	 KxaywORXmJD9lWdH4Cc+MbdBpey/DYInlvJ3yxlXZmn+L4umHhWKSWlCbpoUJRVJz
	 uBXMPE6sJp+pVsQW95OGUw9SQ5/wszZQBk73xge0Wzkxe1WK3xY8ZQ3HHNP9SDcm/
	 OIFz/57abU3TckFnnynsg7c8pXBK2115DY/qZLNZkCYp8oe+t0N+PO6BcASJsf18o
	 cep9nRHyBZSaowXogw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mkpex-1xQ1Wa0FQd-00iyXl; Tue, 21
 Jul 2026 21:44:07 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 21 Jul 2026 21:43:23 +0200
Subject: [PATCH v7 4/6] drm/ttm: Split cgroup charge and resource
 allocation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260721-dmemcg-aggressive-protect-v7-4-97c4b1014315@gmx.de>
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
 Natalie Vock <natalie.vock@gmx.de>
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:W7MAoPndvs/+/dTiLvM0JePVLGxwMAPkeciUyo8/9oWWQbB1ZdH
 iRpzTbz+hjFPkmOPcKnxmjkkpfH3rSILHmRZ4IJj/Lf4bSk/kp/hMh0dJpNPfD/pf5L5cAD
 XKCgSYAVAsPN0zKDmBvokIbalvLhgFlhgYGpCXZJSKTUZ9V8WVxbtzAbfR3Rz+gdAtNTftR
 OSmHdy2uyYLQ3a5pIsWcA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:zZALS1+mOj8=;CvUYiDl6DZvNfoZSO39nEisA2CD
 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

Coupling resource allocation and cgroup charging is racy when charging
succeeds, but subsequent resource allocation fails. Certain eviction
decisions are made on the basis of whether the allocating cgroup is
protected, i.e. within its min/low limits, but with the charge being
tied to resource allocation (and uncharged when the resource allocation
fails), this check is done at a point where the allocation is not actually
charged to the cgroup.

This is subtly wrong if the allocation were to cause the cgroup to exceed
the min/low protection, but it's even more wrong if the same cgroup tries
allocating multiple buffers concurrently: In this case, the min/low
protection may pass for all allocation attempts when the real min/low
protection covers only some, or potentially none of the allocated
buffers.

Instead, charge the allocation to the cgroup once and keep the charge
for as long as we try to allocate a ttm_resource, and only undo the charge
if allocating the resource is ultimately unsuccessful and we move on to
a different ttm_place.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
=2D--
 drivers/gpu/drm/ttm/ttm_bo.c       | 66 ++++++++++++++++++++++++++-------=
=2D----
 drivers/gpu/drm/ttm/ttm_resource.c | 51 ++++++++++++++++++++---------
 include/drm/ttm/ttm_resource.h     |  6 +++-
 3 files changed, 85 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 7192c15f2fcef..95ce3fc0f8764 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -489,8 +489,12 @@ int ttm_bo_evict_first(struct ttm_device *bdev, struc=
t ttm_resource_manager *man
 }
=20
 struct ttm_bo_alloc_state {
+	/** @charge_pool: The memory pool the resource is charged to */
+	struct dmem_cgroup_pool_state *charge_pool;
 	/** @limit_pool: Which pool limit we should test against */
 	struct dmem_cgroup_pool_state *limit_pool;
+	/** @in_evict: Whether we are currently evicting buffers */
+	bool in_evict;
 };
=20
 /**
@@ -519,28 +523,39 @@ static int ttm_bo_alloc_at_place(struct ttm_buffer_o=
bject *bo,
 	bool may_evict;
 	int ret;
=20
-	may_evict =3D force_space && place->mem_type !=3D TTM_PL_SYSTEM;
-
-	ret =3D ttm_resource_alloc(bo, place, res,
-				 force_space ? &alloc_state->limit_pool : NULL);
+	may_evict =3D !alloc_state->in_evict && force_space &&
+		    place->mem_type !=3D TTM_PL_SYSTEM;
+	if (!alloc_state->charge_pool) {
+		ret =3D ttm_resource_try_charge(bo, place, &alloc_state->charge_pool,
+					      force_space ? &alloc_state->limit_pool
+							  : NULL);
+		if (ret) {
+			/*
+			 * -EAGAIN means the charge failed, which we treat
+			 * like an allocation failure. Therefore, return an
+			 * error code indicating the allocation failed -
+			 * either -EBUSY if the allocation should be
+			 * retried with eviction, or -ENOSPC if there should
+			 * be no second attempt.
+			 */
+			if (ret =3D=3D -EAGAIN)
+				ret =3D may_evict ? -EBUSY : -ENOSPC;
+			return ret;
+		}
+	}
=20
+	ret =3D ttm_resource_alloc(bo, place, res, alloc_state->charge_pool);
 	if (ret) {
-		/*
-		 * -EAGAIN means the charge failed, which we treat like an
-		 * allocation failure. Therefore, return an error code indicating
-		 * the allocation failed - either -EBUSY if the allocation should
-		 * be retried with eviction, or -ENOSPC if there should be no second
-		 * attempt.
-		 */
-		if (ret =3D=3D -EAGAIN)
-			return may_evict ? -EBUSY : -ENOSPC;
-
 		if (ret =3D=3D -ENOSPC && may_evict)
-			return -EBUSY;
-
+			ret =3D -EBUSY;
 		return ret;
 	}
=20
+	/*
+	 * Ownership of charge_pool has been transferred to the TTM resource,
+	 * don't make the caller think we still hold a reference to it.
+	 */
+	alloc_state->charge_pool =3D NULL;
 	return 0;
 }
=20
@@ -595,8 +610,9 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, =
struct ttm_buffer_object *
=20
 	evict_walk->evicted++;
 	if (evict_walk->res)
-		lret =3D ttm_resource_alloc(evict_walk->evictor, evict_walk->place,
-					  evict_walk->res, NULL);
+		lret =3D ttm_bo_alloc_at_place(evict_walk->evictor, evict_walk->place,
+					     walk->arg.ctx, false, evict_walk->res,
+					     evict_walk->alloc_state);
 	if (lret =3D=3D 0)
 		return 1;
 out:
@@ -635,6 +651,8 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 	};
 	s64 lret;
=20
+	state->in_evict =3D true;
+
 	evict_walk.walk.arg.trylock_only =3D true;
 	lret =3D ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
=20
@@ -665,6 +683,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 		goto retry;
 	}
 out:
+	state->in_evict =3D false;
 	if (lret < 0)
 		return lret;
 	if (lret =3D=3D 0)
@@ -797,6 +816,7 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_obj=
ect *bo,
 				res, &alloc_state);
=20
 		if (ret =3D=3D -ENOSPC) {
+			dmem_cgroup_uncharge(alloc_state.charge_pool, bo->base.size);
 			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
 			continue;
 		} else if (ret =3D=3D -EBUSY) {
@@ -805,11 +825,15 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_o=
bject *bo,
=20
 			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
=20
-			if (ret =3D=3D -EBUSY)
-				continue;
-			else if (ret)
+			if (ret) {
+				dmem_cgroup_uncharge(alloc_state.charge_pool,
+						bo->base.size);
+				if (ret =3D=3D -EBUSY)
+					continue;
 				return ret;
+			}
 		} else if (ret) {
+			dmem_cgroup_uncharge(alloc_state.charge_pool, bo->base.size);
 			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
 			return ret;
 		}
diff --git a/drivers/gpu/drm/ttm/ttm_resource.c b/drivers/gpu/drm/ttm/ttm_=
resource.c
index 154d6739256f8..02eca679cb68c 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -386,33 +386,52 @@ void ttm_resource_fini(struct ttm_resource_manager *=
man,
 }
 EXPORT_SYMBOL(ttm_resource_fini);
=20
+/**
+ * ttm_resource_try_charge - charge a resource manager's cgroup pool
+ * @bo: buffer for which an allocation should be charged
+ * @place: where the allocation is attempted to be placed
+ * @ret_pool: on charge success, the pool that was charged
+ * @ret_limit_pool: on charge failure, the pool responsible for the failu=
re
+ *
+ * Should be used to charge cgroups before attempting resource allocation=
.
+ * When charging succeeds, the value of ret_pool should be passed to
+ * ttm_resource_alloc.
+ *
+ * Returns: 0 on charge success, negative errno on failure.
+ */
+int ttm_resource_try_charge(struct ttm_buffer_object *bo,
+			    const struct ttm_place *place,
+			    struct dmem_cgroup_pool_state **ret_pool,
+			    struct dmem_cgroup_pool_state **ret_limit_pool)
+{
+	struct ttm_resource_manager *man =3D
+		ttm_manager_type(bo->bdev, place->mem_type);
+
+	if (!man->cg) {
+		*ret_pool =3D NULL;
+		if (ret_limit_pool)
+			*ret_limit_pool =3D NULL;
+		return 0;
+	}
+
+	return dmem_cgroup_try_charge(man->cg, bo->base.size, ret_pool,
+				      ret_limit_pool);
+}
+
 int ttm_resource_alloc(struct ttm_buffer_object *bo,
 		       const struct ttm_place *place,
 		       struct ttm_resource **res_ptr,
-		       struct dmem_cgroup_pool_state **ret_limit_pool)
+		       struct dmem_cgroup_pool_state *charge_pool)
 {
 	struct ttm_resource_manager *man =3D
 		ttm_manager_type(bo->bdev, place->mem_type);
-	struct dmem_cgroup_pool_state *pool =3D NULL;
 	int ret;
=20
-	if (man->cg) {
-		ret =3D dmem_cgroup_try_charge(man->cg, bo->base.size, &pool, ret_limit=
_pool);
-		if (ret) {
-			if (ret =3D=3D -EAGAIN)
-				ret =3D -ENOSPC;
-			return ret;
-		}
-	}
-
 	ret =3D man->func->alloc(man, bo, place, res_ptr);
-	if (ret) {
-		if (pool)
-			dmem_cgroup_uncharge(pool, bo->base.size);
+	if (ret)
 		return ret;
-	}
=20
-	(*res_ptr)->css =3D pool;
+	(*res_ptr)->css =3D charge_pool;
=20
 	spin_lock(&bo->bdev->lru_lock);
 	ttm_resource_add_bulk_move(*res_ptr, bo);
diff --git a/include/drm/ttm/ttm_resource.h b/include/drm/ttm/ttm_resource=
.h
index a5d386583fb6e..e567b7ec8218f 100644
=2D-- a/include/drm/ttm/ttm_resource.h
+++ b/include/drm/ttm/ttm_resource.h
@@ -458,10 +458,14 @@ void ttm_resource_init(struct ttm_buffer_object *bo,
 void ttm_resource_fini(struct ttm_resource_manager *man,
 		       struct ttm_resource *res);
=20
+int ttm_resource_try_charge(struct ttm_buffer_object *bo,
+			    const struct ttm_place *place,
+			    struct dmem_cgroup_pool_state **ret_pool,
+			    struct dmem_cgroup_pool_state **ret_limit_pool);
 int ttm_resource_alloc(struct ttm_buffer_object *bo,
 		       const struct ttm_place *place,
 		       struct ttm_resource **res,
-		       struct dmem_cgroup_pool_state **ret_limit_pool);
+		       struct dmem_cgroup_pool_state *charge_pool);
 void ttm_resource_free(struct ttm_buffer_object *bo, struct ttm_resource =
**res);
 bool ttm_resource_intersects(struct ttm_device *bdev,
 			     struct ttm_resource *res,

=2D-=20
2.55.0


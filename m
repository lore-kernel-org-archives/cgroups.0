Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A727439F6C
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831955; cv=none; b=Q9iF0ZqRlIVfC7ibSivjJG1L1w2nfnpzkYQgGKa2CAckaAyopVHKyCh7jdueA4dmm9Z5xRwEi3Yogb0tlrhQbz11rXORO1uvmuGin5BKZv5K47jUQs1qE35CIfkqiwtq9LEKCN7iRkpm5yzOKKXElhKICor+JTxHa80i+YQGprc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831955; c=relaxed/simple;
	bh=2TKt3Qp9F6YspYeVw9ZxYe1CxTgVwFH91ci0j2w5kQ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SsfA2ABTB1kC7WMp0ic2+Ghsg9dA9lrGXAaWS3897mlTEnIozy2b9RWd7sKI0IpHipTDHQckhg/qdvebT/weqA+eHcbOydo5mz69/HuBPt3s6WFKQNv+j4KpnMAX5Q8QRPaF2cgcBO7biXxbHsdqUJvPX/aV6RHh97C4AbCIzLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=FXBPDDfx; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="FXBPDDfx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831947; x=1786436747; i=natalie.vock@gmx.de;
	bh=qD7UEF1L+9dYFNjtqhgDXM7CHvDj5fCg6P8PmuLfBYE=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=FXBPDDfxgGArIxIXZIbHaHEgLl9d7lkEoC8gQtvz3XBD246iPgGINUlrcCKzsHXd
	 ij/ulHbAubCXBclXe+cuOa9VruzeWFui1H7VEzR2o+PRujcVCD3UR3lwqQPb/85kQ
	 bHC4CoK4pXLtZ9PWHx5qo00qpXsK4tGTnUUwXpHpHd4Xwe/Hwxj5fq5ly9NAqbZ93
	 NbaTOvjfrL69cBlHQ/yq88rfu2fg2FMJqGr88sDrAvmxsRGqMBh0zpdMCCNy+IrX0
	 C5dU9B9PgaHBYe8KT+aVFWS2RpfEhCy+pl+kOWkpuknhCrOD7sS3FBoPEnu3OVujZ
	 u8uGQuP6H2FepDOSXw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M3lc9-1wrRRx44bT-0090jT; Tue, 04
 Aug 2026 10:25:47 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 04 Aug 2026 10:25:19 +0200
Subject: [PATCH v8 4/6] drm/ttm: Split cgroup charge and resource
 allocation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260804-dmemcg-aggressive-protect-v8-4-07af96681bf8@gmx.de>
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
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:fFFLpUVGREvdS4alQ73bIUeoRCzf31e/LRZ9m4zithl9qHsnAqi
 jpVFd16kxHwKLluY8FOukehyOsXhF8AK11xHFjeWD2w/5YjWm+lJU5lAszSROFXYdZ5VQOk
 Nv1ON6f5A8GS0yIWzRLU+lwxbOZO9FtY9gAE9SUJSvacGxjGxG4V6tCsys5gU41KvNXo/xC
 RJMSKICeMyfRHW9H3raLg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0nAxzyfrQkQ=;E0UiwafZorRAyON7O/jRLvJLf1I
 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
 PYLtFpxJ+taObBv/ZiNUUO2SPa1urfoKchWIU=

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
 drivers/gpu/drm/ttm/ttm_bo.c       | 57 ++++++++++++++++++++++++++++++---=
=2D----
 drivers/gpu/drm/ttm/ttm_resource.c | 51 +++++++++++++++++++++++----------=
-
 include/drm/ttm/ttm_resource.h     |  6 +++-
 3 files changed, 86 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 1cdb2172d5924..3becddd2c43b8 100644
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
@@ -518,18 +522,39 @@ static int ttm_bo_alloc_at_place(struct ttm_buffer_o=
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
@@ -584,8 +609,10 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk,=
 struct ttm_buffer_object *
=20
 	evict_walk->evicted++;
 	if (evict_walk->res)
-		lret =3D ttm_resource_alloc(evict_walk->evictor, evict_walk->place,
-					  evict_walk->res, NULL);
+		lret =3D ttm_bo_alloc_at_place(evict_walk->evictor,
+					     evict_walk->place, false,
+					     evict_walk->res,
+					     evict_walk->alloc_state);
 	if (lret =3D=3D 0)
 		return 1;
 out:
@@ -624,6 +651,8 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 	};
 	s64 lret;
=20
+	state->in_evict =3D true;
+
 	evict_walk.walk.arg.trylock_only =3D true;
 	lret =3D ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
=20
@@ -654,6 +683,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 		goto retry;
 	}
 out:
+	state->in_evict =3D false;
 	if (lret < 0)
 		return lret;
 	if (lret =3D=3D 0)
@@ -786,6 +816,7 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_obj=
ect *bo,
 					    &alloc_state);
=20
 		if (ret =3D=3D -ENOSPC) {
+			dmem_cgroup_uncharge(alloc_state.charge_pool, bo->base.size);
 			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
 			continue;
 		} else if (ret =3D=3D -EBUSY) {
@@ -794,11 +825,15 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_o=
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


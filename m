Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F835DA40
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663062; cv=none; b=NWOZ//bSv6qcExV4m30enUykfPLOXF84s4dnBdeVimP7u+BHXNcEvpFU3VXHuVQdR3lmRbXmTxHVDX++db9eACDtq5iPsK4oIw9O49UxNdLJYOM3tZNs57Arq0EDVzV8+HId8SirwQ96knSQ0s16IfYycmdfKB/9mmafD0bnfMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663062; c=relaxed/simple;
	bh=GwQs70/Kf0OBZAtsY6FWCMag0jJNd/WCXLT5F7USAFw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aDVhfGJCBrcxwyylXhZue9hi+723Em5wXIasiFYDabF3E+wJDxNb1Hha5ZPWObJhYgIRnPPlQo0QMSkxSl7KhA5AlrNjs9ndD1cZK8Kqqn8ibnkBFQ9aivZDiFwsMNrosq17Ffr/Ng9OSDEUqT8clYMJ2SIpuW85C5EXjqKByBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=kzrEUOaP; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="kzrEUOaP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663048; x=1785267848; i=natalie.vock@gmx.de;
	bh=UnZMmqHtP1zcqwJ3EtkMD3eL7B10z/Nt5iL6vLDe3w4=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kzrEUOaPE4VgVVexms1qAOSKdw5p/xC8LGoq8Z8EPol+alNpIQchZ7ZSJTi5RbhD
	 t8M/63Bph7qU/EGfQhcmZ5OuArmPmt6ndCMhL1/aGTfxwvf5gDv5Gc3u0z4ZUsZp6
	 18dF3MESgrRscONREZTrmds80wF0sjjtyiwurmNxn+6vnaGorvzrTlyn7adNhfyk/
	 iQCNJbuq9AOHSVtSQUEJs+P7qXpQiuH3GfG58eROJ6iPX0pFgK+hTSkGpHzAteF6m
	 IVeoutO5XIqifjg9hyggVfUpaxH+ztqJK/TJher6MsjhZQ6O8ZyVaE4UM20YhMdCD
	 hzEYo/tfryRLZWNVOg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M4s51-1wkKyd09zT-00348j; Tue, 21
 Jul 2026 21:44:08 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 21 Jul 2026 21:43:24 +0200
Subject: [PATCH v7 5/6] drm/ttm: Be more aggressive when allocating below
 protection limit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260721-dmemcg-aggressive-protect-v7-5-97c4b1014315@gmx.de>
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
X-Provags-ID: V03:K1:v3+zZjoPagCcmVkuo/SaUqFityoXyrYDtBVe+Kx5OO6b5+EAppG
 btpegqjy3pE5B2x+1BcUa9QWjGTnFb2gx+h5HcJeki4dvHqrT9l8KwCCjyMAnplYEhjKunx
 ysj8zJOnff/ncsTdOD4soR6PMPYDc5/j3ys6Fudc30GR+Fp3Dhit6bhPRUGrQ3KfTxVS0sg
 gZ6VnTyPwzwJKsrsjsILg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LBjWuJ3DIp8=;sanekQJPrGc+nKXgg6CfbV+aRBj
 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

When the cgroup's memory usage is below the low/min limit and allocation
fails, try evicting some unprotected buffers to make space. Otherwise,
application buffers may be forced to go into GTT even though usage is
below the corresponding low/min limit, if other applications filled VRAM
with their allocations first.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
=2D--
 drivers/gpu/drm/ttm/ttm_bo.c | 51 +++++++++++++++++++++++++++++++++++++++=
++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 95ce3fc0f8764..ec0821e306da1 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -495,6 +495,10 @@ struct ttm_bo_alloc_state {
 	struct dmem_cgroup_pool_state *limit_pool;
 	/** @in_evict: Whether we are currently evicting buffers */
 	bool in_evict;
+	/** @may_try_low: If only unprotected BOs, i.e. BOs whose cgroup
+	 *  is exceeding its dmem low/min protection, should be considered for e=
viction
+	 */
+	bool may_try_low;
 };
=20
 /**
@@ -544,6 +548,42 @@ static int ttm_bo_alloc_at_place(struct ttm_buffer_ob=
ject *bo,
 		}
 	}
=20
+	/*
+	 * cgroup protection plays a special role in eviction.
+	 * Conceptually, protection of memory via the dmem cgroup controller
+	 * entitles the protected cgroup to use a certain amount of memory.
+	 * There are two types of protection - the 'low' limit is a
+	 * "best-effort" protection, whereas the 'min' limit provides a hard
+	 * guarantee that memory within the cgroup's allowance will not be
+	 * evicted under any circumstance.
+	 *
+	 * To faithfully model this concept in TTM, we also need to take cgroup
+	 * protection into account when allocating. When allocation in one
+	 * place fails, TTM will default to trying other places first before
+	 * evicting.
+	 * If the allocation is covered by dmem cgroup protection, however,
+	 * this prevents the allocation from using the memory it is "entitled"
+	 * to. To make sure unprotected allocations cannot push new protected
+	 * allocations out of places they are "entitled" to use, we should
+	 * evict buffers not covered by any cgroup protection, if this
+	 * allocation is covered by cgroup protection.
+	 *
+	 * Buffers covered by 'min' protection are a special case - the 'min'
+	 * limit is a stronger guarantee than 'low', and thus buffers protected
+	 * by 'low' but not 'min' should also be considered for eviction.
+	 * Buffers protected by 'min' will never be considered for eviction
+	 * anyway, so the regular eviction path should be triggered here.
+	 * Buffers protected by 'low' but not 'min' will take a special
+	 * eviction path that only evicts buffers covered by neither 'low' or
+	 * 'min' protections.
+	 */
+	if (!alloc_state->in_evict) {
+		may_evict |=3D dmem_cgroup_below_min(NULL, alloc_state->charge_pool);
+		alloc_state->may_try_low =3D may_evict;
+
+		may_evict |=3D dmem_cgroup_below_low(NULL, alloc_state->charge_pool);
+	}
+
 	ret =3D ttm_resource_alloc(bo, place, res, alloc_state->charge_pool);
 	if (ret) {
 		if (ret =3D=3D -ENOSPC && may_evict)
@@ -656,8 +696,12 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev=
,
 	evict_walk.walk.arg.trylock_only =3D true;
 	lret =3D ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
=20
-	/* One more attempt if we hit low limit? */
-	if (!lret && evict_walk.hit_low) {
+	/* If we failed to find enough BOs to evict, but we skipped over
+	 * some BOs because they were covered by dmem low protection, retry
+	 * evicting these protected BOs too, except if we're told not to
+	 * consider protected BOs at all.
+	 */
+	if (!lret && evict_walk.hit_low && state->may_try_low) {
 		evict_walk.try_low =3D true;
 		lret =3D ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man, 1);
 	}
@@ -678,7 +722,8 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
 	} while (!lret && evict_walk.evicted);
=20
 	/* We hit the low limit? Try once more */
-	if (!lret && evict_walk.hit_low && !evict_walk.try_low) {
+	if (!lret && evict_walk.hit_low && !evict_walk.try_low &&
+			state->may_try_low) {
 		evict_walk.try_low =3D true;
 		goto retry;
 	}

=2D-=20
2.55.0


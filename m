Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE071420E9F
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831958; cv=none; b=bJrJpOXULIaJUzLpk8Fk3oMR8quwOd83ADpQMpY9HVelETAR7mX4NQOKtl3MLSPQNPXPlwYP4mYIJW4QVBt5Dveaak/aaPiLqWhub5tZhlZvjVJRiT+8iAaN8/5kn55/izadTaiR5ovYvHbdXrmlSVbVmKvk6d2m/x++SXIh0qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831958; c=relaxed/simple;
	bh=7Uya/4k3aK5zjzAgeUPmgC8Crb9TcDnKkdfpNL9ZpwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rmaIzoOiMFQo0grRg1fZcQuWVZih6sz0dPWgiTGIGTDS1QOoioQdO8EBY2OGw1Ua6qaSOnQeoRPZ3KQ07EOvz4tWqlEmG8ZNYbTIV0HLagYjzlEWJ9XK7MFFbbAclSP1IziX1/Bx0oLa8jPhMpGHlMKHn8jjPF/huv0+NfY+j34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=rZiM/HOO; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="rZiM/HOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831948; x=1786436748; i=natalie.vock@gmx.de;
	bh=62HbuEg68D4s2YJSvsEvtNu/R52PjYaSc4kK39GJbyQ=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rZiM/HOOmPrZLVtlANdejg1I5Hwx7HI+BJH1TIzxBZxcT7yPgGls6eE6NaxRWNwx
	 +ESMkxuUPhj2sM77mHoaO/mg+50mXCTRBvWyyiTBt3QGo6MMoPy3HsPa+KqYfnSbW
	 MOsqDhBXdRFr37/IDCY03jzbfA0kwG6DHYzV6XsrBsFAWpgECuAqGl2s8LX3aMWhr
	 M1ibBmlsLottJJpuJlC7WwSt0R/qfx3w9zZooUom0NN29sUVj70zxyVt2fmQQid/e
	 R3Q/2lkm+C1X7yorvEOue9i+sJ1WGQLzr5aEpTfrYVtHZfNz+7b0Cc89wEK9MTg7i
	 GzXzhIRHInKzRIXyEQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MzyuS-1x5y6H3Qxy-015O4k; Tue, 04
 Aug 2026 10:25:47 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 04 Aug 2026 10:25:20 +0200
Subject: [PATCH v8 5/6] drm/ttm: Be more aggressive when allocating below
 protection limit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260804-dmemcg-aggressive-protect-v8-5-07af96681bf8@gmx.de>
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
X-Provags-ID: V03:K1:ZZSO06WQ+m74AH0Omf5ZDT2RxUEJMPPF5IuNf6BAgchBJPuTwju
 F8E8K+kPcMBVOgt4F4fgOIFh3oaB0/IFenmu9FMBd4QlVZZ9ZlCoMuAv3ZSK/zjFxk7JGHP
 aM8jpaXw1jrxkt+YE49VGmP5Iz2R243RdfPHqH2GOQYn38I1Icj1yU7Wi5uVma4d7BoaFMK
 zSh9qYZ+FqA7L+d2JONLQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:b8MTsNmQ5ck=;5jDxtSI0I00MU7gYGLw8NzAyK00
 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
 ++cYoP6ptEQqtD/WbX60RR8qhp/kWtT980/XI=

When the cgroup's memory usage is below the low/min limit and allocation
fails, try evicting some unprotected buffers to make space. Otherwise,
application buffers may be forced to go into GTT even though usage is
below the corresponding low/min limit, if other applications filled VRAM
with their allocations first.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
=2D--
 drivers/gpu/drm/ttm/ttm_bo.c | 53 +++++++++++++++++++++++++++++++++++++++=
++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 3becddd2c43b8..6bbea148838e4 100644
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
@@ -537,12 +541,50 @@ static int ttm_bo_alloc_at_place(struct ttm_buffer_o=
bject *bo,
 			 * retried with eviction, or -ENOSPC if there should
 			 * be no second attempt.
 			 */
+			if (!alloc_state->in_evict)
+				alloc_state->may_try_low =3D may_evict;
 			if (ret =3D=3D -EAGAIN)
 				ret =3D may_evict ? -EBUSY : -ENOSPC;
 			return ret;
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
@@ -656,8 +698,12 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev=
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
@@ -678,7 +724,8 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
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


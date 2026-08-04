Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9CE421249
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831969; cv=none; b=nrGLjrr6CSgnc7aH2lgQC8m7Z8HKKfVqvHbtrrYsLUZi6jrkULxBIK/HinzdLnfM391fTmBHr8xevY6GyAxxv+4BJhj9f9A3Gs17eivMbxQSShu6mGbDllJJpqXZdrQ7VGRCLuB2H1VKD/TRHZA9aMf8dicKP6eLgSTz+aW6/zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831969; c=relaxed/simple;
	bh=qKRXc7DyW3Vozds1os9BlTJwfvYhmJsi7GEvKRou3Po=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QK6SsipY5+cmbb5/6XnX5KYpSXsfwVShb0RMeIih4rvArvWrXzuA7luiTF6jb80oUpNBxZbEdE0bHaALil0mlEjZogDhGPc0OnlEmot1gMxWQ/CVxdhw8pbY0bETGQqRE00YEWcSrgQOkwG7XUjVi0tAsieZaMu7wb0AVRakKGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=EKLu6muX; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="EKLu6muX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831948; x=1786436748; i=natalie.vock@gmx.de;
	bh=9SdJA9r8x3gcpZHDMk57e7YTmDTmWwsLMqbPoWn2pFs=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=EKLu6muXG78vEVfd9FkboAAtla3qjY7bxq122coZc/a7AfR2L0XJRt4PBUJ7Xeep
	 tETVg3+eMXbClavE7nT8pqYXB/rtelEMpWJH7JU+epTHKBXrlk/O30/4UJwvtEngZ
	 bqxQHGcWntzN6isQGFi+O0+wY9cREfZssuyiiRkTn9xLYkChX0K4Pu+c1BKRn+ljT
	 T/zcAFm8v8+3wL/0i7Cx88e18G05cwHf2AApR4xcdaV8eEaaFxbWAJ/y3ys+uXqtH
	 /XJBJNSZXph2BLen4/YdTuw3FdDLcoHS19RjifzWhspUglV2RYS5D0K4z6PWYg5gH
	 usM9ah0u73qR8gyzxw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mnpns-1xFliw2mfS-00gCjy; Tue, 04
 Aug 2026 10:25:48 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 04 Aug 2026 10:25:21 +0200
Subject: [PATCH v8 6/6] drm/ttm: Use common ancestor of evictor and evictee
 as limit pool
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260804-dmemcg-aggressive-protect-v8-6-07af96681bf8@gmx.de>
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
X-Provags-ID: V03:K1:0ie3ilM63VMM1tspNK71c10t5SnhImPAPXL0+iefIg5g2w3YM7u
 rBWbeP6kftrZj9hUfaJGxJsoRq1b2AmberYeHVsryzKbMQTRYk+xdPv66z8NkpOfmP8SjCL
 W0nnDMtTiv2zwnKM6RiDlEp80feRL+qfV3EkVGBV+oeRftpSeSIzORzBmNCMcTUTQKVsP8K
 ihNwEHJ01DFs7Y1Ey0QFg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:pvGzk24kqng=;aXUdNlQn1u/LjzFyYgXLVxfQqjP
 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

When checking whether to skip certain buffers because they're protected
by dmem.low, we're checking the effective protection of the evictee's
cgroup, but depending on how the evictor's cgroup relates to the
evictee's, the semantics of effective protection values change.

When testing against cgroups from different subtrees, page_counter's
recursive protection propagates memory protection afforded to a parent
down to the child cgroups, even if the children were not explicitly
protected. This prevents cgroups whose parents were afforded no
protection from stealing memory from cgroups whose parents were afforded
more protection, without users having to explicitly propagate this
protection.

However, if we always calculate protection from the root cgroup, this
breaks prioritization of sibling cgroups: If one cgroup was explicitly
protected and its siblings were not, the protected cgroup should get
higher priority, i.e. the protected cgroup should be able to steal from
unprotected siblings. This only works if we restrict the protection
calculation to the subtree shared by evictor and evictee.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
=2D--
 drivers/gpu/drm/ttm/ttm_bo.c | 43 +++++++++++++++++++++++++++++++++++++++=
+---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 6bbea148838e4..79c96aba4bf49 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -628,11 +628,48 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk=
, struct ttm_buffer_object *
 {
 	struct ttm_bo_evict_walk *evict_walk =3D
 		container_of(walk, typeof(*evict_walk), walk);
+	struct dmem_cgroup_pool_state *limit_pool, *ancestor =3D NULL;
+	bool evict_valuable;
 	s64 lret;
=20
-	if (!dmem_cgroup_state_evict_valuable(evict_walk->alloc_state->limit_poo=
l,
-					      bo->resource->css, evict_walk->try_low,
-					      &evict_walk->hit_low))
+	/*
+	 * If may_try_low is not set, then we're trying to evict unprotected
+	 * buffers in favor of a protected allocation for charge_pool. Explicitl=
y skip
+	 * buffers belonging to the same cgroup here - that cgroup is definitely=
 protected,
+	 * even though dmem_cgroup_state_evict_valuable would allow the eviction=
 because a
+	 * cgroup is always allowed to evict from itself even if it is protected=
.
+	 */
+	if (!evict_walk->alloc_state->may_try_low &&
+			bo->resource->css =3D=3D evict_walk->alloc_state->charge_pool)
+		return 0;
+
+	limit_pool =3D evict_walk->alloc_state->limit_pool;
+	/*
+	 * If there is no explicit limit pool, find the root of the shared subtr=
ee between
+	 * evictor and evictee. This is important so that recursive protection r=
ules can
+	 * apply properly: Recursive protection distributes cgroup protection af=
forded
+	 * to a parent cgroup but not used explicitly by a child cgroup between =
all child
+	 * cgroups (see docs of effective_protection in mm/page_counter.c). Howe=
ver, when
+	 * direct siblings compete for memory, siblings that were explicitly pro=
tected
+	 * should get prioritized over siblings that weren't. This only happens =
correctly
+	 * when the root of the shared subtree is passed to
+	 * dmem_cgroup_state_evict_valuable. Otherwise, the effective-protection
+	 * calculation cannot distinguish direct siblings from unrelated subtree=
s and the
+	 * calculated protection ends up wrong.
+	 */
+	if (!limit_pool) {
+		ancestor =3D dmem_cgroup_get_common_ancestor(bo->resource->css,
+							   evict_walk->alloc_state->charge_pool);
+		limit_pool =3D ancestor;
+	}
+
+	evict_valuable =3D dmem_cgroup_state_evict_valuable(limit_pool, bo->reso=
urce->css,
+							  evict_walk->try_low,
+							  &evict_walk->hit_low);
+	if (ancestor)
+		dmem_cgroup_pool_state_put(ancestor);
+
+	if (!evict_valuable)
 		return 0;
=20
 	if (bo->pin_count || !bo->bdev->funcs->eviction_valuable(bo, evict_walk-=
>place))

=2D-=20
2.55.0


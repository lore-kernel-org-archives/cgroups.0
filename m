Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E40A470105
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663073; cv=none; b=KF6T7vl+gY2nw14RIpk3/lZWES6juJ4VywL5G9BzaYu76Stbvn3INZG3JdpvC3LDLukPECuzKKFQVkFVN4hHftWYhcS7eOgEx/8ipZqETzlsub3eHEO5dV0sks8Eq1VKtgZ8VxGlyjCaQz/JVznjCqxOvSgYzJ05go5zsREff14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663073; c=relaxed/simple;
	bh=mIjk/4GqO6VXouO0SxGT2SCP0G7BLKvMLa6FKOMYNe8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jeiS2tLbPqBD1zdKhEAOrZnWRNIBgbOVCKLsxbcIDC8Ba6FfnkKP2SMCGxg67cXO7rKDkVHwgurY1id732fjevVylDiWfLN7/lhamq6vvBpB/evqLNsTNORwU7nvmVIp02MfJk4xWfosseFca4/4hGEtCOrtzGheAR/BB/uhlmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=YeUFhxG+; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="YeUFhxG+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663049; x=1785267849; i=natalie.vock@gmx.de;
	bh=1p8nKeSscW/1ofacP9W19lyKcMIRAtNN/X2d/TG423c=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=YeUFhxG+0Kw1aoFoFxitksSL9h0KAT0g9QS3xuvlxFxF/X4o4vAEX83oKH7CEnA5
	 6SfUfItxQAGmechmDtPfLT/5kzKax/7tgbADgEOzBZgSpWlnXNLOQw9JXOtv+rkf4
	 h8x+ud8eEfg/ctVPfeeQRMz6MGlCJVFVvuwFdeTnOOU4rPzoEirgvgaBguhXGFzJf
	 WwFyDrmqDPt+eHXzptn/MCTvVwxaGxxXj9T1m80JrGuVtkmskHHuzTr2SF0983TVx
	 HI9qI7XkFLnaJ2C1f/ty1Y9E8oT69/71KsbibYqGv7Mm56FPc9epwfsoEfWuAFQLa
	 JRCoQ4i4pmKY6Aymsg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MGz1f-1wptQg07nv-00HLM1; Tue, 21
 Jul 2026 21:44:09 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 21 Jul 2026 21:43:25 +0200
Subject: [PATCH v7 6/6] drm/ttm: Use common ancestor of evictor and evictee
 as limit pool
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260721-dmemcg-aggressive-protect-v7-6-97c4b1014315@gmx.de>
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
X-Provags-ID: V03:K1:P0jWobo2B3bL0W0fCbQPEphPApjLzn3f6vUSEbtT9T9KB2kExlq
 zbOy7Xe328c9+av3jwlxu2QfRBkJg2+EWHcY6sbff/ttNwH/uDIcCsP/DhPoZaBZqP7SIFF
 WsCdiyWrGmLlhTIgTpZEtZeoxEbayosQzEfhwY2nG5zXHu3KLMSPMdEf/nh9phnz01Qkq9P
 z/N6XAeAQx7sp4VfHa6Tg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6Qkwqt9vJNk=;MKbLBUbaoLsKeW13AFtwF6KHQex
 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
 =

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
index ec0821e306da1..c843189f36088 100644
=2D-- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -627,11 +627,48 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk=
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


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F80B37F323;
	Thu, 23 Jul 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822180; cv=none; b=bAUoQbAazZzvz7b8AIHTlgyztqqq6JVDmAodzG4ri0wkS1su1sq3HJudhDRyzxgp2k1j/qdBphm18G4XZr/VafZIeChozTRgMRu5tXlTCWiJiJA1dCXxAxVl7yS4YNf/u+3dV5D7vZ95d6nxw2jhPWFxdMPOwUTSvaMTqI0/WiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822180; c=relaxed/simple;
	bh=lW14EqKsndqF/M4tzmuiqXiTOOLZKcZkqZ8YukE1lFc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GETCvcffdWJVzAQFGKU2suYd5+tj3Ux2uaZ8mOtMKFxjeFm+WKDXFPwo1i7h0YQpy63Yu1HYUTq+MM0bYVXdI7BU1TwYuO2S0mKR8SrArsUG7yXVPj8HZE7owFoUazRSMsqefMtnPsGpFdr24mJICMK1BtiN+0QDA0xvSFhRUmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EP4TAkOY; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EP4TAkOY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784822178; x=1816358178;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lW14EqKsndqF/M4tzmuiqXiTOOLZKcZkqZ8YukE1lFc=;
  b=EP4TAkOY/CbAH1qiI3jyW3LiInKD1SFnoACQWobNWEL+J85Pa/QfkD5t
   90OenQg9D4n3gITiJhNkaukdiLT6ZS0ps8ABUIYs/yXnULH3D1X3sYxYT
   AoPDQWeBmjkN52qDwE9DEIG7IM98KSpCrFu/inuZ/PmDVv2tgFXLwUBC+
   n4/XfYO2i76l7gNNHgFeXCyHxgxsOn+gTTCKvMCMIR1ynwahSvXS+D9Us
   bxvXhSnKZ/0f56ofSAyVXmPsBpMAnv3rCI6x+LMRUW8TNd6rq0wp+RqfR
   DvScyMAWE6sh/LWcPiuKf438sU7Itnj3HkttCDAHTPX9LyfsLN0xtVNKC
   Q==;
X-CSE-ConnectionGUID: 69W76hASRuOEkbLxopz6kQ==
X-CSE-MsgGUID: RrKgFis2SFWHzF72d2+iRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="96139957"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="96139957"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 08:56:17 -0700
X-CSE-ConnectionGUID: Q61gjamdTPOLgfuVz41gDA==
X-CSE-MsgGUID: 1ImIcoQURHWAMVuCM6kWhA==
X-ExtLoop1: 1
Received: from conormcd-mobl2.ger.corp.intel.com (HELO [10.245.244.122]) ([10.245.244.122])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 08:56:12 -0700
Message-ID: <fee100e5ec20f6692ae9f40f65d42a306a720465.camel@linux.intel.com>
Subject: Re: [PATCH v8 4/6] drm/ttm: Hook up a cgroup-aware reclaim callback
 for the dmem controller
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	intel-xe@lists.freedesktop.org
Cc: Natalie Vock <natalie.vock@gmx.de>, Johannes Weiner
 <hannes@cmpxchg.org>,  Tejun Heo <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, 	cgroups@vger.kernel.org,
 Huang Rui <ray.huang@amd.com>, Matthew Brost	 <matthew.brost@intel.com>,
 Matthew Auld <matthew.auld@intel.com>, Maxime Ripard	 <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Simona Vetter	 <simona@ffwll.ch>,
 David Airlie <airlied@gmail.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, Thadeu Lima de Souza Cascardo
 <cascardo@igalia.com>,  Alex Deucher <alexander.deucher@amd.com>, Rodrigo
 Vivi <rodrigo.vivi@intel.com>, 	dri-devel@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, 	linux-kernel@vger.kernel.org
Date: Thu, 23 Jul 2026 17:55:58 +0200
In-Reply-To: <43e44b78-3a3f-425d-b327-1a7a90bc7f76@linux.intel.com>
References: <20260723100350.16895-1-thomas.hellstrom@linux.intel.com>
	 <20260723100350.16895-5-thomas.hellstrom@linux.intel.com>
	 <43e44b78-3a3f-425d-b327-1a7a90bc7f76@linux.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-07-23 at 14:02 +0200, Maarten Lankhorst wrote:
> Hey,
>=20
> On 7/23/26 12:03, Thomas Hellstr=C3=B6m wrote:
> > Add ttm_bo_evict_cgroup() to evict buffer objects charged to a
> > specific
> > dmem cgroup pool from a resource manager's LRU until a byte target
> > is
> > met.=C2=A0 Add ttm_resource_manager_set_dmem_region() to associate a
> > dmem
> > cgroup region with a resource manager; drivers supply their own
> > dmem_cgroup_ops with ttm_resource_manager_dmem_reclaim as the
> > reclaim
> > function and the manager pointer as reclaim_priv in the
> > dmem_cgroup_init
> > to wire up TTM eviction as the reclaim callback.
> >=20
> > The eviction context is interruptible; signals abort the operation
> > and
> > propagate back through the write() syscall.
> >=20
> > Introduce a new mode for the bo LRU walker so that sleeping locks
> > can be taken. This can be used when the caller doesn't hold any
> > previous dma_resv locks, and where it intends to hold at most
> > one lock at a time.
> >=20
> > Like the rest of the TTM eviction this should sooner than later
> > be converted to full WW transactions.
> >=20
> > v3:
> > - Fix ttm_resource_manager_set_dmem_region() storing an error
> > pointer
> > =C2=A0 in man->cg unconditionally. (Sashiko-bot)
> > - Fix kernel-doc function name format for ttm_bo_evict_cgroup() and
> > =C2=A0 ttm_resource_manager_set_dmem_region().
> >=20
> > v5:
> > - Rebased on the introduction of struct dmem_cgroup_init.
> > - Handle NULL region in ttm_resource_manager_set_dmem_region() to
> > clear
> > =C2=A0 the reclaim callback, preventing use-after-free when the manager
> > is
> > =C2=A0 torn down while the dmem region outlives it. (Sashiko-bot)
> > - Return 0 on any progress (even partial eviction), -ENOSPC only
> > when
> > =C2=A0 nothing was freed; fixes callers that expected 0 on partial
> > success.
> > - Document that the reclaim callback should return 0 if some
> > progress
> > =C2=A0 was made, -ENOSPC if no progress at all, or another error for
> > fatal
> > =C2=A0 failures.
> >=20
> > v8:
> > - Fix ttm_resource_manager_set_dmem_region() using
> > IS_ERR_OR_NULL(),
> > =C2=A0 which skipped the assignment for a NULL region and thus never
> > =C2=A0 cleared man->cg. Use IS_ERR() so that a NULL region detaches the
> > =C2=A0 region as the kernel-doc and the v5 changelog intended. (Sashiko=
-
> > bot)
> >=20
> > Assisted-by: GitHub_Copilot:claude-sonnet-4.6
> > Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > #v7
> > ---
> > =C2=A0drivers/gpu/drm/ttm/ttm_bo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
| 95
> > +++++++++++++++++++++++++++++-
> > =C2=A0drivers/gpu/drm/ttm/ttm_bo_util.c=C2=A0 |=C2=A0 3 +-
> > =C2=A0drivers/gpu/drm/ttm/ttm_resource.c | 52 ++++++++++++++++
> > =C2=A0include/drm/ttm/ttm_bo.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 10 ++++
> > =C2=A0include/drm/ttm/ttm_resource.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 =
+++
> > =C2=A05 files changed, 163 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/ttm/ttm_bo.c
> > b/drivers/gpu/drm/ttm/ttm_bo.c
> > index 3980f376e3ba..b2bbbb69add3 100644
> > --- a/drivers/gpu/drm/ttm/ttm_bo.c
> > +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> > @@ -515,12 +515,20 @@ static s64 ttm_bo_evict_cb(struct
> > ttm_lru_walk *walk, struct ttm_buffer_object *
> > =C2=A0{
> > =C2=A0	struct ttm_bo_evict_walk *evict_walk =3D
> > =C2=A0		container_of(walk, typeof(*evict_walk), walk);
> > +	/* Capture size before eviction in case res is cleared. */
> > +	s64 bo_size =3D bo->base.size;
>=20
> I just noticed this comment, a bo's size should be fixed, even if the
> backing store is gone?

Yeah, correct. Looks like an old leftover. I'll remove.
I'll post a v9 as well, since initialization seems a bit tricky to get
right.

Thanks,
Thomas

>=20
> > =C2=A0	s64 lret;
> > =C2=A0
> > =C2=A0	if (!dmem_cgroup_state_evict_valuable(evict_walk-
> > >limit_pool, bo->resource->css,
> > =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 evict_walk->try_low,
> > &evict_walk->hit_low))
> > =C2=A0		return 0;
> > =C2=A0
> > +	/*
> > +	 * evict_walk->place is NULL in cgroup drain mode.=C2=A0
> > Drivers'
> > +	 * eviction_valuable() callbacks must handle a NULL place,
> > treating it
> > +	 * as "any placement": the TTM base implementation already
> > does so via
> > +	 * ttm_resource_intersects().
> > +	 */
> > =C2=A0	if (bo->pin_count || !bo->bdev->funcs-
> > >eviction_valuable(bo, evict_walk->place))
> > =C2=A0		return 0;
> > =C2=A0
> > @@ -536,11 +544,15 @@ static s64 ttm_bo_evict_cb(struct
> > ttm_lru_walk *walk, struct ttm_buffer_object *
> > =C2=A0		goto out;
> > =C2=A0
> > =C2=A0	evict_walk->evicted++;
> > -	if (evict_walk->res)
> > +	if (evict_walk->res) {
> > =C2=A0		lret =3D ttm_resource_alloc(evict_walk->evictor,
> > evict_walk->place,
> > =C2=A0					=C2=A0 evict_walk->res, NULL);
> > -	if (lret =3D=3D 0)
> > -		return 1;
> > +		if (lret =3D=3D 0)
> > +			return 1;
> > +	} else {
> > +		/* Cgroup drain: return bytes freed for byte-
> > denominated progress. */
> > +		return bo_size;
> > +	}
> > =C2=A0out:
> > =C2=A0	/* Errors that should terminate the walk. */
> > =C2=A0	if (lret =3D=3D -ENOSPC)
> > @@ -614,6 +626,83 @@ static int ttm_bo_evict_alloc(struct
> > ttm_device *bdev,
> > =C2=A0	return 0;
> > =C2=A0}
> > =C2=A0
> > +/**
> > + * ttm_bo_evict_cgroup() - Evict buffer objects charged to a
> > specific cgroup.
> > + * @bdev: The TTM device.
> > + * @man: The resource manager whose LRU to walk.
> > + * @limit_pool: The cgroup pool state whose members should be
> > evicted.
> > + * @target_bytes: Number of bytes to free.
> > + * @ctx: The TTM operation context.
> > + *
> > + * Walk the LRU of @man and evict buffer objects that are charged
> > to the
> > + * cgroup identified by @limit_pool, until at least @target_bytes
> > have been
> > + * freed.=C2=A0 Mirrors the two-pass (trylock -> sleeping-lock, low-
> > watermark)
> > + * strategy used by ttm_bo_evict_alloc().
> > + *
> > + * Return: >=3D @target_bytes on full success, 0..target_bytes-1 if
> > partial,
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 negative error code=
 on fatal error.
> > + */
> > +s64 ttm_bo_evict_cgroup(struct ttm_device *bdev,
> > +			struct ttm_resource_manager *man,
> > +			struct dmem_cgroup_pool_state *limit_pool,
> > +			s64 target_bytes,
> > +			struct ttm_operation_ctx *ctx)
> > +{
> > +	struct ttm_bo_evict_walk evict_walk =3D {
> > +		.walk =3D {
> > +			.ops =3D &ttm_evict_walk_ops,
> > +			.arg =3D { .ctx =3D ctx },
> > +		},
> > +		.limit_pool =3D limit_pool,
> > +		/* place, evictor, res left NULL: selects cgroup
> > drain mode */
> > +	};
> > +	s64 lret, pass;
> > +
> > +	evict_walk.walk.arg.trylock_only =3D true;
> > +	lret =3D ttm_lru_walk_for_evict(&evict_walk.walk, bdev, man,
> > target_bytes);
> > +	if (lret < 0 || lret >=3D target_bytes)
> > +		return lret;
> > +
> > +	/* Second pass: also evict BOs at the low watermark. */
> > +	if (evict_walk.hit_low) {
> > +		evict_walk.try_low =3D true;
> > +		pass =3D ttm_lru_walk_for_evict(&evict_walk.walk,
> > bdev, man,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target_bytes -
> > lret);
> > +		if (pass < 0)
> > +			return pass;
> > +		lret +=3D pass;
> > +		if (lret >=3D target_bytes)
> > +			return lret;
> > +	}
> > +
> > +	/* Full sleeping-lock pass for remaining target. */
> > +	evict_walk.try_low =3D evict_walk.hit_low =3D false;
> > +	evict_walk.walk.arg.trylock_only =3D false;
> > +
> > +retry:
> > +	evict_walk.walk.arg.sleeping_lock =3D true;
> > +	do {
> > +		evict_walk.evicted =3D 0;
> > +		pass =3D ttm_lru_walk_for_evict(&evict_walk.walk,
> > bdev, man,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target_bytes -
> > lret);
> > +		if (pass < 0) {
> > +			lret =3D pass;
> > +			goto out;
> > +		}
> > +		lret +=3D pass;
> > +	} while (lret < target_bytes && evict_walk.evicted);
> > +
> > +	/* One more attempt if we hit the low limit during
> > sleeping-lock pass. */
> > +	if (lret < target_bytes && evict_walk.hit_low &&
> > !evict_walk.try_low) {
> > +		evict_walk.try_low =3D true;
> > +		goto retry;
> > +	}
> > +
> > +out:
> > +	return lret;
> > +}
> > +EXPORT_SYMBOL(ttm_bo_evict_cgroup);
> > +
> > =C2=A0/**
> > =C2=A0 * ttm_bo_pin - Pin the buffer object.
> > =C2=A0 * @bo: The buffer object to pin
> > diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c
> > b/drivers/gpu/drm/ttm/ttm_bo_util.c
> > index 3e3c201a0222..bd0b23ac2cc4 100644
> > --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> > +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> > @@ -999,7 +999,8 @@ __ttm_bo_lru_cursor_next(struct
> > ttm_bo_lru_cursor *curs)
> > =C2=A0		bo =3D res->bo;
> > =C2=A0		if (ttm_lru_walk_trylock(curs, bo))
> > =C2=A0			bo_locked =3D true;
> > -		else if (!arg->ticket || arg->ctx->no_wait_gpu ||
> > arg->trylock_only)
> > +		else if ((!arg->ticket && !arg->sleeping_lock) ||
> > arg->ctx->no_wait_gpu ||
> > +			 arg->trylock_only)
> > =C2=A0			continue;
> > =C2=A0
> > =C2=A0		if (!ttm_bo_get_unless_zero(bo)) {
> > diff --git a/drivers/gpu/drm/ttm/ttm_resource.c
> > b/drivers/gpu/drm/ttm/ttm_resource.c
> > index 154d6739256f..1ff4a470b083 100644
> > --- a/drivers/gpu/drm/ttm/ttm_resource.c
> > +++ b/drivers/gpu/drm/ttm/ttm_resource.c
> > @@ -953,3 +953,55 @@ void
> > ttm_resource_manager_create_debugfs(struct ttm_resource_manager
> > *man,
> > =C2=A0#endif
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL(ttm_resource_manager_create_debugfs);
> > +
> > +/**
> > + * ttm_resource_manager_dmem_reclaim() - dmem cgroup reclaim
> > callback for TTM
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 resource managers.
> > + * @pool: The dmem cgroup pool state for the cgroup being
> > reclaimed.
> > + * @target_bytes: Number of bytes to try to free.
> > + * @priv: The &ttm_resource_manager pointer, passed as
> > @init.reclaim_priv to
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dmem_cgroup_register_regi=
on().
> > + *
> > + * Drivers should use this as the @reclaim member of their own
> > + * &struct dmem_cgroup_ops, with the &ttm_resource_manager pointer
> > as
> > + * @init.reclaim_priv.
> > + *
> > + * Return: 0 if some memory was freed, -ENOSPC if nothing was
> > freed, or
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 another negative er=
ror code on fatal failure.
> > + */
> > +int ttm_resource_manager_dmem_reclaim(struct
> > dmem_cgroup_pool_state *pool,
> > +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 target_bytes, void
> > *priv)
> > +{
> > +	struct ttm_resource_manager *man =3D priv;
> > +	struct ttm_operation_ctx ctx =3D { .interruptible =3D true };
> > +	s64 freed;
> > +
> > +	freed =3D ttm_bo_evict_cgroup(man->bdev, man, pool,
> > target_bytes, &ctx);
> > +	if (freed < 0)
> > +		return freed;
> > +
> > +	return freed > 0 ? 0 : -ENOSPC;
> > +}
> > +EXPORT_SYMBOL(ttm_resource_manager_dmem_reclaim);
> > +
> > +/**
> > + * ttm_resource_manager_set_dmem_region() - Associate a dmem
> > cgroup region with a
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 resource manager.
> > + * @man: The resource manager.
> > + * @region: The dmem cgroup region to associate, may be NULL or
> > IS_ERR().
> > + *
> > + * When @region is valid, stores it in @man->cg so that TTM can
> > look up the
> > + * associated pool during charging and eviction-target selection.=C2=
=A0
> > When
> > + * @region is %NULL, clears @man->cg to detach the region before
> > teardown.
> > + * An IS_ERR() @region is ignored, leaving @man->cg unchanged.
> > + * The reclaim callback must be wired up using
> > ttm_resource_manager_dmem_reclaim()
> > + * in the driver's own &struct dmem_cgroup_ops, with the manager
> > pointer as
> > + * @init.reclaim_priv.
> > + */
> > +void ttm_resource_manager_set_dmem_region(struct
> > ttm_resource_manager *man,
> > +					=C2=A0 struct
> > dmem_cgroup_region *region)
> > +{
> > +	if (!IS_ERR(region))
> > +		man->cg =3D region;
> > +}
> > +EXPORT_SYMBOL(ttm_resource_manager_set_dmem_region);
> > diff --git a/include/drm/ttm/ttm_bo.h b/include/drm/ttm/ttm_bo.h
> > index 8310bc3d55f9..32791c4db2a9 100644
> > --- a/include/drm/ttm/ttm_bo.h
> > +++ b/include/drm/ttm/ttm_bo.h
> > @@ -226,6 +226,11 @@ struct ttm_lru_walk_arg {
> > =C2=A0	struct ww_acquire_ctx *ticket;
> > =C2=A0	/** @trylock_only: Only use trylock for locking. */
> > =C2=A0	bool trylock_only;
> > +	/**
> > +	 * @sleeping_lock: Use sleeping locks even with %NULL
> > @ticket.
> > +	 * @trylock_only has precedence over this field.
> > +	 */
> > +	bool sleeping_lock;
> > =C2=A0};
> > =C2=A0
> > =C2=A0/**
> > @@ -431,6 +436,11 @@ void ttm_bo_unpin(struct ttm_buffer_object
> > *bo);
> > =C2=A0int ttm_bo_evict_first(struct ttm_device *bdev,
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_resource_manage=
r *man,
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *=
ctx);
> > +s64 ttm_bo_evict_cgroup(struct ttm_device *bdev,
> > +			struct ttm_resource_manager *man,
> > +			struct dmem_cgroup_pool_state *limit_pool,
> > +			s64 target_bytes,
> > +			struct ttm_operation_ctx *ctx);
> > =C2=A0int ttm_bo_access(struct ttm_buffer_object *bo, unsigned long
> > offset,
> > =C2=A0		=C2=A0 void *buf, int len, int write);
> > =C2=A0vm_fault_t ttm_bo_vm_reserve(struct ttm_buffer_object *bo,
> > diff --git a/include/drm/ttm/ttm_resource.h
> > b/include/drm/ttm/ttm_resource.h
> > index a5d386583fb6..32e485fdce9a 100644
> > --- a/include/drm/ttm/ttm_resource.h
> > +++ b/include/drm/ttm/ttm_resource.h
> > @@ -39,6 +39,7 @@
> > =C2=A0
> > =C2=A0struct dentry;
> > =C2=A0struct dmem_cgroup_device;
> > +struct dmem_cgroup_region;
> > =C2=A0struct drm_printer;
> > =C2=A0struct ttm_device;
> > =C2=A0struct ttm_resource_manager;
> > @@ -477,6 +478,12 @@ void ttm_resource_manager_init(struct
> > ttm_resource_manager *man,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_device *bdev,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint64_t size);
> > =C2=A0
> > +void ttm_resource_manager_set_dmem_region(struct
> > ttm_resource_manager *man,
> > +					=C2=A0 struct
> > dmem_cgroup_region *region);
> > +
> > +int ttm_resource_manager_dmem_reclaim(struct
> > dmem_cgroup_pool_state *pool,
> > +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 target_bytes, void
> > *priv);
> > +
> > =C2=A0int ttm_resource_manager_evict_all(struct ttm_device *bdev,
> > =C2=A0				=C2=A0=C2=A0 struct ttm_resource_manager
> > *man);
> > =C2=A0

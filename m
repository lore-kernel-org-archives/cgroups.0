Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD918366049
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784732943; cv=none; b=O64x+OSjt30luQrygS+FFPUqdtCXOGwImCw5dY+ip72LkPzvxXup+Z4j+nAexeFsPTkAjoPFaSCcugzYp/XN4l+BYTtOBzsUHKcv/dHe0UBXM48Y0/jVTXj6GjDcRyJ3WeN8wTMwR0nT5qBHAtadxwLx9EsIm5uor7ooUcQdJxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784732943; c=relaxed/simple;
	bh=Fuh7j3i1hWPA2ST5wcZWSI4lxKim5UhpPM3nkNKc/fU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tyswskF9DbSngSPxoLHhn1SZf6w7IkkyHpBRo+l62B22H7VZONb1FiD1JKausQhSdaeYanpCTPAA51DaC6CxM6I63zbl3gn/t6v2JmLpF6Oa3agY7RQ1vUpoEOECC7vzMbN9KLzVIsJA4+hIrciPY7USdsGj/yxVgQvKCqhR3oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/la5T4J; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/la5T4J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784732940; x=1816268940;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Fuh7j3i1hWPA2ST5wcZWSI4lxKim5UhpPM3nkNKc/fU=;
  b=V/la5T4Jd1eI7sBfp4E35d86TMlaUGarjcuQytXMDCavXx5kd6DoCC5b
   YSmnInGx1tv1WycXhLJAzcI0la2bzKHYh4hD/FkWh+0Quexj9h4Zzv8gE
   UUKOoZ42siW583CzGKte2d0sbhWMed2vvU27zjh9LeayVKFwl3PafPNQ1
   EUwofmrzxZmIGyxrUBOz+M/NNmFjJ1sPDggXsRLpeZwKif65lt9nIboV/
   448+Ovjvn/MpJagmWBPQIj+e1DAsxNLavKzAKdNnm/qzUMGYXuvfh592g
   m39mmpUhVDaGLvAB/s30NGbbFiNtiiiWgt5kFrGB5giXjZLUMoLwBtmPR
   A==;
X-CSE-ConnectionGUID: yAkWSs06SlqOiw0rSumC4A==
X-CSE-MsgGUID: tEO0jsp1R/GKaFhdSufQmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="110913416"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="110913416"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:08:58 -0700
X-CSE-ConnectionGUID: iU29KpU5TxCt+NLgMRzEkQ==
X-CSE-MsgGUID: 0QD0nRCiQpSPTbNLxMR0qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="258181065"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.180]) ([10.245.245.180])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:08:55 -0700
Message-ID: <1c4e53bef3e6cdce4edf97352d9f5e04ce0c69a6.camel@linux.intel.com>
Subject: Re: [PATCH 02/10] ttm: add a memcg accounting flag to the
 alloc/populate APIs
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, 
	tj@kernel.org, christian.koenig@amd.com, Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt	 <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>,
 simona@ffwll.ch, 	intel-xe@lists.freedesktop.org
Date: Wed, 22 Jul 2026 17:08:52 +0200
In-Reply-To: <20260706052330.1110909-3-airlied@gmail.com>
References: <20260706052330.1110909-1-airlied@gmail.com>
	 <20260706052330.1110909-3-airlied@gmail.com>
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

On Mon, 2026-07-06 at 15:22 +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
>=20
> This flag does nothing yet, but this just changes the APIs to accept
> it in the future across all users.
>=20
> This flag will eventually be filled out with when to account a tt
> populate to a memcg.

I agree with Matt Brost's comment about the ttm_operation_ctx.

There are also some sashiko comments that appear valid:
https://sashiko.dev/#/message/20260706053512.D207E1F000E9%40smtp.kernel.org

Thanks,
Thomas


>=20
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
> =C2=A0drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0drivers/gpu/drm/i915/gem/i915_gem_ttm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++--
> =C2=A0drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 2 +-
> =C2=A0drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 ++--
> =C2=A0drivers/gpu/drm/loongson/lsdc_ttm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0drivers/gpu/drm/nouveau/nouveau_bo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ++++--
> =C2=A0drivers/gpu/drm/radeon/radeon_ttm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c |=C2=A0 2 +-
> =C2=A0drivers/gpu/drm/ttm/tests/ttm_pool_test.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 16 ++++++++------
> --
> =C2=A0drivers/gpu/drm/ttm/tests/ttm_tt_test.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 12 ++++++------
> =C2=A0drivers/gpu/drm/ttm/ttm_bo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 7 ++++---
> =C2=A0drivers/gpu/drm/ttm/ttm_bo_util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +++---
> =C2=A0drivers/gpu/drm/ttm/ttm_bo_vm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
4 +++-
> =C2=A0drivers/gpu/drm/ttm/ttm_pool.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 6 ++++--
> =C2=A0drivers/gpu/drm/ttm/ttm_tt.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 8 +++++---
> =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_blit.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++--
> =C2=A0drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 7 ++++---
> =C2=A0drivers/gpu/drm/xe/xe_bo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++--
> =C2=A0include/drm/ttm/ttm_bo.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0include/drm/ttm/ttm_device.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 1 +
> =C2=A0include/drm/ttm/ttm_pool.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0include/drm/ttm/ttm_tt.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A022 files changed, 63 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> index 025625e7e800..8062b3d61157 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -1220,6 +1220,7 @@ static struct ttm_tt
> *amdgpu_ttm_tt_create(struct ttm_buffer_object *bo,
> =C2=A0 */
> =C2=A0static int amdgpu_ttm_tt_populate(struct ttm_device *bdev,
> =C2=A0				=C2=A0 struct ttm_tt *ttm,
> +				=C2=A0 bool memcg_account,
> =C2=A0				=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct amdgpu_device *adev =3D amdgpu_ttm_adev(bdev);
> @@ -1243,7 +1244,7 @@ static int amdgpu_ttm_tt_populate(struct
> ttm_device *bdev,
> =C2=A0		pool =3D &adev->mman.ttm_pools[gtt->pool_id];
> =C2=A0	else
> =C2=A0		pool =3D &adev->mman.bdev.pool;
> -	ret =3D ttm_pool_alloc(pool, ttm, ctx);
> +	ret =3D ttm_pool_alloc(pool, ttm, memcg_account, ctx);
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> index df3fcc2b1248..d45ccede78a4 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
> @@ -317,6 +317,7 @@ static struct ttm_tt *i915_ttm_tt_create(struct
> ttm_buffer_object *bo,
> =C2=A0
> =C2=A0static int i915_ttm_tt_populate(struct ttm_device *bdev,
> =C2=A0				struct ttm_tt *ttm,
> +				bool memcg_account,
> =C2=A0				struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct i915_ttm_tt *i915_tt =3D container_of(ttm,
> typeof(*i915_tt), ttm);
> @@ -324,7 +325,7 @@ static int i915_ttm_tt_populate(struct ttm_device
> *bdev,
> =C2=A0	if (i915_tt->is_shmem)
> =C2=A0		return i915_ttm_tt_shmem_populate(bdev, ttm, ctx);
> =C2=A0
> -	return ttm_pool_alloc(&bdev->pool, ttm, ctx);
> +	return ttm_pool_alloc(&bdev->pool, ttm, memcg_account, ctx);
> =C2=A0}
> =C2=A0
> =C2=A0static void i915_ttm_tt_unpopulate(struct ttm_device *bdev, struct
> ttm_tt *ttm)
> @@ -815,7 +816,7 @@ static int __i915_ttm_get_pages(struct
> drm_i915_gem_object *obj,
> =C2=A0	}
> =C2=A0
> =C2=A0	if (bo->ttm && !ttm_tt_is_populated(bo->ttm)) {
> -		ret =3D ttm_bo_populate(bo, &ctx);
> +		ret =3D ttm_bo_populate(bo, false, &ctx);
> =C2=A0		if (ret)
> =C2=A0			return ret;
> =C2=A0
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
> b/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
> index 56489cc127d6..b81c9df2d7eb 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
> @@ -624,7 +624,7 @@ int i915_ttm_move(struct ttm_buffer_object *bo,
> bool evict,
> =C2=A0
> =C2=A0	/* Populate ttm with pages if needed. Typically system
> memory. */
> =C2=A0	if (ttm && (dst_man->use_tt || (ttm->page_flags &
> TTM_TT_FLAG_SWAPPED))) {
> -		ret =3D ttm_bo_populate(bo, ctx);
> +		ret =3D ttm_bo_populate(bo, false, ctx);
> =C2=A0		if (ret)
> =C2=A0			return ret;
> =C2=A0	}
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
> b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
> index 4824f948daed..d951e58f78ea 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
> @@ -91,7 +91,7 @@ static int i915_ttm_backup(struct
> i915_gem_apply_to_region *apply,
> =C2=A0		goto out_no_lock;
> =C2=A0
> =C2=A0	backup_bo =3D i915_gem_to_ttm(backup);
> -	err =3D ttm_bo_populate(backup_bo, &ctx);
> +	err =3D ttm_bo_populate(backup_bo, false, &ctx);
> =C2=A0	if (err)
> =C2=A0		goto out_no_populate;
> =C2=A0
> @@ -190,7 +190,7 @@ static int i915_ttm_restore(struct
> i915_gem_apply_to_region *apply,
> =C2=A0	if (!backup_bo->resource)
> =C2=A0		err =3D ttm_bo_validate(backup_bo,
> i915_ttm_sys_placement(), &ctx);
> =C2=A0	if (!err)
> -		err =3D ttm_bo_populate(backup_bo, &ctx);
> +		err =3D ttm_bo_populate(backup_bo, false, &ctx);
> =C2=A0	if (!err) {
> =C2=A0		err =3D i915_gem_obj_copy_ttm(obj, backup, pm_apply-
> >allow_gpu,
> =C2=A0					=C2=A0=C2=A0=C2=A0 false);
> diff --git a/drivers/gpu/drm/loongson/lsdc_ttm.c
> b/drivers/gpu/drm/loongson/lsdc_ttm.c
> index d7441d96a0dc..bfb5f1b1ec91 100644
> --- a/drivers/gpu/drm/loongson/lsdc_ttm.c
> +++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
> @@ -111,6 +111,7 @@ lsdc_ttm_tt_create(struct ttm_buffer_object *tbo,
> uint32_t page_flags)
> =C2=A0
> =C2=A0static int lsdc_ttm_tt_populate(struct ttm_device *bdev,
> =C2=A0				struct ttm_tt *ttm,
> +				bool memcg_account,
> =C2=A0				struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	bool slave =3D !!(ttm->page_flags & TTM_TT_FLAG_EXTERNAL);
> @@ -123,7 +124,7 @@ static int lsdc_ttm_tt_populate(struct ttm_device
> *bdev,
> =C2=A0		return 0;
> =C2=A0	}
> =C2=A0
> -	return ttm_pool_alloc(&bdev->pool, ttm, ctx);
> +	return ttm_pool_alloc(&bdev->pool, ttm, memcg_account, ctx);
> =C2=A0}
> =C2=A0
> =C2=A0static void lsdc_ttm_tt_unpopulate(struct ttm_device *bdev,
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c
> b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 0e8de6d4b36f..a38c19f1d6dc 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -1417,7 +1417,9 @@ vm_fault_t
> nouveau_ttm_fault_reserve_notify(struct ttm_buffer_object *bo)
> =C2=A0
> =C2=A0static int
> =C2=A0nouveau_ttm_tt_populate(struct ttm_device *bdev,
> -			struct ttm_tt *ttm, struct ttm_operation_ctx
> *ctx)
> +			struct ttm_tt *ttm,
> +			bool memcg_account,
> +			struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct ttm_tt *ttm_dma =3D (void *)ttm;
> =C2=A0	struct nouveau_drm *drm;
> @@ -1434,7 +1436,7 @@ nouveau_ttm_tt_populate(struct ttm_device
> *bdev,
> =C2=A0
> =C2=A0	drm =3D nouveau_bdev(bdev);
> =C2=A0
> -	return ttm_pool_alloc(&drm->ttm.bdev.pool, ttm, ctx);
> +	return ttm_pool_alloc(&drm->ttm.bdev.pool, ttm,
> memcg_account, ctx);
> =C2=A0}
> =C2=A0
> =C2=A0static void
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c
> b/drivers/gpu/drm/radeon/radeon_ttm.c
> index e7ab8162ac69..98b09463abc2 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -526,6 +526,7 @@ static struct radeon_ttm_tt
> *radeon_ttm_tt_to_gtt(struct radeon_device *rdev,
> =C2=A0
> =C2=A0static int radeon_ttm_tt_populate(struct ttm_device *bdev,
> =C2=A0				=C2=A0 struct ttm_tt *ttm,
> +				=C2=A0 bool memcg_account,
> =C2=A0				=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct radeon_device *rdev =3D radeon_get_rdev(bdev);
> @@ -547,7 +548,7 @@ static int radeon_ttm_tt_populate(struct
> ttm_device *bdev,
> =C2=A0		return 0;
> =C2=A0	}
> =C2=A0
> -	return ttm_pool_alloc(&rdev->mman.bdev.pool, ttm, ctx);
> +	return ttm_pool_alloc(&rdev->mman.bdev.pool, ttm,
> memcg_account, ctx);
> =C2=A0}
> =C2=A0
> =C2=A0static void radeon_ttm_tt_unpopulate(struct ttm_device *bdev, struc=
t
> ttm_tt *ttm)
> diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
> b/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
> index 2db221f6fc3a..0cbf732eebf3 100644
> --- a/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
> +++ b/drivers/gpu/drm/ttm/tests/ttm_bo_validate_test.c
> @@ -538,7 +538,7 @@ static void
> ttm_bo_validate_no_placement_signaled(struct kunit *test)
> =C2=A0
> =C2=A0	if (params->with_ttm) {
> =C2=A0		old_tt =3D priv->ttm_dev->funcs->ttm_tt_create(bo, 0);
> -		ttm_pool_alloc(&priv->ttm_dev->pool, old_tt, &ctx);
> +		ttm_pool_alloc(&priv->ttm_dev->pool, old_tt, false,
> &ctx);
> =C2=A0		bo->ttm =3D old_tt;
> =C2=A0	}
> =C2=A0
> diff --git a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> index be75c8abf388..af235d64b970 100644
> --- a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> +++ b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> @@ -89,7 +89,7 @@ static struct ttm_pool
> *ttm_pool_pre_populated(struct kunit *test,
> =C2=A0
> =C2=A0	ttm_pool_init(pool, devs->dev, NUMA_NO_NODE,
> TTM_ALLOCATION_POOL_USE_DMA_ALLOC);
> =C2=A0
> -	err =3D ttm_pool_alloc(pool, tt, &simple_ctx);
> +	err =3D ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> =C2=A0	ttm_pool_free(pool, tt);
> @@ -157,7 +157,7 @@ static void ttm_pool_alloc_basic(struct kunit
> *test)
> =C2=A0	KUNIT_ASSERT_EQ(test, pool->nid, NUMA_NO_NODE);
> =C2=A0	KUNIT_ASSERT_EQ(test, pool->alloc_flags, params-
> >alloc_flags);
> =C2=A0
> -	err =3D ttm_pool_alloc(pool, tt, &simple_ctx);
> +	err =3D ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0	KUNIT_ASSERT_EQ(test, tt->num_pages, expected_num_pages);
> =C2=A0
> @@ -220,7 +220,7 @@ static void ttm_pool_alloc_basic_dma_addr(struct
> kunit *test)
> =C2=A0
> =C2=A0	ttm_pool_init(pool, devs->dev, NUMA_NO_NODE,
> TTM_ALLOCATION_POOL_USE_DMA_ALLOC);
> =C2=A0
> -	err =3D ttm_pool_alloc(pool, tt, &simple_ctx);
> +	err =3D ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0	KUNIT_ASSERT_EQ(test, tt->num_pages, expected_num_pages);
> =C2=A0
> @@ -253,7 +253,7 @@ static void
> ttm_pool_alloc_order_caching_match(struct kunit *test)
> =C2=A0	tt =3D ttm_tt_kunit_init(test, 0, caching, size);
> =C2=A0	KUNIT_ASSERT_NOT_NULL(test, tt);
> =C2=A0
> -	err =3D ttm_pool_alloc(pool, tt, &simple_ctx);
> +	err =3D ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> =C2=A0	KUNIT_ASSERT_TRUE(test, !list_lru_count(&pt->pages));
> @@ -285,7 +285,7 @@ static void
> ttm_pool_alloc_caching_mismatch(struct kunit *test)
> =C2=A0	KUNIT_ASSERT_FALSE(test, !list_lru_count(&pt_pool->pages));
> =C2=A0	KUNIT_ASSERT_TRUE(test, !list_lru_count(&pt_tt->pages));
> =C2=A0
> -	err =3D ttm_pool_alloc(pool, tt, &simple_ctx);
> +	err =3D ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> =C2=A0	ttm_pool_free(pool, tt);
> @@ -319,7 +319,7 @@ static void ttm_pool_alloc_order_mismatch(struct
> kunit *test)
> =C2=A0	KUNIT_ASSERT_FALSE(test, !list_lru_count(&pt_pool->pages));
> =C2=A0	KUNIT_ASSERT_TRUE(test, !list_lru_count(&pt_tt->pages));
> =C2=A0
> -	err =3D ttm_pool_alloc(pool, tt, &simple_ctx);
> +	err =3D ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> =C2=A0	ttm_pool_free(pool, tt);
> @@ -349,7 +349,7 @@ static void ttm_pool_free_dma_alloc(struct kunit
> *test)
> =C2=A0	KUNIT_ASSERT_NOT_NULL(test, pool);
> =C2=A0
> =C2=A0	ttm_pool_init(pool, devs->dev, NUMA_NO_NODE,
> TTM_ALLOCATION_POOL_USE_DMA_ALLOC);
> -	ttm_pool_alloc(pool, tt, &simple_ctx);
> +	ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0
> =C2=A0	pt =3D &pool->caching[caching].orders[order];
> =C2=A0	KUNIT_ASSERT_TRUE(test, !list_lru_count(&pt->pages));
> @@ -379,7 +379,7 @@ static void ttm_pool_free_no_dma_alloc(struct
> kunit *test)
> =C2=A0	KUNIT_ASSERT_NOT_NULL(test, pool);
> =C2=A0
> =C2=A0	ttm_pool_init(pool, devs->dev, NUMA_NO_NODE, 0);
> -	ttm_pool_alloc(pool, tt, &simple_ctx);
> +	ttm_pool_alloc(pool, tt, false, &simple_ctx);
> =C2=A0
> =C2=A0	ttm_pool_free(pool, tt);
> =C2=A0	ttm_tt_fini(tt);
> diff --git a/drivers/gpu/drm/ttm/tests/ttm_tt_test.c
> b/drivers/gpu/drm/ttm/tests/ttm_tt_test.c
> index bd5f7d0b9b62..dfa38bbfd829 100644
> --- a/drivers/gpu/drm/ttm/tests/ttm_tt_test.c
> +++ b/drivers/gpu/drm/ttm/tests/ttm_tt_test.c
> @@ -262,7 +262,7 @@ static void ttm_tt_populate_null_ttm(struct kunit
> *test)
> =C2=A0	struct ttm_operation_ctx ctx =3D { };
> =C2=A0	int err;
> =C2=A0
> -	err =3D ttm_tt_populate(devs->ttm_dev, NULL, &ctx);
> +	err =3D ttm_tt_populate(devs->ttm_dev, NULL, false, &ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, -EINVAL);
> =C2=A0}
> =C2=A0
> @@ -283,11 +283,11 @@ static void
> ttm_tt_populate_populated_ttm(struct kunit *test)
> =C2=A0	err =3D ttm_tt_init(tt, bo, 0, ttm_cached, 0);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> -	err =3D ttm_tt_populate(devs->ttm_dev, tt, &ctx);
> +	err =3D ttm_tt_populate(devs->ttm_dev, tt, false, &ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0	populated_page =3D *tt->pages;
> =C2=A0
> -	err =3D ttm_tt_populate(devs->ttm_dev, tt, &ctx);
> +	err =3D ttm_tt_populate(devs->ttm_dev, tt, false, &ctx);
> =C2=A0	KUNIT_ASSERT_PTR_EQ(test, populated_page, *tt->pages);
> =C2=A0}
> =C2=A0
> @@ -307,7 +307,7 @@ static void ttm_tt_unpopulate_basic(struct kunit
> *test)
> =C2=A0	err =3D ttm_tt_init(tt, bo, 0, ttm_cached, 0);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> -	err =3D ttm_tt_populate(devs->ttm_dev, tt, &ctx);
> +	err =3D ttm_tt_populate(devs->ttm_dev, tt, false, &ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0	KUNIT_ASSERT_TRUE(test, ttm_tt_is_populated(tt));
> =C2=A0
> @@ -351,7 +351,7 @@ static void ttm_tt_swapin_basic(struct kunit
> *test)
> =C2=A0	err =3D ttm_tt_init(tt, bo, 0, ttm_cached, 0);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> -	err =3D ttm_tt_populate(devs->ttm_dev, tt, &ctx);
> +	err =3D ttm_tt_populate(devs->ttm_dev, tt, false, &ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0	KUNIT_ASSERT_TRUE(test, ttm_tt_is_populated(tt));
> =C2=A0
> @@ -361,7 +361,7 @@ static void ttm_tt_swapin_basic(struct kunit
> *test)
> =C2=A0	KUNIT_ASSERT_TRUE(test, tt->page_flags &
> TTM_TT_FLAG_SWAPPED);
> =C2=A0
> =C2=A0	/* Swapout depopulates TT, allocate pages and then swap them
> in */
> -	err =3D ttm_pool_alloc(&devs->ttm_dev->pool, tt, &ctx);
> +	err =3D ttm_pool_alloc(&devs->ttm_dev->pool, tt, false, &ctx);
> =C2=A0	KUNIT_ASSERT_EQ(test, err, 0);
> =C2=A0
> =C2=A0	err =3D ttm_tt_swapin(tt);
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c
> b/drivers/gpu/drm/ttm/ttm_bo.c
> index bcd76f6bb7f0..cf4ab2b5521a 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -145,7 +145,7 @@ static int ttm_bo_handle_move_mem(struct
> ttm_buffer_object *bo,
> =C2=A0			goto out_err;
> =C2=A0
> =C2=A0		if (mem->mem_type !=3D TTM_PL_SYSTEM) {
> -			ret =3D ttm_bo_populate(bo, ctx);
> +			ret =3D ttm_bo_populate(bo, false, ctx);
> =C2=A0			if (ret)
> =C2=A0				goto out_err;
> =C2=A0		}
> @@ -1255,6 +1255,7 @@ void ttm_bo_tt_destroy(struct ttm_buffer_object
> *bo)
> =C2=A0 * is set to true.
> =C2=A0 */
> =C2=A0int ttm_bo_populate(struct ttm_buffer_object *bo,
> +		=C2=A0=C2=A0=C2=A0 bool memcg_account,
> =C2=A0		=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct ttm_device *bdev =3D bo->bdev;
> @@ -1268,7 +1269,7 @@ int ttm_bo_populate(struct ttm_buffer_object
> *bo,
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	swapped =3D ttm_tt_is_swapped(tt);
> -	ret =3D ttm_tt_populate(bdev, tt, ctx);
> +	ret =3D ttm_tt_populate(bdev, tt, memcg_account, ctx);
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> @@ -1293,7 +1294,7 @@ int ttm_bo_setup_export(struct
> ttm_buffer_object *bo,
> =C2=A0	if (ret !=3D 0)
> =C2=A0		return ret;
> =C2=A0
> -	ret =3D ttm_bo_populate(bo, ctx);
> +	ret =3D ttm_bo_populate(bo, false, ctx);
> =C2=A0	ttm_bo_unreserve(bo);
> =C2=A0	return ret;
> =C2=A0}
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c
> b/drivers/gpu/drm/ttm/ttm_bo_util.c
> index 3e3c201a0222..62dad6c05dff 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> @@ -167,7 +167,7 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object
> *bo,
> =C2=A0	src_man =3D ttm_manager_type(bdev, src_mem->mem_type);
> =C2=A0	if (ttm && ((ttm->page_flags & TTM_TT_FLAG_SWAPPED) ||
> =C2=A0		=C2=A0=C2=A0=C2=A0 dst_man->use_tt)) {
> -		ret =3D ttm_bo_populate(bo, ctx);
> +		ret =3D ttm_bo_populate(bo, false, ctx);
> =C2=A0		if (ret)
> =C2=A0			return ret;
> =C2=A0	}
> @@ -352,7 +352,7 @@ static int ttm_bo_kmap_ttm(struct
> ttm_buffer_object *bo,
> =C2=A0
> =C2=A0	BUG_ON(!ttm);
> =C2=A0
> -	ret =3D ttm_bo_populate(bo, &ctx);
> +	ret =3D ttm_bo_populate(bo, false, &ctx);
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> @@ -533,7 +533,7 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo,
> struct iosys_map *map)
> =C2=A0		pgprot_t prot;
> =C2=A0		void *vaddr;
> =C2=A0
> -		ret =3D ttm_bo_populate(bo, &ctx);
> +		ret =3D ttm_bo_populate(bo, false, &ctx);
> =C2=A0		if (ret)
> =C2=A0			return ret;
> =C2=A0
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> index a80510489c45..2e59836b6085 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> @@ -224,7 +224,9 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct
> vm_fault *vmf,
> =C2=A0		};
> =C2=A0
> =C2=A0		ttm =3D bo->ttm;
> -		err =3D ttm_bo_populate(bo, &ctx);
> +		err =3D ttm_bo_populate(bo,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 false,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &ctx);
> =C2=A0		if (err) {
> =C2=A0			if (err =3D=3D -EINTR || err =3D=3D -ERESTARTSYS ||
> =C2=A0			=C2=A0=C2=A0=C2=A0 err =3D=3D -EAGAIN)
> diff --git a/drivers/gpu/drm/ttm/ttm_pool.c
> b/drivers/gpu/drm/ttm/ttm_pool.c
> index 278bbe7a11ad..e4dbf4c93091 100644
> --- a/drivers/gpu/drm/ttm/ttm_pool.c
> +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> @@ -761,6 +761,7 @@ static unsigned int
> ttm_pool_alloc_find_order(unsigned int highest,
> =C2=A0}
> =C2=A0
> =C2=A0static int __ttm_pool_alloc(struct ttm_pool *pool, struct ttm_tt
> *tt,
> +			=C2=A0=C2=A0=C2=A0 bool memcg_account,
> =C2=A0			=C2=A0=C2=A0=C2=A0 const struct ttm_operation_ctx *ctx,
> =C2=A0			=C2=A0=C2=A0=C2=A0 struct ttm_pool_alloc_state *alloc,
> =C2=A0			=C2=A0=C2=A0=C2=A0 struct ttm_pool_tt_restore *restore)
> @@ -871,6 +872,7 @@ static int __ttm_pool_alloc(struct ttm_pool
> *pool, struct ttm_tt *tt,
> =C2=A0 * Returns: 0 on successe, negative error code otherwise.
> =C2=A0 */
> =C2=A0int ttm_pool_alloc(struct ttm_pool *pool, struct ttm_tt *tt,
> +		=C2=A0=C2=A0 bool memcg_account,

Regardless whether memcg_account is passed as a separate parameter or
part of @ctx, needs kerneldoc update.


Thanks,
Thomas



> =C2=A0		=C2=A0=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct ttm_pool_alloc_state alloc;
> @@ -880,7 +882,7 @@ int ttm_pool_alloc(struct ttm_pool *pool, struct
> ttm_tt *tt,
> =C2=A0
> =C2=A0	ttm_pool_alloc_state_init(tt, &alloc);
> =C2=A0
> -	return __ttm_pool_alloc(pool, tt, ctx, &alloc, NULL);
> +	return __ttm_pool_alloc(pool, tt, memcg_account, ctx,
> &alloc, NULL);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(ttm_pool_alloc);
> =C2=A0
> @@ -935,7 +937,7 @@ int ttm_pool_restore_and_alloc(struct ttm_pool
> *pool, struct ttm_tt *tt,
> =C2=A0			return 0;
> =C2=A0	}
> =C2=A0
> -	return __ttm_pool_alloc(pool, tt, ctx, &alloc, restore);
> +	return __ttm_pool_alloc(pool, tt, false, ctx, &alloc,
> restore);
> =C2=A0}
> =C2=A0
> =C2=A0/**
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c
> b/drivers/gpu/drm/ttm/ttm_tt.c
> index b645a1818184..aa0f17fca770 100644
> --- a/drivers/gpu/drm/ttm/ttm_tt.c
> +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> @@ -368,7 +368,9 @@ int ttm_tt_swapout(struct ttm_device *bdev,
> struct ttm_tt *ttm,
> =C2=A0EXPORT_SYMBOL_FOR_TESTS_ONLY(ttm_tt_swapout);
> =C2=A0
> =C2=A0int ttm_tt_populate(struct ttm_device *bdev,
> -		=C2=A0=C2=A0=C2=A0 struct ttm_tt *ttm, struct ttm_operation_ctx
> *ctx)
> +		=C2=A0=C2=A0=C2=A0 struct ttm_tt *ttm,
> +		=C2=A0=C2=A0=C2=A0 bool memcg_account,
> +		=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	int ret;
> =C2=A0
> @@ -397,9 +399,9 @@ int ttm_tt_populate(struct ttm_device *bdev,
> =C2=A0	}
> =C2=A0
> =C2=A0	if (bdev->funcs->ttm_tt_populate)
> -		ret =3D bdev->funcs->ttm_tt_populate(bdev, ttm, ctx);
> +		ret =3D bdev->funcs->ttm_tt_populate(bdev, ttm,
> memcg_account, ctx);
> =C2=A0	else
> -		ret =3D ttm_pool_alloc(&bdev->pool, ttm, ctx);
> +		ret =3D ttm_pool_alloc(&bdev->pool, ttm,
> memcg_account, ctx);
> =C2=A0	if (ret)
> =C2=A0		goto error;
> =C2=A0
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
> b/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
> index 135b75a3e013..baa1c3fdb12c 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
> @@ -569,13 +569,13 @@ int vmw_bo_cpu_blit(struct vmw_bo *vmw_dst,
> =C2=A0		dma_resv_assert_held(src->base.resv);
> =C2=A0
> =C2=A0	if (!ttm_tt_is_populated(dst->ttm)) {
> -		ret =3D dst->bdev->funcs->ttm_tt_populate(dst->bdev,
> dst->ttm, &ctx);
> +		ret =3D dst->bdev->funcs->ttm_tt_populate(dst->bdev,
> dst->ttm, false, &ctx);
> =C2=A0		if (ret)
> =C2=A0			return ret;
> =C2=A0	}
> =C2=A0
> =C2=A0	if (!ttm_tt_is_populated(src->ttm)) {
> -		ret =3D src->bdev->funcs->ttm_tt_populate(src->bdev,
> src->ttm, &ctx);
> +		ret =3D src->bdev->funcs->ttm_tt_populate(src->bdev,
> src->ttm, false, &ctx);
> =C2=A0		if (ret)
> =C2=A0			return ret;
> =C2=A0	}
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
> b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
> index dfd08ee19041..368701756119 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
> @@ -360,7 +360,8 @@ static void vmw_ttm_destroy(struct ttm_device
> *bdev, struct ttm_tt *ttm)
> =C2=A0
> =C2=A0
> =C2=A0static int vmw_ttm_populate(struct ttm_device *bdev,
> -			=C2=A0=C2=A0=C2=A0 struct ttm_tt *ttm, struct
> ttm_operation_ctx *ctx)
> +			=C2=A0=C2=A0=C2=A0 struct ttm_tt *ttm, bool memcg_account,
> +			=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	bool external =3D (ttm->page_flags & TTM_TT_FLAG_EXTERNAL) !=3D
> 0;
> =C2=A0
> @@ -372,7 +373,7 @@ static int vmw_ttm_populate(struct ttm_device
> *bdev,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ttm-
> >dma_address,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ttm-
> >num_pages);
> =C2=A0
> -	return ttm_pool_alloc(&bdev->pool, ttm, ctx);
> +	return ttm_pool_alloc(&bdev->pool, ttm, memcg_account, ctx);
> =C2=A0}
> =C2=A0
> =C2=A0static void vmw_ttm_unpopulate(struct ttm_device *bdev,
> @@ -580,7 +581,7 @@ int vmw_bo_create_and_populate(struct vmw_private
> *dev_priv,
> =C2=A0	if (unlikely(ret !=3D 0))
> =C2=A0		return ret;
> =C2=A0
> -	ret =3D vmw_ttm_populate(vbo->tbo.bdev, vbo->tbo.ttm, &ctx);
> +	ret =3D vmw_ttm_populate(vbo->tbo.bdev, vbo->tbo.ttm, false,
> &ctx);
> =C2=A0	if (likely(ret =3D=3D 0)) {
> =C2=A0		struct vmw_ttm_tt *vmw_tt =3D
> =C2=A0			container_of(vbo->tbo.ttm, struct
> vmw_ttm_tt, dma_ttm);
> diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
> index 4c80bac67622..20a10a174d1d 100644
> --- a/drivers/gpu/drm/xe/xe_bo.c
> +++ b/drivers/gpu/drm/xe/xe_bo.c
> @@ -536,6 +536,7 @@ static struct ttm_tt *xe_ttm_tt_create(struct
> ttm_buffer_object *ttm_bo,
> =C2=A0}
> =C2=A0
> =C2=A0static int xe_ttm_tt_populate(struct ttm_device *ttm_dev, struct
> ttm_tt *tt,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool memcg_account,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *ctx)
> =C2=A0{
> =C2=A0	struct xe_ttm_tt *xe_tt =3D container_of(tt, struct xe_ttm_tt,
> ttm);
> @@ -553,7 +554,7 @@ static int xe_ttm_tt_populate(struct ttm_device
> *ttm_dev, struct ttm_tt *tt,
> =C2=A0		err =3D ttm_tt_restore(ttm_dev, tt, ctx);
> =C2=A0	} else {
> =C2=A0		ttm_tt_clear_backed_up(tt);
> -		err =3D ttm_pool_alloc(&ttm_dev->pool, tt, ctx);
> +		err =3D ttm_pool_alloc(&ttm_dev->pool, tt,
> memcg_account, ctx);
> =C2=A0	}
> =C2=A0	if (err)
> =C2=A0		return err;
> @@ -1926,7 +1927,7 @@ static int xe_bo_fault_migrate(struct xe_bo
> *bo, struct ttm_operation_ctx *ctx,
> =C2=A0	if (ttm_manager_type(tbo->bdev, tbo->resource->mem_type)-
> >use_tt) {
> =C2=A0		err =3D xe_bo_wait_usage_kernel(bo, ctx);
> =C2=A0		if (!err)
> -			err =3D ttm_bo_populate(&bo->ttm, ctx);
> +			err =3D ttm_bo_populate(&bo->ttm, false, ctx);
> =C2=A0	} else if (should_migrate_to_smem(bo)) {
> =C2=A0		xe_assert(xe_bo_device(bo), bo->flags &
> XE_BO_FLAG_SYSTEM);
> =C2=A0		err =3D xe_bo_migrate(bo, XE_PL_TT, ctx, exec);
> diff --git a/include/drm/ttm/ttm_bo.h b/include/drm/ttm/ttm_bo.h
> index 8310bc3d55f9..535ba37aff88 100644
> --- a/include/drm/ttm/ttm_bo.h
> +++ b/include/drm/ttm/ttm_bo.h
> @@ -475,6 +475,7 @@ pgprot_t ttm_io_prot(struct ttm_buffer_object
> *bo, struct ttm_resource *res,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 pgprot_t tmp);
> =C2=A0void ttm_bo_tt_destroy(struct ttm_buffer_object *bo);
> =C2=A0int ttm_bo_populate(struct ttm_buffer_object *bo,
> +		=C2=A0=C2=A0=C2=A0 bool memcg_account,
> =C2=A0		=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *ctx);
> =C2=A0int ttm_bo_setup_export(struct ttm_buffer_object *bo,
> =C2=A0			struct ttm_operation_ctx *ctx);
> diff --git a/include/drm/ttm/ttm_device.h
> b/include/drm/ttm/ttm_device.h
> index 5618aef462f2..a4bd23988ee0 100644
> --- a/include/drm/ttm/ttm_device.h
> +++ b/include/drm/ttm/ttm_device.h
> @@ -85,6 +85,7 @@ struct ttm_device_funcs {
> =C2=A0	 */
> =C2=A0	int (*ttm_tt_populate)(struct ttm_device *bdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_tt *ttm,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool memcg_account,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *c=
tx);
> =C2=A0
> =C2=A0	/**
> diff --git a/include/drm/ttm/ttm_pool.h b/include/drm/ttm/ttm_pool.h
> index 26ee592e1994..7f3f168c536c 100644
> --- a/include/drm/ttm/ttm_pool.h
> +++ b/include/drm/ttm/ttm_pool.h
> @@ -78,6 +78,7 @@ struct ttm_pool {
> =C2=A0};
> =C2=A0
> =C2=A0int ttm_pool_alloc(struct ttm_pool *pool, struct ttm_tt *tt,
> +		=C2=A0=C2=A0 bool memcg_account,
> =C2=A0		=C2=A0=C2=A0 struct ttm_operation_ctx *ctx);
> =C2=A0void ttm_pool_free(struct ttm_pool *pool, struct ttm_tt *tt);
> =C2=A0
> diff --git a/include/drm/ttm/ttm_tt.h b/include/drm/ttm/ttm_tt.h
> index 406437ad674b..15d4019685f6 100644
> --- a/include/drm/ttm/ttm_tt.h
> +++ b/include/drm/ttm/ttm_tt.h
> @@ -250,6 +250,7 @@ int ttm_tt_swapout(struct ttm_device *bdev,
> struct ttm_tt *ttm,
> =C2=A0 * Calls the driver method to allocate pages for a ttm
> =C2=A0 */
> =C2=A0int ttm_tt_populate(struct ttm_device *bdev, struct ttm_tt *ttm,
> +		=C2=A0=C2=A0=C2=A0 bool memcg_account,
> =C2=A0		=C2=A0=C2=A0=C2=A0 struct ttm_operation_ctx *ctx);
> =C2=A0
> =C2=A0/**

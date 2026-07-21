Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F41471408
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 20:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664169; cv=none; b=SfG4bpi+YTYfypNbdB1veJDE1ph9LMKjQUg5U2qx+ExGtXrOwvVtbV9M8E7+Ls1FfSukd3dfjn4Kkd62pcpHYoX2TpKMvLc5RMHvs3s+DGo7pn9FnyCgTNX6+Rx1X10yqXaz+NVUD4KceyQKpiezOxbptfR66f1jS3p/OVrvfP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664169; c=relaxed/simple;
	bh=96yA8mD1e3ZjIfnonBbknt72yA7ScFllXK17fNt3ozc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a+rA2/P/DlJmfUpsjU34GlEjeUCwseleUBEvIz2mKevCn5LZ666kX7qdg1TEoyqbXCV5eMmjVF9cLYNkvQmjhnVQ7/1FX4Mjd0uwxh5NoR8lBN/HbvtnrQjmwoyoibNigSxsxZmmkRc+ghvd4B1k1MLIT4ZnKG0VEO442TY/bLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=emSG6YCR; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="emSG6YCR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784664167; x=1816200167;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=96yA8mD1e3ZjIfnonBbknt72yA7ScFllXK17fNt3ozc=;
  b=emSG6YCR6eEftOF85UbWdf4wThlHn1SSz82/Utgw0QqgnKrrBRKjofo3
   BRJTu+Ys610HcTEoNHAxycdO9ZRhEoFo9lNfNUHoWcxbinJ9CZ7nuWrkq
   oCeSrhpl22TdE2+v/jNdMxNDCpNbP2ZrU2m+GNFeYNKZcnayy/GZxkPmm
   fz8uYyqiJ3tePKmCYlus2WKYzGhdVji84fyua0tt8abeGQSv8paLFFF55
   6iqZFkZO92LfmdNynrRGsoTS2kUnyOggLHeTt74nip+HSdS113SPGSV4T
   Leux66Qt4saFGA1F7ftSzLabkgAhoErTpHYiaBu3a1YvOt+g55gRUjG3V
   Q==;
X-CSE-ConnectionGUID: ezr1B8hXTaq7/+T9sBRV0w==
X-CSE-MsgGUID: Zdv1TldKRyuhoGu2WZFvgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="110828107"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="110828107"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 13:02:46 -0700
X-CSE-ConnectionGUID: xBUHeOvTT7mlRNO3WfVr+g==
X-CSE-MsgGUID: 5fzaCiORQziorivDS7oSrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="256075075"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.245.245.142]) ([10.245.245.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 13:02:42 -0700
Message-ID: <9aad796e-0db7-4368-8228-8eed3556d1e2@linux.intel.com>
Date: Tue, 21 Jul 2026 22:03:38 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] drm/ttm: Extract code for attempting allocation in
 a place
To: Natalie Vock <natalie.vock@gmx.de>, Maarten Lankhorst <dev@lankhorst.se>,
 Maxime Ripard <mripard@kernel.org>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 =?UTF-8?Q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
References: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
 <20260721-dmemcg-aggressive-protect-v7-3-97c4b1014315@gmx.de>
Content-Language: en-US
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <20260721-dmemcg-aggressive-protect-v7-3-97c4b1014315@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/21/26 21:43, Natalie Vock wrote:
> Move all code for attempting allocation for a specific place to
> ttm_bo_alloc_place. With subsequent patches, this logic is going to get
> more complicated, so it helps readability to have this separate.
> 
> ttm_bo_alloc_at_place takes a pointer to a struct ttm_bo_alloc_state.
> This struct holds various state produced by the allocation (e.g. cgroup
> resource associated with the allocation) that the caller needs to keep
> track of (and potentially dispose of). This is just the limiting cgroup
> pool for now, but future patches will add more state needing to be tracked.
> 
> ttm_bo_alloc_at_place also communicates via return codes if eviction
> using ttm_bo_evict_alloc should be attempted. This is preparation for
> attempting eviction in more cases than just force_space being set.
> 
> No functional change intended.
> 
> Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
> ---
>  drivers/gpu/drm/ttm/ttm_bo.c | 101 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 79 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 3980f376e3ba4..7192c15f2fcef 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -488,6 +488,62 @@ int ttm_bo_evict_first(struct ttm_device *bdev, struct ttm_resource_manager *man
>  	return ret;
>  }
>  
> +struct ttm_bo_alloc_state {
> +	/** @limit_pool: Which pool limit we should test against */
> +	struct dmem_cgroup_pool_state *limit_pool;
> +};
> +
> +/**
> + * ttm_bo_alloc_at_place - Attempt allocating a BO's backing store in a place
> + *
> + * @bo: The buffer to allocate the backing store of
> + * @place: The place to attempt allocation in
> + * @ctx: ttm_operation_ctx associated with this allocation
> + * @force_space: If we should evict buffers to force space
> + * @res: On allocation success, the resulting struct ttm_resource.
> + * @alloc_state: Object holding allocation state such as charged cgroups.
> + *
> + * Returns:
> + * -EBUSY: No space available, but allocation should be retried with ttm_bo_evict_alloc.
> + * -ENOSPC: No space available, allocation should not be retried.
> + * -ERESTARTSYS: An interruptible sleep was interrupted by a signal.
> + *
> + */
> +static int ttm_bo_alloc_at_place(struct ttm_buffer_object *bo,
> +				 const struct ttm_place *place,
> +				 struct ttm_operation_ctx *ctx,
> +				 bool force_space,
> +				 struct ttm_resource **res,
> +				 struct ttm_bo_alloc_state *alloc_state)
> +{
> +	bool may_evict;
> +	int ret;
> +
> +	may_evict = force_space && place->mem_type != TTM_PL_SYSTEM;
> +
> +	ret = ttm_resource_alloc(bo, place, res,
> +				 force_space ? &alloc_state->limit_pool : NULL);
> +
> +	if (ret) {
> +		/*
> +		 * -EAGAIN means the charge failed, which we treat like an
> +		 * allocation failure. Therefore, return an error code indicating
> +		 * the allocation failed - either -EBUSY if the allocation should
> +		 * be retried with eviction, or -ENOSPC if there should be no second
> +		 * attempt.
> +		 */
> +		if (ret == -EAGAIN)
> +			return may_evict ? -EBUSY : -ENOSPC;

-EAGAIN is no longer returned here since commit
591711b32681 ("drm/ttm: Convert -EAGAIN from dmem_cgroup_try_charge to -ENOSPC")

> +		if (ret == -ENOSPC && may_evict)
> +			return -EBUSY;
> +
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * struct ttm_bo_evict_walk - Parameters for the evict walk.
>   */
> @@ -503,12 +559,13 @@ struct ttm_bo_evict_walk {
>  	/** @evicted: Number of successful evictions. */
>  	unsigned long evicted;
>  
> -	/** @limit_pool: Which pool limit we should test against */
> -	struct dmem_cgroup_pool_state *limit_pool;
>  	/** @try_low: Whether we should attempt to evict BO's with low watermark threshold */
>  	bool try_low;
>  	/** @hit_low: If we cannot evict a bo when @try_low is false (first pass) */
>  	bool hit_low;
> +
> +	/** @alloc_state: State associated with the allocation attempt. */
> +	struct ttm_bo_alloc_state *alloc_state;
>  };
>  
>  static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *bo)
> @@ -517,8 +574,9 @@ static s64 ttm_bo_evict_cb(struct ttm_lru_walk *walk, struct ttm_buffer_object *
>  		container_of(walk, typeof(*evict_walk), walk);
>  	s64 lret;
>  
> -	if (!dmem_cgroup_state_evict_valuable(evict_walk->limit_pool, bo->resource->css,
> -					      evict_walk->try_low, &evict_walk->hit_low))
> +	if (!dmem_cgroup_state_evict_valuable(evict_walk->alloc_state->limit_pool,
> +					      bo->resource->css, evict_walk->try_low,
> +					      &evict_walk->hit_low))
>  		return 0;
>  
>  	if (bo->pin_count || !bo->bdev->funcs->eviction_valuable(bo, evict_walk->place))
> @@ -560,7 +618,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
>  			      struct ttm_operation_ctx *ctx,
>  			      struct ww_acquire_ctx *ticket,
>  			      struct ttm_resource **res,
> -			      struct dmem_cgroup_pool_state *limit_pool)
> +			      struct ttm_bo_alloc_state *state)
>  {
>  	struct ttm_bo_evict_walk evict_walk = {
>  		.walk = {
> @@ -573,7 +631,7 @@ static int ttm_bo_evict_alloc(struct ttm_device *bdev,
>  		.place = place,
>  		.evictor = evictor,
>  		.res = res,
> -		.limit_pool = limit_pool,
> +		.alloc_state = state,
>  	};
>  	s64 lret;
>  
> @@ -724,9 +782,8 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_object *bo,
>  
>  	for (i = 0; i < placement->num_placement; ++i) {
>  		const struct ttm_place *place = &placement->placement[i];
> -		struct dmem_cgroup_pool_state *limit_pool = NULL;
> +		struct ttm_bo_alloc_state alloc_state = {};
>  		struct ttm_resource_manager *man;
> -		bool may_evict;
>  
>  		man = ttm_manager_type(bdev, place->mem_type);
>  		if (!man || !ttm_resource_manager_used(man))
> @@ -736,25 +793,25 @@ static int ttm_bo_alloc_resource(struct ttm_buffer_object *bo,
>  				    TTM_PL_FLAG_FALLBACK))
>  			continue;
>  
> -		may_evict = (force_space && place->mem_type != TTM_PL_SYSTEM);
> -		ret = ttm_resource_alloc(bo, place, res, force_space ? &limit_pool : NULL);
> -		if (ret) {
> -			if (ret != -ENOSPC) {
> -				dmem_cgroup_pool_state_put(limit_pool);
> -				return ret;
> -			}
> -			if (!may_evict) {
> -				dmem_cgroup_pool_state_put(limit_pool);
> -				continue;
> -			}
> +		ret = ttm_bo_alloc_at_place(bo, place, ctx, force_space,
> +				res, &alloc_state);
>  
> +		if (ret == -ENOSPC) {
> +			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
> +			continue;
> +		} else if (ret == -EBUSY) {
>  			ret = ttm_bo_evict_alloc(bdev, man, place, bo, ctx,
> -						 ticket, res, limit_pool);
> -			dmem_cgroup_pool_state_put(limit_pool);
> +						 ticket, res, &alloc_state);
> +
> +			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
> +
>  			if (ret == -EBUSY)
>  				continue;
> -			if (ret)
> +			else if (ret)
>  				return ret;
> +		} else if (ret) {
> +			dmem_cgroup_pool_state_put(alloc_state.limit_pool);
> +			return ret;
>  		}
>  
>  		ret = ttm_bo_add_pipelined_eviction_fences(bo, man, ctx->no_wait_gpu);
> 


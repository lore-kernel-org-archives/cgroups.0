Received: from lankhorst.se (unknown [141.105.120.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC7471424
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 20:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.105.120.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664166; cv=none; b=spfKB/qpiRiblm65SBZ1Zfv9ELqNgwXfYa/iGcDnji/hk+fbVnIm6a2H2beXE3aC/tdpZTtydxbVol13DYOwnIq3eZIHkRl5JhcyK3xJzOJso7pNAWms/YnX/KA0XlZwSR5z55/DLP8ZitzN5o3juyLLfUz7KTd5uJuLAZ32yzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664166; c=relaxed/simple;
	bh=pgUo9mvI9JjTqimQl3J21zQSeTH7suoYcdzAjPBLXHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHHqMk6qLOgvTFT64nXlRCoZ0gij2p+ehjMU7EaV9dzYKluFZnbuaTD1YlLRgbk4vI/5Qht7iWwxvBVtR0LCgfrhgTng9uDCd4ccNPG7k4tR+KgMX61gSeZ+ujbAWfDHOAjiPeQcT6Z5/bkYFQJPRVjBL1gdr6YMe9IFASTXyCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se; spf=pass smtp.mailfrom=lankhorst.se; dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b=Uzs75kIW; arc=none smtp.client-ip=141.105.120.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b="Uzs75kIW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1784663834;
	bh=pgUo9mvI9JjTqimQl3J21zQSeTH7suoYcdzAjPBLXHY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Uzs75kIW72h0LQNcD+fTUWdluUdGjLoa6MpGic9GXJe7QG/ZrjNNYgQ9wT4/Gk2nb
	 TsZo4j2tgFmHqpi4Vn3makA/+r+e16asyRokWc9TgtSWdZwWxXn+zlw3aAtouta4Qq
	 4PyGkxB2O83v7GoLXPV0lUoh2Oi4yRWexMZKMwNBmGPdqkJri/qEOkYLy7vNLjNlrd
	 r3D/jhlQUsgUZTDJ9nt9breQkKWE960uIIQfYZa7DSs6t8e8NRqSD+YeZX3/FVnEt+
	 P+bhq+om9jriU1hy36kot+Hub7ZVF9oo06rA9xLZUkOdltGFGXVwav50E7YaarjMsq
	 2mwz7yc2TlzlQ==
Message-ID: <725ec373-67be-4290-a102-23737a90829e@lankhorst.se>
Date: Tue, 21 Jul 2026 21:58:11 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
To: Natalie Vock <natalie.vock@gmx.de>, Maxime Ripard <mripard@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 =?UTF-8?Q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
 <20260721-dmemcg-aggressive-protect-v7-2-97c4b1014315@gmx.de>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <20260721-dmemcg-aggressive-protect-v7-2-97c4b1014315@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>

Feel free to push!

On 7/21/26 21:43, Natalie Vock wrote:
> This helps to find a common subtree of two resources, which is important
> when determining whether it's helpful to evict one resource in favor of
> another.
> 
> To facilitate this, add a common helper to find the ancestor of two
> cgroups using each cgroup's ancestor array.
> 
> Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
> ---
>  include/linux/cgroup.h      | 21 +++++++++++++++++++++
>  include/linux/cgroup_dmem.h |  9 +++++++++
>  kernel/cgroup/dmem.c        | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index f2aa46a4f871e..83a17ded1c516 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -623,6 +623,27 @@ static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
>  	return cgrp->ancestors[ancestor_level];
>  }
>  
> +/**
> + * cgroup_common_ancestor - find common ancestor of two cgroups
> + * @a: first cgroup to find common ancestor of
> + * @b: second cgroup to find common ancestor of
> + *
> + * Find the first cgroup that is an ancestor of both @a and @b, if it exists
> + * and return a pointer to it. If such a cgroup doesn't exist, return NULL.
> + *
> + * This function is safe to call as long as both @a and @b are accessible.
> + */
> +static inline struct cgroup *cgroup_common_ancestor(struct cgroup *a,
> +						    struct cgroup *b)
> +{
> +	int level;
> +
> +	for (level = min(a->level, b->level); level >= 0; level--)
> +		if (a->ancestors[level] == b->ancestors[level])
> +			return a->ancestors[level];
> +	return NULL;
> +}
> +
>  /**
>   * task_under_cgroup_hierarchy - test task's membership of cgroup ancestry
>   * @task: the task to be tested
> diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
> index 1a88cd0c9eb00..9d72457c4cb9d 100644
> --- a/include/linux/cgroup_dmem.h
> +++ b/include/linux/cgroup_dmem.h
> @@ -28,6 +28,8 @@ bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
>  			   struct dmem_cgroup_pool_state *test);
>  bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>  			   struct dmem_cgroup_pool_state *test);
> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
> +							       struct dmem_cgroup_pool_state *b);
>  
>  void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
>  #else
> @@ -75,6 +77,13 @@ static inline bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>  	return false;
>  }
>  
> +static inline
> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
> +							       struct dmem_cgroup_pool_state *b)
> +{
> +	return NULL;
> +}
> +
>  static inline void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool)
>  { }
>  
> diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
> index 9df3b33c65046..edb4c04d09dfe 100644
> --- a/kernel/cgroup/dmem.c
> +++ b/kernel/cgroup/dmem.c
> @@ -762,6 +762,42 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>  }
>  EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
>  
> +/**
> + * dmem_cgroup_get_common_ancestor(): Find the first common ancestor of two pools.
> + * @a: First pool to find the common ancestor of.
> + * @b: First pool to find the common ancestor of.
> + *
> + * Return: The first pool that is a parent of both @a and @b, or NULL if either @a or @b are NULL,
> + * or if such a pool does not exist. A reference to the returned pool is grabbed and must be
> + * released by the caller when it is done using the pool.
> + */
> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
> +							       struct dmem_cgroup_pool_state *b)
> +{
> +	struct cgroup *ancestor_cgroup;
> +	struct cgroup_subsys_state *ancestor_css;
> +	struct dmem_cgroup_pool_state *pool = NULL;
> +
> +	if (!a || !b)
> +		return NULL;
> +
> +	ancestor_cgroup = cgroup_common_ancestor(a->cs->css.cgroup, b->cs->css.cgroup);
> +	if (!ancestor_cgroup)
> +		return NULL;
> +
> +	rcu_read_lock();
> +	ancestor_css = cgroup_e_css(ancestor_cgroup, &dmem_cgrp_subsys);
> +	if (css_tryget(ancestor_css))
> +		pool = get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
> +					    a->region);
> +	if (!pool)
> +		css_put(ancestor_css);
> +	rcu_read_unlock();
> +
> +	return pool;
> +}
> +EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
> +
>  static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
>  {
>  	struct dmem_cgroup_region *region;
> 


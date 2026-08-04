Received: from lankhorst.se (unknown [141.105.120.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D28C494A1B
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 20:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.105.120.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785875011; cv=none; b=PKkWGKvA3ftswN7MD7hP1HBxkY5fz++Atrswgj1sbn1L9NOV0AbowoZesjnllro4yesVF2GTxhGzWR7yZ768amIZ21t7PT6wdu8wUIT+RHZXsk19DFEt1odQDjQKGd0i+TIMLDW609s1rW5QonGD/b62BQ6mC66HVzgJ9Z/HAqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785875011; c=relaxed/simple;
	bh=dHRRYCr6KNXPQ/XC3VIjH4wQn3v7mHs7limZc8dV07w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tktoPVWAqUfKlX2+lRu9qemqPsLVnBStiFtMI2T7qN8RKWumB+z0ArseT0+iDUyWqEO+zqQAPrJeIxd6oNg+MafEbjfFvEKleti87zE3mEV9h9p32RlDFnwBz8x2SDWgaIWBkAUYlL+IwENXUQ3ucsmyQ5Np8VV19KeRUaEpQhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se; spf=pass smtp.mailfrom=lankhorst.se; dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b=RgrMpsLG; arc=none smtp.client-ip=141.105.120.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b="RgrMpsLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1785874639;
	bh=dHRRYCr6KNXPQ/XC3VIjH4wQn3v7mHs7limZc8dV07w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RgrMpsLGhMHrvhXETcOnUlgTp2Cku8y6q4XDrRMwzak0C7NG5WtLfiwa4IP9tC8J1
	 y0WXbpfIinT8aEKyLCq1cHgwCJFT47cCER/oHQ8TZSXZDac4zTnxUj/Mdg4FFnSTbp
	 gGq3HLv1fNAkXTCJGHAEnB7ZqYohflhSfx5s/GtwSWib0cOvYWB8qqnegGwX9KuYmF
	 JZphUsZ6RM3SPT0WeLBEJwzbIaEtGhIcmJNzUaT1XWGl8uvGDukDTsfu6WQTI/M8un
	 YCc1eaQ0saK7h/coYFZLi+9jrgneOYye7RqpkMGOf1oXeGfZgg7OqO5VRAv3x3Bu6X
	 RSYenpeRdV98Q==
Message-ID: <b5b80acd-feea-408b-87eb-4264ffc7e2cd@lankhorst.se>
Date: Tue, 4 Aug 2026 22:18:32 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] cgroup,cgroup/dmem: Add
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
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
 <20260804-dmemcg-aggressive-protect-v8-2-07af96681bf8@gmx.de>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <20260804-dmemcg-aggressive-protect-v8-2-07af96681bf8@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/4/26 10:25, Natalie Vock wrote:
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
>  kernel/cgroup/dmem.c        | 41 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 71 insertions(+)
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
> index 9df3b33c65046..a587611ca2235 100644
> --- a/kernel/cgroup/dmem.c
> +++ b/kernel/cgroup/dmem.c
> @@ -762,6 +762,47 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
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
> +	struct dmemcg_state *ancestor_dmemcs = NULL;
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
> +		ancestor_dmemcs = css_to_dmemcs(ancestor_css);
> +	rcu_read_unlock();
> +
> +	if (ancestor_dmemcs) {
> +		pool = get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
> +					    a->region);
> +		if (IS_ERR(pool))
> +			pool = NULL;
This should probably be a warn_on as this can never happen, sashiko is wrong here.

If a and b are charged, all their ancestors are charged too. And when they share a
common ancestor, then the common ancestor has to have an existing charged pool as
well because there's a huge bug in the code otherwise.

> +		css_put(ancestor_css);
> +	}
> +	return pool;
> +}
> +EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
> +
>  static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
>  {
>  	struct dmem_cgroup_region *region;
> 

Otherwise looks good, so feel free to extend my r-b to this patch too, and with that minor fix up commit it.

Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>


Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C5117993
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788978074; cv=none; b=KvcN0AyI/chG15sNYIuO99+j6+UamxRXBYBZ57Kg+TfH4059LsVw5spMRDT847lq2aRA/b3BnghstXaZIxWPs3A3t8Wp+Omn1FUdVyrGEZJaDVRsYTm34qgY45ql8/oFQQsu2ZyUqH3Sn87sSDvYHRrjYLT3u1+vYjAPZeVECCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788978074; c=relaxed/simple;
	bh=C+OpCeT5gS8c3fbfvJQiNaFeaqhR2+5vFvUmbRntlSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=foxH4PSVl6zewvIXn6v+szPyDdzY5P3KokAGuW+ok/L3Le0G2j6OWuizOp+larhDnrs8W8HDsNNLJ8GbEkf53Vswg8j73snNHySMyGQkX3HQug+ovTukZMJtQr/tGeKqIN1mfOEsrgY1hmytrb75LTtw9gwfq74mIUts8yY/PTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=pfuiC65T; arc=none smtp.client-ip=74.125.224.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="pfuiC65T"
Received: by mail-yx2-f1.google.com with SMTP id 956f58d0204a3-66d27631526so2021119d50.1
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978070; x=1789582870; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CUMCov5LhTuYJkVeQH8wQuxKR0Qh1nB1q0JH2zRc7+s=;
        b=pfuiC65TobxFZbLAXgQfD2CK5cMzsd+fV+skQhg0AAw9ZrPdn7x9HMGHN3JtFD11Oa
         2VuuKObfrGQZoXnc5UwFbkCnS1o5ZRCIo32YT46rzsWI/v5t9Ry2w1Gd9OAGDqNHlOBy
         b+MWIN0MAG4xqybTh12fmfpr4y5y89FM7mDq8FtEp0HhL9Z4WA0qkV5eLC5u3UUQgvCN
         YSUuqoRH+BTz2qeSgR1kmncHSCeY9G/XXlGAOfJsu4VF02LVJrwIpfvSlKoLfVBRJmfw
         7iDQ9VSjHfeUuinGWLo2oubUyAiRUpOs4LY1mUyO07I3V3i0fEF7G/I2jK1lBtcdDXw6
         Rb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978070; x=1789582870;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CUMCov5LhTuYJkVeQH8wQuxKR0Qh1nB1q0JH2zRc7+s=;
        b=IMmuJR0jilWYulAOHAb2rUQGxhFTWAbL9kuSxwNWyU+MdOAjbo8JvWj9yiLqe596/+
         W0sGsS5idyNmaVF3aF2lYH8SyBXfWxwSIE9fgPcY7RJc5Jc9xcCR/AOwTI+0YmCmpOnk
         bYEukj1KldX51I1pt3QK3JJtcjYSxU3djm0bOTW4K3toTcgHhMRIhHEJxZpqA2HBqn7h
         BNuYG868ierQ74AywPihYybEjoy3iiDkjiys7kuzENfA14jH0rUb6xryYpo5wTNHTbHh
         /3f+H69kxW5pOIhtGOC0h25drh5Ca3Pezmok/h1J9B6qQLz1oa3mY3za5MNyFjryPI/F
         SNpg==
X-Forwarded-Encrypted: i=1; AKwUvBxdfPB1F7PBsBLMYZ1YOe8AZoykjCEHbzke/eQRhF+XMFLpqt9dJFEh2z6rVZEBaFmOPmmKC+CT@vger.kernel.org
X-Gm-Message-State: AFuF++mAg9tmDBhfhPSIN+uXW2Jtn0ocqp5CAmpIhSeCxsmlwiCTgLJK
	jlOYqizRzo2UYTNl5/nOU/f2EZrmv8oQH8vuYpZspOeEQpxAvEGtdfZTYLfehk6nGG0=
X-Gm-Gg: AYBFou3pa/psDu64PRi8eUfqLtMBJVVLIEeH6EwVqOUa/uZYAvJYcm3UKO6I0Xjd8av
	iCY3S4mEpdX5yT84VV84i9y+Kc7FAIIjVBBzOsAmC/P6ew+0bNz7Fhv8eRhSOxye5nB+ZYL5rDg
	xIoYDKQy8fotTIS/NdSGRUbx5QnpuJXwcc5DiKjcZReTGj+OJQa0A/HSWcmvS9/3PDMV0xYss0u
	Kv0rTtr+Rpv+fcVBnJ2VSgCxfyR0W5CqioFM4DIEEujIYOte+ylECCyYCuPlsCl3nXAyOxkDHS3
	4CHWwwwt9yxN/JJg8JsucR3bHgkYHjA1GBgKfvpZAZBzTZC4xBQDtT+p3SR0lMwDq3n69Xy9f8p
	t64Wc2phF34D0QPd4oCwN7A3MfzVs1EWd/Lvpjfn+3i6a4PjjAFV2XVHea/fPoWOk0BXzQAJIag
	ll8NFTf8wxx0f1mISq4HwqjphwRMp40qQOkRVPg+g973TE82ziaXAhoVvO5VaufdlONBghOno=
X-Received: by 2002:a53:e447:0:b0:66f:c1bc:c081 with SMTP id 956f58d0204a3-66fc1bcc626mr7160601d50.73.1788978070364;
        Wed, 09 Sep 2026 11:21:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406871b6sm152808526d6.32.2026.09.09.11.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:21:08 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:21:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
Message-ID: <aqGjkGA7XeYEHA2T@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>

On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
> kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
> and is only used as the list_lru xarray index.  With
> cgroup.memory=nokmem the assignment never happens, so every memcg
> resolves to the per-node lists.  The next patch needs the index to
> work under nokmem as well, so drop the copy and use the memcg ID.
> 
> The ID works just as well as the copy did: root and NULL still
> return -1 and use the per-node lists, and the ID is only released
> after the list_lru reparenting, so a stale or recycled ID can never
> reach a live list_lru entry.
> 
> The early return of memcg_offline_kmem() under nokmem is dropped as
> well, so the reparenting also covers lrus that stay memcg aware
> without kmem accounting.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>  include/linux/memcontrol.h |  8 +++++---
>  mm/list_lru.c              | 10 +++++-----
>  mm/memcontrol.c            |  6 ------
>  3 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fdf4812e1d818..edeb287978934 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -254,7 +254,6 @@ struct mem_cgroup {
>  #if BITS_PER_LONG < 64
>  	seqlock_t		socket_pressure_seqlock;
>  #endif
> -	int kmemcg_id;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;
> @@ -1775,12 +1774,15 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
>  }
>  
>  /*
> - * A helper for accessing memcg's kmem_id, used for getting
> + * A helper for accessing the memcg ID, used for getting
>   * corresponding LRU lists.
>   */
>  static inline int memcg_kmem_id(struct mem_cgroup *memcg)
>  {
> -	return memcg ? memcg->kmemcg_id : -1;
> +	if (!memcg || mem_cgroup_is_root(memcg))
> +		return -1;
> +
> +	return memcg->id.id;
>  }

This is a private ID with lifetime only guaranteed for online
groups. Reparenting happens right before it dies at offlining right
now, but this is not a great dependency to have.

Use mem_cgroup_id() instead and just get rid of that helper.

>  struct mem_cgroup *mem_cgroup_from_virt(void *p);
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index a4522ca93ebcb..6fd4e9af84396 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -502,7 +502,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
>  					struct list_lru_one *src,
>  					struct mem_cgroup *dst_memcg)
>  {
> -	int dst_idx = dst_memcg->kmemcg_id;
> +	int dst_idx = memcg_kmem_id(dst_memcg);
>  	struct list_lru_one *dst;
>  
>  	spin_lock_irq(&src->lock);
> @@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  		 * allocating a new mlru since CSS_DYING is already set for this
>  		 * memcg a rcu grace period ago.
>  		 */
> -		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
> +		mlru = xa_load(&lru->xa, memcg_kmem_id(memcg));
>  		if (!mlru)
>  			continue;
>  
> @@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  		for_each_node(i)
>  			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
>  
> -		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
> +		xa_erase_irq(&lru->xa, memcg_kmem_id(memcg));
>  
>  		/*
>  		 * Here all list_lrus corresponding to the cgroup are guaranteed
> @@ -566,7 +566,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
>  					    struct list_lru *lru)
>  {
> -	int idx = memcg->kmemcg_id;
> +	int idx = memcg_kmem_id(memcg);
>  
>  	return idx < 0 || xa_load(&lru->xa, idx);
>  }
> @@ -602,7 +602,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
>  			if (!mlru)
>  				return -ENOMEM;
>  		}
> -		xas_set(&xas, pos->kmemcg_id);
> +		xas_set(&xas, memcg_kmem_id(pos));
>  		do {
>  			xas_lock_irqsave(&xas, flags);
>  			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7ce50bccf1264..619d4c1f2e8f2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3780,17 +3780,12 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
>  		return;
>  
>  	static_branch_enable(&memcg_kmem_online_key);
> -
> -	memcg->kmemcg_id = memcg->id.id;
>  }
>  
>  static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup *parent;
>  
> -	if (mem_cgroup_kmem_disabled())
> -		return;
> -
>  	if (unlikely(mem_cgroup_is_root(memcg)))
>  		return;

Both of these functions do very little now and the asymmetry you're
adding on the mem_cgroup_kmem_disabled() check looks odd. Please just
inline them into mem_cgroup_css_online()/offline():

onlining:
	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root()))
		static_branch_enable(&memcg_kmem_online_key);

offlining:
	memcg_reparent_list_lrus(memcg, parent);

The root check is unnecessary because roots are not destroyed. But if
you'd rather not make that change here, keep the root check, and leave
its removal to a separate cleanup patch, that's fine too.

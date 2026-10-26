Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007509;
	b=ZvF0m2Xr6KTZxcT8z9VrDXMZASMHem927aCFT2H+4HS/1UyzTWdB7N7XlOb3vR3EgGKg
	 ZHHnpBWA5kJYa0ecHDgjjQ0buTPZkSDTAYe9hu8NcYfj/jNc5pQGPeOl0hM3yu76P6tB/
	 qPhHb8iOTnP5Ue5gxkxX75g/HS//GDGfKKupE9ti6+ank8A3KtqqtGxYfachaFjKIyquk
	 qdOCAES1bg+hIBTOwDluPyBWi5wejjw6JXuBiyVpsXCSkMN9QJ2eSZlMqjt/PO6y/VsJ/
	 fbG1pKvw2njAKzYHFj7GqoDjfOxwlgt0AvZ+XnsS8/zAkKjMRpTIHojKCOyFI0SO3Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007509;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=x+EqPqnUrdL97N89dZ6gFIZevXV0kvlIFkPLD7q7NEY=;
	b=sWNMoGTbXwLMEqEW4Hqv5tZZ4OhFJlacm9//N/lF+FrMGjnC3t6/WV8Ej8IoN+MY+F03
	 Ax/AaG9tWnCKvFvh7aH4uzEnRMEl3f7s5GAOEAsVNj3zZJcCB65yflvjSp31fAckPCcMK
	 WSOU8EcirE3Bn/j2j9j1fSuS0WWErkt4+Ymy5y2eS/C2QSIwN46z28OM3d1Ge4ugJ8mf8
	 wmt6/34E+hwcJVhfLMBEDdZUoyqXNInsjEEja8yvmMkF0zHyhwA6MjVaWtnOYMmkHKOCi
	 yERarQD3PY97xl+Tczkquxklhn6MBlxoO14VYqOfuBciZWailZFS0Fwd8snUmPUWUWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=V+vap0DN;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1996F606A31A
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 09:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1996F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=V+vap0DN
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so8557155e9.0
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 02:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793007507; x=1793612307; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x+EqPqnUrdL97N89dZ6gFIZevXV0kvlIFkPLD7q7NEY=;
        b=V+vap0DNhUEaVpCg2DhHMh77XyUYV3l8M1l/MQJ34BhhwkwvM9UsEj9KhDPdFSGRp0
         owQcZK0S+OKvw3vB4t++ihvLemrjzzOa+W0uF2KZgix0H13n+Npyx34uEa7M+Sbyrcpd
         S8dGOlv1YLQMn2vg71pgoQN6rQ99mtPEoWbd9Nd9InvISzTgGu0z0IVKM9CKXB+g8QBz
         tKROMwOeG5pfYn5my7ex8J6qABXG2LPg4j95st+UqxTkTPJDLaffpXLlGat1xjfL5oTu
         nnjaDxuLp9xMAzZEbAV4Uft62RoGodZwV8U+ST4DO5E14OHrQPqByViM9NgmtPgYEqn5
         +kpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793007507; x=1793612307;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x+EqPqnUrdL97N89dZ6gFIZevXV0kvlIFkPLD7q7NEY=;
        b=GOQPMqzHU8Zd25apAUUBkDw7BvaLMaiXhOBG4u3zJn8LM0doDUEB8rPzbbfCWIC4px
         oGK0RjWvRe6D2MBFZ45elsA8EPFzAiavJXcHUAGt5db1Fp4LGBvkPiC9zLcB60O/eMuJ
         hXukFD3dK1CX6l964Cu+1oWFoFNbH/n7e2OzPl+GqKjPBdLvaqHv7Mm7tYtofmEZmhsm
         KppQj/qyvA6ajuwcehSf5Vhq0fiiNz5lu9eOH13sn2V93ITrrmirYtXG0zCIUcNEdSrj
         8R77JGJlxTqn9/sXvK4t0TxEbGHk+gZm7b4zlvyonjM7XBVVFKJOk4Dswt68EWsBVPpK
         76+w==
X-Forwarded-Encrypted: i=1; AKwUvBzuamrJFZPU644FE4cKRDSaFA8VKqljCVZwECrdLlOJvuhYuvTOCZyOlMngqvLbrMYnY81Pnz4M@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1IY+kAL/epUIqqekZPQJ5LiUtSNLuA65BykAovAuW4A89bU2u
	JRMuSFWc4PN2KNxyIlB3DOld3A7e7MJ5GohpcEegE3Z1GpKV3mU09yW0zLfzSXuvODo=
X-Gm-Gg: AYBFou3I9fDqOc8P3bYn/pBttQ3wT/4b+MUZpN2+ppDX+Jg+5EHLTQ/8SQO/qIQSYOf
	gVJQlbjJ3EAjSTtkSS9ks56mt9g9A2JlJXENvZXl+732IHDKs37Lyk+X3JAIN+cPV0HFEmcGuol
	pFw1Ygnrd6k73mi6knQT0MzYeP3ZUu02APQvJV7QmbVkYFjrEBTHCdfB60uKTxwOrQPttyps6cs
	MyOH9tXf0hNBj/I4rn2xXIfvxpZ764S7ZUR6ZKAclOniOqV7RKNf/GUXzBzcILvZQp3EDgGGNeX
	JdF+TshZPNCxhQlHNesJ0Fg6xOBXkFcmJxUfBt1m4xcCZaJjpmK+vPqZZoYEaasIBZVr/+5ertR
	6PGDpa69frCoDcQQe5TWteb3Op9Y+0Ek1sWXnlRvNCtPpKNt4bw4LM49DBGJEKt06Y2lugQgbBl
	pmp2f9XFC5d6GtgzLAMgM9enRVLc1XxJSWywuj65xwsVIosJ7u+47dzQpgw7e6Pl+NcM/RoUAK7
	P7LHNm6nNV6WD/zeNwUCSWgkgB0xSq1fPEqodxxgt9ouELRAiBClC5HZfbCotAmOKDdcnvRJVpb
	w4aPA2aF401ry5k+
X-Received: by 2002:a05:600c:8b63:b0:4a2:1960:6fa with SMTP id 5b1f17b1804b1-4a35ae7027emr123797325e9.4.1793007507462;
        Mon, 26 Oct 2026 02:38:27 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359fbb725sm181656095e9.0.2026.10.26.02.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:38:27 -0700 (PDT)
Date: Mon, 26 Oct 2026 10:38:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] memcg: don't go through the lruvec for folio and
 kmem lruvec stat updates
Message-ID: <at8fkp9hR7Mvjy4J@tiehlicka>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
 <20261023195417.1391216-3-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023195417.1391216-3-joannelkoong@gmail.com>

On Fri 23-10-26 12:54:17, Joanne Koong wrote:
> lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
> and the node, but look up the lruvec with mem_cgroup_lruvec() and update
> the stats through mod_lruvec_state(), which reads lruvec->pgdat and
> mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
> 128-byte cacheline pair with lines that the lru_lock holder writes
> constantly (lru_lock or lru_zone_size[], depending on the alignment of
> struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
> these per-folio stat updates contend with the lru_lock holder.
> 
> Pass the memcg and node they already know to mod_memcg_node_state()
> instead.
> 
> On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
> (80 CPUs) with threads faulting in and freeing shmem in a single memcg,
> this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
> pages/sec) and 2% at 80 threads (8.66M -> 8.82M).
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 71 ++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..9f33cc5c8293 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>  	return x;
>  }
>  
> -static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> +static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
>  				     enum node_stat_item idx, long val);
>  
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> @@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  	int nid;
>  
>  	for_each_node(nid) {
> -		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> -		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> -		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> -		struct mem_cgroup_per_node *child_pn, *parent_pn;
> +		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +		unsigned long value = lruvec_page_state_local(lruvec, idx);
>  
> -		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
> -		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> -
> -		__mod_memcg_lruvec_state(child_pn, idx, -value);
> -		__mod_memcg_lruvec_state(parent_pn, idx, value);
> +		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
> +		__mod_memcg_lruvec_state(parent, nid, idx, value);
>  	}
>  }
>  
> @@ -990,10 +985,10 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>  }
>  #endif
>  
> -static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> +static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
>  				     enum node_stat_item idx, long val)
>  {
> -	struct mem_cgroup *memcg = pn->memcg;
> +	struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>  	int i = memcg_stats_index(idx);
>  	int cpu;
>  
> @@ -1015,21 +1010,23 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>  	put_cpu();
>  }
>  
> +static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
> +				 enum node_stat_item idx, int val)
> +{
> +	bool rcu_locked = false;
> +
> +	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
> +	__mod_memcg_lruvec_state(memcg, nid, idx, val);
> +	get_non_dying_memcg_end(rcu_locked);
> +}
> +
>  void mod_memcg_lruvec_state(struct lruvec *lruvec,
>  			    enum node_stat_item idx, int val)
>  {
> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	struct mem_cgroup_per_node *pn;
> -	struct mem_cgroup *memcg;
> -	bool rcu_locked = false;
>  
>  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
> -	pn = memcg->nodeinfo[pgdat->node_id];
> -
> -	__mod_memcg_lruvec_state(pn, idx, val);
> -
> -	get_non_dying_memcg_end(rcu_locked);
> +	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
>  }
>  
>  /**
> @@ -1058,19 +1055,13 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
>  {
>  	struct mem_cgroup *memcg;
>  	pg_data_t *pgdat = folio_pgdat(folio);
> -	struct lruvec *lruvec;
> +
> +	mod_node_page_state(pgdat, idx, val);
>  
>  	rcu_read_lock();
>  	memcg = folio_memcg(folio);
> -	/* Untracked pages have no memcg, no lruvec. Update only the node */
> -	if (!memcg) {
> -		rcu_read_unlock();
> -		mod_node_page_state(pgdat, idx, val);
> -		return;
> -	}
> -
> -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	mod_lruvec_state(lruvec, idx, val);
> +	if (memcg)
> +		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
>  	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(lruvec_stat_mod_folio);
> @@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>  {
>  	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
>  	struct mem_cgroup *memcg;
> -	struct lruvec *lruvec;
> +
> +	mod_node_page_state(pgdat, idx, val);
>  
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_virt(p);
>  
>  	/*
> -	 * Untracked pages have no memcg, no lruvec. Update only the
> -	 * node. If we reparent the slab objects to the root memcg,
> -	 * when we free the slab object, we need to update the per-memcg
> -	 * vmstats to keep it correct for the root memcg.
> +	 * If we reparent the slab objects to the root memcg, when we free the
> +	 * slab object, we need to update the per-memcg vmstats to keep it
> +	 * correct for the root memcg.
>  	 */
> -	if (!memcg) {
> -		mod_node_page_state(pgdat, idx, val);
> -	} else {
> -		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -		mod_lruvec_state(lruvec, idx, val);
> -	}
> +	if (memcg)
> +		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
>  	rcu_read_unlock();
>  }
>  
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4FE367288;
	Tue, 22 Sep 2026 04:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050516; cv=none; b=buw0EWkyHZbEcfgVIxZ7J1DGlBJbw6fP5MyV2jTLJTM4kqR0xahINScYrQv5Zuy71YC0oGCO0bCNR+1DnXxYEOpFVn4ER2R1M1hKayT6GxDWwKApx3HEVdrm1i64LYkmlfbW2rt2TrJxSDpobSurwUWqocpoE9a8pIOm/uMhWKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050516; c=relaxed/simple;
	bh=CDH8UUJGYKODIwt/rWpK9MSR27oVUm5OyuFz3Cu6gfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XqOvqyG91aM0vHe034pVtNp+XGxYiY2PN7BFY4O0xS9NrvD3p6St1cjTnZFlaprQYc+5s+xr1McJk7t/gaIvOU85m0FKPG+Htr6KKVRAv3SGUcuooI12piYTYgZfFISVjU78DTbj3XU7iS5B2jUUY3k2zHDkSvZHJXRKzeSuNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8eoeLIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8eoeLIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F9E1F000FF;
	Tue, 22 Sep 2026 04:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050514;
	bh=boh3TVrKyNvSdhPdrQfdvLGE6AQK3mRxCRvL6MrRYaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i8eoeLIGAfbZtTuppPHSK/pR3V8fYKPII9qU9LQ73EHTxe+bJ3wsJiC7+pD826Fv7
	 KoXLXq2C2d9edwocjsW3Ao7IDHyA5M+hnYcP316WYhXo4J6k7lSiaUwoB+8w66GiJO
	 TgAW/JX+OS7V+t6z7XPbLPwMGMl4Zn1L6UO7+CNfK+hbliGUy0MvHLXHkZaTCi0jcy
	 JOlsXR7utH6TZySSNW6rlqdw5UYUJaww8GuVqHoYtK8rO5fnT4OItM4wnMOMvtZHU6
	 iEWyX+e0fDeadgCStA+8+yiHanUOn2ttxg1u/DpKp9VmtoqJ5IsQUNQc501Ow1EoEx
	 M1xQr6mz0ENig==
Date: Tue, 22 Sep 2026 06:15:07 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
Message-ID: <arIAyyjYcCKHFmyD@localhost.localdomain>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>

On Mon, Sep 21, 2026 at 05:12:35PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
> 
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
> 
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

For the fix itself:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

question below:

> ---
>  mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1460cba53588..9c96ebd5436f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  	rcu_read_unlock();
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> +				     struct folio *old, struct folio *new)
> +{
> +	long nr_pages = folio_nr_pages(old);
> +	struct mem_cgroup *memcg;
> +	int old_nid = folio_nid(old);
> +	int new_nid = folio_nid(new);
> +
> +	if (old_nid == new_nid)
> +		return;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
> +			       NR_HUGETLB, -nr_pages);
> +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
> +			       NR_HUGETLB, nr_pages);
> +	rcu_read_unlock();

Why do we need the whole thing to be embraced by rcu?

 

-- 
Oscar Salvador
SUSE Labs

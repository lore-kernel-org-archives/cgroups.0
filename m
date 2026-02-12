Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E3433F37E
	for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770908894; cv=none; b=NDdV3BjgVaprkqtt28CLKPxqnT+u1lmHDaZ2oETV4IYjLHaRE2wKT8XB4aPuopvPX3FIHUiPFK1/D4wPunyZLYNzE4Qnx5XwWEvtZ7ZjjSGt0QfCOVKCb9pf62GPIFsqVB2+oMWE5f2RF8Y1P14v5D8L4lkZDrIdDSAWDbIMtjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770908894; c=relaxed/simple;
	bh=lyIVO3YKLzbGPMRXk1WLVlcKUIa84nvT5ivVOEzzV9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ty8gnYVksQiJ0RIDVDZZXNDHcbT0yzW0u1GwMeetVojG/7z/L/T5TgQe/YsMxO7C0FmVs2APAjiHFPSZEJRZP7ORvvvR8B9TKPWVVZHcwMlwvl9p8gXGy8PCUp75AS4k6XN81fKetrv/N5Pj2qRcAl7HqciK6SdZh5KkFpnE0Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XxaWGlEC; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XxaWGlEC"
Date: Thu, 12 Feb 2026 07:07:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770908880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwOfzTHo9+0udcjtzr/t6KDnWYj44fvh58Cy5u0CarI=;
	b=XxaWGlECBN4a610iIpj/hxVRt0G79D1N7svcZQZiL0dTP19ojT1qgU0qS98Wddx7J0SXc8
	IGi/YSGTIcDrI2HQgoyDrN67COuIc51tksr8vGdaB9ljvXyEwlm2cL8dA9cKXH18EO/RSu
	EBGdEiAwXGwlIFEFzkdNeio4AIT4vyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org, 
	eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org, 
	joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com, mhocko@suse.com, 
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, vbabka@suse.cz, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aY3r75eewxbArKVu@linux.dev>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212045109.255391-2-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 11, 2026 at 08:51:08PM -0800, JP Kobryn wrote:
> It would be useful to see a breakdown of allocations to understand which
> NUMA policies are driving them. For example, when investigating memory
> pressure, having policy-specific counts could show that allocations were
> bound to the affected node (via MPOL_BIND).
> 
> Add per-policy page allocation counters as new node stat items. These
> counters can provide correlation between a mempolicy and pressure on a
> given node.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>

[...]

>  int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
>  {
>  	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
> @@ -2446,8 +2461,14 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  
>  	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
>  
> -	if (pol->mode == MPOL_PREFERRED_MANY)
> -		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +	if (pol->mode == MPOL_PREFERRED_MANY) {
> +		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +		if (page)
> +			__mod_node_page_state(page_pgdat(page),
> +					mpol_node_stat(MPOL_PREFERRED_MANY), 1 << order);

Here and two places below, please use mod_node_page_state() instead of
__mod_node_page_state() as __foo() requires preempt disable or if the
given stat can be updated in IRQ, then IRQ disable. This code path does
not do either of that.

> +
> +		return page;
> +	}
>  
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    /* filter "hugepage" allocation, unless from alloc_pages() */
> @@ -2472,6 +2493,9 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  			page = __alloc_frozen_pages_noprof(
>  				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
>  				nid, NULL);
> +			if (page)
> +				__mod_node_page_state(page_pgdat(page),
> +						mpol_node_stat(pol->mode), 1 << order);
>  			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>  				return page;
>  			/*
> @@ -2484,6 +2508,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  	}
>  
>  	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
> +	if (page)
> +		__mod_node_page_state(page_pgdat(page), mpol_node_stat(pol->mode), 1 << order);
>  

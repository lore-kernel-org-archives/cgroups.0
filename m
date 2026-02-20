Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570392FF153
	for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 22:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771625386; cv=none; b=chhdmg7n2EfnU/c2XcJ77n6ZF0KS2xZgGjR1yngdTvzRiYsarvYrHCPS+bTF2n+X6CVdpKRcfuKkmA2USKV2Hjo0suzESPAmPewfZav0OXanUMwS2w3fA4yABBBrvV+UMa4KzjNsTJ2R/0oy1PBYAu8I9PdtJWS1x1jNoOmjVR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771625386; c=relaxed/simple;
	bh=S+0Y6DfpwFix6vlxsNRVx7ARwV3j9KnXOSbZXeyKeBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4ozZTznX22bmQ+guGILRGRFrjMaqlHSjP7aLYkEpGAjhYbt9VYABIUrYoIR5qK8x4EA+ch2uONH/7JmSa9TeZEweTbstJQd18d/rdB5oJ/hBPVBeJbZZk1GCbnX+RJvIdr3v8FdNtuMwRWznBmUxwOy1ATNyfw64kMmwr0jKn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GTyA4VOW; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GTyA4VOW"
Date: Fri, 20 Feb 2026 14:09:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771625373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bMcpQEUmQPBfSHE/XsFFGAO79A7tRmTzeXgyD6t0vqU=;
	b=GTyA4VOWkcp/D3+UgQRVXcg0nUbDJZuVwMWrhkq8xt2zoFpEYEYArzx40OrtD3f+yFGrSu
	q/skB1MhRSv5lfsszeTX172W2sdttYgXZoh6DGEM6hqJMHhzotH2TexkLuio74cY71uc32
	ctHmYlWTLWgvZsdzpTgRLwORojKBBLo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZjaxAi-AzyOYzNT@linux.dev>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220191035.3703800-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 20, 2026 at 02:10:34PM -0500, Johannes Weiner wrote:
[...]
>  static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
>  {
>  	struct rb_node *n = root->rb_node;
> @@ -3463,11 +3457,11 @@ void vfree(const void *addr)
>  		 * High-order allocs for huge vmallocs are split, so
>  		 * can be freed as an array of order-0 allocations
>  		 */
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			dec_node_page_state(page, NR_VMALLOC);
>  		__free_page(page);
>  		cond_resched();
>  	}
> -	if (!(vm->flags & VM_MAP_PUT_PAGES))
> -		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> @@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  			continue;
>  		}
>  
> +		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);

mod_node_page_state() takes 'struct pglist_data *pgdat', you need to use
page_pgdat(page) as first param.

> +
>  		split_page(page, large_order);
>  		for (i = 0; i < (1U << large_order); i++)
>  			pages[nr_allocated + i] = page + i;
> @@ -3675,6 +3671,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	if (!order) {
>  		while (nr_allocated < nr_pages) {
>  			unsigned int nr, nr_pages_request;
> +			int i;
>  
>  			/*
>  			 * A maximum allowed request is hard-coded and is 100
> @@ -3698,6 +3695,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							nr_pages_request,
>  							pages + nr_allocated);
>  
> +			for (i = nr_allocated; i < nr_allocated + nr; i++)
> +				inc_node_page_state(pages[i], NR_VMALLOC);
> +
>  			nr_allocated += nr;
>  
>  			/*
> @@ -3722,6 +3722,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		if (unlikely(!page))
>  			break;
>  
> +		mod_node_page_state(page, NR_VMALLOC, 1 << order);

Same here.

With above fixes, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

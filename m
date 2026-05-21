Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72495356772;
	Thu, 21 May 2026 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779383813; cv=none; b=mJ3B2RDPD8iDyapMKM5IM3kP5d3nlCSvNqFzyTW1zW8IkWKtA/VhSrCLHzdoQXzswx/XSTuv8ZZ1z5+vyN4J26Ov9wsy1vEaWxp5Q4vvOtoLd8BhjU3OpYIPq+9RSUfE4k51Gsgr8rTRvw5qoLlWA88q7JN9bcaBeyRhcTnPtm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779383813; c=relaxed/simple;
	bh=MhT4xIROXekYNevTxt0aQWZRsttVHqAq+qDgJCLgKbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il+YbBB78jE+AC3SeZxllMWdsXmJ24E9ilGI75zTXJYipzhRoadCDUL5vA5L5XoZEkb4/MGcSjFYUd2MMlAcoOy2HNp/l0JmMS0pOmgdc7Y/FMxoexP4FdBvME+YJW6oXyiuixhriTpFgKmAr5FwZu9ecszNVM7YO+hYzO/F+Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ub0Ujck9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ub0Ujck9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZvUjhf1UU/IohtHymqimCuPKGDaSQBsrsNMlIA60drc=; b=ub0Ujck9hnxGESg0BOKgJ4xVXT
	L1UOhZJowMMFbByRnTcfSo15BTAqDPdk7zOqWTaGvE2CGQ5Ta2NxXuUtaxhH//STzNDdmUpM3ZaRI
	ajidiw6tUhsGiUqNgzIUVmcMXShVld5lLotoOnRZE09/J9Uqf/mwUfTebkDlnHGMEzxS9KZAXdo9H
	ygdQibwbGeghHNYLcVwoyghEFmClmSbNCbvmtDSlNrPizo0ojNQEZ8vY3P4KrCRZSuyb4G6AJSj7P
	QyCTnCURVpxfSG3jlDxuHMfuQuZLKPnJDtWH/qd8Ep5QdJwmj0MeWrHwiDN9VICp68T21wvOHUCKF
	mTppm22w==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ70o-00000008bi0-02sn;
	Thu, 21 May 2026 17:16:46 +0000
Date: Thu, 21 May 2026 13:16:43 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/8] mm: list_lru: deduplicate unlock_list_lru()
Message-ID: <x6zjeg2tlnuz22ofpvlpmnskiw3gnkhkghomfgdasfajwwye55@pbz76jdh2tru>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-3-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-3-hannes@cmpxchg.org>

On 26/05/21 11:02AM, Johannes Weiner wrote:
> The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
> same pattern when bailing. Consolidate into a common implementation.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  mm/list_lru.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d3619961a7ac..9a68177619bf 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -15,6 +15,14 @@
>  #include "slab.h"
>  #include "internal.h"
>  
> +static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> +{
> +	if (irq_off)
> +		spin_unlock_irq(&l->lock);
> +	else
> +		spin_unlock(&l->lock);
> +}
> +
>  #ifdef CONFIG_MEMCG
>  static LIST_HEAD(memcg_list_lrus);
>  static DEFINE_MUTEX(list_lrus_mutex);
> @@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
>  	else
>  		spin_lock(&l->lock);
>  	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
> -		if (irq)
> -			spin_unlock_irq(&l->lock);
> -		else
> -			spin_unlock(&l->lock);
> +		unlock_list_lru(l, irq);
>  		return false;
>  	}
>  	return true;
> @@ -101,14 +106,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	memcg = parent_mem_cgroup(memcg);
>  	goto again;
>  }
> -
> -static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> -{
> -	if (irq_off)
> -		spin_unlock_irq(&l->lock);
> -	else
> -		spin_unlock(&l->lock);
> -}
>  #else
>  static void list_lru_register(struct list_lru *lru)
>  {
> @@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  
>  	return l;
>  }
> -
> -static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> -{
> -	if (irq_off)
> -		spin_unlock_irq(&l->lock);
> -	else
> -		spin_unlock(&l->lock);
> -}
>  #endif /* CONFIG_MEMCG */
>  
>  /* The caller must ensure the memcg lifetime. */
> -- 
> 2.54.0
> 

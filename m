Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0654CDF59
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 01:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622509; cv=none; b=h8+r/a2AkvC+X3BBDuHNd8c0ZyHFhwMJUbI0Dm94PtYbiowtwovWEEhTnrRDaqsQT3LYo+Yd6el28FCkM5y3bTObsd/Amq88/Yssc/BNOd1d4r71oLuXobQvdoEbni4QFGjfn1xoCe8ipFW/SN0zHlQzlnKZnug1cTy0v6+mlPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622509; c=relaxed/simple;
	bh=prN5H8SaiZTV7pApteisCiLH+mKhQksL1qSnd7wzZjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vg1iRb+SvZTbRVGjGCN0luPxSz5bc610Ys2fEnCo2IFeD8x9BOoqBsIguQMdlWf6BE3Ej/AE6wTd2IbzOt6aLa4OhKxKMT1F33hSwqEIkmC5nPLSAZ2TmKJBYG8SfRRxgQGNLl2KdeK5BXYu6jtbBRy5+x7UyGql51H/R79hgTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jOEuyHVq; arc=none smtp.client-ip=91.218.175.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jOEuyHVq"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=prN5H8SaiZTV7pApteisCiLH+mKhQksL1qSnd7wzZjo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787622503; v=1; x=1788227303;
 b=jOEuyHVq7k3pykS/uKauSLbdnVgQU/BENKUapkq/zZmLrauZ4h5PmGfeuZxG/CuLLZ08YQIh
 AL1QZlCoGmht/9oR8nyisW6IwsXKFJvuDzW+kCYHZc/FUro2Cg5IaqJ+0TCKu0FSKtGoi15IdSq
 862PkzHbDVw97hdEQq8qS4As=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id a2e5a6a88a84bda4;
	Tue, 25 Aug 2026 01:48:13 +0000
X-Mizu-Trace-ID: a2e5a6a88a84bda4
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 09:48:07 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v2 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <aoz0Q-PARiEKF8_H@fedora>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
 <20260824-mglru-flags-cleanup-v2-1-0104132114ae@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-mglru-flags-cleanup-v2-1-0104132114ae@tencent.com>

On 08/24/26 at 11:26pm, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which was
> more of a workaround for another bug: lru_zone_size is unsigned, so
> underflow wraps it around and returns an enormously large number, then
> the memcg shrinker loops almost forever as the calculated number of
> folios to shrink is huge. That commit also checked if a zero value
> matches the empty LRU list, so we have to hold the LRU lock, and
> handle the positive and negative deltas separately.
> 
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> for lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, so handling the deltas separately is no longer
> needed. And if we just turn it into an atomic long, underflow isn't a
> big issue either, and can be checked at the reader side, which is
> called much less frequently than the updater.
> 
> So let's turn the counter into an atomic long and check at the reader
> side instead, which has a smaller overhead. The underflow correction
> is removed: a massive leak of the LRU size counter would indicate
> that something else has gone very wrong, and one should fix that
> leaking site instead. Besides, the updater-side sanity check is
> unlikely to catch the leaking site anyway: if a folio was removed
> without updating the counter while other folios remain on the LRU,
> the WARN only triggers much later, from a likely innocent callsite.
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h |  9 +++++++--
>  mm/memcontrol.c            | 18 +-----------------
>  2 files changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 215e2e87f42b..7b89d0cb5f6c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
>  	/* Fields which get updated often at the end. */
>  	struct lruvec		lruvec;
>  	CACHELINE_PADDING(_pad2_);
> -	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> +	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>  	struct mem_cgroup_reclaim_iter	iter;
>  
>  	/*
> @@ -902,10 +902,15 @@ static inline
>  unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
>  		enum lru_list lru, int zone_idx)
>  {
> +	long val;
>  	struct mem_cgroup_per_node *mz;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
> +	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
> +	if (WARN_ON_ONCE(val < 0))
> +		return 0;
> +
> +	return val;
>  }
>  
>  void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11b85f4b6828..a7572ded56c9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  				int zid, long nr_pages)
>  {
>  	struct mem_cgroup_per_node *mz;
> -	unsigned long *lru_size;
> -	long size;
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	lru_size = &mz->lru_zone_size[zid][lru];
> -
> -	if (nr_pages < 0)
> -		*lru_size += nr_pages;
> -
> -	size = *lru_size;
> -	if (WARN_ONCE(size < 0,
> -		"%s(%p, %d, %ld): lru_size %ld\n",
> -		__func__, lruvec, lru, nr_pages, size)) {
> -		VM_BUG_ON(1);
> -		*lru_size = 0;

If it happened, the resetting to 0 is removed, will it cause anything
unexpected and different behaviour? mem_cgroup_get_zone_lru_size() just
read minus value and always WARN_ON_ONCE() if no new adding to this
counter.

> -	}
> -
> -	if (nr_pages > 0)
> -		*lru_size += nr_pages;
> +	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
>  }
>  
>  /**
> 
> -- 
> 2.55.0
> 
> 

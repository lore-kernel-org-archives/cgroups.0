Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF2D2E888A
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 02:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787105119; cv=none; b=q0HF4W6U/8nA0q3ZES6bcDmDpZMkKtKXQNsbDF2pAgcWOkCaFa73/ziZ5FLfwvbmUu28A3wzfaxCjk9H5FdmY/AY3R6Dtf2vAhGbmS62jXLG7SLV8tqdUfAnxwNhBFEdAX/1Igmm4yP6Xib6M1oBmHXw1RQ075PdqCa37U3uIe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787105119; c=relaxed/simple;
	bh=22tSUCGFrD68K1lRH+RPcG9Hyj3wJxpH/fb0Ypvsvz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqtPDCnPhIVnIkCEbWjLTqVNkWUcwIDZBEMn5RMdo8GKQ17MBBO2W+gxeMuQk2MS5q6I65kJgCdAJpc8qTwRgrS1mUctoEErF8renInvt1MqEbKs2Q7NF+HLdxh/JRhA3+5wuN9GTlcgqighlI3+CSHSbb4V23MpH/zLpYhfSgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xLFujGOX; arc=none smtp.client-ip=95.215.58.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xLFujGOX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=22tSUCGFrD68K1lRH+RPcG9Hyj3wJxpH/fb0Ypvsvz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787105114; v=1; x=1787709914;
 b=xLFujGOXICQk37IC4fJ7m0O5ky9LFXhV0/Lrhy8rntsZuUmtQH9B4IniEWFc9IPnYc76blFP
 lbdOwBmzp4bfvTkmhxXuuPa0LWO/7G0a8PKh+Pdo20joRr1fUm4DcNd9i75En+7zbk6XOS5vu6i
 3rF9VE5xJCGdD1vxg9qNSYTo=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 6217c15f338751e5;
	Wed, 19 Aug 2026 02:05:14 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa2507d8-8476-4090-b4a9-1cbd7225009b@linux.dev>
Date: Wed, 19 Aug 2026 10:05:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-1-8dbbdac0d28c@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-1-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
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
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/memcontrol.h |  9 +++++++--
>   mm/memcontrol.c            | 18 +-----------------
>   2 files changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229..b13e3f056319 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
>   	/* Fields which get updated often at the end. */
>   	struct lruvec		lruvec;
>   	CACHELINE_PADDING(_pad2_);
> -	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> +	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>   	struct mem_cgroup_reclaim_iter	iter;
>   
>   	/*
> @@ -897,10 +897,15 @@ static inline
>   unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
>   		enum lru_list lru, int zone_idx)
>   {
> +	long val;
>   	struct mem_cgroup_per_node *mz;
>   
>   	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
> +	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
> +	if (WARN_ON_ONCE(val < 0))
> +		return 0;
> +
> +	return val;
>   }
>   
>   void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d3339520809..9d0ee3d3bda7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>   				int zid, long nr_pages)
>   {
>   	struct mem_cgroup_per_node *mz;
> -	unsigned long *lru_size;
> -	long size;
>   
>   	if (mem_cgroup_disabled())
>   		return;
>   
>   	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
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
> -	}
> -

This code is confusing, I used to try to remove it.

Well done.


> -	if (nr_pages > 0)
> -		*lru_size += nr_pages;
> +	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
>   }
>   
>   /**
> 

Looks good to me.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
-- 
Best regards
Ridong


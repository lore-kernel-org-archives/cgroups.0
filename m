Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C9537BE78
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 01:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787794646; cv=none; b=HFuM1Vx/RacKiQtxRh2I2S2dAuuWNVrRQjcbGvTi95pFcA8kePLf9a3zfd6EqvwEQnyFJq66uXwjHN1kmJ0kblWd1xg7erigPGamNRm3fFw+G1dfxyUDYMYXuSi0vKpY4FR+6N2E/lDqLDDgxQbfe7CEcAjP11lm2J2Y/v0jomw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787794646; c=relaxed/simple;
	bh=htyAKBUKag4BkmqelGoVlxjJ7s9eT/i2PDyfgKhi+pQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQ8B6LDGZ7CsBSnBqd+hx9SdM/AbgoM1Rar9oRFHrbqgeUPlF3sAQzi+fUq9C5X/PTLOqUPWB1BPfD55r9fyoaPKN26of7NLHLh5wmNMqOX7KGhV9mFi+tZomXb3Er5+yJ4FVLGNPT1gsaCzWPlIWbnAZGwFrNkIK4+89XPFZ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=utTf4NcU; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="utTf4NcU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=htyAKBUKag4BkmqelGoVlxjJ7s9eT/i2PDyfgKhi+pQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787794641; v=1; x=1788399441;
 b=utTf4NcU4n4TAvT83CXkJlQuWI5F9l6oAwfGYXPaHINyrIH/Dv9j91QVa6tPrjNMJsgSzrVM
 oA7331wY/Z/ZOOCr+e+LdDsf9BveJqQUKuokTVX3RQHi/SyJWXio1XQ0pHcLLcIea8PI53GlPw0
 c6utCRWxj5NUf4p8C7tf2zmM=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 00f404dab48392af;
	Thu, 27 Aug 2026 01:37:21 +0000
X-Mizu-Trace-ID: 00f404dab48392af
X-Migadu-Flow: FLOW_OUT
Message-ID: <49c19d73-beca-473f-96b9-23ff8ee9d445@linux.dev>
Date: Thu, 27 Aug 2026 09:37:11 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand
 <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260826133054.88529-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826133054.88529-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/26/2026 9:30 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> memory.min/low is silently bypassed for MGLRU during global proactive
> reclaim (writing to the root memory.reclaim) and global direct reclaim.
> It can be reproduced as follows:
> 
>    # echo 7 > /sys/kernel/mm/lru_gen/enabled
>    # cd /sys/fs/cgroup
>    # mkdir -p a/b
>    # echo 100M > a/memory.min
>    # echo +memory > a/cgroup.subtree_control
>    # echo 100M > a/b/memory.min
>    # echo $$ > a/b/cgroup.procs
>    # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>    # cat a/b/memory.current
>    222650368
>    # echo 500M > memory.reclaim
>    -bash: echo: write error: Resource temporarily unavailable
>    # cat a/b/memory.current
>    6070272
> 
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection.  The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
> 
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow remain stale or zero.
> 
> Introduce mem_cgroup_protection_path() which computes emin/elow along
> the root-to-target path only by iterating through the cgroup ancestors
> array top-down.  This avoids the full tree traversal that would be
> needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.
> 

Hi all,

This is an RFC patch.

My initial attempt to address this issue involved traversing the entire memcg 
tree, similar to what kswapd does. However, Sashiko raised concerns that this 
could introduce performance regressions [1].

To address that, this patch instead walks the cgroup ancestors array in a 
top-down manner, as outlined above, and I'd like to gather feedback on this 
approach.

[1] https://lore.kernel.org/linux-mm/20260723130559.2343690-1-ridong.chen@linux.dev/

> Call it from shrink_one() for the non-kswapd path so that each memcg
> about to be shrunk has correct protection values.
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   include/linux/memcontrol.h |  7 +++++++
>   mm/memcontrol.c            | 42 ++++++++++++++++++++++++++++++++++++++
>   mm/vmscan.c                |  8 +++++++-
>   3 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a8..26be8277d64b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -605,6 +605,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
>   
>   void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   				     struct mem_cgroup *memcg);
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +				struct mem_cgroup *memcg);
>   
>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>   					  struct mem_cgroup *memcg)
> @@ -1133,6 +1135,11 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   {
>   }
>   
> +static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
> +					      struct mem_cgroup *memcg)
> +{
> +}
> +
>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>   					  struct mem_cgroup *memcg)
>   {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..c739db33b917 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5198,6 +5198,48 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>   }
>   
> +/**
> + * mem_cgroup_protection_path - compute protection along root->memcg path
> + * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
> + * @memcg: the target memory cgroup
> + *
> + * Walk the ancestor path from @root down to @memcg and compute the effective
> + * protection at each level.  This is safe for isolated queries because it
> + * ensures parents are computed before children.
> + */
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +				struct mem_cgroup *memcg)
> +{
> +	bool recursive_protection =
> +		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
> +	struct cgroup *cg;
> +	int root_level, i;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	if (!root)
> +		root = root_mem_cgroup;
> +
> +	if (memcg == root)
> +		return;
> +
> +	root_level = root->css.cgroup->level;
> +	cg = memcg->css.cgroup;
> +
> +	rcu_read_lock();
> +	for (i = root_level + 1; i <= cg->level; i++) {
> +		struct mem_cgroup *cur;
> +
> +		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
> +						    &memory_cgrp_subsys));
> +		if (cur)
> +			page_counter_calculate_protection(&root->memory,
> +					&cur->memory, recursive_protection);
> +	}
> +	rcu_read_unlock();
> +}
> +
>   static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>   			gfp_t gfp)
>   {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6dff207ad8c6..e572d2742c8c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5102,7 +5102,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
> -	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
> +	/*
> +	 * For kswapd, lru_gen_age_node() has already called
> +	 * mem_cgroup_calculate_protection()
> +	 */
> +	if (!current_is_kswapd())
> +		mem_cgroup_protection_path(NULL, memcg);
> +
>   	if (mem_cgroup_below_min(NULL, memcg))
>   		return MEMCG_LRU_YOUNG;
>   

-- 
Best regards
Ridong


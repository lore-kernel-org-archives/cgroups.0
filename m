Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795334039;
	b=3jj1xGHb+6WlJCqmYQQxxVF/8aitymY6JOyaorDzIziCTmhQCDCKhS8iawyFBPd/GG4y
	 wPOHL7McGc6wifGzYVd46BjjjRzgN+2hx8jXPCNXeabS2UinNZCPvRdOBfBE+44TJVvd0
	 uV5bzFhr0sSeQW5kUI3Govu9IZ5s0XjBmuLRs5iyjQgw1N+tD9HzCHc2IFfEwcnqpITcX
	 ByMrBTg59zjQY2mqF2/PUWKn0vU3KMTZKC2OpOp/cDuccThxXVAor3EiaJ0MuxazztAkq
	 6H7hyNQcrWEjH5TZQnRXl0691diER66xeKehY39QR7OeHEScyGOPfAAgz03BVnNz82g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795334039;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=mOcmoHBzKwzqRhuvzie4cVIDXlVg/sxRWH6argNn2FA=;
	b=BxaZ0RF8go9gPgKGwJGQO9lUezwLHr3Gz+NmC6rr2hkla4/ymN2OzT7Iuixt419BOunQ
	 sVhTDgfnb+CjNSzFakIZLC8eL39KpiS8cpwHwvRxG7l8haIe1/HNBT7mVukN63Pvwr0WO
	 qz8iXX17DGSoIdq7fhN/oYGzoZqI1xBTURnY3fXeoMcyi2MuVtVvSaqYVJsUuhF2j++dy
	 ufSmY//PRQUmy5CYSYZJDDSkzGlsYz5YbkMWfa9Yoq5KqasSYJnsYKWIS6xLxXUxyhmvj
	 rxv2/sVucQJJ/zN89qmEWGhcpCgyHtrenp7WJzC6ftwIaJZgcd7KQzcjyQaebRi5UYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LHuP4vQ0;
	arc=none smtp.remote-ip=95.215.58.52
Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC1B606A32A
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 07:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FC1B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LHuP4vQ0
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zkTOqn+rNjlOfmFIyhoF6rAk683YaTwi6c+aGGYoa60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795334036; v=1; x=1795938836;
 b=LHuP4vQ0LbfH0TkiIc7OPnMdIxBu3k1zCmUWVwzAtOnjVmf0a7rwmnpud7efP4ws1s4i4kHF
 1hxO0Ln+Tqt7z1JUMNar2v1E2mG9HikoNFNE88J416rT3vWkwiJ2+7S1dIDKNCSy/sr0MuM4ANQ
 MzPpOjU+kVGOeQw/LXMgJJJo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 862c2fb0d81c39f5;
	Sun, 22 Nov 2026 07:53:56 +0000
X-Mizu-Trace-ID: 862c2fb0d81c39f5
X-Migadu-Flow: FLOW_OUT
Message-ID: <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
Date: Sun, 22 Nov 2026 15:53:44 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
To: kasong@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
 Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/11/19 05:03, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Add a helper that resolves a live lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.  The first user is
> the lockless folio_inc_lru_refs() path later in the series.
>
> Factor the ancestor walk out of lruvec_live_lock_irq() into
> __lruvec_get_live(), so that both entry points share it, and spell
> out why the walk is enough while only the RCU read lock is held:
> reparenting of a memcg that starts dying waits for a grace period,
> so it cannot race with the caller until the lock is released.
>
> Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> predicates, and use it for the walk rather than repeating the open coded
> css_is_dying() test a few definitions away from where it is explained.
>
> No functional change for existing callers.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Some nits bellow:

> ---
>   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..441a5d57e723 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>   }
>   
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)

Let's make it const for @memcg along the way.

> +{
> +	return memcg ? css_is_dying(&memcg->css) : false;
> +}
> +
>   static inline void mem_cgroup_protection(const struct mem_cgroup *root,
>   					 const struct mem_cgroup *memcg,
>   					 unsigned long *min,
> @@ -1349,6 +1354,11 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>   	return true;
>   }
>   
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +	return false;
> +}
> +
>   static inline
>   unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
>   		enum lru_list lru, int zone_idx)
> @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
>   	spin_lock_irq(&lruvec->lru_lock);
>   }
>   
> -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +/*
> + * Reparenting moves a dying memcg's LRU state to its parent at any time,
> + * so anything added to that LRU afterwards would be lost.  This helper
> + * walks up to the nearest live ancestor while the caller must hold the
> + * RCU read lock: reparenting of a memcg that starts dying waits for a
> + * grace period, so it cannot race with the caller until the lock is
> + * released.
> + */
> +static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)

Cound @lruvec be const as well?

>   {
>   #ifdef CONFIG_MEMCG
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
> -	rcu_read_lock();
> -
>   	/*
>   	 * The memcg can be NULL when the memory controller is disabled.
>   	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
>   	 */
> -	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +	while (unlikely(memcg_is_dying(memcg))) {
>   		memcg = parent_mem_cgroup(memcg);
>   		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>   	}
> +#endif
> +	return lruvec;
> +}
>   
> +static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_lock();
> +	lruvec = __lruvec_get_live(lruvec);
>   	spin_lock_irq(&lruvec->lru_lock);
>   #else
>   	lruvec_lock_irq(lruvec);
>   #endif
> -
>   	return lruvec;
>   }
>   
> @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const struct folio *folio,
>   	       lruvec_memcg(lruvec) == folio_memcg(folio);
>   }
>   
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Same as folio_lruvec(), except that a folio whose memcg is dying is
> + * accounted to the nearest live ancestor, which is where reparenting
> + * would put it anyway.
> + *
> + * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
> + * folio_lruvec_live_put().
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)

const folio?

> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_lock();
> +	return __lruvec_get_live(folio_lruvec(folio));
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)

Ditto.

Thanks,
Muchun

> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_unlock();
> +#endif
> +}
> +
>   /* Don't lock again iff page's lruvec locked */
>   static inline struct lruvec *folio_lruvec_relock_irq(const struct folio *folio,
>   		struct lruvec *locked_lruvec)
> @@ -1826,11 +1877,6 @@ void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
>   
>   void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>   
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -	return memcg ? css_is_dying(&memcg->css) : false;
> -}
> -
>   #else
>   static inline bool mem_cgroup_kmem_disabled(void)
>   {
> @@ -1901,11 +1947,6 @@ static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
>   static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
>   {
>   }
> -
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -	return false;
> -}
>   #endif /* CONFIG_MEMCG */
>   
>   #if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
>


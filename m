Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795679884;
	b=A5e3BTu+LF0ediDwrTw4lLTFAklM8nArpAqXKuSBg4C6nn0yJlXYych39nSxieGhyGRB
	 WUYikJKL+C28fdZA9TKZi+LRDZ+JPFLP5KYvxvOXVoclwyep4Hgt438SMoesKU4lEFNi6
	 y0vWDd3QpbaDM/vK5lWFgbVisFswQ7MLJQoCPj0rULhJc5ADr4gOxAa5A36CieVNJfBDA
	 LTIOa1r0A/4q/bO9a7+s58t+XpnS7IHTRhtGtZGXiyhXZtsMWMwLxwpbtHA2e7DQy/zbK
	 cw/P0MW545Ng2QGeJFiLZ7rQECisgyTnlnoaTEvjCAlrLohBM5qX78ZmiimqByu40Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795679884;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LvwFbBDWNBefR0kvXHQjNB1xk2tLuKkLL0ZTvCS0RKo=;
	b=GoCq5Gw4i5BaYaOTvsGieIBWuig6OH6E4i9DC9MhY6mBds7VOKoBlRcZRrf/HfskxYK9
	 qbC4UFi/xaMT+pCmEzQIUMG2kQjxRHQYv6XQRa7Zh963hhGlj1Jgjl3B+rvqLuESxTAog
	 assGIYLwHMWCFOgmQ74OdXmXIYmWZQj2tI06Pqn9VxN6MJ30Ma+XEX7U91pEE/E0NOWxg
	 Q/K8TBV68wE6TKvgVfxyRE9FViLjCkdeVD7A9+akVPApOoBTCJ7VaqO7WxH3ZsQoPX8Wm
	 Qh27gqQN1Lh1q/bh9G95En+ekE2sKkXvJJf7BUz7HkAimCwCztgXa13dvfzif6Gcb2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o6bjUeAs;
	arc=none smtp.remote-ip=95.215.58.245
Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442B4606A330
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 07:58:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 442B4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o6bjUeAs
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FjE3HtgmKFq8WFEo5xKnHSon1s4J/tMgqoWdmhdBcjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795679882; v=1; x=1796284682;
 b=o6bjUeAscT1Lwh6QHVgwf2bJ1f75R+7XJvrz13QiJ08OF1Wvc9srPIbjDCJWT656QujjEIKP
 C45RqbYJStESB/bkq3kguAp8+hhqQh35vGPP3sYNU5Hnvdp3VEuqWvW1n0n4ZDr7tBB1bRGoaUZ
 /eWlpySvzH0QeYAOBQCoxV/w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c5246ef4abf9f853;
	Thu, 26 Nov 2026 07:58:01 +0000
X-Mizu-Trace-ID: c5246ef4abf9f853
X-Migadu-Flow: FLOW_OUT
Message-ID: <b771065b-392d-4bf6-ab63-682179f6ed1f@linux.dev>
Date: Thu, 26 Nov 2026 15:57:41 +0800
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
Subject: Re: [PATCH v6 05/18] mm/memcg: add folio-based lruvec live helper
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-5-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-5-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
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
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..a03f9711522e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>   }
>   
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
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
> +static inline struct lruvec *folio_lruvec_live_get(const struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_lock();
> +	return __lruvec_get_live(folio_lruvec(folio));
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(const struct lruvec *lruvec)
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

LGTM.
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795662689;
	b=oo3dWt7iwBsXjNCNxk3uQcIAtmsk4ruuNYwRV+WSWXuC7p+XwwWrxT35LtUmMrPKP7dp
	 EDsd189RHq5s56LWlNo9Cryg0XFpEGiSGUtsOwf2ipvtxlDOh2hLoRKNA1CE0osKcTa04
	 ghvqLvsPGyKkt8WPYz+Gh0g/nUD1X9GUijw6JuWc5EDuFote77nM/8X4Yqxfo2MyFa5W1
	 qTq3byF/mY1Zm5UAMGUtJ5cymw2BrPmpmQ10ilYRX8BgrcAQPe0HgOiU3IzPi+LU2oshO
	 23HaPseI+XaLQPhDIvhPahndOBqZbiXMhg0LRvybXfW0PK0sv1xeJmKuKlpsZyCt5Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795662689;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WYSs5d5Lp36V/22Iomfy0//nynBZd0fYykzrM/pot3A=;
	b=L345J6i45rhUDU3GA9MZ4m+YYKpJsQouKTwdqnmvCDRsiFZkwtKh7YktFRGgG8IKR1uz
	 gFv+1c2NIUvp0r3aU6JTppudrxQyXTL14Cu1BTSQPCbfg5ML9BS22llDivaJbllXkyaBc
	 /DqXpJ2pkPFHbi+xKPBdUEHWjXMX4nyknTJWCNKsWQ68zMBI+CzYZsQsLEzk18bLhaeUm
	 lOCLj7EoDLl9oRELGjImOg4YeW//H/A1QZOMvEpdeKz2h7P2PaFkwgLrJosqt4yjCe8fn
	 SZP1fjHlkgCrajDdyH295IAiKGggf1jy9hitNN30kzjRywF8aZyQMAgISWHfhsTCmww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XvQ+r2RM;
	arc=none smtp.remote-ip=91.218.175.210
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DF1606A326
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 03:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03DF1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XvQ+r2RM
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vvqUdZiid5uV0/NNKfcYRq6aGGte+Ajub0kcJ88W1xw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795662685; v=1; x=1796267485;
 b=XvQ+r2RMwGUGG5NBKscjbd1IEWuCTdDQIo98L1SjnbjCjJMgWoAL8FtytLaBy0CWLY2+jxXS
 hdTmfApQPa0Z895vccKpW6ltMPzR86wOfdNzdome4YHjY1oUi+qMCfdssS3I22jaFLPBS91D5ts
 dpF6fN1TnG+4+T5QhV2e4WU4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c118c9884fa7c50c;
	Thu, 26 Nov 2026 03:11:24 +0000
X-Mizu-Trace-ID: c118c9884fa7c50c
X-Migadu-Flow: FLOW_OUT
Message-ID: <82a7b4da-a67a-4e53-bdad-8c0551585cec@linux.dev>
Date: Thu, 26 Nov 2026 11:11:10 +0800
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
Subject: Re: [PATCH v6 04/18] mm/mglru: make generation page counters atomic
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
 <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h |  6 ++----
>   include/linux/mmzone.h    |  2 +-
>   mm/vmscan.c               | 26 +++++++++++++-------------
>   mm/vmscan.h               |  2 +-
>   4 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2edb9beef6d3..46beded51c7d 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
>   	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
>   
>   	if (old_gen >= 0)
> -		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -			   lrugen->nr_pages[old_gen][type][zone] - delta);
> +		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
>   	if (new_gen >= 0)
> -		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
> -			   lrugen->nr_pages[new_gen][type][zone] + delta);
> +		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
>   
>   	/* addition */
>   	if (old_gen < 0) {
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6a2ad0cff795..4e85bb520f76 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -554,7 +554,7 @@ struct lru_gen_folio {
>   	/* the multi-gen LRU lists, lazily sorted on eviction */
>   	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>   	/* the multi-gen LRU sizes, eventually consistent */
> -	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
> +	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>   	/* the exponential moving average of refaulted */
>   	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
>   	/* the exponential moving average of evicted+protected */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bc7579d47f9b..202e0f874b23 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
>   			continue;
>   
>   		walk->nr_pages[gen][type][zone] = 0;
> -		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
> -			   lrugen->nr_pages[gen][type][zone] + delta);
> +		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
>   
>   		if (lru_gen_is_active(lruvec, gen))
>   			lru += LRU_ACTIVE;
> @@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   				break;
>   		}
>   		flush_lru_batch(head, &batch_end, target_list);
> -
> -		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -			   lrugen->nr_pages[old_gen][type][zone] - delta);
> -		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> -			   lrugen->nr_pages[target_gen][type][zone] + delta);
> +		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
> +		atomic_long_add(delta, &lrugen->nr_pages[target_gen][type][zone]);
>   		if (!remaining)
>   			return false;
>   	}
> @@ -4093,8 +4089,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>   	for (type = 0; type < ANON_AND_FILE; type++) {
>   		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>   			enum lru_list lru = type * LRU_INACTIVE_FILE;
> -			long delta = lrugen->nr_pages[prev][type][zone] -
> -				     lrugen->nr_pages[next][type][zone];
> +			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
> +				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
>   
>   			if (!delta)
>   				continue;
> @@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>   	child_lrugen = &child_lruvec->lrugen;
>   	parent_lrugen = &parent_lruvec->lrugen;
>   
> +	/*
> +	 * The child is offline and the lockless updaters, which hold
> +	 * rcu_read_lock() over the update, avoid racing with reparenting,
> +	 * so the read/set/add operations below are safe.
> +	 */
>   	for (gen = 0; gen < MAX_NR_GENS; gen++) {
> -		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> +		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
>   		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
>   		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
>   
> @@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>   		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
>   				      &parent_lrugen->folios[gen][type][zone]);
>   
> -		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> -		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> +		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
> +		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
>   
>   		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
>   			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index c2cea36289f3..6551f0a6691a 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
>   	unsigned long size = 0;
>   
>   	for (int zone = 0; zone < max_zone; zone++)
> -		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +		size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
>   
>   	return size;
>   }
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


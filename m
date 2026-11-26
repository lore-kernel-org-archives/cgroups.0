Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795686214;
	b=hDX7RSuK859Ni8+gHr4/RY+TgPzs5d7/i4N07H0QCa8PYIg31qGaNjXJv8AcqmqNs0/o
	 6H7t6duKvzSIAZWAH+WEV7HQLj5RJ/GQvGx2wA0lgpbLHq2o+xRWCPQEUknGoQkUTfMgM
	 YLGFSvp9HHy0koUizWZng9ycFFajvK0ilrKIlVWnTRnUYQ2FiglNgn6B9QBEdCUb5SDHQ
	 O2p3jnxKVFyBIFbOulxPphHdleLbysb0jzuTROz4oUrGl79qR94kfeMjj8OXcuw1nnJYx
	 EvkDZWd4bHFLTVlh7kAFWa88hH+JqWW0eg4wIjFNUpwCgNTRYzG35qtf+6oee6/vGHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686214;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=45243M13KOvb9KniU4MCiqJ1WOWt7TIcLK3eH++OB0U=;
	b=qdgVYY/VmYHUXv6pmsJP0S3VcTUYgPdLKGyR5uLR43J6gmHDd1038+nJEizErbLqitp6
	 gduvKviJ3CzA3dAPXgIPJQivCXe1S/9ILZFxiEeJGaKUYoNM77GsgGxwAKQrSEJJNDH0r
	 MKO8Gyzxn4wEwJOj5fSy3o2Hix7FNAZOeugtHT7wJSTZW3FceRH7H5vRXO8QrrghNfOKT
	 oWgseDQ69HIDNzXpnnE7hbrOEFbyrkgl2M682jBLETiHZbmLQmp3clMdiuHju7DbglYJU
	 hLctc4am4/Jop45YsBJG5Cp/kDZYxvMKM8f0eKZ4MMD4wPQKtTS01tsIJAdhjiuzMAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=X5m1zwmm;
	arc=none smtp.remote-ip=91.218.175.240
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279F606A330
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 09:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9279F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=X5m1zwmm
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D32CMv1v+3bZYh/n5UdiiqLQfDC+3bfpicw46CnpCFQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795686211; v=1; x=1796291011;
 b=X5m1zwmmUc6pxxpJk42goqzglAFVJR222zZ/211EZRBRW6HPJiZSnrWREX/AIIWBcY2J2KTz
 mGUOV42Gknh3+Low1hXhU7rF90Ple6A06zQh7Mfkh6VUQW8uWnk55o2j+x4M9dpXl/rgbL0N3Cv
 F/Etamn1HGVnTDJBb7qfYZwo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5d6fe757d0ca69c4;
	Thu, 26 Nov 2026 09:43:30 +0000
X-Mizu-Trace-ID: 5d6fe757d0ca69c4
X-Migadu-Flow: FLOW_OUT
Message-ID: <387237c3-c2f8-4782-9ba6-481f459cf7f2@linux.dev>
Date: Thu, 26 Nov 2026 17:43:14 +0800
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
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
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
 <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2395ca8ee305..2edb9beef6d3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
>   {
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
> -	lockdep_assert_held(&lruvec->lru_lock);
>   	WARN_ON_ONCE(nr_pages != (int)nr_pages);
>   
>   	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -	__mod_zone_page_state(&pgdat->node_zones[zid],
> -				NR_ZONE_LRU_BASE + lru, nr_pages);
> +	mod_zone_page_state(&pgdat->node_zones[zid],
> +			    NR_ZONE_LRU_BASE + lru, nr_pages);
>   }
>   
>   static __always_inline void update_lru_size(struct lruvec *lruvec,
> 

Hi Kairui,

Just a heads-up: this may conflict with Joanne's "mm: move LRU size stat
updates out of lru_lock in folio batches" [1], which is in linux-next now.

That patch makes __update_lru_size() add to a batch attached to the
lruvec by the lru_lock holder, and relies on lockdep_assert_held() there.
Once this patch lets folio_inc_lru_refs()/folio_reset_lru_refs() call it
without the lock, they could write into another CPU's on-stack batch.
So the lockless paths probably need to bypass the batch.

[1] https://lore.kernel.org/20261029204157.117879-1-joannelkoong@gmail.com

-- 
Best regards
Ridong


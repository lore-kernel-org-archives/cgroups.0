Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792462502;
	b=d2haU0A+ch521aKIrrPn3Yvv+V9JAmEfssDdwXkc/E+Qper2g1dADlmyqsXzb3o1+tsD
	 z56NoidHWVvgQ1UwRxGm9SPfwbg9b0ct+dTHGHD3Ad50ibGB5Z/ZOYnL3o3OiAqenklym
	 DhjMCd8O955bn+spFdjIjGr/Gof1Qk3VvLodmz+9RJbtQt7/6ezKuzFhwS80r03Y90ZN+
	 auuM/6DbqMDNv7YVh58uf2MPZXujn+XzvXX8C/zjP/bobzZqWloA0fA6ZI1Htfw0vlmLh
	 jgkAtQ4AFMMfOHHepi7Z1JfLKhD4IqWWGE4bktrRDhbB3G71Q6E4wLRQwsr/wE7Kg0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792462502;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=H5koWBlEkzUtVRPXaV/v1U0rZzsCMMRJSatrplJvvdI=;
	b=A6uOKSerseCo8FWNKLFn3/TEUBUYDVzFPhzzf0xow66YKV8GabfFPAE63lH2gvJNCwHW
	 7i8khiSO59BGcvqAvCF0LEC8bp6jk+Ftj87E6IVCjlngBXu/mfGYD05aOupwByd/HmEzD
	 sD+ww5VpQck4cmJtrP3yX3FyWtDr09lTtYvI0wCKJ5mf8L++ieNPrg1eOIgLuteRtZr05
	 OxixA6dNyWXKczYND3KP+hrBNxWVAi8eEKHjhlRfthYlgIiVKGoenMY6/0pHN8ReegCRI
	 RX52C67/8tEm5v7mAhhS+rXfxOSpQOicU9Kf24Zki1Bue5kmbYZP+YGrk+IBC6c98oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MtTqySqA;
	arc=none smtp.remote-ip=95.215.58.13
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FC7606A31E
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 02:15:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5FC7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MtTqySqA
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RIrheAYm8hykGe22Eq3j94xLVcRIa2q6YiEDm7rvq1I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792462498; v=1; x=1793067298;
 b=MtTqySqABRAkFsDiyocbxlm1d9OrkRuNkd5LlWHji6/bhhwnZuwybc6iZbny2iJF29J8rO84
 k45ctSv0WYakcFKuJ6QKpSoB9ZaSCyoQJdjOji+otlausoKPjDUEChFLZRBH6o0srn03qBWoMlR
 d7AfDngwtMkve4uGwALBDn6U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1bfec103754fcc10;
	Tue, 20 Oct 2026 02:14:58 +0000
X-Mizu-Trace-ID: 1bfec103754fcc10
X-Migadu-Flow: FLOW_OUT
Message-ID: <f8d85b59-971d-4397-a785-b4ab4d301874@linux.dev>
Date: Tue, 20 Oct 2026 10:14:54 +0800
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
Subject: Re: [PATCH v3] mm/shrinker: allocate shrinker_info_unit from a
 dedicated kmem_cache
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/20/26 12:11 AM, Konstantin Khorenko wrote:
> shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work
> plus a one-word bitmap, 520 bytes on 64-bit. kzalloc_node() takes it
> from kmalloc-1k, so almost half of every unit is padding.
> 
> Allocate the units from a cache of their own, sized to the unit. The
> cache is not cache-line aligned: the counters of a unit already share
> cache lines between shrinkers, and aligning the unit would only keep
> neighbouring units off each other's boundary line, at the cost of part
> of the saving.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
> This is v3 of patch 1/2 of "mm/shrinker: make per-memcg shrinker units
> cheaper", sent on its own as Andrew asked in the v2 thread.
> 
> Patch 2/2 of v1-v2, "mm/shrinker: allocate the per-memcg shrinker units
> on demand", is not part of this posting. It is the change that makes a
> memcg pay only for the shrinkers it uses, and it is discussed separately
> in the v2 thread.
> 
> Tested on a 4-CPU, single-node VM with the test from the earlier cover
> letters: 8000 tmpfs mounts, then 2000 empty memory cgroups. The units
> move from kmalloc-1k to the new cache, 31 per order-2 slab, and the
> unreclaimable slab per cgroup goes from 144 KB to 87 KB. Removing the
> cgroups and dropping the caches returns the cache to its earlier size.
> 
> memory.reclaim on a cgroup still frees its objects on 140 ext4
> superblocks, and cgroups making their first objects while mounts keep
> raising shrinker_nr_max leave nothing in dmesg, also with
> slub_debug=FZPU on the cache. selftests/cgroup test_memcontrol passes.
> test_kmem_memcg_deletion also fails without the patch, by a similar
> margin.
> 
> Changes in v3:
> - Allocate the unit from a dedicated kmem_cache instead of shrinking it
>    to 63 ids so that it fits kmalloc-512 (Andrew Morton, Muchun Song).
>    New subject, since the unit keeps its size.
> - Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com
> 
> Changes in v2:
> - Patch 1: check the unit size with BUILD_BUG_ON(!is_power_of_2())
>    in shrinker_unit_alloc() instead of an open-coded static_assert()
>    in the header (Muchun Song).
> - Link to v1: https://patch.msgid.link/20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com
> ---
>   include/linux/memcontrol.h |  1 +
>   mm/memcontrol.c            |  2 ++
>   mm/shrinker.c              | 11 +++++++++--
>   3 files changed, 12 insertions(+), 2 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a88..b5a89594c263c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1675,6 +1675,7 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
>   }
>   #endif
>   
> +void shrinker_unit_cache_init(void);
>   int alloc_shrinker_info(struct mem_cgroup *memcg);
>   void free_shrinker_info(struct mem_cgroup *memcg);
>   void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586cc..7a817181168ed 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5717,6 +5717,8 @@ int __init mem_cgroup_init(void)
>   	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
>   				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
>   
> +	shrinker_unit_cache_init();
> +
>   	return 0;
>   }
>   
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f2..4fb424e721bca 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -12,6 +12,12 @@ DEFINE_MUTEX(shrinker_mutex);
>   
>   #ifdef CONFIG_MEMCG
>   static int shrinker_nr_max;
> +static struct kmem_cache *shrinker_unit_cachep;
> +
> +void __init shrinker_unit_cache_init(void)
> +{
> +	shrinker_unit_cachep = KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);
> +}
>   
>   static inline int shrinker_unit_size(int nr_items)
>   {
> @@ -33,7 +39,7 @@ static inline void shrinker_unit_free(struct shrinker_info *info, int start)
>   		if (!unit[i])
>   			break;
>   
> -		kfree(unit[i]);
> +		kmem_cache_free(shrinker_unit_cachep, unit[i]);
>   		unit[i] = NULL;
>   	}
>   }
> @@ -47,7 +53,8 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
>   	int i;
>   
>   	for (i = start; i < nr; i++) {
> -		unit = kzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
> +		unit = kmem_cache_alloc_node(shrinker_unit_cachep,
> +					     GFP_KERNEL | __GFP_ZERO, nid);
>   		if (!unit) {
>   			shrinker_unit_free(new, start);
>   			return -ENOMEM;
> 
> ---
> base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
> change-id: 20261016-vstor-144715-shrinker_info_unit-kmem_cache-69ea3f78b635
> 
> Best regards,
> --
> Konstantin Khorenko <khorenko@virtuozzo.com>
> 


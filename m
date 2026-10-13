Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DB847142E
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791859956; cv=none; b=DZkWH9FkCtfkIHP3cslZTA6FIX8VLdM+QLYp7EQ1ldI/WgF/b/LfXwpP3jCqTF3SrMitAA7tdJsO1LsyAztPlPU28aB91fDq9gIUaj7wVgQC0RWuo+c98c7WNF3f6fmgGPk2wza5azNBuwZOtuBbqRf1KSBXhunnu+pgt/Mrz18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791859956; c=relaxed/simple;
	bh=uL6ePUcLBZZOUIyB5RLHnAYGU9PprjKQPlmJBefHVMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nu2amkKz7QDWIqJJCcLSNh4TUgdmJUJkYUKQ5zCyeYWb05Awl6TGdVj4arwPuhQnqP+5NhHpNtQ/E9GDRoVEq6i8t/P9JZME2vaxX6uDVXgfV07/uyE/yvFpp5tbjE/V28J6eQvhrIU1oGsRPpF4dYVG2+LjkQ/akThaIajZmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NAMtpaTP; arc=none smtp.client-ip=95.215.58.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NAMtpaTP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uL6ePUcLBZZOUIyB5RLHnAYGU9PprjKQPlmJBefHVMY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791859953; v=1; x=1792464753;
 b=NAMtpaTPaCQ5A3BTTO3fwnlTUTeVof9HIoOGcULZS+jzEK5ALCPSDHs+G2rJtftClVL2B4Uw
 8G2dxy/mHsi0XK3sZIcQYIjPxYzpVb9PGXdsqCR1OIgj+Rb24JiQONZiPoa5aomONHCzQcDD9QG
 OrXo0ye+S5CeYVkCzx/61iIs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6830bd04216ac914;
	Tue, 13 Oct 2026 02:52:33 +0000
X-Mizu-Trace-ID: 6830bd04216ac914
X-Migadu-Flow: FLOW_OUT
Message-ID: <c2d25c25-2fd4-4bb5-a021-3cdf23e493d0@linux.dev>
Date: Tue, 13 Oct 2026 10:52:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/13/26 3:02 AM, Konstantin Khorenko wrote:
> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
> unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
> two, plus the one-word bitmap of shrinkers with objects charged to the
> cgroup. That word takes the unit just past the power of two, to 520
> bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
> it is padding.
> 
> The units are allocated when the cgroup goes online and freed when it is
> freed, so a dying cgroup keeps them until the last reference to it is
> gone. Their number is the number of memory cgroups, times the NUMA
> nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
> the peak number of memcg-aware shrinkers registered at once, and every
> superblock registers one, so a host that mounts many filesystems and
> runs many cgroups carries the padding as unreclaimable slab, and keeps
> paying it for new cgroups after the mounts are gone.
> 
> Let a unit cover one id less than a word holds. The bitmap still fits
> one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
> longs, so the unit fills a power-of-two kmalloc slot exactly and, on
> 64-bit, the memory taken by units halves, for about one unit more in
> BITS_PER_LONG.
> round_up() in expand_shrinker_info() needs a power-of-two step and
> becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
> modulos and multiplications that do not care. Assert the unit size at
> build time, since the layout depends on it.
> 
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>   include/linux/shrinker.h | 9 ++++++++-
>   mm/shrinker.c            | 2 +-
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a9..c250ab68d346c 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -7,7 +7,11 @@
>   #include <linux/refcount.h>
>   #include <linux/completion.h>
>   
> -#define SHRINKER_UNIT_BITS	BITS_PER_LONG
> +/*
> + * One id less than a word holds, so that nr_deferred[] and the map word add
> + * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc slot.
> + */
> +#define SHRINKER_UNIT_BITS	(BITS_PER_LONG - 1)
>   
>   /*
>    * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
> @@ -18,6 +22,9 @@ struct shrinker_info_unit {
>   	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
>   };
>   
> +static_assert(!(sizeof(struct shrinker_info_unit) &
> +		(sizeof(struct shrinker_info_unit) - 1)));
> +
>   struct shrinker_info {
>   	struct rcu_head rcu;
>   	int map_nr_max;
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f2..a9418072a509e 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -159,7 +159,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
>   static int expand_shrinker_info(int new_id)
>   {
>   	int ret = 0;
> -	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
> +	int new_nr_max = roundup(new_id + 1, SHRINKER_UNIT_BITS);
>   	int new_size, old_size = 0;
>   	struct mem_cgroup *memcg;
>   
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi




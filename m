Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37158370D56
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 07:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788593354; cv=none; b=UlwuvwKkwe1M6MRILguuYiKT0yceqdT5e7M9PD9jmfaoQg5kqTMHj5fHnOtlR7BPd98wWaJx4YwI9GBDHnpUgQciOA2o7tstC1oQmh+5QS8G+YpewXuNxrErQInPIqFln0qcf0cBai9lygEpH1YUY1anqgp0Ma4fFSJzk7ohEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788593354; c=relaxed/simple;
	bh=FO7uk+ZczJKUWeZKSugD0fmMxualw4LCIKgewWBGV1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9INIMA+sz6Whi5nNETuv3+c0+qM2BdpLymPVBeVKP/FR6YrE/tPyKwP86osM2v4maw3w9u9t87QzwbEmLrhDP9YnFp8TqbWTWq4K/4XXA6Ld/MTAuFXDcKpYVHBt5ojuZ3qtkUiFq15BqsZxmQKlB2oxNFAHirUbTjTJZJWQIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sn8e1vKp; arc=none smtp.client-ip=91.218.175.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sn8e1vKp"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FO7uk+ZczJKUWeZKSugD0fmMxualw4LCIKgewWBGV1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788593350; v=1; x=1789198150;
 b=Sn8e1vKpmMPzdYYzJRR4lZuz2OnF8SaOrtUCfRegQ6mwhNhdspWOSbjzHto9eMcCEipcYypD
 bZA+B8dRa3NfRSh/30yhj95DT0R3f9UsbzmvtmFT//sQPmCEHFQlD/LQAvgsBO2mYu/SeNnEG6L
 FzA8qlxdk48nthKbhlHy2qCA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d6a05955758b5d40;
	Sat, 05 Sep 2026 07:29:00 +0000
X-Mizu-Trace-ID: d6a05955758b5d40
X-Migadu-Flow: FLOW_OUT
Message-ID: <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
Date: Sat, 5 Sep 2026 15:28:50 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
To: bingfangguo@tencent.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> __mem_cgroup_uncharge_swap() needs both the memcg and the id refcount
> drop.  Right now it looks the memcg up by id, uncharges it, then looks
> it up again inside mem_cgroup_private_id_put() to drop the reference.
>
> Make mem_cgroup_private_id_put() resolve the id once, drop the
> reference, and return the nearest online memcg with a reference held for
> the caller.  __mem_cgroup_uncharge_swap() then uses that memcg directly
> and drops the reference after uncharging, avoiding the second xarray
> lookup.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   mm/memcontrol.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 048c9bb0fad79..f0503a1e5492d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
>   	}
>   }
>   
> -static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> +/**
> + * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
> + * @id: the memcg private id got from mem_cgroup_id_get_online
> + * @n: count of references to put
> + */
> +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)

Having an API that put reference-counted resources return a struct pointer
is a very strange design. Please don't do that.

>   {
>   	struct mem_cgroup *memcg;
>   
>   	rcu_read_lock();
>   	memcg = mem_cgroup_from_private_id(id);
> +	if (!memcg)
> +		goto out;
> +
>   	__mem_cgroup_private_id_put(memcg, n);
> +
> +	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
> +		memcg = parent_mem_cgroup(memcg);
> +
> +out:
>   	rcu_read_unlock();
> +	return memcg;
>   }
>   
>   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   	struct mem_cgroup *memcg;
>   
>   	rcu_read_lock();
> -	memcg = mem_cgroup_from_private_id(id);

I think we can introduce a new helper like obj_cgroup_from_private_id(),
We can use the ID to get the corresponding obj_cgroup, and then get the
mem_cgroup.

Muhcun,
Thanks.
> +	memcg = mem_cgroup_private_id_put(id, nr_pages);
>   	if (memcg) {
>   		if (!mem_cgroup_is_root(memcg)) {
>   			if (do_memsw_account())
> @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   				page_counter_uncharge(&memcg->swap, nr_pages);
>   		}
>   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> -		mem_cgroup_private_id_put(id, nr_pages);
>   	}
>   	rcu_read_unlock();
>   
> +	mem_cgroup_put(memcg);
>   }
>   
>   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>


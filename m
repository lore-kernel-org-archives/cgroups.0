Received: from mta0.migadu.com (out-93.mta0.migadu.com [91.218.175.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F2440655
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788602516; cv=none; b=FbDwMRmE8aYc1EL+jOewMKtQbr9ix/lk8ztSFgoSL54l0Tgs6tL4TBuGJstGNfHa9fjcn8r5RL4Dgv35OywRcm8NtC6r3uBlmrNNeiH51M7mpeS2mjJP0IkQ2AuWM1pvM6J3MtoYzg8/IgORdG6fVfIweK8mKaWPi3sN+TFg9+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788602516; c=relaxed/simple;
	bh=ueDZ8PzmB2BcxpWqII3y7lg815/Y5Ff1RHaLqlhWFZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3IVqtQ+pIZRN5w9QUAx2Rcu9NVSI7sq6Va6hHn16JALMiFaoe1dlcJeI+oi42UX+VDCbbbgG2v2PKT7DRxU6dyTJfJAj7QCDPoolGYG0N3dUdu/pYfd1CVQ4CeQHt9entgjaHuON5WTxmSsFKLBUrgxBH4nIiK7GS5U8vXH7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=reQNMr70; arc=none smtp.client-ip=91.218.175.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="reQNMr70"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ueDZ8PzmB2BcxpWqII3y7lg815/Y5Ff1RHaLqlhWFZw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788602509; v=1; x=1789207309;
 b=reQNMr70Txa4bnVxqjyMDrstBVmiPfgfnW5jbdx1ExdL0VkTcJnvq3XjI896pWmZl6QqKOxY
 wnx9j69loHDdYlvUkX4OoCOCBcguA+9nKHHZp/CUJ0ZpUKN20bhKbXF+L7YL3WjSOcbFeKQY+JM
 DUn/itdC/Uo1WQ4f8qDi89ec=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f97f8397945b4985;
	Sat, 05 Sep 2026 10:01:49 +0000
X-Mizu-Trace-ID: f97f8397945b4985
X-Migadu-Flow: FLOW_OUT
Message-ID: <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
Date: Sat, 5 Sep 2026 18:01:44 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
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
 <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> Swap uncharge knows the memcg only by its private id, and the id can
> outlive the memcg it used to belong to after we rebind memcgid to
> objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
> memcg containing the refcount internally, and keep the underlying
> __mem_cgroup_private_id_put() for the offline path that still holds a
> memcg pointer.
>
> In the uncharge path, the memcg pointer will have to be read from the
> xarray twice, but we'll fix that later by returning the memcg from the
> put path, so the uncharge path can obtain a reference in the same step.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   mm/memcontrol.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ecb4fb07d7735..048c9bb0fad79 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>   	}
>   }
>   
> -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
>   {
>   	if (refcount_sub_and_test(n, &memcg->id.ref)) {
>   		mem_cgroup_private_id_remove(memcg);
> @@ -4048,9 +4048,19 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
>   	}
>   }
>   
> +static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_private_id(id);
> +	__mem_cgroup_private_id_put(memcg, n);
> +	rcu_read_unlock();
> +}

To me, the direction of this change makes sense. At the same
time, I would also suggest applying a similar change to the get
function, for example: change mem_cgroup_private_id_get_online
to:

     unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg,
                                              unsigned int n);

Have it return a private ID. That way, I think the two interfaces
look much more symmetrical overall.

Based on this change, it should be easier to implement the
direction of my last suggestion in Patch 5.

Muchun,
Thanks.

> +
>   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>   {
> -	mem_cgroup_private_id_put(memcg, 1);
> +	__mem_cgroup_private_id_put(memcg, 1);
>   }
>   
>   struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> @@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   				page_counter_uncharge(&memcg->swap, nr_pages);
>   		}
>   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> -		mem_cgroup_private_id_put(memcg, nr_pages);
> +		mem_cgroup_private_id_put(id, nr_pages);
>   	}
>   	rcu_read_unlock();
> +
>   }
>   
>   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>


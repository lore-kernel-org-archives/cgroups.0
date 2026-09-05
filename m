Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC341379A
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 07:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788592353; cv=none; b=a17ntWYZB9CzBxek+4bwgE9Pa3vQBNYVTIMhoU6uLHQx/8fDTdD6h6FzHqHr2TLCxjGduVhsw9BX+aTzYBPGo8bhjxXxMhJBaHb8LCxEz1G10hFhCSnv53l44DZ95Dbax5IrZj5yVNc3IlR2qKeWGQSuRCQocfbS+EmNCRuqmv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788592353; c=relaxed/simple;
	bh=NDEQnPZ0MaLk8wFMT+/bNULPhdcxRN/4BxqEM/TV/So=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MLKlCSqDF0qPouiDGpRrbJmdFMRsq1oOS23vi5GYf7RoK6TZ7rHFu5KHaUfr9iee1tsPwclDyJtg46MhlRclv4snlriAn/Bk77eO1DJmTIoFXaqGCEyOHXPxS0VTUyeun2Juqp4IylXbwxNHZRuDziRlTv6/hotiI3ymA2A+IbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tAZU/ufA; arc=none smtp.client-ip=91.218.175.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tAZU/ufA"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NDEQnPZ0MaLk8wFMT+/bNULPhdcxRN/4BxqEM/TV/So=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788592346; v=1; x=1789197146;
 b=tAZU/ufAEEpRfnTicQ+t3GppjgsIbdu+OOXQ0z3fFbtBGLW3h7xZVrVKaFe2KgnAE04Nrroc
 yeip7kA9uI0EwVV003A0bY0zQwAeFbmRLRKBlOOhHbMXIL4kEFU442D1acLfFZBrZFWoQSaUVc5
 ti5iv/7J6BT89RhwR7f1riic=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 78ea68531be7ce2e;
	Sat, 05 Sep 2026 07:12:26 +0000
X-Mizu-Trace-ID: 78ea68531be7ce2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <a2fb9ea3-78dc-4bee-a64e-0928983961ad@linux.dev>
Date: Sat, 5 Sep 2026 15:12:19 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after
 swap charging success
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
 <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> __mem_cgroup_try_charge_swap() pinned the memcg private id before the
> swap counter was charged and had to undo the pin on the failure path.
> Hold RCU lock for an extended period (which should be fine,
> __memcg1_swapout() does this as well) so concurrent memcg release can
> be avoided, and take the id reference to its online parent only after
> charging has succeeded.
>
> The failure path is now a plain return, and the id is only pinned for
> entries that actually end up charged to swap.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   mm/memcontrol.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 31cec9dde55f0..ecb4fb07d7735 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>   	struct page_counter *counter;
>   	struct mem_cgroup *memcg;
>   	struct obj_cgroup *objcg;
> +	unsigned short memcgid;
>   
>   	if (do_memsw_account())
>   		return 0;
> @@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>   		return 0;
>   	}
>   
> -	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> -	/* memcg is pined by memcg ID. */
> -	rcu_read_unlock();
> +	while (memcg_is_dying(memcg))
> +		memcg = parent_mem_cgroup(memcg);

Since we've already chosen to expand the scope of RCU holding, it
seems we don't need to check whether the memcg is in a dying state
here. The upcoming stats updates aren't really tied to whether the
memcg is dying anyway, right? Why don't we just simplify the code?

Muchun,
Thanks.
>   
>   	if (!mem_cgroup_is_root(memcg) &&
>   	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>   		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>   		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> -		mem_cgroup_private_id_put(memcg, nr_pages);
> +		rcu_read_unlock();
>   		return -ENOMEM;
>   	}
>   	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
>   
> +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> +	memcgid = mem_cgroup_private_id(memcg);
> +	rcu_read_unlock();
> +
>   	ci = swap_cluster_get_and_lock(folio);
> -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> -			  mem_cgroup_private_id(memcg));
> +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
>   	swap_cluster_unlock(ci);
>   
>   	return 0;
>


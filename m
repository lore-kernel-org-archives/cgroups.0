Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B600F3D5C2C;
	Fri, 22 May 2026 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451207; cv=none; b=JVy9aRHIgbSwA7rx81mXpQetzjO70BgCrlF0Ht81DfNEqULCueMvPW2l7/X/o8qsjmHr+WyD9A9yoVcLGir0gePWuiIi4DPaGaxmEqXzpDK2Y0Va074C/SUbNjXx08R1JN1gZRtv7PgZM2yZn3xuWITsT8Dj60ft9y6jEDpV+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451207; c=relaxed/simple;
	bh=fbbKCCrY3BmvyZw2c/eMjZh3Vo/ZWlwwpAQZ2RiZgGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ne/ePkpaVJSfa5Js5yTCrkC/Ec9NPr84opzNorQdWoIy7QNDJy/+McwZecFgPfQwHPLiGKm39KRn9OC+/ML/xW7PPogABu4lkxzLdqIcnalaSjqFOLsNm3tBnSiYOiMqcpy5a5FVfITjyVgbtOyuWHljEPB/OikJkD8K51sTcXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2B76E1F415;
	Fri, 22 May 2026 11:59:51 +0000 (UTC)
Message-ID: <601a6c29-de31-44d7-b354-cc7a0e42d732@ghiti.fr>
Date: Fri, 22 May 2026 13:59:51 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm: memcontrol: track MEMCG_KMEM per NUMA node
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Wei Xu <weixugc@google.com>,
 Yuanchu Xie <yuanchu@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-5-alex@ghiti.fr> <ag9AY2SrcsE1B3Ti@linux.dev>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <ag9AY2SrcsE1B3Ti@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEfzuW/isuEquYusTjkCChymQZGYrE6UQrubmew1s29pfPbQNHYcMXPE1xkckOz4Gx0v3nmpsWrjOwwNI/NQP2eMy0oeQPLTyFe6w5utDyi4foMiOVk4+AXCNSKtaXZSJaS8qbvrdYN8pxLR2nFCYce0CWO3EmPID8zG5tYwOwQfHMa1OEb945QZyjUtxYGW1qqWXOSWY/gnoZgw2ppsRwrCUORANR234l8GGNNWkEZCc8iIZNv6/ArqYXZ5daLx5INydrxyR9kh4hQlxTLIdopou03K9EciWwQERt8JUyD/HkFt5SP0vbD1yY5ukGLKg8ld6Sa0ErWG65+c1P3ct8HSKRcjr5HVfJKW0/9xYzRmfz2BxG3HmECiQ+iT/sIjdchBLIyxQpMTorwb5K6HA8z0DGz9RvGwfqqEF+NaUoz3InIEWgSYze4ATmZ/p0clh5zOYJ9N4VMhQ+b/CTqJrUNWEtBqGBTAah7NOliBmO9ZTLNskkzAQtwc7R5ZBALlgbV49CtnhHnXOD6m5kqj/qNOSnJqydGb6oUVFMpDj5tYC1jWxVdrNYxX/x/g1USbTUsLpDGxM1+q0vhJftZRIcFM3d7qTVClJAqLoPdu6utVZx1uwc3/X+FUEQ3DuysdHQ0g/JAUFyLxprfZr1MJ7aRYH7NUQsDbBIPkY6P1/G4WA

On 5/21/26 19:28, Shakeel Butt wrote:
> On Mon, May 11, 2026 at 10:20:39PM +0200, Alexandre Ghiti wrote:
>> This patch gets rid of MEMCG_KMEM and wires all the "generic" functions
>> by introducing per-node obj_cgroup objects.
>>
>> Note that it does not convert the kmem users to proper per-memcg-per-node
>> accounting now, this is done in upcoming patches.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>   include/linux/memcontrol.h | 23 ++++++++++----
>>   include/linux/mmzone.h     |  1 +
>>   mm/memcontrol.c            | 64 ++++++++++++++++++++++++--------------
>>   mm/vmstat.c                |  1 +
>>   4 files changed, 59 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 568ab08f42af..17cf823160e4 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -35,7 +35,6 @@ enum memcg_stat_item {
>>   	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
>>   	MEMCG_SOCK,
>>   	MEMCG_PERCPU_B,
>> -	MEMCG_KMEM,
>>   	MEMCG_ZSWAP_B,
>>   	MEMCG_ZSWAPPED,
>>   	MEMCG_ZSWAP_INCOMP,
>> @@ -126,9 +125,10 @@ struct mem_cgroup_per_node {
>>   	struct list_head objcg_list;
>>   
>>   #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>> -	/* slab stats for nmi context */
>> +	/* slab and kmem stats for nmi context */
>>   	atomic_t		slab_reclaimable;
>>   	atomic_t		slab_unreclaimable;
>> +	atomic_t		kmem;
>>   #endif
>>   };
>>   
>> @@ -190,6 +190,7 @@ struct obj_cgroup {
>>   		struct rcu_head rcu;
>>   	};
>>   	bool is_root;
>> +	int nid;
>>   };
>>   
>>   /*
>> @@ -254,10 +255,6 @@ struct mem_cgroup {
>>   	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
>>   	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>>   
>> -#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>> -	/* MEMCG_KMEM for nmi context */
>> -	atomic_t		kmem_stat;
>> -#endif
>>   	/*
>>   	 * Hint of reclaim pressure for socket memroy management. Note
>>   	 * that this indicator should NOT be used in legacy cgroup mode
>> @@ -776,6 +773,20 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
>>   		percpu_ref_put(&objcg->refcnt);
>>   }
>>   
>> +static inline struct obj_cgroup *obj_cgroup_get_nid(struct obj_cgroup *objcg,
>> +						    int nid)
>> +{
>> +	struct obj_cgroup *nid_objcg;
>> +	struct mem_cgroup *memcg;
>> +
>> +	rcu_read_lock();
>> +	memcg = obj_cgroup_memcg(objcg);
>> +	nid_objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
>> +	rcu_read_unlock();
>> +
>> +	return nid_objcg;
> What is guarating the life of nid_objcg?


Sashiko raised the same question, so I need to be educated here: what 
currently guarantees the life objcg returned by current_obj_cgroup()?


>

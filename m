Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0159385D62
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 10:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788084820; cv=none; b=sStR02wfSV1C9pMSIKG722KQ7ISc6m+DB6MNNyr/pYUqbgy0SvEmLFXH5tQP4C4Aj61FiU5OPSQmwjtaew3kmKKw6AAv7h//FCjXHnORu1T4Rs02U9cf0VLfum5llO42obNM+LC/qs60Oy3KSoLRMvU0EBVNy63dVQKedeACoWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788084820; c=relaxed/simple;
	bh=orh/j8jOJpiqrKlrLd2jKhjQfJBswjC/3RKWNPcbXdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tetBTDLNpAMyhbu1T1z+EGWhySAhXd+eQAAofHiWMdapYwURMqf7iR1slg46xyOdBuNZXs268sz10Dvzk8/JELJ/GMvhlYN8deiFveyww8OR6HRcelHWWSXAFnfckPczQzFyJ6NtrHTbGJvZOnNx5F8fwIKp6kTNHdcKDll+jDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hV9xK6G+; arc=none smtp.client-ip=91.218.175.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hV9xK6G+"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=orh/j8jOJpiqrKlrLd2jKhjQfJBswjC/3RKWNPcbXdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788084814; v=1; x=1788689614;
 b=hV9xK6G+s2tQILnyHfaicHJCKWu8j6ovNFFtf2xsQxXkp2ZITHcQNBjt9+UjsEvwE1aB2E0G
 +GzIb0G0qqZiCT0C2SSiqZj/7RNHTtSDxSB9PZlZOV7cZAsDmkEvVIjAErRVY6bBrzrBp1+oVPk
 WYn6rh9a84SOeEBHvOG/Gg1M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e5d5919426a8fdc3;
	Sun, 30 Aug 2026 10:13:24 +0000
X-Mizu-Trace-ID: e5d5919426a8fdc3
X-Migadu-Flow: FLOW_OUT
Message-ID: <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
Date: Sun, 30 Aug 2026 18:13:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
 <20260828110919.1324028-3-ridong.chen@linux.dev>
 <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/30/2026 3:53 PM, Barry Song wrote:
> On Fri, Aug 28, 2026 at 7:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> memory.min/low is silently bypassed for MGLRU during global proactive
>> reclaim (writing to the root memory.reclaim) and global direct reclaim.
> 
> I guess nobody is silently bypassing anything. It's just that the
> effective min is stale data. If kswapd has run at least once, should
> the protection have been updated already?
> I guess we need to update the changelog a bit?
> 

The children's emin/elow are derived from the parent's min/low settings and 
children_min_usage, both of which can change over time. As a result, emin/elow 
may become stale, even if kswapd has already run once.

>> It can be reproduced as follows:
>>
>>    # echo 7 > /sys/kernel/mm/lru_gen/enabled
>>    # cd /sys/fs/cgroup
>>    # mkdir -p a/b
>>    # echo 100M > a/memory.min
>>    # echo +memory > a/cgroup.subtree_control
>>    # echo 100M > a/b/memory.min
>>    # echo $$ > a/b/cgroup.procs
>>    # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>>    # cat a/b/memory.current
>>    222650368
>>    # echo 500M > memory.reclaim
>>    -bash: echo: write error: Resource temporarily unavailable
>>    # cat a/b/memory.current
>>    6070272
>>
>> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
>> protection. The traditional LRU path is not affected because
>> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
>> visits during a top-down tree walk.
>>
>> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
>> moved the protection computation into lru_gen_age_node(), which only
>> runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
>> lru_gen_shrink_node() -> shrink_many() without any protection
>> computation, so emin/elow remain stale or zero.
>>
>> Introduce mem_cgroup_protection_path() which computes emin/elow along
>> the root-to-target path only by iterating through the cgroup ancestors
>> array top-down. This avoids the full tree traversal that would be
>> needed with mem_cgroup_calculate_protection(), limiting the cost to
>> O(depth) per memcg - typically 3-5 levels.
>>
>> Call it from shrink_one() for the non-kswapd path so that each memcg
>> about to be shrunk has correct protection values.
>>
>> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/memcontrol.h | 11 ++++++++++
>>   mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                |  8 ++++++-
>>   3 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 7d1c0ce189a8..8066b798a759 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -605,6 +605,10 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
>>
>>   void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>                                       struct mem_cgroup *memcg);
>> +#ifdef CONFIG_LRU_GEN
>> +void mem_cgroup_protection_path(struct mem_cgroup *root,
>> +                               struct mem_cgroup *memcg);
>> +#endif
>>
>>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>>                                            struct mem_cgroup *memcg)
>> @@ -1133,6 +1137,13 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>   {
>>   }
>>
>> +#ifdef CONFIG_LRU_GEN
>> +static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
>> +                                             struct mem_cgroup *memcg)
>> +{
>> +}
>> +#endif
>> +
> 
> I wonder if we could follow the zswap pattern?
> 
> #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
> bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
> void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
> void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
> bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
> #else
> static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
> {
>          return true;
> }

That is fine for me, I will update it.

> ...
> #endif
> 
>>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>>                                            struct mem_cgroup *memcg)
>>   {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1271d390b617..095050d4296a 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5198,6 +5198,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>          page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>>   }
>>
>> +#ifdef CONFIG_LRU_GEN
>> +/**
>> + * mem_cgroup_protection_path - compute protection along root->memcg path
>> + * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
>> + * @memcg: the target memory cgroup
>> + *
>> + * Walk the ancestor path from @root down to @memcg and compute the effective
>> + * protection at each level.  This is safe for isolated queries because it
>> + * ensures parents are computed before children.
>> + */
>> +void mem_cgroup_protection_path(struct mem_cgroup *root,
>> +                               struct mem_cgroup *memcg)
> 
> Can we rename it to `mem_cgroup_calculate_protection_path()`?
> 
> BTW, I see that the only caller is in vmscan and it passes NULL as
> `root`. Do we need to keep the `root` argument if the new helper is
> only used for global reclaim?
> 
I'd suggest keeping it as is. This function updates protection along the path 
from root to memcg, and could be reused later. Note that 
mem_cgroup_calculate_protection() assumes the caller has already performed the 
top-down walk, each level's calculation depends on its parent being updated first.

For mem_cgroup_calculate_protection_path(), it can be called in any context 
without such a precondition.

-- 
Best regards
Ridong


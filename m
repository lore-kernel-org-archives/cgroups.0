Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224DE2E62A4
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 01:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787881929; cv=none; b=GAEIFkqy5CnMg+rMVj8Mj+S43WLTUMFj2iu48uLGoolvvBpLLHl6tXzSFawunanFjD1vI6LccSE3J5ftAM5qM0JDFuiaIV5QJ3sPhX8El9uEBjm7WfKLBj+CyTdwtJ9Hnhir23JGXbL7hceH8j3KvT79nzW27yox7kaHrs6HkLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787881929; c=relaxed/simple;
	bh=y7yB0bB4nuU8iui0WepOTzhFkm2WtSs4RSCP5Ouvwks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qGgRskV3eLf3z+OMD0ettlCi/iWjgXmzLxhpvU4Tm89mlPw6jflWIwG5zMszLshaTjyL5IcuVAykgQkUBvOAZVdKc+jtiCVyqHuzWNXUQujSbmHk2OKvtmCfUIvCs6IwH5+LoRiv5FFbo97SdL7qfg/ffGbqA3OD61x5OMLmEJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ff5/NPe8; arc=none smtp.client-ip=95.215.58.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ff5/NPe8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=y7yB0bB4nuU8iui0WepOTzhFkm2WtSs4RSCP5Ouvwks=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787881924; v=1; x=1788486724;
 b=Ff5/NPe8hoo92rcRwqW0841g7IcPUpQDb+WPq4vz+gZjaDI5v3c4Qs8Aoi3H+ir3FbAynx+v
 B+J1oVRNdhfJtFK+yC/iXY5Ym0iy77CGWRGvUSMTATd75e+lPMzPhI/X9MSlj9Xlb4JKj1b7rlM
 /HTMB8teWPQXSQnnjspd/AcY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e5cd93c861d874df;
	Fri, 28 Aug 2026 01:52:03 +0000
X-Mizu-Trace-ID: e5cd93c861d874df
X-Migadu-Flow: FLOW_OUT
Message-ID: <02305fa3-775a-42fd-a53f-9e611d5cf3a1@linux.dev>
Date: Fri, 28 Aug 2026 09:51:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260826133054.88529-1-ridong.chen@linux.dev>
 <20260827172141.GF3004@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260827172141.GF3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/28/2026 1:21 AM, Johannes Weiner wrote:
> On Wed, Aug 26, 2026 at 09:30:54PM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> memory.min/low is silently bypassed for MGLRU during global proactive
>> reclaim (writing to the root memory.reclaim) and global direct reclaim.
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
>> protection.  The traditional LRU path is not affected because
>> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
>> visits during a top-down tree walk.
>>
>> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
>> moved the protection computation into lru_gen_age_node(), which only
>> runs for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
>> lru_gen_shrink_node() -> shrink_many() without any protection
>> computation, so emin/elow remain stale or zero.
>>
>> Introduce mem_cgroup_protection_path() which computes emin/elow along
>> the root-to-target path only by iterating through the cgroup ancestors
>> array top-down.  This avoids the full tree traversal that would be
>> needed with mem_cgroup_calculate_protection(), limiting the cost to
>> O(depth) per memcg - typically 3-5 levels.
> 
> Right, because of the memcg-lru...
> 

Yep, that's it.

>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5198,6 +5198,48 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>>   	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>>   }
>>   
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
>> +				struct mem_cgroup *memcg)
>> +{
>> +	bool recursive_protection =
>> +		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
>> +	struct cgroup *cg;
>> +	int root_level, i;
>> +
>> +	if (mem_cgroup_disabled())
>> +		return;
>> +
>> +	if (!root)
>> +		root = root_mem_cgroup;
>> +
>> +	if (memcg == root)
>> +		return;
>> +
>> +	root_level = root->css.cgroup->level;
>> +	cg = memcg->css.cgroup;
>> +
>> +	rcu_read_lock();
>> +	for (i = root_level + 1; i <= cg->level; i++) {
>> +		struct mem_cgroup *cur;
>> +
>> +		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
>> +						    &memory_cgrp_subsys));
>> +		if (cur)
>> +			page_counter_calculate_protection(&root->memory,
>> +					&cur->memory, recursive_protection);
>> +	}
>> +	rcu_read_unlock();
>> +}
> 
> Please wrap this in a #ifdef CONFIG_LRU_GEN block.

Will add.

-- 
Best regards
Ridong


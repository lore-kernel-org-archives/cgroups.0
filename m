Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A9937C0E6
	for <cgroups@vger.kernel.org>; Thu, 29 Jan 2026 08:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769676695; cv=none; b=mkQ9AhS8PadTdXOZq0S2wPgmhlwTA+ZqC0QU1CBRp5DMKeN4DzGup1CDrVreDdNgyoKoCmkyLNUUU3Cu7UXkNnWKB3lLWGrwchWhR/GqPfdV5KSyS9t0mdr0Nt1stLcNmRXnjUTyv/SBuUBKhlevgt/ZuWGQLNckSlbBnxzP/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769676695; c=relaxed/simple;
	bh=rzFwTbcGlRFqg/XzbyvFBTLjJtfVORh5u9QmF3dfJic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hjtb4gjE1SpnXGLGL0h8ddHzT0RGguQ8gs1NfBuXEy8IykOKaMHZ7QXrSQ7jv9Wpq/K7rdGZsW3tsImpZDJYrnCS8u8nz6jkY7x0C3bvXI3qO12Ay+EWnDFbCNUXS/9OEyAzBXQ/vVjB2CWMTX/I2q7C99ArDZRG9ShH1vFdIKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vvxYXiUm; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vvxYXiUm"
Message-ID: <6860146b-be12-4d5f-bec1-bbcec1dffbc6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769676676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAdXb4bfUsmEDEKXvxCCDPoLM2r4WzvPltJYWV3bwtA=;
	b=vvxYXiUm1xh5hSI0HndFd1wGYWaZAXe1kxDlslz5niCHLt+NR7Yn1ohQi7vhPZBTvXJ7mV
	1TOrUgLmqGZQW99e0EBT4XQfvagxB0MBQuERtxdBLv5eBFvZmMTRRTrcUfg5c03zZwDx1O
	c0M/oTunUTmd9zvO4CMOmjcmhXbsWRo=
Date: Thu, 29 Jan 2026 16:50:39 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30] mm: memcontrol: prepare for reparenting
 state_local
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <iu27pt5nqs6myshw57e7dotld33v6lwuyouvquoqc2zmc5loi6@f23auf7hqbdp>
 <9b9057f8-4c4c-4067-b6ba-0791888c25e8@linux.dev> <aXrBiPlpEOOC3cMZ@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXrBiPlpEOOC3cMZ@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 1/29/26 10:10 AM, Harry Yoo wrote:
> On Mon, Jan 19, 2026 at 11:34:53AM +0800, Qi Zheng wrote:
>>
>>
>> On 1/18/26 11:20 AM, Shakeel Butt wrote:
>>> On Wed, Jan 14, 2026 at 07:32:55PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>>>> memcg to its parent memcg. The following counts are all non-hierarchical
>>>> and need to be reparented to prevent the counts of parent memcg overflow.
>>>>
>>>> 1. memcg->vmstats->state_local[i]
>>>> 2. pn->lruvec_stats->state_local[i]
>>>>
>>>> This commit implements the specific function, which will be used during
>>>> the reparenting process.
>>>
>>> Please add more explanation which was discussed in the email chain at
>>> https://lore.kernel.org/all/5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5/
>>
>> OK, will do.
>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 70583394f421f..7aa32b97c9f17 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -225,6 +225,28 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
>>>>    	return objcg;
>>>>    }
>>>> +#ifdef CONFIG_MEMCG_V1
>>>> +static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
>>>> +
>>>> +static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>>> +{
>>>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>>> +		return;
>>>> +
>>>> +	synchronize_rcu();
>>>
>>> Hmm synchrinuze_rcu() is a heavy hammer here. Also you would need rcu
>>> read lock in mod_memcg_state() & mod_memcg_lruvec_state() for this
>>> synchronize_rcu().
>>
>> Since these two functions require memcg or lruvec, they are already
>> within the critical section of the RCU lock.
> 
> What happens if someone grabbed a refcount and then release the rcu read
> lock before percpu refkill and then call mod_memcg[_lruvec]_state()?
> 
> In this case, can we end up reparenting in the middle of non-hierarchical
> stat update because they don't have RCU grace period?
> 
> Something like
> 
> T1				T2
> 
> 				- rcu_read_lock()
> 				- get memcg refcnt
> 				- rcu_read_unlock()
> 
> 				- call mod_memcg_state()
> 				- CSS_IS_DYING is not set
> - Set CSS_IS_DYING
> - Trigger percpu refkill
> 				
> - Trigger offline_css()
>    -> reparent non-hierarchical	- update non-hierarchical stats
>       stats
> 				- put memcg refcount

Good catch, I think you are right.

The rcu lock should be added to mod_memcg_state() and
mod_memcg_lruvec_state().

I will update to v4 as soon as possible.

Thanks,
Qi

> 
>>> Hmm instead of synchronize_rcu() here, we can use queue_rcu_work() in
>>> css_killed_ref_fn(). It would be as simple as the following:
>>
>> It does look much simpler, will do.
>>
>> Thanks,
>> Qi
> 


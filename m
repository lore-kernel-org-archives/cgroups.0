From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Thu, 20 Aug 2020 16:29:27 -0400
Message-ID: <a3d4783b-5aee-da40-06c0-ac63e292ccdb@redhat.com>
References: <20200820130350.3211-1-longman@redhat.com>
 <20200820130350.3211-3-longman@redhat.com>
 <20200820173546.GB912520@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597955375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqTEDMhBKHUNdE/xOyKTnipumO1ldzx6XH3nmOiyvQQ=;
        b=UqoHrxDCUmVGNuNcjX3y5BjoF2tgaUImBNGrCwRDViVBs1s+5iIBRSrF/O1JyDobx4q+jy
        mWDSWtxy/fxtSQQ5ceNPpEYMhtSphwX0pWk+VxmYfbJa1fQRChKqY6UEQmdBcveqGtVYVK
        MR5QQexJ+YsFvOghE+dWdSRs9Mg43Yo=
In-Reply-To: <20200820173546.GB912520@cmpxchg.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>

On 8/20/20 1:35 PM, Johannes Weiner wrote:
> On Thu, Aug 20, 2020 at 09:03:49AM -0400, Waiman Long wrote:
>> The mem_cgroup_get_max() function used to get memory+swap max from
>> both the v1 memsw and v2 memory+swap page counters & return the maximum
>> of these 2 values. This is redundant and it is more efficient to just
>> get either the v1 or the v2 values depending on which one is currently
>> in use.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/memcontrol.c | 14 +++++---------
>>   1 file changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 26b7a48d3afb..d219dca5239f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1633,17 +1633,13 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
>>    */
>>   unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>>   {
>> -	unsigned long max;
>> +	unsigned long max = READ_ONCE(memcg->memory.max);
>>   
>> -	max = READ_ONCE(memcg->memory.max);
>>   	if (mem_cgroup_swappiness(memcg)) {
>> -		unsigned long memsw_max;
>> -		unsigned long swap_max;
>> -
>> -		memsw_max = memcg->memsw.max;
>> -		swap_max = READ_ONCE(memcg->swap.max);
>> -		swap_max = min(swap_max, (unsigned long)total_swap_pages);
>> -		max = min(max + swap_max, memsw_max);
>> +		if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +			max += READ_ONCE(memcg->swap.max);
>> +		else
>> +			max = memcg->memsw.max;
> I agree with the premise of the patch, but v1 and v2 have sufficiently
> different logic, and the way v1 overrides max from the innermost
> branch again also doesn't help in understanding what's going on.
>
> Can you please split out the v1 and v2 code?
>
> 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> 		max = READ_ONCE(memcg->memory.max);
> 		if (mem_cgroup_swappiness(memcg))
> 			max += READ_ONCE(memcg->swap.max);
> 	} else {
> 		if (mem_cgroup_swappiness(memcg))
> 			max = memcg->memsw.max;
> 		else
> 			max = READ_ONCE(memcg->memory.max);
> 	}
>
> It's slightly repetitive, but IMO much more readable.
>
Sure. That makes it even better.

Cheers,
Longman


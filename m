From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Mon, 14 Sep 2020 09:51:26 -0400
Message-ID: <e8ddc443-b56a-1dd6-6d41-ad217e9aea80@redhat.com>
References: <20200914024452.19167-1-longman@redhat.com>
 <20200914024452.19167-3-longman@redhat.com>
 <20200914114825.GM16999@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600091494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fu/1GHUDf4AcKJWnq4PI0AJl4nVdBvz984mVLLa8XWI=;
        b=FXur+oHttylqzUUIdyCox9+t9no2W5Hg02/O1KZXBXsILmO/f8dvL+me4gbOKYXRLPA6S0
        FNC7RyrknDa9olelUdO6SZObUVpBpT1Wp9XKxhKTYssqyHzU+b62i9HrETu+pM1fux/Xzk
        qzc4SLOTz7r/GR3xXBRWzEJyrmlNE00=
In-Reply-To: <20200914114825.GM16999-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 9/14/20 7:48 AM, Michal Hocko wrote:
> On Sun 13-09-20 22:44:51, Waiman Long wrote:
>> The mem_cgroup_get_max() function used to get memory+swap max from
>> both the v1 memsw and v2 memory+swap page counters & return the maximum
>> of these 2 values. This is redundant and it is more efficient to just
>> get either the v1 or the v2 values depending on which one is currently
>> in use.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/memcontrol.c | 20 +++++++++-----------
>>   1 file changed, 9 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8c74f1200261..ca36bed588d1 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1633,17 +1633,15 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
>>    */
>>   unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>>   {
>> -	unsigned long max;
>> -
>> -	max = READ_ONCE(memcg->memory.max);
>> -	if (mem_cgroup_swappiness(memcg)) {
>> -		unsigned long memsw_max;
>> -		unsigned long swap_max;
>> -
>> -		memsw_max = memcg->memsw.max;
>> -		swap_max = READ_ONCE(memcg->swap.max);
>> -		swap_max = min(swap_max, (unsigned long)total_swap_pages);
>> -		max = min(max + swap_max, memsw_max);
>> +	unsigned long max = READ_ONCE(memcg->memory.max);
>> +
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
>> +		if (mem_cgroup_swappiness(memcg))
>> +			max += min(READ_ONCE(memcg->swap.max),
>> +				   (unsigned long)total_swap_pages);
>> +	} else { /* v1 */
>> +		if (mem_cgroup_swappiness(memcg))
>> +			max = memcg->memsw.max;
> I agree that making v1 vs. v2 distinction here makes the code more
> obvious. But I do not think your code is correct for v1. In a default
> state it would lead to max = PAGE_COUNTER_MAX which is not something
> we want, right?
>
> instead you want
> 		max += min(READ_ONCE(memcg->memsw.max), total_swap_pages);
>
You are right, it is a bit tricky for v1.

I will change it to

     max += min(READ_ONCE(memcg->memsw.max) - max, total_swap_pages):

Thanks,
Longman


From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Mon, 14 Sep 2020 10:58:45 -0400
Message-ID: <24d1cfe4-845e-0944-4187-217d345d59a5@redhat.com>
References: <20200914024452.19167-1-longman@redhat.com>
 <20200914141955.2145-1-longman@redhat.com>
 <20200914144739.GV16999@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600095531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4EylP6DiiMU0xDyOAgmGkadg42XWec7eelWwk0KDc0=;
        b=bgr9QGacO+rrT8VwtKAUTbJ/z4GDHTDFdxMq62qBPJIcOt+deZ1Xwi960jmvG+K1dYXGjI
        beoZ11jQOQxEQTmiK/M8uKzgCpffDYUDN5vQMk84BpuXytKTCiICsv7tNcqc7uvwTK7rOq
        wUeQDJ9dmB2thGFCU+e4ZwMCtOGQzSU=
In-Reply-To: <20200914144739.GV16999@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>

On 9/14/20 10:47 AM, Michal Hocko wrote:
> On Mon 14-09-20 10:19:55, Waiman Long wrote:
>> The mem_cgroup_get_max() function used to get memory+swap max from
>> both the v1 memsw and v2 memory+swap page counters & return the maximum
>> of these 2 values. This is redundant and it is more efficient to just
>> get either the v1 or the v2 values depending on which one is currently
>> in use.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/memcontrol.c | 24 +++++++++++++-----------
>>   1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8c74f1200261..2331d4bc7c4d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1633,17 +1633,19 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
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
>> +		if (mem_cgroup_swappiness(memcg)) {
>> +			unsigned long memsw = READ_ONCE(memcg->memsw.max);
>> +
>> +			if (memsw > max)
>> +				max += min(memsw - max, (unsigned long)total_swap_pages);
> Yes this looks better. But, memsw can never be smaller than the hard
> limit (mem_cgroup_resize_max). I would find it slightly easier to
> understand if you did
> 	/* calculate swap excess capacity from memsw limit*/
> 	unsigned long memsw = READ_ONCE(memcg->memsw.max) - max;
> 	max += min (memsw, total_swap_pages);

Right, I thought it was possible to set memsw lower than mem. It was not 
allowed. So the extra check is unnecessary. Will fix that.

Cheers,
Longman


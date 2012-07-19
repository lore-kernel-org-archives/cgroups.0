From: Wanpeng Li <liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC] mm/memcg: calculate max hierarchy limit number
 instead of min
Date: Thu, 19 Jul 2012 14:30:52 +0800
Message-ID: <20120719063051.GA18422@kernel>
References: <a>
 <1342013081-4096-1-git-send-email-liwp.linux@gmail.com>
 <5007A418.10801@jp.fujitsu.com>
Reply-To: Wanpeng Li <liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5007A418.10801-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Jul 19, 2012 at 03:07:20PM +0900, Kamezawa Hiroyuki wrote:
>(2012/07/11 22:24), Wanpeng Li wrote:
>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Since hierachical_memory_limit shows "of bytes of memory limit with
>> regard to hierarchy under which the memory cgroup is", the count should
>> calculate max hierarchy limit when use_hierarchy in order to show hierarchy
>> subtree limit. hierachical_memsw_limit is the same case.
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>Hm ? What is the hierarchical limit for 'C' in following tree ?
>
>A  ---  limit=1G 
> \
>  B --  limit=500M
>   \
>    C - unlimtied
>
Hmm, thank you Kame. :-)

Regards,
Wanpeng Li 

>Thanks,
>-Kame
>
>
>> ---
>>   mm/memcontrol.c |   14 +++++++-------
>>   1 files changed, 7 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 69a7d45..6392c0a 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3929,10 +3929,10 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>>   		unsigned long long *mem_limit, unsigned long long *memsw_limit)
>>   {
>>   	struct cgroup *cgroup;
>> -	unsigned long long min_limit, min_memsw_limit, tmp;
>> +	unsigned long long max_limit, max_memsw_limit, tmp;
>>   
>> -	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
>> -	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>> +	max_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
>> +	max_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>>   	cgroup = memcg->css.cgroup;
>>   	if (!memcg->use_hierarchy)
>>   		goto out;
>> @@ -3943,13 +3943,13 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>>   		if (!memcg->use_hierarchy)
>>   			break;
>>   		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
>> -		min_limit = min(min_limit, tmp);
>> +		max_limit = max(max_limit, tmp);
>>   		tmp = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>> -		min_memsw_limit = min(min_memsw_limit, tmp);
>> +		max_memsw_limit = max(max_memsw_limit, tmp);
>>   	}
>>   out:
>> -	*mem_limit = min_limit;
>> -	*memsw_limit = min_memsw_limit;
>> +	*mem_limit = max_limit;
>> +	*memsw_limit = max_memsw_limit;
>>   }
>>   
>>   static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
>> 
>
>
>
>--
>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>see: http://www.linux-mm.org/ .
>Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

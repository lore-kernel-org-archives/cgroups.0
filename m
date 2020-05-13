From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: Fix memcg_kmem_bypass() for remote memcg charging
Date: Wed, 13 May 2020 19:19:56 +0800
Message-ID: <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200513090502.GV29153-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2020/5/13 17:05, Michal Hocko wrote:
> On Wed 13-05-20 15:28:28, Li Zefan wrote:
>> While trying to use remote memcg charging in an out-of-tree kernel module
>> I found it's not working, because the current thread is a workqueue thread.
>>
>> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>
>> No need to queue this for v5.7 as currently no upstream users of this memcg
>> feature suffer from this bug.
>>
>> ---
>>  mm/memcontrol.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index a3b97f1..db836fc 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2802,6 +2802,8 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
>>  
>>  static inline bool memcg_kmem_bypass(void)
>>  {
>> +	if (unlikely(current->active_memcg))
>> +		return false;
> 
> I am confused. Why the check below is insufficient? It checks for both mm
> and PF_KTHREAD?
> 

memalloc_use_memcg(memcg);
alloc_page(GFP_KERNEL_ACCOUNT);
memalloc_unuse_memcg();

If we run above code in a workqueue thread the memory won't be charged to the specific
memcg, because memcg_kmem_bypass() returns true in this case.

>>  	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>>  		return true;
>>  	return false;

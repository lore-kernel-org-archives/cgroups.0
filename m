From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/cgroup: avoid panic when init with low memory
Date: Mon, 20 Feb 2017 18:09:43 +0100
Message-ID: <934d40ec-060b-4794-2fdc-35a7ea1dc9e2@linux.vnet.ibm.com>
References: <1487154969-6704-1-git-send-email-ldufour@linux.vnet.ibm.com>
 <20170220130123.GI2431@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170220130123.GI2431@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 20/02/2017 14:01, Michal Hocko wrote:
> On Wed 15-02-17 11:36:09, Laurent Dufour wrote:
>> The system may panic when initialisation is done when almost all the
>> memory is assigned to the huge pages using the kernel command line
>> parameter hugepage=xxxx. Panic may occur like this:
> 
> I am pretty sure the system might blow up in many other ways when you
> misconfigure it and pull basically all the memory out. Anyway...
> 
> [...]
> 
>> This is a chicken and egg issue where the kernel try to get free
>> memory when allocating per node data in mem_cgroup_init(), but in that
>> path mem_cgroup_soft_limit_reclaim() is called which assumes that
>> these data are allocated.
>>
>> As mem_cgroup_soft_limit_reclaim() is best effort, it should return
>> when these data are not yet allocated.
> 
> ... this makes some sense. Especially when there is no soft limit
> configured. So this is a good step. I would just like to ask you to go
> one step further. Can we make the whole soft reclaim thing uninitialized
> until the soft limit is actually set? Soft limit is not used in cgroup
> v2 at all and I would strongly discourage it in v1 as well. We will save
> few bytes as a bonus.

Hi Michal, and thanks for the review.

I'm not familiar with that part of the kernel, so to be sure we are on
the same line, are you suggesting to set soft_limit_tree at the first
time mem_cgroup_write() is called to set a soft_limit field ?

Obviously, all callers to soft_limit_tree_node() and
soft_limit_tree_from_page() will have to check for the return pointer to
be NULL.

Cheers,
Laurent.


>> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
>> ---
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1fd6affcdde7..213f96b2f601 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2556,7 +2556,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>>  	 * is empty. Do it lockless to prevent lock bouncing. Races
>>  	 * are acceptable as soft limit is best effort anyway.
>>  	 */
>> -	if (RB_EMPTY_ROOT(&mctz->rb_root))
>> +	if (!mctz || RB_EMPTY_ROOT(&mctz->rb_root))
>>  		return 0;
>>  
>>  	/*
>> -- 
>> 2.7.4
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

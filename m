From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V7 07/14] mm/page_cgroup: Make page_cgroup point to the cgroup rather than the mem_cgroup
Date: Tue, 05 Jun 2012 08:23:28 +0530
Message-ID: <87ehpu8o5z.fsf@skywalker.in.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FCD648E.90709@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FCD648E.90709-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> writes:

> (2012/05/30 23:38), Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V"<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> We will use it later to make page_cgroup track the hugetlb cgroup information.
>> 
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   include/linux/mmzone.h      |    2 +-
>>   include/linux/page_cgroup.h |    8 ++++----
>>   init/Kconfig                |    4 ++++
>>   mm/Makefile                 |    3 ++-
>>   mm/memcontrol.c             |   42 +++++++++++++++++++++++++-----------------
>>   5 files changed, 36 insertions(+), 23 deletions(-)
>> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 2427706..2483cc5 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -1052,7 +1052,7 @@ struct mem_section {
>> 
>>   	/* See declaration of similar field in struct zone */
>>   	unsigned long *pageblock_flags;
>> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>> +#ifdef CONFIG_PAGE_CGROUP
>>   	/*
>>   	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
>>   	 * section. (see memcontrol.h/page_cgroup.h about this.)
>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
>> index a88cdba..7bbfe37 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -12,7 +12,7 @@ enum {
>>   #ifndef __GENERATING_BOUNDS_H
>>   #include<generated/bounds.h>
>> 
>> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>> +#ifdef CONFIG_PAGE_CGROUP
>>   #include<linux/bit_spinlock.h>
>> 
>>   /*
>> @@ -24,7 +24,7 @@ enum {
>>    */
>>   struct page_cgroup {
>>   	unsigned long flags;
>> -	struct mem_cgroup *mem_cgroup;
>> +	struct cgroup *cgroup;
>>   };
>> 
>
> This patch seems very bad.

I had to change that to 

struct page_cgroup {
	unsigned long flags;
	struct cgroup_subsys_state *css;
};

to get memcg to work. We end up changing css.cgroup on cgroupfs mount/umount.

>
>   - What is the performance impact to memcg ? Doesn't this add extra overheads 
>     to memcg lookup ?

Considering that we are stashing cgroup_subsys_state, it should be a
simple addition. I haven't measured the exact numbers. Do you have any
suggestion on the tests I can run ?

>   - Hugetlb reuquires much more smaller number of tracking information rather
>     than memcg requires. I guess you can record the information into page->private
>     if you want.

So If we end up tracking page cgroup in struct page all these extra over
head will go away. And in most case we would have both memcg and hugetlb
enabled by default.

>   - This may prevent us from the work 'reducing size of page_cgroup'
>

by reducing you mean moving struct page_cgroup info to struct page
itself ? If so this should not have any impact right ? Most of the
requirement of hugetlb should be similar to memcg. 

> So, strong Nack to this. I guess you can use page->private or some entries in
> struct page, you have many pages per accounting units. Please make an effort
> to avoid using page_cgroup.
>

HugeTLB already use page->private of compound page head to track subpool
pointer. So we won't be able to use page->private.

-aneesh

From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 4/5] memcg: do not call page_cgroup_init at system_boot
Date: Wed, 6 Mar 2013 12:22:39 +0400
Message-ID: <5136FCCF.6090003@parallels.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com> <1362489058-3455-5-git-send-email-glommer@parallels.com> <513696C1.3090301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513696C1.3090301-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

On 03/06/2013 05:07 AM, Kamezawa Hiroyuki wrote:
> (2013/03/05 22:10), Glauber Costa wrote:
>> If we are not using memcg, there is no reason why we should allocate
>> this structure, that will be a memory waste at best. We can do better
>> at least in the sparsemem case, and allocate it when the first cgroup
>> is requested. It should now not panic on failure, and we have to handle
>> this right.
>>
>> flatmem case is a bit more complicated, so that one is left out for
>> the moment.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> ---
>>   include/linux/page_cgroup.h |  28 +++++----
>>   init/main.c                 |   2 -
>>   mm/memcontrol.c             |   3 +-
>>   mm/page_cgroup.c            | 150 ++++++++++++++++++++++++--------------------
>>   4 files changed, 99 insertions(+), 84 deletions(-)
> 
> This patch seems a complicated mixture of clean-up and what-you-really-want.
> 
I swear it is all what-I-really-want, any cleanups are non-intentional!

>> -#if !defined(CONFIG_SPARSEMEM)
>> +static void *alloc_page_cgroup(size_t size, int nid)
>> +{
>> +	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
>> +	void *addr = NULL;
>> +
>> +	addr = alloc_pages_exact_nid(nid, size, flags);
>> +	if (addr) {
>> +		kmemleak_alloc(addr, size, 1, flags);
>> +		return addr;
>> +	}
> 
> As far as I remember, this function was written for SPARSEMEM.
> 
> How big this "size" will be with FLATMEM/DISCONTIGMEM ?
> if 16GB, 16 * 1024 * 1024 * 1024 / 4096 * 16 = 64MB. 
> 
> What happens if order > MAX_ORDER is passed to alloc_pages()...no warning ?
> 
> How about using vmalloc always if not SPARSEMEM ?

I don't oppose.

>>   
>> -void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
>> +static void free_page_cgroup(void *addr)
>> +{
>> +	if (is_vmalloc_addr(addr)) {
>> +		vfree(addr);
>> +	} else {
>> +		struct page *page = virt_to_page(addr);
>> +		int nid = page_to_nid(page);
>> +		BUG_ON(PageReserved(page));
> 
> This BUG_ON() can be removed.
> 

You are right, although it is still a bug =)

>> +		free_pages_exact(addr, page_cgroup_table_size(nid));
>> +	}
>> +}
>> +
>> +static void page_cgroup_msg(void)
>> +{
>> +	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>> +	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you "
>> +			 "don't want memory cgroups.\nAlternatively, consider "
>> +			 "deferring your memory cgroups creation.\n");
>> +}
> 
> I think this warning can be removed because it's not boot option problem
> after this patch. I guess the boot option can be obsolete....
> 

I think it is extremely useful, at least during the next couple of
releases. A lot of distributions will create memcgs for no apparent
reasons way before they are used (if used at all), as a placeholder only.

This can at least tell them that there is a way to stop paying a memory
penalty (together with the actual memory footprint)

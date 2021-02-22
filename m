From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Mon, 22 Feb 2021 10:38:27 -0800
Message-ID: <d141f9ec-5502-b011-167f-e24d891b0dfe@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen@linux.intel.com>
 <YC4BcsNFEmW7XeqB@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YC4BcsNFEmW7XeqB-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/17/21 9:56 PM, Johannes Weiner wrote:

>>  static inline void uncharge_gather_clear(struct uncharge_gather *ug)
>> @@ -6849,7 +6850,13 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>>  	 * exclusive access to the page.
>>  	 */
>>  
>> -	if (ug->memcg != page_memcg(page)) {
>> +	if (ug->memcg != page_memcg(page) ||
>> +	    /*
>> +	     * Update soft limit tree used in v1 cgroup in page batch for
>> +	     * the same node. Relevant only to v1 cgroup with a soft limit.
>> +	     */
>> +	    (ug->dummy_page && ug->nid != page_to_nid(page) &&
>> +	     ug->memcg->soft_limit != PAGE_COUNTER_MAX)) {
> 
> Sorry, I used weird phrasing in my last email.
> 
> Can you please preface the checks you're adding with a
> !cgroup_subsys_on_dfl(memory_cgrp_subsys) to static branch for
> cgroup1? The uncharge path is pretty hot, and this would avoid the
> runtime overhead on cgroup2 at least, which doesn't have the SL.
> 
> Also, do we need the ug->dummy_page check? It's only NULL on the first
> loop - where ug->memcg is NULL as well and the branch is taken anyway.
> 
> The soft limit check is also slightly cheaper than the nid check, as
> page_to_nid() might be out-of-line, so we should do it first. This?
> 
> 	/*
> 	 * Batch-uncharge all pages of the same memcg.
> 	 *
> 	 * Unless we're looking at a cgroup1 with a softlimit
> 	 * set: the soft limit trees are maintained per-node
> 	 * and updated on uncharge (via dummy_page), so keep
> 	 * batches confined to a single node as well.
> 	 */
> 	if (ug->memcg != page_memcg(page) ||
> 	    (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
> 	     ug->memcg->soft_limit != PAGE_COUNTER_MAX &&
> 	     ug->nid != page_to_nid(page)))
> 

Johannes,

Thanks for your feedback.  Since Michal has concerns about the overhead
this patch could incur, I think we'll hold the patch for now.  If later
on Michal think that this patch is a good idea, I'll incorporate these
changes you suggested.

Tim

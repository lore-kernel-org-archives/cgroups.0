From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Tue, 9 Feb 2021 14:34:07 -0800
Message-ID: <3445ebcd-bc69-ec6e-8995-c95753b5c4a7@linux.intel.com>
References: <cover.1612902157.git.tim.c.chen@linux.intel.com>
 <3b6e4e9aa8b3ee1466269baf23ed82d90a8f791c.1612902157.git.tim.c.chen@linux.intel.com>
 <YCMLEB/2IscnaGGh@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YCMLEB/2IscnaGGh-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/9/21 2:22 PM, Johannes Weiner wrote:
> Hello Tim,
> 
> On Tue, Feb 09, 2021 at 12:29:47PM -0800, Tim Chen wrote:
>> @@ -6849,7 +6850,9 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>>  	 * exclusive access to the page.
>>  	 */
>>  
>> -	if (ug->memcg != page_memcg(page)) {
>> +	if (ug->memcg != page_memcg(page) ||
>> +	    /* uncharge batch update soft limit tree on a node basis */
>> +	    (ug->dummy_page && ug->nid != page_to_nid(page))) {
> 
> The fix makes sense to me.
> 
> However, unconditionally breaking up the batch by node can
> unnecessarily regress workloads in cgroups that do not have a soft
> limit configured, and cgroup2 which doesn't have soft limits at
> all. Consider an interleaving allocation policy for example.
> 
> Can you please further gate on memcg->soft_limit != PAGE_COUNTER_MAX,
> or at least on !cgroup_subsys_on_dfl(memory_cgrp_subsys)?
> 

Sure.  Will fix this.

Tim

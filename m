From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/7] lru: add an element to a memcg list
Date: Fri, 15 Feb 2013 14:57:09 +0400
Message-ID: <511E1485.5080109@parallels.com>
References: <1360328857-28070-1-git-send-email-glommer@parallels.com> <1360328857-28070-4-git-send-email-glommer@parallels.com> <xr93txpemkeo.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93txpemkeo.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Dave Shrinnker <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 02/15/2013 05:32 AM, Greg Thelen wrote:
> On Fri, Feb 08 2013, Glauber Costa wrote:
> 
>> With the infrastructure we now have, we can add an element to a memcg
>> LRU list instead of the global list. The memcg lists are still
>> per-node.
> 
> [...]
> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index b9e1941..bfb4b5b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3319,6 +3319,36 @@ static inline void memcg_resume_kmem_account(void)
>>  	current->memcg_kmem_skip_account--;
>>  }
>>  
>> +static struct mem_cgroup *mem_cgroup_from_kmem_page(struct page *page)
>> +{
>> +	struct page_cgroup *pc;
>> +	struct mem_cgroup *memcg = NULL;
>> +
>> +	pc = lookup_page_cgroup(page);
>> +	if (!PageCgroupUsed(pc))
>> +		return NULL;
>> +
>> +	lock_page_cgroup(pc);
>> +	if (PageCgroupUsed(pc))
>> +		memcg = pc->mem_cgroup;
>> +	unlock_page_cgroup(pc);
> 
> Once we drop the lock, is there anything that needs protection
> (e.g. PageCgroupUsed)?  If there's no problem, then what's the point of
> taking the lock?
> 

This is the same pattern already used in the rest of memcg, and I just
transposing it here. From my understanding, we need to make sure that if
the Used bit is not set, we don't rely on the memcg information. So we
take the lock to guarantee that the big is not cleared in the meantime.
But after that, we should be fine.

Kame, you have any input?



From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 3/5] memcg: make it suck faster
Date: Wed, 06 Mar 2013 19:54:33 +0900
Message-ID: <51372069.7070607@jp.fujitsu.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com> <1362489058-3455-4-git-send-email-glommer@parallels.com> <513691CD.3070806@jp.fujitsu.com> <5137007E.7030004@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5137007E.7030004-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

(2013/03/06 17:38), Glauber Costa wrote:
> 
>>
>>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>>> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
>>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>
>> After quick look, it seems most parts are good. But I have a concern.
>>
>> At memcg enablement, you move the numbers from vm_stat[] to res_counters.
>>
> Not only to res_counters. Mostly to mem_cgroup_stat_cpu, but I do move
> to res_counters as well.
> 
>> Why you need it ? It's not explained.
> 
> Because at this point, the bypass will no longer be in effect and we
> need accurate figures in root cgroup about what happened so far.
> 
> If we always have root-level hierarchy, then the bypass could go on
> forever. But if we have not, we'll need to rely on whatever was in there.
> 
>> And if it's necessary, uncharge will leak because page_cgroup is not marked
>> as PCG_USED, pc->mem_cgroup == NULL. So, res.usage will not be decreased.
>>
> 
> The same problem happen when deriving an mz from a page. Since
> pc->mem_cgroup will be NULL. I am interpreting that as "root mem cgroup".
> 
yes.

> Maybe even better would be to scan page cgroup writing a magic. Then if
> we see that magic we are sure it is an uninitialized pc.
> 
>> Could you fix it if you need to move numbers to res_counter ?
>>
> 
> At least for the pages in LRUs, I can scan them all, and update their
> page information. I am just wondering if this isn't a *very* expensive
> operation. Fine that we do it once, but still, is potentially scanning
> *all* pages in the system.
> 
> So I've basically decided it is better to interpret pc->mem_cgroup =
> NULL as this uninitialized state. (and can change to a magic)
> 

I think it can work. 

Thanks,
-Kame




From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Wed, 14 Apr 2021 17:42:39 -0700
Message-ID: <ec5d5da8-bfc8-cd7a-7959-ee86d4e01bfa@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <YGwlGrHtDJPQF7UG@dhcp22.suse.cz>
 <c615a610-eb4b-7e1e-16d1-4bc12938b08a@linux.intel.com>
 <YG7ugXZZ9BcXyGGk@dhcp22.suse.cz>
 <58e5dcc9-c134-78de-6965-7980f8596b57@linux.intel.com>
 <CALvZod4zXB6-3Mshu_TnTsQaDErfYkPTw9REYNRptSvPSRmKVA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvZod4zXB6-3Mshu_TnTsQaDErfYkPTw9REYNRptSvPSRmKVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>



On 4/12/21 12:20 PM, Shakeel Butt wrote:

>>
>> memory_t0.current       Current usage of tier 0 memory by the cgroup.
>>
>> memory_t0.min           If tier 0 memory used by the cgroup falls below this low
>>                         boundary, the memory will not be subjected to demotion
>>                         to lower tiers to free up memory at tier 0.
>>
>> memory_t0.low           Above this boundary, the tier 0 memory will be subjected
>>                         to demotion.  The demotion pressure will be proportional
>>                         to the overage.
>>
>> memory_t0.high          If tier 0 memory used by the cgroup exceeds this high
>>                         boundary, allocation of tier 0 memory by the cgroup will
>>                         be throttled. The tier 0 memory used by this cgroup
>>                         will also be subjected to heavy demotion.
>>
>> memory_t0.max           This will be a hard usage limit of tier 0 memory on the cgroup.
>>
>> If needed, memory_t[12...].current/min/low/high for additional tiers can be added.
>> This follows closely with the design of the general memory controller interface.
>>
>> Will such an interface looks sane and acceptable with everyone?
>>
> 
> I have a couple of questions. Let's suppose we have a two socket
> system. Node 0 (DRAM+CPUs), Node 1 (DRAM+CPUs), Node 2 (PMEM on socket
> 0 along with Node 0) and Node 3 (PMEM on socket 1 along with Node 1).
> Based on the tier definition of this patch series, tier_0: {node_0,
> node_1} and tier_1: {node_2, node_3}.
> 
> My questions are:
> 
> 1) Can we assume that the cost of access within a tier will always be
> less than the cost of access from the tier? (node_0 <-> node_1 vs
> node_0 <-> node_2)

I do assume that higher tier memory offers better performance (or less
access latency) than a lower tier memory.  Otherwise, this defeats the
whole purpose of promoting hot memory from lower tier to a higher tier,
and demoting cold memory to a lower tier.

Tiers assumption is embedded once we define this promotion/demotion relationship
between the numa nodes.

So if 

  node_m ----demotes----> node_n
         <---promotes---- 

then node_m is one tier higher tier than node_n. This promotion/demotion
relationship between the nodes is the underpinning of Dave and Ying's
demotion and promotion patch sets.  

> 2) If yes to (1), is that assumption future proof? Will the future
> systems with DRAM over CXL support have the same characteristics?

I think if you configure a promotion/demotion relationship between
DRAM over CXL and local-socket connected DRAM, you could divide them
up into separate tiers.  Or you don't care about the difference and
you will configure them not to have a promotion/demotion relationship
and they will be at the same tier.  Balance within the same tier
will be effected by the autonuma mechanism.

> 3) Will the cost of access from tier_0 to tier_1 be uniform? (node_0
> <-> node_2 vs node_0 <-> node_3). For jobs running on node_0, node_3
> might be third tier and similarly for jobs running on node_1, node_2
> might be third tier.

Tier definition is an admin's choice, of where the admin think the
hot memory should reside after looking at the memory performance.
It falls out of how the admin construct the promotion/demotion relationship
between the nodes and OS does not assume the tier relationship from
memory performance directly. 

> 
> The reason I am asking these questions is that the statically
> partitioning memory nodes into tiers will inherently add platform
> specific assumptions in the user API.
> 
> Assumptions like:
> 1) Access within tier is always cheaper than across tier.
> 2) Access from tier_i to tier_i+1 has uniform cost.
> 
> The reason I am more inclined towards having numa centric control is
> that we don't have to make these assumptions. Though the usability
> will be more difficult. Greg (CCed) has some ideas on making it better
> and we will share our proposal after polishing it a bit more.
> 

I am still trying to understand how a numa centric control actually
work. Putting limits on every numa node for each cgroup
seems to make the system configuration quite complicated.  Looking
forward to your proposal so I can better understand that perspective.

Tim 

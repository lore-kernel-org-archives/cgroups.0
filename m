From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Fri, 9 Apr 2021 16:26:53 -0700
Message-ID: <58e5dcc9-c134-78de-6965-7980f8596b57@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <YGwlGrHtDJPQF7UG@dhcp22.suse.cz>
 <c615a610-eb4b-7e1e-16d1-4bc12938b08a@linux.intel.com>
 <YG7ugXZZ9BcXyGGk@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YG7ugXZZ9BcXyGGk-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 4/8/21 4:52 AM, Michal Hocko wrote:

>> The top tier memory used is reported in
>>
>> memory.toptier_usage_in_bytes
>>
>> The amount of top tier memory usable by each cgroup without
>> triggering page reclaim is controlled by the
>>
>> memory.toptier_soft_limit_in_bytes 
> 

Michal,

Thanks for your comments.  I will like to take a step back and
look at the eventual goal we envision: a mechanism to partition the 
tiered memory between the cgroups. 

A typical use case may be a system with two set of tasks.
One set of task is very latency sensitive and we desire instantaneous
response from them. Another set of tasks will be running batch jobs
were latency and performance is not critical.   In this case,
we want to carve out enough top tier memory such that the working set
of the latency sensitive tasks can fit entirely in the top tier memory.
The rest of the top tier memory can be assigned to the background tasks.  

To achieve such cgroup based tiered memory management, we probably want
something like the following.

For generalization let's say that there are N tiers of memory t_0, t_1 ... t_N-1,
where tier t_0 sits at the top and demotes to the lower tier. 
We envision for this top tier memory t0 the following knobs and counters 
in the cgroup memory controller

memory_t0.current 	Current usage of tier 0 memory by the cgroup.

memory_t0.min		If tier 0 memory used by the cgroup falls below this low
			boundary, the memory will not be subjected to demotion
			to lower tiers to free up memory at tier 0.  

memory_t0.low		Above this boundary, the tier 0 memory will be subjected
			to demotion.  The demotion pressure will be proportional
			to the overage.

memory_t0.high		If tier 0 memory used by the cgroup exceeds this high
			boundary, allocation of tier 0 memory by the cgroup will
			be throttled. The tier 0 memory used by this cgroup
			will also be subjected to heavy demotion.

memory_t0.max		This will be a hard usage limit of tier 0 memory on the cgroup.

If needed, memory_t[12...].current/min/low/high for additional tiers can be added.
This follows closely with the design of the general memory controller interface.  

Will such an interface looks sane and acceptable with everyone?

The patch set I posted is meant to be a straw man cgroup v1 implementation
and I readily admits that it falls short of the eventual functionality 
we want to achieve.  It is meant to solicit feedback from everyone on how the tiered
memory management should work.

> Are you trying to say that soft limit acts as some sort of guarantee?

No, the soft limit does not offers guarantee.  It will only serves to keep the usage
of the top tier memory in the vicinity of the soft limits.

> Does that mean that if the memcg is under memory pressure top tiear
> memory is opted out from any reclaim if the usage is not in excess?

In the prototype implementation, regular memory reclaim is still in effect
if we are under heavy memory pressure. 

> 
> From you previous email it sounds more like the limit is evaluated on
> the global memory pressure to balance specific memcgs which are in
> excess when trying to reclaim/demote a toptier numa node.

On a top tier node, if the free memory on the node falls below a percentage, then
we will start to reclaim/demote from the node.

> 
> Soft limit reclaim has several problems. Those are historical and
> therefore the behavior cannot be changed. E.g. go after the biggest
> excessed memcg (with priority 0 - aka potential full LRU scan) and then
> continue with a normal reclaim. This can be really disruptive to the top
> user.

Thanks for pointing out these problems with soft limit explicitly.

> 
> So you can likely define a more sane semantic. E.g. push back memcgs
> proporitional to their excess but then we have two different soft limits
> behavior which is bad as well. I am not really sure there is a sensible
> way out by (ab)using soft limit here.
> 
> Also I am not really sure how this is going to be used in practice.
> There is no soft limit by default. So opting in would effectivelly
> discriminate those memcgs. There has been a similar problem with the
> soft limit we have in general. Is this really what you are looing for?
> What would be a typical usecase?

>> Want to make sure I understand what you mean by NUMA aware limits.
>> Yes, in the patch set, it does treat the NUMA nodes differently.
>> We are putting constraint on the "top tier" RAM nodes vs the lower
>> tier PMEM nodes.  Is this what you mean?
> 
> What I am trying to say (and I have brought that up when demotion has been
> discussed at LSFMM) is that the implementation shouldn't be PMEM aware.
> The specific technology shouldn't be imprinted into the interface.
> Fundamentally you are trying to balance memory among NUMA nodes as we do
> not have other abstraction to use. So rather than talking about top,
> secondary, nth tier we have different NUMA nodes with different
> characteristics and you want to express your "priorities" for them.

With node priorities, how would the system reserve enough
high performance memory for those performance critical task cgroup? 

By priority, do you mean the order of allocation of nodes for a cgroup?
Or you mean that all the similar performing memory node will be grouped in
the same priority?

Tim

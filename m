From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Wed, 7 Apr 2021 15:33:26 -0700
Message-ID: <c615a610-eb4b-7e1e-16d1-4bc12938b08a@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <YGwlGrHtDJPQF7UG@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YGwlGrHtDJPQF7UG-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 4/6/21 2:08 AM, Michal Hocko wrote:
> On Mon 05-04-21 10:08:24, Tim Chen wrote:
> [...]
>> To make fine grain cgroup based management of the precious top tier
>> DRAM memory possible, this patchset adds a few new features:
>> 1. Provides memory monitors on the amount of top tier memory used per cgroup 
>>    and by the system as a whole.
>> 2. Applies soft limits on the top tier memory each cgroup uses 
>> 3. Enables kswapd to demote top tier pages from cgroup with excess top
>>    tier memory usages.
> 

Michal,

Thanks for giving your feedback.  Much appreciated.

> Could you be more specific on how this interface is supposed to be used?

We created a README section on the cgroup control part of this patchset:
https://git.kernel.org/pub/scm/linux/kernel/git/vishal/tiering.git/commit/?h=tiering-0.71&id=20f20be02671384470c7cd8f66b56a9061a4071f
to illustrate how this interface should be used.

The top tier memory used is reported in

memory.toptier_usage_in_bytes

The amount of top tier memory usable by each cgroup without
triggering page reclaim is controlled by the

memory.toptier_soft_limit_in_bytes 

knob for each cgroup.  

We anticipate that for cgroup v2, we will have

memory_toptier.max  (max allowed top tier memory)
memory_toptier.high (aggressive page demotion from top tier memory)
memory_toptier.min  (not to page demote from top tier memory at this threshold) 

this is analogous to existing controllers
memory.max, memory.high and memory.min

> 
>> This allows us to provision different amount of top tier memory to each
>> cgroup according to the cgroup's latency need.
>>
>> The patchset is based on cgroup v1 interface. One shortcoming of the v1
>> interface is the limit on the cgroup is a soft limit, so a cgroup can
>> exceed the limit quite a bit before reclaim before page demotion reins
>> it in. 
> 
> I have to say that I dislike abusing soft limit reclaim for this. In the
> past we have learned that the existing implementation is unfixable and
> changing the existing semantic impossible due to backward compatibility.
> So I would really prefer the soft limit just find its rest rather than
> see new potential usecases.

Do you think we can reuse some of the existing soft reclaim machinery
for the v2 interface?

More particularly, can we treat memory_toptier.high in cgroup v2 as a soft limit?
We sort how much each mem cgroup exceeds memory_toptier.high and
go after the cgroup that have largest excess first for page demotion.
Will appreciate if you can shed some insights on what could go wrong
with such an approach. 

> 
> I haven't really looked into details of this patchset but from a cursory
> look it seems like you are actually introducing a NUMA aware limits into
> memcg that would control consumption from some nodes differently than
> other nodes. This would be rather alien concept to the existing memcg
> infrastructure IMO. It looks like it is fusing borders between memcg and
> cputset controllers.

Want to make sure I understand what you mean by NUMA aware limits.
Yes, in the patch set, it does treat the NUMA nodes differently.
We are putting constraint on the "top tier" RAM nodes vs the lower
tier PMEM nodes.  Is this what you mean?  I can see it does has
some flavor of cpuset controller.  In this case, it doesn't explicitly
set a node as allowed or forbidden as in cpuset, but put some constraints
on the usage of a group of nodes.  

Do you have suggestions on alternative controller for allocating tiered memory resource?


> 
> You also seem to be basing the interface on the very specific usecase.
> Can we expect that there will be many different tiers requiring their
> own balancing?
> 

You mean more than two tiers of memory? We did think a bit about system
that has stuff like high bandwidth memory that's faster than DRAM.
Our thought is usage and freeing of those memory will require 
explicit assignment (not used by default), so will be outside the
realm of auto balancing.  So at this point, we think two tiers will be good.

Tim

From: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 26 Feb 2020 15:59:23 -0800
Message-ID: <1bfd6ea4-f012-5778-64c6-36731e69b5ba@linux.alibaba.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>



On 2/26/20 12:25 PM, Shakeel Butt wrote:
> On Wed, Feb 19, 2020 at 10:12 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>> We have received regression reports from users whose workloads moved
>> into containers and subsequently encountered new latencies. For some
>> users these were a nuisance, but for some it meant missing their SLA
>> response times. We tracked those delays down to cgroup limits, which
>> inject direct reclaim stalls into the workload where previously all
>> reclaim was handled my kswapd.
>>
>> This patch adds asynchronous reclaim to the memory.high cgroup limit
>> while keeping direct reclaim as a fallback. In our testing, this
>> eliminated all direct reclaim from the affected workload.
>>
>> memory.high has a grace buffer of about 4% between when it becomes
>> exceeded and when allocating threads get throttled. We can use the
>> same buffer for the async reclaimer to operate in. If the worker
>> cannot keep up and the grace buffer is exceeded, allocating threads
>> will fall back to direct reclaim before getting throttled.
>>
>> For irq-context, there's already async memory.high enforcement. Re-use
>> that work item for all allocating contexts, but switch it to the
>> unbound workqueue so reclaim work doesn't compete with the workload.
>> The work item is per cgroup, which means the workqueue infrastructure
>> will create at maximum one worker thread per reclaiming cgroup.
>>
>> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> ---
>>   mm/memcontrol.c | 60 +++++++++++++++++++++++++++++++++++++------------
>>   mm/vmscan.c     | 10 +++++++--
> This reminds me of the per-memcg kswapd proposal from LSFMM 2018
> (https://lwn.net/Articles/753162/).

Thanks for bringing this up.

>
> If I understand this correctly, the use-case is that the job instead
> of direct reclaiming (potentially in latency sensitive tasks), prefers
> a background non-latency sensitive task to do the reclaim. I am
> wondering if we can use the memory.high notification along with a new
> memcg interface (like memory.try_to_free_pages) to implement a user
> space background reclaimer. That would resolve the cpu accounting
> concerns as the user space background reclaimer can share the cpu cost
> with the task.

Actually I'm interested how you implement userspace reclaimer. Via a new 
syscall or a variant of existing syscall?

>
> One concern with this approach will be that the memory.high
> notification is too late and the latency sensitive task has faced the
> stall. We can either introduce a threshold notification or another
> notification only limit like memory.near_high which can be set based
> on the job's rate of allocations and when the usage hits this limit
> just notify the user space.

Yes, the solo purpose of background reclaimer is to avoid direct reclaim 
for latency sensitive workloads. Our in-house implementation has high 
watermark and low watermark, both of which is lower than limit or high. 
The background reclaimer would be triggered once available memory is 
reached low watermark, then keep reclaimed until available memory is 
reached high watermark. It is pretty same with how global water mark works.

>
> Shakeel


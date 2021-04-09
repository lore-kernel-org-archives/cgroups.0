From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered memory
Date: Fri, 09 Apr 2021 10:58:03 +0800
Message-ID: <87eefkxiys.fsf@yhuang6-desk1.ccr.corp.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
        <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg@mail.gmail.com>
        <CAHbLzkrPD6s9vRy89cgQ36e+1cs6JbLqV84se7nnvP9MByizXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHbLzkrPD6s9vRy89cgQ36e+1cs6JbLqV84se7nnvP9MByizXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Yang Shi's message of "Thu, 8 Apr 2021 11:00:54 -0700")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> On Thu, Apr 8, 2021 at 10:19 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Hi Tim,
>>
>> On Mon, Apr 5, 2021 at 11:08 AM Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> >
>> > Traditionally, all memory is DRAM.  Some DRAM might be closer/faster than
>> > others NUMA wise, but a byte of media has about the same cost whether it
>> > is close or far.  But, with new memory tiers such as Persistent Memory
>> > (PMEM).  there is a choice between fast/expensive DRAM and slow/cheap
>> > PMEM.
>> >
>> > The fast/expensive memory lives in the top tier of the memory hierachy.
>> >
>> > Previously, the patchset
>> > [PATCH 00/10] [v7] Migrate Pages in lieu of discard
>> > https://lore.kernel.org/linux-mm/20210401183216.443C4443-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org/
>> > provides a mechanism to demote cold pages from DRAM node into PMEM.
>> >
>> > And the patchset
>> > [PATCH 0/6] [RFC v6] NUMA balancing: optimize memory placement for memory tiering system
>> > https://lore.kernel.org/linux-mm/20210311081821.138467-1-ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
>> > provides a mechanism to promote hot pages in PMEM to the DRAM node
>> > leveraging autonuma.
>> >
>> > The two patchsets together keep the hot pages in DRAM and colder pages
>> > in PMEM.
>>
>> Thanks for working on this as this is becoming more and more important
>> particularly in the data centers where memory is a big portion of the
>> cost.
>>
>> I see you have responded to Michal and I will add my more specific
>> response there. Here I wanted to give my high level concern regarding
>> using v1's soft limit like semantics for top tier memory.
>>
>> This patch series aims to distribute/partition top tier memory between
>> jobs of different priorities. We want high priority jobs to have
>> preferential access to the top tier memory and we don't want low
>> priority jobs to hog the top tier memory.
>>
>> Using v1's soft limit like behavior can potentially cause high
>> priority jobs to stall to make enough space on top tier memory on
>> their allocation path and I think this patchset is aiming to reduce
>> that impact by making kswapd do that work. However I think the more
>> concerning issue is the low priority job hogging the top tier memory.
>>
>> The possible ways the low priority job can hog the top tier memory are
>> by allocating non-movable memory or by mlocking the memory. (Oh there
>> is also pinning the memory but I don't know if there is a user api to
>> pin memory?) For the mlocked memory, you need to either modify the
>> reclaim code or use a different mechanism for demoting cold memory.
>
> Do you mean long term pin? RDMA should be able to simply pin the
> memory for weeks. A lot of transient pins come from Direct I/O. They
> should be less concerned.
>
> The low priority jobs should be able to be restricted by cpuset, for
> example, just keep them on second tier memory nodes. Then all the
> above problems are gone.

To optimize the page placement of a process between DRAM and PMEM, we
want to place the hot pages in DRAM and the cold pages in PMEM.  But the
memory accessing pattern changes overtime, so we need to migrate pages
between DRAM and PMEM to adapt to the changing.

To avoid the hot pages be pinned in PMEM always, one way is to online
the PMEM as movable zones.  If so, and if the low priority jobs are
restricted by cpuset to allocate from PMEM only, we may fail to run
quite some workloads as being discussed in the following threads,

https://lore.kernel.org/linux-mm/1604470210-124827-1-git-send-email-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

>>
>> Basically I am saying we should put the upfront control (limit) on the
>> usage of top tier memory by the jobs.
>
> This sounds similar to what I talked about in LSFMM 2019
> (https://lwn.net/Articles/787418/). We used to have some potential
> usecase which divides DRAM:PMEM ratio for different jobs or memcgs
> when I was with Alibaba.
>
> In the first place I thought about per NUMA node limit, but it was
> very hard to configure it correctly for users unless you know exactly
> about your memory usage and hot/cold memory distribution.
>
> I'm wondering, just off the top of my head, if we could extend the
> semantic of low and min limit. For example, just redefine low and min
> to "the limit on top tier memory". Then we could have low priority
> jobs have 0 low/min limit.

Per my understanding, memory.low/min are for the memory protection
instead of the memory limiting.  memory.high is for the memory limiting.

Best Regards,
Huang, Ying

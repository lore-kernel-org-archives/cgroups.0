From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] mm, memcg: add mem_cgroup_disabled checks in
 vmpressure and swap-related functions
Date: Sat, 10 Jul 2021 11:37:27 +0800
Message-ID: <24966bfd-008f-3b48-36f7-4aa298057559@huawei.com>
References: <20210710003626.3549282-1-surenb@google.com>
 <b29493f5-34d9-6e8f-ec41-179a043641f4@huawei.com>
 <CAJuCfpEGEoA9Pb8iLdXNH9Q3fiGEaNkKWM6p+M1KzE69cmEJww@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJuCfpEGEoA9Pb8iLdXNH9Q3fiGEaNkKWM6p+M1KzE69cmEJww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2021/7/10 10:40, Suren Baghdasaryan wrote:
> On Fri, Jul 9, 2021 at 6:52 PM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On 2021/7/10 8:36, Suren Baghdasaryan wrote:
>>> Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap and
>>> cgroup_throttle_swaprate functions. This minimizes the memcg overhead in
>>> the pagefault and exit_mmap paths when memcgs are disabled using
>>> cgroup_disable=memory command-line option.
>>> This change results in ~2.1% overhead reduction when running PFT test
>>> comparing {CONFIG_MEMCG=n, CONFIG_MEMCG_SWAP=n} against {CONFIG_MEMCG=y,
>>> CONFIG_MEMCG_SWAP=y, cgroup_disable=memory} configuration on an 8-core
>>> ARM64 Android device.
>>>
>>> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>>> ---
>>>  mm/memcontrol.c | 3 +++
>>>  mm/swapfile.c   | 3 +++
>>>  mm/vmpressure.c | 7 ++++++-
>>>  3 files changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index ae1f5d0cb581..a228cd51c4bd 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -7305,6 +7305,9 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
>>>       struct mem_cgroup *memcg;
>>>       unsigned short id;
>>>
>>> +     if (mem_cgroup_disabled())
>>> +             return;
>>> +
>>>       id = swap_cgroup_record(entry, 0, nr_pages);
>>>       rcu_read_lock();
>>>       memcg = mem_cgroup_from_id(id);
>>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>>> index 1e07d1c776f2..707fa0481bb4 100644
>>> --- a/mm/swapfile.c
>>> +++ b/mm/swapfile.c
>>> @@ -3778,6 +3778,9 @@ void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
>>>       struct swap_info_struct *si, *next;
>>>       int nid = page_to_nid(page);
>>>
>>> +     if (mem_cgroup_disabled())
>>> +             return;
>>> +
>>
>> Many thanks for your patch. But I'am somewhat confused about this change.
>> IMO, cgroup_throttle_swaprate() is only related to blk_cgroup and it seems
>> it's irrelevant to mem_cgroup. Could you please have a explanation for me?
> 
> cgroup_throttle_swaprate() is a NoOp when CONFIG_MEMCG=n (see:
> https://elixir.bootlin.com/linux/latest/source/include/linux/swap.h#L699),

I browsed the git history related to cgroup_throttle_swaprate() and found this:

"""
mm: memcontrol: move out cgroup swaprate throttling

    The cgroup swaprate throttling is about matching new anon allocations to
    the rate of available IO when that is being throttled.  It's the io
    controller hooking into the VM, rather than a memory controller thing.
"""

It seems cgroup_throttle_swaprate() is working with memory allocations.
So mem_cgroup matters this way. But I'am not sure...

> therefore I assume we can safely skip it when memcgs are disabled via
> "cgroup_disable=memory". From perf results I also see no hits on this
> function when CONFIG_MEMCG=n.
> However, looking into the code, I'm not sure why it should depend on
> CONFIG_MEMCG. But it's Friday night and I might be missing some
> details here...

Many thanks for your replay at Friday night. :)

> 
>>
>> Thanks!
>>
>>>       if (!(gfp_mask & __GFP_IO))
>>>               return;
>>>
>>> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
>>> index d69019fc3789..9b172561fded 100644
>>> --- a/mm/vmpressure.c
>>> +++ b/mm/vmpressure.c
>>> @@ -240,7 +240,12 @@ static void vmpressure_work_fn(struct work_struct *work)
>>>  void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>>>               unsigned long scanned, unsigned long reclaimed)
>>>  {
>>> -     struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
>>> +     struct vmpressure *vmpr;
>>> +
>>> +     if (mem_cgroup_disabled())
>>> +             return;
>>> +
>>> +     vmpr = memcg_to_vmpressure(memcg);
>>>
>>>       /*
>>>        * Here we only want to account pressure that userland is able to
>>>
>>
> .
> 


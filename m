From: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 17:48:59 +0800
Message-ID: <bd926b17-45c2-53bc-3c61-cda3ae442312@huawei.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <2025405d-c32b-338a-b668-48b07a34e4ef@huawei.com>
 <CAJD7tkZHxRY0GEhcRoa8PqLM7pnsu44_U9XKV-9u==iGqwf3=g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJD7tkZHxRY0GEhcRoa8PqLM7pnsu44_U9XKV-9u==iGqwf3=g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>



在 2022/4/1 17:20, Yosry Ahmed 写道:
> On Thu, Mar 31, 2022 at 8:05 PM Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>
>>
>> 在 2022/3/31 16:41, Yosry Ahmed 写道:
>>> From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>
>>> Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
>>>
>>> Use case: Proactive Reclaim
>>> ---------------------------
>>>
>>> A userspace proactive reclaimer can continuously probe the memcg to
>>> reclaim a small amount of memory. This gives more accurate and
>>> up-to-date workingset estimation as the LRUs are continuously
>>> sorted and can potentially provide more deterministic memory
>>> overcommit behavior. The memory overcommit controller can provide
>>> more proactive response to the changing behavior of the running
>>> applications instead of being reactive.
>>>
>>> A userspace reclaimer's purpose in this case is not a complete replacement
>>> for kswapd or direct reclaim, it is to proactively identify memory savings
>>> opportunities and reclaim some amount of cold pages set by the policy
>>> to free up the memory for more demanding jobs or scheduling new jobs.
>>>
>>> A user space proactive reclaimer is used in Google data centers.
>>> Additionally, Meta's TMO paper recently referenced a very similar
>>> interface used for user space proactive reclaim:
>>> https://dl.acm.org/doi/pdf/10.1145/3503222.3507731
>>>
>>> Benefits of a user space reclaimer:
>>> -----------------------------------
>>>
>>> 1) More flexible on who should be charged for the cpu of the memory
>>> reclaim. For proactive reclaim, it makes more sense to be centralized.
>>>
>>> 2) More flexible on dedicating the resources (like cpu). The memory
>>> overcommit controller can balance the cost between the cpu usage and
>>> the memory reclaimed.
>>>
>>> 3) Provides a way to the applications to keep their LRUs sorted, so,
>>> under memory pressure better reclaim candidates are selected. This also
>>> gives more accurate and uptodate notion of working set for an
>>> application.
>>>
>>> Why memory.high is not enough?
>>> ------------------------------
>>>
>>> - memory.high can be used to trigger reclaim in a memcg and can
>>>     potentially be used for proactive reclaim.
>>>     However there is a big downside in using memory.high. It can potentially
>>>     introduce high reclaim stalls in the target application as the
>>>     allocations from the processes or the threads of the application can hit
>>>     the temporary memory.high limit.
>>>
>>> - Userspace proactive reclaimers usually use feedback loops to decide
>>>     how much memory to proactively reclaim from a workload. The metrics
>>>     used for this are usually either refaults or PSI, and these metrics
>>>     will become messy if the application gets throttled by hitting the
>>>     high limit.
>>>
>>> - memory.high is a stateful interface, if the userspace proactive
>>>     reclaimer crashes for any reason while triggering reclaim it can leave
>>>     the application in a bad state.
>>>
>>> - If a workload is rapidly expanding, setting memory.high to proactively
>>>     reclaim memory can result in actually reclaiming more memory than
>>>     intended.
>>>
>>> The benefits of such interface and shortcomings of existing interface
>>> were further discussed in this RFC thread:
>>> https://lore.kernel.org/linux-mm/5df21376-7dd1-bf81-8414-32a73cea45dd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
>>>
>>> Interface:
>>> ----------
>>>
>>> Introducing a very simple memcg interface 'echo 10M > memory.reclaim' to
>>> trigger reclaim in the target memory cgroup.
>>>
>>>
>>> Possible Extensions:
>>> --------------------
>>>
>>> - This interface can be extended with an additional parameter or flags
>>>     to allow specifying one or more types of memory to reclaim from (e.g.
>>>     file, anon, ..).
>>>
>>> - The interface can also be extended with a node mask to reclaim from
>>>     specific nodes. This has use cases for reclaim-based demotion in memory
>>>     tiering systens.
>>>
>>> - A similar per-node interface can also be added to support proactive
>>>     reclaim and reclaim-based demotion in systems without memcg.
>>>
>>> For now, let's keep things simple by adding the basic functionality.
>>>
>>> [yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org: refreshed to current master, updated commit
>>> message based on recent discussions and use cases]
>>> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>    Documentation/admin-guide/cgroup-v2.rst |  9 ++++++
>>>    mm/memcontrol.c                         | 37 +++++++++++++++++++++++++
>>>    2 files changed, 46 insertions(+)
>>>
>>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>>> index 69d7a6983f78..925aaabb2247 100644
>>> --- a/Documentation/admin-guide/cgroup-v2.rst
>>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>>> @@ -1208,6 +1208,15 @@ PAGE_SIZE multiple when read back.
>>>        high limit is used and monitored properly, this limit's
>>>        utility is limited to providing the final safety net.
>>>
>>> +  memory.reclaim
>>> +     A write-only file which exists on non-root cgroups.
>>> +
>>> +     This is a simple interface to trigger memory reclaim in the
>>> +     target cgroup. Write the number of bytes to reclaim to this
>>> +     file and the kernel will try to reclaim that much memory.
>>> +     Please note that the kernel can over or under reclaim from
>>> +     the target cgroup.
>>> +
>>>      memory.oom.group
>>>        A read-write single value file which exists on non-root
>>>        cgroups.  The default value is "0".
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 725f76723220..994849fab7df 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -6355,6 +6355,38 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
>>>        return nbytes;
>>>    }
>>>
>>> +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>>> +                           size_t nbytes, loff_t off)
>>> +{
>>> +     struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>>> +     unsigned int nr_retries = MAX_RECLAIM_RETRIES;
>>> +     unsigned long nr_to_reclaim, nr_reclaimed = 0;
>>> +     int err;
>>> +
>>> +     buf = strstrip(buf);
>>> +     err = page_counter_memparse(buf, "", &nr_to_reclaim);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     while (nr_reclaimed < nr_to_reclaim) {
>>> +             unsigned long reclaimed;
>>> +
>>> +             if (signal_pending(current))
>>> +                     break;
>>> +
>>> +             reclaimed = try_to_free_mem_cgroup_pages(memcg,
>>> +                                             nr_to_reclaim - nr_reclaimed,
>>> +                                             GFP_KERNEL, true);
>> In some scenario there are lots of page cache,  and we only want to
>> reclaim page cache,
>> how about add may_swap option?
> Thanks for taking a look at this!
>
> The first listed extension is an argument/flags to specify the type of
do you mean nbytes in  memory_reclaim? it decide the amount of memory
to reclaim.

one more argument such as may_swap can be add into memory_reclaim, and
pass this argument to try_to_free_mem_cgroup_pages in order to replace the
default "true"

Thanks.

> memory that we want to reclaim, I think this covers this use case, or
> am I missing something?
>
>>> +
>>> +             if (!reclaimed && !nr_retries--)
>>> +                     break;
>>> +
>>> +             nr_reclaimed += reclaimed;
>>> +     }
>>> +
>>> +     return nbytes;
>>> +}
>>> +
>>>    static struct cftype memory_files[] = {
>>>        {
>>>                .name = "current",
>>> @@ -6413,6 +6445,11 @@ static struct cftype memory_files[] = {
>>>                .seq_show = memory_oom_group_show,
>>>                .write = memory_oom_group_write,
>>>        },
>>> +     {
>>> +             .name = "reclaim",
>>> +             .flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
>>> +             .write = memory_reclaim,
>>> +     },
>>>        { }     /* terminate */
>>>    };
>>>
> .


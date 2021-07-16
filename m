From: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] memcg: infrastructure to flush memcg stats
Date: Fri, 16 Jul 2021 17:58:37 +0200
Message-ID: <75599651-b3eb-45a7-56c8-f83546650c94@samsung.com>
References: <20210714013948.270662-1-shakeelb@google.com>
        <CGME20210716150353eucas1p2c9ad1d1021ee584de587e5ec10b8467b@eucas1p2.samsung.com>
        <20210714013948.270662-2-shakeelb@google.com>
        <78005c4c-9233-7bc8-d50e-e3fe11f30b5d@samsung.com>
        <CALvZod5SONQ6=ewesLhMSampu=sxbA3iDS3f+rsHkEUY5G2Cyg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210716155839euoutp0276f63011465c0a730659bf5e89157c9f~SUKz6e4yA0500305003euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626451119;
        bh=+MzerVI9mU/S0yInCgp08mtqd2wbklS0uGBuLN3t2Eo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=YB/tnct5K/+cw6LPBp4gM99lKw6wQo22aVZQ6mD8ULfjVLYNw8bfNDQJO5HLxrYb6
         EXI+43iGv0uYhUqsV655dR1tDhjwueU/oqHrb0k6CSY7sepCPLUu3QMm5QHHGvHM19
         G4Vyj3pK9QI5RgOfOmLNe3T4FNO+sQ1gg+0rktb8=
In-Reply-To: <CALvZod5SONQ6=ewesLhMSampu=sxbA3iDS3f+rsHkEUY5G2Cyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On 16.07.2021 17:14, Shakeel Butt wrote:
> Hi Marek
>
> On Fri, Jul 16, 2021 at 8:03 AM Marek Szyprowski
> <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>> Hi,
>>
>> On 14.07.2021 03:39, Shakeel Butt wrote:
>>> At the moment memcg stats are read in four contexts:
>>>
>>> 1. memcg stat user interfaces
>>> 2. dirty throttling
>>> 3. page fault
>>> 4. memory reclaim
>>>
>>> Currently the kernel flushes the stats for first two cases. Flushing the
>>> stats for remaining two casese may have performance impact. Always
>>> flushing the memcg stats on the page fault code path may negatively
>>> impacts the performance of the applications. In addition flushing in the
>>> memory reclaim code path, though treated as slowpath, can become the
>>> source of contention for the global lock taken for stat flushing because
>>> when system or memcg is under memory pressure, many tasks may enter the
>>> reclaim path.
>>>
>>> This patch uses following mechanisms to solve these challenges:
>>>
>>> 1. Periodically flush the stats from root memcg every 2 seconds. This
>>> will time limit the out of sync stats.
>>>
>>> 2. Asynchronously flush the stats after fixed number of stat updates.
>>> In the worst case the stat can be out of sync by O(nr_cpus * BATCH) for
>>> 2 seconds.
>>>
>>> 3. For avoiding thundering herd to flush the stats particularly from the
>>> memory reclaim context, introduce memcg local spinlock and let only one
>>> flusher active at a time. This could have been done through
>>> cgroup_rstat_lock lock but that lock is used by other subsystem and for
>>> userspace reading memcg stats. So, it is better to keep flushers
>>> introduced by this patch decoupled from cgroup_rstat_lock.
>>>
>>> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> This patch landed in today's linux-next (next-20210716) as commit
>> 42265e014ac7 ("memcg: infrastructure to flush memcg stats"). On my test
>> system's I found that it triggers a kernel BUG on all ARM64 boards:
>>
>>    BUG: sleeping function called from invalid context at
>> kernel/cgroup/rstat.c:200
>>    in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 7, name:
>> kworker/u8:0
>>    3 locks held by kworker/u8:0/7:
>>     #0: ffff00004000c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
>> process_one_work+0x200/0x718
>>     #1: ffff80001334bdd0 ((stats_flush_dwork).work){+.+.}-{0:0}, at:
>> process_one_work+0x200/0x718
>>     #2: ffff8000124f6d40 (stats_flush_lock){+.+.}-{2:2}, at:
>> mem_cgroup_flush_stats+0x20/0x48
>>    CPU: 2 PID: 7 Comm: kworker/u8:0 Tainted: G        W 5.14.0-rc1+ #3713
>>    Hardware name: Raspberry Pi 4 Model B (DT)
>>    Workqueue: events_unbound flush_memcg_stats_dwork
>>    Call trace:
>>     dump_backtrace+0x0/0x1d0
>>     show_stack+0x14/0x20
>>     dump_stack_lvl+0x88/0xb0
>>     dump_stack+0x14/0x2c
>>     ___might_sleep+0x1dc/0x200
>>     __might_sleep+0x4c/0x88
>>     cgroup_rstat_flush+0x2c/0x58
>>     mem_cgroup_flush_stats+0x34/0x48
>>     flush_memcg_stats_dwork+0xc/0x38
>>     process_one_work+0x2a8/0x718
>>     worker_thread+0x48/0x460
>>     kthread+0x12c/0x160
>>     ret_from_fork+0x10/0x18
>>
>> This can be also reproduced with QEmu. Please let me know if I can help
>> fixing this issue.
>>
> Thanks for the report. The issue can be fixed by changing
> cgroup_rstat_flush() to cgroup_rstat_flush_irqsafe() in
> mem_cgroup_flush_stats(). I will send out the updated patch in a
> couple of hours after a bit more testing.

Right, this fixes the issue on my test systems. Feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Tested-by: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

to the fixup patch if the target kernel tree won't be rebased and the 
original patch (42265e014ac7) stays.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


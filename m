From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Thu, 5 Aug 2021 09:44:40 +0800
Message-ID: <6f64a114-eb95-39c2-c779-ac77d2becccb@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com> <YQNsxVPsRSBZcfGG@carbon.lan>
 <YQOhGs3k9rHx3mmT@dhcp22.suse.cz> <YQlPiLY0ieRb704V@cmpxchg.org>
 <YQpNtfjl0rHH8Mgf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YQpNtfjl0rHH8Mgf-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2021/8/4 16:20, Michal Hocko wrote:
> On Tue 03-08-21 10:15:36, Johannes Weiner wrote:
> [...]
>> git history shows we tried to remove it once:
>>
>> commit 8521fc50d433507a7cdc96bec280f9e5888a54cc
>> Author: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Date:   Tue Jul 26 16:08:29 2011 -0700
>>
>>     memcg: get rid of percpu_charge_mutex lock
>>
>> but it turned out that the lock did in fact protect a data structure:
>> the stock itself. Specifically stock->cached:
>>
>> commit 9f50fad65b87a8776ae989ca059ad6c17925dfc3
>> Author: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Date:   Tue Aug 9 11:56:26 2011 +0200
>>
>>     Revert "memcg: get rid of percpu_charge_mutex lock"
>>
>>     This reverts commit 8521fc50d433507a7cdc96bec280f9e5888a54cc.
>>
>>     The patch incorrectly assumes that using atomic FLUSHING_CACHED_CHARGE
>>     bit operations is sufficient but that is not true.  Johannes Weiner has
>>     reported a crash during parallel memory cgroup removal:
>>
>>       BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
>>       IP: [<ffffffff81083b70>] css_is_ancestor+0x20/0x70
>>       Oops: 0000 [#1] PREEMPT SMP
>>       Pid: 19677, comm: rmdir Tainted: G        W   3.0.0-mm1-00188-gf38d32b #35 ECS MCP61M-M3/MCP61M-M3
>>       RIP: 0010:[<ffffffff81083b70>]  css_is_ancestor+0x20/0x70
>>       RSP: 0018:ffff880077b09c88  EFLAGS: 00010202
>>       Process rmdir (pid: 19677, threadinfo ffff880077b08000, task ffff8800781bb310)
>>       Call Trace:
>>        [<ffffffff810feba3>] mem_cgroup_same_or_subtree+0x33/0x40
>>        [<ffffffff810feccf>] drain_all_stock+0x11f/0x170
>>        [<ffffffff81103211>] mem_cgroup_force_empty+0x231/0x6d0
>>        [<ffffffff811036c4>] mem_cgroup_pre_destroy+0x14/0x20
>>        [<ffffffff81080559>] cgroup_rmdir+0xb9/0x500
>>        [<ffffffff81114d26>] vfs_rmdir+0x86/0xe0
>>        [<ffffffff81114e7b>] do_rmdir+0xfb/0x110
>>        [<ffffffff81114ea6>] sys_rmdir+0x16/0x20
>>        [<ffffffff8154d76b>] system_call_fastpath+0x16/0x1b
>>
>>     We are crashing because we try to dereference cached memcg when we are
>>     checking whether we should wait for draining on the cache.  The cache is
>>     already cleaned up, though.
>>
>>     There is also a theoretical chance that the cached memcg gets freed
>>     between we test for the FLUSHING_CACHED_CHARGE and dereference it in
>>     mem_cgroup_same_or_subtree:
>>
>>             CPU0                    CPU1                         CPU2
>>       mem=stock->cached
>>       stock->cached=NULL
>>                                   clear_bit
>>                                                             test_and_set_bit
>>       test_bit()                    ...
>>       <preempted>             mem_cgroup_destroy
>>       use after free
>>
>>     The percpu_charge_mutex protected from this race because sync draining
>>     is exclusive.
>>
>>     It is safer to revert now and come up with a more parallel
>>     implementation later.
>>
>> I didn't remember this one at all!
> 
> Me neither. Thanks for looking that up!
> 
>> However, when you look at the codebase from back then, there was no
>> rcu-protection for memcg lifetime, and drain_stock() didn't double
>> check stock->cached inside the work. Hence the crash during a race.
>>
>> The drain code is different now: drain_local_stock() disables IRQs
>> which holds up rcu, and then calls drain_stock() and drain_obj_stock()
>> which both check stock->cached one more time before the deref.
>>
>> With workqueue managing concurrency, and rcu ensuring memcg lifetime
>> during the drain, this lock indeed seems unnecessary now.
>>
>> Unless I'm missing something, it should just be removed instead.
> 
> I do not think you are missing anything. We can drop the lock and
> simplify the code. The above information would be great to have in the
> changelog.
> 

Am I supposed to revert this with the above information in the changelog and add
Suggested-by for both of you?

Many thanks.

> Thanks!
> 


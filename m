From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Tue, 20 Apr 2021 08:45:59 +0200
Message-ID: <YH54pyRWSi1zLMw4@dhcp22.suse.cz>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618901161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZpEr8rucvyG2/a07JnpA9LV+PcWjdOeGmyGcfuA/fJY=;
        b=R4va9TNPMu33bK7ocxbSjbmNgjzfWarvCyngb/9y4qjds0cvNH7UMyTzxF1yagcKIkEvk2
        X6S8jUQniS1UeN/QZkr3pQqOh400CWqWslgxdP639bony98f9QgQ3DTGscYlF1BLI0ogpd
        vP1tbCgz6T7jJdxNMANKHw11uP4cktw=
Content-Disposition: inline
In-Reply-To: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon 19-04-21 18:44:02, Shakeel Butt wrote:
> Proposal: Provide memory guarantees to userspace oom-killer.
> 
> Background:
> 
> Issues with kernel oom-killer:
> 1. Very conservative and prefer to reclaim. Applications can suffer
> for a long time.
> 2. Borrows the context of the allocator which can be resource limited
> (low sched priority or limited CPU quota).
> 3. Serialized by global lock.
> 4. Very simplistic oom victim selection policy.
> 
> These issues are resolved through userspace oom-killer by:
> 1. Ability to monitor arbitrary metrics (PSI, vmstat, memcg stats) to
> early detect suffering.
> 2. Independent process context which can be given dedicated CPU quota
> and high scheduling priority.
> 3. Can be more aggressive as required.
> 4. Can implement sophisticated business logic/policies.
> 
> Android's LMKD and Facebook's oomd are the prime examples of userspace
> oom-killers. One of the biggest challenges for userspace oom-killers
> is to potentially function under intense memory pressure and are prone
> to getting stuck in memory reclaim themselves. Current userspace
> oom-killers aim to avoid this situation by preallocating user memory
> and protecting themselves from global reclaim by either mlocking or
> memory.min. However a new allocation from userspace oom-killer can
> still get stuck in the reclaim and policy rich oom-killer do trigger
> new allocations through syscalls or even heap.

Can you be more specific please?

> Our attempt of userspace oom-killer faces similar challenges.
> Particularly at the tail on the very highly utilized machines we have
> observed userspace oom-killer spectacularly failing in many possible
> ways in the direct reclaim. We have seen oom-killer stuck in direct
> reclaim throttling, stuck in reclaim and allocations from interrupts
> keep stealing reclaimed memory. We have even observed systems where
> all the processes were stuck in throttle_direct_reclaim() and only
> kswapd was running and the interrupts kept stealing the memory
> reclaimed by kswapd.
> 
> To reliably solve this problem, we need to give guaranteed memory to
> the userspace oom-killer.

There is nothing like that. Even memory reserves are a finite resource
which can be consumed as it is sharing those reserves with other users
who are not necessarily coordinated. So before we start discussing
making this even more muddy by handing over memory reserves to the
userspace we should really examine whether pre-allocation is something
that will not work.

> At the moment we are contemplating between
> the following options and I would like to get some feedback.
> 
> 1. prctl(PF_MEMALLOC)
> 
> The idea is to give userspace oom-killer (just one thread which is
> finding the appropriate victims and will be sending SIGKILLs) access
> to MEMALLOC reserves. Most of the time the preallocation, mlock and
> memory.min will be good enough but for rare occasions, when the
> userspace oom-killer needs to allocate, the PF_MEMALLOC flag will
> protect it from reclaim and let the allocation dip into the memory
> reserves.

I do not think that handing over an unlimited ticket to the memory
reserves to userspace is a good idea. Even the in kernel oom killer is
bound to a partial access to reserves. So if we really want this then
it should be in sync with and bound by the ALLOC_OOM.

> The misuse of this feature would be risky but it can be limited to
> privileged applications. Userspace oom-killer is the only appropriate
> user of this feature. This option is simple to implement.
> 
> 2. Mempool
> 
> The idea is to preallocate mempool with a given amount of memory for
> userspace oom-killer. Preferably this will be per-thread and
> oom-killer can preallocate mempool for its specific threads. The core
> page allocator can check before going to the reclaim path if the task
> has private access to the mempool and return page from it if yes.

Could you elaborate some more on how this would be controlled from the
userspace? A dedicated syscall? A driver?

> This option would be more complicated than the previous option as the
> lifecycle of the page from the mempool would be more sophisticated.
> Additionally the current mempool does not handle higher order pages
> and we might need to extend it to allow such allocations. Though this
> feature might have more use-cases and it would be less risky than the
> previous option.

I would tend to agree.

> Another idea I had was to use kthread based oom-killer and provide the
> policies through eBPF program. Though I am not sure how to make it
> monitor arbitrary metrics and if that can be done without any
> allocations.

A kernel module or eBPF to implement oom decisions has already been
discussed few years back. But I am afraid this would be hard to wire in
for anything except for the victim selection. I am not sure it is
maintainable to also control when the OOM handling should trigger.

-- 
Michal Hocko
SUSE Labs

From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Tue, 20 Apr 2021 12:17:58 -0700
Message-ID: <YH8o5iIau85FaeLw@carbon.DHCP.thefacebook.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+Nr8aTrUc4EEeXeaW3ifa+be2lW0Pv6b5f+8AnmPVMg=;
 b=nURjeuHbzPr9pUMcb/MbbeQvkpyHBpADsvmKXvyUHy3d+2yhqsc+GF+dBCMvtBIgqQGS
 jKduCeahu2kOl7CbNzBNIA9v9rVk7WcQqgxedfFiD7FOjtK0gaaPW/HMh2A4GcPn78kY
 U7tprq+qwIUafrqDdAK+UMiQUtXu25ThLho= 
Content-Disposition: inline
In-Reply-To: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Apr 19, 2021 at 06:44:02PM -0700, Shakeel Butt wrote:
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
> 
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
> the userspace oom-killer. At the moment we are contemplating between
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
> 
> The misuse of this feature would be risky but it can be limited to
> privileged applications. Userspace oom-killer is the only appropriate
> user of this feature. This option is simple to implement.

Hello Shakeel!

If ordinary PAGE_SIZE and smaller kernel allocations start to fail,
the system is already in a relatively bad shape. Arguably the userspace
OOM killer should kick in earlier, it's already a bit too late.
Allowing to use reserves just pushes this even further, so we're risking
the kernel stability for no good reason.

But I agree that throttling the oom daemon in direct reclaim makes no sense.
I wonder if we can introduce a per-task flag which will exclude the task from
throttling, but instead all (large) allocations will just fail under a
significant memory pressure more easily. In this case if there is a significant
memory shortage the oom daemon will not be fully functional (will get -ENOMEM
for an attempt to read some stats, for example), but still will be able to kill
some processes and make the forward progress.
But maybe it can be done in userspace too: by splitting the daemon into
a core- and extended part and avoid doing anything behind bare minimum
in the core part.

> 
> 2. Mempool
> 
> The idea is to preallocate mempool with a given amount of memory for
> userspace oom-killer. Preferably this will be per-thread and
> oom-killer can preallocate mempool for its specific threads. The core
> page allocator can check before going to the reclaim path if the task
> has private access to the mempool and return page from it if yes.
> 
> This option would be more complicated than the previous option as the
> lifecycle of the page from the mempool would be more sophisticated.
> Additionally the current mempool does not handle higher order pages
> and we might need to extend it to allow such allocations. Though this
> feature might have more use-cases and it would be less risky than the
> previous option.

It looks like an over-kill for the oom daemon protection, but if there
are other good use cases, maybe it's a good feature to have.

> 
> Another idea I had was to use kthread based oom-killer and provide the
> policies through eBPF program. Though I am not sure how to make it
> monitor arbitrary metrics and if that can be done without any
> allocations.

To start this effort it would be nice to understand what metrics various
oom daemons use and how easy is to gather them from the bpf side. I like
this idea long-term, but not sure if it has been settled down enough.
I imagine it will require a fair amount of work on the bpf side, so we
need a good understanding of features we need.

Thanks!

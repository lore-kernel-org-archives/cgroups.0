From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Tue, 20 Apr 2021 18:18:29 -0700
Message-ID: <CALvZod7dXuFPeMv5NGu96uCosFpWY_Gy07iDsfSORCA0dT_zsA@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH8o5iIau85FaeLw@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iuYkrU1zcW7Z65oSaWVLBz+0IZ221pOBrSimYNtby7s=;
        b=ndkdt3mjYlW+H/QWZc671xlRMDK4yybhmgXbvu53LBPocwBLlpjTZ783Rd2QVNzrGj
         IkSdWhxhBQo0UbqFvs6XPv6hCdPKkg3b7FMjuPdJLz2w54a+Wyfrp6CFYDZyPmDZ3IkE
         W0vUtwV0T3yekrghgmLcCS164X9lDUDwgvhq916QgiJMH6wfzNW5C5/XrLnNN1ph/GiG
         K9J+ZM292B32Iy7S2ga4b5yxthPArwSwjdGo+ryLUmzGMwC6X6Vm5f3VEnJDlzd6Fanr
         5Tu901R+Odid1zCgNaLUEr0kwh4Mm7azowTlPf+njENOsLhgr4i1ixuDJo8Jn+I4+guT
         /+4w==
In-Reply-To: <YH8o5iIau85FaeLw-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 20, 2021 at 12:18 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Mon, Apr 19, 2021 at 06:44:02PM -0700, Shakeel Butt wrote:
[...]
> > 1. prctl(PF_MEMALLOC)
> >
> > The idea is to give userspace oom-killer (just one thread which is
> > finding the appropriate victims and will be sending SIGKILLs) access
> > to MEMALLOC reserves. Most of the time the preallocation, mlock and
> > memory.min will be good enough but for rare occasions, when the
> > userspace oom-killer needs to allocate, the PF_MEMALLOC flag will
> > protect it from reclaim and let the allocation dip into the memory
> > reserves.
> >
> > The misuse of this feature would be risky but it can be limited to
> > privileged applications. Userspace oom-killer is the only appropriate
> > user of this feature. This option is simple to implement.
>
> Hello Shakeel!
>
> If ordinary PAGE_SIZE and smaller kernel allocations start to fail,
> the system is already in a relatively bad shape. Arguably the userspace
> OOM killer should kick in earlier, it's already a bit too late.

Please note that these are not allocation failures but rather reclaim
on allocations (which is very normal). Our observation is that this
reclaim is very unpredictable and depends on the type of memory
present on the system which depends on the workload. If there is a
good amount of easily reclaimable memory (e.g. clean file pages), the
reclaim would be really fast. However for other types of reclaimable
memory the reclaim time varies a lot. The unreclaimable memory, pinned
memory, too many direct reclaimers, too many isolated memory and many
other things/heuristics/assumptions make the reclaim further
non-deterministic.

In our observation the global reclaim is very non-deterministic at the
tail and dramatically impacts the reliability of the system. We are
looking for a solution which is independent of the global reclaim.

> Allowing to use reserves just pushes this even further, so we're risking
> the kernel stability for no good reason.

Michal has suggested ALLOC_OOM which is less risky.

>
> But I agree that throttling the oom daemon in direct reclaim makes no sense.
> I wonder if we can introduce a per-task flag which will exclude the task from
> throttling, but instead all (large) allocations will just fail under a
> significant memory pressure more easily. In this case if there is a significant
> memory shortage the oom daemon will not be fully functional (will get -ENOMEM
> for an attempt to read some stats, for example), but still will be able to kill
> some processes and make the forward progress.

So, the suggestion is to have a per-task flag to (1) indicate to not
throttle and (2) fail allocations easily on significant memory
pressure.

For (1), the challenge I see is that there are a lot of places in the
reclaim code paths where a task can get throttled. There are
filesystems that block/throttle in slab shrinking. Any process can get
blocked on an unrelated page or inode writeback within reclaim.

For (2), I am not sure how to deterministically define "significant
memory pressure". One idea is to follow the __GFP_NORETRY semantics
and along with (1) the userspace oom-killer will see ENOMEM more
reliably than stucking in the reclaim.

So, the oom-killer maintains a list of processes to kill in extreme
conditions, have their pidfds open and keep that list fresh. Whenever
any syscalls returns ENOMEM, it starts doing
pidfd_send_signal(SIGKILL) to that list of processes, right?

The idea has merit but I don't see how this is any simpler. The (1) is
challenging on its own and my main concern is that it will be very
hard to maintain as reclaim code (particularly shrinkers) callbacks
into many diverse subsystems.

> But maybe it can be done in userspace too: by splitting the daemon into
> a core- and extended part and avoid doing anything behind bare minimum
> in the core part.
>
> >
> > 2. Mempool
> >
> > The idea is to preallocate mempool with a given amount of memory for
> > userspace oom-killer. Preferably this will be per-thread and
> > oom-killer can preallocate mempool for its specific threads. The core
> > page allocator can check before going to the reclaim path if the task
> > has private access to the mempool and return page from it if yes.
> >
> > This option would be more complicated than the previous option as the
> > lifecycle of the page from the mempool would be more sophisticated.
> > Additionally the current mempool does not handle higher order pages
> > and we might need to extend it to allow such allocations. Though this
> > feature might have more use-cases and it would be less risky than the
> > previous option.
>
> It looks like an over-kill for the oom daemon protection, but if there
> are other good use cases, maybe it's a good feature to have.
>

IMHO it is not an over-kill and easier to do then to remove all
instances of potential blocking/throttling sites in memory reclaim.

> >
> > Another idea I had was to use kthread based oom-killer and provide the
> > policies through eBPF program. Though I am not sure how to make it
> > monitor arbitrary metrics and if that can be done without any
> > allocations.
>
> To start this effort it would be nice to understand what metrics various
> oom daemons use and how easy is to gather them from the bpf side. I like
> this idea long-term, but not sure if it has been settled down enough.
> I imagine it will require a fair amount of work on the bpf side, so we
> need a good understanding of features we need.
>

Are there any examples of gathering existing metrics from bpf? Suren
has given a list of metrics useful for Android. Is it possible to
gather those metrics?

BTW thanks a lot for taking a look and I really appreciate your time.

thanks,
Shakeel

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Tue, 20 Apr 2021 09:04:21 -0700
Message-ID: <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH54pyRWSi1zLMw4@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5nl3Ndrhwo1fgJ0D9XlIWFVK7QF0q78XBT9yudtMFo=;
        b=vKkrzDPvcz3fRrLdFAlmjvz7vtpkEl6ajq8gX+3KnuXhf54ZQGOVasz9hBppAxsdGG
         zyZztOZeDrmM1spFY6MohNqmhFkis2LK6VOi3W+IH9bUeykvyICNxSmqkCbnhjzpXjHf
         XKqYdFR9obobgtE2/O5DtNC/WwW/AqrYZbV6madxBsKv65SP+wJgk1bNlZDPbiVzTkN+
         oXOXooCT2XNO3MHIRjEFKvTiEfjRt9nw92NVvhniIiBj65dVt1+Orf0nel6QyomWzsXL
         ZmTInp0PiGiIWle6TL2gZ+KVl4aYadA8xDJUllgsDk/j3ms1uSI3fpCdytsAN4lUl24V
         Aizw==
In-Reply-To: <YH54pyRWSi1zLMw4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Apr 19, 2021 at 11:46 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 19-04-21 18:44:02, Shakeel Butt wrote:
[...]
> > memory.min. However a new allocation from userspace oom-killer can
> > still get stuck in the reclaim and policy rich oom-killer do trigger
> > new allocations through syscalls or even heap.
>
> Can you be more specific please?
>

To decide when to kill, the oom-killer has to read a lot of metrics.
It has to open a lot of files to read them and there will definitely
be new allocations involved in those operations. For example reading
memory.stat does a page size allocation. Similarly, to perform action
the oom-killer may have to read cgroup.procs file which again has
allocation inside it.

Regarding sophisticated oom policy, I can give one example of our
cluster level policy. For robustness, many user facing jobs run a lot
of instances in a cluster to handle failures. Such jobs are tolerant
to some amount of failures but they still have requirements to not let
the number of running instances below some threshold. Normally killing
such jobs is fine but we do want to make sure that we do not violate
their cluster level agreement. So, the userspace oom-killer may
dynamically need to confirm if such a job can be killed.

[...]
> > To reliably solve this problem, we need to give guaranteed memory to
> > the userspace oom-killer.
>
> There is nothing like that. Even memory reserves are a finite resource
> which can be consumed as it is sharing those reserves with other users
> who are not necessarily coordinated. So before we start discussing
> making this even more muddy by handing over memory reserves to the
> userspace we should really examine whether pre-allocation is something
> that will not work.
>

We actually explored if we can restrict the syscalls for the
oom-killer which does not do memory allocations. We concluded that is
not practical and not maintainable. Whatever the list we can come up
with will be outdated soon. In addition, converting all the must-have
syscalls to not do allocations is not possible/practical.

> > At the moment we are contemplating between
> > the following options and I would like to get some feedback.
> >
> > 1. prctl(PF_MEMALLOC)
> >
> > The idea is to give userspace oom-killer (just one thread which is
> > finding the appropriate victims and will be sending SIGKILLs) access
> > to MEMALLOC reserves. Most of the time the preallocation, mlock and
> > memory.min will be good enough but for rare occasions, when the
> > userspace oom-killer needs to allocate, the PF_MEMALLOC flag will
> > protect it from reclaim and let the allocation dip into the memory
> > reserves.
>
> I do not think that handing over an unlimited ticket to the memory
> reserves to userspace is a good idea. Even the in kernel oom killer is
> bound to a partial access to reserves. So if we really want this then
> it should be in sync with and bound by the ALLOC_OOM.
>

Makes sense.

> > The misuse of this feature would be risky but it can be limited to
> > privileged applications. Userspace oom-killer is the only appropriate
> > user of this feature. This option is simple to implement.
> >
> > 2. Mempool
> >
> > The idea is to preallocate mempool with a given amount of memory for
> > userspace oom-killer. Preferably this will be per-thread and
> > oom-killer can preallocate mempool for its specific threads. The core
> > page allocator can check before going to the reclaim path if the task
> > has private access to the mempool and return page from it if yes.
>
> Could you elaborate some more on how this would be controlled from the
> userspace? A dedicated syscall? A driver?
>

I was thinking of simply prctl(SET_MEMPOOL, bytes) to assign mempool
to a thread (not shared between threads) and prctl(RESET_MEMPOOL) to
free the mempool.

> > This option would be more complicated than the previous option as the
> > lifecycle of the page from the mempool would be more sophisticated.
> > Additionally the current mempool does not handle higher order pages
> > and we might need to extend it to allow such allocations. Though this
> > feature might have more use-cases and it would be less risky than the
> > previous option.
>
> I would tend to agree.
>
> > Another idea I had was to use kthread based oom-killer and provide the
> > policies through eBPF program. Though I am not sure how to make it
> > monitor arbitrary metrics and if that can be done without any
> > allocations.
>
> A kernel module or eBPF to implement oom decisions has already been
> discussed few years back. But I am afraid this would be hard to wire in
> for anything except for the victim selection. I am not sure it is
> maintainable to also control when the OOM handling should trigger.
>

I think you are referring to [1]. That patch was only looking at PSI
and I think we are on the same page that we need more information to
decide when to kill. Also I agree with you that it is hard to
implement "when to kill" with eBPF but I wanted the idea out to see if
eBPF experts have some suggestions.

[1] https://lore.kernel.org/lkml/20190807205138.GA24222-druUgvl0LCNAfugRpC6u6w@public.gmane.org/

thanks,
Shakeel

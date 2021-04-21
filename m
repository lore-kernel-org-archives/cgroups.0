From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 09:16:15 +0200
Message-ID: <YH/RPydqhwXdyG80@dhcp22.suse.cz>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH54pyRWSi1zLMw4@dhcp22.suse.cz>
 <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618989376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/t8yc2lQ3pLQ4sfUDYcnlZrhBPSE43fDoX7RlTCbrYU=;
        b=oz0tPCAnFgexhSXdu2bypRgSNPkmuFx2oBUto0IsTOm7T3MUgl/JhML9WF6kinDHrFrVOJ
        IS5PbSD5CKpAsNC4PlCXPuwL+EcVCRnxa0oA0IGADjtUOAMQAdi/ymAjuKIk/ClNmYMU/+
        v+8nf1NboN5d1MbJTAFteM/dOvHUqKo=
Content-Disposition: inline
In-Reply-To: <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue 20-04-21 09:04:21, Shakeel Butt wrote:
> On Mon, Apr 19, 2021 at 11:46 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Mon 19-04-21 18:44:02, Shakeel Butt wrote:
> [...]
> > > memory.min. However a new allocation from userspace oom-killer can
> > > still get stuck in the reclaim and policy rich oom-killer do trigger
> > > new allocations through syscalls or even heap.
> >
> > Can you be more specific please?
> >
> 
> To decide when to kill, the oom-killer has to read a lot of metrics.
> It has to open a lot of files to read them and there will definitely
> be new allocations involved in those operations. For example reading
> memory.stat does a page size allocation. Similarly, to perform action
> the oom-killer may have to read cgroup.procs file which again has
> allocation inside it.

True but many of those can be avoided by opening the file early. At
least seq_file based ones will not allocate later if the output size
doesn't increase. Which should be the case for many. I think it is a
general improvement to push those who allocate during read to an open
time allocation.

> Regarding sophisticated oom policy, I can give one example of our
> cluster level policy. For robustness, many user facing jobs run a lot
> of instances in a cluster to handle failures. Such jobs are tolerant
> to some amount of failures but they still have requirements to not let
> the number of running instances below some threshold. Normally killing
> such jobs is fine but we do want to make sure that we do not violate
> their cluster level agreement. So, the userspace oom-killer may
> dynamically need to confirm if such a job can be killed.

What kind of data do you need to examine to make those decisions?

> [...]
> > > To reliably solve this problem, we need to give guaranteed memory to
> > > the userspace oom-killer.
> >
> > There is nothing like that. Even memory reserves are a finite resource
> > which can be consumed as it is sharing those reserves with other users
> > who are not necessarily coordinated. So before we start discussing
> > making this even more muddy by handing over memory reserves to the
> > userspace we should really examine whether pre-allocation is something
> > that will not work.
> >
> 
> We actually explored if we can restrict the syscalls for the
> oom-killer which does not do memory allocations. We concluded that is
> not practical and not maintainable. Whatever the list we can come up
> with will be outdated soon. In addition, converting all the must-have
> syscalls to not do allocations is not possible/practical.

I am definitely curious to learn more.

[...]
> > > 2. Mempool
> > >
> > > The idea is to preallocate mempool with a given amount of memory for
> > > userspace oom-killer. Preferably this will be per-thread and
> > > oom-killer can preallocate mempool for its specific threads. The core
> > > page allocator can check before going to the reclaim path if the task
> > > has private access to the mempool and return page from it if yes.
> >
> > Could you elaborate some more on how this would be controlled from the
> > userspace? A dedicated syscall? A driver?
> >
> 
> I was thinking of simply prctl(SET_MEMPOOL, bytes) to assign mempool
> to a thread (not shared between threads) and prctl(RESET_MEMPOOL) to
> free the mempool.

I am not a great fan of prctl. It has become a dumping ground for all
mix of unrelated functionality. But let's say this is a minor detail at
this stage. So you are proposing to have a per mm mem pool that would be
used as a fallback for an allocation which cannot make a forward
progress, right? Would that pool be preallocated and sitting idle? What
kind of allocations would be allowed to use the pool? What if the pool
is depleted?
-- 
Michal Hocko
SUSE Labs

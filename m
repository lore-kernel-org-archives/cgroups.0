From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Tue, 4 May 2021 19:45:19 -0700
Message-ID: <CALvZod4pqkY84Od67=aEnpWL7V3bXnH4pduBQAh89Byp=snD+Q@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH54pyRWSi1zLMw4@dhcp22.suse.cz> <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw@mail.gmail.com>
 <YH/RPydqhwXdyG80@dhcp22.suse.cz> <CALvZod4kRWDQuZZQ5F+z6WMcUWLwgYd-Kb0mY8UAEK4MbSOZaA@mail.gmail.com>
 <YIA2rB0wgqKzfUfi@dhcp22.suse.cz> <CALvZod4_L7GSHnivQTSdDzo=fb4i3z=katjzVCHfLz9WWGK8uQ@mail.gmail.com>
 <CAJuCfpEXyG9x1nUsg+6yVWTP+-A4OwuCg9XHLAciu39=JNY7DQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpyffmzF28xsaxMRD2G97jPnI0ZZ1SR5Rjf3NGEtBIA=;
        b=WeyYZGSlF4U/HwB/qVfj/2M1q/SsBc/SKWwZXb07+k3IHswE46B/RH47b+4Tq/22n6
         cJqgiZYKFSa5CPgEvKu1v6InVgLl9uy97j0IGcSYidqkwZt6CFst4uMGSHPwu20HAKYq
         Srmc6a9Mbxc5pqZ3svXSYaZ5RtOwasDrY7ezpwc4tBuj53FCQ7EXSZovm0/gpUO9iwwZ
         su3SMw/cUk3m4xk7brfxW7WSf+TvhBnlJfhA51FDVlT9bJtegtxVRO1lbNIEX7//gEUN
         FRgRk4VDGYIxofh5nMP1MByGTUdj7rDMqT1gLLmVQXIUNvw57IUDi13+DvQbRNS+CFpc
         hdyQ==
In-Reply-To: <CAJuCfpEXyG9x1nUsg+6yVWTP+-A4OwuCg9XHLAciu39=JNY7DQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, May 4, 2021 at 6:26 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, May 4, 2021 at 5:37 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Wed, Apr 21, 2021 at 7:29 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > [...]
> > > > > What if the pool is depleted?
> > > >
> > > > This would mean that either the estimate of mempool size is bad or
> > > > oom-killer is buggy and leaking memory.
> > > >
> > > > I am open to any design directions for mempool or some other way where
> > > > we can provide a notion of memory guarantee to oom-killer.
> > >
> > > OK, thanks for clarification. There will certainly be hard problems to
> > > sort out[1] but the overall idea makes sense to me and it sounds like a
> > > much better approach than a OOM specific solution.
> > >
> > >
> > > [1] - how the pool is going to be replenished without hitting all
> > > potential reclaim problems (thus dependencies on other all tasks
> > > directly/indirectly) yet to not rely on any background workers to do
> > > that on the task behalf without a proper accounting etc...
> > > --
> >
> > I am currently contemplating between two paths here:
> >
> > First, the mempool, exposed through either prctl or a new syscall.
> > Users would need to trace their userspace oom-killer (or whatever
> > their use case is) to find an appropriate mempool size they would need
> > and periodically refill the mempools if allowed by the state of the
> > machine. The challenge here is to find a good value for the mempool
> > size and coordinating the refilling of mempools.
> >
> > Second is a mix of Roman and Peter's suggestions but much more
> > simplified. A very simple watchdog with a kill-list of processes and
> > if userspace didn't pet the watchdog within a specified time, it will
> > kill all the processes in the kill-list. The challenge here is to
> > maintain/update the kill-list.
>
> IIUC this solution is designed to identify cases when oomd/lmkd got
> stuck while allocating memory due to memory shortages and therefore
> can't feed the watchdog. In such a case the kernel goes ahead and
> kills some processes to free up memory and unblock the blocked
> process. Effectively this would limit the time such a process gets
> stuck by the duration of the watchdog timeout. If my understanding of
> this proposal is correct,

Your understanding is indeed correct.

> then I see the following downsides:
> 1. oomd/lmkd are still not prevented from being stuck, it just limits
> the duration of this blocked state. Delaying kills when memory
> pressure is high even for short duration is very undesirable.

Yes I agree.

> I think
> having mempool reserves could address this issue better if it can
> always guarantee memory availability (not sure if it's possible in
> practice).

I think "mempool ... always guarantee memory availability" is
something I should quantify with some experiments.

> 2. What would be performance overhead of this watchdog? To limit the
> duration of a process being blocked to a small enough value we would
> have to have quite a small timeout, which means oomd/lmkd would have
> to wake up quite often to feed the watchdog. Frequent wakeups on a
> battery-powered system is not a good idea.

This is indeed the downside i.e. the tradeoff between acceptable stall
vs frequent wakeups.

> 3. What if oomd/lmkd gets stuck for some memory-unrelated reason and
> can't feed the watchdog? In such a scenario the kernel would assume
> that it is stuck due to memory shortages and would go on a killing
> spree.

This is correct but IMHO killing spree is not worse than oomd/lmkd
getting stuck for some other reason.

> If there is a sure way to identify when a process gets stuck
> due to memory shortages then this could work better.

Hmm are you saying looking at the stack traces of the userspace
oom-killer or some metrics related to oom-killer? It will complicate
the code.

> 4. Additional complexity of keeping the list of potential victims in
> the kernel. Maybe we can simply reuse oom_score to choose the best
> victims?

Your point of additional complexity is correct. Regarding oom_score I
think you meant oom_score_adj, I would avoid putting more
policies/complexity in the kernel but I got your point that the
simplest watchdog might not be helpful at all.

> Thanks,
> Suren.
>
> >
> > I would prefer the direction which oomd and lmkd are open to adopt.
> >
> > Any suggestions?

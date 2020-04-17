From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 14:51:09 -0700
Message-ID: <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
References: <20200417010617.927266-1-kuba@kernel.org> <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com> <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com> <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmTmDDUdpiLDV9LVGQCn0/OLUoBHllDUrwiB8bPf7PE=;
        b=VVM8cusG0MQVqrRDrUMvM8EhIwHOn0sQjHBjQhOSHLGEZCqJMCc4gROw7t4V/VvMaM
         rTksXe0M88FFeD+d+4/bU9Umfz4tE0rDCFqJOsAP3yaEDjpWmUR9eMq3AzzsiqYBQZNi
         Qi5TmhCZLqxmx93vn63TQb3vbwPVpF0H+JIhVikUm85foDo7F5Xb6KvZFwLmyFrNIkSL
         z0wQyU2jNtR4QvbOlI3OHXgzEbM+bT53bjqp3l7bkCopGgWyws5tk2hxrzjT4QynMgT6
         dD6JSbo1qnWGSX02bZGkk10xSJ+aXhLrECxwYZ4spLR0m5HatbRaYOnwAgY37gWpKmxN
         IdYQ==
In-Reply-To: <20200417193539.GC43469-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 17, 2020 at 12:35 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Apr 17, 2020 at 10:51:10AM -0700, Shakeel Butt wrote:
> > > Can you please elaborate concrete scenarios? I'm having a hard time seeing
> > > differences from page cache.
> >
> > Oh I was talking about the global reclaim here. In global reclaim, any
> > task can be throttled (throttle_direct_reclaim()). Memory freed by
> > using the CPU of high priority low latency jobs can be stolen by low
> > priority batch jobs.
>
> I'm still having a hard time following this thread of discussion, most
> likely because my knoweldge of mm is fleeting at best. Can you please ELI5
> why the above is specifically relevant to this discussion?
>

No, it is not relevant to this discussion "now". The mention of
performance isolation in my first email was mostly due to my lack of
understanding about what problem this patch series is trying to solve.
So, let's skip this topic.

> I'm gonna list two things that come to my mind just in case that'd help
> reducing the back and forth.
>
> * With protection based configurations, protected cgroups wouldn't usually
>   go into direct reclaim themselves all that much.
>
> * We do have holes in accounting CPU cycles used by reclaim to the orgins,
>   which, for example, prevents making memory.high reclaim async and lets
>   memory pressure contaminate cpu isolation possibly to a significant degree
>   on lower core count machines in some scenarios, but that's a separate
>   issue we need to address in the future.
>

I have an opinion on the above but I will restrain as those are not
relevant to the patch series.

> > > cgroup A has memory.low protection and no other restrictions. cgroup B has
> > > no protection and has access to swap. When B's memory starts bloating and
> > > gets the system under memory contention, it'll start consuming swap until it
> > > can't. When swap becomes depleted for B, there's nothing holding it back and
> > > B will start eating into A's protection.
> > >
> >
> > In this example does 'B' have memory.high and memory.max set and by A
>
> B doesn't have anything set.
>
> > having no other restrictions, I am assuming you meant unlimited high
> > and max for A? Can 'A' use memory.min?
>
> Sure, it can but 1. the purpose of the example is illustrating the
> imcompleteness of the existing mechanism

I understand but is this a real world configuration people use and do
we want to support the scenario where without setting high/max, the
kernel still guarantees the isolation.

> 2. there's a big difference between
> letting the machine hit the wall and waiting for the kernel OOM to trigger
> and being able to monitor the situation as it gradually develops and respond
> to it, which is the whole point of the low/high mechanisms.
>

I am not really against the proposed solution. What I am trying to see
is if this problem is more general than an anon/swap-full problem and
if a more general solution is possible. To me it seems like, whenever
a large portion of reclaimable memory (anon, file or kmem) becomes
non-reclaimable abruptly, the memory isolation can be broken. You gave
the anon/swap-full example, let me see if I can come up with file and
kmem examples (with similar A & B).

1) B has a lot of page cache but temporarily gets pinned for rdma or
something and the system gets low on memory. B can attack A's low
protected memory as B's page cache is not reclaimable temporarily.

2) B has a lot of dentries/inodes but someone has taken a write lock
on shrinker_rwsem and got stuck in allocation/reclaim or CPU
preempted. B can attack A's low protected memory as B's slabs are not
reclaimable temporarily.

I think the aim is to slow down B enough to give the PSI monitor a
chance to act before either B targets A's protected memory or the
kernel triggers oom-kill.

My question is do we really want to solve the issue without limiting B
through high/max? Also isn't fine grained PSI monitoring along with
limiting B through memory.[high|max] general enough to solve all three
example scenarios?

thanks,
Shakeel

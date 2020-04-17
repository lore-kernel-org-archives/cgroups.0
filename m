From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 10:51:10 -0700
Message-ID: <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
References: <20200417010617.927266-1-kuba@kernel.org> <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com> <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bvq8GDDyYV41j+5P8OsI6ehsGT+D4XvqiNl9KWPqiw=;
        b=rcPENmuw3uoibqCQ1bei91SZIX5CUxsppMlNgftSQMML52eG74i79y68GqmTEcLfP0
         ULN6ukv+0a58WwyLrgvPd2vyg1NgsO6mTXw02TFLShqH7rTMyLxmJj0pas6ibkeULTuF
         zvL7GDe8Nsjj2H6xwJKjHk1scm/yLizWICpyBkHsDskJnl4p0tKyqkLm3QTxkg8uD3DB
         5WI68ZUgtj++O69DQfmKAb72c7UIxoFYL2VMHIvnMSHyFT3fHtrXZMsF3+Uc1gNI9ySG
         7VYION5mZD2kA76B0mIi1P5r48iacIP98VQkdw0A9e8+QLgsfdukRlPBYqeo5N9elsJs
         2LzA==
In-Reply-To: <20200417173615.GB43469-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 17, 2020 at 10:36 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Apr 17, 2020 at 10:18:15AM -0700, Shakeel Butt wrote:
> > > There currently are issues with anonymous memory management which makes them
> > > different / worse than page cache but I don't follow why swapping
> > > necessarily means that isolation is broken. Page refaults don't indicate
> > > that memory isolation is broken after all.
> >
> > Sorry, I meant the performance isolation. Direct reclaim does not
> > really differentiate who to stall and whose CPU to use.
>
> Can you please elaborate concrete scenarios? I'm having a hard time seeing
> differences from page cache.
>

Oh I was talking about the global reclaim here. In global reclaim, any
task can be throttled (throttle_direct_reclaim()). Memory freed by
using the CPU of high priority low latency jobs can be stolen by low
priority batch jobs.

> > > > memcg limit reclaim and memcg limits are overcommitted. Shouldn't
> > > > running out of swap will trigger the OOM earlier which should be
> > > > better than impacting the whole system.
> > >
> > > The primary scenario which was being considered was undercommitted
> > > protections but I don't think that makes any relevant differences.
> > >
> >
> > What is undercommitted protections? Does it mean there is still swap
> > available on the system but the memcg is hitting its swap limit?
>
> Hahaha, I assumed you were talking about memory.high/max and was saying that
> the primary scenarios that were being considered was usage of memory.low
> interacting with swap. Again, can you please give an concrete example so
> that we don't misunderstand each other?
>
> > > This is exactly similar to delay injection for memory.high. What's desired
> > > is slowing down the workload as the available resource is depleted so that
> > > the resource shortage presents as gradual degradation of performance and
> > > matching increase in resource PSI. This allows the situation to be detected
> > > and handled from userland while avoiding sudden and unpredictable behavior
> > > changes.
> > >
> >
> > Let me try to understand this with an example. Memcg 'A' has
>
> Ah, you already went there. Great.
>
> > memory.high = 100 MiB, memory.max = 150 MiB and memory.swap.max = 50
> > MiB. When A's usage goes over 100 MiB, it will reclaim the anon, file
> > and kmem. The anon will go to swap and increase its swap usage until
> > it hits the limit. Now the 'A' reclaim_high has fewer things (file &
> > kmem) to reclaim but the mem_cgroup_handle_over_high() will keep A's
> > increase in usage in check.
> >
> > So, my question is: should the slowdown by memory.high depends on the
> > reclaimable memory? If there is no reclaimable memory and the job hits
> > memory.high, should the kernel slow it down to crawl until the PSI
> > monitor comes and decides what to do. If I understand correctly, the
> > problem is the kernel slow down is not successful when reclaimable
> > memory is very low. Please correct me if I am wrong.
>
> In combination with memory.high, swap slowdown may not be necessary because
> memory.high's slow down mechanism is already there to handle "can't swap"
> scenario whether that's because swap is disabled wholesale, limited or
> depleted. However, please consider the following scenario.
>
> cgroup A has memory.low protection and no other restrictions. cgroup B has
> no protection and has access to swap. When B's memory starts bloating and
> gets the system under memory contention, it'll start consuming swap until it
> can't. When swap becomes depleted for B, there's nothing holding it back and
> B will start eating into A's protection.
>

In this example does 'B' have memory.high and memory.max set and by A
having no other restrictions, I am assuming you meant unlimited high
and max for A? Can 'A' use memory.min?

> The proposed mechanism just plugs another vector for the same condition
> where anonymous memory management breaks down because they can no longer be
> reclaimed due to swap unavailability.
>
> Thanks.
>
> --
> tejun

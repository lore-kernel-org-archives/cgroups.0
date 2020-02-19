From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 14:16:18 -0500
Message-ID: <20200219191618.GB54486@cmpxchg.org>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mZCRvJUEd0aeZMSM2KiDRl8M85Gpn4sTqFj3MDhSdPs=;
        b=ZICvLtBj1Wsb4nDHlvOkhJNjp3TK0gM17yFa9MWXljGt5qzSyWPJyOsQ2sFarzK7fo
         BUjh3r6byLkmeK3UhKrBX+McO538JJpggApObSaFa7bl67ekDkGK29iwsMiq41gfPvMX
         4UHHiWljqNjxb1OKPRXzIXh8ymNLCJGtes2Zcn12WpgyyO+0SUmRejsSms4mxW7hSzgU
         nKjNF019p2KE9fxskrQvcbZt5XkL0ZWaIaAcdZtK7/I/2r4+s7VR/gLAVBzZknuwqgPw
         s7kQMRNLecMpnp/YU05mEVI/pqk3i00TvTx+a7189OODFLRBJcRg3laDJqIQubVaU+LO
         924w==
Content-Disposition: inline
In-Reply-To: <20200219183731.GC11847-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 19, 2020 at 07:37:31PM +0100, Michal Hocko wrote:
> On Wed 19-02-20 13:12:19, Johannes Weiner wrote:
> > We have received regression reports from users whose workloads moved
> > into containers and subsequently encountered new latencies. For some
> > users these were a nuisance, but for some it meant missing their SLA
> > response times. We tracked those delays down to cgroup limits, which
> > inject direct reclaim stalls into the workload where previously all
> > reclaim was handled my kswapd.
> 
> I am curious why is this unexpected when the high limit is explicitly
> documented as a throttling mechanism.

Memory.high is supposed to curb aggressive growth using throttling
instead of OOM killing. However, if the workload has plenty of easily
reclaimable memory and just needs to recycle a couple of cache pages
to permit an allocation, there is no need to throttle the workload -
just as there wouldn't be any need to trigger the OOM killer.

So it's not unexpected, but it's unnecessarily heavy-handed: since
memory.high allows some flexibility around the target size, we can
move the routine reclaim activity (cache recycling) out of the main
execution stream of the workload, just like we do with kswapd. If that
cannot keep up, we can throttle and do direct reclaim.

It doesn't change the memory.high semantics, but it allows exploiting
the fact that we have SMP systems and can parallize the book keeping.

> > This patch adds asynchronous reclaim to the memory.high cgroup limit
> > while keeping direct reclaim as a fallback. In our testing, this
> > eliminated all direct reclaim from the affected workload.
> 
> Who is accounted for all the work? Unless I am missing something this
> just gets hidden in the system activity and that might hurt the
> isolation. I do see how moving the work to a different context is
> desirable but this work has to be accounted properly when it is going to
> become a normal mode of operation (rather than a rare exception like the
> existing irq context handling).

Yes, the plan is to account it to the cgroup on whose behalf we're
doing the work.

The problem is that we have a general lack of usable CPU control right
now - see Rik's work on this: https://lkml.org/lkml/2019/8/21/1208.
For workloads that are contended on CPU, we cannot enable the CPU
controller because the scheduling latencies are too high. And for
workloads that aren't CPU contended, well, it doesn't really matter
where the reclaim cycles are accounted to.

Once we have the CPU controller up to speed, we can add annotations
like these to account stretches of execution to specific
cgroups. There just isn't much point to do it before we can actually
enable CPU control on the real workloads where it would matter.

[ This is generally work in process: for example, if you isolate
  workloads with memory.low, kswapd cpu time isn't accounted to the
  cgroup that causes it. Swap IO issued by kswapd isn't accounted to
  the group that is getting swapped. The memory consumed by struct
  cgroup itself, the percpu allocations for the vmstat arrays etc.,
  which is sizable, are not accounted to the cgroup that creates
  subgroups, and so forth. ]

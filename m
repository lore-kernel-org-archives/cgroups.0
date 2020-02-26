From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 26 Feb 2020 17:26:42 -0500
Message-ID: <20200226222642.GB30206@cmpxchg.org>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1pUOCDo1xfpbB9eMKwX1WssgTio2peYBY4faFYcpXSE=;
        b=1QSlHaDUxgg2mgs9SMQl+bXQNUUVbnXcl/ljCp1zHziKIqL7ke61B1q5H5ZJs6zUFG
         XquHcPjSE5EI58XbhmobrTTTBDWvVyakNk66BSFINlEcDf3yXJ+n7C4oKlHlPPCmuVEA
         hkePiAzrmF2glb3j+OdYa5MOhpiLdbaUtEoOp3X2+s5clbSqBkY+C443tYDRAN4ZTpNd
         sw/MFTv2cPxz8FJ0vdZIWMjwAh0Wf4lrTIA0/hNYI7vdfUcA0p9nGpU122CzNoY/kk9j
         Gsxa3n94IUR+n4++WvWjtaCkIQSPYrHoKNLnl4c2L6ZFACP1oepYMzs/amMEUdQGgMU0
         IiPg==
Content-Disposition: inline
In-Reply-To: <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Wed, Feb 26, 2020 at 12:25:33PM -0800, Shakeel Butt wrote:
> On Wed, Feb 19, 2020 at 10:12 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > We have received regression reports from users whose workloads moved
> > into containers and subsequently encountered new latencies. For some
> > users these were a nuisance, but for some it meant missing their SLA
> > response times. We tracked those delays down to cgroup limits, which
> > inject direct reclaim stalls into the workload where previously all
> > reclaim was handled my kswapd.
> >
> > This patch adds asynchronous reclaim to the memory.high cgroup limit
> > while keeping direct reclaim as a fallback. In our testing, this
> > eliminated all direct reclaim from the affected workload.
> >
> > memory.high has a grace buffer of about 4% between when it becomes
> > exceeded and when allocating threads get throttled. We can use the
> > same buffer for the async reclaimer to operate in. If the worker
> > cannot keep up and the grace buffer is exceeded, allocating threads
> > will fall back to direct reclaim before getting throttled.
> >
> > For irq-context, there's already async memory.high enforcement. Re-use
> > that work item for all allocating contexts, but switch it to the
> > unbound workqueue so reclaim work doesn't compete with the workload.
> > The work item is per cgroup, which means the workqueue infrastructure
> > will create at maximum one worker thread per reclaiming cgroup.
> >
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 60 +++++++++++++++++++++++++++++++++++++------------
> >  mm/vmscan.c     | 10 +++++++--
> 
> This reminds me of the per-memcg kswapd proposal from LSFMM 2018
> (https://lwn.net/Articles/753162/).

Ah yes, I remember those discussions. :)

One thing that has changed since we tried to implement this last was
the workqueue concurrency code. We don't have to worry about a single
thread or fixed threads per cgroup, because the workqueue code has
improved significantly to handle concurrency demands, and having one
work item per cgroup makes sure we have anywhere between 0 threads and
one thread per cgroup doing this reclaim work, completely on-demand.

Also, with cgroup2, memory and cpu always have overlapping control
domains, so the question who to account the work to becomes a much
easier one to answer.

> If I understand this correctly, the use-case is that the job instead
> of direct reclaiming (potentially in latency sensitive tasks), prefers
> a background non-latency sensitive task to do the reclaim. I am
> wondering if we can use the memory.high notification along with a new
> memcg interface (like memory.try_to_free_pages) to implement a user
> space background reclaimer. That would resolve the cpu accounting
> concerns as the user space background reclaimer can share the cpu cost
> with the task.

The idea is not necessarily that the background reclaimer is lower
priority work, but that it can execute in parallel on a separate CPU
instead of being forced into the execution stream of the main work.

So we should be able to fully resolve this problem inside the kernel,
without going through userspace, by accounting CPU cycles used by the
background reclaim worker to the cgroup that is being reclaimed.

> One concern with this approach will be that the memory.high
> notification is too late and the latency sensitive task has faced the
> stall. We can either introduce a threshold notification or another
> notification only limit like memory.near_high which can be set based
> on the job's rate of allocations and when the usage hits this limit
> just notify the user space.

Yeah, I think it would be a pretty drastic expansion of the memory
controller's interface.

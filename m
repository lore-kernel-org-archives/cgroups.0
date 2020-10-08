From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Thu, 8 Oct 2020 11:14:49 -0400
Message-ID: <20201008151449.GB163830@cmpxchg.org>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200928210216.GA378894@cmpxchg.org>
 <CALvZod7afgoAL7KyfjpP-LoSFGSHv7XtfbbnVhEEhsiZLqZu9A@mail.gmail.com>
 <20201001151058.GB493631@cmpxchg.org>
 <CALvZod66T4-y2JQnN+favf6tnKkkFQ17HZ8EAAX0GXAcbO4v+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pHRJWCSun0VJ1G5+k8UnmqCRL8Yd5f7znmF3gBnbB3o=;
        b=G3iQr75c2qWXNzE1TTuhZ56VcAS5y/X+omVvETmmyx5mT1CiXWx4u/Wy8KnTcyAioe
         vVKtvwVC3tDVLuSbSh5u8ExJEQfEQ4VNGY4xYjQ7Y7wmixMbbBaMluJQDLJyyPwiFi2X
         nTaLq62ndN5wlKrxKU7THa9N+EJyw8O3XZwFRQY8gr4ybahuPvOUYYg668PWwQbE/gZZ
         0lg3fldvR3sx4cDKT4sTDcjnxlIpmxm4tpAB0Ns8NZJmY4I1Rk3xsmtyFfEJJRSkhLYa
         8trensZDmzhr5ACp6f7ta1JZoD2BbQTpMgFNOVdOOOy+szVogrA4ssV4WudqQLl8k/iY
         bpmA==
Content-Disposition: inline
In-Reply-To: <CALvZod66T4-y2JQnN+favf6tnKkkFQ17HZ8EAAX0GXAcbO4v+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org

On Mon, Oct 05, 2020 at 02:59:10PM -0700, Shakeel Butt wrote:
> Hi Johannes,
> 
> On Thu, Oct 1, 2020 at 8:12 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > Hello Shakeel,
> >
> > On Wed, Sep 30, 2020 at 08:26:26AM -0700, Shakeel Butt wrote:
> > > On Mon, Sep 28, 2020 at 2:03 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > > Workloads may not
> > > > allocate anything for hours, and then suddenly allocate gigabytes
> > > > within seconds. A sudden onset of streaming reads through the
> > > > filesystem could destroy the workingset measurements, whereas a limit
> > > > would catch it and do drop-behind (and thus workingset sampling) at
> > > > the exact rate of allocations.
> > > >
> > > > Again I believe something that may be doable as a hyperscale operator,
> > > > but likely too fragile to get wider applications beyond that.
> > > >
> > > > My take is that a proactive reclaim feature, whose goal is never to
> > > > thrash or punish but to keep the LRUs warm and the workingset trimmed,
> > > > would ideally have:
> > > >
> > > > - a pressure or size target specified by userspace but with
> > > >   enforcement driven inside the kernel from the allocation path
> > > >
> > > > - the enforcement work NOT be done synchronously by the workload
> > > >   (something I'd argue we want for *all* memory limits)
> > > >
> > > > - the enforcement work ACCOUNTED to the cgroup, though, since it's the
> > > >   cgroup's memory allocations causing the work (again something I'd
> > > >   argue we want in general)
> > >
> > > For this point I think we want more flexibility to control the
> > > resources we want to dedicate for proactive reclaim. One particular
> > > example from our production is the batch jobs with high memory
> > > footprint. These jobs don't have enough CPU quota but we do want to
> > > proactively reclaim from them. We would prefer to dedicate some amount
> > > of CPU to proactively reclaim from them independent of their own CPU
> > > quota.
> >
> > Would it not work to add headroom for this reclaim overhead to the CPU
> > quota of the job?
> >
> > The reason I'm asking is because reclaim is only one side of the
> > proactive reclaim medal. The other side is taking faults and having to
> > do IO and/or decompression (zswap, compressed btrfs) on the workload
> > side. And that part is unavoidably consuming CPU and IO quota of the
> > workload. So I wonder how much this can generally be separated out.
> >
> > It's certainly something we've been thinking about as well. Currently,
> > because we use memory.high, we have all the reclaim work being done by
> > a privileged daemon outside the cgroup, and the workload pressure only
> > stems from the refault side.
> >
> > But that means a workload is consuming privileged CPU cycles, and the
> > amount varies depending on the memory access patterns - how many
> > rotations the reclaim scanner is doing etc.
> >
> > So I do wonder whether this "cost of business" of running a workload
> > with a certain memory footprint should be accounted to the workload
> > itself. Because at the end of the day, the CPU you have available will
> > dictate how much memory you need, and both of these axes affect how
> > you can schedule this job in a shared compute pool. Do neighboring
> > jobs on the same host leave you either the memory for your colder
> > pages, or the CPU (and IO) to trim them off?
> >
> > For illustration, compare extreme examples of this.
> >
> >         A) A workload that has its executable/libraries and a fixed
> >            set of hot heap pages. Proactive reclaim will be relatively
> >            slow and cheap - a couple of deactivations/rotations.
> >
> >         B) A workload that does high-speed streaming IO and generates
> >            a lot of drop-behind cache; or a workload that has a huge
> >            virtual anon set with lots of allocations and MADV_FREEing
> >            going on. Proactive reclaim will be fast and expensive.
> >
> > Even at the same memory target size, these two types of jobs have very
> > different requirements toward the host environment they can run on.
> >
> > It seems to me that this is cost that should be captured in the job's
> > overall resource footprint.
> 
> I understand your point but from the usability perspective, I am
> finding it hard to deploy/use.
> 
> As you said, the proactive reclaim cost will be different for
> different types of workload but I do not expect the job owners telling
> me how much headroom their jobs need.

Isn't that the same for all work performed by the kernel? Instead of
proactive reclaim, it could just be regular reclaim due to a limit,
whose required headroom depends on the workload's allocation rate.

We wouldn't question whether direct reclaim cycles should be charged
to the cgroup. I'm not quite sure why proactive reclaim is different -
it's the same work done earlier.

> I would have to start with a fixed headroom for a job, have to monitor
> the resource usage of the proactive reclaim for it and dynamically
> adjust the headroom to not steal the CPU from the job (I am assuming
> there is no isolation between job and proactive reclaim).
> 
> This seems very hard to use as compared to setting aside a fixed
> amount of CPU for proactive reclaim system wide. Please correct me if
> I am misunderstanding something.

I see your point, but I don't know how a fixed system-wide pool is
easier to configure if you don't know the constituent consumers. How
much would you set aside?

A shared resource outside the natural cgroup hierarchy also triggers
my priority inversion alarm bells. How do you prevent a lower priority
job from consuming a disproportionate share of this pool? And as a
result cause the reclaim in higher priority groups to slow down, which
causes their memory footprint to expand and their LRUs to go stale.

It also still leaves the question around IO budget. Even if you manage
to not eat into the CPU budget of the job, you'd still eat into the IO
budget of the job, and that's harder to separate out.

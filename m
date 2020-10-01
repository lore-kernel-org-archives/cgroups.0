From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Thu, 1 Oct 2020 11:10:58 -0400
Message-ID: <20201001151058.GB493631@cmpxchg.org>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200928210216.GA378894@cmpxchg.org>
 <CALvZod7afgoAL7KyfjpP-LoSFGSHv7XtfbbnVhEEhsiZLqZu9A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OmZIxJBtx1NXXlnYK2+JLM28lEpk+Yfzhaq84vx6//8=;
        b=Vj+V9qtl+81/Vm8czipooCdTsZG1TfHRMTHRHlCJ7amFumfHSRkbnTWrfov3dMDsfh
         RXnAz+L7IhzewaiQ7iw2v8tuqbtuLnyt85yRcn19yc9eo5kh/MLbYLXSvbHMkULt2g2p
         nuj1Lepdlz0GpJAFmMuMGFfId9X4Y37T3rnX711ANm/Gn1s+5r9SFISanfZn0V7gW1Ua
         TyNNCg2TxtxqgXXOUmAnlBuKiiE+15lSgVsFdvV5Ki/vKcttzWFH+vsDkVjkZLHO+BuF
         jVgYygCuSQKRO3B9S6nCTZ9sX4US25qd8ogXHNnWGfzdLefhkPryYxyHH8AerZil7HW1
         xaqg==
Content-Disposition: inline
In-Reply-To: <CALvZod7afgoAL7KyfjpP-LoSFGSHv7XtfbbnVhEEhsiZLqZu9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Shakeel,

On Wed, Sep 30, 2020 at 08:26:26AM -0700, Shakeel Butt wrote:
> On Mon, Sep 28, 2020 at 2:03 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > Workloads may not
> > allocate anything for hours, and then suddenly allocate gigabytes
> > within seconds. A sudden onset of streaming reads through the
> > filesystem could destroy the workingset measurements, whereas a limit
> > would catch it and do drop-behind (and thus workingset sampling) at
> > the exact rate of allocations.
> >
> > Again I believe something that may be doable as a hyperscale operator,
> > but likely too fragile to get wider applications beyond that.
> >
> > My take is that a proactive reclaim feature, whose goal is never to
> > thrash or punish but to keep the LRUs warm and the workingset trimmed,
> > would ideally have:
> >
> > - a pressure or size target specified by userspace but with
> >   enforcement driven inside the kernel from the allocation path
> >
> > - the enforcement work NOT be done synchronously by the workload
> >   (something I'd argue we want for *all* memory limits)
> >
> > - the enforcement work ACCOUNTED to the cgroup, though, since it's the
> >   cgroup's memory allocations causing the work (again something I'd
> >   argue we want in general)
> 
> For this point I think we want more flexibility to control the
> resources we want to dedicate for proactive reclaim. One particular
> example from our production is the batch jobs with high memory
> footprint. These jobs don't have enough CPU quota but we do want to
> proactively reclaim from them. We would prefer to dedicate some amount
> of CPU to proactively reclaim from them independent of their own CPU
> quota.

Would it not work to add headroom for this reclaim overhead to the CPU
quota of the job?

The reason I'm asking is because reclaim is only one side of the
proactive reclaim medal. The other side is taking faults and having to
do IO and/or decompression (zswap, compressed btrfs) on the workload
side. And that part is unavoidably consuming CPU and IO quota of the
workload. So I wonder how much this can generally be separated out.

It's certainly something we've been thinking about as well. Currently,
because we use memory.high, we have all the reclaim work being done by
a privileged daemon outside the cgroup, and the workload pressure only
stems from the refault side.

But that means a workload is consuming privileged CPU cycles, and the
amount varies depending on the memory access patterns - how many
rotations the reclaim scanner is doing etc.

So I do wonder whether this "cost of business" of running a workload
with a certain memory footprint should be accounted to the workload
itself. Because at the end of the day, the CPU you have available will
dictate how much memory you need, and both of these axes affect how
you can schedule this job in a shared compute pool. Do neighboring
jobs on the same host leave you either the memory for your colder
pages, or the CPU (and IO) to trim them off?

For illustration, compare extreme examples of this.

	A) A workload that has its executable/libraries and a fixed
	   set of hot heap pages. Proactive reclaim will be relatively
	   slow and cheap - a couple of deactivations/rotations.

	B) A workload that does high-speed streaming IO and generates
	   a lot of drop-behind cache; or a workload that has a huge
	   virtual anon set with lots of allocations and MADV_FREEing
	   going on. Proactive reclaim will be fast and expensive.

Even at the same memory target size, these two types of jobs have very
different requirements toward the host environment they can run on.

It seems to me that this is cost that should be captured in the job's
overall resource footprint.

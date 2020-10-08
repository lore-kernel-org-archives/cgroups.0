From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Thu, 8 Oct 2020 10:53:36 -0400
Message-ID: <20201008145336.GA163830@cmpxchg.org>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200928210216.GA378894@cmpxchg.org>
 <20200929150444.GG2277@dhcp22.suse.cz>
 <20200929215341.GA408059@cmpxchg.org>
 <CALvZod5eN0PDtKo8SEp1n-xGvgCX9k6-OBGYLT3RmzhA+Q-2hw@mail.gmail.com>
 <20201001143149.GA493631@cmpxchg.org>
 <CALvZod59cU40A3nbQtkP50Ae3g6T2MQSt+q1=O2=Gy9QUzNkbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uyKHtfoarsj+UYs2PP4XCdlBcu5iL8M8TqmjexyJtjo=;
        b=gSpOReNk6UlU6+gBPtDU3TmLons5StnRVP+CSGLouttWxPrXlWzOUzwAitmC+kccP2
         0zmeEv8fvogdspFm1WObJnfz37SM5ZQXGJVkNbRt3U9rIh7Pyw4kD0vw0G9kikekdRdl
         C2gz/68+9dh12edgZNkL+yu9ynPSKifE62fxva7Ow56HS1u8kUWSsGm2yoI9rtaJKJiN
         nJA/QAp95vu+Fs1ILvQcjFYZDG+JxrV4BqbTRG3oG/QYOK4UZCI4Cc9geDfeNj3qsVsq
         MFI8DWNCMjRkARF4wR2mrx1S+YWbkkW2KhHKaCXXeQQUOCxJQtRVVlpJiKio3PpqqbwF
         TK5A==
Content-Disposition: inline
In-Reply-To: <CALvZod59cU40A3nbQtkP50Ae3g6T2MQSt+q1=O2=Gy9QUzNkbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>

On Tue, Oct 06, 2020 at 09:55:43AM -0700, Shakeel Butt wrote:
> On Thu, Oct 1, 2020 at 7:33 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> [snip]
> > > >    So instead of asking users for a target size whose suitability
> > > >    heavily depends on the kernel's LRU implementation, the readahead
> > > >    code, the IO device's capability and general load, why not directly
> > > >    ask the user for a pressure level that the workload is comfortable
> > > >    with and which captures all of the above factors implicitly? Then
> > > >    let the kernel do this feedback loop from a per-cgroup worker.
> > >
> > > I am assuming here by pressure level you are referring to the PSI like
> > > interface e.g. allowing the users to tell about their jobs that X
> > > amount of stalls in a fixed time window is tolerable.
> >
> > Right, essentially the same parameters that psi poll() would take.
> 
> I thought a bit more on the semantics of the psi usage for the
> proactive reclaim.
> 
> Suppose I have a top level cgroup A on which I want to enable
> proactive reclaim. Which memory psi events should the proactive
> reclaim should consider?
> 
> The simplest would be the memory.psi at 'A'. However memory.psi is
> hierarchical and I would not really want the pressure due limits in
> children of 'A' to impact the proactive reclaim.

I don't think pressure from limits down the tree can be separated out,
generally. All events are accounted recursively as well. Of course, we
remember the reclaim level for evicted entries - but if there is
reclaim triggered at A and A/B concurrently, the distribution of who
ends up reclaiming the physical pages in A/B is pretty arbitrary/racy.

If A/B decides to do its own proactive reclaim with the sublimit, and
ends up consuming the pressure budget assigned to proactive reclaim in
A, there isn't much that can be done.

It's also possible that proactive reclaim in A keeps A/B from hitting
its limit in the first place.

I have to say, the configuration doesn't really strike me as sensible,
though. Limits make sense for doing fixed partitioning: A gets 4G, A/B
gets 2G out of that. But if you do proactive reclaim on A you're
essentially saying A as a whole is auto-sizing dynamically based on
its memory access pattern. I'm not sure what it means to then start
doing fixed partitions in the sublevel.

> PSI due to refaults and slow IO should be included or maybe only
> those which are caused by the proactive reclaim itself. I am
> undecided on the PSI due to compaction. PSI due to global reclaim
> for 'A' is even more complicated. This is a stall due to reclaiming
> from the system including self. It might not really cause more
> refaults and IOs for 'A'. Should proactive reclaim ignore the
> pressure due to global pressure when tuning its aggressiveness.

Yeah, I think they should all be included, because ultimately what
matters is what the workload can tolerate without sacrificing
performance.

Proactive reclaim can destroy THPs, so the cost of recreating them
should be reflected. Otherwise you can easily overpressurize.

For global reclaim, if you say you want a workload pressurized to X
percent in order to drive the LRUs and chop off all cold pages the
workload can live without, it doesn't matter who does the work. If
there is an abundance of physical memory, it's going to be proactive
reclaim. If physical memory is already tight enough that global
reclaim does it for you, there is nothing to be done in addition, and
proactive reclaim should hang back. Otherwise you can again easily
overpressurize the workload.

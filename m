From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Thu, 8 Oct 2020 17:09:17 -0400
Message-ID: <20201008210917.GC163830@cmpxchg.org>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200928210216.GA378894@cmpxchg.org>
 <20200929150444.GG2277@dhcp22.suse.cz>
 <20200929215341.GA408059@cmpxchg.org>
 <CALvZod5eN0PDtKo8SEp1n-xGvgCX9k6-OBGYLT3RmzhA+Q-2hw@mail.gmail.com>
 <20201001143149.GA493631@cmpxchg.org>
 <CALvZod59cU40A3nbQtkP50Ae3g6T2MQSt+q1=O2=Gy9QUzNkbg@mail.gmail.com>
 <20201008145336.GA163830@cmpxchg.org>
 <CALvZod5-EtB0jNi9DXTmLSKrUzK2jXRhW8h6+7sqB356k0t1+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bKBtP0ujyc6cQVOrIcuXYWFHroSBLTISizcx1XMf6ng=;
        b=s3k82CHtM77kUlpDxAcCO0fDeNqzwcdQM8Of6YdH+JSnzn+xzdpRJ9ziqQJ17PbB71
         Mqtm7QLzZTQmjyHN54EEKjqcrnVar1NQomaJT3VkEktsowxDbaBgGtqLQVh0M/BOAaD9
         ARebNxoHOvYc4+h8nX3dYiA4ASrfoBZw+PtKvaDVCwv8CEtNux6iZ46m7efurvObQfKa
         pgRycL6/yDCFdXCxwCz2QfxOGdAsLD+tVl05QF2XfsTkXbk+27DnGXntvqhDOIaLbdua
         VjKUUQkR0jHnr0i/di/mlHqms2aF9AyPaAlyMuHaHfPx/5aXe43ZgQt8cORCWgcVX9tP
         HkZw==
Content-Disposition: inline
In-Reply-To: <CALvZod5-EtB0jNi9DXTmLSKrUzK2jXRhW8h6+7sqB356k0t1+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>

On Thu, Oct 08, 2020 at 08:55:57AM -0700, Shakeel Butt wrote:
> On Thu, Oct 8, 2020 at 7:55 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Tue, Oct 06, 2020 at 09:55:43AM -0700, Shakeel Butt wrote:
> > > On Thu, Oct 1, 2020 at 7:33 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > >
> > > [snip]
> > > > > >    So instead of asking users for a target size whose suitability
> > > > > >    heavily depends on the kernel's LRU implementation, the readahead
> > > > > >    code, the IO device's capability and general load, why not directly
> > > > > >    ask the user for a pressure level that the workload is comfortable
> > > > > >    with and which captures all of the above factors implicitly? Then
> > > > > >    let the kernel do this feedback loop from a per-cgroup worker.
> > > > >
> > > > > I am assuming here by pressure level you are referring to the PSI like
> > > > > interface e.g. allowing the users to tell about their jobs that X
> > > > > amount of stalls in a fixed time window is tolerable.
> > > >
> > > > Right, essentially the same parameters that psi poll() would take.
> > >
> > > I thought a bit more on the semantics of the psi usage for the
> > > proactive reclaim.
> > >
> > > Suppose I have a top level cgroup A on which I want to enable
> > > proactive reclaim. Which memory psi events should the proactive
> > > reclaim should consider?
> > >
> > > The simplest would be the memory.psi at 'A'. However memory.psi is
> > > hierarchical and I would not really want the pressure due limits in
> > > children of 'A' to impact the proactive reclaim.
> >
> > I don't think pressure from limits down the tree can be separated out,
> > generally. All events are accounted recursively as well. Of course, we
> > remember the reclaim level for evicted entries - but if there is
> > reclaim triggered at A and A/B concurrently, the distribution of who
> > ends up reclaiming the physical pages in A/B is pretty arbitrary/racy.
> >
> > If A/B decides to do its own proactive reclaim with the sublimit, and
> > ends up consuming the pressure budget assigned to proactive reclaim in
> > A, there isn't much that can be done.
> >
> > It's also possible that proactive reclaim in A keeps A/B from hitting
> > its limit in the first place.
> >
> > I have to say, the configuration doesn't really strike me as sensible,
> > though. Limits make sense for doing fixed partitioning: A gets 4G, A/B
> > gets 2G out of that. But if you do proactive reclaim on A you're
> > essentially saying A as a whole is auto-sizing dynamically based on
> > its memory access pattern. I'm not sure what it means to then start
> > doing fixed partitions in the sublevel.
> >
> 
> Think of the scenario where there is an infrastructure owner and the
> large number of job owners. The aim of the infra owner is to reduce
> cost by stuffing as many jobs as possible on the same machine while
> job owners want consistent performance.
> 
> The job owners usually have meta jobs i.e. a set of small jobs that
> run on the same machines and they manage these sub-jobs themselves.
>
> The infra owner wants to do proactive reclaim to trim the current jobs
> without impacting their performance and more importantly to have
> enough memory to land new jobs (We have learned the hard way that
> depending on global reclaim for memory overcommit is really bad for
> isolation).
>
> In the above scenario the configuration you mentioned might not be
> sensible is really possible. This is exactly what we have in prod.

I apologize if my statement was worded too broadly. I fully understand
your motivation and understand the sub job structure. It's more about
at which level to run proactive reclaim when there are sub-domains.

You said you're already using a feedback loop to adjust proactive
reclaim based on refault rates. How do you deal with this issue today
of one subgroup potentially having higher refaults due to a limit?

It appears that as soon as the subgroups can age independently, you
also need to treat them independently for proactive reclaim. Because
one group hitting its pressure limit says nothing about its sibling.

If you apply equal reclaim on them both based on the independently
pressured subjob, you'll under-reclaim the siblings.

If you apply equal reclaim on them both based on the unpressured
siblings alone, you'll over-pressurize the one with its own limit.

This seems independent of the exact metric you're using, and more
about at which level you apply pressure, and whether reclaim
subdomains created through a hard limit can be treated as part of a
larger shared pool or not.

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Thu, 8 Oct 2020 08:55:57 -0700
Message-ID: <CALvZod5-EtB0jNi9DXTmLSKrUzK2jXRhW8h6+7sqB356k0t1+g@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200928210216.GA378894@cmpxchg.org>
 <20200929150444.GG2277@dhcp22.suse.cz> <20200929215341.GA408059@cmpxchg.org>
 <CALvZod5eN0PDtKo8SEp1n-xGvgCX9k6-OBGYLT3RmzhA+Q-2hw@mail.gmail.com>
 <20201001143149.GA493631@cmpxchg.org> <CALvZod59cU40A3nbQtkP50Ae3g6T2MQSt+q1=O2=Gy9QUzNkbg@mail.gmail.com>
 <20201008145336.GA163830@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ua8VNvIgbxYgAvBR1LdP3f0lw9rNzuY+FsL2FkuuKgc=;
        b=nCnHGAJ/yBurVMCl5kStVg/46KC2El3gkCBnP53vS25tn//WMkF7s8yzX7p7CvDbnG
         q6FJUw2/6CiR21Cm9mmWN4Mzva9K1FGe5zhBl55R5xSrxWAM6dRoPoy/PaGFnJ+Rflau
         2VwIUJldFGM9dWLAEvA2qjnvRiZ5nfNbHwRvetcM1x23nzGTjp8GrOXW4sZneucjRutN
         UkRRejkmqwXxRfE0PO+pemHwC2tMmiq25I32bpzlbxGYLl4IqHVaejIuJzZTIrJs2oE/
         ys19ayvNy0zx7gTemXEztd+W0K96hUEh/Ce3w6755oDEAGxGo2pjRVb2xutjKaFXsToO
         05+g==
In-Reply-To: <20201008145336.GA163830-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>

On Thu, Oct 8, 2020 at 7:55 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Tue, Oct 06, 2020 at 09:55:43AM -0700, Shakeel Butt wrote:
> > On Thu, Oct 1, 2020 at 7:33 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > [snip]
> > > > >    So instead of asking users for a target size whose suitability
> > > > >    heavily depends on the kernel's LRU implementation, the readahead
> > > > >    code, the IO device's capability and general load, why not directly
> > > > >    ask the user for a pressure level that the workload is comfortable
> > > > >    with and which captures all of the above factors implicitly? Then
> > > > >    let the kernel do this feedback loop from a per-cgroup worker.
> > > >
> > > > I am assuming here by pressure level you are referring to the PSI like
> > > > interface e.g. allowing the users to tell about their jobs that X
> > > > amount of stalls in a fixed time window is tolerable.
> > >
> > > Right, essentially the same parameters that psi poll() would take.
> >
> > I thought a bit more on the semantics of the psi usage for the
> > proactive reclaim.
> >
> > Suppose I have a top level cgroup A on which I want to enable
> > proactive reclaim. Which memory psi events should the proactive
> > reclaim should consider?
> >
> > The simplest would be the memory.psi at 'A'. However memory.psi is
> > hierarchical and I would not really want the pressure due limits in
> > children of 'A' to impact the proactive reclaim.
>
> I don't think pressure from limits down the tree can be separated out,
> generally. All events are accounted recursively as well. Of course, we
> remember the reclaim level for evicted entries - but if there is
> reclaim triggered at A and A/B concurrently, the distribution of who
> ends up reclaiming the physical pages in A/B is pretty arbitrary/racy.
>
> If A/B decides to do its own proactive reclaim with the sublimit, and
> ends up consuming the pressure budget assigned to proactive reclaim in
> A, there isn't much that can be done.
>
> It's also possible that proactive reclaim in A keeps A/B from hitting
> its limit in the first place.
>
> I have to say, the configuration doesn't really strike me as sensible,
> though. Limits make sense for doing fixed partitioning: A gets 4G, A/B
> gets 2G out of that. But if you do proactive reclaim on A you're
> essentially saying A as a whole is auto-sizing dynamically based on
> its memory access pattern. I'm not sure what it means to then start
> doing fixed partitions in the sublevel.
>

Think of the scenario where there is an infrastructure owner and the
large number of job owners. The aim of the infra owner is to reduce
cost by stuffing as many jobs as possible on the same machine while
job owners want consistent performance.

The job owners usually have meta jobs i.e. a set of small jobs that
run on the same machines and they manage these sub-jobs themselves.

The infra owner wants to do proactive reclaim to trim the current jobs
without impacting their performance and more importantly to have
enough memory to land new jobs (We have learned the hard way that
depending on global reclaim for memory overcommit is really bad for
isolation).

In the above scenario the configuration you mentioned might not be
sensible is really possible. This is exactly what we have in prod. You
can also get the idea why I am asking for flexibility for the cost of
proactive reclaim.

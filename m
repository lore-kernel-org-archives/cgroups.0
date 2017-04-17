From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Mon, 17 Apr 2017 13:26:37 +0900
Message-ID: <20170417042637.GB20981@bbox>
References: <20170317231636.142311-1-timmurray@google.com>
 <20170330155123.GA3929@cmpxchg.org>
 <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw@mail.gmail.com>
 <20170413043047.GA16783@bbox>
 <20170413160147.GB29727@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170413160147.GB29727-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patrik Torstensson <totte-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

Hi Johannes,

On Thu, Apr 13, 2017 at 12:01:47PM -0400, Johannes Weiner wrote:
> On Thu, Apr 13, 2017 at 01:30:47PM +0900, Minchan Kim wrote:
> > On Thu, Mar 30, 2017 at 12:40:32PM -0700, Tim Murray wrote:
> > > As a result, I think there's still a need for relative priority
> > > between mem cgroups, not just an absolute limit.
> > > 
> > > Does that make sense?
> > 
> > I agree with it.
> > 
> > Recently, embedded platform's workload for smart things would be much
> > diverse(from game to alarm) so it's hard to handle the absolute limit
> > proactively and userspace has more hints about what workloads are
> > more important(ie, greedy) compared to others although it would be
> > harmful for something(e.g., it's not visible effect to user)
> > 
> > As a such point of view, I support this idea as basic approach.
> > And with thrashing detector from Johannes, we can do fine-tune of
> > LRU balancing and vmpressure shooting time better.
> > 
> > Johannes,
> > 
> > Do you have any concern about this memcg prority idea?
> 
> While I fully agree that relative priority levels would be easier to
> configure, this patch doesn't really do that. It allows you to set a
> scan window divider to a fixed amount and, as I already pointed out,
> the scan window is no longer representative of memory pressure.
> 
> [ Really, sc->priority should probably just be called LRU lookahead
>   factor or something, there is not much about it being representative
>   of any kind of urgency anymore. ]

I agree that sc->priority is not memory pressure indication.
I should have clarified my intention. Sorry about that.

I'm not saying I like this implementation as I mentioned with
previous reply.
http://lkml.kernel.org/r/20170322052013.GE30149@bbox

Just about general idea, in global OOM case, break proportional
reclaim and then prefering low-priority group's reclaim would be
good for some workload like current embedded platform. And to
achieve it, aging velocity control via scan window adjusting seems
to be reasonable.

> 
> With this patch, if you configure the priorities of two 8G groups to 0
> and 4, reclaim will treat them exactly the same*. If you configure the
> priorities of two 100G groups to 0 and 7, reclaim will treat them
> exactly the same. The bigger the group, the more of the lower range of
> the priority range becomes meaningless, because once the divider
> produces outcomes bigger than SWAP_CLUSTER_MAX(32), it doesn't
> actually bias reclaim anymore.

It seems it's the logic of memcg reclaim not global which is major
concern for current problem because there is no set up limitation for
each memcg.

> 
> So that's not a portable relative scale of pressure discrimination.
> 
> But the bigger problem with this is that, as sc->priority doesn't
> represent memory pressure anymore, it is merely a cut-off for which
> groups to scan and which groups not to scan *based on their size*.

Yes, because there are no measurable pressure concept in current VM
and you are trying to add the notion which is really good!

> 
> That is the same as setting memory.low!
> 
> * For simplicity, I'm glossing over the fact here that LRUs are split
>   by type and into inactive/active, so in reality the numbers are a
>   little different, but you get the point.
> 
> > Or
> > Do you think the patchset you are preparing solve this situation?
> 
> It's certainly a requirement. In order to implement a relative scale
> of memory pressure discrimination, we first need to be able to really
> quantify memory pressure.

Yeb. If we can get it, it would be better than unconditional
discriminated aging by the static priority which would leave
non-workingset pages in high priority group while workingset in
low-priority group would be evicted.

Rather than it, we ages every group's LRU fairly and if high-priority
group makes memory pressure beyond his threshold, VM should feedback
to low priority groups to be reclaimed more, which would be better.

> 
> Then we can either allow setting absolute latency/slowdown minimums
> for each group, with reclaim skipping groups above those thresholds,
> or we can map a relative priority scale against the total slowdown due
> to lack of memory in the system, and each group gets a relative share
> based on its priority compared to other groups.

Fully agreed.

> 
> But there is no way around first having a working measure of memory
> pressure before we can meaningfully distribute it among the groups.

Yeb. I'm looking foward to seeing it.

Thanks for the thoughtful comment, Johannes!

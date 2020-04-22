From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Wed, 22 Apr 2020 15:26:32 +0200
Message-ID: <20200422132632.GG30312@dhcp22.suse.cz>
References: <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200421165601.GA345998-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 21-04-20 12:56:01, Johannes Weiner wrote:
> On Tue, Apr 21, 2020 at 06:11:38PM +0200, Michal Hocko wrote:
> > On Tue 21-04-20 10:27:46, Johannes Weiner wrote:
> > > On Tue, Apr 21, 2020 at 01:06:12PM +0200, Michal Hocko wrote:
> > [...]
> > > > I am also not sure about the isolation aspect. Because an external
> > > > memory pressure might have pushed out memory to the swap and then the
> > > > workload is throttled based on an external event. Compare that to the
> > > > memory.high throttling which is not directly affected by the external
> > > > pressure.
> > > 
> > > Neither memory.high nor swap.high isolate from external pressure.
> > 
> > I didn't say they do. What I am saying is that an external pressure
> > might punish swap.high memcg because the external memory pressure would
> > eat up the quota and trigger the throttling.
> 
> External pressure could also push a cgroup into a swap device that
> happens to be very slow and cause the cgroup to be throttled that way.

Yes but it would get throttled at the fault time when the swapped out
memory is needed. Unless the anon workload actively doesn't fit into
memory then refaults are not that common. Compare that to a continuous
throttling because your memory has been pushed out to swap and you
cannot do much about that without being slowed down to crawling.

> But that effect is actually not undesirable. External pressure means
> that something more important runs and needs the memory of something
> less important (otherwise, memory.low would deflect this intrusion).
> 
> So we're punishing/deprioritizing the right cgroup here. The one that
> isn't protected from memory pressure.
> 
> > It is fair to say that this externally triggered interference is already
> > possible with swap.max as well though. It would likely be just more
> > verbose because of the oom killer intervention rather than a slowdown.
> 
> Right.
> 
> > > They
> > > are put on cgroups so they don't cause pressure on other cgroups. Swap
> > > is required when either your footprint grows or your available space
> > > shrinks. That's why it behaves like that.
> > > 
> > > That being said, I think we're getting lost in the implementation
> > > details before we have established what the purpose of this all
> > > is. Let's talk about this first.
> > 
> > Thanks for describing it in the length. I have a better picture of the
> > intention (this should have been in the changelog ideally). I can see
> > how the swap consumption throttling might be useful but I still dislike the
> > proposed implementation. Mostly because of throttling of all allocations
> > regardless whether they can contribute to the swap consumption or not.
> 
> I mean, even if they're not swappable, they can still contribute to
> swap consumption that wouldn't otherwise have been there. Each new
> page that comes in displaces another page at the end of the big LRU
> pipeline and pushes it into the mouth of reclaim - which may swap. So
> *every* allocation has a certain probability of increasing swap usage.

You are right of course and this makes an reasonable implementation of
swap.high far from trivial. I would even dare to say that an optimal
implementation is impossible because the throttling cannot be done in
the reclaim context (at least not in your case where you rely on the
global reclaim).

> The fact that we have reached swap.high is a good hint that reclaim
> has indeed been swapping quite aggressively to accomodate incoming
> allocations, and probably will continue to do so.

You can fill up a swap space even without an aggressive reclaim so I
wouldn't make any assumptions just based on the amount of swapped out
memory.
 
> We could check whether there are NO anon pages left in a workload, but
> that's such an extreme and short-lived case that it probably wouldn't
> make a difference in practice.
>
> We could try to come up with a model that calculates a probabilty of
> each new allocation to cause swap. Whether that new allocation itself
> is swapbacked would of course be a factor, but there are other factors
> as well: the millions of existing LRU pages, the reclaim decisions we
> will make, swappiness and so forth.

Yeah, an optimal solution likely doesn't exist. Some portion of
get_scan_count could be used to have at least some clue on whether
swap out is likely.
 
> Of course, I agree with you, if all you have coming in is cache
> allocations, you'd *eventually* run out of pages to swap.
>
> However, 10G of new active cache allocations can still cause 10G of
> already allocated anon pages to get swapped out. For example if a
> malloc() leak happened *before* the regular cache workingset is
> established. We cannot retro-actively throttle those anon pages, we
> can only keep new allocations from pushing old ones into swap.

Yes and this is the fundamental problem we have here as I have mentioned
above as well. Throttling and swapout are simply not bound together. So
we can only guess. And that guessing is a concern because opinions on
that might differ. For example I really dislike the huge hammer to
throttle for all charges but I do see how reasonable people might
disagree on this matter.

That being said I believe our discussion is missing an important part.
There is no description of the swap.high semantic. What can user expect
when using it?
-- 
Michal Hocko
SUSE Labs

From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Fri, 1 Feb 2019 11:27:41 +0100
Message-ID: <20190201102515.GK11599@dhcp22.suse.cz>
References: <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190130192345.GA20957@cmpxchg.org>
 <20190130200559.GI18811@dhcp22.suse.cz>
 <20190130213131.GA13142@cmpxchg.org>
 <20190131085808.GO18811@dhcp22.suse.cz>
 <20190131162248.GA17354@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190131162248.GA17354@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu 31-01-19 11:22:48, Johannes Weiner wrote:
> On Thu, Jan 31, 2019 at 09:58:08AM +0100, Michal Hocko wrote:
> > On Wed 30-01-19 16:31:31, Johannes Weiner wrote:
> > > On Wed, Jan 30, 2019 at 09:05:59PM +0100, Michal Hocko wrote:
> > [...]
> > > > I thought I have already mentioned an example. Say you have an observer
> > > > on the top of a delegated cgroup hierarchy and you setup limits (e.g. hard
> > > > limit) on the root of it. If you get an OOM event then you know that the
> > > > whole hierarchy might be underprovisioned and perform some rebalancing.
> > > > Now you really do not care that somewhere down the delegated tree there
> > > > was an oom. Such a spurious event would just confuse the monitoring and
> > > > lead to wrong decisions.
> > > 
> > > You can construct a usecase like this, as per above with OOM, but it's
> > > incredibly unlikely for something like this to exist. There is plenty
> > > of evidence on adoption rate that supports this: we know where the big
> > > names in containerization are; we see the things we run into that have
> > > not been reported yet etc.
> > > 
> > > Compare this to real problems this has already caused for
> > > us. Multi-level control and monitoring is a fundamental concept of the
> > > cgroup design, so naturally our infrastructure doesn't monitor and log
> > > at the individual job level (too much data, and also kind of pointless
> > > when the jobs are identical) but at aggregate parental levels.
> > > 
> > > Because of this wart, we have missed problematic configurations when
> > > the low, high, max events were not propagated as expected (we log oom
> > > separately, so we still noticed those). Even once we knew about it, we
> > > had trouble tracking these configurations down for the same reason -
> > > the data isn't logged, and won't be logged, at this level.
> > 
> > Yes, I do understand that you might be interested in the hierarchical
> > accounting.
> > 
> > > Adding a separate, hierarchical file would solve this one particular
> > > problem for us, but it wouldn't fix this pitfall for all future users
> > > of cgroup2 (which by all available evidence is still most of them) and
> > > would be a wart on the interface that we'd carry forever.
> > 
> > I understand even this reasoning but if I have to chose between a risk
> > of user breakage that would require to reimplement the monitoring or an
> > API incosistency I vote for the first option. It is unfortunate but this
> > is the way we deal with APIs and compatibility.
> 
> I don't know why you keep repeating this, it's simply not how Linux
> API is maintained in practice.
> 
> In cgroup2, we fixed io.stat to not conflate discard IO and write IO:
> 636620b66d5d4012c4a9c86206013964d3986c4f
> 
> Linus changed the Vmalloc field semantics in /proc/meminfo after over
> a decade, without a knob to restore it in production:
> 
>     If this breaks anything, we'll obviously have to re-introduce the code
>     to compute this all and add the caching patches on top.  But if given
>     the option, I'd really prefer to just remove this bad idea entirely
>     rather than add even more code to work around our historical mistake
>     that likely nobody really cares about.
>     a5ad88ce8c7fae7ddc72ee49a11a75aa837788e0
> 
> Mel changed the zone_reclaim_mode default behavior after over a
> decade:
> 
>     Those that require zone_reclaim_mode are likely to be able to
>     detect when it needs to be enabled and tune appropriately so lets
>     have a sensible default for the bulk of users.
>     4f9b16a64753d0bb607454347036dc997fd03b82
>     Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> And then Mel changed the default zonelist ordering to pick saner
> behavior for most users, followed by a complete removal of the zone
> list ordering, after again, decades of existence of these things:
> 
>     commit c9bff3eebc09be23fbc868f5e6731666d23cbea3
>     Author: Michal Hocko <mhocko@suse.com>
>     Date:   Wed Sep 6 16:20:13 2017 -0700
> 
>         mm, page_alloc: rip out ZONELIST_ORDER_ZONE
> 
> And why did we do any of those things and risk user disruption every
> single time? Because the existing behavior was not a good default, a
> burden on people, and the risk of breakage was sufficiently low.
> 
> I don't see how this case is different, and you haven't provided any
> arguments that would explain that.

Because there is no simple way to revert in _this_ particular case. Once
you change the semantic of the file you cannot simply make it
non-hierarchical after somebody complains. You do not want to break both
worlds. See the difference?

[...]
> > Those users requiring the hierarchical beahvior can use the new file
> > without any risk of breakages so I really do not see why we should
> > undertake the risk and do it the other way around.
> 
> Okay, so let's find a way forward here.
> 
> 1. A new memory.events_tree file or similar. This would give us a way
> to get the desired hierarchical behavior. The downside is that it's
> suggesting that ${x} and ${x}_tree are the local and hierarchical
> versions of a cgroup file, and that's false everywhere else. Saying we
> would document it is a cop-out and doesn't actually make the interface
> less confusing (most people don't look at errata documentation until
> they've been burned by unexpected behavior).
> 
> 2. A runtime switch (cgroup mount option, sysctl, what have you) that
> lets you switch between the local and the tree behavior. This would be
> able to provide the desired semantics in a clean interface, while
> still having the ability to support legacy users.

With an obvious downside that one or the other usecase has to learn that
the current semantic is different than expected which is again something
that has to be documented so we are in the same "people don't look at
errata documentation...". Another obvious problem is that you might have
two workloads with different semantic expectations and then this option
simply falls flat.

> 2a. A runtime switch that defaults to the local behavior.
> 
> 2b. A runtime switch that defaults to the tree behavior.
> 
> The choice between 2a and 2b comes down to how big we evaluate the
> risk that somebody has an existing dependency on the local behavior.
> 
> Given what we know about cgroup2 usage, and considering our previous
> behavior in such matters, I'd say 2b is reasonable and in line with
> how we tend to handle these things. On the tiny chance that somebody
> is using the current behavior, they can flick the switch (until we add
> the .local files, or simply use the switch forever).

My preference is 1 but if there is a _larger_ consensus of different
cgroup v2  users that 2 is more preferred then I can live with that.
-- 
Michal Hocko
SUSE Labs

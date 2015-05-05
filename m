From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 20:29:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505052007140.4225@nanos>
References: <5546C34C.7050202@huawei.com> <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com> <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com> <554737AE.5040402@huawei.com> <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <20150505144104.GS1971@htj.duckdns.org> <20150505151113.GP21418@twins.programming.kicks-ass.net> <20150505161335.GT1971@htj.duckdns.org> <20150505165006.GR21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150505165006.GR21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, 5 May 2015, Peter Zijlstra wrote:
> On Tue, May 05, 2015 at 12:13:35PM -0400, Tejun Heo wrote:
> > On Tue, May 05, 2015 at 05:11:13PM +0200, Peter Zijlstra wrote:
> > > 
> > > So no; hard failure is good and desired. It allows guarantees, which is
> > > a good and desired feature of control.
> > 
> > Isn't that too sweeping a statement?  We want them in some places but
> > not necessarily in all places.  The hard failures aren't going away.
> > They're just localized to specific areas where they're easier to
> > handle.
> 
> Easier how? I'm really not seeing how any of this is making things
> easier for anybody.
> 
> All I'm seeing is that you're making cgroups useless for people who want
> to guarantee things (eg. the realtime people).

I fully agree and after reading through this thread I really have to
say that this whole notion of relax the admission control and then try
to magically converge to the resource limits is horrible in all
aspects.

Hierarchies must have a strictly inherited and overall consistent
resource management and therefor resource limitation. Otherwise they
are just useless.

The idea of allowing overcommitment and magically converging to back
to the limits yells heuristics all over the place and we all know how
reliable heuristics are.

Tejun, you try to make the whole configuration and placement simpler
for the user, but all you achieve is that you act like all these
politicians who promise tax cuts and whatever and forget about them
once the elections are over. How is that going to make stuff simpler
for users/admins? Not at all.

Instead of failing hard at placement/configuration time they get
surprised by hard to understand fallout of magic convergence
heuristics. That's crap and no matter how you argue it stays crap.

As Peter said several times: hard failure is good and desired. It's a
very clear information on which people can act on. If the failures
modes are nilly-willy today, as you wrote somewhere, then we need to
fix that and make them consistent and understandable and not replace
them by half baken heuristics which postpone the failure to some point
where it is even less understandable.

If there are issues with run-away problems, i.e. upping a resource
limit which gets eaten up from the existing tasks before you can admit
a new one, then your magic convergence thing is again the wrong
answer. The right approach is:

      1) Up the limit and make a reservation at the same time
      2) Admit the new task and allow it to consume the reservation
      3) Set it effective

You can apply this to ALL sorts of resource controllers and you give
the user a very simple to understand mechanism to control and
configure his system.

> Are you really going to force us to abandon cgroups and invent yet
> another grouping thing?

Sigh no. I think cgroups can be fixed, if we just adhere to the basic
principles of hierarchical resource management and remove/reject all
magic "we'll fix that for you" nonsense.

Thanks,

	tglx

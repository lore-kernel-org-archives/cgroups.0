From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 17:11:13 +0200
Message-ID: <20150505151113.GP21418@twins.programming.kicks-ass.net>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <20150505144104.GS1971@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150505144104.GS1971@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 05, 2015 at 10:41:04AM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Mon, May 04, 2015 at 02:37:38PM +0200, Peter Zijlstra wrote:
> > > I just realized we allow removing/adding controllers from/to cgroups
> > > while there are tasks in them, which isn't safe unless we eliminate all
> > > can_attach callbacks. We've done so for some cgroup subsystems, but
> > > there are still a few of them...
> > 
> > You can't remove can_attach(), we must be able to disallow joining a
> > cgroup.
> > 
> > If that results in you not being able to change the cgroup setup with
> > tasks in, so be it -- that seems like a sane restriction anyhow.
> 
> This is really an interface policy issue.  For all other controllers,
> it's almost trivial to let organizational operations (setting up
> hierarchies, moving processes around) overrule controller
> configurations.  The main benefit of doing this is that this decouples
> organizational operations from resource control.  Users can depend on
> the fact that allowed organizational operations won't fail due to
> specific controller configuration issues.

But but but... that doesn't make any damn sense! Why would you want to
do something mad like that?

To me the organization is very much part of the control structure. It
cannot be an invariant. Treating it like that destroys the whole notion
of a hierarchy.

> This also works well with controllers accepting target configurations
> regardless of the current state and enforcing rules to converge to the
> configured state instead.

I think we had a long discussion on that which we never finished. I'm
not much for converging to a state. Either it can or it can not and you
hard fail.

With this soft lets just accept any old crap mentality you cannot
provide guarantees.

> e.g. if you set max memory lower than the
> currently used, the config will be accepted and the controller will
> keep trying to make the current state converge to the target state.
> This is important as rejecting configuration can lead to chasing game
> between configuration attempts and run-away resource consumption.

This is an entirely different issue; albeit with its own pitfalls, what
if you put the max too low and you run into a never ending reclaim loop?
Attempting to attain the unattainable.

> Now, RR slices are the special case here because it's inherently
> different from every other resource cgroup is concerned with. 

I don't think so, any controller which wants to carve up a fixed
resource in non proportional ways is going to run into this.

Its just that you don't want this, but that doesn't render it less
useful.

> It
> simply doesn't fit into the same model that other resources follow.
> There are several options we can try.
> 
> 1. Decouple RR slices from cpu controller.  This would be the best
>    route to follow.  RR slices need a hard allocator no matter what we
>    do.  There isn't much point in imposing hierarchical structure on
>    top of it.

The same is true of SCHED_DEADLINE, we hard divide a fixed amount. We've
not currently exposed it to cgroups, but we want to eventually.

As to not having a hierarchy; you're the one destroying it by saying the
organization should be decoupled from the controller.

And, no a hierarchy still makes perfect sense, think of containers, they
might not even see the parent.

> 3. Take compromise in the other direction - add exceptions to
>    organizational operations but clearly limit the failure modes.  We
>    prolly want to structure code in a way to enforce this.

I'm for failure modes as you should well now by know ;-)

I really think you're moving in the wrong direction with the whole
cgroup stuff if you just want to willy nilly allow everything.

Also, who's the one doing a PID controller which will hard fail fork?
How are you going to do away with can_attach() there? Surely you need to
dis-allow another task joining when its at its maximum number of allowed
PIDs, the same condition you're going to fail fork().

So no; hard failure is good and desired. It allows guarantees, which is
a good and desired feature of control.

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 18:50:06 +0200
Message-ID: <20150505165006.GR21418@twins.programming.kicks-ass.net>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <20150505144104.GS1971@htj.duckdns.org>
 <20150505151113.GP21418@twins.programming.kicks-ass.net>
 <20150505161335.GT1971@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150505161335.GT1971@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 05, 2015 at 12:13:35PM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, May 05, 2015 at 05:11:13PM +0200, Peter Zijlstra wrote:
> ...
> > But but but... that doesn't make any damn sense! Why would you want to
> > do something mad like that?
> > 
> > To me the organization is very much part of the control structure. It
> > cannot be an invariant. Treating it like that destroys the whole notion
> > of a hierarchy.
> 
> You and I don't really agree on this.  The disagreement is fine but
> what I don't get is why this is such a big deal.  How would it break
> the whole notion of a hierarchy?  A user isn't allowed to esacpe the
> subhierarchy it's allowed in no matter what.  Whether organizational
> operations supercedes configurations or not doesn't matter as long as
> the user is confined under the right hierarchy.

I really don't get what you're saying there. If its not allowed to
'escape' there must be some equivalent of can_attach().

Otherwise you simply cannot reject the move.

> Furthermore, in majority of use cases, organizational operations are
> used to set up the hierarchy when starting up a group and then left
> alone.  For stateful controller like memcg process migrations are
> inherently expensive and intrusive, so the usage model isn't
> arbitrary.  This is a corner case issue and doesn't really affect the
> whole model.

Again, I don't follow, so why is can_attach() bad?

> > I don't think so, any controller which wants to carve up a fixed
> > resource in non proportional ways is going to run into this.
> > 
> > Its just that you don't want this, but that doesn't render it less
> > useful.
> 
> Well, of the resources that we handle right now, it is a special case
> and a sucky one at that because it ties itself to regular cpu
> controller which doesn't need that behavior.

It doesn't 'tie' itself to the cpu controller, its a fundamental part of
the cpu controller. The cpu controller is about all computation time,
RR/FIFO is a very much part of that.

And RR/FIFO is extra special in that if you grant a process that it can
suck your machine dry of this time. This is why you must configure it.

People should not unknowingly let programs use RR/FIFO. Also what sorts
of 'problems' are people having because of this? What kind of
applications 'require' RR/FIFO on a normal desktop?

> > As to not having a hierarchy; you're the one destroying it by saying the
> > organization should be decoupled from the controller.
> 
> I don't get this part.  How does making organization supercede
> configuration destroy hierarchy?

If you want to unconditionally allow task migration between groups, the
hierarchy doesn't actually mean anything.

You can't enforce hierarchical constraints. Which to me is the entire
point of having a hierarchy.

> > And, no a hierarchy still makes perfect sense, think of containers, they
> > might not even see the parent.
> 
> The mode of configuration is different tho.  No matter what we do, if
> we want to automate this sort of distribution with resource as limited
> as realtime slices, it'll need a separate allocator which can carve
> out resources on demand.

But you don't want to automate, full stop.

> This can't be ratio-distributed or
> soft-capped and having to tie this together with regular cpu
> controller is annoying.

Welcome to actual world issues. Stop pretending this stuff is easy and
can be hidden from the user.

IF people want to use RR/FIFO they had better damn well know what
they're doing. There is not way around that. There's just too many
things that can go wrong with it.

If they don't want to deal with this problems, then tell them to go
away. Do _NOT_ pretend its easy and fudge it for them.

This on-demand carving thing you mention, that's a _MASSIVE_ fudge. Just
don't even go there.

> > I really think you're moving in the wrong direction with the whole
> > cgroup stuff if you just want to willy nilly allow everything.
> 
> Well, let's agree to disagree on that one.  It's not about allowing
> willy nilly everything but separating out the specification of intent
> from the current state and you also saw how coupling the two tightly
> messed up cpuset.  It can make configuration tedious enough to the
> point where it becomes impractical to use under certain circumstances.

Well, no I didn't see how cpusets was messed up. You see that is where
we start to disagree.

The improvement I wanted to cpusets was to simply disallow hotplug when
there were tasks that could not go elsewhere.

> The thing is, allowing to specify configurations doesn't prevent the
> user from enforcing stricter rules.  The current state is always
> visible to the user and if it fails to converge, the user can take
> whatever actions that it needs to take to remedy the situation.

Right, so how about failing hotplug if there's (user) tasks pinned to a
cpu? That's clearly visible and the user can go fix it if he really
wants to do the unplug.

That's a very similar thing, but you've argued against it.

That said, this is not the point we're now arguing about; I want the
hierarchy to actually mean something, and the only way to do that is to
allow can_attach().

Without can_attach() one cannot provide hierarchical constraints.

> > Also, who's the one doing a PID controller which will hard fail fork?
> > How are you going to do away with can_attach() there? Surely you need to
> > dis-allow another task joining when its at its maximum number of allowed
> > PIDs, the same condition you're going to fail fork().
> 
> It allows migrations into already capped cgroup. 

OMFG, that's so broken. This basically renders the entire cap useless.

So you now have: no more than 'N' tasks, except <big-gaping-hole>.

> It just won't allow
> new forks.  This isn't different from allowing limit to be lowered
> below the current and we *do* want that because otherwise it becomes a
> race between whoever is setting the config and whoever is consuming
> the resources.  You always wanna be able to say "stop giving out
> resources now".

Ah, that is what you've been trying to say with your memcg example. Well
see this cannot work for realtime (and anybody else who wants to provide
actual guarantees).

You simply cannot lower the max below the current usage, end of story.
Because it will _NOT_ converge. Tasks were promised that time and will
continue using it.

If you want to lower it, first take some tasks out. Idem the cpu
affinity vs hotplug.

Same for your PID controller btw, it will NOT converge, tasks won't
magically go away just because you want them to.

Also, there is no problem failing any of these setting, its 'obvious'
what the problem is. When they return -EBUSY or whatnot, the resource is
taken and you need to go free some up.

> > So no; hard failure is good and desired. It allows guarantees, which is
> > a good and desired feature of control.
> 
> Isn't that too sweeping a statement?  We want them in some places but
> not necessarily in all places.  The hard failures aren't going away.
> They're just localized to specific areas where they're easier to
> handle.

Easier how? I'm really not seeing how any of this is making things
easier for anybody.

All I'm seeing is that you're making cgroups useless for people who want
to guarantee things (eg. the realtime people).

Are you really going to force us to abandon cgroups and invent yet
another grouping thing?

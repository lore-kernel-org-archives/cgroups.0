From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 14:31:26 -0400
Message-ID: <20150505183126.GX1971@htj.duckdns.org>
References: <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <20150505144104.GS1971@htj.duckdns.org>
 <20150505151113.GP21418@twins.programming.kicks-ass.net>
 <20150505161335.GT1971@htj.duckdns.org>
 <20150505165006.GR21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DeTi+1TnMLNL+gJSwd7AjaBwIeBUv3rBhoFV9EplK68=;
        b=WCZA1fcYEIlW8A25/7aD9tCj5X/R1y5OPoxfVm7RC3jSdOSyne30yJ/7qRO0SbERZt
         5YSVx98K5rK06GRVNERVAXOUN2jGCv3ry4OdbAguG/Twh45mI5H1wVBmiO6QKMLN7FCe
         DLPCONomvbhhr61RyX9Hp3ovW6nd9Pl7zkmyEFEiqICgvOO21O5s6TH1iIInSvhPqSqw
         k69eft8dAV09Kv+1l8kSqZ0Qa2scDV2OHqhVOG0w593YFg0A/I6ru51it6RjXkNtR5aD
         iMdBTl8nD77I9h9I1xqeCWypwb/fXKAGEF4CGwSSwenIMliDAfZYWmgPMpmcpFmvcbxH
         rJIA==
Content-Disposition: inline
In-Reply-To: <20150505165006.GR21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, again.

On Tue, May 05, 2015 at 06:50:06PM +0200, Peter Zijlstra wrote:
> I really don't get what you're saying there. If its not allowed to
> 'escape' there must be some equivalent of can_attach().
> 
> Otherwise you simply cannot reject the move.

A given user isn't allowed to move processes into a cgroup outside its
subhierarchy and the hierarchical resource control keeps the
subhierarchy under the limits no matter what the user does inside it.
Whether can_attach can fail or not is peripheral in this sense - if a
user can move processes into a cgroup outside its allowed scope, the
user can already escape regardless of the specifics of configuration.

Any user of cgroups should be confined to its scope and when it's
confined that way, the hierarchical limits are enforced no matter what
happens in its subhierarchy.

> > Furthermore, in majority of use cases, organizational operations are
> > used to set up the hierarchy when starting up a group and then left
> > alone.  For stateful controller like memcg process migrations are
> > inherently expensive and intrusive, so the usage model isn't
> > arbitrary.  This is a corner case issue and doesn't really affect the
> > whole model.
> 
> Again, I don't follow, so why is can_attach() bad?

It's more like can_attach failures don't add much for other
controllers.  Please see below.

> People should not unknowingly let programs use RR/FIFO. Also what sorts
> of 'problems' are people having because of this? What kind of
> applications 'require' RR/FIFO on a normal desktop?

The cases I hear about are mostly audio applications which end up in
whatever default cgroups other applications are put in w/o an easy way
to configure the hierarchy for RR slices.  As I wrote way back, if
these can't be decoupled, whoever is setting up cpu cgroup hierarchies
will also have to take part in distributing realtime slices.

This might not necessarily be a bad thing.  It's just different from
everything else cgroups deal with at this point.

> > I don't get this part.  How does making organization supercede
> > configuration destroy hierarchy?
> 
> If you want to unconditionally allow task migration between groups, the
> hierarchy doesn't actually mean anything.
>
> You can't enforce hierarchical constraints. Which to me is the entire
> point of having a hierarchy.

No, hierarchy still puts restrictions on who can do what where.
Whether organization operations supercede configurations or not
doens't affect this at all.  Again, if you can stow away processes out
of your domain, you're escaping the hierarchical constrasints all the
same.  Delegations need to scoped no matter what.

> > This can't be ratio-distributed or
> > soft-capped and having to tie this together with regular cpu
> > controller is annoying.
> 
> Welcome to actual world issues. Stop pretending this stuff is easy and
> can be hidden from the user.
> 
> IF people want to use RR/FIFO they had better damn well know what
> they're doing. There is not way around that. There's just too many
> things that can go wrong with it.
> 
> If they don't want to deal with this problems, then tell them to go
> away. Do _NOT_ pretend its easy and fudge it for them.
> 
> This on-demand carving thing you mention, that's a _MASSIVE_ fudge. Just
> don't even go there.

How is on-demand allocation fudging?  You can do it manually or you
can have policies set up to allocate the specific resource.  This is
really beside the point tho.  What I was trying to say was that this
takes a different approach from other non-hard resources.

> > Well, let's agree to disagree on that one.  It's not about allowing
> > willy nilly everything but separating out the specification of intent
> > from the current state and you also saw how coupling the two tightly
> > messed up cpuset.  It can make configuration tedious enough to the
> > point where it becomes impractical to use under certain circumstances.
> 
> Well, no I didn't see how cpusets was messed up. You see that is where
> we start to disagree.

Yeah, seems that way.  Let's agree to disagree here.

> The improvement I wanted to cpusets was to simply disallow hotplug when
> there were tasks that could not go elsewhere.

Would that mean we're also gonna disallow hotunplug if some threads
are pinned to that cpu?  And the kernel would still be changing
configurations in an non-reversible way.  Again, how does that jive
with plain affinities?

> That said, this is not the point we're now arguing about; I want the
> hierarchy to actually mean something, and the only way to do that is to
> allow can_attach().
> 
> Without can_attach() one cannot provide hierarchical constraints.

I don't think this is the point either.  The point is how to deal with
hard resources that can't be permissive by default.

> > > Also, who's the one doing a PID controller which will hard fail fork?
> > > How are you going to do away with can_attach() there? Surely you need to
> > > dis-allow another task joining when its at its maximum number of allowed
> > > PIDs, the same condition you're going to fail fork().
> > 
> > It allows migrations into already capped cgroup. 
> 
> OMFG, that's so broken. This basically renders the entire cap useless.
> 
> So you now have: no more than 'N' tasks, except <big-gaping-hole>.

We need that "hole" anyway as I wrote below.  The rule is "no new fork
if there are more than N tasks in the group" and that's it.

...
> Ah, that is what you've been trying to say with your memcg example. Well
> see this cannot work for realtime (and anybody else who wants to provide
> actual guarantees).
> 
> You simply cannot lower the max below the current usage, end of story.
> Because it will _NOT_ converge. Tasks were promised that time and will
> continue using it.

So, this is the key issue.  These resources are fundamentally
different.

> If you want to lower it, first take some tasks out. Idem the cpu
> affinity vs hotplug.
> 
> Same for your PID controller btw, it will NOT converge, tasks won't
> magically go away just because you want them to.

It won't automatically converge of course.  It just won't allow new
forks.  Moving processes into the cgroup is at the same level as
lowering the limit below current.  If one is allowed, the other is
allowed too and neither can allow the user to escape its hierarchical
limit as long as the user is properly contained in its subhierarchy.

> Also, there is no problem failing any of these setting, its 'obvious'
> what the problem is. When they return -EBUSY or whatnot, the resource is
> taken and you need to go free some up.

Hmm... so, I kinda agree here.  If we clearly define and constrain how
we use -EBUSY (hard resources only), it can work out.

Thanks.

-- 
tejun

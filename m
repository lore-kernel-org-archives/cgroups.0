From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 12:13:35 -0400
Message-ID: <20150505161335.GT1971@htj.duckdns.org>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <20150505144104.GS1971@htj.duckdns.org>
 <20150505151113.GP21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UdwpL2N8WdXBZfrOksgM+lBeHx/FtIDh+1my7MIFCtQ=;
        b=tXlLt63zXkpAiI/cmHqOni1rnbQipdZfFA6HjAos/L4lIk2ruGE7a6R9rZYCRjrQbl
         D3DpEZb5m2fsu9R65n1NoOdynWtpSpTsxTi8ANLoo/nrDXSc2A+kVBWVquNx1W08hmRp
         VHRLapsXIMJWCMkRtjWXJuKCgvQE78I8V8HTtUmU6IM0n9ZYcYFPOdRsnWmpjcoojLlt
         rmsMzDXKPSM5ZiwOc7yCwZHps0apGbwD/GrOKbzP6gM0glfdRAJwNnjN7iiYvZZ3aKAX
         bAA3oxjo2Z9H5nFsZAXt8ccHEgezN0vYNVQghQ/H4mRf0UinMzoXHsyEWaUW2OJFb+Qq
         PiyQ==
Content-Disposition: inline
In-Reply-To: <20150505151113.GP21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, Peter.

On Tue, May 05, 2015 at 05:11:13PM +0200, Peter Zijlstra wrote:
...
> But but but... that doesn't make any damn sense! Why would you want to
> do something mad like that?
> 
> To me the organization is very much part of the control structure. It
> cannot be an invariant. Treating it like that destroys the whole notion
> of a hierarchy.

You and I don't really agree on this.  The disagreement is fine but
what I don't get is why this is such a big deal.  How would it break
the whole notion of a hierarchy?  A user isn't allowed to esacpe the
subhierarchy it's allowed in no matter what.  Whether organizational
operations supercedes configurations or not doesn't matter as long as
the user is confined under the right hierarchy.

Furthermore, in majority of use cases, organizational operations are
used to set up the hierarchy when starting up a group and then left
alone.  For stateful controller like memcg process migrations are
inherently expensive and intrusive, so the usage model isn't
arbitrary.  This is a corner case issue and doesn't really affect the
whole model.

> > e.g. if you set max memory lower than the
> > currently used, the config will be accepted and the controller will
> > keep trying to make the current state converge to the target state.
> > This is important as rejecting configuration can lead to chasing game
> > between configuration attempts and run-away resource consumption.
> 
> This is an entirely different issue; albeit with its own pitfalls, what
> if you put the max too low and you run into a never ending reclaim loop?
> Attempting to attain the unattainable.

That's an oom condition and memcg handles it accordingly.

> > Now, RR slices are the special case here because it's inherently
> > different from every other resource cgroup is concerned with. 
> 
> I don't think so, any controller which wants to carve up a fixed
> resource in non proportional ways is going to run into this.
> 
> Its just that you don't want this, but that doesn't render it less
> useful.

Well, of the resources that we handle right now, it is a special case
and a sucky one at that because it ties itself to regular cpu
controller which doesn't need that behavior.

> > It
> > simply doesn't fit into the same model that other resources follow.
> > There are several options we can try.
> > 
> > 1. Decouple RR slices from cpu controller.  This would be the best
> >    route to follow.  RR slices need a hard allocator no matter what we
> >    do.  There isn't much point in imposing hierarchical structure on
> >    top of it.
> 
> The same is true of SCHED_DEADLINE, we hard divide a fixed amount. We've
> not currently exposed it to cgroups, but we want to eventually.
> 
> As to not having a hierarchy; you're the one destroying it by saying the
> organization should be decoupled from the controller.

I don't get this part.  How does making organization supercede
configuration destroy hierarchy?

> And, no a hierarchy still makes perfect sense, think of containers, they
> might not even see the parent.

The mode of configuration is different tho.  No matter what we do, if
we want to automate this sort of distribution with resource as limited
as realtime slices, it'll need a separate allocator which can carve
out resources on demand.  This can't be ratio-distributed or
soft-capped and having to tie this together with regular cpu
controller is annoying.

> > 3. Take compromise in the other direction - add exceptions to
> >    organizational operations but clearly limit the failure modes.  We
> >    prolly want to structure code in a way to enforce this.
> 
> I'm for failure modes as you should well now by know ;-)
> 
> I really think you're moving in the wrong direction with the whole
> cgroup stuff if you just want to willy nilly allow everything.

Well, let's agree to disagree on that one.  It's not about allowing
willy nilly everything but separating out the specification of intent
from the current state and you also saw how coupling the two tightly
messed up cpuset.  It can make configuration tedious enough to the
point where it becomes impractical to use under certain circumstances.

The thing is, allowing to specify configurations doesn't prevent the
user from enforcing stricter rules.  The current state is always
visible to the user and if it fails to converge, the user can take
whatever actions that it needs to take to remedy the situation.

> Also, who's the one doing a PID controller which will hard fail fork?
> How are you going to do away with can_attach() there? Surely you need to
> dis-allow another task joining when its at its maximum number of allowed
> PIDs, the same condition you're going to fail fork().

It allows migrations into already capped cgroup.  It just won't allow
new forks.  This isn't different from allowing limit to be lowered
below the current and we *do* want that because otherwise it becomes a
race between whoever is setting the config and whoever is consuming
the resources.  You always wanna be able to say "stop giving out
resources now".

> So no; hard failure is good and desired. It allows guarantees, which is
> a good and desired feature of control.

Isn't that too sweeping a statement?  We want them in some places but
not necessarily in all places.  The hard failures aren't going away.
They're just localized to specific areas where they're easier to
handle.

Thanks.

-- 
tejun

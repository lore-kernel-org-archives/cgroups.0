From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Tue, 21 Mar 2017 13:39:58 +0100
Message-ID: <20170321123958.af7mcvcovexxzahu@hirez.programming.kicks-ass.net>
References: <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
 <20170210175145.GJ6515@twins.programming.kicks-ass.net>
 <20170212050544.GJ29323@mtj.duckdns.org>
 <20170214103541.GS6515@twins.programming.kicks-ass.net>
 <20170313200544.GE15709@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O5APkL++nj1o1vSTDuU7NSAcmxgGjwFy2xUpLyWMxQQ=; b=Ey5OzdsB+aukrYQNh8sMUtYG+
        ZvECvR8nob9ouXDRMYXeOoAEGxr3yQPuZa2IT7ZvftGnpNsW+TR7NIMC11Q239BvXkQ/qZ/3LSHUH
        6dIGWn8rRjDMlD9sMjWxZtzpY6mF1w6URHXfFriqRkJVQK1OYaoR4TXRmlgBswdtvAMvkmQtkjccb
        kU5vpn+OxEpB2P2aokW5iGjhlHq1zZf5BwkEaKJ3Qafog7+VEmqVym2B1qFUAokqnfxLY4j6IgJ7Z
        uEqU1uv8Q+RGXyYTUu/uKODMMXF/IvFc8cGkHtCYfMYH0UL1irz+ccVU8NSbpC7XhorzFNcCrG/8h
    
Content-Disposition: inline
In-Reply-To: <20170313200544.GE15709-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Mar 13, 2017 at 04:05:44PM -0400, Tejun Heo wrote:
> Hey, Peter.  Sorry about the long delay.

No worries; we're all (too) busy.


> > > If we go to thread mode and back to domain mode, the control knobs for
> > > domain controllers don't make sense on the thread part of the tree and
> > > they won't have cgroup_subsys_state to correspond to either.  For
> > > example,
> > > 
> > >  A - T - B
> > > 
> > > B's memcg knobs would control memory distribution from A and cgroups
> > > in T can't have memcg knobs.  It'd be weird to indicate that memcg is
> > > enabled in those cgroups too.
> > 
> > But memcg _is_ enabled for T. All the tasks are mapped onto A for
> > purpose of the system controller (memcg) and are subject to its
> > constraints.
> 
> Sure, T is contained in A but think about the interface.  For memcg, T
> belongs to A.  B is the first descendant when viewed from memcg, which
> brings about two problems - memcg doesn't have control knobs to assign
> throughout T which is just weird and there's no way to configure how T
> competes against B.
> 
> > > We can make it work somehow.  It's just weird-ass interface.
> > 
> > You could make these control files (read-only?) symlinks back to A's
> > actual control files. To more explicitly show this.
> 
> But the knobs are supposed to control how much resource a child gets
> from its parent.  Flipping that over while walking down the same tree
> sounds horribly ugly and confusing to me.  Besides, that doesn't solve
> the problem with lacking the ability configure T's consumptions
> against B.

So I'm not confused; and I suspect you're not either. But you're worried
about 'simple' people getting confused?

The rules really are fairly straight forward; but yes, it will be a
little more involved than without this. But note that this is an
optional thing, people don't have to make thread groups if they don't
want to. And they further don't have to use non-leaf thread groups.

And at some point, there's no helping stupid; and trying to do so will
only make you insane.

So the fundamental thing to realize (and explain) is that there are two
different types of controllers; and that they operate on different views
of the hierarchy.

I think our goal as a kernel API should be presenting the capabilities
in a concise and consistent manner; and I feel that the proposed
interface is that.

So the points you raise above; about system controller knobs in thread
groups and competition between thread and system groups as seen for
system controllers are confusion due to not considering the views.

And yes, having to consider views is new and a direct consequence of
this new optional feature. But I don't see how its a problem.


> Scheduling hackbench is an extreme case tho and in practice at least
> we're not seeing noticeable issues with a few levels of nesting when
> the workload actually spends cpu cycles doing things other than
> scheduling.

Right; most workloads don't schedule _that_ much; and the overhead isn't
too painful.

> However, we're seeing significant increase in scheduling
> latency coming from how cgroups are handled from the rebalance path.
> I'm still looking into it and will write about that in a separate
> thread.

I have some vague memories of this being a pain point. IIRC it comes
down to the problem that latency is an absolute measure and the weight
is relative thing.

I think we mucked about with it some many years ago; but haven't done so
recently.

> > Also, there is the one giant wart in v2 wrt no-internal-processes;
> > namely the root group is allowed to have them.
> > 
> > Now I understand why this is so; so don't feel compelled to explain that
> > again, but it does make the model very ugly and has a real problem, see
> > below. OTOH, since it is there, I would very much like to make use of
> > this 'feature' and allow a thread-group on the root group.
> > 
> > And since you then _can_ have nested thread groups, it again becomes
> > very important to be able to find the resource domains, which brings me
> > back to my proposal; albeit with an addition constraint.
> 
> I've thought quite a bit about ways to allow thread granularity from
> the top while still presenting a consistent picture to resource domain
> controllers.  That's what's missing from the CPU controller side given
> Mike's claim that there's unavoidable overhead in nesting CPU
> controller and requiring at least one level of nesting on cgroup v2
> for thread granularity might not be acceptable.
> 
> Going back to why thread support on cgroup v2 was needed in the first
> place, it was to allow thread level control while cooperating with
> other controllers on v2.  IOW, allowing thread level control for CPU
> while cooperating with resource domain type controllers.

Well, not only CPU, I can see the same being used for perf for example.

> Now, going back to allowing thread hierarchies from the root, given
> that their resource domain can only be root, which is exactly what you
> get when CPU is mounted on a separate hierarchy, it seems kinda moot.

Not quite; see below on the container thing.

> The practical constraint with the current scheme is that in cases
> where other resource domain controllers need to be used, the thread
> hierarchies would have to be nested at least one level, but if you
> don't want any resource domain things, that's the same as mounting the
> controller separately.
> 
> > Now on to the problem of the no-internal-processes wart; how does
> > cgroup-v2 currently implement the whole container invariant? Because by
> > that invariant, a container's 'root' group must also allow
> > internal-processes.
> 
> I'm not sure I follow the question here.  What's the "whole container
> invariant"?

The container invariant is that everything inside a container looks and
works *exactly* like a 'real' system.

Containers do this with namespace; so the PID namespace 'hides' all
processes not part of its namespace and has an independent PID number;
such that we can start at 1 again for our init; with that it also has a
new child reaper etc..

Similarly, the cgroup namespace should hide everything outside its
subtree; but it should also provide a full new root cgroup, which
_should_ include the no-internal-processes exception.

Another constraint is the whole controller mounting nonsense; unless you
would allow containers to (re)mount cgroups controllers differently, an
unlikely case I feel; containers are constrained to whatever mount
options the host kernel got dealt.

This effectively means that controller mount options are not a viable
configuration mechanism.

This is really important for things like Docker and related. They must
assume some standard setup of cgroups or otherwise cannot use it at all.

But even aside of that; the mount thing is a fairly static an inflexible
configuration. What if you have two workloads that require a different
setup on the same machine?

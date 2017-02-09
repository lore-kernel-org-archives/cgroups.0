From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Thu, 9 Feb 2017 11:29:09 +0100
Message-ID: <20170209102909.GC6515@twins.programming.kicks-ass.net>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208230819.GD25826-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Feb 08, 2017 at 06:08:19PM -0500, Tejun Heo wrote:
> (cc'ing Linus and Andrew for visibility)
> 
> Hello, Peter.
> 
> On Mon, Feb 06, 2017 at 01:49:43PM +0100, Peter Zijlstra wrote:
> > But to me the resource domain is your primary new construct; so it makes
> > more sense to explicitly mark that.
> 
> Whether it's new or not isn't the point.  Resource domains weren't
> added arbitrarily.  We were missing critical resource accounting and
> control capabilities because cgroup v1's abstraction wasn't strong
> enough to cover some of the major resource consumers and how different
> resources can interact with each other.
> 
> Resource domains were added to address that.  Given that cgroup's
> primary goal is providing resource accounting and control, it doesn't
> make sense to make this optional.

I'm not sure what you're saying here. Are you agreeing that 'resource
domains' are the primary new construct or not?

> > My question was, if you have root.threads=1, can you then still create
> > (sub) resource domains? Can I create a child cgroup and clear "threads"
> > again?
> >
> > (I'm assuming "threads" is inherited when creating new groups).
> > 
> > Now, _if_ we can do the above, then "threads" is not sufficient to
> > uniquely identify resource domains, which I think was your point in the
> > other email. Which argues against the interface. Because a group can be
> > a resource domain _and_ have threads sub-trees.
> >
> > OTOH, if you can _not_ do this, then this proposal is
> > insufficient/inadequate.
> 
> No, you can't flip it back and I'm not convinced this matters.  More
> on this below.

Then I shall preliminary NAK your proposal right here, but I shall
continue to read on.

> > So, just to recap, my proposal is as follows:
> > 
> >  1) each cgroup will have a new flag, indicating if this is a resource
> >     domain.
> > 
> >     a) this flag will be inherited; when creating a new cgroup, the
> >        state of the flag will be set to the value of the parent cgroup.
> > 
> >     b) the root cgroup is a resource domain per definition, will
> >        have it set (cannot be cleared).
> > 
> >  2) all tasks of a process shall be part of the same resource domain
> > 
> >  3) controllers come in two types:
> > 
> >     a) task based controllers; these use the direct cgroup the task
> >        is assigned to.
> > 
> >     b) resource controllers; these use the effective resource group
> >        of the task, which is the first parent group with our new
> >        flag set.
> > 
> > 
> > With an optional:
> > 
> >  1c) this flag can only be changed on empty groups
> > 
> > to ease implementation.
> > 
> > From these rules it follows that:
> > 
> > - 1a and 1b together ensure no change in behaviour per default
> >   for cgroup-v2.
> > 
> > - 2 and 3a together ensure resource groups automagically work for task
> >   based controllers (under the assumption that the controller is
> >   strictly hierarchical).
> > 
> > For example, cpuacct does the accounting strictly hierarchical, it adds
> > the cpu usage to each parent group. Therefore the total cpu usage
> > accounted to the resource group is the same as if all tasks were part of
> > that group.
> 
> So, what you're proposing isn't that different from what the posted
> patches implement except that what's implemented doesn't allow
> flipping a part of a threaded subtree back to domain mode.
> 
> Your proposal is more complicated while seemingly not adding much to
> what can be achieved.  The orignal proposal is very simple.  It allows
> declaring a subtree to be threaded (or task based) and that's it.  A
> threaded subtree can't have resource domains under it.
> 
> The only addition that your proposal has is the ability to mark
> portions of such subtree to be domains again.  This would require
> making domain controllers and thread controllers to see different
> hierarchies,

Uhm, no. They would see the exact same hierarchy, seeing how there is
only one tree. They would have different view of it maybe, but I don't
see how that matters, nor do you explain.

> which brings in something completely new to the basic hierarchy.

I'm failing to see what.

> Different controllers seeing differing levels of the same hierarchy is
> part of the basic behaviors

I have no idea what you mean there.

> and making subtrees threaded is a
> straight-forward extension of that - threaded controllers just see
> further into the hierarchy.  Adding threaded sub-sections in the
> middle is more complex and frankly confusing.

I disagree, as I completely fail to see any confusion. The rules are
simple and straight forward.

I also don't see why you would want to impose this artificial
restriction. It doesn't get you anything. Why are you so keen on designs
with these artificial limits on?

> Let's say we can make that work but what are the use cases which would
> require such setup where we have to alternate between thread and
> domain modes through out the resource hierarchy?

I would very much like to run my main workload in the root resource
group. This means I need to have threaded subtrees at the root level.

Your design would then mean I then cannot run a VM (which uses all these
cgroups muck and needs its own resource domain) for some less
critical/isolated workload.

Now, you'll argue I should set up a subtree for the main workload; but
why would I do that? Why would you force me into making this choice;
which has performance penalties associated (because the root resource
domain is special cased in a bunch of places; and because the shallower
the cgroup tree the less overhead etc.).

> This will be a
> considerable departure and added complexity from the existing
> behaviors and code.  We gotta be achieving something significant if
> we're doing that.  Why would we want this?

How is this a departure? I do not understand.

Why would we not want to do this? Why would we want to impose artificial
limitations. What specifically is hard about what I propose?

You have no actual arguments on why what I propose would be hard to
implement. As far as I can tell it should be fairly similar in
complexity to what you already proposed.

> And here's another aspect.  The currently proposed interface doesn't
> preclude adding the behavior you're describing in the future.  Once
> thread mode is enabled on a subtree, it isn't allowed to be disabled
> in its proper subtree; however, if there actually are use cases which
> require flipping it back, we can later implemnt the behavior and lift
> that restriction.  I think it makes sense to start with a simple
> model.

Your choice of flag makes it impossible to tell what is a resource
domain and what is not in that situation.

Suppose I set the root group threaded and I create subgroups (which will
also all have threaded set). Suppose I clear the threaded bit somewhere
in the subtree to create a new resource group, but then immediately set
the threaded bit again to allow that resource group to have thread
subgroups as well. Now the entire hierarchy will have the threaded flag
set and it becomes impossible to find the resource domains.

This is all a direct consequence of your flag not denoting the primary
construct; eg. resource domains.

IOW; you've completely failed to convince me and my NAK stands.

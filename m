From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 25 Aug 2015 17:02:34 -0400
Message-ID: <20150825210234.GE26785@mtj.duckdns.org>
References: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pRq3zRLY7pY2t8MzMvX2bivN3yQM1dE0ahG7+kOupzU=;
        b=KN5rjLqVg2EWRB/QCZd3vA/vo50mxQIV2V/4Y/7Ib/rJY+XbzSQf5ZwfJRSZJZh19Z
         KQJRN40nDXPmKSETPXWgskkMzHiJ0M3mrhvbTwre19v+rDQW2LkzP0uuAsjWN5a5AeUs
         Y9a+cphz3I5PpNlKKNzkTA2a2NcygQiy1G0Vrafn8d5ORnYOdPgw0bWlrW7IYpeWLW+8
         C1AEMUR4PyoZo7D2kr0ytX5vY9AMpT4tnTkE5mPLoxyaefnprlxhn0hMHj/6eBfBwqmk
         CLpBK+n5FWLTGua+qmiyY+sli1/HPg56AzvjMNGNmjRWGvRZVVVGJFm2k0o6v1CWvWEr
         H5sg==
Content-Disposition: inline
In-Reply-To: <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Mon, Aug 24, 2015 at 04:06:39PM -0700, Paul Turner wrote:
> > This is an erratic behavior on cpuset's part tho.  Nothing else
> > behaves this way and it's borderline buggy.
> 
> It's actually the only sane possible interaction here.
> 
> If you don't overwrite the masks you can no longer manage cpusets with
> a multi-threaded application.
> If you partially overwrite the masks you can create a host of
> inconsistent behaviors where an application suddenly loses
> parallelism.

It's a layering problem.  It'd be fine if cpuset either did "layer
per-thread affinities below w/ config change notification" or "ignore
and/or reject per-thread affinities".  What we have now is two layers
manipulating the same field without any mechanism for coordination.

> The *only* consistent way is to clobber all masks uniformly.  Then
> either arrange for some notification to the application to re-sync, or
> use sub-sub-containers within the cpuset hierarchy to advertise
> finer-partitions.

I don't get it.  How is that the only consistent way?  Why is making
irreversible changes even a good way?  Just layer the masks and
trigger notification on changes.

> I don't think the case of having a large compute farm with
> "unimportant" and "important" work is particularly fringe.  Reducing
> the impact on the "important" work so that we can scavenge more cycles
> for the latency insensitive "unimportant" is very real.

What if optimizing cache allocation across competing threads of a
process can yield, say, 3% gain across large compute farm?  Is that
fringe?

> Right, but it's exactly because of _how bad_ those other mechanisms
> _are_ that cgroups was originally created.    Its growth was not
> managed well from there, but let's not step away from the fact that
> this interface was created to solve this problem.

Sure, at the same time, please don't forget that there are ample
reasons we can't replace more basic mechanisms with cgroups.  I'm not
saying this can't be part of cgroup but rather that it's misguided to
do plunge into cgroups as the first and only step.

More importantly, I am extremely doubtful that we understand the usage
scenarios and their benefits very well at this point and want to avoid
over-committing to something we'll look back and regret.  As it
currently stands, this has a high likelihood of becoming a mismanaged
growth.

For the cache allocation thing, I'd strongly suggest something way
simpler and non-commmittal - e.g. create a char device node with
simple configuration and basic access control.  If this *really* turns
out to be useful and its configuration complex enough to warrant
cgroup integration, let's do it then, and if we actually end up there,
I bet the interface that we'd come up with at that point would be
different from what people are proposing now.

> > Yeah, I understand the similarity part but don't buy that the benefit
> > there is big enough to introduce a kernel API which is expected to be
> > used by individual programs which is radically different from how
> > processes / threads are organized and applications interact with the
> > kernel.
> 
> Sorry, I don't quite follow, in what way is it radically different?
> What is magically different about a process versus a thread in this
> sub-division?

I meant that cgroupfs as opposed to most other programming interfaces
that we publish to applications.  We already have process / thread
hierarchy which is created through forking/cloning and conventions
built around them for interaction.  No sane application programming
interface requires individual applications to open a file somewhere,
echo some values to it and use directory operations to manage its
organization.  Will get back to this later.

> > All controllers only get what their ancestors can hand down to them.
> > That's basic hierarchical behavior.
> 
> And many users want non work-conserving systems in which we can add
> and remove idle resources.  This means that how much bandwidth an
> ancestor has is not fixed in stone.

I'm having a hard time following you on this part of the discussion.
Can you give me an example?

> > If that's the case and we fail miserably at creating a reasonable
> > programming interface for that, we can always revive thread
> > granularity.  This is mostly a policy decision after all.
> 
> These interfaces should be presented side-by-side.  This is not a
> reasonable patch-later part of the interface as we depend on it today.

Revival of thread affinity is trivial and will stay that way for a
long time and the transition is already gradual, so it'll be a lost
opportunity but there is quite a bit of maneuvering room.  Anyways, on
with the sub-process interface.

Skipping description of the problems with the current setup here as
I've repated it a couple times in this thread already.

On the other sub-thread, I said that process/thread tree and cgroup
association are inherently tied.  This is because a new child task is
always born into the parent's cgroup and the only reason cgroup works
on system management use cases is because system management often
controls enough of how processes are created.

The flexible migration that cgroup supports may suggest that an
external agent with enough information can define and manage
sub-process hierarchy without involving the target application but
this doesn't necessarily work because such information is often only
available in the application itself and the internal thread hierarchy
should be agreeable to the hierarchy that's being imposed upon it -
when threads are dynamically created, different parts of the hierarchy
should be created by different parent thread.

Also, the problem with external and in-application manipulations
stepping on each other's toes is mostly not caused by individual
config settings but by the possibility that they may try to set up
different hierarchies or modify the existing one in a way which is not
expected by the other.

Given that thread hierarchy already needs to be compatible with
resource hierarchy, is something unix programs already understands and
thus can render itself to an a lot more conventional interface which
doesn't cause organizational conflicts, I think it's logical to use
that for sub-process resource distribution.

So, it comes down to sth like the following

	set_resource($TID, $FLAGS, $KEY, $VAL)

- If $TID isn't already a resource group leader, it creates a
  sub-cgroup, sets $KEY to $VAL and moves $PID and all its descendants
  to it.

- If $TID is already a resource group leader, set $KEY to $VAL.

- If the process is moved to another cgroup, the sub-hierarchy is
  preserved.

The reality is a bit more complex and cgroup core would need to handle
implicit leaf cgroups and duplicating sub-hierarchy.  The biggest
complexity would be extending atomic multi-thread migrations to
accomodate multiple targets but it already does atomic multi-task
migrations and performing the migrations back-to-back should work.
Controller side changes wouldn't be much.  Copying configs to clone
sub-hierarchy and specifying which are availble should be about it.

This should give applications a simple and straight-forward interface
to program against while avoiding all the issues with exposing
cgroupfs directly to individual applications.

> > So, the proposed patches already merge cpu and cpuacct, at least in
> > appearance.  Given the kitchen-sink nature of cpuset, I don't think it
> > makes sense to fuse it with cpu.
> 
> Arguments in favor of this:
>  a) Today the load-balancer has _no_ understanding of group level
> cpu-affinity masks.
>  b) With SCHED_NUMA, we can benefit from also being able to apply (b)
> to understand which nodes are usable.

Controllers can cooperate with each other on the unified hierarchy -
cpu can just query the matching cpuset css about the relevant
attributes and the results will always be properly hierarchical for
cpu too.  There's no reason to merge the two controllers for that.

Thanks.

-- 
tejun

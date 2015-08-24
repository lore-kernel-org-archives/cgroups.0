From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 16:06:39 -0700
Message-ID: <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
References: <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org> <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=DBq1kwnOD7zk57Mf3eObk1NNUQn14ZIuEzLkE+SPlXY=;
        b=VhIwEPpWZ7YnyvXktXUoN8LIi01inN87JLN80MuyketJ5RJ1xwELrF4BxsQupYSSQu
         LWntWGrg4IXiAqnPHZVBBuJqbGavBR6EPh/Q7IrsxvMJK59v1KAEUk+W4cSPYriiBm9B
         4cYwo9I+EMUQfT5PcukTg328N13aJuBldo2OPjS0novY2lWVMiSnomPdudaZNqeZpRnY
         prAdBSMX+yOs7CrS9CcJw0KSUmn9xzr0UBimZFWop73iSTmAN55Wn/Wj4jBpWbtTSdXy
         L803nnQtY7KDhU1j4sc0s8a8Pv225mFJOkaf4W6JGTfK6qSgOpyV1BVwYL2Gshq6FlRW
         K8gA==
In-Reply-To: <20150824221935.GN28944-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Aug 24, 2015 at 3:19 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hey,
>
> On Mon, Aug 24, 2015 at 02:58:23PM -0700, Paul Turner wrote:
>> > Why isn't it?  Because the programs themselves might try to override
>> > it?
>>
>> The major reasons are:
>>
>> 1) Isolation.  Doing everything with sched_setaffinity means that
>> programs can use arbitrary resources if they desire.
>>   1a) These restrictions need to also apply to threads created by
>> library code.  Which may be 3rd party.
>> 2) Interaction between cpusets and sched_setaffinity.  For necessary
>> reasons, a cpuset update always overwrites all extant
>> sched_setaffinity values. ...And we need some cpusets for (1)....And
>> we need periodic updates for access to shared cores.
>
> This is an erratic behavior on cpuset's part tho.  Nothing else
> behaves this way and it's borderline buggy.
>

It's actually the only sane possible interaction here.

If you don't overwrite the masks you can no longer manage cpusets with
a multi-threaded application.
If you partially overwrite the masks you can create a host of
inconsistent behaviors where an application suddenly loses
parallelism.

The *only* consistent way is to clobber all masks uniformly.  Then
either arrange for some notification to the application to re-sync, or
use sub-sub-containers within the cpuset hierarchy to advertise
finer-partitions.

(Generally speaking, there is no real way to mate these APIs and part
of the reason we use sub-containers here.  What's being proposed will
make this worse rather than better.)

>> 3) Virtualization of CPU ids.  (Multiple applications all binding to
>> core 1 is a bad thing.)
>
> This is about who's setting the affinity, right?  As long as an agent
> which knows system details sets it, which mechanism doesn't really
> matter.

Yes, there are other ways to implement this.

>
>> >> Let me try to restate:
>> >>   I think that we can specify the usage is specifically niche that it
>> >> will *typically* be used by higher level management daemons which
>> >
>> > I really don't think that's the case.
>> >
>>
>> Can you provide examples of non-exceptional usage in this fashion?
>
> I heard of two use cases.  One is sytem-partitioning that you're
> talking about and the other is preventing threads of the same process
> from stepping on each other's toes.  There was a fancy word for the
> cacheline cannibalizing behavior which shows up in those scenarios.

So this is a single example right, since the system partitioning case
is the one in which it's exclusively used by a higher level management
daemon.

The case of an process with specifically identified threads in
conflict certainly seems exceptional in the level of optimization both
in implementation and analysis present.  I would expect in this case
that either they are comfortable with the more technical API, or they
can coordinate with an external controller.  Which is much less
overloaded both by number of callers and by number of interfaces than
it is in the cpuset case.

>
>> > It's more like there are two niche sets of use cases.  If a
>> > programmable interface or cgroups has to be picked as an exclusive
>> > alternative, it's pretty clear that programmable interface is the way
>> > to go.
>>
>> I strongly disagree here:
>>   The *major obvious use* is partitioning of a system, which must act
>
> I don't know.  Why is that more major obvious use?  This is super
> duper fringe to begin with.  It's like tallying up beans.  Sure, some
> may be taller than others but they're all still beans and I'm not even
> sure there's a big difference between the two use cases here.

I don't think the case of having a large compute farm with
"unimportant" and "important" work is particularly fringe.  Reducing
the impact on the "important" work so that we can scavenge more cycles
for the latency insensitive "unimportant" is very real.

>
>> on groups of processes.  Cgroups is the only interface we have which
>> satisfies this today.
>
> Well, not really.  cgroups is more convenient / better at these things
> but not the only way to do it.  People have been doing isolation to
> varying degrees with other mechanisms for ages.
>

Right, but it's exactly because of _how bad_ those other mechanisms
_are_ that cgroups was originally created.    Its growth was not
managed well from there, but let's not step away from the fact that
this interface was created to solve this problem.

>> > Ditto.  Wouldn't it be better to implement something which resemables
>> > conventional programming interface rather than contorting the
>> > filesystem semantics?
>>
>> Maybe?  This is a trade-off, some of which is built on the assumptions
>> we're now debating.
>>
>> There is also value, cost-wise, in iterative improvement of what we
>> have today rather than trying to nuke it from orbit.  I do not know
>> which of these is the right choice, it likely depends strongly on
>> where we end up for sub-process interfaces.  If we do support those
>> I'm not sure it makes sense for them to have an entirely different API
>> from process-level coordination, at which point the file-system
>> overload is a trade-off rather than a cost.
>
> Yeah, I understand the similarity part but don't buy that the benefit
> there is big enough to introduce a kernel API which is expected to be
> used by individual programs which is radically different from how
> processes / threads are organized and applications interact with the
> kernel.

Sorry, I don't quite follow, in what way is it radically different?
What is magically different about a process versus a thread in this
sub-division?

> These are a lot more grave issues and if we end up paying
> some complexity from kernel side internally, so be it.
>
>> > So, except for cpuset, this doesn't matter for controllers.  All
>> > limits are hierarchical and that's it.
>>
>> Well no, it still matters because I might want to lower the limit
>> below what children have set.
>
> All controllers only get what their ancestors can hand down to them.
> That's basic hierarchical behavior.
>

And many users want non work-conserving systems in which we can add
and remove idle resources.  This means that how much bandwidth an
ancestor has is not fixed in stone.

>> > For cpuset, it's tricky
>> > because a nested cgroup might end up with no intersecting execution
>> > resource.  The kernel can't have threads which don't have any
>> > execution resources and the solution has been assuming the resources
>> > from higher-ups till there's some.  Application control has always
>> > behaved the same way.  If the configured affinity becomes empty, the
>> > scheduler ignored it.
>>
>> Actually no, any configuration change that would result in this state
>> is rejected.
>>
>> It's not possible to configure an empty cpuset once tasks are in it,
>> or attach tasks to an empty set.
>> It's also not possible to create this state using setaffinity, these
>> restrictions are always over-ridden by updates, even if they do not
>> need to be.
>
> So, even in traditional hierarchies, this isn't true.  You can get to
> no-resource config through cpu hot-unplug and cpuset currently ejects
> tasks to the closest ancestor with execution resources.

This is exactly congruent with what I said.  It's not possible to have
tasks attached to an empty cpuset.  Ejection is only maintaining this
in the face of a non-failable operation.

>
>> > Because the details on this particular issue can be hashed out in the
>> > future?  There's nothing permanently blocking any direction that we
>> > might choose in the future and what's working today will keep working.
>> > Why block the whole thing which can be useful for the majority of use
>> > cases for this particular corner case?
>>
>> Because I do not think sub-process hierarchies are the corner case
>> that you're making them out to be for these controllers and that has
>> real implications for the ultimate direction of this interface.
>
> If that's the case and we fail miserably at creating a reasonable
> programming interface for that, we can always revive thread
> granularity.  This is mostly a policy decision after all.

These interfaces should be presented side-by-side.  This is not a
reasonable patch-later part of the interface as we depend on it today.

>
>> Also.  If we are making disruptive changes here, I would want to
>> discuss merging cpu, cpuset, and cpuacct.  What this merge looks like
>> depends on the above.
>
> So, the proposed patches already merge cpu and cpuacct, at least in
> appearance.  Given the kitchen-sink nature of cpuset, I don't think it
> makes sense to fuse it with cpu.

Arguments in favor of this:
 a) Today the load-balancer has _no_ understanding of group level
cpu-affinity masks.
 b) With SCHED_NUMA, we can benefit from also being able to apply (b)
to understand which nodes are usable.

>
> Thanks.
>
> --
> tejun

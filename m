From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Fri, 18 Sep 2015 04:27:07 -0700
Message-ID: <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
References: <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org> <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org> <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org> <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=gO4/9tYzqQIidcDQbidELI+M200/63gojz0X5UJOje4=;
        b=B1Az+P53pqMhAkbZFDHXTKWw+a9V7Uex/dDmw2EUQqLiCTg3jAwbLrGKpcesc2BkvH
         FM11KKXZ1RvE95LQdvT0/c67Qomen8NArGMP2xcJA1utILYP3RPRmW/E6K5eOp+OiveY
         xBXFUcpEV6HjP/0vl2LPmYw/AN+ABmyE7lNDI4HO5zBZ/KMXcbkftc37ovRPKZx8y0In
         8eamHIRnnYShtRYxOLagOPi/qvpDG3DL5OO1zoC1btAjg3uY61rYNrlHnQpZ3P8yw4E4
         mwWP4i4HxY27QlkT/DO3yl4HV++nGoSrhV/HCmCSBmsYcp3OULPrkwd3Jm6NAL8trakL
         4U+g==
In-Reply-To: <20150912144007.GA8942-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Sep 12, 2015 at 7:40 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Sep 09, 2015 at 05:49:31AM -0700, Paul Turner wrote:
>> I do not think this is a layering problem.  This is more like C++:
>> there is no sane way to concurrently use all the features available,
>> however, reasonably self-consistent subsets may be chosen.
>
> That's just admitting failure.
>

Alternatively: accepting there are varied use-cases to
support.

>> > I don't get it.  How is that the only consistent way?  Why is making
>> > irreversible changes even a good way?  Just layer the masks and
>> > trigger notification on changes.
>>
>> I'm not sure if you're agreeing or disagreeing here.  Are you saying
>> there's another consistent way from "clobbering then triggering
>> notification changes" since it seems like that's what is rejected and
>> then described.  This certainly does not include any provisions for
>> reversibility (which I think is a non-starter).
>>
>> With respect to layering:  Are you proposing we maintain a separate
>> mask for sched_setaffinity and cpusets, then do different things
>> depending on their intersection, or lack thereof?  I feel this would
>> introduce more consistencies than it would solve as these masks would
>> not be separately inspectable from user-space, leading to confusing
>> interactions as they are changed.
>
> So, one of the problems is that the kernel can't have tasks w/o
> runnable CPUs, so we have to some workaround when, for whatever
> reason, a task ends up with no CPU that it can run on.  The other is
> that we never established a consistent way to deal with it in global
> case either.
>
> You say cpuset isn't a layering thing but that simply isn't true.
> It's a cgroup-scope CPU mask.  It layers atop task affinities
> restricting what they can be configured to, limiting the effective
> cpumask to the intersection of actually existing CPUs and overriding
> individual affinity setting when the intersection doesn't exist.
>
> The kernel does not update all CPU affinity masks when a CPU goes down
> or comes up.  It just enforces the intersection and when the
> intersection becomes empty, ignores it.  cgroup-scoped behaviors
> should reflect what the system does in the global case in general, and
> the global behavior here, although missing some bits, is a lot saner
> than what cpuset is currently doing.

You are conflating two things here:
1) How we maintain these masks
2) The interactions on updates

I absolutely agree with you that we want to maintain (1) in a
non-pointwise format.  I've already talked about that in other replies
on this thread.

However for (2) I feel you are:
 i) Underestimating the complexity of synchronizing updates with user-space.
 ii) Introducing more non-desirable behaviors [partial overwrite] than
those you object to [total overwrite].

>
>> There are also very real challenges with how any notification is
>> implemented, independent of delivery:
>> The 'main' of an application often does not have good control or even
>> understanding over its own threads since many may be library managed.
>> Designation of responsibility for updating these masks is difficult.
>> That said, I think a notification would still be a useful improvement
>> here and that some applications would benefit.
>
> And this is the missing piece in the global case too.  We've just
> never solved this problem properly but that does not mean we should go
> off and do something completely different for cgroup case.  Clobbering
> is fine if there's a single entity controlling everything but at that
> level it's nothing more than a shorthand for running taskset on member
> tasks.
>

From user-space's perspective it always involves some out-of-band
clobber since what's specified by cpusets takes precedence.

However the result of overlaying the masks is that different update
combinations will have very different effects, varying from greatly
expanding parallelism to greatly restricting it.  Further, these
effects are hard to predict since anything returned by getaffinity is
obscured by whatever the instantaneous cpuset-level masks happen to be.

>> At the very least, I do not think that cpuset's behavior here can be
>> dismissed as unreasonable.
>
> It sure is very misguided.
>

It's the most consistent choice; you've not given any reasons above
why a solution with only partial consistency is any better.

Any choice here is difficult to coordinate, that two APIs allow
manipulation of the same property means that we must always
choose some compromise here.  I prefer the one with the least
surprises.

>> > What if optimizing cache allocation across competing threads of a
>> > process can yield, say, 3% gain across large compute farm?  Is that
>> > fringe?
>>
>> Frankly, yes.  If you have a compute farm sufficiently dedicated to a
>> single application I'd say that's a fairly specialized use.  I see no
>> reason why a more 'technical' API should be a challenge for such a
>> user.  The fundamental point here was that it's ok for the API of some
>> controllers to be targeted at system rather than user control in terms
>> of interface.  This does not restrict their use by users where
>> appropriate.
>
> We can go back and forth forever on this but I'm fairly sure
> everything CAT related is niche at this point.

I agree it makes sense to restrict to the partitioning operations
desired and not the resource being controlled.  Be it CAT or other.

>
>> So there is definitely a proliferation of discussion regarding
>> applying cgroups to other problems which I agree we need to take a
>> step back and re-examine.
>>
>> However, here we're fundamentally talking about APIs designed to
>> partition resources which is the problem that cgroups was introduced
>> to address.  If we want to introduce another API to do that below the
>> process level we need to talk about why it's fundamentally different
>> for processes versus threads, and whether we want two APIs that
>> interface with the same underlying kernel mechanics.
>
> More on this below but going full-on cgroup controller w/ thread-level
> interface is akin to introducing syscalls for this.  That really is
> what it is.
>
>> > For the cache allocation thing, I'd strongly suggest something way
>> > simpler and non-commmittal - e.g. create a char device node with
>> > simple configuration and basic access control.  If this *really* turns
>> > out to be useful and its configuration complex enough to warrant
>> > cgroup integration, let's do it then, and if we actually end up there,
>> > I bet the interface that we'd come up with at that point would be
>> > different from what people are proposing now.
>>
>> As above, I really want to focus on (1) so I will be brief here:
>>
>> Making it a char device requires yet-another adhoc method of
>> describing process groupings that a configuration should apply to and
>> yet-another set of rules for its inheritance.  Once we merge it, we're
>
> Actually, we *always* had a method of describing process groupings
> called process hierarchy.  cgroup provides dyanmic classfication atop,
> but not completely as the hierarchy still dictates where new processes
> end up.
>

As before, the process hierarchy is essentially static and only really
used for resource parenting, not resource partitioning.

I think you are somewhat trivializing the dynamic aspect here.  As
soon as the hierarchy is non-static then you have to reinvent some
mechanism of describing and interacting with that hierarchy.  This does
not apply to the process hierarchy.

I do not yet see a good reason why the threads arbitrarily not sharing an
address space necessitates the use of an entirely different API.  The
only problems stated so far in this discussion have been:
  1) Actual issues involving relative paths, which are potentially solvable.
  2) Aesthetic distaste for using file-system abstractions

>> committed to backwards support of the interface either way, I do not
>> see what reimplementing things as a char device or sysfs or seqfile or
>> other buys us over it being cgroupfs in this instance.
>>
>> I think that the real problem here is that stuff gets merged that does
>> not follow the rules of how something implemented with cgroups must
>> behave (typically respect with to a hierarchy); which is obviously
>> increasingly incompatible with a model where we have a single
>> hierarchy.  But, provided that we can actually define those rules;  I
>> do not see the gain in denying the admission of new controller which
>> is wholly consistent with them.  It does not really measurably add to
>> the complexity of the implementation (and it greatly reduces it where
>> grouping semantics are desired).
>
> CAT is really a bad example.  I'd say no as a cgroup controller or as
> a new set of syscalls.  It simply isn't developed enough yet and we
> don't want to commit that much.  System resource partitioning which
> can't easily be achieved in different ways can surely be a part of
> cgroup but we don't wanna do that willy nilly.  We actually wanna
> deliberate on what the actual resources and their abstractions are
> which we have tradtionally been horrible at.

None of that paragraph was actually about CAT.  It's that don't
understand this disjunction that we should arbitrarily partition some
things with cgroups, but actively prefer not to use it for others.

Fundamentally cgroups was originally an API about defining partitions
and attaching control semantics to them, which this statement feels
like a step away from.  I do not understand the claim that we should
try not to use it for problems that want partitioning.

>
>> > I'm having a hard time following you on this part of the discussion.
>> > Can you give me an example?
>>
>> For example, when a system is otherwise idle we might choose to give
>> an application additional memory or cpu resources.  These may be
>> reclaimed in the future, such an update requires updating children to
>> be compatible with a parents' new limits.
>
> There are four types of resource control that cgroup does - weights,
> limits, guarantees, and strict allocations.  Weights are obviously
> work-preserving.  Limiters and strict allocators shouldn't be.
> Guarantees are limiters applied the other direction and
> work-preserving and strict allocations are strict allocations.  I
> still don't quite get what you were trying to say.  What was the point
> here?

You asked for an example where updating a parent's limits required the
modification of a descendant.  This was one.

>
>> > The flexible migration that cgroup supports may suggest that an
>> > external agent with enough information can define and manage
>> > sub-process hierarchy without involving the target application but
>> > this doesn't necessarily work because such information is often only
>> > available in the application itself and the internal thread hierarchy
>> > should be agreeable to the hierarchy that's being imposed upon it -
>> > when threads are dynamically created, different parts of the hierarchy
>> > should be created by different parent thread.
>>
>> I think what's more important here is that you can define it to work.
>> This does require cooperation between the external agent and the
>> application in the layout of the application's hierarchy.  But this is
>> something we do use.  A good example would be the surfacing of public
>> and private cpus previously discussed to the application.
>
> So, if you do that, it's fine, but this is the same as your previous
> c++ argument.  This shouldn't be the standard we design these
> interfaces on.  If it can be clearly layered in a consistent way, we
> should do that and that doesn't prevent internal and external entities
> cooperating.

Sorry, I don't understand this statement.  It's a requirement, not a
standard.   All that's being said is that this is a real thing that
the API presently supports.  The alternatives you are proposing do not
cleanly support this.  I make the C++ argument exactly because this is
something not all users are likely to require.

>
>> > Also, the problem with external and in-application manipulations
>> > stepping on each other's toes is mostly not caused by individual
>> > config settings but by the possibility that they may try to set up
>> > different hierarchies or modify the existing one in a way which is not
>> > expected by the other.
>>
>> How is this different from say signals or ptrace or any file-system
>> modification?  This does not seem a problem inherent to cgroups.
>
> ptrace is obviously a special case but we don't let external agents
> meddle with signal handlers or change cwd of a process.  In most
> cases, there are distinctions between what's internal to a process and
> what's not.

But, given the right capabilities or user, we do allow them to send
signals, modify the file-system, etc.

There is nothing about using a VFS interface that precludes extending
the same protections.

>
>> > Given that thread hierarchy already needs to be compatible with
>> > resource hierarchy, is something unix programs already understands and
>> > thus can render itself to an a lot more conventional interface which
>> > doesn't cause organizational conflicts, I think it's logical to use
>> > that for sub-process resource distribution.
>> >
>> > So, it comes down to sth like the following
>> >
>> >         set_resource($TID, $FLAGS, $KEY, $VAL)
>> >
>> > - If $TID isn't already a resource group leader, it creates a
>> >   sub-cgroup, sets $KEY to $VAL and moves $PID and all its descendants
>> >   to it.
>> >
>> > - If $TID is already a resource group leader, set $KEY to $VAL.
>> >
>> > - If the process is moved to another cgroup, the sub-hierarchy is
>> >   preserved.
>> >
>>
>> Honestly, I find this API awkward:
>>
>> 1) It depends on "anchor" threads to define groupings.
>
> So does cgroupfs.  Any kind of thread or process grouping can't escape
> that as soon as things start forking and if things don't fork whether
> something is anchor or not doesn't make much difference.

The difference is that this ignores how applications are actually written:

A container that is independent of its members (e.g. a cgroup
directory) can be created and configured by an application's Init() or
within the construction of a data-structure that will use it without
dependency on those resources yet being used.

As an example:
  The resources associated with thread pools are often dynamically
managed.  What you're proposing means that some initialization must
now be moved into the first thread that pool creates (as opposed to
the pool's initilization), that synchronization and identification of
this thread is now required, and that it must be treated differently
to other threads in the pool (it can no longer be reclaimed).

>
>> 2) It does not allow thread-level hierarchies to be created
>
> Huh?  That's the only thing it would do.  This obviously wouldn't get
> applied to processes.  It's strictly about threads.

This allows a single *partition*, not a hierarchy.    As machines
become larger, so are many of the processes we run on them.  These
larger processes manage resources between threads on scales that we
would previously partition between processes.

>
>> 3) When coordination with an external agent is desired this defines no
>> common interface that can be shared.  Directories are an extremely
>> useful container.  Are you proposing applications would need to
>> somehow publish the list of anchor-threads from (1)?
>
> Again, this is an invariant no matter what we do.  As I wrote numerous
> times in this thread, this information is only known to the process
> itself.  If an external agent want to manipulate these from outside,
> it just has to know which thread is doing what.  The difference is
> that this doesn't require the process itself to coordinate with
> external agent when operating on itself.

Nothing about what was previously state would require any coordination
with the process and an external agent when operating on itself.
What's the basis for this claim?

This also ignores the cases previously discussed in which the external
agent is providing state for threads within a process to attach to.
An example of this is repeated below.

This isn't even covering that this requires the invention of entirely
new user-level APIs and coordination for somehow publishing these
magic tids.

>
>> What if I want to set up state that an application will attaches
>> threads to [consider cpuset example above]?
>
> It feels like we're running in circles.  Process-level control stays
> the same.  That part is not an issue.  Thread-level control requires
> cooperation from the process itself no matter what and should stay
> confined to the limits imposed on the process as a whole.
>
> Frankly, cpuset example doesn't make much sense to me because there is
> nothing hierarchical about it and it isn't even layered properly.  Can
> you describe what you're actually trying to achieve?  But no matter
> the specifities of the example, it's almost trivial to achieve
> whatever end results.

This has been previously detailed, repeating it here:

Machines are shared resources, we partition the available cpus into
shared and private sets.  These sets are dynamic as when a new
application arrives requesting private cpus, we must reserve some cpus
that were previously shared.

We use sub-cpusets to advertise to applications which of their cpus
are shared and which are private.  They can then attach threads to
these containers  -- which are dynamically updated as cores shift
between public and private configurations.

>
>> 4) How is the cgroup property to $KEY translation defined?  This feels
>> like an ioctl and no more natural than the file-system.  It also does
>
> How are they even comparable?  Sure ioctl inputs are variable-formed
> and its definitions aren't closely scrutinized but other than those
> it's a programmable system-call interface and how programs use and
> interact with them is completely different from how a program
> interacts with cgroupfs.

They're exactly comparable in that every cgroup.<property> api now
needs some magic equivalent $KEY defined.  I don't understand how
you're proposing these would be generated or managed.

> It doesn't have to parse out the path,
> compose the knob path, open and format the data into it

There's nothing hard about this.  Further, we already have to do
exactly this at the process level; which means abstractions for this
already exist; removing this property does not change their presence
of requirement, but instead means they must be duplicated for the
in-thread case.

Even ignoring that the libraries for this can be shared between thread
and process, this is also generally easier to work with than magic
$KEY values.


> all the while
> not being sure whether the file it's operating on is even the right
> one anymore or the sub-hierarchcy it's assuming is still there.

One possible resolution to this has been proposed several times:
  Have the sub-process hierarchy exposed in an independent and fixed location.

>
>> not seem to resolve your concerns regarding races; the application
>> must still coordinate internally when concurrently calling
>> set_resource().
>
> I have no idea where you're going with this.  When did the internal
> synchronization inside a process become an issue?  Sure, if a thread
> does *(int *)=0, we can't protect other threads from it.  Also, why
> would it be a problem?  If two perform set_resource() on the same
> thread, one will be executed after the other.  What are you talking
> about?

It was my impression that you'd had atomicity concerns regarding
file-system operations such as writes for updates previously.  If you
have no concerns within a sub-processes operation then this can be
discarded.

>
>> 5) How does an external agent coordinate when a resource must be
>> removed from a sub-hierarchy?
>
> That sort of restriction should generally be put at the higher level.
> Thread-level resource control should be cooperative with the
> application if at all necessary and in those cases just set the limit
> on the sub-hierarchy would work.
>

Could you expand on how you envision this being cooperative?  This
seems tricky to me, particularly when limits are involved.

How do I even arbitrate which external agents are allowed control?

> If the process is adversarial, it can mess up whatever external agent
> tries to do inside the process by messing up its thread forking
>
>> On a larger scale, what properties do you feel this separate API
>> provides that would not be also supported by instead exposing
>> sub-process hierarchies via /proc/self or similar.
>>
>> Perhaps it would help to enumerate the the key problems we're trying
>> to solve with the choice of this interface?
>>  1) Thread spanning trees within the cgroup hierarchy.  (Immediately
>> fixed, only processes are present on the cgroup-mount)
>>  2) Interactions with the parent process moving within the hierarchy
>>  3) Potentially supporting move operations within a hierarchy
>>
>> Are there other cruxes?
>
> It's a lot easier for applications to program against and it makes it
> explicit that grouping thrads is the domain of the process itself,

So I was really trying to make sure we covered the interface problems
we're trying to solve here.  Are there major ones not listed there?

However, I strongly disagree with this statement.  It is much easier
for applications to work with named abstract objects then having magic
threads that it must track and treat specially.

My implementation must now look like this:
  1) I instantiate some abstraction which uses cgroups.
  2) In construction I must now coordinate with my chosen threading
implementation (an exciting new dependency) to create a new thread and
get its tid.  This thread must exist for as long as the associated
data-structure.  I must pay a kernel stack, at least one page of
thread stack and however much TLS I've declared in my real threads.
  3) In destruction I must now wake and free the thread created in (2).
  4) If I choose to treat it as a real thread, I must be careful, this
thread is special and cannot be arbitrarily released like other
threads.
  5) To do anything I must go grok the documentation to look up the
magic $KEY.  If I get this wrong I am going to have a fun time
debugging it since things are no longer reasonably inspect-able.  If I
must work with a cgroup that adds features over time things are even
more painful since $KEY may or may not exist.

Is any of the above unfair with respect to what you've described above?
This isn't even beginning to consider the additional pain that a
language implementing its own run-time such as Go might incur.

> which is true no matter what we do, and everybody follows the same
> grouping inside the process thus removing the problems around
> different entities manipulating the sub-hierarchy in incompatible
> ways.

Option B:
  We expose sub-process hierarchies via /proc/self/cgroups or similar.
They do not appear within the process only cgroup hierarchy.
  Only the same user (or a privileged one) has access to this internal
hierarchy.  This can be arbitrarily restricted further.
  Applications continue to use almost exactly the same cgroup
interfaces that exist today, however, the problem of path computation
and non-stable paths are now eliminated.

Really, what problems does this not solve?

It eliminates the unstable mount point, your concerns regarding
external entity manipulation, and allows for the parent processes to
be moved.  It provides a reasonable place for coordination to occur,
with standard mechanisms for access control.  It allows for state to
be easily inspected, it does not require new documentation, allows the
creation of sub-hierarchies, does not require special threads.

This was previously raised as a straw man, but I have not yet seen or
thought of good arguments against it.

Thanks,

- Paul

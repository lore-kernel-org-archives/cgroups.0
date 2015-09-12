From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sat, 12 Sep 2015 10:40:07 -0400
Message-ID: <20150912144007.GA8942@htj.duckdns.org>
References: <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=A9Aau1dVg/X2DGWSOeROzR82/5oWWIAgaSXJFl7uuKk=;
        b=Tbvx17j3Hm3BzuID/ZTsklcfMU211U8uXK981w3hrnWz36Az3lEeO2fcNo7gLzQpSq
         7goMgxiNIotCy/aN9qe5pE4/AN82mlFoIcEHENnO0wcWJTF/5HK2pnEdFv71DexI7RX/
         grLjLd6pSZ6vKfw6dbnlfPK3HQ5CIQPum6S6zO3yBzlfSO3pFulV19HtmqiXdr+ZbIbE
         k2rAT9JDtdlee1I5CR5ILXFVPFQY8Zy+3MAkq/Kv49J4Jky/Z2bv2YJxDd5Wiy/Nm7rm
         QBfexjw0bE0Uvgibg+zC2HEOCHedbtWocl0QYBbxZLG1KrOPfDYbJHNYH2n+JZo5wfGN
         43Lg==
Content-Disposition: inline
In-Reply-To: <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Wed, Sep 09, 2015 at 05:49:31AM -0700, Paul Turner wrote:
> I do not think this is a layering problem.  This is more like C++:
> there is no sane way to concurrently use all the features available,
> however, reasonably self-consistent subsets may be chosen.

That's just admitting failure.

> > I don't get it.  How is that the only consistent way?  Why is making
> > irreversible changes even a good way?  Just layer the masks and
> > trigger notification on changes.
> 
> I'm not sure if you're agreeing or disagreeing here.  Are you saying
> there's another consistent way from "clobbering then triggering
> notification changes" since it seems like that's what is rejected and
> then described.  This certainly does not include any provisions for
> reversibility (which I think is a non-starter).
> 
> With respect to layering:  Are you proposing we maintain a separate
> mask for sched_setaffinity and cpusets, then do different things
> depending on their intersection, or lack thereof?  I feel this would
> introduce more consistencies than it would solve as these masks would
> not be separately inspectable from user-space, leading to confusing
> interactions as they are changed.

So, one of the problems is that the kernel can't have tasks w/o
runnable CPUs, so we have to some workaround when, for whatever
reason, a task ends up with no CPU that it can run on.  The other is
that we never established a consistent way to deal with it in global
case either.

You say cpuset isn't a layering thing but that simply isn't true.
It's a cgroup-scope CPU mask.  It layers atop task affinities
restricting what they can be configured to, limiting the effective
cpumask to the intersection of actually existing CPUs and overriding
individual affinity setting when the intersection doesn't exist.

The kernel does not update all CPU affinity masks when a CPU goes down
or comes up.  It just enforces the intersection and when the
intersection becomes empty, ignores it.  cgroup-scoped behaviors
should reflect what the system does in the global case in general, and
the global behavior here, although missing some bits, is a lot saner
than what cpuset is currently doing.

> There are also very real challenges with how any notification is
> implemented, independent of delivery:
> The 'main' of an application often does not have good control or even
> understanding over its own threads since many may be library managed.
> Designation of responsibility for updating these masks is difficult.
> That said, I think a notification would still be a useful improvement
> here and that some applications would benefit.

And this is the missing piece in the global case too.  We've just
never solved this problem properly but that does not mean we should go
off and do something completely different for cgroup case.  Clobbering
is fine if there's a single entity controlling everything but at that
level it's nothing more than a shorthand for running taskset on member
tasks.

> At the very least, I do not think that cpuset's behavior here can be
> dismissed as unreasonable.

It sure is very misguided.

> > What if optimizing cache allocation across competing threads of a
> > process can yield, say, 3% gain across large compute farm?  Is that
> > fringe?
> 
> Frankly, yes.  If you have a compute farm sufficiently dedicated to a
> single application I'd say that's a fairly specialized use.  I see no
> reason why a more 'technical' API should be a challenge for such a
> user.  The fundamental point here was that it's ok for the API of some
> controllers to be targeted at system rather than user control in terms
> of interface.  This does not restrict their use by users where
> appropriate.

We can go back and forth forever on this but I'm fairly sure
everything CAT related is niche at this point.

> So there is definitely a proliferation of discussion regarding
> applying cgroups to other problems which I agree we need to take a
> step back and re-examine.
> 
> However, here we're fundamentally talking about APIs designed to
> partition resources which is the problem that cgroups was introduced
> to address.  If we want to introduce another API to do that below the
> process level we need to talk about why it's fundamentally different
> for processes versus threads, and whether we want two APIs that
> interface with the same underlying kernel mechanics.

More on this below but going full-on cgroup controller w/ thread-level
interface is akin to introducing syscalls for this.  That really is
what it is.

> > For the cache allocation thing, I'd strongly suggest something way
> > simpler and non-commmittal - e.g. create a char device node with
> > simple configuration and basic access control.  If this *really* turns
> > out to be useful and its configuration complex enough to warrant
> > cgroup integration, let's do it then, and if we actually end up there,
> > I bet the interface that we'd come up with at that point would be
> > different from what people are proposing now.
> 
> As above, I really want to focus on (1) so I will be brief here:
> 
> Making it a char device requires yet-another adhoc method of
> describing process groupings that a configuration should apply to and
> yet-another set of rules for its inheritance.  Once we merge it, we're

Actually, we *always* had a method of describing process groupings
called process hierarchy.  cgroup provides dyanmic classfication atop,
but not completely as the hierarchy still dictates where new processes
end up.

> committed to backwards support of the interface either way, I do not
> see what reimplementing things as a char device or sysfs or seqfile or
> other buys us over it being cgroupfs in this instance.
>
> I think that the real problem here is that stuff gets merged that does
> not follow the rules of how something implemented with cgroups must
> behave (typically respect with to a hierarchy); which is obviously
> increasingly incompatible with a model where we have a single
> hierarchy.  But, provided that we can actually define those rules;  I
> do not see the gain in denying the admission of new controller which
> is wholly consistent with them.  It does not really measurably add to
> the complexity of the implementation (and it greatly reduces it where
> grouping semantics are desired).

CAT is really a bad example.  I'd say no as a cgroup controller or as
a new set of syscalls.  It simply isn't developed enough yet and we
don't want to commit that much.  System resource partitioning which
can't easily be achieved in different ways can surely be a part of
cgroup but we don't wanna do that willy nilly.  We actually wanna
deliberate on what the actual resources and their abstractions are
which we have tradtionally been horrible at.

> > I'm having a hard time following you on this part of the discussion.
> > Can you give me an example?
> 
> For example, when a system is otherwise idle we might choose to give
> an application additional memory or cpu resources.  These may be
> reclaimed in the future, such an update requires updating children to
> be compatible with a parents' new limits.

There are four types of resource control that cgroup does - weights,
limits, guarantees, and strict allocations.  Weights are obviously
work-preserving.  Limiters and strict allocators shouldn't be.
Guarantees are limiters applied the other direction and
work-preserving and strict allocations are strict allocations.  I
still don't quite get what you were trying to say.  What was the point
here?

> > The flexible migration that cgroup supports may suggest that an
> > external agent with enough information can define and manage
> > sub-process hierarchy without involving the target application but
> > this doesn't necessarily work because such information is often only
> > available in the application itself and the internal thread hierarchy
> > should be agreeable to the hierarchy that's being imposed upon it -
> > when threads are dynamically created, different parts of the hierarchy
> > should be created by different parent thread.
> 
> I think what's more important here is that you can define it to work.
> This does require cooperation between the external agent and the
> application in the layout of the application's hierarchy.  But this is
> something we do use.  A good example would be the surfacing of public
> and private cpus previously discussed to the application.

So, if you do that, it's fine, but this is the same as your previous
c++ argument.  This shouldn't be the standard we design these
interfaces on.  If it can be clearly layered in a consistent way, we
should do that and that doesn't prevent internal and external entities
cooperating.

> > Also, the problem with external and in-application manipulations
> > stepping on each other's toes is mostly not caused by individual
> > config settings but by the possibility that they may try to set up
> > different hierarchies or modify the existing one in a way which is not
> > expected by the other.
> 
> How is this different from say signals or ptrace or any file-system
> modification?  This does not seem a problem inherent to cgroups.

ptrace is obviously a special case but we don't let external agents
meddle with signal handlers or change cwd of a process.  In most
cases, there are distinctions between what's internal to a process and
what's not.

> > Given that thread hierarchy already needs to be compatible with
> > resource hierarchy, is something unix programs already understands and
> > thus can render itself to an a lot more conventional interface which
> > doesn't cause organizational conflicts, I think it's logical to use
> > that for sub-process resource distribution.
> >
> > So, it comes down to sth like the following
> >
> >         set_resource($TID, $FLAGS, $KEY, $VAL)
> >
> > - If $TID isn't already a resource group leader, it creates a
> >   sub-cgroup, sets $KEY to $VAL and moves $PID and all its descendants
> >   to it.
> >
> > - If $TID is already a resource group leader, set $KEY to $VAL.
> >
> > - If the process is moved to another cgroup, the sub-hierarchy is
> >   preserved.
> >
> 
> Honestly, I find this API awkward:
> 
> 1) It depends on "anchor" threads to define groupings.

So does cgroupfs.  Any kind of thread or process grouping can't escape
that as soon as things start forking and if things don't fork whether
something is anchor or not doesn't make much difference.

> 2) It does not allow thread-level hierarchies to be created

Huh?  That's the only thing it would do.  This obviously wouldn't get
applied to processes.  It's strictly about threads.

> 3) When coordination with an external agent is desired this defines no
> common interface that can be shared.  Directories are an extremely
> useful container.  Are you proposing applications would need to
> somehow publish the list of anchor-threads from (1)?

Again, this is an invariant no matter what we do.  As I wrote numerous
times in this thread, this information is only known to the process
itself.  If an external agent want to manipulate these from outside,
it just has to know which thread is doing what.  The difference is
that this doesn't require the process itself to coordinate with
external agent when operating on itself.

> What if I want to set up state that an application will attaches
> threads to [consider cpuset example above]?

It feels like we're running in circles.  Process-level control stays
the same.  That part is not an issue.  Thread-level control requires
cooperation from the process itself no matter what and should stay
confined to the limits imposed on the process as a whole.

Frankly, cpuset example doesn't make much sense to me because there is
nothing hierarchical about it and it isn't even layered properly.  Can
you describe what you're actually trying to achieve?  But no matter
the specifities of the example, it's almost trivial to achieve
whatever end results.

> 4) How is the cgroup property to $KEY translation defined?  This feels
> like an ioctl and no more natural than the file-system.  It also does

How are they even comparable?  Sure ioctl inputs are variable-formed
and its definitions aren't closely scrutinized but other than those
it's a programmable system-call interface and how programs use and
interact with them is completely different from how a program
interacts with cgroupfs.  It doesn't have to parse out the path,
compose the knob path, open and format the data into it all the while
not being sure whether the file it's operating on is even the right
one anymore or the sub-hierarchcy it's assuming is still there.

> not seem to resolve your concerns regarding races; the application
> must still coordinate internally when concurrently calling
> set_resource().

I have no idea where you're going with this.  When did the internal
synchronization inside a process become an issue?  Sure, if a thread
does *(int *)=0, we can't protect other threads from it.  Also, why
would it be a problem?  If two perform set_resource() on the same
thread, one will be executed after the other.  What are you talking
about?

> 5) How does an external agent coordinate when a resource must be
> removed from a sub-hierarchy?

That sort of restriction should generally be put at the higher level.
Thread-level resource control should be cooperative with the
application if at all necessary and in those cases just set the limit
on the sub-hierarchy would work.

If the process is adversarial, it can mess up whatever external agent
tries to do inside the process by messing up its thread forking
hierarchy.  It just doesn't matter.

> On a larger scale, what properties do you feel this separate API
> provides that would not be also supported by instead exposing
> sub-process hierarchies via /proc/self or similar.
>
> Perhaps it would help to enumerate the the key problems we're trying
> to solve with the choice of this interface?
>  1) Thread spanning trees within the cgroup hierarchy.  (Immediately
> fixed, only processes are present on the cgroup-mount)
>  2) Interactions with the parent process moving within the hierarchy
>  3) Potentially supporting move operations within a hierarchy
> 
> Are there other cruxes?

It's a lot easier for applications to program against and it makes it
explicit that grouping thrads is the domain of the process itself,
which is true no matter what we do, and everybody follows the same
grouping inside the process thus removing the problems around
different entities manipulating the sub-hierarchy in incompatible
ways.

Thanks.

-- 
tejun

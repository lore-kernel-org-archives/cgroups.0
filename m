From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 1 Oct 2015 14:46:29 -0400
Message-ID: <20151001184629.GB26498@mtj.duckdns.org>
References: <20150822182916.GE20768@mtj.duckdns.org>
 <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yh5uaMDFGV3mEWe3ZFE0e8qfg1e1nmFFNvoN8MT0zyA=;
        b=LeLI0d6hvZLPWqqSiDGfMAjVJ5RRKXFqRwAHQjs2Z/9xHS7POD4UAXUssD210FLcel
         qyjJ8xmdP5iO8BnlCb/TDDC9ssYw22oyJmUEAMF7Kcs02NklqzpZcpzS144Gwr43rlgZ
         7jHeW2k4PUTh85HbpC75xBVcl1fTZ4LT5alPxWLA8JVZmGfugxMn09jhZEJpjZgST3HI
         ur0tntGDINuc5PYxkShMriit+Gqhun5YeK4K+PsOSdhD/+kN8O/hjBps9ibC8bgrjqKi
         XvHjGkIn83QQ7HJkbYIVC1GS+kPYmgI79pzvzxHi4x83qamnr5KpmbW2RGex/CiA3hMg
         Yytg==
Content-Disposition: inline
In-Reply-To: <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Paul.

Sorry about the delay.  Things were kinda hectic in the past couple
weeks.

On Fri, Sep 18, 2015 at 04:27:07AM -0700, Paul Turner wrote:
> On Sat, Sep 12, 2015 at 7:40 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, Sep 09, 2015 at 05:49:31AM -0700, Paul Turner wrote:
> >> I do not think this is a layering problem.  This is more like C++:
> >> there is no sane way to concurrently use all the features available,
> >> however, reasonably self-consistent subsets may be chosen.
> >
> > That's just admitting failure.
> >
> 
> Alternatively: accepting there are varied use-cases to
> support.

Analogies like this can go awry but as we're in it anyway, let's push
it a bit further.  One of the reasons why C++ isn't lauded as an
example of great engineering is while it does support a vast number of
use-cases or rather usage-scenarios (it's not necessarily focused on
utility but just how things are done) it fails to distill the essence
of the actual utility out of them and condense it.  It's not just an
aesthetic argument.  That failure exacts heavy costs on its users and
is one of the reasons why C++ projects are more prone to horrible
disarrays unless specific precautions are taken.

I'm not against supporting valid and useful use-cases but not all
usage-scenarios are equal.  If we can achieve the same eventual goals
with reasonable trade-offs in a simpler and more straight-forward way,
that's what we should do even though that'd require some modifications
to specific usage-scenarios.  ie. the usage-scenarios need to
scrutinized so that the core of the utility can be extracted and
abstracted in the, hopefully, minimal way.

This is what worries me when you liken the situation to C++.  You
probably were trying to make a different point but I'm not sure we're
on the same page and I think we need to agree at least on this in
principle; otherwise, we'll just keep talking past each other.

> > The kernel does not update all CPU affinity masks when a CPU goes down
> > or comes up.  It just enforces the intersection and when the
> > intersection becomes empty, ignores it.  cgroup-scoped behaviors
> > should reflect what the system does in the global case in general, and
> > the global behavior here, although missing some bits, is a lot saner
> > than what cpuset is currently doing.
> 
> You are conflating two things here:
> 1) How we maintain these masks
> 2) The interactions on updates
> 
> I absolutely agree with you that we want to maintain (1) in a
> non-pointwise format.  I've already talked about that in other replies
> on this thread.
> 
> However for (2) I feel you are:
>  i) Underestimating the complexity of synchronizing updates with user-space.
>  ii) Introducing more non-desirable behaviors [partial overwrite] than
> those you object to [total overwrite].

The thing which bothers me the most is that cpuset behavior is
different from global case for no good reason.  We don't have a model
right now.  It's schizophrenic.  And what I was trying to say was that
maybe this is because we never had a working model in the global case
either but if that's the case we need to solve the global case too or
at least figure out where we wanna be in the long term.

> It's the most consistent choice; you've not given any reasons above
> why a solution with only partial consistency is any better.
>
> Any choice here is difficult to coordinate, that two APIs allow
> manipulation of the same property means that we must always
> choose some compromise here.  I prefer the one with the least
> surprises.

I don't think the current situation around affinity mask handling can
be considered consistent and cpuset is pouring more inconsistencies
into it.  We need to figure it out one way or the other.

...
> I do not yet see a good reason why the threads arbitrarily not sharing an
> address space necessitates the use of an entirely different API.  The
> only problems stated so far in this discussion have been:
>   1) Actual issues involving relative paths, which are potentially solvable.

Also the ownership of organization.  If the use-cases can be
reasonably served with static grouping, I think it'd definitely be a
worthwhile trade-off to make.  It's different from process level
grouping.  There, we can simply state that this is to be arbitrated in
the userland and that arbitration isn't that difficult as it's among
administration stack of userspace.

In-process attributes are different.  The process itself can
manipulate its own attributes but it's also common for external tools
to peek into processes and set certain attributes.  Even when the two
parties aren't coordinated, this is usually fine because there's no
reason for applications to depend on what those attribute are set to
and even when the different entities do different things, the
combination is still something coherent.

Now, if you make the in-process grouping dynamic and accessible to
external entities (and if we aren't gonna do that, why even bother?),
this breaks down and we have some of the same problems we have with
allowing applications to directly manipulate cgroup sub-directories.
This is a fundamental problem.  Setting attributes can be shared but
organization is an exclusive process.  You can't share that without
close coordination.

Assigning the full responsiblity of in-process organization to the
application itself and tying it to static parental relationship allows
for solid common grounds where these resource operations can be
performed by different entities without causing structural issues just
like other similar operations.

Another point for assigning this responsibility to the application
itself is that it can't be done without the application's cooperation
anyway because the group membership of new threads is determined by
the group the parent belongs to.

>   2) Aesthetic distaste for using file-system abstractions

It's not that but more about what the file-system interface implies.
It's not just different.  It breaks a lot of expectations a lot of
application visible kernel interface provides as explained above.
There are reasons why we usually don't do things this way.

...
> >> 1) It depends on "anchor" threads to define groupings.
> >
> > So does cgroupfs.  Any kind of thread or process grouping can't escape
> > that as soon as things start forking and if things don't fork whether
> > something is anchor or not doesn't make much difference.
> 
> The difference is that this ignores how applications are actually written:

It does require the applications to follow certain protocols to
organize itself but this is a pretty trivial thing to do and comes
with the benefit that we don't need to introduce a completely new
grouping concept to applications.

> A container that is independent of its members (e.g. a cgroup
> directory) can be created and configured by an application's Init() or
> within the construction of a data-structure that will use it without
> dependency on those resources yet being used.
> 
> As an example:
>   The resources associated with thread pools are often dynamically
> managed.  What you're proposing means that some initialization must
> now be moved into the first thread that pool creates (as opposed to
> the pool's initilization), that synchronization and identification of
> this thread is now required, and that it must be treated differently
> to other threads in the pool (it can no longer be reclaimed).

That should be like a two hour job for most applications.  This is a
trivial thing to do.  It's difficult for me to consider the difficulty
of doing this a major decision point.

> >> 2) It does not allow thread-level hierarchies to be created
> >
> > Huh?  That's the only thing it would do.  This obviously wouldn't get
> > applied to processes.  It's strictly about threads.
> 
> This allows a single *partition*, not a hierarchy.    As machines
> become larger, so are many of the processes we run on them.  These
> larger processes manage resources between threads on scales that we
> would previously partition between processes.

I don't get it.  Why wouldn't it allow hierarchy?

> >> 3) When coordination with an external agent is desired this defines no
> >> common interface that can be shared.  Directories are an extremely
> >> useful container.  Are you proposing applications would need to
> >> somehow publish the list of anchor-threads from (1)?
> >
> > Again, this is an invariant no matter what we do.  As I wrote numerous
> > times in this thread, this information is only known to the process
> > itself.  If an external agent want to manipulate these from outside,
> > it just has to know which thread is doing what.  The difference is
> > that this doesn't require the process itself to coordinate with
> > external agent when operating on itself.
> 
> Nothing about what was previously state would require any coordination
> with the process and an external agent when operating on itself.
> What's the basis for this claim?

I hope this is explained now.

> This also ignores the cases previously discussed in which the external
> agent is providing state for threads within a process to attach to.
> An example of this is repeated below.
>
> This isn't even covering that this requires the invention of entirely
> new user-level APIs and coordination for somehow publishing these
> magic tids.

We already have those tids.

> >> What if I want to set up state that an application will attaches
> >> threads to [consider cpuset example above]?
> >
> > It feels like we're running in circles.  Process-level control stays
> > the same.  That part is not an issue.  Thread-level control requires
> > cooperation from the process itself no matter what and should stay
> > confined to the limits imposed on the process as a whole.
> >
> > Frankly, cpuset example doesn't make much sense to me because there is
> > nothing hierarchical about it and it isn't even layered properly.  Can
> > you describe what you're actually trying to achieve?  But no matter
> > the specifities of the example, it's almost trivial to achieve
> > whatever end results.
> 
> This has been previously detailed, repeating it here:
> 
> Machines are shared resources, we partition the available cpus into
> shared and private sets.  These sets are dynamic as when a new
> application arrives requesting private cpus, we must reserve some cpus
> that were previously shared.
> 
> We use sub-cpusets to advertise to applications which of their cpus
> are shared and which are private.  They can then attach threads to
> these containers  -- which are dynamically updated as cores shift
> between public and private configurations.

I see but you can easily do that the other way too, right?  Let the
applications publish where they put their threads and let the external
entity set configs on them.

> >> 4) How is the cgroup property to $KEY translation defined?  This feels
> >> like an ioctl and no more natural than the file-system.  It also does
> >
> > How are they even comparable?  Sure ioctl inputs are variable-formed
> > and its definitions aren't closely scrutinized but other than those
> > it's a programmable system-call interface and how programs use and
> > interact with them is completely different from how a program
> > interacts with cgroupfs.
> 
> They're exactly comparable in that every cgroup.<property> api now
> needs some magic equivalent $KEY defined.  I don't understand how
> you're proposing these would be generated or managed.

Not everything.  Just the ones which make sense in-process.  This is
exactly the process we need to go through when introducing new
syscalls.  Why is this a surprise?  We want to scrutinize them, hard.

> > It doesn't have to parse out the path,
> > compose the knob path, open and format the data into it
> 
> There's nothing hard about this.  Further, we already have to do
> exactly this at the process level; which means abstractions for this

I'm not following.  Why would it need to do that already?

> already exist; removing this property does not change their presence
> of requirement, but instead means they must be duplicated for the
> in-thread case.
> 
> Even ignoring that the libraries for this can be shared between thread
> and process, this is also generally easier to work with than magic
> $KEY values.

This is like saying syscalls are worse in terms of progammability
compared to opening and writing formatted strings for setting
attributes.  If that's what you're saying, let's just agree to disgree
on this one.

> > all the while
> > not being sure whether the file it's operating on is even the right
> > one anymore or the sub-hierarchcy it's assuming is still there.
> 
> One possible resolution to this has been proposed several times:
>   Have the sub-process hierarchy exposed in an independent and fixed location.
>
> >> not seem to resolve your concerns regarding races; the application
> >> must still coordinate internally when concurrently calling
> >> set_resource().
> >
> > I have no idea where you're going with this.  When did the internal
> > synchronization inside a process become an issue?  Sure, if a thread
> > does *(int *)=0, we can't protect other threads from it.  Also, why
> > would it be a problem?  If two perform set_resource() on the same
> > thread, one will be executed after the other.  What are you talking
> > about?
> 
> It was my impression that you'd had atomicity concerns regarding
> file-system operations such as writes for updates previously.  If you
> have no concerns within a sub-processes operation then this can be
> discarded.

That's comparing apples and oranges.  Threads being moved around and
hierarchies changing beneath them present a whole different issues
than someone else setting an attribute to a different value.  The
operations might fail, might set properties on the wrong group.

> >> 5) How does an external agent coordinate when a resource must be
> >> removed from a sub-hierarchy?
> >
> > That sort of restriction should generally be put at the higher level.
> > Thread-level resource control should be cooperative with the
> > application if at all necessary and in those cases just set the limit
> > on the sub-hierarchy would work.
> >
> 
> Could you expand on how you envision this being cooperative?  This
> seems tricky to me, particularly when limits are involved.
> 
> How do I even arbitrate which external agents are allowed control?

I think we're talking past each other.  If you wanna put restrictions
on the process as whole, do it at the higher level.  If you wanna
fiddle with in-process resource distribution, you just have to assume
that the application itself is cooperative or at least not malicious.
No matter what external entities try to do, the application can
circumvent because that's what ultimately determines the grouping.

> So I was really trying to make sure we covered the interface problems
> we're trying to solve here.  Are there major ones not listed there?
> 
> However, I strongly disagree with this statement.  It is much easier
> for applications to work with named abstract objects then having magic
> threads that it must track and treat specially.

How is that different?  Sure, the name is created by the threads but
once you set the resource, the tid would be the resource group ID and
the thread can go away.  It's still an object named by an ID.  The
only difference is that the process of creating the hierarchy is tied
to the process that threads are created in.

> My implementation must now look like this:
>   1) I instantiate some abstraction which uses cgroups.
>   2) In construction I must now coordinate with my chosen threading
> implementation (an exciting new dependency) to create a new thread and
> get its tid.  This thread must exist for as long as the associated
> data-structure.  I must pay a kernel stack, at least one page of
> thread stack and however much TLS I've declared in my real threads.
>   3) In destruction I must now wake and free the thread created in (2).
>   4) If I choose to treat it as a real thread, I must be careful, this
> thread is special and cannot be arbitrarily released like other
> threads.
>   5) To do anything I must go grok the documentation to look up the
> magic $KEY.  If I get this wrong I am going to have a fun time
> debugging it since things are no longer reasonably inspect-able.  If I
> must work with a cgroup that adds features over time things are even
> more painful since $KEY may or may not exist.
> 
> Is any of the above unfair with respect to what you've described above?

Yeah, as I wrote above.

> This isn't even beginning to consider the additional pain that a
> language implementing its own run-time such as Go might incur.

Yeap, it does require userland runtime to have a way to make the
thread creation history visible to the operating system.  It doesn't
look like a big price.  Again, I'm looking for a balance.

You're citing inconveniences from userland side and yeah I get that.
Making things more rigid and static requires some adjustments from
userland but we gain from it too.  No need to worry about structural
inconsistencies and the varied failure modes which can cascade from
that.

If the only possible solution is C++-esque everything-goes way, sure,
we'll have to do that but that's not the case.  We can implement and
provide the core functionality in a more controlled manner.

> Option B:
>   We expose sub-process hierarchies via /proc/self/cgroups or similar.
> They do not appear within the process only cgroup hierarchy.
>   Only the same user (or a privileged one) has access to this internal
> hierarchy.  This can be arbitrarily restricted further.
>   Applications continue to use almost exactly the same cgroup
> interfaces that exist today, however, the problem of path computation
> and non-stable paths are now eliminated.
> 
> Really, what problems does this not solve?
>
> It eliminates the unstable mount point, your concerns regarding
> external entity manipulation, and allows for the parent processes to
> be moved.  It provides a reasonable place for coordination to occur,
> with standard mechanisms for access control.  It allows for state to
> be easily inspected, it does not require new documentation, allows the
> creation of sub-hierarchies, does not require special threads.
> 
> This was previously raised as a straw man, but I have not yet seen or
> thought of good arguments against it.

It allows for structural inconsistencies where applications can end up
performing operations which are non-sensical.  Breaking that invariant
is substantial.  Why would we do that if 

Can we at least agree that we're now venturing into an area where
things aren't really critical?  The core functionality here is being
able to hierarchically categorize threads and assign resource limits
to them.  Can we agree that the minimum core functionality is met in
both approaches?

Thanks.

-- 
tejun

From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Wed, 9 Sep 2015 05:49:31 -0700
Message-ID: <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
References: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org> <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org> <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=8fTrA/OUMuPMUCTLOjVRnAzGp959IqYjpLWTP2F0gLU=;
        b=QRYw10KMG57swHrV8EXOYEqY9t7wh5Bt80O2a3X6vQJIEU94AFTpYPTZefCWaDPi1t
         mbH15LmNykIrLbB7t60ZwdpGa8bwKoadukr166bIbSS6S1f95vjQV+1kB/3pIpdHZcl1
         WdU3k/pni/KTJdiYqfA8XTgJyooRY0Am9eLu4cdfT+XnnUJCNCvXo9kj6lIdkXvmvDwB
         P8j/Ozj40+JbIvwu5vXLGQ1N/2eta4NzNmIZHj3jyjWHavPq/F2CBECl490Tgog4xhKt
         HRlDMh/wFXV+SohJLexiTdYTti6+W5F+UA5pD7McqU/ywC63n6beraVaSnd661bqf+2o
         qmdw==
In-Reply-To: <20150825210234.GE26785-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

[ Picking this back up, I was out of the country last week.  Note that
we are also wrestling with some DMARC issues as it was just activated
for Google.com so apologies if people do not receive this directly. ]

On Tue, Aug 25, 2015 at 2:02 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Mon, Aug 24, 2015 at 04:06:39PM -0700, Paul Turner wrote:
>> > This is an erratic behavior on cpuset's part tho.  Nothing else
>> > behaves this way and it's borderline buggy.
>>
>> It's actually the only sane possible interaction here.
>>
>> If you don't overwrite the masks you can no longer manage cpusets wi=
th
>> a multi-threaded application.
>> If you partially overwrite the masks you can create a host of
>> inconsistent behaviors where an application suddenly loses
>> parallelism.
>
> It's a layering problem.  It'd be fine if cpuset either did "layer
> per-thread affinities below w/ config change notification" or "ignore
> and/or reject per-thread affinities".  What we have now is two layers
> manipulating the same field without any mechanism for coordination.
>

I think this is a mischaracterization.  With respect to the two
proposed solutions:

a) Notifications do not solve this problem.
b) Rejecting per-thread affinities is a non-starter.  It's absolutely
needed.  (Aside:  This would also wholly break the existing
sched_setaffinity/getaffinity syscalls.)

I do not think this is a layering problem.  This is more like C++:
there is no sane way to concurrently use all the features available,
however, reasonably self-consistent subsets may be chosen.

>> The *only* consistent way is to clobber all masks uniformly.  Then
>> either arrange for some notification to the application to re-sync, =
or
>> use sub-sub-containers within the cpuset hierarchy to advertise
>> finer-partitions.
>
> I don't get it.  How is that the only consistent way?  Why is making
> irreversible changes even a good way?  Just layer the masks and
> trigger notification on changes.

I'm not sure if you're agreeing or disagreeing here.  Are you saying
there's another consistent way from "clobbering then triggering
notification changes" since it seems like that's what is rejected and
then described.  This certainly does not include any provisions for
reversibility (which I think is a non-starter).

With respect to layering:  Are you proposing we maintain a separate
mask for sched_setaffinity and cpusets, then do different things
depending on their intersection, or lack thereof?  I feel this would
introduce more consistencies than it would solve as these masks would
not be separately inspectable from user-space, leading to confusing
interactions as they are changed.

There are also very real challenges with how any notification is
implemented, independent of delivery:
The 'main' of an application often does not have good control or even
understanding over its own threads since many may be library managed.
Designation of responsibility for updating these masks is difficult.
That said, I think a notification would still be a useful improvement
here and that some applications would benefit.

At the very least, I do not think that cpuset's behavior here can be
dismissed as unreasonable.

>
>> I don't think the case of having a large compute farm with
>> "unimportant" and "important" work is particularly fringe.  Reducing
>> the impact on the "important" work so that we can scavenge more cycl=
es
>> for the latency insensitive "unimportant" is very real.
>
> What if optimizing cache allocation across competing threads of a
> process can yield, say, 3% gain across large compute farm?  Is that
> fringe?

=46rankly, yes.  If you have a compute farm sufficiently dedicated to a
single application I'd say that's a fairly specialized use.  I see no
reason why a more 'technical' API should be a challenge for such a
user.  The fundamental point here was that it's ok for the API of some
controllers to be targeted at system rather than user control in terms
of interface.  This does not restrict their use by users where
appropriate.

>
>> Right, but it's exactly because of _how bad_ those other mechanisms
>> _are_ that cgroups was originally created.    Its growth was not
>> managed well from there, but let's not step away from the fact that
>> this interface was created to solve this problem.
>
> Sure, at the same time, please don't forget that there are ample
> reasons we can't replace more basic mechanisms with cgroups.  I'm not
> saying this can't be part of cgroup but rather that it's misguided to
> do plunge into cgroups as the first and only step.
>

So there is definitely a proliferation of discussion regarding
applying cgroups to other problems which I agree we need to take a
step back and re-examine.

However, here we're fundamentally talking about APIs designed to
partition resources which is the problem that cgroups was introduced
to address.  If we want to introduce another API to do that below the
process level we need to talk about why it's fundamentally different
for processes versus threads, and whether we want two APIs that
interface with the same underlying kernel mechanics.

> More importantly, I am extremely doubtful that we understand the usag=
e
> scenarios and their benefits very well at this point and want to avoi=
d
> over-committing to something we'll look back and regret.  As it
> currently stands, this has a high likelihood of becoming a mismanaged
> growth.

I don't disagree with you with respect to new controllers, but I worry
this is forking the discussion somewhat.  There are two issues being
conflated here:

1) The need for per-thread resource control and what such an API
should look like.
2) The proliferation of new controllers, such as CAT.

We should try to focus on (1) here as that is the most immediate for
forward progress.  We can certainly draw anecdotes from (2) but we do
know (1) applies to existing controllers (e.g. cpu/cpuacct/cpuset).

>
> For the cache allocation thing, I'd strongly suggest something way
> simpler and non-commmittal - e.g. create a char device node with
> simple configuration and basic access control.  If this *really* turn=
s
> out to be useful and its configuration complex enough to warrant
> cgroup integration, let's do it then, and if we actually end up there=
,
> I bet the interface that we'd come up with at that point would be
> different from what people are proposing now.

As above, I really want to focus on (1) so I will be brief here:

Making it a char device requires yet-another adhoc method of
describing process groupings that a configuration should apply to and
yet-another set of rules for its inheritance.  Once we merge it, we're
committed to backwards support of the interface either way, I do not
see what reimplementing things as a char device or sysfs or seqfile or
other buys us over it being cgroupfs in this instance.

I think that the real problem here is that stuff gets merged that does
not follow the rules of how something implemented with cgroups must
behave (typically respect with to a hierarchy); which is obviously
increasingly incompatible with a model where we have a single
hierarchy.  But, provided that we can actually define those rules;  I
do not see the gain in denying the admission of new controller which
is wholly consistent with them.  It does not really measurably add to
the complexity of the implementation (and it greatly reduces it where
grouping semantics are desired).

>
>> > Yeah, I understand the similarity part but don't buy that the bene=
fit
>> > there is big enough to introduce a kernel API which is expected to=
 be
>> > used by individual programs which is radically different from how
>> > processes / threads are organized and applications interact with t=
he
>> > kernel.
>>
>> Sorry, I don't quite follow, in what way is it radically different?
>> What is magically different about a process versus a thread in this
>> sub-division?
>
> I meant that cgroupfs as opposed to most other programming interfaces
> that we publish to applications.  We already have process / thread
> hierarchy which is created through forking/cloning and conventions
> built around them for interaction.

I do not think the process/thread hierarchy is particularly comparable
as it is both immutable and not a partition.  It expresses resource
parenting only.=EF=BF=BC  The only common operation performed on it is =
killing
a sub-tree.

> No sane application programming
> interface requires individual applications to open a file somewhere,
> echo some values to it and use directory operations to manage its
> organization.  Will get back to this later.
>
>> > All controllers only get what their ancestors can hand down to the=
m.
>> > That's basic hierarchical behavior.
>>
>> And many users want non work-conserving systems in which we can add
>> and remove idle resources.  This means that how much bandwidth an
>> ancestor has is not fixed in stone.
>
> I'm having a hard time following you on this part of the discussion.
> Can you give me an example?

=46or example, when a system is otherwise idle we might choose to give
an application additional memory or cpu resources.  These may be
reclaimed in the future, such an update requires updating children to
be compatible with a parents' new limits.
>
>> > If that's the case and we fail miserably at creating a reasonable
>> > programming interface for that, we can always revive thread
>> > granularity.  This is mostly a policy decision after all.
>>
>> These interfaces should be presented side-by-side.  This is not a
>> reasonable patch-later part of the interface as we depend on it toda=
y.
>
> Revival of thread affinity is trivial and will stay that way for a
> long time and the transition is already gradual, so it'll be a lost
> opportunity but there is quite a bit of maneuvering room.  Anyways, o=
n
> with the sub-process interface.
>
> Skipping description of the problems with the current setup here as
> I've repated it a couple times in this thread already.
>
> On the other sub-thread, I said that process/thread tree and cgroup
> association are inherently tied.  This is because a new child task is
> always born into the parent's cgroup and the only reason cgroup works
> on system management use cases is because system management often
> controls enough of how processes are created.
>
> The flexible migration that cgroup supports may suggest that an
> external agent with enough information can define and manage
> sub-process hierarchy without involving the target application but
> this doesn't necessarily work because such information is often only
> available in the application itself and the internal thread hierarchy
> should be agreeable to the hierarchy that's being imposed upon it -
> when threads are dynamically created, different parts of the hierarch=
y
> should be created by different parent thread.

I think what's more important here is that you can define it to work.
This does require cooperation between the external agent and the
application in the layout of the application's hierarchy.  But this is
something we do use.  A good example would be the surfacing of public
and private cpus previously discussed to the application.

>
> Also, the problem with external and in-application manipulations
> stepping on each other's toes is mostly not caused by individual
> config settings but by the possibility that they may try to set up
> different hierarchies or modify the existing one in a way which is no=
t
> expected by the other.

How is this different from say signals or ptrace or any file-system
modification?  This does not seem a problem inherent to cgroups.

>
> Given that thread hierarchy already needs to be compatible with
> resource hierarchy, is something unix programs already understands an=
d
> thus can render itself to an a lot more conventional interface which
> doesn't cause organizational conflicts, I think it's logical to use
> that for sub-process resource distribution.
>
> So, it comes down to sth like the following
>
>         set_resource($TID, $FLAGS, $KEY, $VAL)
>
> - If $TID isn't already a resource group leader, it creates a
>   sub-cgroup, sets $KEY to $VAL and moves $PID and all its descendant=
s
>   to it.
>
> - If $TID is already a resource group leader, set $KEY to $VAL.
>
> - If the process is moved to another cgroup, the sub-hierarchy is
>   preserved.
>

Honestly, I find this API awkward:

1) It depends on "anchor" threads to define groupings.
2) It does not allow thread-level hierarchies to be created
3) When coordination with an external agent is desired this defines no
common interface that can be shared.  Directories are an extremely
useful container.  Are you proposing applications would need to
somehow publish the list of anchor-threads from (1)?  What if I want
to set up state that an application will attaches threads to [consider
cpuset example above]?
4) How is the cgroup property to $KEY translation defined?  This feels
like an ioctl and no more natural than the file-system.  It also does
not seem to resolve your concerns regarding races; the application
must still coordinate internally when concurrently calling
set_resource().
5) How does an external agent coordinate when a resource must be
removed from a sub-hierarchy?

On a larger scale, what properties do you feel this separate API
provides that would not be also supported by instead exposing
sub-process hierarchies via /proc/self or similar.

Perhaps it would help to enumerate the the key problems we're trying
to solve with the choice of this interface?
 1) Thread spanning trees within the cgroup hierarchy.  (Immediately
fixed, only processes are present on the cgroup-mount)
 2) Interactions with the parent process moving within the hierarchy
 3) Potentially supporting move operations within a hierarchy

Are there other cruxes?

> The reality is a bit more complex and cgroup core would need to handl=
e
> implicit leaf cgroups and duplicating sub-hierarchy.  The biggest
> complexity would be extending atomic multi-thread migrations to
> accomodate multiple targets but it already does atomic multi-task
> migrations and performing the migrations back-to-back should work.
> Controller side changes wouldn't be much.  Copying configs to clone
> sub-hierarchy and specifying which are availble should be about it.
>
> This should give applications a simple and straight-forward interface
> to program against while avoiding all the issues with exposing
> cgroupfs directly to individual applications.

Is your primary concern here (2) above?  E.g. that moving the parent
process means that the location we write to for sub-process updates is
not consistent?  Or other?  For issues involving synchronization,
what's proposed at least feels no different to what we face today.

>
>> > So, the proposed patches already merge cpu and cpuacct, at least i=
n
>> > appearance.  Given the kitchen-sink nature of cpuset, I don't thin=
k it
>> > makes sense to fuse it with cpu.
>>
>> Arguments in favor of this:
>>  a) Today the load-balancer has _no_ understanding of group level
>> cpu-affinity masks.
>>  b) With SCHED_NUMA, we can benefit from also being able to apply (b=
)
>> to understand which nodes are usable.
>
> Controllers can cooperate with each other on the unified hierarchy -
> cpu can just query the matching cpuset css about the relevant
> attributes and the results will always be properly hierarchical for
> cpu too.  There's no reason to merge the two controllers for that

Let's shelve this for now.

>
> Thanks.
>
> --
> tejun

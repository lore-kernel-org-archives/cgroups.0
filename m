From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sat, 24 Oct 2015 07:21:10 +0900
Message-ID: <20151023222110.GA4390@mtj.duckdns.org>
References: <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fnxkz3flyy+yMY+V7p8pgeRm0p/RDfkl7JGnM1WQYII=;
        b=pTVQQcQB0gA/61+kMGnCESOyy8ZReOBQhBM5RWW2F7SE3acTwgsYeklhoSo1cLItqh
         CXalVYbgrZPeViLRJQHSCrOCh8kKiidpOgSuWvRiw2o9/+0A4pkEGNcfT564TJ0+jvnn
         JS9Cw/oHePiSm2elWahIuTG2uBSWmd1M4U0UBYQVktC+VO0NdroVWn5x2vbJasuGrQp5
         E/cTNFdYQe2q8w/FkiDw/HpKg5XK5ICNAVulVuVYo047Y4uzPz3J0NcUol1Wf29LQxQv
         7VyepqavNDT/YtcF2r3oKfrlohqNRztCazVyXi7Na1ULsGPIdT/p/rc5Ng3bzTP/iY2i
         0TFg==
Content-Disposition: inline
In-Reply-To: <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Paul.

On Thu, Oct 15, 2015 at 04:42:37AM -0700, Paul Turner wrote:
> > The thing which bothers me the most is that cpuset behavior is
> > different from global case for no good reason.
> 
> I've tried to explain above that I believe there are reasonable
> reasons for it working the way it does from an interface perspective.
> I do not think they can be so quickly discarded out of hand.  However,
> I think we should continue winnowing focus and first resolve the model
> of interaction for sub-process hierarchies,

One way or the other, I think the kernel needs to sort out how task
affinity masks are handled when the available CPUs change, be that
from CPU hotplug or cpuset config changes.

On forcing all affinity masks to the set of available CPUs, I'm still
not convinced that it's a useful extra behavior to implement for
cpuset especially given that the same can be achieved from userland
without too much difficulty.  This goes back to the argument for
implmenting the minimal set of functionality which can be used as
building blocks.  Updating all task affinty masks is an irreversible
destructive operation.  It doesn't enable anything which can't be
otherwise but does end up restricting how the feature can be used.

But yeah, let's shelve this subject for now.

> > Now, if you make the in-process grouping dynamic and accessible to
> > external entities (and if we aren't gonna do that, why even bother?),
> > this breaks down and we have some of the same problems we have with
> > allowing applications to directly manipulate cgroup sub-directories.
> > This is a fundamental problem.  Setting attributes can be shared but
> > organization is an exclusive process.  You can't share that without
> > close coordination.
> 
> Your concern here is centered on permissions, not the interface.
> 
> This seems directly remedied by exactly:
>   Any sub-process hierarchy we exposed would be locked down in terms
> of write access.  These would not be generally writable.  You're
> absolutely correct that you can't share without close coordination,
> and granting the appropriate permissions is part of that.

It is not about permissions.  It is about designing an interface which
guarantees certain set of invariants regardless of priviledges - even
root can't violate such invariants short of injecting code into and
modifying the behavior of the target process.  This isn't anything
unusual.  In fact, permission based access control is something which
is added if and only if allowing and controlling accesses from
multiple parties is necessary and needs to be explicitly justified.

If coordination in terms of thread hierarchy organization from the
target process is needed for allowing external entities to twiddle
with resource distribution, no capability is lost by making the
organization solely the responsibility of the target process while
gaining a lot stronger set of behavioral invariants.  I can't see
strong enough justifications for allowing external entities to
manipulate in-process thread organization.

> > assigning the full responsiblity of in-process organization to the
> > application itself and tying it to static parental relationship allows
> > for solid common grounds where these resource operations can be
> > performed by different entities without causing structural issues just
> > like other similar operations.
> 
> But cases have already been presented above where the full
> responsibility cannot be delegated to the application.  Because we
> explicitly depend on constraints being provided by the external
> environment.

I don't think such cases have been presented.  The only thing
necessary is the target processes organizing threads in a way which
allows external agents to apply external constraints.

> > It's not that but more about what the file-system interface implies.
> > It's not just different.  It breaks a lot of expectations a lot of
> > application visible kernel interface provides as explained above.
> > There are reasons why we usually don't do things this way.
> 
> The arguments you've made above are largely centered on permissions
> and the right to make modifications.  I don't see what other
> expectations you believe are being broken here.  This still feels like
> an aesthetic objection.

I hope my points are clear by now.

> > It does require the applications to follow certain protocols to
> > organize itself but this is a pretty trivial thing to do and comes
> > with the benefit that we don't need to introduce a completely new
> > grouping concept to applications.
> 
> I strongly disagree here:  Applications today do _not_ use sub-process
> clone hierarchies today.  As a result, this _is_ introducing a
> completely new grouping concept because it's one applications have
> never cared about outside of a shell implementation.

It is a logical extension of how the kernel organizes processes in the
system.  It's a lot more native to how programs usually interact with
the system than meddling with a pseudo file system.

> > That should be like a two hour job for most applications.  This is a
> > trivial thing to do.  It's difficult for me to consider the difficulty
> > of doing this a major decision point.
> 
> You are seriously underestimating the complexity and API overhead this
> introduces.  It cannot be claimed trivial and discarded; it's not.

You're exaggerating.  Requiring applications to organize threads
according to, most likely, their logical roles, is not an unreasonable
burden for enabling hierarchical resource control.  While I can
understand the reluctance for users who are currently making use of
task-granular cgroups, please realize that we're trying to introduce a
whole new class of features directly visible to applications.  Future
usages will vastly outnumber that of the current cgroup hack.  In
addition, it's not like the current users are required to migrate
immediately.

> "- If $TID isn't already a resource group leader, it creates a
>   sub-cgroup, sets $KEY to $VAL and moves $PID and all its descendants
>   to it.
> 
> - If $TID is already a resource group leader, set $KEY to $VAL."
> 
> This only allows resource groups at the root level to be created.
> There is no way to make $TID2 a resource group leader, parented by
> $TID1.

I probably should have written it better but obviously a new resource
group for $TID would be nested under the resource group $TID is
already in.

> > We already have those tids.
> 
> External management applications do not.  This was covering that would
> now need a new API to handle their publishing.  Whereas using the VFS
> handles this naturally.

I suppose you're suggesting that naming conventions in the per-process
cgroup hierarchy can be used as a mechanism to carry such information,
am I right?  If so, it's trivial to solve.  Just let the application
tag the TID based resource groups with an integer or string
identifying hints.

> > I see but you can easily do that the other way too, right?  Let the
> > applications publish where they put their threads and let the external
> > entity set configs on them.
> 
> And what API controls the right to do this?

Exactly the same as prlimit(2)?  In fact, while details will dictate
what will happen exactly, we might even just extend prlimit(2) instead
of introducing completely new syscalls.  Please not that the fact that
prlimit(2) can be so easily referred to is not an accident.  This is
because what's being proposed is a natural extension of the model the
kernel already uses.

> > Not everything.  Just the ones which make sense in-process.  This is
> > exactly the process we need to go through when introducing new
> > syscalls.  Why is this a surprise?  We want to scrutinize them, hard.
> 
> I'm talking only about the control->$KEY mapping.  Yes it would be a
> subset, but this seems a large step back in usability.

I don't understand.  This is introducing a whole new set of syscalls
to be used by applications and we *need* to scrutinize and restrict
what's being exposed.  Furthermore, as there are inherent differences
in system management interface and application programming interface,
we should filter what's to be exposed to individual applications
regardless of the specific mechanism for the interface.  For example,
it doesn't make any sense to expose "cgroup.procs" or "release_agent"
on in-process interface.

It'd be a step back in usability only for users who have been using
cgroups in fringing ways which can't be justified for ratification and
we do want to actively filter those out.  It may cause a short-term
pain for some but the whole thing is an a lot larger problem.  Let's
please think long term.

> > I'm not following.  Why would it need to do that already?
> 
> Because the process-level interface will continue to work the way it
> does today.  That means we still need to implement these operations.
> 
> This same library code could be shared for applications to use on
> their private, sub-process, controls.

This doesn't make any sense.  The reason why cgroup users need low
level access libraries is because the file system interface is too
unwiedly to program directly against.  The fact the system management
interface requires such library can't possibly be an argument against
the kernel providing a programmable interface to applications.

> > This is like saying syscalls are worse in terms of progammability
> > compared to opening and writing formatted strings for setting
> > attributes.  If that's what you're saying, let's just agree to disgree
> > on this one.
> 
> The goal of such a system is as much administration as it is a
> programmable interface.  There's a reason much configuration is
> specified by sysctls and not syscalls.

And there are reasons why individual applications usually don't
program directly against sysctl or other system management interfaces.
It's the kernel's job to provide abstractions so that those two
spheres can be separated reasonably.  We don't want system management
meddling with thread organization of applications.  That's the
application's domain.  Applying attributes on top sure can be done
from outside.

> > That's comparing apples and oranges.  Threads being moved around and
> > hierarchies changing beneath them present a whole different issues
> > than someone else setting an attribute to a different value.  The
> > operations might fail, might set properties on the wrong group.
> 
> There are no differences between using VFS and your proposed API for this.

I hope this part is clear now.

> I think you misunderstood here.  What I'm saying is equivalently:
> - How do I bless a 'good' external agent to be allowed to make modificaitons
> - How do I make sure a malicious external process is not able to make
> modifications

I'm lost why these are even being asked.  Why would it be any
different from other syscalls which manipulate similar attributes?

> > How is that different?  Sure, the name is created by the threads but
> > once you set the resource, the tid would be the resource group ID and
> > the thread can go away.  It's still an object named by an ID.
> 
> Huh?? If the thread goes away, then the tid can be re-used -- within
> the same process.  Now you have non-unique IDs to operate on??

The TID can be pinned on group creation or we can track thread
hierarchy (while collapsing irrelevant dead parts) to allow setting
attributes on siblings instead.  These are details which can be
fleshed out as design and implementation progresses.  Let's please
concentrate on the general approach for now.

> > It allows for structural inconsistencies where applications can end up
> > performing operations which are non-sensical.  Breaking that invariant
> > is substantial.  Why would we do that if
> 
> Can you please provide an example?  I don't know what inconsistencies
> you mean here.  In particular, I do not see anything that your
> proposed interface resolves versus this; while being _significantly_
> simpler for applications to use and implement.

The fact that in-process hierarchy can be manipulated by external
entities, regardless of permissions, means that the organization can
be changed underneath the application in a way which can cause various
failures and unexpected behaviors when the application later on
performs operations assuming the original organization.

> > Can we at least agree that we're now venturing into an area where
> > things aren't really critical?  The core functionality here is being
> > able to hierarchically categorize threads and assign resource limits
> > to them.  Can we agree that the minimum core functionality is met in
> > both approaches?
> 
> I'm not sure entirely how to respond here.  I am deeply concerned that
> the API you're proposing is not tenable for providing this core
> functionality.  I worry that you're introducing serious new challenges
> and too quickly discarding them as manageable.

The capability to obtain here is allowing threads of a process to be
organized hierarchically and controlling resource distribution along
that hierarchy.  I'm asking whether you agree that such core
capability can be obtained in both approaches.

I think you're underestimating the gravity of adding a whole new set
of interfaces to be used by applications.  This is something which
will be with us decades later.  I can understand the reluctance coming
for the existing users; however, in perspective, that is not a concern
that we can or should hinge major decisions on, so I beg you to take a
step back from immediate concerns and take a longer-term look at the
problem.

Also, while holding off the v2 interface for the cpu controller is an
understandable method of exerting political (I don't mean in a
derogative way) pressure on resolving the in-process resource
management issue, I don't think our specific disagreements affect
system level interface in any way.  Given the size of the problem,
implementing a proper solution for this problem will likely take quite
a while even after we agree on the approach.  As, AFAICS, there aren't
technical reasons to hold back v2 interface, can we please proceed
there?  I promise to keep working on in-process resource distribution
to the best of my abilities.  It's something I want to solve anyway.

Thanks.

-- 
tejun

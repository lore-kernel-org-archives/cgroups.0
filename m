From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 17 Aug 2015 21:03:30 -0700
Message-ID: <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org> <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org> <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=vRkjjDJ3E+xRkNNxkM2eLRiHoHPMvP6AjqErGI1nxFM=;
        b=c02IbtFe0BF9ziHzy2FUjll9t6aLV0D70RgT3SUgw70xehQrEF0O61SjR9n6rDE5Bg
         XARg0TAxW3aNyxzXOQq9Dp+Tmj9r77UndhRX/kPXUtkkxUjzxPm8uLMoJfJMTePMI4na
         pc0z9QPnYEpIP4nYhVtLNKXVAguaXp2OYNybaRBtnfgpq1bcTMBTgyhFAspvbOxQK3uh
         JM79kdCENu9cCKwT/lmmYPw6K/lWP/Ge0X79Pi/Pjh8MnCEUr9Opxg5Wgp2TO/w0f4+b
         Mh4dmTpva6xKtAi2X45fbfUXTa5vq/gdXNt1IRBRs4TUjjnhoyq5nH1JrAcveQSJmT4+
         +IRQ==
In-Reply-To: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Apologies for the repeat.  Gmail ate its plain text setting for some
reason.  Shame bells.

On Mon, Aug 17, 2015 at 9:02 PM, Paul Turner <pjt@google.com> wrote:
>
>
> On Wed, Aug 5, 2015 at 7:31 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> Hello,
>>
>> On Wed, Aug 05, 2015 at 11:10:36AM +0200, Peter Zijlstra wrote:
>> > > I've been thinking about it and I'm now convinced that cgroups just is
>> > > the wrong interface to require each application to be programming
>> > > against.
>> >
>> > But people are doing it. So you must give them something. You cannot
>> > just tell them to go away.
>>
>> Sure, more on specifics later, but, first of all, the transition to v2
>> is a gradual process.  The new and old hierarchies can co-exist, so
>> nothing forces abrupt transitions.  Also, we do want to start as
>> restricted as possible and then widen it gradually as necessary.
>>
>> > So where are the people doing this in this discussion? Or are you
>> > one-sidedly forcing things? IIRC Google was doing this.
>>
>> We've been having those discussions for years in person and on the
>> cgroup mailing list.  IIRC, the google case was for blkcg where they
>> have an IO proxy process which wanna issue IOs as different cgroups
>> depending on who's the original issuer.  They created multiple
>> threads, put them in different cgroups and bounce the IOs to the
>> matching one; however, this is already pretty silly as they have to
>> bounce IOs to different threads.  What makes a lot more sense here is
>> the ability to tag an IO as coming from a specific cgroup (or a
>> process's cgroup) and there was discussion of using an extra field in
>> aio request to indicate this, which is an a lot better solution for
>> the problem, can also express different IO priority and pretty easy to
>> implement.
>>
>
> So we have two major types of use that are relevant to this interface:
>
> 1) Proxy agents.  When a control systems want to perform work on behalf of a
> container, they will sometimes move the acting thread into the relevant
> control groups so that it can be accounted on that container's behalf.
> [This is more relevant for non-persistent resources such as CPU time or I/O
> priorities than charges that will outlive the work such as memory
> allocations.]
>
> I agree (1) is at best a bit of a hack and can be worked around on the type
> of time-frame these interfaces move at.
>
> 2) Control within an address-space.  For subsystems with fungible resources,
> e.g. CPU, it can be useful for an address space to partition its own
> threads.  Losing the capability to do this against the CPU controller would
> be a large set-back for instance.  Occasionally, it is useful to share these
> groupings between address spaces when processes are cooperative, but this is
> less of a requirement.
>
> This is important to us.
>
>
>> > The whole libvirt trainwreck also does this (the programming against
>> > cgroups, not the per task thing afaik).
>>
>> AFAIK, libvirt is doing multiple backends anyway and as long as the
>> delegation rules are clear, libvirt managing its own subhierarchy is
>> not a problem.  It's an administration software stack which requires
>> fairly close integration with the userland part of operating system.
>>
>> > You also cannot mandate system-disease, not everybody will want to run
>> > that monster. From what I understood last time, Google has no interest
>> > what so ever of using it.
>>
>> But what would require tight coupling of individual applications and
>> something like systemd is the kernel failing to set up a reasonable
>> boundary between management and application interfaces.  If the kernel
>> provides a useable API for individual applications to use, they'll
>> program against it and the management part can be whatever.  If we
>> fail to do that, individual applications will have to talk to external
>> agent to coordinate access to management interface
>
>
> It's notable here that for a managed system, the agent coordinating access
> *must* be external
>
>>
>> and that's what'll
>> end up creating hard dependency on specific system agents from
>> applications like apache or mysql or whatever.  We really don't want
>> that.  The kernel *NEEDS* to clearly distinguish those two to prevent
>> that from happening.
>>
>> > > I wrote this in the CAT thread too but cgroups may be an
>> > > okay management / administration interface but is a horrible
>> > > programming interface to be used by individual applications.
>> >
>> > Yeah, I need to catch up on that CAT thread, but the reality is, people
>> > use it as a programming interface, whether you like it or not.
>>
>> And that's one of the major fuck ups on cgroup's part that must be
>> rectified.  Look at the interface being proposed there.  It's exposing
>> direct hardware details w/o much abstraction which is fine for a
>> system management interface but at the same time it's intended to be
>> exposed to individual applications.
>
>
> FWIW this is something we've had no significant problems managing with
> separate mount mounts and file system protections.  Yes, there are some
> potential warts around atomicity; but we've not found them too onerous.
>
> What I don't quite follow here is the assumption that CAT should would be
> necessarily exposed to individual applications? What's wrong with subsystems
> that are primarily intended only for system management agents, we already
> have several of these.
>
>
>>
>> This lack of distinction makes
>> people skip the attention that they should be paying when they're
>> designing interface exposed to individual programs.  Worse, this makes
>> these things fly under the review scrutiny that public API accessible
>> to applications usually receives.  Yet, that's what these things end
>> up to be.  This just has to stop.  cgroups can't continue to be this
>> ghetto shortcut to implementing half-assed APIs.
>
>
> I certainly don't disagree on this point :).  But as above, I don't quite
> follow why an API being in cgroups must mean it's accessible to an
> application controlled by that group.  This has certainly not been a
> requirement for our use.
>
>>
>>
>> > > For things which don't require hierarchy, the obvious thing to do is
>> > > implementing a usual syscall-like interface be it a separate syscall,
>> > > an prctl command, an ioctl or whatever.
>> >
>> > And then you get /proc extensions to observe them, then people make
>> > those /proc extensions writable and before you know it you've got an
>> > equal or bigger mess back than you started out with :-(
>>
>> What we should be doing is pushing them into the same arena as any
>> other publicly accessible API.  I don't think there can be a shortcut
>> to this.
>>
>
> Are you explicitly opposed to non-hierarchical partitions, however?  Cpuset
> is [typically] an example of this, where the interface wants to control
> unified properties across a set of processes.  Without necessarily being
> usefully hierarchical.  (This is just to understand your core position, I'm
> not proposing cpuset should shape *anything*.)
>
>>
>> > > For things which require
>> > > building a hierarchy of member threads, the right thing to do is
>> > > making it a part of the usual process hierarchy - this is *the*
>> > > hierarchy that applications are familiar with and have the facilities
>> > > to deal with, so we can, for example, add a clone or unshare flag
>> > > which puts the calling threads in a new child group and then let that
>> > > use the fore-mentioned syscall-like interface to configure whatever it
>> > > wants to configure.
>> >
>> > And then you get to add support to cgroups to migrate hierarchies, is
>> > that complexity you're waiting for?
>>
>> Absolutely, if it comes to that, that's what we should do.  The only
>> other option is spilling and getting locked into half-baked interface
>> to applications which not only harm userland but also kernel.
>>
>> > Not to mention that its an unwieldy interface because then you get spawn
>> > spawning threads etc.. Seeing how its impossible for the main thread to
>> > create N tasks in one subgroup and another M tasks in another subgroup.
>> >
>> > Instead they get to spawn a thread A, with which they then need to
>> > communicate to spawn a further N tasks, then spawn a thread B, and again
>> > communicate for another M tasks.
>> >
>> > That's a rather awkward change to how people usually spawn threads.
>>
>> It is within the usual purview of how userland deals with hierarchies
>> of processes / threads and I don't think it's necessarily bad and more
>> importantly I don't think the use case or the perceived awkwardness
>> justifies introducing a wholely new mechanism.
>>
>> > Also, what to do when a thread changes profile? I can imagine a
>> > situation where a task accepts a connection and depending on the kind of
>> > request it gets, gets placed into a certain sub-group.
>>
>> Migration is a very expensive operation.  The obvious thing to do for
>> such cases is having pools of workers for different profiles.  Also,
>> as mentioned before, for more specific cases like IO, it makes a lot
>> more sense to override things per operation rather than moving threads
>> around.
>>
>> > But there's no migration facility, so you get to go hand the work
>> > around, which is expensive.
>>
>> That's a lot cheaper than migrating.
>>
>> > If there would be a migration facility, you've just lost naming, so how
>> > are you going to denote the subgroups?
>>
>> I don't think we want migration in sub-process hierarchy but in the
>> off chance we do the naming can follow the same pid/program
>> group/session id scheme, which, again, is a lot easier to deal with
>> from applications.
>
>
> I don't have many objections with hand-off versus migration above, however,
> I think that this is a big drawback.  Threads are expensive to create and
> are often cached rather than released.  While migration may be expensive,
> creating a more thread is more so.  The important to reconfigure a thread's
> personality at run-time is important.
>
>>
>> > > In the long term, this is *way* better than
>> > > letting individual applications fumble with cgroup hierarchy
>> > > delegation and pseudo filesystem access.
>> >
>> > You're worried about the intersection between what a task does and what
>> > the administrator does, and that's a valid worry. But I'm really not
>> > convinced this is going to make it better.
>> >
>> > We already have relative file ops (openat(), mkdirat(), unlinkat()
>> > etc..) can't we make sure they do the right thing in the face of a
>> > process (hierarchy) getting migrated by the administrator.
>>
>> But those are relative to the current directory per operation and
>> there's no way to define a transaction across multiple file
>> operations.  There's no way to prevent a process from being migrated
>> inbetween openat() and subsequent write().
>
>
> A forwarding /proc/thread_self/cgroup accessor, or similar, would be another
> way to address some of these issues.
>
>>
>>
>> > That way, things at least _can_ work right, and I think being able to do
>> > the right thing trumps not being able to make a mess -- people are
>> > people, they'll always make a mess.
>>
>> It can't, at least not in the usual manner that file system operations
>> are defined.  This is an interface which requires central coordination
>> (even for delegation) and a horrible one to expose to individual
>> applications.
>>
>> > > If hierarchical weight and/or bandwidth limiting for thread hierarchy
>> > > is absolutely necessary, doing this shouldn't be too difficult and I
>> > > suspect it wouldn't be all that different from autogroup.
>> >
>> > Autogroups are a bit icky and have the 'advantage' of not intersecting
>> > with regular cgroups (much). The above has intricate intersection with
>> > the cgroup stuff.
>> >
>> > As said, your migrate process becomes a move hierarchy. You further get
>> > more 'hidden' cgroups. /proc files that report what cgroup a task is in
>> > will report a cgroup that's not actually present in the filesystem
>> > (autogroups already does this, it confuses people). And as stated you
>> > take away a lot of things that are now possible.
>>
>> I don't think it's a lot that per-process is gonna take away.
>> Per-thread use cases are pretty niche to begin with and most can and
>> should be implemented better using a more fitting mechanism.  As for
>> having to deal with more complexity in cgroup core, that's fine.  If
>> it comes to that, we'll have to bite the bullet and do it.  Sure, we
>> want to be simpler but not at the cost of messing up userland API and
>> please note that what we lost with cgroups is this tension.
>
>
> I don't quite agree here.  Losing per-thread control within the cpu
> controller is likely going to mean that much of it ends up being
> reimplemented as some duplicate-in-appearance interface that gets us back to
> where we are today.  I recognize that these controllers (cpu, cpuacct) are
> square pegs in that per-process makes sense for most other sub-systems; but
> unfortunately, their needs and use-cases are real / dependent on their
> present form.
>
>>
>> This tension between the difficulty and complexity of implementing
>> something which can be used by applications and the necessity or
>> desirability of the proposed use cases is crucial in steering kernel
>> development and the APIs it exposes.  Abusing cgroups like we've been
>> doing bypasses that tension and we of course end up locked into an
>> extremely crappy interfaces and mechanisms which could never be
>> justified in the first place.  This is about time we stopped this
>> disaster train.
>>
>> Thanks.
>>
>> --
>> tejun
>
>

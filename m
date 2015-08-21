From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Fri, 21 Aug 2015 12:26:30 -0700
Message-ID: <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org> <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org> <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com> <20150818203117.GC15739@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=3HrkRSB0ETyVvUf+6EPgZ4HU5NZjfCBvOtJMz0c36Y4=;
        b=Or+B5Lz2S1iFGV+NIba5Y0q46BJZL8RL2mm4wWIihBnNqRUChWRD3LWUP+K73Iks+c
         WP8BuOCAC8tzCzPaOYQWjXMlczr2qVtFtzrkffjhj+J5Q3OpSc0hIpoB/t17ec1TDWIJ
         drB0has4gOd17NJRVYgwQ6MxbFWtmRfHIl2gZd0edTMUCTguuCIUb4rtAR5D/M1o8nAp
         +NgQsfqGFWaKVe7CEz1I+ktg8AM8eFt6ACbvt3BmW7NBwSycErS5fqk3l7PvfgpPyNKA
         EpXAEWw7QToXHo9W3jehAA6uqnXn3cwaDmtEhc/E28RxwfKNLQv2idK3tTw76xJ7TYAq
         P3Kw==
In-Reply-To: <20150818203117.GC15739-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Aug 18, 2015 at 1:31 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Paul.
>
> On Mon, Aug 17, 2015 at 09:03:30PM -0700, Paul Turner wrote:
>> > 2) Control within an address-space.  For subsystems with fungible resources,
>> > e.g. CPU, it can be useful for an address space to partition its own
>> > threads.  Losing the capability to do this against the CPU controller would
>> > be a large set-back for instance.  Occasionally, it is useful to share these
>> > groupings between address spaces when processes are cooperative, but this is
>> > less of a requirement.
>> >
>> > This is important to us.
>
> Sure, let's build a proper interface for that.  Do you actually need
> sub-hierarchy inside a process?  Can you describe your use case in
> detail and why having hierarchical CPU cycle distribution is essential
> for your use case?
>

One common example here is a thread-pool.  Having a hierarchical
constraint allows users to specify what proportion of time it should
receive, independent of how many threads are placed in the pool.

A very concrete example of the above is a virtual machine in which you
want to guarantee scheduling for the vCPU threads which must schedule
beside many hypervisor support threads.   A hierarchy is the only way
to fix the ratio at which these compete.

An example that's not the cpu controller is that we use cpusets to
expose to applications their "shared" and "private" cores.  (These
sets are dynamic based on what is coscheduled on a given machine.)

>> >> And that's one of the major fuck ups on cgroup's part that must be
>> >> rectified.  Look at the interface being proposed there.  It's exposing
>> >> direct hardware details w/o much abstraction which is fine for a
>> >> system management interface but at the same time it's intended to be
>> >> exposed to individual applications.
>> >
>> > FWIW this is something we've had no significant problems managing with
>> > separate mount mounts and file system protections.  Yes, there are some
>> > potential warts around atomicity; but we've not found them too onerous.
>
> You guys control the whole stack.  Of course, you can get away with an
> interface which are pretty messed up in terms of layering and
> isolation; however, generic kernel interface cannot be designed
> according to that standard.

I feel like two points are being conflated here:

Yes, it is sufficiently generic that it's possible to configure
nonsensical things.

But, it is also possible to lock things down presently.  This is, for
better or worse, the direction that general user-space has also taken
with centralized management daemons such as systemd.

Setting design aside for a moment -- which I fully agree with you that
there is room for large improvement in.  The largest idiosyncrasy
today is that the configuration above does depend on having a stable
mount point for applications to manage their sub-hierarchies.
Migrations would improve this greatly, but this is a bit of a detour
because you're looking to fix the fundamental design rather than
improve the state of the world and that's probably a good thing :)

>
>> > What I don't quite follow here is the assumption that CAT should would be
>> > necessarily exposed to individual applications? What's wrong with subsystems
>> > that are primarily intended only for system management agents, we already
>> > have several of these.
>
> Why would you assume that threads of a process wouldn't want to
> configure it ever?  How is this different from CPU affinity?

In general cache and CPU behave differently.  Generally for it to make
sense between threads in a process they would have to have wholly
disjoint memory, at which point the only sane long-term implementation
is separate processes and the management moves up a level anyway.

That said, there are surely cases in which it might be convenient to
use at a per-thread level to correct a specific performance anomaly.
But at that point, you have certainly reached the level of hammer that
you can coordinate with an external daemon if necessary.

>
>> >> This lack of distinction makes
>> >> people skip the attention that they should be paying when they're
>> >> designing interface exposed to individual programs.  Worse, this makes
>> >> these things fly under the review scrutiny that public API accessible
>> >> to applications usually receives.  Yet, that's what these things end
>> >> up to be.  This just has to stop.  cgroups can't continue to be this
>> >> ghetto shortcut to implementing half-assed APIs.
>> >
>> > I certainly don't disagree on this point :).  But as above, I don't quite
>> > follow why an API being in cgroups must mean it's accessible to an
>> > application controlled by that group.  This has certainly not been a
>> > requirement for our use.
>
> I don't follow what you're trying to way with the above paragraph.
> Are you still talking about CAT?  If so, that use case isn't the only
> one.  I'm pretty sure there are people who would want to configure
> cache allocation at thread level.

I'm not agreeing with you that "in cgroups" means "must be usable by
applications within that hierarchy".  A cgroup subsystem used as a
partitioning API only by system management daemons is entirely
reasonable.  CAT is a reasonable example of this.

>
>> >> What we should be doing is pushing them into the same arena as any
>> >> other publicly accessible API.  I don't think there can be a shortcut
>> >> to this.
>> >
>> > Are you explicitly opposed to non-hierarchical partitions, however?  Cpuset
>> > is [typically] an example of this, where the interface wants to control
>> > unified properties across a set of processes.  Without necessarily being
>> > usefully hierarchical.  (This is just to understand your core position, I'm
>> > not proposing cpuset should shape *anything*.)
>
> I'm having trouble following what you're trying to say.  FWIW, cpuset
> is fully hierarchical.

I think where I was going with this is better addressed above.  Here
all I meant is that it's difficult to construct useful sub-hierarchies
on the cpuset side, especially for memory.   But this is a little
x86-centric so let's drop it.

>
>> >> I don't think we want migration in sub-process hierarchy but in the
>> >> off chance we do the naming can follow the same pid/program
>> >> group/session id scheme, which, again, is a lot easier to deal with
>> >> from applications.
>> >
>> > I don't have many objections with hand-off versus migration above, however,
>> > I think that this is a big drawback.  Threads are expensive to create and
>> > are often cached rather than released.  While migration may be expensive,
>> > creating a more thread is more so.  The important to reconfigure a thread's
>> > personality at run-time is important.
>
> The core problem here is picking the hot path.  If cgroups as a whole
> doesn't pick a position here, controllers have to assume that
> migration might not be a very cold path which naturally leads to
> overall designs and synchronization schemes which concede hot path
> performance to accomodate migration.  We simply can't afford to do
> that - we end up losing way more in way hotter paths for something
> which may be marginally useful in some corner cases.
>
> So, this is a trade-off we're consciously making.  If there are
> common-enough use cases which require jumping across different cgroup
> domains, we'll try to figure out a way to accomodate those but by
> default migration is a very cold and expensive path.
>

The core here was the need for allowing sub-process migration.  I'm
not sure I follow the performance trade-off argument; haven't we
historically seen the opposite?  That migration has been a slow-path
without optimizations and people pushing to make it faster?  This
seems a hard generalization to make for something that's inherently
tied to a particular controller.

I don't care if we try turning that dial back to assume it's a cold
path once more, only that it's supported.

>> >> But those are relative to the current directory per operation and
>> >> there's no way to define a transaction across multiple file
>> >> operations.  There's no way to prevent a process from being migrated
>> >> inbetween openat() and subsequent write().
>> >
>> > A forwarding /proc/thread_self/cgroup accessor, or similar, would be another
>> > way to address some of these issues.
>
> That sounds horrible to me.  What if the process wants to do RMW a
> config?

Locking within a process is easy.

> What if the permissions are different after an intervening
> migration?

This is a side-effect of migration not being properly supported.

> What if the sub-hierarchy no longer exists or has been
> replaced by a hierarchy with the same topology but actualy is a
> different one?

The easy answer is that:  Only a process should be managing its
sub-hierarchy.  That's the nice thing about hierarchies.

The harder answer is:  How do we handle non-fungible resources such as
CPU assignments within a hierarchy?  This is a big part of why I make
arguments for certain partitions being management-software only above.
This is imperfect, but better then where we stand today.

>
>> > I don't quite agree here.  Losing per-thread control within the cpu
>> > controller is likely going to mean that much of it ends up being
>> > reimplemented as some duplicate-in-appearance interface that gets us back to
>> > where we are today.  I recognize that these controllers (cpu, cpuacct) are
>> > square pegs in that per-process makes sense for most other sub-systems; but
>> > unfortunately, their needs and use-cases are real / dependent on their
>> > present form.
>
> Let's build an API which actually looks and behaves like an API which
> is properly isolated from what external agents may do to the process.
> I can't see how that would be "back to where we are today".  All of
> those are pretty critical attributes for a public kernel API and
> utterly broken right now.
>

Sure, but I don't think you can throw out per-thread control for all
controllers to enable this.  Which makes everything else harder.  A
intermediary step in unification might be that we move from N mounts
to 2.  Those that can be managed at the process level, and those that
can't.  It's a compromise, but may allow cleaner abstractions for the
former case.

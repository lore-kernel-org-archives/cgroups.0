From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 5 Aug 2015 11:10:36 +0200
Message-ID: <20150805091036.GT25159@twins.programming.kicks-ass.net>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150804151017.GD17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Aug 04, 2015 at 11:10:17AM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, Aug 04, 2015 at 11:07:11AM +0200, Peter Zijlstra wrote:
> > What about the unified hierarchy stuff cannot deal with per-task
> > controllers?
> > 
> > _That_ was the biggest problem from what I can remember, and I see no
> > proposed resolution for that here.
> 
> I've been thinking about it and I'm now convinced that cgroups just is
> the wrong interface to require each application to be programming
> against.

But people are doing it. So you must give them something. You cannot
just tell them to go away.

So where are the people doing this in this discussion? Or are you
one-sidedly forcing things? IIRC Google was doing this.

The whole libvirt trainwreck also does this (the programming against
cgroups, not the per task thing afaik).

You also cannot mandate system-disease, not everybody will want to run
that monster. From what I understood last time, Google has no interest
what so ever of using it.

> I wrote this in the CAT thread too but cgroups may be an
> okay management / administration interface but is a horrible
> programming interface to be used by individual applications.

Yeah, I need to catch up on that CAT thread, but the reality is, people
use it as a programming interface, whether you like it or not.

> For things which don't require hierarchy, the obvious thing to do is
> implementing a usual syscall-like interface be it a separate syscall,
> an prctl command, an ioctl or whatever.

And then you get /proc extensions to observe them, then people make
those /proc extensions writable and before you know it you've got an
equal or bigger mess back than you started out with :-(

> For things which require
> building a hierarchy of member threads, the right thing to do is
> making it a part of the usual process hierarchy - this is *the*
> hierarchy that applications are familiar with and have the facilities
> to deal with, so we can, for example, add a clone or unshare flag
> which puts the calling threads in a new child group and then let that
> use the fore-mentioned syscall-like interface to configure whatever it
> wants to configure.

And then you get to add support to cgroups to migrate hierarchies, is
that complexity you're waiting for?

Not to mention that its an unwieldy interface because then you get spawn
spawning threads etc.. Seeing how its impossible for the main thread to
create N tasks in one subgroup and another M tasks in another subgroup.

Instead they get to spawn a thread A, with which they then need to
communicate to spawn a further N tasks, then spawn a thread B, and again
communicate for another M tasks.

That's a rather awkward change to how people usually spawn threads.

Also, what to do when a thread changes profile? I can imagine a
situation where a task accepts a connection and depending on the kind of
request it gets, gets placed into a certain sub-group.

But there's no migration facility, so you get to go hand the work
around, which is expensive.

If there would be a migration facility, you've just lost naming, so how
are you going to denote the subgroups?

> In the long term, this is *way* better than
> letting individual applications fumble with cgroup hierarchy
> delegation and pseudo filesystem access.

You're worried about the intersection between what a task does and what
the administrator does, and that's a valid worry. But I'm really not
convinced this is going to make it better.

We already have relative file ops (openat(), mkdirat(), unlinkat()
etc..) can't we make sure they do the right thing in the face of a
process (hierarchy) getting migrated by the administrator.

That way, things at least _can_ work right, and I think being able to do
the right thing trumps not being able to make a mess -- people are
people, they'll always make a mess.

> If hierarchical weight and/or bandwidth limiting for thread hierarchy
> is absolutely necessary, doing this shouldn't be too difficult and I
> suspect it wouldn't be all that different from autogroup.

Autogroups are a bit icky and have the 'advantage' of not intersecting
with regular cgroups (much). The above has intricate intersection with
the cgroup stuff.

As said, your migrate process becomes a move hierarchy. You further get
more 'hidden' cgroups. /proc files that report what cgroup a task is in
will report a cgroup that's not actually present in the filesystem
(autogroups already does this, it confuses people). And as stated you
take away a lot of things that are now possible.



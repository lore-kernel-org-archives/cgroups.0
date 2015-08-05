From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 5 Aug 2015 10:31:32 -0400
Message-ID: <20150805143132.GK17598@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ts3bQEjkGkZEJIaADdUFZreVHK6yqDukM52bk5EbXwM=;
        b=w1z/AVtiQicqZe1SDEuzQtNTfM4jd4qakFyRpkv+KQcfW9dLB1nrioERs/X4CfgW5/
         BilJevTWtecguyh5qngzLvGbhi5wctseF64AQ6R9W3FLwwsPhqNtCqBlcyYmq4pkEMFK
         fqSCkiG5sD/vgd/nfkWoWYxh11krMpnJUBZiw0dPqitSwJElfUXRIJB46x5e4hOZaVWp
         dkjgMiqZULKitkOzQEDQ+ry2LkLagcHUKAlTrStMvBVs/50NYYIsGxzlP564xXXVAgUK
         6GtmHHEestkASiJ5YQiRI5gdf0qJmSTKiQ1cNGiGO1B5qObCQ/OWFLM+VopXKegK9/h0
         DmDA==
Content-Disposition: inline
In-Reply-To: <20150805091036.GT25159-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Wed, Aug 05, 2015 at 11:10:36AM +0200, Peter Zijlstra wrote:
> > I've been thinking about it and I'm now convinced that cgroups just is
> > the wrong interface to require each application to be programming
> > against.
> 
> But people are doing it. So you must give them something. You cannot
> just tell them to go away.

Sure, more on specifics later, but, first of all, the transition to v2
is a gradual process.  The new and old hierarchies can co-exist, so
nothing forces abrupt transitions.  Also, we do want to start as
restricted as possible and then widen it gradually as necessary.

> So where are the people doing this in this discussion? Or are you
> one-sidedly forcing things? IIRC Google was doing this.

We've been having those discussions for years in person and on the
cgroup mailing list.  IIRC, the google case was for blkcg where they
have an IO proxy process which wanna issue IOs as different cgroups
depending on who's the original issuer.  They created multiple
threads, put them in different cgroups and bounce the IOs to the
matching one; however, this is already pretty silly as they have to
bounce IOs to different threads.  What makes a lot more sense here is
the ability to tag an IO as coming from a specific cgroup (or a
process's cgroup) and there was discussion of using an extra field in
aio request to indicate this, which is an a lot better solution for
the problem, can also express different IO priority and pretty easy to
implement.

> The whole libvirt trainwreck also does this (the programming against
> cgroups, not the per task thing afaik).

AFAIK, libvirt is doing multiple backends anyway and as long as the
delegation rules are clear, libvirt managing its own subhierarchy is
not a problem.  It's an administration software stack which requires
fairly close integration with the userland part of operating system.

> You also cannot mandate system-disease, not everybody will want to run
> that monster. From what I understood last time, Google has no interest
> what so ever of using it.

But what would require tight coupling of individual applications and
something like systemd is the kernel failing to set up a reasonable
boundary between management and application interfaces.  If the kernel
provides a useable API for individual applications to use, they'll
program against it and the management part can be whatever.  If we
fail to do that, individual applications will have to talk to external
agent to coordinate access to management interface and that's what'll
end up creating hard dependency on specific system agents from
applications like apache or mysql or whatever.  We really don't want
that.  The kernel *NEEDS* to clearly distinguish those two to prevent
that from happening.

> > I wrote this in the CAT thread too but cgroups may be an
> > okay management / administration interface but is a horrible
> > programming interface to be used by individual applications.
> 
> Yeah, I need to catch up on that CAT thread, but the reality is, people
> use it as a programming interface, whether you like it or not.

And that's one of the major fuck ups on cgroup's part that must be
rectified.  Look at the interface being proposed there.  It's exposing
direct hardware details w/o much abstraction which is fine for a
system management interface but at the same time it's intended to be
exposed to individual applications.  This lack of distinction makes
people skip the attention that they should be paying when they're
designing interface exposed to individual programs.  Worse, this makes
these things fly under the review scrutiny that public API accessible
to applications usually receives.  Yet, that's what these things end
up to be.  This just has to stop.  cgroups can't continue to be this
ghetto shortcut to implementing half-assed APIs.

> > For things which don't require hierarchy, the obvious thing to do is
> > implementing a usual syscall-like interface be it a separate syscall,
> > an prctl command, an ioctl or whatever.
> 
> And then you get /proc extensions to observe them, then people make
> those /proc extensions writable and before you know it you've got an
> equal or bigger mess back than you started out with :-(

What we should be doing is pushing them into the same arena as any
other publicly accessible API.  I don't think there can be a shortcut
to this.

> > For things which require
> > building a hierarchy of member threads, the right thing to do is
> > making it a part of the usual process hierarchy - this is *the*
> > hierarchy that applications are familiar with and have the facilities
> > to deal with, so we can, for example, add a clone or unshare flag
> > which puts the calling threads in a new child group and then let that
> > use the fore-mentioned syscall-like interface to configure whatever it
> > wants to configure.
> 
> And then you get to add support to cgroups to migrate hierarchies, is
> that complexity you're waiting for?

Absolutely, if it comes to that, that's what we should do.  The only
other option is spilling and getting locked into half-baked interface
to applications which not only harm userland but also kernel.

> Not to mention that its an unwieldy interface because then you get spawn
> spawning threads etc.. Seeing how its impossible for the main thread to
> create N tasks in one subgroup and another M tasks in another subgroup.
> 
> Instead they get to spawn a thread A, with which they then need to
> communicate to spawn a further N tasks, then spawn a thread B, and again
> communicate for another M tasks.
> 
> That's a rather awkward change to how people usually spawn threads.

It is within the usual purview of how userland deals with hierarchies
of processes / threads and I don't think it's necessarily bad and more
importantly I don't think the use case or the perceived awkwardness
justifies introducing a wholely new mechanism.

> Also, what to do when a thread changes profile? I can imagine a
> situation where a task accepts a connection and depending on the kind of
> request it gets, gets placed into a certain sub-group.

Migration is a very expensive operation.  The obvious thing to do for
such cases is having pools of workers for different profiles.  Also,
as mentioned before, for more specific cases like IO, it makes a lot
more sense to override things per operation rather than moving threads
around.

> But there's no migration facility, so you get to go hand the work
> around, which is expensive.

That's a lot cheaper than migrating.

> If there would be a migration facility, you've just lost naming, so how
> are you going to denote the subgroups?

I don't think we want migration in sub-process hierarchy but in the
off chance we do the naming can follow the same pid/program
group/session id scheme, which, again, is a lot easier to deal with
from applications.

> > In the long term, this is *way* better than
> > letting individual applications fumble with cgroup hierarchy
> > delegation and pseudo filesystem access.
> 
> You're worried about the intersection between what a task does and what
> the administrator does, and that's a valid worry. But I'm really not
> convinced this is going to make it better.
> 
> We already have relative file ops (openat(), mkdirat(), unlinkat()
> etc..) can't we make sure they do the right thing in the face of a
> process (hierarchy) getting migrated by the administrator.

But those are relative to the current directory per operation and
there's no way to define a transaction across multiple file
operations.  There's no way to prevent a process from being migrated
inbetween openat() and subsequent write().

> That way, things at least _can_ work right, and I think being able to do
> the right thing trumps not being able to make a mess -- people are
> people, they'll always make a mess.

It can't, at least not in the usual manner that file system operations
are defined.  This is an interface which requires central coordination
(even for delegation) and a horrible one to expose to individual
applications.

> > If hierarchical weight and/or bandwidth limiting for thread hierarchy
> > is absolutely necessary, doing this shouldn't be too difficult and I
> > suspect it wouldn't be all that different from autogroup.
> 
> Autogroups are a bit icky and have the 'advantage' of not intersecting
> with regular cgroups (much). The above has intricate intersection with
> the cgroup stuff.
>
> As said, your migrate process becomes a move hierarchy. You further get
> more 'hidden' cgroups. /proc files that report what cgroup a task is in
> will report a cgroup that's not actually present in the filesystem
> (autogroups already does this, it confuses people). And as stated you
> take away a lot of things that are now possible.

I don't think it's a lot that per-process is gonna take away.
Per-thread use cases are pretty niche to begin with and most can and
should be implemented better using a more fitting mechanism.  As for
having to deal with more complexity in cgroup core, that's fine.  If
it comes to that, we'll have to bite the bullet and do it.  Sure, we
want to be simpler but not at the cost of messing up userland API and
please note that what we lost with cgroups is this tension.

This tension between the difficulty and complexity of implementing
something which can be used by applications and the necessity or
desirability of the proposed use cases is crucial in steering kernel
development and the APIs it exposes.  Abusing cgroups like we've been
doing bypasses that tension and we of course end up locked into an
extremely crappy interfaces and mechanisms which could never be
justified in the first place.  This is about time we stopped this
disaster train.

Thanks.

-- 
tejun

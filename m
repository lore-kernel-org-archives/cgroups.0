From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 18 Aug 2015 13:31:17 -0700
Message-ID: <20150818203117.GC15739@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Dyfw/KM/5VBDzFeRx00maVfuF1MuXbIJfQzp5bSbq5c=;
        b=ubSWkV/gcAuZk1iGMi8TIhyM+jlruQBvfR/QFQ/Rxuvohva8lr1SFcQRFKHOkCoWgx
         IMnmNt1fXDudQbYHYcqscxn/e1xTEiLQaSqkIgWZPbpt0Q7SMj16LSpRT1rvL9IH6SNz
         t0mHyGgGEdVuj8uF67V0mo0e9fnNWznh6L04eMDBqOUmVIK95ugTxo+0cD6whkOelOcF
         aLg3OK4FhNBw8KuWgVlahWYFHzTbwx9xWBZlGaai843g8OZQ94h52WsUf13kDn/8ZoCS
         SdNHiOfH+jJAOd/yCrY3OHJ0TKufweifgsgHAb1uWJUgetIOzjw18A3GlpwUbCTgmFX+
         ikNw==
Content-Disposition: inline
In-Reply-To: <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Paul.

On Mon, Aug 17, 2015 at 09:03:30PM -0700, Paul Turner wrote:
> > 2) Control within an address-space.  For subsystems with fungible resources,
> > e.g. CPU, it can be useful for an address space to partition its own
> > threads.  Losing the capability to do this against the CPU controller would
> > be a large set-back for instance.  Occasionally, it is useful to share these
> > groupings between address spaces when processes are cooperative, but this is
> > less of a requirement.
> >
> > This is important to us.

Sure, let's build a proper interface for that.  Do you actually need
sub-hierarchy inside a process?  Can you describe your use case in
detail and why having hierarchical CPU cycle distribution is essential
for your use case?

> >> And that's one of the major fuck ups on cgroup's part that must be
> >> rectified.  Look at the interface being proposed there.  It's exposing
> >> direct hardware details w/o much abstraction which is fine for a
> >> system management interface but at the same time it's intended to be
> >> exposed to individual applications.
> >
> > FWIW this is something we've had no significant problems managing with
> > separate mount mounts and file system protections.  Yes, there are some
> > potential warts around atomicity; but we've not found them too onerous.

You guys control the whole stack.  Of course, you can get away with an
interface which are pretty messed up in terms of layering and
isolation; however, generic kernel interface cannot be designed
according to that standard.

> > What I don't quite follow here is the assumption that CAT should would be
> > necessarily exposed to individual applications? What's wrong with subsystems
> > that are primarily intended only for system management agents, we already
> > have several of these.

Why would you assume that threads of a process wouldn't want to
configure it ever?  How is this different from CPU affinity?

> >> This lack of distinction makes
> >> people skip the attention that they should be paying when they're
> >> designing interface exposed to individual programs.  Worse, this makes
> >> these things fly under the review scrutiny that public API accessible
> >> to applications usually receives.  Yet, that's what these things end
> >> up to be.  This just has to stop.  cgroups can't continue to be this
> >> ghetto shortcut to implementing half-assed APIs.
> >
> > I certainly don't disagree on this point :).  But as above, I don't quite
> > follow why an API being in cgroups must mean it's accessible to an
> > application controlled by that group.  This has certainly not been a
> > requirement for our use.

I don't follow what you're trying to way with the above paragraph.
Are you still talking about CAT?  If so, that use case isn't the only
one.  I'm pretty sure there are people who would want to configure
cache allocation at thread level.

> >> What we should be doing is pushing them into the same arena as any
> >> other publicly accessible API.  I don't think there can be a shortcut
> >> to this.
> >
> > Are you explicitly opposed to non-hierarchical partitions, however?  Cpuset
> > is [typically] an example of this, where the interface wants to control
> > unified properties across a set of processes.  Without necessarily being
> > usefully hierarchical.  (This is just to understand your core position, I'm
> > not proposing cpuset should shape *anything*.)

I'm having trouble following what you're trying to say.  FWIW, cpuset
is fully hierarchical.

> >> I don't think we want migration in sub-process hierarchy but in the
> >> off chance we do the naming can follow the same pid/program
> >> group/session id scheme, which, again, is a lot easier to deal with
> >> from applications.
> >
> > I don't have many objections with hand-off versus migration above, however,
> > I think that this is a big drawback.  Threads are expensive to create and
> > are often cached rather than released.  While migration may be expensive,
> > creating a more thread is more so.  The important to reconfigure a thread's
> > personality at run-time is important.

The core problem here is picking the hot path.  If cgroups as a whole
doesn't pick a position here, controllers have to assume that
migration might not be a very cold path which naturally leads to
overall designs and synchronization schemes which concede hot path
performance to accomodate migration.  We simply can't afford to do
that - we end up losing way more in way hotter paths for something
which may be marginally useful in some corner cases.

So, this is a trade-off we're consciously making.  If there are
common-enough use cases which require jumping across different cgroup
domains, we'll try to figure out a way to accomodate those but by
default migration is a very cold and expensive path.

> >> But those are relative to the current directory per operation and
> >> there's no way to define a transaction across multiple file
> >> operations.  There's no way to prevent a process from being migrated
> >> inbetween openat() and subsequent write().
> >
> > A forwarding /proc/thread_self/cgroup accessor, or similar, would be another
> > way to address some of these issues.

That sounds horrible to me.  What if the process wants to do RMW a
config?  What if the permissions are different after an intervening
migration?  What if the sub-hierarchy no longer exists or has been
replaced by a hierarchy with the same topology but actualy is a
different one?

> > I don't quite agree here.  Losing per-thread control within the cpu
> > controller is likely going to mean that much of it ends up being
> > reimplemented as some duplicate-in-appearance interface that gets us back to
> > where we are today.  I recognize that these controllers (cpu, cpuacct) are
> > square pegs in that per-process makes sense for most other sub-systems; but
> > unfortunately, their needs and use-cases are real / dependent on their
> > present form.

Let's build an API which actually looks and behaves like an API which
is properly isolated from what external agents may do to the process.
I can't see how that would be "back to where we are today".  All of
those are pretty critical attributes for a public kernel API and
utterly broken right now.

Thanks.

-- 
tejun

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 4 Aug 2015 11:10:17 -0400
Message-ID: <20150804151017.GD17598@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PQ9o2tRWCXswfbsb885m7/1I8XhvpxGf/wHPhrPTCEo=;
        b=UBLJH+uxrYbebs4CgZ3KEwWo9DrESNWwdwKV/EBK78K+K25PdglyP8LKVT/Df7txp6
         b1yDgJmNL5BkOUgcblTOg5VQBGnTgf5BAsYlet/InrkGOPslP6xpNcDQP+zuRcm3VwRS
         8Xx+1uELEeZLoyXEU48dCI8nRuTtvIApt/NSJ/COshGlPmH9aDEB7ozF0gPq6N4obbLM
         MQwezRXORj1yRKfH9FwKyGo0euC4m2P12mHb8jViWk0FPCnIsVbUMz77eyz7zFCcsIxy
         G4rE8gu5xRzNNHp9wQxy+7wPiRbYpqqOUkIX6vW3pZ2+U5Itz5k6PtnVDmRzbWeXLUTz
         MVBQ==
Content-Disposition: inline
In-Reply-To: <20150804090711.GL25159@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello, Peter.

On Tue, Aug 04, 2015 at 11:07:11AM +0200, Peter Zijlstra wrote:
> What about the unified hierarchy stuff cannot deal with per-task
> controllers?
> 
> _That_ was the biggest problem from what I can remember, and I see no
> proposed resolution for that here.

I've been thinking about it and I'm now convinced that cgroups just is
the wrong interface to require each application to be programming
against.  I wrote this in the CAT thread too but cgroups may be an
okay management / administration interface but is a horrible
programming interface to be used by individual applications.

For things which don't require hierarchy, the obvious thing to do is
implementing a usual syscall-like interface be it a separate syscall,
an prctl command, an ioctl or whatever.  For things which require
building a hierarchy of member threads, the right thing to do is
making it a part of the usual process hierarchy - this is *the*
hierarchy that applications are familiar with and have the facilities
to deal with, so we can, for example, add a clone or unshare flag
which puts the calling threads in a new child group and then let that
use the fore-mentioned syscall-like interface to configure whatever it
wants to configure.  In the long term, this is *way* better than
letting individual applications fumble with cgroup hierarchy
delegation and pseudo filesystem access.

If hierarchical weight and/or bandwidth limiting for thread hierarchy
is absolutely necessary, doing this shouldn't be too difficult and I
suspect it wouldn't be all that different from autogroup.

> > * cpuacct is implictly enabled and disabled by cpu and its information
> >   is reported through "cpu.stat" which now uses microseconds for all
> >   time durations.  All time duration fields now have "_usec" appended
> >   to them for clarity.  While this doesn't solve the double accounting
> >   immediately, once majority of users switch to v2, cpu can directly
> >   account and report the relevant stats and cpuacct can be disabled on
> >   the unified hierarchy.
> > 
> >   Note that cpuacct.usage_percpu is currently not included in
> >   "cpu.stat".  If this information is actually called for, it can be
> >   added later.
> 
> Since you're rev'ing the interface, can't we simply kill the old cpuacct
> and implement the missing pieces in cpu directly ?

Yeah, that's the plan.  For the transitional period however, we'd have
a lot more usages where cpuacct is mounted in a legacy hierarchy so I
didn't want to incur the overhead of duplicate accounting for those
cases and the dependency mechanism is already there making it trivial.

> > * "cpu.cfs_quota_us" and "cpu.cfs_period_us" are replaced by "cpu.max"
> >   which contains both quota and period.
> 
> This is indeed a maximum limit, however
> 
> > * "cpu.rt_runtime_us" and "cpu.rt_period_us" are replaced by
> >   "cpu.rt.max" which contains both runtime and period.
> 
> the RT thing is conceptually more of a minimum guarantee, than a
> maximum, even though the current implementation is both, there are plans
> to allow (controlled) relaxation of the maximum part.

Ah, I see.  Yeah, then it should be cpu.rt.min.  I'll just remove the
file until the relaxation part is determined.

> Also, if you're going to rev the interface, there's more changes we
> should make. I'll have to go dig them out.

Great, please let me know what you have on mind.

Thanks.

-- 
tejun

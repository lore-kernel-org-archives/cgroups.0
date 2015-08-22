From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sat, 22 Aug 2015 11:29:16 -0700
Message-ID: <20150822182916.GE20768@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eO7k0qba95JOD/aMAOhfgOQgjE+l7YTln+pj1Nr0bxI=;
        b=jUNkY8cLkJgJM0hH7DX4QilgsN+6sR+12kjDUZH7gdeZMoSncr8zj47vGGXXPXdiLL
         0FsazfKoW0ALF2EWfImP6SDxyYkci6NVCM7Gkc8TTNBCiArlrqpdKsvBSMNVHlxDOKD6
         mttx088GYL+zT755hjjcfXhqNaVfwM1DpF1bdjR7dJDUPKROekjcPtP997UBrabSQ6sd
         AT44BsFuEujYohtzGT3/Ilsxmi8LwSDLzmX59pCAKrj+FUSq0xOadaGX1VFEUu1KRXeS
         vnzs69J3tU7qmfwL9FNqTagwHHxiiwdqXwvGdLlSeg+3CJsNeMsiomJKiE9RRtnLaoNF
         dp6g==
Content-Disposition: inline
In-Reply-To: <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Hello, Paul.

On Fri, Aug 21, 2015 at 12:26:30PM -0700, Paul Turner wrote:
...
> A very concrete example of the above is a virtual machine in which you
> want to guarantee scheduling for the vCPU threads which must schedule
> beside many hypervisor support threads.   A hierarchy is the only way
> to fix the ratio at which these compete.

Just to learn more, what sort of hypervisor support threads are we
talking about?  They would have to consume considerable amount of cpu
cycles for problems like this to be relevant and be dynamic in numbers
in a way which letting them competing against vcpus makes sense.  Do
IO helpers meet these criteria?

> An example that's not the cpu controller is that we use cpusets to
> expose to applications their "shared" and "private" cores.  (These
> sets are dynamic based on what is coscheduled on a given machine.)

Can you please go into more details with these?

> > Why would you assume that threads of a process wouldn't want to
> > configure it ever?  How is this different from CPU affinity?
> 
> In general cache and CPU behave differently.  Generally for it to make
> sense between threads in a process they would have to have wholly
> disjoint memory, at which point the only sane long-term implementation
> is separate processes and the management moves up a level anyway.
> 
> That said, there are surely cases in which it might be convenient to
> use at a per-thread level to correct a specific performance anomaly.
> But at that point, you have certainly reached the level of hammer that
> you can coordinate with an external daemon if necessary.

So, I'm not super familiar with all the use cases but the whole cache
allocation thing is almost by nature a specific niche thing and I feel
pretty reluctant to blow off per-thread usages as too niche to worry
about.

> > I don't follow what you're trying to way with the above paragraph.
> > Are you still talking about CAT?  If so, that use case isn't the only
> > one.  I'm pretty sure there are people who would want to configure
> > cache allocation at thread level.
> 
> I'm not agreeing with you that "in cgroups" means "must be usable by
> applications within that hierarchy".  A cgroup subsystem used as a
> partitioning API only by system management daemons is entirely
> reasonable.  CAT is a reasonable example of this.

I see.  The same argument.  I don't think CAT just being system
management thing makes sense.

> > So, this is a trade-off we're consciously making.  If there are
> > common-enough use cases which require jumping across different cgroup
> > domains, we'll try to figure out a way to accomodate those but by
> > default migration is a very cold and expensive path.
> 
> The core here was the need for allowing sub-process migration.  I'm
> not sure I follow the performance trade-off argument; haven't we
> historically seen the opposite?  That migration has been a slow-path
> without optimizations and people pushing to make it faster?  This
> seems a hard generalization to make for something that's inherently
> tied to a particular controller.

It isn't something tied to a particular controller.  Some controllers
may get impacted less by than others but there's an inherent
connection between how dynamic an association is and how expensive the
locking around it needs to be and we need to set up basic behavior and
usage conventions so that different controllers are designed and
implemented assuming similar usage patterns; otherwise, we end up with
the chaotic shit show that we have had where everything behaves
differently and nobody knows what's the right way to do things and we
end up locked into weird requirements which some controller induced
for no good reason but cause significant pain on use cases which
actually matter.

> I don't care if we try turning that dial back to assume it's a cold
> path once more, only that it's supported.

It has always been a cold path and I'm not saying this is gonna be
noticeably worse in the future but usages like bouncing threads on
request-by-request basis are and will be clearly worse than bouncing
to threads which are already in the target domain.

> >> > A forwarding /proc/thread_self/cgroup accessor, or similar, would be another
> >> > way to address some of these issues.
> >
> > That sounds horrible to me.  What if the process wants to do RMW a
> > config?
> 
> Locking within a process is easy.

It's not contained in the process at all.  What if an external entity
decides to migrate the process into another cgroup inbetween?

> > What if the permissions are different after an intervening
> > migration?
> 
> This is a side-effect of migration not being properly supported.
>
> > What if the sub-hierarchy no longer exists or has been
> > replaced by a hierarchy with the same topology but actualy is a
> > different one?
> 
> The easy answer is that:  Only a process should be managing its
> sub-hierarchy.  That's the nice thing about hierarchies.

cgroupfs is a horrible place to implement that part of interface.  It
doesn't make any sense to combine those two into the same hierarchy.
You're agreeing to the identified problem but somehow still suggesting
doing what we've been doing when the root cause of the said problem is
conflating and interlocking these two separate things.

> The harder answer is:  How do we handle non-fungible resources such as
> CPU assignments within a hierarchy?  This is a big part of why I make
> arguments for certain partitions being management-software only above.
> This is imperfect, but better then where we stand today.

I'm not following.  Why is that different?

> > Let's build an API which actually looks and behaves like an API which
> > is properly isolated from what external agents may do to the process.
> > I can't see how that would be "back to where we are today".  All of
> > those are pretty critical attributes for a public kernel API and
> > utterly broken right now.
> 
> Sure, but I don't think you can throw out per-thread control for all
> controllers to enable this.  Which makes everything else harder.  A
> intermediary step in unification might be that we move from N mounts
> to 2.  Those that can be managed at the process level, and those that
> can't.  It's a compromise, but may allow cleaner abstractions for the
> former case.

The transition can already be gradual.  Why would you add yet another
transition step?

Thanks.

-- 
tejun

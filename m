From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 4 Aug 2015 11:07:11 +0200
Message-ID: <20150804090711.GL25159@twins.programming.kicks-ass.net>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438641689-14655-4-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 03, 2015 at 06:41:29PM -0400, Tejun Heo wrote:
> While the cpu controller doesn't have any functional problems, there
> are a couple interface issues which can be addressed in the v2
> interface.
> 
> * cpuacct being a separate controller.  This separation is artificial
>   and rather pointless as demonstrated by most use cases co-mounting
>   the two controllers.  It also forces certain information to be
>   accounted twice.
> 
> * Use of different time units.  Writable control knobs use
>   microseconds, some stat fields use nanoseconds while other cpuacct
>   stat fields use centiseconds.
> 
> * Control knobs which can't be used in the root cgroup still show up
>   in the root.
> 
> * Control knob names and semantics aren't consistent with other
>   controllers.

What about the unified hierarchy stuff cannot deal with per-task
controllers?

_That_ was the biggest problem from what I can remember, and I see no
proposed resolution for that here.

> This patchset implements cpu controller's interface on the unified
> hierarchy which adheres to the controller file conventions described
> in Documentation/cgroups/unified-hierarchy.txt.  Overall, the
> following changes are made.
> 
> * cpuacct is implictly enabled and disabled by cpu and its information
>   is reported through "cpu.stat" which now uses microseconds for all
>   time durations.  All time duration fields now have "_usec" appended
>   to them for clarity.  While this doesn't solve the double accounting
>   immediately, once majority of users switch to v2, cpu can directly
>   account and report the relevant stats and cpuacct can be disabled on
>   the unified hierarchy.
> 
>   Note that cpuacct.usage_percpu is currently not included in
>   "cpu.stat".  If this information is actually called for, it can be
>   added later.

Since you're rev'ing the interface, can't we simply kill the old cpuacct
and implement the missing pieces in cpu directly ?

> * "cpu.shares" is replaced with "cpu.weight" and operates on the
>   standard scale defined by CGROUP_WEIGHT_MIN/DFL/MAX (1, 100, 10000).
>   The weight is scaled to scheduler weight so that 100 maps to 1024
>   and the ratio relationship is preserved - if weight is W and its
>   scaled value is S, W / 100 == S / 1024.  While the mapped range is a
>   bit smaller than the orignal scheduler weight range, the dead zones
>   on both sides are relatively small and covers wider range than the
>   nice value mappings.  This file doesn't make sense in the root
>   cgroup and isn't create on root.

Not too thrilled about this, but if people can live with the reduced
resolution then I suppose we can do.

> * "cpu.cfs_quota_us" and "cpu.cfs_period_us" are replaced by "cpu.max"
>   which contains both quota and period.

This is indeed a maximum limit, however

> * "cpu.rt_runtime_us" and "cpu.rt_period_us" are replaced by
>   "cpu.rt.max" which contains both runtime and period.

the RT thing is conceptually more of a minimum guarantee, than a
maximum, even though the current implementation is both, there are plans
to allow (controlled) relaxation of the maximum part.

Also, if you're going to rev the interface, there's more changes we
should make. I'll have to go dig them out.

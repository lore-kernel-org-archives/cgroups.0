From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] sched: Implement interface for cgroup unified
 hierarchy
Date: Sat, 29 Jul 2017 11:17:07 +0200
Message-ID: <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
References: <20170720184808.1433868-1-tj@kernel.org>
 <20170720184808.1433868-3-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bZN08l8ep7Cjw+ryRskVC+2PeIStazVELLAUg5UV9Ic=; b=BvyGkptpDi+x6/qXjW18x9T8H
        9Z/UZqTHQ1OBZXRxp6JANzZDUusMqX7PRj5fvz9cuM31dSuW/md6tiyt344b/0T1XR4J/PHveCVqf
        st8EfddkCmHk8UlPHWx3kieXQwjeY7GQpX+UXfIhXXLkljBobO08SODjznsfELodv+mFkh4MOoqHU
        u/SR9p6VAW8OGnLiXSBvwOYxK7D5XYqrXpqzGmeuAQlb0spe9rhyBtEUDp7ibDMPw/qorAv2Z/uNR
        YneNpILjzaEP/dR7nG9YmesxExQOXTKrhfqwuB8GVtdf/ILG5humYQldN15FwhHe2uSspt8M/QDhm
    
Content-Disposition: inline
In-Reply-To: <20170720184808.1433868-3-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Thu, Jul 20, 2017 at 02:48:08PM -0400, Tejun Heo wrote:
> There are a couple interface issues which can be addressed in cgroup2
> interface.
> 
> * Stats from cpuacct being reported separately from the cpu stats.
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
> 
> This patchset implements cpu controller's interface on cgroup2 which
> adheres to the controller file conventions described in
> Documentation/cgroups/cgroup-v2.txt.  Overall, the following changes
> are made.
> 
> * cpuacct is implictly enabled and disabled by cpu and its information
>   is reported through "cpu.stat" which now uses microseconds for all
>   time durations.  All time duration fields now have "_usec" appended
>   to them for clarity.
> 
>   Note that cpuacct.usage_percpu is currently not included in
>   "cpu.stat".  If this information is actually called for, it will be
>   added later.
> 
> * "cpu.shares" is replaced with "cpu.weight" and operates on the
>   standard scale defined by CGROUP_WEIGHT_MIN/DFL/MAX (1, 100, 10000).
>   The weight is scaled to scheduler weight so that 100 maps to 1024
>   and the ratio relationship is preserved - if weight is W and its
>   scaled value is S, W / 100 == S / 1024.  While the mapped range is a
>   bit smaller than the orignal scheduler weight range, the dead zones
>   on both sides are relatively small and covers wider range than the
>   nice value mappings.  This file doesn't make sense in the root
>   cgroup and isn't create on root.

s/create/&d/

Thanks!

> * "cpu.weight.nice" is added. When read, it reads back the nice value
>   which is closest to the current "cpu.weight".  When written, it sets
>   "cpu.weight" to the weight value which matches the nice value.  This
>   makes it easy to configure cgroups when they're competing against
>   threads in threaded subtrees.
> 
> * "cpu.cfs_quota_us" and "cpu.cfs_period_us" are replaced by "cpu.max"
>   which contains both quota and period.
> 
> * "cpu.rt_runtime_us" and "cpu.rt_period_us" are replaced by
>   "cpu.rt.max" which contains both runtime and period.

So we've been looking at overhauling the whole RT stuff. But sadly we've
not been able to find something that works with all the legacy
constraints (like RT tasks having arbitrary affinities).

Lets just hope we can preserve this interface :/
> 
> v3: - Added "cpu.weight.nice" to allow using nice values when
>       configuring the weight.  The feature is requested by PeterZ.
>     - Merge the patch to enable threaded support on cpu and cpuacct.

>     - Dropped the bits about getting rid of cpuacct from patch
>       description as there is a pretty strong case for making cpuacct
>       an implicit controller so that basic cpu usage stats are always
>       available.

What about the whole double accounting thing? Because currently cpuacct
and cpu do a fair bit of duplication. It would be very good to get rid
of that.

>     - Documentation updated accordingly.  "cpu.rt.max" section is
>       dropped for now.

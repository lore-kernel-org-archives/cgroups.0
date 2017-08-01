From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 1 Aug 2017 23:40:38 +0200
Message-ID: <20170801214038.sp4lw6lrnl3votte@hirez.programming.kicks-ass.net>
References: <20170720184808.1433868-1-tj@kernel.org>
 <20170720184808.1433868-3-tj@kernel.org>
 <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
 <20170801201745.GA2311718@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=35nNzyNij6zOVQ5u1KSXdmUrqIYXyfJcWYFPElgsvQo=; b=BoOSJ4pI0Hrmvd8cak/nq4t65
        r4dxOdKKgbwh62n7RAiHClr/5Wp4Mrk1WeQ++u1gFtVEc/kzXocINPWAZcl+Gnqqt3EZMJIoBc74b
        NCZvAKCcjCNRQecf7Z8eiFXpP8JQYQkSD0iP0uOV8EqiACfZ3+ZSe76VlvFFw6hyfDHUS4xoJqg51
        GaX2i1+rJJmd8d7zfPP7rh0nb4ybIxrWUUddBukKR9J402uTiYkqEpIvq/yYhSs8ZvqhWqcXcw/vD
        bIOJo+11qoCrXR6KGBI6frjMgBAv6f+/5A17kdcLKajIrj2MtfBOb1W4SJOzp1UDhFUFQeMbvrkLs
    
Content-Disposition: inline
In-Reply-To: <20170801201745.GA2311718-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Tue, Aug 01, 2017 at 01:17:45PM -0700, Tejun Heo wrote:

> > What about the whole double accounting thing? Because currently cpuacct
> > and cpu do a fair bit of duplication. It would be very good to get rid
> > of that.
> 
> I'm not that sure at this point.  Here are my current thoughts on
> cpuacct.
> 
> * It is useful to have basic cpu statistics on cgroup without having
>   to enable the cpu controller, especially because enabling cpu
>   controller always changes how cpu cycles are distributed and
>   currently comes at some performance overhead.
> 
> * On cgroup2, there is only one hierarchy.  It'd be great to have
>   basic resource accounting enabled by default on all cgroups.  Note
>   that we couldn't do that on v1 because there could be any number of
>   hierarchies and the cost would increase with the number of
>   hierarchies.

Yes, the whole single hierarchy thing makes doing away with the double
accounting possible.

> * It is bothersome that we're walking up the tree each time for
>   cpuacct although being percpu && just walking up the tree makes it
>   relatively cheap.

So even if its only CPU local accounting, you still have all the pointer
chasing and misses, not to mention that a faster O(depth) is still
O(depth).

>		Anyways, I'm thinking about shifting the
>   aggregation to the reader side so that the hot path always only
>   updates local counters in a way which can scale even when there are
>   a lot of (idle) cgroups.  Will follow up on this later.

Not entirely sure I follow, we currently only update the current cgroup
and its immediate parents, no? Or are you looking to only account into
the current cgroup and propagate into the parents on reading?

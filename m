From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 2 Aug 2017 08:41:35 -0700
Message-ID: <20170802154135.GI2311718@devbig577.frc2.facebook.com>
References: <20170720184808.1433868-1-tj@kernel.org>
 <20170720184808.1433868-3-tj@kernel.org>
 <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
 <20170801201745.GA2311718@devbig577.frc2.facebook.com>
 <20170801214038.sp4lw6lrnl3votte@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=abNcUbzoBhWAdZCHn8IsuRABPE1x2d7AipZ+lQJEGRE=;
        b=ha1vk/legvysAPgqQzO+lqUBK5sksVwyT0A1n/ohEOWzlWze50aGMb/qPyBY7Sd58q
         Xxgh1s/A84E7hEtsq5aUG44YNPZJRM0SwZ/LKrDtgg3k+9fJpiGgt0d0DthJSxRsOOFP
         gbPRtyJdhdswq49g2TO9Y78jXJkvnOlMc68dn5tPvMrYHEYxdupY3Oe91QT7yX/1dgwe
         evuAUXejxdwVoLo7f4sLQIdAw5ZVKLcImoneQ96eiiuxwYT2hBBU6hZJwNAe9pzj3NsZ
         pRXLuav+Em3jBk/JUmJ2u+/EVhLD37IyPfeNMjwJWLCJXSkfWwiesm44FjJm3jAm7+ZF
         N/gg==
Content-Disposition: inline
In-Reply-To: <20170801214038.sp4lw6lrnl3votte-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Peter.

On Tue, Aug 01, 2017 at 11:40:38PM +0200, Peter Zijlstra wrote:
> > * On cgroup2, there is only one hierarchy.  It'd be great to have
> >   basic resource accounting enabled by default on all cgroups.  Note
> >   that we couldn't do that on v1 because there could be any number of
> >   hierarchies and the cost would increase with the number of
> >   hierarchies.
> 
> Yes, the whole single hierarchy thing makes doing away with the double
> accounting possible.

Yeah, we can either do that or make it cheaper so that we can have
basic stats by default.

> > * It is bothersome that we're walking up the tree each time for
> >   cpuacct although being percpu && just walking up the tree makes it
> >   relatively cheap.
> 
> So even if its only CPU local accounting, you still have all the pointer
> chasing and misses, not to mention that a faster O(depth) is still
> O(depth).
> 
> >		Anyways, I'm thinking about shifting the
> >   aggregation to the reader side so that the hot path always only
> >   updates local counters in a way which can scale even when there are
> >   a lot of (idle) cgroups.  Will follow up on this later.
> 
> Not entirely sure I follow, we currently only update the current cgroup
> and its immediate parents, no? Or are you looking to only account into
> the current cgroup and propagate into the parents on reading?

Yeah, shifting the cost to the readers and being smart with
propagation so that reading isn't O(nr_descendants) but
O(nr_descendants_which_have_run_since_last_read).  That way, we can
show the basic stats without taxing the hot paths with reasonable
scalability.

I have a couple questions about cpuacct tho.

* The stat file is sampling based and the usage files are calculated
  from actual scheduling events.  Is this because the latter is more
  accurate?

* Why do we have user/sys breakdown in usage numbers?  It tries to
  distinguish user or sys by looking at task_pt_regs().  I can't see
  how this would work (e.g. interrupt handlers never schedule) and w/o
  kernel preemption, the sys part is always zero.  What is this number
  supposed to mean?

Thanks.

-- 
tejun

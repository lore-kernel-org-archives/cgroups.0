From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 2 Aug 2017 11:16:00 -0700
Message-ID: <20170802181600.GJ2311718@devbig577.frc2.facebook.com>
References: <20170720184808.1433868-1-tj@kernel.org>
 <20170720184808.1433868-3-tj@kernel.org>
 <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
 <20170801201745.GA2311718@devbig577.frc2.facebook.com>
 <20170801214038.sp4lw6lrnl3votte@hirez.programming.kicks-ass.net>
 <20170802154135.GI2311718@devbig577.frc2.facebook.com>
 <20170802160511.cb7yl65t4nmctf3y@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VagTq7wuiC54OxkB9uKcdSP2u5g+EoDeKlAYdbAMJt0=;
        b=AQ2DvVpc2U4UGnSM6F2qUNCagOA8GgIWo0xYg7sPc55y7I+L3MLCO4qw8e1sUWp2Cm
         YmLeSpBYoFA8KNZ786iQU0ZDjiHpYrXfiw2W2qDtWQwbHQejO+uGe72dRk5HI4KgWUHK
         /+Y2HUJ4lk17JisE5W6ZFw4OzwUXYU+RqiJ1nu2qbfJWzMDDIDLP2kpXNwJVjwZcahMc
         1UBF+/r93LDp0aBuk9HXS/KBcNl3P23CM7SLX2qVuFikXsReNThzeQRBbhInzAnKV9RT
         2pKOnEyBS5+iEdt/KbmDrIqKCtxDe/CLn8VzJ4D9GKzr9z2PI/JNEvDlEHY+lpLxS5x3
         RaWg==
Content-Disposition: inline
In-Reply-To: <20170802160511.cb7yl65t4nmctf3y@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Peter.

On Wed, Aug 02, 2017 at 06:05:11PM +0200, Peter Zijlstra wrote:
> > * The stat file is sampling based and the usage files are calculated
> >   from actual scheduling events.  Is this because the latter is more
> >   accurate?
> 
> So I actually don't know the history of this stuff too well. But I would
> think so. This all looks rather dodgy.

I see.

> > * Why do we have user/sys breakdown in usage numbers?  It tries to
> >   distinguish user or sys by looking at task_pt_regs().  I can't see
> >   how this would work (e.g. interrupt handlers never schedule) and w/o
> >   kernel preemption, the sys part is always zero.  What is this number
> >   supposed to mean?
> 
> For normal scheduler stuff we account the total runtime in ns and use
> the user/kernel tick samples to divide it into user/kernel time parts.
> See cputime_adjust().
> 
> But looking at the cpuacct I have no clue, that looks wonky at best.
> 
> Ideally we'd reuse the normal cputime code and do the same thing
> per-cgroup, but clearly that isn't happening now.
> 
> I never really looked further than that cpuacct_charge() doing _another_
> cgroup iteration, even though we already account that delta to each
> cgroup (modulo scheduling class crud).

Yeah, it's kinda silly.  I'll see if I can just kill cpuacct for
cgroup2.

Thanks.

-- 
tejun

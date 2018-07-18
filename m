From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 18:36:44 -0400
Message-ID: <20180718223644.GH2838@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mdcasbT5nuYq6T0zUYdhs6kUC62eS5unO9iAl6OFIhg=;
        b=jVXcicgSqZHNrhICIqsWLnHN4/6/aFMac/r4iWo5HSuaRFGbFNvUHNLOU4Os+p/OSj
         15tedgLd5o4vIEn490auASvCe1n6fLh8zndQz1R3c8NmVkXzLYW0zgralbYxLx3uBuA5
         /OemkmXuvCOje1koOHZmEsFOrmoQQvHEo153dj5nulnfsCrecnhsJf69CGWbZSJVbfXP
         +fLXGoyrPnl9eAWjU5Phl/M6bdyMAvG1Irkj8tPOIH+QiytLcXUw3SzW4pi6APL9p7ks
         S9SdBH4ZNBJc/TOBxBLSSW6z5ZHQ4zdNrrNNDkylfyDscem/vJhbHq5qsovl0F4m9TRJ
         5i0w==
Content-Disposition: inline
In-Reply-To: <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Jul 18, 2018 at 02:03:18PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > +	/* Time in which tasks wait for the CPU */
> > +	state = PSI_NONE;
> > +	if (tasks[NR_RUNNING] > 1)
> > +		state = PSI_SOME;
> > +	time_state(&groupc->res[PSI_CPU], state, now);
> > +
> > +	/* Time in which tasks wait for memory */
> > +	state = PSI_NONE;
> > +	if (tasks[NR_MEMSTALL]) {
> > +		if (!tasks[NR_RUNNING] ||
> > +		    (cpu_curr(cpu)->flags & PF_MEMSTALL))
> 
> I'm confused, why do we care if the current tasks is MEMSTALL or not?

We want to know whether we're losing CPU potential because of a lack
of memory. That can happen when the task waits for refaults and the
CPU goes idle, but it can also happen when the CPU is performing
reclaim.

If the task waits for refaults and something else is runnable, we're
not losing CPU potential. But if the task performs reclaim and uses
the CPU, nothing else can do productive work on that CPU.

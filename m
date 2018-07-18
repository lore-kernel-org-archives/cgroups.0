From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 09:56:33 -0400
Message-ID: <20180718135633.GA5161@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180718124627.GD2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fKRmFfiEiZawB24hwn9VgULRzC8ly5fwSmN5hO/0hnw=;
        b=iolCabrzZ6IAESM5i/NqGGjIZOFoWftAGvno24p4cp2dcg6SEwDBOR0UbIY8mkuMiM
         6tdq+jSmUfD/mGI0oJk/+rPVp/34yGUrenHYrUAL/XgX0i0HQEqASZL45j3iXGzaIzkd
         s2K6SzOt+UnIv2phYgQ801kc5u5hrwMxrbt2F535LELTbI8Ou24+vR4a7hvP2SPszzMt
         7SA9d0nxdZ+gO4/VlExRfPpsWrlTon1GYtbOa4PrAroFjZ0Yw1GMcjNRMzt19jKjLB8+
         0ygHeVIu/Q6liif+phbUpp8WpxiIaNUPbEPuqnWl0/38xYuC7ne282mTok3xIc1kHZ8p
         /WlA==
Content-Disposition: inline
In-Reply-To: <20180718124627.GD2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi Peter,

thanks for the feedback so far, I'll get to the other emails
later. I'm currently running A/B tests against our production traffic
to get uptodate numbers in particular on the optimizations you
suggested for the cacheline packing, time_state(), ffs() etc.

On Wed, Jul 18, 2018 at 02:46:27PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> 
> > +static inline void psi_enqueue(struct task_struct *p, u64 now, bool wakeup)
> > +{
> > +	int clear = 0, set = TSK_RUNNING;
> > +
> > +	if (psi_disabled)
> > +		return;
> > +
> > +	if (!wakeup || p->sched_psi_wake_requeue) {
> > +		if (p->flags & PF_MEMSTALL)
> > +			set |= TSK_MEMSTALL;
> > +		if (p->sched_psi_wake_requeue)
> > +			p->sched_psi_wake_requeue = 0;
> > +	} else {
> > +		if (p->in_iowait)
> > +			clear |= TSK_IOWAIT;
> > +	}
> > +
> > +	psi_task_change(p, now, clear, set);
> > +}
> > +
> > +static inline void psi_dequeue(struct task_struct *p, u64 now, bool sleep)
> > +{
> > +	int clear = TSK_RUNNING, set = 0;
> > +
> > +	if (psi_disabled)
> > +		return;
> > +
> > +	if (!sleep) {
> > +		if (p->flags & PF_MEMSTALL)
> > +			clear |= TSK_MEMSTALL;
> > +	} else {
> > +		if (p->in_iowait)
> > +			set |= TSK_IOWAIT;
> > +	}
> > +
> > +	psi_task_change(p, now, clear, set);
> > +}
> 
> > +/**
> > + * psi_memstall_enter - mark the beginning of a memory stall section
> > + * @flags: flags to handle nested sections
> > + *
> > + * Marks the calling task as being stalled due to a lack of memory,
> > + * such as waiting for a refault or performing reclaim.
> > + */
> > +void psi_memstall_enter(unsigned long *flags)
> > +{
> > +	struct rq_flags rf;
> > +	struct rq *rq;
> > +
> > +	if (psi_disabled)
> > +		return;
> > +
> > +	*flags = current->flags & PF_MEMSTALL;
> > +	if (*flags)
> > +		return;
> > +	/*
> > +	 * PF_MEMSTALL setting & accounting needs to be atomic wrt
> > +	 * changes to the task's scheduling state, otherwise we can
> > +	 * race with CPU migration.
> > +	 */
> > +	rq = this_rq_lock_irq(&rf);
> > +
> > +	update_rq_clock(rq);
> > +
> > +	current->flags |= PF_MEMSTALL;
> > +	psi_task_change(current, rq_clock(rq), 0, TSK_MEMSTALL);
> > +
> > +	rq_unlock_irq(rq, &rf);
> > +}
> 
> I'm confused by this whole MEMSTALL thing... I thought the idea was to
> account the time we were _blocked_ because of memstall, but you seem to
> count the time we're _running_ with PF_MEMSTALL.

Under heavy memory pressure, a lot of active CPU time is spent
scanning and rotating through the LRU lists, which we do want to
capture in the pressure metric. What we really want to know is the
time in which CPU potential goes to waste due to a lack of
resources. That's the CPU going idle due to a memstall, but it's also
a CPU doing *work* which only occurs due to a lack of memory. We want
to know about both to judge how productive system and workload are.

> And esp. the wait_on_page_bit_common caller seems performance sensitive,
> and the above function is quite expensive.

Right, but we don't call it on every invocation, only when waiting for
the IO to read back a page that was recently deactivated and evicted:

	if (bit_nr == PG_locked &&
	    !PageUptodate(page) && PageWorkingset(page)) {
		if (!PageSwapBacked(page))
			delayacct_thrashing_start();
		psi_memstall_enter(&pflags);
		thrashing = true;
	}

That means the page cache workingset/file active list is thrashing, in
which case the IO itself is our biggest concern, not necessarily a few
additional cycles before going to sleep to wait on its completion.

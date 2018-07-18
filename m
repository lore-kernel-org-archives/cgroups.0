From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 14:46:27 +0200
Message-ID: <20180718124627.GD2476@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=G1CeSVNRSs9e+uLfff8rjLTQr0i13eyHf/GBu+Hp1rg=; b=TlKvUjn1O2j9/9jkG36/vJFJ7
        3auHwldptvotgxfSvP16t8FJDRBijLbCwIIYiwOXKzYdc8kayKPCjFBJCcbo4Ye1bpH8LljqpYr9Y
        IOn3sAxGaJdxT7N9ZAMx8cF66ySuPjNES7SapNySqf13fHAKp5GW0Dc9VAgk+W9Ss7kX1/GqWFHqQ
        cbwGGPZkv64Bo3PUw+PkIOrZ/4Z3gOeSRhgiJ0NBqUgWoFq56bZye/zGyl+h4T4nRd8hwcnOA+aaE
        dSLDgGdRKaG6eeT8XRPLAxodJ7aZn4iiDeb323ltaW5wZdOapR+NfP8RpxI0YXQqwTbI8NgOtmuc+
      
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:

> +static inline void psi_enqueue(struct task_struct *p, u64 now, bool wakeup)
> +{
> +	int clear = 0, set = TSK_RUNNING;
> +
> +	if (psi_disabled)
> +		return;
> +
> +	if (!wakeup || p->sched_psi_wake_requeue) {
> +		if (p->flags & PF_MEMSTALL)
> +			set |= TSK_MEMSTALL;
> +		if (p->sched_psi_wake_requeue)
> +			p->sched_psi_wake_requeue = 0;
> +	} else {
> +		if (p->in_iowait)
> +			clear |= TSK_IOWAIT;
> +	}
> +
> +	psi_task_change(p, now, clear, set);
> +}
> +
> +static inline void psi_dequeue(struct task_struct *p, u64 now, bool sleep)
> +{
> +	int clear = TSK_RUNNING, set = 0;
> +
> +	if (psi_disabled)
> +		return;
> +
> +	if (!sleep) {
> +		if (p->flags & PF_MEMSTALL)
> +			clear |= TSK_MEMSTALL;
> +	} else {
> +		if (p->in_iowait)
> +			set |= TSK_IOWAIT;
> +	}
> +
> +	psi_task_change(p, now, clear, set);
> +}

> +/**
> + * psi_memstall_enter - mark the beginning of a memory stall section
> + * @flags: flags to handle nested sections
> + *
> + * Marks the calling task as being stalled due to a lack of memory,
> + * such as waiting for a refault or performing reclaim.
> + */
> +void psi_memstall_enter(unsigned long *flags)
> +{
> +	struct rq_flags rf;
> +	struct rq *rq;
> +
> +	if (psi_disabled)
> +		return;
> +
> +	*flags = current->flags & PF_MEMSTALL;
> +	if (*flags)
> +		return;
> +	/*
> +	 * PF_MEMSTALL setting & accounting needs to be atomic wrt
> +	 * changes to the task's scheduling state, otherwise we can
> +	 * race with CPU migration.
> +	 */
> +	rq = this_rq_lock_irq(&rf);
> +
> +	update_rq_clock(rq);
> +
> +	current->flags |= PF_MEMSTALL;
> +	psi_task_change(current, rq_clock(rq), 0, TSK_MEMSTALL);
> +
> +	rq_unlock_irq(rq, &rf);
> +}

I'm confused by this whole MEMSTALL thing... I thought the idea was to
account the time we were _blocked_ because of memstall, but you seem to
count the time we're _running_ with PF_MEMSTALL.


And esp. the wait_on_page_bit_common caller seems performance sensitive,
and the above function is quite expensive.



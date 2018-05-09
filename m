From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 9 May 2018 12:21:00 +0200
Message-ID: <20180509102100.GN12217@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yXw5wGWgNbTksMl0p2Ca+JTi6iz3wulrrSaIORPjtJs=; b=kw/E4VsO00CgF0l0htO+1Kgny
        LyDqanH2BH2E5/FQ1HgbGjhtj1KeSaDCvbrQ2uAZFYY52p5SLR82qgfXdnlcfWsENErL22rqQ+cGo
        byWptRBo6mQD55S12K48lUm9FMc5kb7TSksNbpMsIEz1NkJ50Suz4EamUGpJZQXzGFQB4bktXuUMJ
        L34LYoF0JaCZ5Jt0KqilPoP8NRZs+gv4jDdzhB1yoVbYnBTTb3wWBkg8Ms+T1ZKpJsRLRoOh/gSKf
        E6Q/FadzCB0RiKz3xIGK1VD/q9Kfc74iy8xCwK+s23HS++jHpLesLl/7D+qRXUy6bdoWwicr73MAX
    
Content-Disposition: inline
In-Reply-To: <20180507210135.1823-7-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 07, 2018 at 05:01:34PM -0400, Johannes Weiner wrote:
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
> +	*flags = current->flags & PF_MEMSTALL;
> +	if (*flags)
> +		return;
> +	/*
> +	 * PF_MEMSTALL setting & accounting needs to be atomic wrt
> +	 * changes to the task's scheduling state, otherwise we can
> +	 * race with CPU migration.
> +	 */
> +	local_irq_disable();
> +	rq = this_rq();
> +	raw_spin_lock(&rq->lock);
> +	rq_pin_lock(rq, &rf);

Given that churn in sched.h, you seen rq_lock() and friends.

Either write this like:

	local_irq_disable();
	rq = this_rq();
	rq_lock(rq, &rf);

Or instroduce "rq = this_rq_lock_irq()", which we could also use in
do_sched_yield().

> +	update_rq_clock(rq);
> +
> +	current->flags |= PF_MEMSTALL;
> +	psi_task_change(current, rq_clock(rq), 0, TSK_MEMSTALL);
> +
> +	rq_unpin_lock(rq, &rf);
> +	raw_spin_unlock(&rq->lock);
> +	local_irq_enable();

That's called rq_unlock_irq().

> +}
> +
> +/**
> + * psi_memstall_leave - mark the end of an memory stall section
> + * @flags: flags to handle nested memdelay sections
> + *
> + * Marks the calling task as no longer stalled due to lack of memory.
> + */
> +void psi_memstall_leave(unsigned long *flags)
> +{
> +	struct rq_flags rf;
> +	struct rq *rq;
> +
> +	if (*flags)
> +		return;
> +	/*
> +	 * PF_MEMSTALL clearing & accounting needs to be atomic wrt
> +	 * changes to the task's scheduling state, otherwise we could
> +	 * race with CPU migration.
> +	 */
> +	local_irq_disable();
> +	rq = this_rq();
> +	raw_spin_lock(&rq->lock);
> +	rq_pin_lock(rq, &rf);
> +
> +	update_rq_clock(rq);
> +
> +	current->flags &= ~PF_MEMSTALL;
> +	psi_task_change(current, rq_clock(rq), TSK_MEMSTALL, 0);
> +
> +	rq_unpin_lock(rq, &rf);
> +	raw_spin_unlock(&rq->lock);
> +	local_irq_enable();
> +}

Idem.



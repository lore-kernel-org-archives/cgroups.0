From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 3 Aug 2018 19:21:39 +0200
Message-ID: <20180803172139.GE2494@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/7zcp47e6Ydd4cZN9LQW18xrO4SGF+ktz9zrchZXPTw=; b=IC0ceDxaj3PSNtMTXsAaOk1M9
        QEtga76/juR42zvAw8YxOerG0K+uYK2ow40CGzi1YhW5SewN0LagB8Dfwz2LWm9Btlztd4040Zpl6
        u0/ODDUHaxsv2ONZgj7/zbIBDGXO1qRD5kDu5ruoTk/wjutwUf0TfDR3kxkYUjYrrFVGfQObFkuFs
        WSVr6hJyDuwr3bq6lDxduvs9KjgJq2oX76ZRgr8aiwsQg75b2NvkOHRn30bcFRwPnZQCUh1tkPUs0
        MdNVE0Edk8oQuZyCVZHkWoqr7+K1hAYuXDzvw1kTkP2wUeiYZve62Gb2b7CUiY31wKu+X/8iGWQKM
    
Content-Disposition: inline
In-Reply-To: <20180801151958.32590-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> +			time = READ_ONCE(groupc->times[s]);
> +			/*
> +			 * In addition to already concluded states, we
> +			 * also incorporate currently active states on
> +			 * the CPU, since states may last for many
> +			 * sampling periods.
> +			 *
> +			 * This way we keep our delta sampling buckets
> +			 * small (u32) and our reported pressure close
> +			 * to what's actually happening.
> +			 */
> +			if (test_state(groupc->tasks, cpu, s)) {
> +				/*
> +				 * We can race with a state change and
> +				 * need to make sure the state_start
> +				 * update is ordered against the
> +				 * updates to the live state and the
> +				 * time buckets (groupc->times).
> +				 *
> +				 * 1. If we observe task state that
> +				 * needs to be recorded, make sure we
> +				 * see state_start from when that
> +				 * state went into effect or we'll
> +				 * count time from the previous state.
> +				 *
> +				 * 2. If the time delta has already
> +				 * been added to the bucket, make sure
> +				 * we don't see it in state_start or
> +				 * we'll count it twice.
> +				 *
> +				 * If the time delta is out of
> +				 * state_start but not in the time
> +				 * bucket yet, we'll miss it entirely
> +				 * and handle it in the next period.
> +				 */
> +				smp_rmb();
> +				time += cpu_clock(cpu) - groupc->state_start;
> +			}

As is, groupc->state_start needs a READ_ONCE() above and a WRITE_ONCE()
below. But like stated earlier, doing an update in scheduler_tick() is
probably easier.

> +static void psi_group_change(struct psi_group *group, int cpu, u64 now,
> +			     unsigned int clear, unsigned int set)
> +{
> +	struct psi_group_cpu *groupc;
> +	unsigned int t, m;
> +	u32 delta;
> +
> +	groupc = per_cpu_ptr(group->pcpu, cpu);
> +
> +	/*
> +	 * First we assess the aggregate resource states these CPU's
> +	 * tasks have been in since the last change, and account any
> +	 * SOME and FULL time that may have resulted in.
> +	 *
> +	 * Then we update the task counts according to the state
> +	 * change requested through the @clear and @set bits.
> +	 */
> +
> +	delta = now - groupc->state_start;
> +	groupc->state_start = now;
> +
> +	/*
> +	 * Update state_start before recording time in the sampling
> +	 * buckets and changing task counts, to prevent a racing
> +	 * aggregation from counting the delta twice or attributing it
> +	 * to an old state.
> +	 */
> +	smp_wmb();
> +
> +	if (test_state(groupc->tasks, cpu, PSI_IO_SOME)) {
> +		groupc->times[PSI_IO_SOME] += delta;
> +		if (test_state(groupc->tasks, cpu, PSI_IO_FULL))
> +			groupc->times[PSI_IO_FULL] += delta;
> +	}
> +	if (test_state(groupc->tasks, cpu, PSI_MEM_SOME)) {
> +		groupc->times[PSI_MEM_SOME] += delta;
> +		if (test_state(groupc->tasks, cpu, PSI_MEM_FULL))
> +			groupc->times[PSI_MEM_FULL] += delta;
> +	}

Might we worth checking the compiler does the right thing here and
optimizes this branch fest into something sensible.

> +	if (test_state(groupc->tasks, cpu, PSI_CPU_SOME))
> +		groupc->times[PSI_CPU_SOME] += delta;
> +	if (test_state(groupc->tasks, cpu, PSI_NONIDLE))
> +		groupc->times[PSI_NONIDLE] += delta;


From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 3 Aug 2018 18:56:41 +0200
Message-ID: <20180803165641.GA2476@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=us6WDSBVfFK9MXOUFs3re4B3d5LTNqnZtZ8/cNrTON0=; b=o/b8HnvqHg/3a8NSDjpfeR3LB
        /uBc0NQBp0ceNu55U83fcxvbvX7cBRgZzMAJF1xLPFzGPB86WdPEyQjU4lc8vOGheZdOeF4YLaIJB
        JTPgOoS7GxtP76Z4pCjQpaOOrrlYlYQkxWxtMboBpVCflApu2EaRBdy1KB7j6KzbYjEw4+rEf7V8/
        gMq528JYuxk9zJdHZEB0BgMjJHOEbjhd1fj0WhqspwqI68AyY8MYLiV/jPm5vkhOqzhEOSYlSxB8P
        /L3uei7haPxqrWVytdNq3f8IGAABe4YzYSDyDZy6Rq5BX7+UKNijeydqOoAnmddo9riTO9vVCdrve
      
Content-Disposition: inline
In-Reply-To: <20180801151958.32590-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> +static bool test_state(unsigned int *tasks, int cpu, enum psi_states state)
> +{
> +	switch (state) {
> +	case PSI_IO_SOME:
> +		return tasks[NR_IOWAIT];
> +	case PSI_IO_FULL:
> +		return tasks[NR_IOWAIT] && !tasks[NR_RUNNING];
> +	case PSI_MEM_SOME:
> +		return tasks[NR_MEMSTALL];
> +	case PSI_MEM_FULL:
> +		/*
> +		 * Since we care about lost potential, things are
> +		 * fully blocked on memory when there are no other
> +		 * working tasks, but also when the CPU is actively
> +		 * being used by a reclaimer and nothing productive
> +		 * could run even if it were runnable.
> +		 */
> +		return tasks[NR_MEMSTALL] &&
> +			(!tasks[NR_RUNNING] ||
> +			 cpu_curr(cpu)->flags & PF_MEMSTALL);

I don't think you can do this, there is nothing that guarantees
cpu_curr() still exists.

> +	case PSI_CPU_SOME:
> +		return tasks[NR_RUNNING] > 1;
> +	case PSI_NONIDLE:
> +		return tasks[NR_IOWAIT] || tasks[NR_MEMSTALL] ||
> +			tasks[NR_RUNNING];
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool psi_update_stats(struct psi_group *group)
> +{
> +	u64 deltas[NR_PSI_STATES - 1] = { 0, };
> +	unsigned long missed_periods = 0;
> +	unsigned long nonidle_total = 0;
> +	u64 now, expires, period;
> +	int cpu;
> +	int s;
> +
> +	mutex_lock(&group->stat_lock);
> +
> +	/*
> +	 * Collect the per-cpu time buckets and average them into a
> +	 * single time sample that is normalized to wallclock time.
> +	 *
> +	 * For averaging, each CPU is weighted by its non-idle time in
> +	 * the sampling period. This eliminates artifacts from uneven
> +	 * loading, or even entirely idle CPUs.
> +	 *
> +	 * We don't need to synchronize against CPU hotplugging. If we
> +	 * see a CPU that's online and has samples, we incorporate it.
> +	 */
> +	for_each_online_cpu(cpu) {
> +		struct psi_group_cpu *groupc = per_cpu_ptr(group->pcpu, cpu);
> +		u32 uninitialized_var(nonidle);

urgh.. I can see why the compiler got confused. Dodgy :-)

> +
> +		BUILD_BUG_ON(PSI_NONIDLE != NR_PSI_STATES - 1);
> +
> +		for (s = PSI_NONIDLE; s >= 0; s--) {
> +			u32 time, delta;
> +
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

The alternative is adding an update to scheduler_tick(), that would
ensure you're never more than nr_cpu_ids * TICK_NSEC behind.

> +			delta = time - groupc->times_prev[s];
> +			groupc->times_prev[s] = time;
> +
> +			if (s == PSI_NONIDLE) {
> +				nonidle = nsecs_to_jiffies(delta);
> +				nonidle_total += nonidle;
> +			} else {
> +				deltas[s] += (u64)delta * nonidle;
> +			}
> +		}
> +	}

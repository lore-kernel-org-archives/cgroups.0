From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Tue, 17 Jul 2018 12:03:47 +0200
Message-ID: <20180717100347.GD2494@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iXNnyF2ef2ZgbJomMol+/cweHoUkF/XCw3sPJXTZ2R4=; b=Hik9ZahreQ2sr0HCHcXj5f+3L
        0ddtuhzzkZccZTR88SQVLdALCJNildsXLwTCHP60RBngAlJm+EZByVl+AMe9NqL4gUBujykYzKBt+
        ThEL/uK38aDGcrSqmvbK1S4mpMnrbvhLiOWPX+rt06J8JbMk6bEnePgmMsOOuCxE00PU6WK//laRG
        GYtlLmXJkSXxAKHDrdmPeZXC/MI4u1sIpnZgK4NLuS5N8NHGowgBiftKufUSyMEG8cPiVJvK6i8oz
        Vj+9EJA5nAvdGOfo/YbQkCK4tW3Js4G2HpUDVVI20MY3KWqH1uhftuTPMtFEDahPzKnWxBTqO9soZ
    
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> +static void time_state(struct psi_resource *res, int state, u64 now)
> +{
> +	if (res->state != PSI_NONE) {
> +		bool was_full = res->state == PSI_FULL;
> +
> +		res->times[was_full] += now - res->state_start;
> +	}
> +	if (res->state != state)
> +		res->state = state;
> +	if (res->state != PSI_NONE)
> +		res->state_start = now;
> +}
> +
> +static void psi_group_change(struct psi_group *group, int cpu, u64 now,
> +			     unsigned int clear, unsigned int set)
> +{
> +	enum psi_state state = PSI_NONE;
> +	struct psi_group_cpu *groupc;
> +	unsigned int *tasks;
> +	unsigned int to, bo;
> +
> +	groupc = per_cpu_ptr(group->cpus, cpu);
> +	tasks = groupc->tasks;
> +
> +	/* Update task counts according to the set/clear bitmasks */
> +	for (to = 0; (bo = ffs(clear)); to += bo, clear >>= bo) {
> +		int idx = to + (bo - 1);
> +
> +		if (tasks[idx] == 0 && !psi_bug) {
> +			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d idx=%d tasks=[%u %u %u] clear=%x set=%x\n",
> +					cpu, idx, tasks[0], tasks[1], tasks[2],
> +					clear, set);
> +			psi_bug = 1;
> +		}
> +		tasks[idx]--;
> +	}
> +	for (to = 0; (bo = ffs(set)); to += bo, set >>= bo)
> +		tasks[to + (bo - 1)]++;
> +
> +	/* Time in which tasks wait for the CPU */
> +	state = PSI_NONE;
> +	if (tasks[NR_RUNNING] > 1)
> +		state = PSI_SOME;
> +	time_state(&groupc->res[PSI_CPU], state, now);
> +
> +	/* Time in which tasks wait for memory */
> +	state = PSI_NONE;
> +	if (tasks[NR_MEMSTALL]) {
> +		if (!tasks[NR_RUNNING] ||
> +		    (cpu_curr(cpu)->flags & PF_MEMSTALL))
> +			state = PSI_FULL;
> +		else
> +			state = PSI_SOME;
> +	}
> +	time_state(&groupc->res[PSI_MEM], state, now);
> +
> +	/* Time in which tasks wait for IO */
> +	state = PSI_NONE;
> +	if (tasks[NR_IOWAIT]) {
> +		if (!tasks[NR_RUNNING])
> +			state = PSI_FULL;
> +		else
> +			state = PSI_SOME;
> +	}
> +	time_state(&groupc->res[PSI_IO], state, now);
> +
> +	/* Time in which tasks are non-idle, to weigh the CPU in summaries */
> +	if (groupc->nonidle)
> +		groupc->nonidle_time += now - groupc->nonidle_start;
> +	groupc->nonidle = tasks[NR_RUNNING] ||
> +		tasks[NR_IOWAIT] || tasks[NR_MEMSTALL];
> +	if (groupc->nonidle)
> +		groupc->nonidle_start = now;
> +
> +	/* Kick the stats aggregation worker if it's gone to sleep */
> +	if (!delayed_work_pending(&group->clock_work))
> +		schedule_delayed_work(&group->clock_work, PSI_FREQ);
> +}
> +
> +void psi_task_change(struct task_struct *task, u64 now, int clear, int set)
> +{
> +	int cpu = task_cpu(task);
> +
> +	if (psi_disabled)
> +		return;
> +
> +	if (!task->pid)
> +		return;
> +
> +	if (((task->psi_flags & set) ||
> +	     (task->psi_flags & clear) != clear) &&
> +	    !psi_bug) {
> +		printk_deferred(KERN_ERR "psi: inconsistent task state! task=%d:%s cpu=%d psi_flags=%x clear=%x set=%x\n",
> +				task->pid, task->comm, cpu,
> +				task->psi_flags, clear, set);
> +		psi_bug = 1;
> +	}
> +
> +	task->psi_flags &= ~clear;
> +	task->psi_flags |= set;
> +
> +	psi_group_change(&psi_system, cpu, now, clear, set);
> +}


> +/*
> + * PSI tracks state that persists across sleeps, such as iowaits and
> + * memory stalls. As a result, it has to distinguish between sleeps,
> + * where a task's runnable state changes, and requeues, where a task
> + * and its state are being moved between CPUs and runqueues.
> + */
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

This is still a scary amount of accounting; not to mention you'll be
adding O(cgroup-depth) to this in a later patch.

Where are the performance numbers for all this?

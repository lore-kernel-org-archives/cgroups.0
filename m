From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 9 May 2018 16:33:24 +0530
Message-ID: <87060553-2e09-2e2a-13a2-a91345d6df30@codeaurora.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1525863814;
        bh=+1PXQ9g0qF5G3qCnv2axV1PQvCB16OJwuNa5CXfvpN8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Z3xyJLsJzseo6ovnAdC9b75i3OjZB4G+ShOPqndixpxXVLTiqbDlxoR4SHu760Hzn
         WB/4x+uo2eMIUpSRtQn5O9sWMltBpm2frBPMZUxKL2C3wMAAr6Eo4OoCqWj+oNsCZa
         KDsVxKVcSCp5ZTDt0ZXP8JmHGzySIcp3Tlo1TVm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1525863813;
        bh=+1PXQ9g0qF5G3qCnv2axV1PQvCB16OJwuNa5CXfvpN8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=POeCGKfkO2ESR5cOQQJVtZmkgkviyY7/jNWKv7K5ZiSGQYRbFcFnGbEGQEj3ibRxc
         Yta+4ujahviZ+d4UThV34pItc/i1AhdRWG0+cqExN75LlYILh7ZWS41xE+cB/P7r4f
         evAv04qKnMhSkZwTD6/CkPN5azvI4nuOAdTZKbQE=
In-Reply-To: <20180507210135.1823-7-hannes@cmpxchg.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com


On 5/8/2018 2:31 AM, Johannes Weiner wrote:
> +static void psi_group_update(struct psi_group *group, int cpu, u64 now,
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
> +			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d idx=%d tasks=[%u %u %u %u]\n",
> +					cpu, idx, tasks[0], tasks[1],
> +					tasks[2], tasks[3]);
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

This causes a crash when the work is scheduled before system_wq is up. In my case when the first
schedule was called from kthreadd. And I had to do this to make it work.
if (keventd_up() && !delayed_work_pending(&group->clock_work))

> +		schedule_delayed_work(&group->clock_work, MY_LOAD_FREQ);
> +}
> +
> +void psi_task_change(struct task_struct *task, u64 now, int clear, int set)
> +{
> +	struct cgroup *cgroup, *parent;

unused variables

Thanks,
Vinayak

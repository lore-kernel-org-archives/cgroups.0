From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 10/10] sched/psi: per-cgroup PSI accounting
 disable/re-enable interface
Date: Wed, 24 Aug 2022 05:59:40 -0400
Message-ID: <YwX2jC2UQ/zeY2E8@cmpxchg.org>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-11-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=KDrwIuEhT+5ed/QHPncJMrlSCfotDJCP28NTdWL4Z+8=;
        b=FUdbq4Ey9WfkBGooYh1jtUkdsUaCaWZPuwYV3PkH7QaJ6rIuPi95KEyNjCkcKjaUhs
         pIAD/64crbo5hfuYw7IQnI5SE/VWZojQajcqMjOBLaHqJtPnCBS5+FQay9YxHB2pgLLm
         qMLo5SLvf/bh9qEVLS4tH+aah2FYaseQaxsjwzA62Hu5QnonD+hFcmPFH82kW4mDQaUX
         +ZzYA1UtkfEokBQiNK7TMxkke0mamFuB3H9psq4TU0e95ZwOQc6fBIQL7Fzq/BdOSDP5
         AzyQeD2ztdmWD7M3Eti7MaeFc/MXhS4skbQhVSvgxhgzwUCDIxFluMVEwvKGA1iYeCqm
         FtPw==
Content-Disposition: inline
In-Reply-To: <20220824081829.33748-11-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: tj@kernel.org, mkoutny@suse.com, surenb@google.com, gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Chengming,

Thanks for incorporating all the feedback. I have a few nitpicks
below, but with those considered, please add:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

On Wed, Aug 24, 2022 at 04:18:29PM +0800, Chengming Zhou wrote:
> @@ -5171,12 +5220,19 @@ static struct cftype cgroup_base_files[] = {
>  	{
>  		.name = "irq.pressure",
>  		.flags = CFTYPE_PRESSURE,
> +		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
>  		.seq_show = cgroup_irq_pressure_show,
>  		.write = cgroup_irq_pressure_write,
>  		.poll = cgroup_pressure_poll,
>  		.release = cgroup_pressure_release,
>  	},
>  #endif
> +	{
> +		.name = "cgroup.pressure",
> +		.flags = CFTYPE_PRESSURE,
> +		.seq_show = cgroup_psi_show,
> +		.write = cgroup_psi_write,

To match the naming convention, these should be called
cgroup_pressure_show() and cgroup_pressure_write().

> @@ -745,6 +745,14 @@ static void psi_group_change(struct psi_group *group, int cpu,
>  		if (set & (1 << t))
>  			groupc->tasks[t]++;
>  
> +	if (!group->enabled) {
> +		if (groupc->state_mask & (1 << PSI_NONIDLE))
> +			record_times(groupc, now);

Thanks for the explanation in the other thread, it made sense. But can
you please add a comment to document it? Something like:

	/*
	 * On the first group change after disabling PSI, conclude
	 * the current state and flush its time. This is unlikely
	 * to matter to the user, but aggregation (get_recent_times)
	 * may have already incorporated the live state into times_prev;
	 * avoid a delta sample underflow when PSI is later re-enabled.
	 */

An unlikely() would also make sense on that branch.

> @@ -1081,6 +1092,40 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
>  
>  	task_rq_unlock(rq, task, &rf);
>  }
> +
> +void psi_cgroup_enabled_sync(struct psi_group *group)
> +{
> +	int cpu;
> +
> +	/*
> +	 * After we disable psi_group->enabled, we don't actually
> +	 * stop percpu tasks accounting in each psi_group_cpu,
> +	 * instead only stop test_state() loop, record_times()
> +	 * and averaging worker, see psi_group_change() for details.
> +	 *
> +	 * When disable cgroup PSI, this function has nothing to sync
> +	 * since cgroup pressure files are hidden and percpu psi_group_cpu
> +	 * would see !psi_group->enabled and only do task accounting.
> +	 *
> +	 * When re-enable cgroup PSI, this function use psi_group_change()
> +	 * to get correct state mask from test_state() loop on tasks[],
> +	 * and restart groupc->state_start from now, use .clear = .set = 0
> +	 * here since no task status really changed.
> +	 */
> +	if (!group->enabled)
> +		return;

Thanks for adding the comment, that's helpful.

I think the function would be a tad clearer and self-documenting if
you called it psi_cgroup_restart(), and only call it on enabling.

> +	for_each_possible_cpu(cpu) {
> +		struct rq *rq = cpu_rq(cpu);
> +		struct rq_flags rf;
> +		u64 now;
> +
> +		rq_lock_irq(rq, &rf);
> +		now = cpu_clock(cpu);
> +		psi_group_change(group, cpu, 0, 0, now, true);
> +		rq_unlock_irq(rq, &rf);
> +	}
> +}
>  #endif /* CONFIG_CGROUPS */

Thanks,
Johannes

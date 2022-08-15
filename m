From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Mon, 15 Aug 2022 11:49:55 -0400
Message-ID: <YvprI6ZL8dVWGyBO@cmpxchg.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1Uwpvs6/NyNM8qU91zfSlGe+Ud6fzUb0NOatTEgolZk=;
        b=T/xlXFA4JKiGztHsekPw8KTMm4XUMP+HOrfT13Yh6ODYX53NkbQmoFGB5CqjDeYTkM
         VwOCewIxcBV+lygIzSykbKBc8rbGKJoP5ngplrdtixBz1Zb78YNUmyWm6XburHngBVpC
         vuB7s5tGtR3wMiVWGnpomZ907mC4X6feY6vjvbKZVUvN6o6BtVCZhNTkbKwNqfafrfqh
         ImbX4RLPBJdCo7Pbbu8bvNMEmlY554iv2NTT107xzqha75H8rk9jQMwElmGv1lgZ2Hjs
         Tr0WhaLtkUV9pIaWJrVC0uC5HKxCe0WDHDkXPMg0QgBzJlqZ9k7BEiI1oBXcu++4TSxI
         KfgA==
Content-Disposition: inline
In-Reply-To: <20220808110341.15799-10-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou wrote:
> +static ssize_t cgroup_psi_write(struct kernfs_open_file *of,
> +				char *buf, size_t nbytes, loff_t off)
> +{
> +	ssize_t ret;
> +	int enable;
> +	struct cgroup *cgrp;
> +	struct psi_group *psi;
> +
> +	ret = kstrtoint(strstrip(buf), 0, &enable);
> +	if (ret)
> +		return ret;
> +
> +	if (enable < 0 || enable > 1)
> +		return -ERANGE;
> +
> +	cgrp = cgroup_kn_lock_live(of->kn, false);
> +	if (!cgrp)
> +		return -ENOENT;
> +
> +	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
> +	psi_cgroup_enable(psi, enable);

I think it should also add/remove the pressure files when enabling and
disabling the aggregation, since their contents would be stale and
misleading.

Take a look at cgroup_add_dfl_cftypes() and cgroup_rm_cftypes()

> @@ -5115,6 +5152,12 @@ static struct cftype cgroup_base_files[] = {
>  		.release = cgroup_pressure_release,
>  	},
>  #endif
> +	{
> +		.name = "cgroup.psi",
> +		.flags = CFTYPE_PRESSURE,
> +		.seq_show = cgroup_psi_show,
> +		.write = cgroup_psi_write,
> +	},
>  #endif /* CONFIG_PSI */
>  	{ }	/* terminate */
>  };
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index 58f8092c938f..9df1686ee02d 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -181,6 +181,7 @@ static void group_init(struct psi_group *group)
>  {
>  	int cpu;
>  
> +	group->enabled = true;
>  	for_each_possible_cpu(cpu)
>  		seqcount_init(&per_cpu_ptr(group->pcpu, cpu)->seq);
>  	group->avg_last_update = sched_clock();
> @@ -700,17 +701,16 @@ static void psi_group_change(struct psi_group *group, int cpu,
>  	groupc = per_cpu_ptr(group->pcpu, cpu);
>  
>  	/*
> -	 * First we assess the aggregate resource states this CPU's
> -	 * tasks have been in since the last change, and account any
> -	 * SOME and FULL time these may have resulted in.
> -	 *
> -	 * Then we update the task counts according to the state
> +	 * First we update the task counts according to the state
>  	 * change requested through the @clear and @set bits.
> +	 *
> +	 * Then if the cgroup PSI stats accounting enabled, we
> +	 * assess the aggregate resource states this CPU's tasks
> +	 * have been in since the last change, and account any
> +	 * SOME and FULL time these may have resulted in.
>  	 */
>  	write_seqcount_begin(&groupc->seq);
>  
> -	record_times(groupc, now);
> -
>  	/*
>  	 * Start with TSK_ONCPU, which doesn't have a corresponding
>  	 * task count - it's just a boolean flag directly encoded in
> @@ -750,6 +750,14 @@ static void psi_group_change(struct psi_group *group, int cpu,
>  		if (set & (1 << t))
>  			groupc->tasks[t]++;
>  
> +	if (!group->enabled) {
> +		if (groupc->state_mask & (1 << PSI_NONIDLE))
> +			record_times(groupc, now);

Why record the nonidle time? It's only used for aggregation, which is
stopped as well.

> @@ -1088,6 +1097,23 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
>  
>  	task_rq_unlock(rq, task, &rf);
>  }
> +
> +void psi_cgroup_enable(struct psi_group *group, bool enable)
> +{
> +	struct psi_group_cpu *groupc;
> +	int cpu;
> +	u64 now;
> +
> +	if (group->enabled == enable)
> +		return;
> +	group->enabled = enable;
> +
> +	for_each_possible_cpu(cpu) {
> +		groupc = per_cpu_ptr(group->pcpu, cpu);
> +		now = cpu_clock(cpu);
> +		psi_group_change(group, cpu, 0, 0, now, true);

This loop deserves a comment, IMO.

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 09/10] sched/psi: cache parent psi_group to speed up
 groups iterate
Date: Wed, 24 Aug 2022 06:18:49 -0400
Message-ID: <YwX7CeeRDDAhV3UH@cmpxchg.org>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jYmWHg1umNQmTFAwHrCQ8H6AfC+tenyU3IxwvmYsyvo=;
        b=qfFFRs5A0nr5chGy5gZIGGb4C9QrEEKgXqfyx/fNmBO9DMO56woexl6r1J5hd6xkVl
         pLvfy0VeOa50Wh2l1jUgJ+098USlLXKqbAzbAzuiFxp99NBVU11ZvT/9TWP1SCroYNH6
         dMSlnl7vipOpaSRLvPVYtNwGW3xpuQyDPiH28ME27+igm2RkGKmX+bCJRp7CHYcM8goH
         Is5alYIwsk0mWIwD0OHL3dFsZqWJTnBf4Icxr3tJI7xGMK86gxIky2SAfYL4pMdJTRcq
         YLAzLYn54dy/EiDGWopEFP8angsfSlkFeMAazJLpWM1p7yNgDwORj2l/2sryFuDnhPWe
         9OJA==
Content-Disposition: inline
In-Reply-To: <20220824081829.33748-10-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Chengming,

This looks generally good to me, but I have one comment:

On Wed, Aug 24, 2022 at 04:18:28PM +0800, Chengming Zhou wrote:
> @@ -772,30 +772,18 @@ static void psi_group_change(struct psi_group *group, int cpu,
>  		schedule_delayed_work(&group->avgs_work, PSI_FREQ);
>  }
>  
> -static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> +static inline struct psi_group *task_psi_group(struct task_struct *task)
>  {
> -	if (*iter == &psi_system)
> -		return NULL;
> -
>  #ifdef CONFIG_CGROUPS
> -	if (static_branch_likely(&psi_cgroups_enabled)) {
> -		struct cgroup *cgroup = NULL;
> -
> -		if (!*iter)
> -			cgroup = task->cgroups->dfl_cgrp;
> -		else
> -			cgroup = cgroup_parent(*iter);
> -
> -		if (cgroup && cgroup_parent(cgroup)) {
> -			*iter = cgroup;
> -			return cgroup_psi(cgroup);
> -		}
> -	}
> +	if (static_branch_likely(&psi_cgroups_enabled))
> +		return cgroup_psi(task_dfl_cgroup(task));
>  #endif
> -	*iter = &psi_system;
>  	return &psi_system;
>  }
>  
> +#define for_each_psi_group(group) \
> +	for (; group; group = group->parent)

It would be better to open-code this. It's hiding that it's walking
ancestors, and the name and single parameter suggest it's walking some
global list - not that the parameter is iterator AND starting point.

This makes for particularly obscure code in the discontiguous loops in
psi_task_switch():

	group = task_psi_group(task);
	for_each_psi_group(group)
		if (group == common)
			break;
	/* This looks like a second full loop: */
	for_each_psi_group(group)
		...

>  static void psi_flags_change(struct task_struct *task, int clear, int set)
>  {
>  	if (((task->psi_flags & set) ||
> @@ -815,7 +803,6 @@ void psi_task_change(struct task_struct *task, int clear, int set)
>  {
>  	int cpu = task_cpu(task);
>  	struct psi_group *group;
> -	void *iter = NULL;
>  	u64 now;
>  
>  	if (!task->pid)
> @@ -825,7 +812,8 @@ void psi_task_change(struct task_struct *task, int clear, int set)
>  
>  	now = cpu_clock(cpu);
>  
> -	while ((group = iterate_groups(task, &iter)))
> +	group = task_psi_group(task);
> +	for_each_psi_group(group)
>  		psi_group_change(group, cpu, clear, set, now, true);

task_psi_group() is never NULL, so this should be a do-while loop:

	group = task_psi_group(task);
	do {
		psi_group_change(group, cpu, clear, set, now, true);
	} while ((group = group->parent));

> @@ -834,7 +822,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  {
>  	struct psi_group *group, *common = NULL;
>  	int cpu = task_cpu(prev);
> -	void *iter;
>  	u64 now = cpu_clock(cpu);
>  
>  	if (next->pid) {
> @@ -845,8 +832,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		 * we reach the first common ancestor. Iterate @next's
>  		 * ancestors only until we encounter @prev's ONCPU.
>  		 */
> -		iter = NULL;
> -		while ((group = iterate_groups(next, &iter))) {
> +		group = task_psi_group(next);
> +		for_each_psi_group(group) {

Ditto.

>  			if (per_cpu_ptr(group->pcpu, cpu)->state_mask &
>  			    PSI_ONCPU) {
>  				common = group;
> @@ -887,9 +874,12 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  
>  		psi_flags_change(prev, clear, set);
>  
> -		iter = NULL;
> -		while ((group = iterate_groups(prev, &iter)) && group != common)
> +		group = task_psi_group(prev);
> +		for_each_psi_group(group) {
> +			if (group == common)
> +				break;

Ditto.

>  			psi_group_change(group, cpu, clear, set, now, wake_clock);
> +		}
>  
>  		/*
>  		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
> @@ -897,7 +887,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		 */
>  		if (sleep || unlikely(prev->in_memstall != next->in_memstall)) {
>  			clear &= ~TSK_ONCPU;
> -			for (; group; group = iterate_groups(prev, &iter))
> +			for_each_psi_group(group)
>  				psi_group_change(group, cpu, clear, set, now, wake_clock);

This can stay as is, group may already be NULL here.

> @@ -907,7 +897,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  void psi_account_irqtime(struct task_struct *task, u32 delta)
>  {
>  	int cpu = task_cpu(task);
> -	void *iter = NULL;
>  	struct psi_group *group;
>  	struct psi_group_cpu *groupc;
>  	u64 now;
> @@ -917,7 +906,8 @@ void psi_account_irqtime(struct task_struct *task, u32 delta)
>  
>  	now = cpu_clock(cpu);
>  
> -	while ((group = iterate_groups(task, &iter))) {
> +	group = task_psi_group(task);
> +	for_each_psi_group(group) {
>  		groupc = per_cpu_ptr(group->pcpu, cpu);

do-while again.

With that,
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks!

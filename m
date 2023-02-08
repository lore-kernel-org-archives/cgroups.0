From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Wed, 8 Feb 2023 14:15:12 -0500
Message-ID: <Y+P0wLTdZcOPiKPZ@cmpxchg.org>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-3-ryncsn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lruqI717GEqwSqhIRWVJHYQvXYTXBA2SnOdHTnWZ0Hc=;
        b=IA5Ku2U10160DCh0OY6jBF0v6JMjNFPl5SHCV2Gd8RxQK0iWl+/G70px3kmh/K5Kd0
         vUlYWWHKGnQG4d2DrtJJYAur+MYTJLuj0NpnAntBKLuNo/pVBromJcAe5QL+yZSHIBvg
         DewxvkaQNlcdyWXTPkFsLzDWotOFqaN4TADBCtGxp9TlxoZxWTTWO2W4fsrEqpVfRrsH
         6euXxZuD3zSaRvIQz/3a3I7Dux/WrkpjlMCVroaKO4F5KbvIqrHtaTsmOJ7koysbnRQL
         umlnq7KV3CC0w0dTKMsS8vmPENmTqy3nzNW2hFUo6+Pcz2Qo2EUbGuUE/tbvaYtmNLxA
         62Jw==
Content-Disposition: inline
In-Reply-To: <20230208161654.99556-3-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Thu, Feb 09, 2023 at 12:16:54AM +0800, Kairui Song wrote:
> From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> psi_group->parent has the same hierarchy as the cgroup it's in.
> So just iterate through cgroup instead.
> 
> By adjusting the iteration logic, save some space in psi_group
> struct, and the performance is actually better. I see a measurable
> performance gain using mmtests/perfpipe:
> 
> (AVG of 100 test, ops/sec, the higher the better)
> KVM guest on a i7-9700:
>         psi=0         root cgroup   5 levels of cgroup
> Before: 59221         55352         47821
> After:  60100         56036         50884
> 
> KVM guest on a Ryzen 9 5900HX:
>         psi=0         root cgroup   5 levels of cgroup
> Before: 144566        138919        128888
> After:  145812        139580        133514
> 
> Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Awesome!

A few comments below:

> @@ -858,15 +858,34 @@ static void psi_group_change(struct psi_group *group, int cpu,
>  		schedule_delayed_work(&group->avgs_work, PSI_FREQ);
>  }
>  
> -static inline struct psi_group *task_psi_group(struct task_struct *task)
> +static inline struct psi_group *psi_iter_first(struct task_struct *task, void **iter)

Please name these psi_groups_first() and psi_groups_next().

>  #ifdef CONFIG_CGROUPS
> -	if (static_branch_likely(&psi_cgroups_enabled))
> -		return cgroup_psi(task_dfl_cgroup(task));
> +	if (static_branch_likely(&psi_cgroups_enabled)) {
> +		struct cgroup *cgroup = task_dfl_cgroup(task);
> +
> +		*iter = cgroup_parent(cgroup);
> +		return cgroup_psi(cgroup);
> +	}
>  #endif
>  	return &psi_system;
>  }
>  
> +static inline struct psi_group *psi_iter_next(void **iter)
> +{
> +#ifdef CONFIG_CGROUPS
> +	if (static_branch_likely(&psi_cgroups_enabled)) {
> +		struct cgroup *cgroup = *iter;
> +
> +		if (cgroup) {
> +			*iter = cgroup_parent(cgroup);
> +			return cgroup_psi(cgroup);
> +		}
> +	}
> +#endif
> +	return NULL;
> +}

> @@ -886,6 +905,7 @@ void psi_task_change(struct task_struct *task, int clear, int set)
>  {
>  	int cpu = task_cpu(task);
>  	struct psi_group *group;
> +	void *iter;
>  	u64 now;
>  
>  	if (!task->pid)
> @@ -895,16 +915,17 @@ void psi_task_change(struct task_struct *task, int clear, int set)
>  
>  	now = cpu_clock(cpu);
>  
> -	group = task_psi_group(task);
> +	group = psi_iter_first(task, &iter);
>  	do {
>  		psi_group_change(group, cpu, clear, set, now, true);
> -	} while ((group = group->parent));
> +	} while ((group = psi_iter_next(&iter)));
>  }
>  
>  void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		     bool sleep)
>  {
>  	struct psi_group *group, *common = NULL;
> +	void *iter;
>  	int cpu = task_cpu(prev);
>  	u64 now = cpu_clock(cpu);

Please add @iter at the end to keep line length sorting.

> @@ -915,7 +936,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		 * ancestors with @prev, those will already have @prev's
>  		 * TSK_ONCPU bit set, and we can stop the iteration there.
>  		 */
> -		group = task_psi_group(next);
> +		group = psi_iter_first(prev, &iter);
>  		do {
>  			if (per_cpu_ptr(group->pcpu, cpu)->state_mask &
>  			    PSI_ONCPU) {
> @@ -924,7 +945,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  			}
>  
>  			psi_group_change(group, cpu, 0, TSK_ONCPU, now, true);
> -		} while ((group = group->parent));
> +		} while ((group = psi_iter_next(&iter)));
>  	}
>  
>  	if (prev->pid) {
> @@ -957,12 +978,12 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  
>  		psi_flags_change(prev, clear, set);
>  
> -		group = task_psi_group(prev);
> +		group = psi_iter_first(prev, &iter);
>  		do {
>  			if (group == common)
>  				break;
>  			psi_group_change(group, cpu, clear, set, now, wake_clock);
> -		} while ((group = group->parent));
> +		} while ((group = psi_iter_next(&iter)));
>  
>  		/*
>  		 * TSK_ONCPU is handled up to the common ancestor. If there are
> @@ -972,7 +993,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  		 */
>  		if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
>  			clear &= ~TSK_ONCPU;
> -			for (; group; group = group->parent)
> +			for (; group; group = psi_iter_next(&iter))
>  				psi_group_change(group, cpu, clear, set, now, wake_clock);
>  		}
>  	}
> @@ -983,6 +1004,7 @@ void psi_account_irqtime(struct task_struct *task, u32 delta)
>  {
>  	int cpu = task_cpu(task);
>  	struct psi_group *group;
> +	void *iter;
>  	struct psi_group_cpu *groupc;
>  	u64 now;

Ditto. You can move @groupc in the same patch.

Otherwise, this looks good to me. Please add:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

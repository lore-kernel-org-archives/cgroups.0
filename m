From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Tue, 18 May 2021 20:52:51 +0200
Message-ID: <20210518185251.GI5618@worktop.programming.kicks-ass.net>
References: <20210518020200.1790058-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oSWP8vajmc6Gi5h6aBbsbC+8taP14EjR7xZIHx+2buM=; b=qXZncWhEP2ILcY0hl8axexb1Wq
        A+7qQtZ89fXZpzBeF8z3a6dQluFMortMkxyupWV793d4136Z2Ic52KxLsCadqQ13NvM+tgVZbg3Ub
        9IQ9kD4ZHcrwl/LnPibA8AQctV0b9V9npgVvc5LYJsjDOAjjKM32hZDT0Aa/uchVFT5qPWfulYa5C
        9DGpI/EdJco3CRTDVUI7ARElCTc941jl+d4K9jeRqZVdTKNlQwN2ILFP3InKrGaq8Ab0aOMQ/0EnF
        fOAaeoPDvExwg5QeACwbNy4O2AWLTREb4PCM6ITckSAdW/Z9zQfRhcqLqPrsegYEms24nrDRL3s3S
        oSGDyTKg==;
Content-Disposition: inline
In-Reply-To: <20210518020200.1790058-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Mon, May 17, 2021 at 07:02:00PM -0700, Suren Baghdasaryan wrote:

> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index cc25a3cff41f..4b8e72640ac9 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -148,6 +148,7 @@
>  static int psi_bug __read_mostly;
>  
>  DEFINE_STATIC_KEY_FALSE(psi_disabled);
> +DEFINE_STATIC_KEY_FALSE(psi_cgroups_disabled);

I'm thinking the whole thing will be easier/clearer when you make this:

DEFINE_STATIC_KEY_TRUE(psi_cgroups_enabled);

>  
>  #ifdef CONFIG_PSI_DEFAULT_DISABLED
>  static bool psi_enable;
> @@ -211,6 +212,9 @@ void __init psi_init(void)
>  		return;
>  	}
>  
> +	if (!cgroup_psi_enabled())
> +		static_branch_enable(&psi_cgroups_disabled);

	if (!cgroup_psi_enabled())
		static_branch_disable(&psi_cgroups_enabled);

> +
>  	psi_period = jiffies_to_nsecs(PSI_FREQ);
>  	group_init(&psi_system);
>  }
> @@ -744,23 +748,23 @@ static void psi_group_change(struct psi_group *group, int cpu,
>  
>  static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
>  {
> +	if (*iter == &psi_system)
> +		return NULL;
> +
>  #ifdef CONFIG_CGROUPS
> +	if (!static_branch_likely(&psi_cgroups_disabled)) {

	if (static_branch_likely(&psi_cgroups_enabled)) {

> +		struct cgroup *cgroup = NULL;
>  
> +		if (!*iter)
> +			cgroup = task->cgroups->dfl_cgrp;
> +		else
> +			cgroup = cgroup_parent(*iter);
>  
> +		if (cgroup && cgroup_parent(cgroup)) {
> +			*iter = cgroup;
> +			return cgroup_psi(cgroup);
> +		}
>  	}
>  #endif
>  	*iter = &psi_system;
>  	return &psi_system;

But yes, very nice.

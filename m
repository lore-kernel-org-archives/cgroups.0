From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Mon, 17 May 2021 14:31:02 -0400
Message-ID: <YKK2ZumDWcaGWvBj@cmpxchg.org>
References: <20210513175349.959661-1-surenb@google.com>
 <YJ5iAvqAmIhzJRot@hirez.programming.kicks-ass.net>
 <CAJuCfpHy+MknCepfjx9XYUA1j42Auauv7MFQbt+zOU-tA4gasA@mail.gmail.com>
 <YJ64xHoogrowXTok@hirez.programming.kicks-ass.net>
 <CAJuCfpGkj9HxbkXnYN58JXJp1j6kVkvQhqscnEfjyB5unKg1NQ@mail.gmail.com>
 <CAJuCfpH2X47_3VvfZXs_eWhYDziOh13qdUwcfxPJe=Zg_Nkvqw@mail.gmail.com>
 <CAJuCfpEznCYhjbM+1=dMdEn1J2NVw88M+4AThD99PBKg41RgTw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UIgRSmdq0WSwZaTtDLga+2Wo1ADVfnOj+xZ3R2W4aJE=;
        b=i7yNQh/t5w8KCHFJtkLOXFF/z0IQpwrTuwjqD9dtDYQ2cv3wWZwNmT+5J2eNdbNIsp
         jVc3tBvDnYe7g8TVQ7jB9EgnK+rHhFDzdm6w/+Mev63PyENqwu3wA7uuEDcgno0uUWbV
         pwnNxHmshKit3PlgRbvYerc8maRx/B1pMM85eAr+3yTJHF7ZH3Ws7zj0sfbgs7NzUFnb
         D7yk38tPRufil/zPmCQZyLqyknqyiNzuA+Hr+IUYFCdxIoin1YT3qmOggCDEQoxpgY2W
         Pg6aUbK9WjDk19fq4FplcFRD5XAWKc/hzyhtzryYrhmXdMx19f4cGyXvKyk561xC6+Kr
         LD5A==
Content-Disposition: inline
In-Reply-To: <CAJuCfpEznCYhjbM+1=dMdEn1J2NVw88M+4AThD99PBKg41RgTw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, lizefan.x@bytedance.com, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, mgorman@suse.de, Minchan Kim <minchan@kernel.org>, Jonathan Corbet <corbet@lwn.net>, bristot@redhat.com, "Paul E . McKenney" <paulmck@kernel.org>, rdunlap@infradead.org, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, macro@orcam.me.uk, Viresh Kumar <viresh.kumar@linaro.org>, mike.kravetz@oracle.com, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>

On Sun, May 16, 2021 at 12:52:32PM -0700, Suren Baghdasaryan wrote:
> After reworking the code to add a static key I had to expand the
> #ifdef CONFIG_CGROUPS section, so I think a code refactoring below
> would make sense. It localizes config-specific code and it has the
> same exact code for CONFIG_CGROUPS=n and for
> cgroup_psi_enabled()==false. WDYT?:
> 
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -181,6 +181,7 @@ struct psi_group psi_system = {
>  };
> 
>  static void psi_avgs_work(struct work_struct *work);
> +static void cgroup_iterator_init(void);
> 
>  static void group_init(struct psi_group *group)
>  {
> @@ -211,6 +212,8 @@ void __init psi_init(void)
>                  return;
>          }
> 
> +        cgroup_iterator_init();
> +
>          psi_period = jiffies_to_nsecs(PSI_FREQ);
>          group_init(&psi_system);
>  }
> @@ -742,11 +745,31 @@ static void psi_group_change(struct psi_group
> *group, int cpu,
>                  schedule_delayed_work(&group->avgs_work, PSI_FREQ);
>  }
> 
> -static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> +static inline struct psi_group *sys_group_iterator(struct task_struct *task,
> +                                                   void **iter)
>  {
> +        *iter = &psi_system;
> +        return &psi_system;
> +}
> +
>  #ifdef CONFIG_CGROUPS
> +
> +DEFINE_STATIC_KEY_FALSE(psi_cgroups_disabled);
> +
> +static void cgroup_iterator_init(void)
> +{
> +        if (!cgroup_psi_enabled())
> +                static_branch_enable(&psi_cgroups_disabled);
> +}
> +
> +static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> +{
>          struct cgroup *cgroup = NULL;
> 
> +        /* Skip to psi_system if per-cgroup accounting is disabled */
> +        if (static_branch_unlikely(&psi_cgroups_disabled))
> +                return *iter ? NULL : sys_group_iterator(task, iter);
> +
>          if (!*iter)
>                  cgroup = task->cgroups->dfl_cgrp;

That looks over-engineered. You have to check iter whether cgroups are
enabled or not. Pulling the jump label check up doesn't save anything,
but it ends up duplicating code.

What you had in the beginning was better, it just had the system label
in an unexpected place where it would check iter twice in a row.

The (*iter == &psi_system) check inside the cgroups branch has the
same purpose as the (*iter) check in the else branch. We could
consolidate that by pulling it up front.

If we wrap the entire cgroup iteration block into the static branch,
IMO it becomes a bit clearer as well.

How about this?

static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
{
	if (*iter == &psi_system)
		return NULL;

#ifdef CONFIG_CGROUPS
	if (!static_branch_likely(&psi_cgroups_disabled)) {
		struct cgroup *cgroup = NULL;

		if (!*iter)
			cgroup = task->cgroups->dfl_cgrp;
		else
			cgroup = cgroup_parent(*iter);

		if (cgroup && cgroup_parent(cgroup)) {
			*iter = cgroup;
			return cgroup_psi(cgroup);
		}
	}
#endif

	*iter = &psi_system;
	return &psi_system;
}

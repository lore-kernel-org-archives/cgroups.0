From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] cgroup/cpuset: Free DL BW in case can_attach()
 fails
Date: Wed, 22 Mar 2023 10:48:29 -0400
Message-ID: <0473da14-81ce-74fd-4357-3142af9e3ce9@redhat.com>
References: <20230322135959.1998790-1-dietmar.eggemann@arm.com>
 <20230322135959.1998790-3-dietmar.eggemann@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679496515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nv1rg/DAjDe5KwYu6JClmrs+DeW1EZyujTLakuo+/7c=;
        b=NHt+U/+cn0m6ThoPXphxk7R9QH4seyYdZm84sjUVpYqxMXUYf6EdyWv4SNUKzIyMaQ2HNH
        474U2WRtm7l0mmERxGdXQX5923QBQa+KYRhy3uvbr2lKLMiuOP+tG414PTHhVOLOh4BkI0
        hF5oLIDccZM5GYRdF5OCc0IUr+fMKGI=
Content-Language: en-US
In-Reply-To: <20230322135959.1998790-3-dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luca Abeni <luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Tommaso Cucinotta <tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 3/22/23 09:59, Dietmar Eggemann wrote:
> cpuset_can_attach() can fail. Postpone DL BW allocation until all task
> have been checked. DL BW is not allocated per-task but as a sum over
> all DL tasks migrating.
>
> If multiple controllers are attached to the cgroup next to cuset a
Typo: "cuset" -> "cpuset"
> non-cpuset can_attach() can fail. In this case free DL BW in
> cpuset_cancel_attach().
>
> Finally, update cpuset DL task count (nr_deadline_tasks) only in
> cpuset_attach().
>
> Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
> ---
>   include/linux/sched.h  |  2 +-
>   kernel/cgroup/cpuset.c | 55 ++++++++++++++++++++++++++++++++++++++----
>   kernel/sched/core.c    | 17 ++-----------
>   3 files changed, 53 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 658e997ba057..675ec74469d7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1846,7 +1846,7 @@ current_restore_flags(unsigned long orig_flags, unsigned long flags)
>   }
>   
>   extern int cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
> -extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_effective_cpus);
> +extern int task_can_attach(struct task_struct *p);
>   extern int dl_bw_alloc(int cpu, u64 dl_bw);
>   extern void dl_bw_free(int cpu, u64 dl_bw);
>   #ifdef CONFIG_SMP
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index f46192d2e97e..fdc476eefbed 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -198,6 +198,8 @@ struct cpuset {
>   	 * know when to rebuild associated root domain bandwidth information.
>   	 */
>   	int nr_deadline_tasks;
> +	int nr_migrate_dl_tasks;
> +	u64 sum_migrate_dl_bw;
>   
>   	/* Invalid partition error code, not lock protected */
>   	enum prs_errcode prs_err;
> @@ -2462,16 +2464,23 @@ static int fmeter_getrate(struct fmeter *fmp)
>   
>   static struct cpuset *cpuset_attach_old_cs;
>   
> +static void reset_migrate_dl_data(struct cpuset *cs)
> +{
> +	cs->nr_migrate_dl_tasks = 0;
> +	cs->sum_migrate_dl_bw = 0;
> +}
> +
>   /* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
>   static int cpuset_can_attach(struct cgroup_taskset *tset)
>   {
>   	struct cgroup_subsys_state *css;
> -	struct cpuset *cs;
> +	struct cpuset *cs, *oldcs;
>   	struct task_struct *task;
>   	int ret;
>   
>   	/* used later by cpuset_attach() */
>   	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
> +	oldcs = cpuset_attach_old_cs;
>   	cs = css_cs(css);
>   
>   	mutex_lock(&cpuset_mutex);
> @@ -2489,7 +2498,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   		goto out_unlock;
>   
>   	cgroup_taskset_for_each(task, css, tset) {
> -		ret = task_can_attach(task, cs->effective_cpus);
> +		ret = task_can_attach(task);
>   		if (ret)
>   			goto out_unlock;
>   		ret = security_task_setscheduler(task);
> @@ -2497,11 +2506,31 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   			goto out_unlock;
>   
>   		if (dl_task(task)) {
> -			cs->nr_deadline_tasks++;
> -			cpuset_attach_old_cs->nr_deadline_tasks--;
> +			cs->nr_migrate_dl_tasks++;
> +			cs->sum_migrate_dl_bw += task->dl.dl_bw;
> +		}
> +	}
> +
> +	if (!cs->nr_migrate_dl_tasks)
> +		goto out_succes;
> +
> +	if (!cpumask_intersects(oldcs->effective_cpus, cs->effective_cpus)) {
> +		int cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
> +
> +		if (unlikely(cpu >= nr_cpu_ids)) {
> +			reset_migrate_dl_data(cs);
> +			ret = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
> +		if (ret) {
> +			reset_migrate_dl_data(cs);
> +			goto out_unlock;

I do have a question about just picking any cpu to see if there is 
enough DL bandwidth. What happens if there are multiple DL tasks to be 
migrated and their total bandwidth exceed any one cpu can provide?

Other than that, the overall workflow looks good to me from the cpuset 
point of view.

Cheers,
Longman

>   		}
>   	}
>   
> +out_succes:
>   	/*
>   	 * Mark attach is in progress.  This makes validate_change() fail
>   	 * changes which zero cpus/mems_allowed.
> @@ -2516,11 +2545,21 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   static void cpuset_cancel_attach(struct cgroup_taskset *tset)
>   {
>   	struct cgroup_subsys_state *css;
> +	struct cpuset *cs;
>   
>   	cgroup_taskset_first(tset, &css);
> +	cs = css_cs(css);
>   
>   	mutex_lock(&cpuset_mutex);
> -	css_cs(css)->attach_in_progress--;
> +	cs->attach_in_progress--;
> +
> +	if (cs->nr_migrate_dl_tasks) {
> +		int cpu = cpumask_any(cs->effective_cpus);
> +
> +		dl_bw_free(cpu, cs->sum_migrate_dl_bw);
> +		reset_migrate_dl_data(cs);
> +	}
> +
>   	mutex_unlock(&cpuset_mutex);
>   }
>   
> @@ -2615,6 +2654,12 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>   out:
>   	cs->old_mems_allowed = cpuset_attach_nodemask_to;
>   
> +	if (cs->nr_migrate_dl_tasks) {
> +		cs->nr_deadline_tasks += cs->nr_migrate_dl_tasks;
> +		oldcs->nr_deadline_tasks -= cs->nr_migrate_dl_tasks;
> +		reset_migrate_dl_data(cs);
> +	}
> +
>   	cs->attach_in_progress--;
>   	if (!cs->attach_in_progress)
>   		wake_up(&cpuset_attach_wq);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2f07aecb7434..4fb058b72886 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -9201,8 +9201,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
>   	return ret;
>   }
>   
> -int task_can_attach(struct task_struct *p,
> -		    const struct cpumask *cs_effective_cpus)
> +int task_can_attach(struct task_struct *p)
>   {
>   	int ret = 0;
>   
> @@ -9215,21 +9214,9 @@ int task_can_attach(struct task_struct *p,
>   	 * success of set_cpus_allowed_ptr() on all attached tasks
>   	 * before cpus_mask may be changed.
>   	 */
> -	if (p->flags & PF_NO_SETAFFINITY) {
> +	if (p->flags & PF_NO_SETAFFINITY)
>   		ret = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
> -					      cs_effective_cpus)) {
> -		int cpu = cpumask_any_and(cpu_active_mask, cs_effective_cpus);
>   
> -		if (unlikely(cpu >= nr_cpu_ids))
> -			return -EINVAL;
> -		ret = dl_bw_alloc(cpu, p->dl.dl_bw);
> -	}
> -
> -out:
>   	return ret;
>   }
>   


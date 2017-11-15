From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 15 Nov 2017 15:56:26 +0530
Message-ID: <6f8b194f-05ec-05d4-3df6-e9eadc7f68bf@codeaurora.org>
References: <45cdac2f-4462-e5b5-d724-8cca58e3932a@codeaurora.org>
 <1509347805-23491-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510741595;
        bh=3d6ohSO0F+K5axI9UzYgr7f6DE+rPMH3qTdv2butBbM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QOTvsRLK7tMfmh+rpZ6J3AkDs3LLuYR9PyYFglh7TycA/jVKv+NjQXcye5vHgqnY3
         B3O2NtLNfiJzRKVhng3x6onAgIJGYcmBORyoZdKAPpAmi8G4JSvzSmZnsQAyHTnl8t
         CgYmHBG/3mSJIM6mLiTVVrH5H+xtCeanU52e+guw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510741592;
        bh=3d6ohSO0F+K5axI9UzYgr7f6DE+rPMH3qTdv2butBbM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jU5R7AejQfvqeFrPjJ5ijUq4RFiz2U2OqZ21HAb2p4apE7KQ42+xIRxROUNjLSUIT
         hwcOhmxDb4CDHgdY7h/Ld7QMfrzZonvjeAbJOrZhfpimbs8+CbRwgfdeUWkbPboJiX
         y6T11Xp9CSzNJO+1QYa9DyDJtstHbX5QlUEeMxvY=
In-Reply-To: <1509347805-23491-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/30/2017 12:46 PM, Prateek Sood wrote:
> Remove circular dependency deadlock in a scenario where hotplug of CPU is
> being done while there is updation in cgroup and cpuset triggered from
> userspace.
> 
> Process A => kthreadd => Process B => Process C => Process A
> 
> Process A
> cpu_subsys_offline();
>   cpu_down();
>     _cpu_down();
>       percpu_down_write(&cpu_hotplug_lock); //held
>       cpuhp_invoke_callback();
> 	     workqueue_offline_cpu();
>             queue_work_on(); // unbind_work on system_highpri_wq
>                __queue_work();
>                  insert_work();
>                     wake_up_worker();
>             flush_work();
>                wait_for_completion();
> 
> worker_thread();
>    manage_workers();
>       create_worker();
> 	     kthread_create_on_node();
> 		    wake_up_process(kthreadd_task);
> 
> kthreadd
> kthreadd();
>   kernel_thread();
>     do_fork();
>       copy_process();
>         percpu_down_read(&cgroup_threadgroup_rwsem);
>           __rwsem_down_read_failed_common(); //waiting
> 
> Process B
> kernfs_fop_write();
>   cgroup_file_write();
>     cgroup_procs_write();
>       percpu_down_write(&cgroup_threadgroup_rwsem); //held
>       cgroup_attach_task();
>         cgroup_migrate();
>           cgroup_migrate_execute();
>             cpuset_can_attach();
>               mutex_lock(&cpuset_mutex); //waiting
> 
> Process C
> kernfs_fop_write();
>   cgroup_file_write();
>     cpuset_write_resmask();
>       mutex_lock(&cpuset_mutex); //held
>       update_cpumask();
>         update_cpumasks_hier();
>           rebuild_sched_domains_locked();
>             get_online_cpus();
>               percpu_down_read(&cpu_hotplug_lock); //waiting
> 
> Eliminating deadlock by reversing the locking order for cpuset_mutex and
> cpu_hotplug_lock. After inverting the locking sequence of cpu_hotplug_lock
> and cpuset_mutex, cpuset_hotplug_workfn() related functionality can be
> done synchronously from the context doing cpu hotplug. For memory hotplug
> it still gets queued as a work item.
> 
> Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  include/linux/cpuset.h |  6 ----
>  kernel/cgroup/cpuset.c | 94 +++++++++++++++++++++++++++-----------------------
>  kernel/power/process.c |  2 --
>  kernel/sched/core.c    |  1 -
>  4 files changed, 50 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index a1e6a33..e74655d 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -51,9 +51,7 @@ static inline void cpuset_dec(void)
>  
>  extern int cpuset_init(void);
>  extern void cpuset_init_smp(void);
> -extern void cpuset_force_rebuild(void);
>  extern void cpuset_update_active_cpus(void);
> -extern void cpuset_wait_for_hotplug(void);
>  extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
>  extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
> @@ -166,15 +164,11 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>  static inline int cpuset_init(void) { return 0; }
>  static inline void cpuset_init_smp(void) {}
>  
> -static inline void cpuset_force_rebuild(void) { }
> -
>  static inline void cpuset_update_active_cpus(void)
>  {
>  	partition_sched_domains(1, NULL, NULL);
>  }
>  
> -static inline void cpuset_wait_for_hotplug(void) { }
> -
>  static inline void cpuset_cpus_allowed(struct task_struct *p,
>  				       struct cpumask *mask)
>  {
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 4657e29..ec44aaa 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -817,6 +817,18 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  	return ndoms;
>  }
>  
> +static void cpuset_sched_change_begin(void)
> +{
> +	cpus_read_lock();
> +	mutex_lock(&cpuset_mutex);
> +}
> +
> +static void cpuset_sched_change_end(void)
> +{
> +	mutex_unlock(&cpuset_mutex);
> +	cpus_read_unlock();
> +}
> +
>  /*
>   * Rebuild scheduler domains.
>   *
> @@ -826,16 +838,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
>   * 'cpus' is removed, then call this routine to rebuild the
>   * scheduler's dynamic sched domains.
>   *
> - * Call with cpuset_mutex held.  Takes get_online_cpus().
>   */
> -static void rebuild_sched_domains_locked(void)
> +static void rebuild_sched_domains_cpuslocked(void)
>  {
>  	struct sched_domain_attr *attr;
>  	cpumask_var_t *doms;
>  	int ndoms;
>  
>  	lockdep_assert_held(&cpuset_mutex);
> -	get_online_cpus();
>  
>  	/*
>  	 * We have raced with CPU hotplug. Don't do anything to avoid
> @@ -843,27 +853,25 @@ static void rebuild_sched_domains_locked(void)
>  	 * Anyways, hotplug work item will rebuild sched domains.
>  	 */
>  	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> -		goto out;
> +		return;
>  
>  	/* Generate domain masks and attrs */
>  	ndoms = generate_sched_domains(&doms, &attr);
>  
>  	/* Have scheduler rebuild the domains */
>  	partition_sched_domains(ndoms, doms, attr);
> -out:
> -	put_online_cpus();
>  }
>  #else /* !CONFIG_SMP */
> -static void rebuild_sched_domains_locked(void)
> +static void rebuild_sched_domains_cpuslocked(void)
>  {
>  }
>  #endif /* CONFIG_SMP */
>  
>  void rebuild_sched_domains(void)
>  {
> -	mutex_lock(&cpuset_mutex);
> -	rebuild_sched_domains_locked();
> -	mutex_unlock(&cpuset_mutex);
> +	cpuset_sched_change_begin();
> +	rebuild_sched_domains_cpuslocked();
> +	cpuset_sched_change_end();
>  }
>  
>  /**
> @@ -949,7 +957,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
>  	rcu_read_unlock();
>  
>  	if (need_rebuild_sched_domains)
> -		rebuild_sched_domains_locked();
> +		rebuild_sched_domains_cpuslocked();
>  }
>  
>  /**
> @@ -1281,7 +1289,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
>  		cs->relax_domain_level = val;
>  		if (!cpumask_empty(cs->cpus_allowed) &&
>  		    is_sched_load_balance(cs))
> -			rebuild_sched_domains_locked();
> +			rebuild_sched_domains_cpuslocked();
>  	}
>  
>  	return 0;
> @@ -1314,7 +1322,6 @@ static void update_tasks_flags(struct cpuset *cs)
>   *
>   * Call with cpuset_mutex held.
>   */
> -
>  static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>  		       int turning_on)
>  {
> @@ -1347,7 +1354,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>  	spin_unlock_irq(&callback_lock);
>  
>  	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
> -		rebuild_sched_domains_locked();
> +		rebuild_sched_domains_cpuslocked();
>  
>  	if (spread_flag_changed)
>  		update_tasks_flags(cs);
> @@ -1615,7 +1622,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
>  	cpuset_filetype_t type = cft->private;
>  	int retval = 0;
>  
> -	mutex_lock(&cpuset_mutex);
> +	cpuset_sched_change_begin();
>  	if (!is_cpuset_online(cs)) {
>  		retval = -ENODEV;
>  		goto out_unlock;
> @@ -1651,7 +1658,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
>  		break;
>  	}
>  out_unlock:
> -	mutex_unlock(&cpuset_mutex);
> +	cpuset_sched_change_end();
>  	return retval;
>  }
>  
> @@ -1662,7 +1669,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
>  	cpuset_filetype_t type = cft->private;
>  	int retval = -ENODEV;
>  
> -	mutex_lock(&cpuset_mutex);
> +	cpuset_sched_change_begin();
>  	if (!is_cpuset_online(cs))
>  		goto out_unlock;
>  
> @@ -1675,7 +1682,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
>  		break;
>  	}
>  out_unlock:
> -	mutex_unlock(&cpuset_mutex);
> +	cpuset_sched_change_end();
>  	return retval;
>  }
>  
> @@ -1714,7 +1721,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>  	kernfs_break_active_protection(of->kn);
>  	flush_work(&cpuset_hotplug_work);
>  
> -	mutex_lock(&cpuset_mutex);
> +	cpuset_sched_change_begin();
>  	if (!is_cpuset_online(cs))
>  		goto out_unlock;
>  
> @@ -1738,7 +1745,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>  
>  	free_trial_cpuset(trialcs);
>  out_unlock:
> -	mutex_unlock(&cpuset_mutex);
> +	cpuset_sched_change_end();
>  	kernfs_unbreak_active_protection(of->kn);
>  	css_put(&cs->css);
>  	flush_workqueue(cpuset_migrate_mm_wq);
> @@ -2039,14 +2046,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
>  /*
>   * If the cpuset being removed has its flag 'sched_load_balance'
>   * enabled, then simulate turning sched_load_balance off, which
> - * will call rebuild_sched_domains_locked().
> + * will call rebuild_sched_domains_cpuslocked().
>   */
>  
>  static void cpuset_css_offline(struct cgroup_subsys_state *css)
>  {
>  	struct cpuset *cs = css_cs(css);
>  
> -	mutex_lock(&cpuset_mutex);
> +	cpuset_sched_change_begin();
>  
>  	if (is_sched_load_balance(cs))
>  		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
> @@ -2054,7 +2061,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
>  	cpuset_dec();
>  	clear_bit(CS_ONLINE, &cs->flags);
>  
> -	mutex_unlock(&cpuset_mutex);
> +	cpuset_sched_change_end();
>  }
>  
>  static void cpuset_css_free(struct cgroup_subsys_state *css)
> @@ -2275,15 +2282,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs)
>  	mutex_unlock(&cpuset_mutex);
>  }
>  
> -static bool force_rebuild;
> -
> -void cpuset_force_rebuild(void)
> -{
> -	force_rebuild = true;
> -}
> -
>  /**
> - * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
> + * cpuset_hotplug - handle CPU/memory hotunplug for a cpuset
>   *
>   * This function is called after either CPU or memory configuration has
>   * changed and updates cpuset accordingly.  The top_cpuset is always
> @@ -2298,7 +2298,7 @@ void cpuset_force_rebuild(void)
>   * Note that CPU offlining during suspend is ignored.  We don't modify
>   * cpusets across suspend/resume cycles at all.
>   */
> -static void cpuset_hotplug_workfn(struct work_struct *work)
> +static void cpuset_hotplug(bool use_cpu_hp_lock)
>  {
>  	static cpumask_t new_cpus;
>  	static nodemask_t new_mems;
> @@ -2356,25 +2356,31 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>  	}
>  
>  	/* rebuild sched domains if cpus_allowed has changed */
> -	if (cpus_updated || force_rebuild) {
> -		force_rebuild = false;
> -		rebuild_sched_domains();
> +	if (cpus_updated) {
> +		if (use_cpu_hp_lock)
> +			rebuild_sched_domains();
> +		else {
> +			/* Acquiring cpu_hotplug_lock is not required.
> +			 * When cpuset_hotplug() is called in hotplug path,
> +			 * cpu_hotplug_lock is held by the hotplug context
> +			 * which is waiting for cpuhp_thread_fun to indicate
> +			 * completion of callback.
> +			 */
> +			mutex_lock(&cpuset_mutex);
> +			rebuild_sched_domains_cpuslocked();
> +			mutex_unlock(&cpuset_mutex);
> +		}
>  	}
>  }
>  
> -void cpuset_update_active_cpus(void)
> +static void cpuset_hotplug_workfn(struct work_struct *work)
>  {
> -	/*
> -	 * We're inside cpu hotplug critical region which usually nests
> -	 * inside cgroup synchronization.  Bounce actual hotplug processing
> -	 * to a work item to avoid reverse locking order.
> -	 */
> -	schedule_work(&cpuset_hotplug_work);
> +	cpuset_hotplug(true);
>  }
>  
> -void cpuset_wait_for_hotplug(void)
> +void cpuset_update_active_cpus(void)
>  {
> -	flush_work(&cpuset_hotplug_work);
> +	cpuset_hotplug(false);
>  }
>  
>  /*
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 50f25cb..28772b405 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -203,8 +203,6 @@ void thaw_processes(void)
>  	__usermodehelper_set_disable_depth(UMH_FREEZING);
>  	thaw_workqueues();
>  
> -	cpuset_wait_for_hotplug();
> -
>  	read_lock(&tasklist_lock);
>  	for_each_process_thread(g, p) {
>  		/* No other threads should have PF_SUSPEND_TASK set */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d17c5da..25b8717 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5590,7 +5590,6 @@ static void cpuset_cpu_active(void)
>  		 * restore the original sched domains by considering the
>  		 * cpuset configurations.
>  		 */
> -		cpuset_force_rebuild();
>  	}
>  	cpuset_update_active_cpus();
>  }
> 

Any improvement/suggestion for this patch?

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project

From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 26 Oct 2017 10:05:12 -0400
Message-ID: <dc80ad9d-5b3d-b991-76c8-35630bc139c5@redhat.com>
References: <20171025093041.GO3165@worktop.lehotels.local>
 <1509018722-30359-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509018722-30359-1-git-send-email-prsood@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Prateek Sood <prsood@codeaurora.org>, peterz@infradead.org, tj@kernel.org, lizefan@huawei.com, mingo@kernel.org, boqun.feng@gmail.com, tglx@linutronix.de
Cc: cgroups@vger.kernel.org, sramana@codeaurora.org, linux-kernel@vger.kernel.org

On 10/26/2017 07:52 AM, Prateek Sood wrote:
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
>         workqueue_offline_cpu();
>           wq_update_unbound_numa();
>             kthread_create_on_node();
>               wake_up_process();  //wakeup kthreadd
>           flush_work();
>           wait_for_completion();
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
> cpu_hotplug_lock.

General comments:

Please add a version number of your patch. I have seen multiple versions
of this patch and have lost track how many are there as there is no
version number information.  In addition, there are changes beyond just
swapping the lock order and they are not documented in this change log.
I would like to see you discuss about those additional changes here as well.

>  void rebuild_sched_domains(void)
>  {
> +	cpus_read_lock();
>  	mutex_lock(&cpuset_mutex);
> -	rebuild_sched_domains_locked();
> +	rebuild_sched_domains_cpuslocked();
>  	mutex_unlock(&cpuset_mutex);
> +	cpus_read_unlock();
>  }

I saw a lot of instances where cpus_read_lock() and mutex_lock() come
together. Maybe some new lock/unlock helper functions may help.

> @@ -2356,25 +2354,29 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
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
> +			/* When called during cpu hotplug cpu_hotplug_lock
> +			 * is held by the calling thread, not
> +			 * not cpuhp_thread_fun
> +			 */

??? The comment is not clear.

Cheers,
Longman


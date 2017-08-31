From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] Workqueue lockup: Circular dependency in threads
Date: Thu, 31 Aug 2017 18:43:56 +0530
Message-ID: <bc1016ee-792e-87f8-5158-777b7f9405b8@codeaurora.org>
References: <1504101538-20075-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504185241;
        bh=PNyh0fQSXq6vveCYsJqLTF8NH0rDo/uYegRu5sDy+rs=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=G4zS+LZ8A8cLr+kzTlpjyI4qXvgGY2T71rlu0JvqAbKKhVG4X/qZLASWncmTirT01
         6hhAzNslhnFfnE/4SaoMxFFpzfya0HrSp8ThLAUEZFBf4PkWg8Kok4yp21gbIZsRM2
         RKGV9Kftj6KJiRWCZSwNSfuS1NXiMjdNuS8vOhMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504185241;
        bh=PNyh0fQSXq6vveCYsJqLTF8NH0rDo/uYegRu5sDy+rs=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=G4zS+LZ8A8cLr+kzTlpjyI4qXvgGY2T71rlu0JvqAbKKhVG4X/qZLASWncmTirT01
         6hhAzNslhnFfnE/4SaoMxFFpzfya0HrSp8ThLAUEZFBf4PkWg8Kok4yp21gbIZsRM2
         RKGV9Kftj6KJiRWCZSwNSfuS1NXiMjdNuS8vOhMs=
In-Reply-To: <1504101538-20075-1-git-send-email-prsood@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, sramana@codeaurora.org, mingo@kernel.org, tj@kernel.org, longman@redhat.com, apkm@linux-foundation.org

On 08/30/2017 07:28 PM, Prateek Sood wrote:
> Hi,
> 
> While using Linux version 4.4 on my setup, I have observed a deadlock.
> 
> 1) CPU3 is getting hot plugged from a worker thread(kworker/0:0) on CPU0.
> 2) Cpu hot plug flow needs to flush the work items on hot plugging CPU3,
>    with a high priority worker from the corresponding CPU(cpu3) worker pool.
> 3) There is no high priority worker on CPU3, resulting in creation of worker
>    thread with high priority from create_worker.
> 4) This creation is done by kthreadd, which got stuck while trying to acquire
>    cgroup_threadgroup_rwsem during kernel thread creation.
> 5) Cgroup cgroup_threadgroup_rwsem is acquired by task init:729 and is waiting
>    on cpuset_mutex.
> 6) cpuset_mutex is acquired by task init:1 and is waiting for cpuhotplug lock.
> 7) cpuhotplug lock is acquired by kworker/0:0 while doing hotplug of CPU3
> 
> Circular dependency:
> kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0
> 
> kworker/0:0
> -000|__switch_to()
> -001|context_switch(inline)
> -001|__schedule()
> -002|__preempt_count_sub(inline)
> -002|schedule()
> -003|schedule_timeout()
> -004|do_wait_for_common(inline)
> -004|__wait_for_common(inline)
> -004|wait_for_common()
> -005|wait_for_completion()
> -006|flush_work()
> -007|workqueue_cpu_down_callback()
> -008|notifier_call_chain()
> -009|__raw_notifier_call_chain()
> -010|notifier_to_errno(inline)
> -010|__cpu_notify()
> -011|cpu_down()
> -012|cpu_down()
> -013|cpu_subsys_offline()
> -014|device_offline()
> -015|do_core_control()
> -016|check_temp()
> -017|__read_once_size(inline)
> -017|static_key_count(inline)
> -017|static_key_false(inline)
> -017|trace_workqueue_execute_end(inline)
> -017|process_one_work()
> -018|worker_thread()
> -019|kthread()
> -020|ret_from_fork(asm)
>  ---|end of frame
> 
> kthreadd
> -000|__switch_to()
> -001|context_switch(inline)
> -001|__schedule()
> -002|__preempt_count_sub(inline)
> -002|schedule()
> -003|rwsem_down_read_failed()
> -004|current_thread_info(inline)
> -004|preempt_count_ptr(inline)
> -004|__preempt_count_add(inline)
> -004|__percpu_down_read()
> -005|current_thread_info(inline)
> -005|preempt_count_ptr(inline)
> -005|__preempt_count_dec_and_test(inline)
> -005|percpu_down_read(inline)
> -005|cgroup_threadgroup_change_begin(inline)
> -005|threadgroup_change_begin(inline)
> -005|copy_process.isra.60()
> -006|do_fork()
> -007|kernel_thread()
> -008|create_kthread(inline)
> -008|kthreadd()
> -009|ret_from_fork(asm)
>  ---|end of frame
> 
> init:729
> -000|__switch_to()
> -001|context_switch(inline)
> -001|__schedule()
> -002|__preempt_count_sub(inline)
> -002|schedule()
> -003|__preempt_count_add(inline)
> -003|schedule_preempt_disabled()
> -004|spin_lock(inline)
> -004|__mutex_lock_common(inline)
> -004|__mutex_lock_slowpath()
> -005|current_thread_info(inline)
> -005|mutex_set_owner(inline)
> -005|mutex_lock()
> -006|__read_once_size(inline)
> -006|static_key_count(inline)
> -006|cpuset_can_attach()
> -007|cgroup_taskset_migrate()
> -008|cgroup_migrate()
> -009|cgroup_attach_task()
> -010|__cgroup_procs_write.isra.32()
> -011|cgroup_tasks_write()
> -012|cgroup_file_write()
> -013|kernfs_fop_write()
> -014|__vfs_write()
> -015|vfs_write()
> -016|SYSC_write(inline)
> -016|sys_write()
> -017|el0_svc_naked(asm)
>  -->|exception
> -018|NUX:0x507970(asm)
>  ---|end of frame
> 
> init:1
> -000|__switch_to()
> -001|context_switch(inline)
> -001|__schedule()
> -002|__preempt_count_sub(inline)
> -002|schedule()
> -003|__preempt_count_add(inline)
> -003|schedule_preempt_disabled()
> -004|spin_lock(inline)
> -004|__mutex_lock_common(inline)
> -004|__mutex_lock_slowpath()
> -005|current_thread_info(inline)
> -005|mutex_set_owner(inline)
> -005|mutex_lock()
> -006|atomic_add(inline)
> -006|get_online_cpus()
> -007|rebuild_sched_domains_locked()
> -008|update_cpumask(inline)
> -008|cpuset_write_resmask()
> -009|cgroup_file_write()
> -010|kernfs_fop_write()
> -011|__vfs_write()
> -012|vfs_write()
> -013|SYSC_write(inline)
> -013|sys_write()
> -014|el0_svc_naked(asm)
>  -->|exception
> -015|NUX:0x507970(asm)
>  ---|end of frame
> 
> We can reorder the sequence of locks as in the below diff to avoid this
> deadlock. But I am looking for inputs/better solution to fix this deadlock.
> 
> ---
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>  /**
>   * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
>   * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
> @@ -930,7 +946,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
>  	rcu_read_unlock();
>  
>  	if (need_rebuild_sched_domains)
> -		rebuild_sched_domains_locked();
> +		rebuild_sched_domains_unlocked()(without taking cpuhotplug.lock)
>  }
>  
>  /**
> @@ -1719,6 +1735,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
> +	get_online_cpus();
>  	mutex_lock(&cpuset_mutex);
>  	if (!is_cpuset_online(cs))
>  		goto out_unlock;
> @@ -1744,6 +1761,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>  	mutex_unlock(&cpuset_mutex);
> +	put_online_cpus();
>  	kernfs_unbreak_active_protection(of->kn);
>  	css_put(&cs->css);
>  	flush_workqueue(cpuset_migrate_mm_wq);
> 

++

Adding more folks for suggestion

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project

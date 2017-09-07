From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 7 Sep 2017 19:45:05 +0200
Message-ID: <20170907174505.GF17526@worktop.programming.kicks-ass.net>
References: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3dTLjGJcmsyNP3zbkGvadqanyRqZfp79+x40XTDlkWk=; b=B6lOiY+1oJ3n/l61eleObm2lI
        caDbc2iIGk7aRHnkWQp0j11J941J3aHmw01l8fd106zL9ZMBPZqbUsDtbu5I99CZ/f8++4QtvDQ7Y
        eE0Yl4pV+zCbNsygkoERPq5nxaVNxwWu6O5Jr/003CrmUaIYlD9Z/Cf9tGTgJLQfCs83SyvGHcmKY
        WQm3ZyFJEHd+nmQZdE3jA3FSttuSCmoXR24scxNonZ4iEIokugk4i7Pq6ACIbYGwZLC0MwUuXLQ5B
        Q6Rq+rUoFj2Ud0W4DYG8GaikVd5f2lcRQskr6LhXhNhcGRnjg0ZgcC3zFrDUnXCiAJVWzdARl3+Mm
    
Content-Disposition: inline
In-Reply-To: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, boqun.feng@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, sramana@codeaurora.org

On Thu, Sep 07, 2017 at 07:26:23PM +0530, Prateek Sood wrote:
> Remove circular dependency deadlock in a scenario where hotplug of CPU is
> being done while there is updation in cgroup and cpuset triggered from
> userspace.
> 
> Process A => kthreadd => Process B => Process C => Process A

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

TJ, I'm puzzled, why would we need to spawn new threads to update NUMA
affinity when taking a CPU out? That doesn't make sense to me, we can
either shrink the affinity of an existing thread or completely kill of a
thread if the mask becomes empty. But why spawn a new thread?

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

So this will eventually do our:

		complete() to make A go.


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


So the whole thing looks like:


A		B			C		D

L(hotplug)
		L(threadgroup)
					L(cpuset)
							L(threadgroup)
WFC(c)
		L(cpuset)
					L(hotplug)
							C(c)

Yes, inverting cpuset and hotplug would break that chain, but I'm still
wondering why workqueue needs to spawn threads on CPU down.

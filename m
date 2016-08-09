From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and
 OOM
Date: Tue, 9 Aug 2016 17:00:59 +0800
Message-ID: <57A99BCB.6070905@huawei.com>
References: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

> This almost stalls the system, this patch moves the threadgroup_change_begin
> from before cgroup_fork() to just before cgroup_canfork(). Ideally we shouldn't
> have to worry about threadgroup changes till the task is actually added to
> the threadgroup. This avoids having to call reclaim with cgroup_threadgroup_rwsem
> held.
> 
> There are other theoretical issues with this semaphore
> 
> systemd can do
> 
> 1. cgroup_mutex (cgroup_kn_lock_live)
> 2. cgroup_threadgroup_rwsem (W) (__cgroup_procs_write)
> 
> and other threads can go
> 
> 1. cgroup_threadgroup_rwsem (R) (copy_process)
> 2. mem_cgroup_iter (as a part of reclaim) (cgroup_mutex -- rcu lock or cgroup_mutex)
> 
> However, I've not examined them in too much detail or looked at lockdep
> wait chains for those paths.
> 
> I am sure there is a good reason for placing cgroup_threadgroup_rwsem
> where it is today and I might be missing something. I am also surprised
> no-one else has run into it so far.
> 
> Comments?
> 

We used to use cgroup_threadgroup_rwsem for syncronization between threads
in the same threadgroup, but now it has evolved to ensure atomic operations
across multi processes.

For example, I'm trying to fix a race. See https://lkml.org/lkml/2016/8/8/900

And the fix kind of relies on the fact that cgroup_post_fork() is placed
inside the read section of cgroup_threadgroup_rwsem, so that cpuset_fork()
won't race with cgroup migration.

> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Signed-off-by: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  kernel/fork.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5c2c355..0474fa8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1406,7 +1406,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->real_start_time = ktime_get_boot_ns();
>  	p->io_context = NULL;
>  	p->audit_context = NULL;
> -	threadgroup_change_begin(current);
>  	cgroup_fork(p);
>  #ifdef CONFIG_NUMA
>  	p->mempolicy = mpol_dup(p->mempolicy);
> @@ -1558,6 +1557,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	INIT_LIST_HEAD(&p->thread_group);
>  	p->task_works = NULL;
>  
> +	threadgroup_change_begin(current);
>  	/*
>  	 * Ensure that the cgroup subsystem policies allow the new process to be
>  	 * forked. It should be noted the the new process's css_set can be changed
> @@ -1658,6 +1658,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  bad_fork_cancel_cgroup:
>  	cgroup_cancel_fork(p);
>  bad_fork_free_pid:
> +	threadgroup_change_end(current);
>  	if (pid != &init_struct_pid)
>  		free_pid(pid);
>  bad_fork_cleanup_thread:
> @@ -1690,7 +1691,6 @@ bad_fork_cleanup_policy:
>  	mpol_put(p->mempolicy);
>  bad_fork_cleanup_threadgroup_lock:
>  #endif
> -	threadgroup_change_end(current);
>  	delayacct_tsk_free(p);
>  bad_fork_cleanup_count:
>  	atomic_dec(&p->cred->user->processes);
> 

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/3] sched, cgroup: replace signal_struct->group_rwsem
 with a global percpu_rwsem
Date: Tue, 19 May 2015 17:16:59 +0200
Message-ID: <20150519151659.GF3644@twins.programming.kicks-ass.net>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
 <1431549318-16756-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431549318-16756-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org

On Wed, May 13, 2015 at 04:35:17PM -0400, Tejun Heo wrote:

.gitconfig:

[diff "default"]
        xfuncname = "^[[:alpha:]$_].*[^:]$"

Will avoid keying on labels like that and show us this is
__cgroup_procs_write().

> @@ -2480,7 +2442,7 @@ retry_find_task:
>  	get_task_struct(tsk);
>  	rcu_read_unlock();
>  
> -	threadgroup_lock(tsk);
> +	percpu_down_write(&cgroup_threadgroup_rwsem);
>  	if (threadgroup) {
>  		if (!thread_group_leader(tsk)) {
>  			/*
> @@ -2490,7 +2452,7 @@ retry_find_task:
>  			 * try again; this is
>  			 * "double-double-toil-and-trouble-check locking".
>  			 */
> -			threadgroup_unlock(tsk);
> +			percpu_up_write(&cgroup_threadgroup_rwsem);
>  			put_task_struct(tsk);
>  			goto retry_find_task;
>  		}

> @@ -2703,17 +2665,17 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
>  				goto out_finish;
>  			last_task = task;
>  
> -			threadgroup_lock(task);
> +			percpu_down_write(&cgroup_threadgroup_rwsem);
>  			/* raced against de_thread() from another thread? */
>  			if (!thread_group_leader(task)) {
> -				threadgroup_unlock(task);
> +				percpu_up_write(&cgroup_threadgroup_rwsem);
>  				put_task_struct(task);
>  				continue;
>  			}
>  
>  			ret = cgroup_migrate(src_cset->dfl_cgrp, task, true);
>  
> -			threadgroup_unlock(task);
> +			percpu_up_write(&cgroup_threadgroup_rwsem);
>  			put_task_struct(task);
>  
>  			if (WARN(ret, "cgroup: failed to update controllers for the default hierarchy (%d), further operations may crash or hang\n", ret))


So my only worry with this patch-set is that these operations will be
hugely expensive.

Now it looks like the cgroup_update_dfl_csses() thing is very rare, its
when you change which controllers are active in a given subtree under
the uber-l337-super-comount design.

The other one, __cgorup_procs_write() is every /procs, /tasks write to a
cgroup, and that does worry me, this could be a somewhat common thing.

The Changelog states task migration is a cold path, but is tens of
miliseconds per task really no problem?

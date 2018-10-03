From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 4/5] sched/core: Prevent race condition between
 cpuset and __sched_setscheduler()
Date: Wed, 3 Oct 2018 15:42:30 -0400
Message-ID: <20181003154230.4b8792fb@gandalf.local.home>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
        <20180903142801.20046-5-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903142801.20046-5-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Mon,  3 Sep 2018 16:28:00 +0200
Juri Lelli <juri.lelli@redhat.com> wrote:


> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5b43f482fa0f..8dc26005bb1e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2410,6 +2410,24 @@ void __init cpuset_init_smp(void)
>  	BUG_ON(!cpuset_migrate_mm_wq);
>  }
>  
> +/**
> + * cpuset_read_only_lock - Grab the callback_lock from another subsysytem
> + *
> + * Description: Gives the holder read-only access to cpusets.
> + */
> +void cpuset_read_only_lock(void)
> +{
> +	raw_spin_lock(&callback_lock);

This was confusing to figure out why grabbing a spinlock gives read
only access. So I read the long comment above the definition of
callback_lock. A couple of notes.

1) The above description needs to go into more detail as to why
grabbing a spinlock is "read only".

2) The comment above the callback_lock needs to incorporate this, as
reading that comment alone will not give anyone an idea that this
exists.

Other than that, I don't see any issue with this patch.

-- Steve


> +}
> +
> +/**
> + * cpuset_read_only_unlock - Release the callback_lock from another subsysytem
> + */
> +void cpuset_read_only_unlock(void)
> +{
> +	raw_spin_unlock(&callback_lock);
> +}
> +
>  /**
>   * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
>   * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 22f5622cba69..ac11ee599968 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4228,6 +4228,13 @@ static int __sched_setscheduler(struct task_struct *p,
>  	rq = task_rq_lock(p, &rf);
>  	update_rq_clock(rq);
>  
> +	/*
> +	 * Make sure we don't race with the cpuset subsystem where root
> +	 * domains can be rebuilt or modified while operations like DL
> +	 * admission checks are carried out.
> +	 */
> +	cpuset_read_only_lock();
> +
>  	/*
>  	 * Changing the policy of the stop threads its a very bad idea:
>  	 */
> @@ -4289,6 +4296,7 @@ static int __sched_setscheduler(struct task_struct *p,
>  	/* Re-check policy now with rq lock held: */
>  	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
>  		policy = oldpolicy = -1;
> +		cpuset_read_only_unlock();
>  		task_rq_unlock(rq, p, &rf);
>  		goto recheck;
>  	}
> @@ -4346,6 +4354,7 @@ static int __sched_setscheduler(struct task_struct *p,
>  
>  	/* Avoid rq from going away on us: */
>  	preempt_disable();
> +	cpuset_read_only_unlock();
>  	task_rq_unlock(rq, p, &rf);
>  
>  	if (pi)
> @@ -4358,6 +4367,7 @@ static int __sched_setscheduler(struct task_struct *p,
>  	return 0;
>  
>  unlock:
> +	cpuset_read_only_unlock();
>  	task_rq_unlock(rq, p, &rf);
>  	return retval;
>  }


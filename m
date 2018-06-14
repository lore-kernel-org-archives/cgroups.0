From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 4/5] sched/core: Prevent race condition between
 cpuset and __sched_setscheduler()
Date: Thu, 14 Jun 2018 16:11:42 -0400
Message-ID: <20180614161142.69f186a6@gandalf.local.home>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
        <20180613121711.5018-5-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-5-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Wed, 13 Jun 2018 14:17:10 +0200
Juri Lelli <juri.lelli@redhat.com> wrote:

> +/**
> + * cpuset_lock - Grab the cpuset_mutex from another subsysytem
> + */
> +int cpuset_lock(void)
> +{
> +	return mutex_trylock(&cpuset_mutex);
> +}
> +
> +/**
> + * cpuset_unlock - Release the cpuset_mutex from another subsysytem
> + */
> +void cpuset_unlock(void)
> +{
> +	mutex_unlock(&cpuset_mutex);
> +}
> +
>  /**
>   * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
>   * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ca788f74259d..a5b0c6c25b44 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4218,6 +4218,14 @@ static int __sched_setscheduler(struct task_struct *p,
>  		if (attr->sched_flags & SCHED_FLAG_SUGOV)
>  			return -EINVAL;
>  
> +		/*
> +		 * Make sure we don't race with the cpuset subsystem where root
> +		 * domains can be rebuilt or modified while operations like DL
> +		 * admission checks are carried out.
> +		 */
> +		if (!cpuset_lock())
> +			return -EBUSY;
> +

How important is this for being a trylock? Reason I am asking is that
it is making my deadline test fail to get the resources. What my test
does is to create a bunch of threads, and they try to get the deadline
resources as they are created. This happens in parallel. Thus, when one
gets the cpuset_lock, the others are hitting this and returning -EBUSY.
At first I thought I was over committing somehow but after adding a
trace_printk() in cpuset_lock(), and this fail case it became obvious
to what was happening:

   deadline_test-1376  [004]   107.179693: sys_enter_sched_setattr: pid: 0x00000000, uattr: 0x7f017fceeed0, flags: 0x00000000
   deadline_test-1376  [004]   107.179697: bputs:                cpuset_lock: cpuset_mutex trylock
   deadline_test-1377  [003]   107.179763: sys_exit_futex:       0x0
   deadline_test-1377  [003]   107.179767: sys_enter_sched_setattr: pid: 0x00000000, uattr: 0x7f017f4eded0, flags: 0x00000000
   deadline_test-1377  [003]   107.179771: bputs:                cpuset_lock: cpuset_mutex trylock
   deadline_test-1377  [003]   107.179771: bputs:                __sched_setscheduler: cpuset_lock
   deadline_test-1377  [003]   107.179773: sys_exit_sched_setattr: 0xfffffffffffffff0

-- Steve

>  		retval = security_task_setscheduler(p);
>  		if (retval)
>  			return retval;


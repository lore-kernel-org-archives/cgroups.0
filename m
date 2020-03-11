From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] sched/cpuset: distribute tasks within affinity masks
Date: Wed, 11 Mar 2020 14:05:33 +0000
Message-ID: <20200311140533.pclgecwhbpqzyrks@e107158-lin.cambridge.arm.com>
References: <20200311010113.136465-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200311010113.136465-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 03/10/20 18:01, Josh Don wrote:
> From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Currently, when updating the affinity of tasks via either cpusets.cpus,
> or, sched_setaffinity(); tasks not currently running within the newly
> specified mask will be arbitrarily assigned to the first CPU within the
> mask.
> 
> This (particularly in the case that we are restricting masks) can
> result in many tasks being assigned to the first CPUs of their new
> masks.
> 
> This:
>  1) Can induce scheduling delays while the load-balancer has a chance to
>     spread them between their new CPUs.
>  2) Can antogonize a poor load-balancer behavior where it has a
>     difficult time recognizing that a cross-socket imbalance has been
>     forced by an affinity mask.
> 
> This change adds a new cpumask interface to allow iterated calls to
> distribute within the intersection of the provided masks.
> 
> The cases that this mainly affects are:
> - modifying cpuset.cpus
> - when tasks join a cpuset
> - when modifying a task's affinity via sched_setaffinity(2)
> 
> Co-developed-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This actually helps me fix a similar problem I faced in RT [1]. If multiple RT
tasks wakeup at the same time we get a 'thundering herd' issue where they all
end up going to the same CPU, just to be pushed out again.

Beside this will help fix another problem for RT tasks fitness, which is
a manifestation of the problem above. If two tasks wake up at the same time and
they happen to run on a little cpu (but request to run on a big one), one of
them will end up being migrated because find_lowest_rq() will return the first
cpu in the mask for both tasks.

I tested the API (not the change in sched/core.c) and it looks good to me.

> ---
> v2:
> - Moved the "distribute" implementation to a new
> cpumask_any_and_distribute() function
> - No longer move a task if it is already running on an allowed cpu
> 
>  include/linux/cpumask.h |  7 +++++++
>  kernel/sched/core.c     |  7 ++++++-
>  lib/cpumask.c           | 29 +++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index d5cc88514aee..f0d895d6ac39 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -194,6 +194,11 @@ static inline unsigned int cpumask_local_spread(unsigned int i, int node)
>  	return 0;
>  }
>  
> +static inline int cpumask_any_and_distribute(const struct cpumask *src1p,
> +					     const struct cpumask *src2p) {
> +	return cpumask_next_and(-1, src1p, src2p);
> +}

nit: cpumask_first_and() is better here?

It might be a good idea to split the API from the user too.

Anyway, for the API.

Reviewed-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Tested-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>

Thanks

--
Qais Yousef

[1] https://lore.kernel.org/lkml/20200219140243.wfljmupcrwm2jelo@e107158-lin/

> +
>  #define for_each_cpu(cpu, mask)			\
>  	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
>  #define for_each_cpu_not(cpu, mask)		\
> @@ -245,6 +250,8 @@ static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
>  int cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
>  int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
>  unsigned int cpumask_local_spread(unsigned int i, int node);
> +int cpumask_any_and_distribute(const struct cpumask *src1p,
> +			       const struct cpumask *src2p);
>  
>  /**
>   * for_each_cpu - iterate over every cpu in a mask
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1a9983da4408..fc6f2bec7d44 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1652,7 +1652,12 @@ static int __set_cpus_allowed_ptr(struct task_struct *p,
>  	if (cpumask_equal(p->cpus_ptr, new_mask))
>  		goto out;
>  
> -	dest_cpu = cpumask_any_and(cpu_valid_mask, new_mask);
> +	/*
> +	 * Picking a ~random cpu helps in cases where we are changing affinity
> +	 * for groups of tasks (ie. cpuset), so that load balancing is not
> +	 * immediately required to distribute the tasks within their new mask.
> +	 */
> +	dest_cpu = cpumask_any_and_distribute(cpu_valid_mask, new_mask);
>  	if (dest_cpu >= nr_cpu_ids) {
>  		ret = -EINVAL;
>  		goto out;
> diff --git a/lib/cpumask.c b/lib/cpumask.c
> index 0cb672eb107c..fb22fb266f93 100644
> --- a/lib/cpumask.c
> +++ b/lib/cpumask.c
> @@ -232,3 +232,32 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>  	BUG();
>  }
>  EXPORT_SYMBOL(cpumask_local_spread);
> +
> +static DEFINE_PER_CPU(int, distribute_cpu_mask_prev);
> +
> +/**
> + * Returns an arbitrary cpu within srcp1 & srcp2.
> + *
> + * Iterated calls using the same srcp1 and srcp2 will be distributed within
> + * their intersection.
> + *
> + * Returns >= nr_cpu_ids if the intersection is empty.
> + */
> +int cpumask_any_and_distribute(const struct cpumask *src1p,
> +			       const struct cpumask *src2p)
> +{
> +	int next, prev;
> +
> +	/* NOTE: our first selection will skip 0. */
> +	prev = __this_cpu_read(distribute_cpu_mask_prev);
> +
> +	next = cpumask_next_and(prev, src1p, src2p);
> +	if (next >= nr_cpu_ids)
> +		next = cpumask_first_and(src1p, src2p);
> +
> +	if (next < nr_cpu_ids)
> +		__this_cpu_write(distribute_cpu_mask_prev, next);
> +
> +	return next;
> +}
> +EXPORT_SYMBOL(cpumask_any_and_distribute);
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 

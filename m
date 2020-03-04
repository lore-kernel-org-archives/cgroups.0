From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] sched/cpuset: distribute tasks within affinity masks
Date: Wed, 4 Mar 2020 19:21:39 +0100
Message-ID: <20200304182139.GO2596@hirez.programming.kicks-ass.net>
References: <20200228010134.42866-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hKyWk7Lq9ur1Op8sObVzpsl0Nt0c5ZcDaJMgGzKn8JE=; b=NY2qlbYBsu9O8vYaS7tyE5l9MV
        AmD64y52Ym5b+53nu8nhjjIy86DdgdzHv6M9XPy1Bt8m1eTKWH26Sa2J/6i0vUl56tBwnidlxdItv
        hm0VLOonJMI+2O7PSHkchFj27+lL/fwtdiH3pTNTiyCM+Eju56n7fANmWpnTPp02ivGzw+zvZcGgs
        Qa4iJO2RjOyDxcLNQMIjcKk8ZdLwAkXVgWMaqwxRJMRtm5qCGJ4XDDBCi0vJuNHoEIANp3RdDJa4A
        2vpc/fIpflsJyq2WIkJSnfHqtMUjPam47XOnMJnkjtQpi9CVGUsqfteXwJ1PWVF0Gk8CFu6HrONx3
        uOByesWA==;
Content-Disposition: inline
In-Reply-To: <20200228010134.42866-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 27, 2020 at 05:01:34PM -0800, Josh Don wrote:
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 04278493bf15..a2aab6a8a794 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1587,6 +1587,8 @@ extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_
>  #ifdef CONFIG_SMP
>  extern void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask);
>  extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
> +extern int set_cpus_allowed_ptr_distribute(struct task_struct *p,
> +				const struct cpumask *new_mask);

Why? Changelog doesn't seem to give a reason for adding another
interface.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1a9983da4408..2336d6d66016 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1612,6 +1612,32 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
>  		set_next_task(rq, p);
>  }
>  
> +static DEFINE_PER_CPU(int, distribute_cpu_mask_prev);
> +
> +/*
> + * Returns an arbitrary cpu within *srcp1 & srcp2
> + *
> + * Iterated calls using the same srcp1 and srcp2, passing the previous cpu each
> + * time, will be distributed within their intersection.
> + */
> +static int distribute_to_new_cpumask(const struct cpumask *src1p,
> +				     const struct cpumask *src2p)
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

That's a valid implementation of cpumask_any_and(), it just has a really
weird name.

>  /*
>   * Change a given task's CPU affinity. Migrate the thread to a
>   * proper CPU and schedule it away if the CPU it's executing on
> @@ -1621,11 +1647,11 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
>   * task must not exit() & deallocate itself prematurely. The
>   * call is not atomic; no spinlocks may be held.
>   */
> -static int __set_cpus_allowed_ptr(struct task_struct *p,
> +static int __set_cpus_allowed_ptr(struct task_struct *p, bool distribute_cpus,
>  				  const struct cpumask *new_mask, bool check)
>  {
>  	const struct cpumask *cpu_valid_mask = cpu_active_mask;
> -	unsigned int dest_cpu;
> +	unsigned int dest_cpu, prev_cpu;
>  	struct rq_flags rf;
>  	struct rq *rq;
>  	int ret = 0;
> @@ -1652,8 +1678,33 @@ static int __set_cpus_allowed_ptr(struct task_struct *p,
>  	if (cpumask_equal(p->cpus_ptr, new_mask))
>  		goto out;
>  
> -	dest_cpu = cpumask_any_and(cpu_valid_mask, new_mask);
> -	if (dest_cpu >= nr_cpu_ids) {
> +	if (!cpumask_intersects(new_mask, cpu_valid_mask)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	prev_cpu = task_cpu(p);
> +	if (distribute_cpus) {
> +		dest_cpu = distribute_to_new_cpumask(new_mask,
> +						     cpu_valid_mask);
> +	} else {
> +		/*
> +		 * Can the task run on the task's current CPU? If so, we're
> +		 * done.
> +		 *
> +		 * We only enable this short-circuit in the case that we're
> +		 * not trying to distribute tasks.  As we may otherwise not
> +		 * distribute away from a loaded CPU, or make duplicate
> +		 * assignments to it.
> +		 */
> +		if (cpumask_test_cpu(prev_cpu, new_mask))
> +			dest_cpu = prev_cpu;
> +		else
> +			dest_cpu = cpumask_any_and(cpu_valid_mask, new_mask);
> +	}

That all seems overly complicated; what is wrong with just this:

	dest_cpu = cpumask_any_and_fancy(cpu_valid_mask, new_mask);

I don't really buy the argument why that shortcut is problematic; it's
all averages anyway, and keeping a task on a CPU where it's already
running seems like a win.

> +	/* May have raced with cpu_down */
> +	if (unlikely(dest_cpu >= nr_cpu_ids)) {
>  		ret = -EINVAL;
>  		goto out;
>  	}

From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Don't filter offline CPUs in
 cpuset_cpus_allowed() for top cpuset tasks
Date: Sat, 4 Feb 2023 11:01:22 +0100
Message-ID: <Y94s8mzrE9VyUJLa@hirez.programming.kicks-ass.net>
References: <20230203164040.213437-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1CILfoEi2sLKOY/pCvvQ82YwMOdadBhYba5yUkzOQF4=; b=ZJpSGJ2Gm7UKIQyW7E+HUvnADc
        Y0cBs4LCGAakZUibVz2HRJJXcHWFFbZqobqrG9ZvNbMxE/mp40jOFj72+zfb2mCIzezK2tdFCvjcr
        KifjCmqGtgCm7yhZrJTy7ICh16810d7c3BVP1v34SUi718dAz3QPVzuoDD/dGCpOtClfuveM4Ebe8
        MERsMl7a04e5L2cBJN8jPgcnfOImMseg6e9d+aEfpl4ovLwChRxraRssx/KP0hdEvBUyhblK2qtwv
        eayZoOGpY9u7koRpkx5HLi7+cudW+1FAXiZd/wqklwz08N58MF5gykplMguJR4OoWJt56fDAJxWw6
        0+TntN9Q==;
Content-Disposition: inline
In-Reply-To: <20230203164040.213437-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Fri, Feb 03, 2023 at 11:40:40AM -0500, Waiman Long wrote:
> Since commit 8f9ea86fdf99 ("sched: Always preserve the user
> requested cpumask"), relax_compatible_cpus_allowed_ptr() is calling
> __sched_setaffinity() unconditionally. This helps to expose a bug in
> the current cpuset hotplug code where the cpumasks of the tasks in
> the top cpuset are not updated at all when some CPUs become online or
> offline. It is likely caused by the fact that some of the tasks in the
> top cpuset, like percpu kthreads, cannot have their cpu affinity changed.
> 
> One way to reproduce this as suggested by Peter is:
>  - boot machine
>  - offline all CPUs except one
>  - taskset -p ffffffff $$
>  - online all CPUs
> 
> Fix this by allowing cpuset_cpus_allowed() to return a wider mask that
> includes offline CPUs for those tasks that are in the top cpuset. For
> tasks not in the top cpuset, the old rule applies and only online CPUs
> will be returned in the mask since hotplug events will update their
> cpumasks accordingly.

So you get the task_cpu_possible_mask() interaction vs cpusets horribly
wrong here, but given the very sorry state of task_cpu_possible_mask()
correctness of cpuset as a whole that might just not matter at this
point.

I do very much hate how you add exceptions on exceptions instead of
looking to do something right :-(

Fixing that parition case in my patch is 1 extra line and then I think
it fundamentally does the right thing and can serve as a basis for
fixing cpuset as a whole.

> Fixes: 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
> Reported-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Originally-from: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 207bafdb05e8..11554e5845f7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3707,15 +3707,38 @@ void __init cpuset_init_smp(void)
>   * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
>   * attached to the specified @tsk.  Guaranteed to return some non-empty
>   * subset of cpu_online_mask, even if this means going outside the
> - * tasks cpuset.
> + * tasks cpuset, except when the task is in the top cpuset.
>   **/
>  
>  void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
>  {
>  	unsigned long flags;
> +	struct cpuset *cs;
>  
>  	spin_lock_irqsave(&callback_lock, flags);
> -	guarantee_online_cpus(tsk, pmask);
> +	rcu_read_lock();
> +
> +	cs = task_cs(tsk);
> +	if (cs != &top_cpuset)
> +		guarantee_online_cpus(tsk, pmask);
> +	/*
> +	 * TODO: Tasks in the top cpuset won't get update to their cpumasks
> +	 * when a hotplug online/offline event happens. So we include all
> +	 * offline cpus in the allowed cpu list.
> +	 */

I don't like TODO there, I really don't think CPUSET should update root
tasks, that means yet another fundamental difference between
CPUSET={y,n}.

> +	if ((cs == &top_cpuset) || cpumask_empty(pmask)) {
> +		const struct cpumask *possible_mask = task_cpu_possible_mask(tsk);
> +
> +		/*
> +		 * We first exclude cpus allocated to partitions. If there is no
> +		 * allowable online cpu left, we fall back to all possible cpus.
> +		 */
> +		cpumask_andnot(pmask, possible_mask, top_cpuset.subparts_cpus);
> +		if (!cpumask_intersects(pmask, cpu_online_mask))
> +			cpumask_copy(pmask, possible_mask);
> +	}
> +
> +	rcu_read_unlock();
>  	spin_unlock_irqrestore(&callback_lock, flags);
>  }

I really detest this patch, but if you insist it might just do :-/

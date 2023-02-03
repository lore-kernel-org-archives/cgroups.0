From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Don't filter offline CPUs in
 cpuset_cpus_allowed() for top cpuset tasks
Date: Fri, 3 Feb 2023 11:00:24 -1000
Message-ID: <Y9116OLfP6GoZ0ez@slm.duckdns.org>
References: <20230203164040.213437-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+b8TnNfk5HpRX2+jLolvQqR5er/qgFGP/PJZjr+rDww=;
        b=VtEc3firMEuR7MoYOPU4HtJ6MhKnzGhR0W2YC73IzSbv5qj0C/9q4m9zqhHT7+hLi8
         /AHYf4ixUm4qKzV2qdB9Ontci9e3SAwWHb5aSc1dGSRJkjbwHdVBbZ4OoFWjGm8DEcwu
         2g/eauO/KsQz3COI7P91NsVL4TV/YnJPEyLYaafVOrJUVeRxTJoLyR8nQJ90ZYed38mt
         Qd8E1EeVenTnYmuTC4shi8XjTVm5MjGue6QczlHnqb7bjyYaEQ8G9YJPcxaTyvkACXj+
         JAaGq+bu8vTy1SDm18FIQnIuVDaBoQNeKMupY/xs5zURfBFTwH2YPcjXwl77tGmVDRDI
         FakA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230203164040.213437-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

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
> 
> Fixes: 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
> Reported-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Originally-from: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

So, this is the replacement for the first patch[1] Will posted, right?

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
> +	if ((cs == &top_cpuset) || cpumask_empty(pmask)) {
> +		const struct cpumask *possible_mask = task_cpu_possible_mask(tsk);
> +
> +		/*
> +		 * We first exclude cpus allocated to partitions. If there is no
> +		 * allowable online cpu left, we fall back to all possible cpus.
> +		 */
> +		cpumask_andnot(pmask, possible_mask, top_cpuset.subparts_cpus);

and the differences are that

* It's only applied to the root cgroup.

* Cpus taken up by partitions are excluded.

Is my understanding correct?

> +		if (!cpumask_intersects(pmask, cpu_online_mask))
> +			cpumask_copy(pmask, possible_mask);
> +	}
> +
> +	rcu_read_unlock();
>  	spin_unlock_irqrestore(&callback_lock, flags);

So, I suppose you're suggesting applying this patch instead of the one Will
Deacon posted[1] and we need Will's second patch[2] on top, right?

[1] http://lkml.kernel.org/r/20230131221719.3176-3-will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/r/20230131221719.3176-3-will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Thanks.

-- 
tejun

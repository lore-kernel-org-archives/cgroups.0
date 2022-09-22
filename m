From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1] mm: oom: introduce cpuset oom
Date: Thu, 22 Sep 2022 12:18:04 -0700 (PDT)
Message-ID: <18621b07-256b-7da1-885a-c96dfc8244b6@google.com>
References: <20220921064710.89663-1-ligang.bdlg@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date;
        bh=6I54Hmibv9NNEON21MI/khC1j473zoH5sNcGiz/IqMA=;
        b=jUjTeh5wzF9Ni5HL8rTLkQmxNzQ3yiyS8+wNt2SvUGZ7nGR9TOlyMyCEWezk93KVou
         ou2QevkOksC6VOZRj8jeW+2+DYXWx2J6QAZhW+ATh67Uxw4MyS9azJq4UHyOMKdiQtRL
         KOAB4SghBAL72PCXfYFb8JlkczkehRvHXlchTMaaeJ+yZ6C/nefzrjZXIzptjNLOJQUN
         LwbiXyZgpUtQmTa6axgSgPmAp9DYre7MlUt66vZXtKwxzpLoXuY8BeG6QuthtCJzEUzX
         52/bqPUPaJgJ4wazvClsHtrdj6IHUINvjXnc3KpprM7N+v1MNUlksFtyf7vOwH+qASqZ
         PEJA==
In-Reply-To: <20220921064710.89663-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 21 Sep 2022, Gang Li wrote:

> cpuset confine processes to processor and memory node subsets.
> When a process in cpuset triggers oom, it may kill a completely
> irrelevant process on another numa node, which will not release any
> memory for this cpuset.
> 
> It seems that `CONSTRAINT_CPUSET` is not really doing much these
> days. Using CONSTRAINT_CPUSET, we can easily achieve node aware oom
> killing by selecting victim from the cpuset which triggers oom.
> 
> Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hmm, is this the right approach?

If a cpuset results in a oom condition, is there a reason why we'd need to 
find a process from within that cpuset to kill?  I think the idea is to 
free memory on the oom set of nodes (cpuset.mems) and that can happen by 
killing a process that is not a member of this cpuset.

I understand the challenges of creating a NUMA aware oom killer to target 
memory that is actually resident on an oom node, but this approach doesn't 
seem right and could actually lead to pathological cases where a small 
process trying to fork in an otherwise empty cpuset is repeatedly oom 
killing when we'd actually prefer to kill a single large process.

> ---
> This idea comes from a previous patch:
> mm, oom: Introduce per numa node oom for CONSTRAINT_MEMORY_POLICY
> https://lore.kernel.org/all/YoJ%2FioXwGTdCywUE-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/
> 
> Any comments are welcome.
> ---
>  include/linux/cpuset.h |  6 ++++++
>  kernel/cgroup/cpuset.c | 17 +++++++++++++++++
>  mm/oom_kill.c          |  4 ++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index d58e0476ee8e..7475f613ab90 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -178,6 +178,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>  	task_unlock(current);
>  }
>  
> +int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg);
> +
>  #else /* !CONFIG_CPUSETS */
>  
>  static inline bool cpusets_enabled(void) { return false; }
> @@ -299,6 +301,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
>  	return false;
>  }
>  
> +static inline int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
> +{
> +	return 0;
> +}
>  #endif /* !CONFIG_CPUSETS */
>  
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b474289c15b8..1f1238b4276d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3943,6 +3943,23 @@ void cpuset_print_current_mems_allowed(void)
>  	rcu_read_unlock();
>  }
>  
> +int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
> +{
> +	int ret = 0;
> +	struct cgroup *cgrp;
> +	struct css_task_iter it;
> +	struct task_struct *task;
> +
> +	rcu_read_lock();
> +	css_task_iter_start(&(task_cs(current)->css), CSS_TASK_ITER_PROCS, &it);
> +	while (!ret && (task = css_task_iter_next(&it)))
> +		ret = fn(task, arg);
> +	css_task_iter_end(&it);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  /*
>   * Collection of memory_pressure is suppressed unless
>   * this flag is enabled by writing "1" to the special
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 46e7e073f137..8cea787b359c 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -367,6 +367,8 @@ static void select_bad_process(struct oom_control *oc)
>  
>  	if (is_memcg_oom(oc))
>  		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
> +	else if (oc->constraint == CONSTRAINT_CPUSET)
> +		cpuset_cgroup_scan_tasks(oom_evaluate_task, oc);
>  	else {
>  		struct task_struct *p;
>  
> @@ -427,6 +429,8 @@ static void dump_tasks(struct oom_control *oc)
>  
>  	if (is_memcg_oom(oc))
>  		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
> +	else if (oc->constraint == CONSTRAINT_CPUSET)
> +		cpuset_cgroup_scan_tasks(dump_task, oc);
>  	else {
>  		struct task_struct *p;
>  
> -- 
> 2.20.1
> 
> 
> 

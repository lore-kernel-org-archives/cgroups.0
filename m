From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] oom: rework dump_tasks to optimize memcg-oom
 situation
Date: Wed, 7 Nov 2012 10:07:14 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1211071003150.27451@chino.kir.corp.google.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277719-21760-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=AM3Xco+uRTT0dg3XvUhBaIs7HgnHb/W/yxBIYo0LDcE=;
        b=T0S4fxPeUEVnzE8JQe1vobe80RDkez+aDZK4gqgS0jOwcpsjj7BFFxzDP6enl1vXqV
         Hzyyt6SI1hPyxkufw8sZun2bUsRC5SnbxguxiNDUC0GweUQ8rqlGAUqxmWfIi4KMerRX
         Lj7jfLj4DUQj1OPMim5gzpB+XlYaWeRu6I4I+sa4v5nBZXG9RcXDw3OGb1VxesUwiOdb
         Fie2dODffoPkOkXkUVGO9gorhIRpzDROtsZPh1Bj/ktGg5zZ6Qoc/Yqb7cKRgUdugly4
         Xft4Xa/qp7cy1/nL2UdYInaf1bTwxw48CuSRgN3+DQ6lmUEmjkpUwzB+Ug6XpoC5bgME
         5GHQ==
In-Reply-To: <1352277719-21760-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Wed, 7 Nov 2012, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> If memcg oom happening, don't scan all system tasks to dump memory state of
> eligible tasks, instead we iterates only over the process attached to the oom
> memcg and avoid the rcu lock.
> 

Avoiding the rcu lock isn't actually that impressive here, the cgroup 
iterator will use it's own lock for that memcg.

> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  include/linux/memcontrol.h |    7 +++++
>  include/linux/oom.h        |    2 +
>  mm/memcontrol.c            |   14 +++++++++++
>  mm/oom_kill.c              |   55 ++++++++++++++++++++++++++-----------------
>  4 files changed, 56 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index c91e3c1..4322ca8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -122,6 +122,8 @@ unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
>  void mem_cgroup_update_lru_size(struct lruvec *, enum lru_list, int);
>  extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
>  					struct task_struct *p);
> +extern void dump_tasks_memcg(const struct mem_cgroup *memcg,
> +					const nodemask_t *nodemask);

Shouldn't need the nodemask parameter, just have dump_tasks_memcg() pass 
NULL to dump_per_task(), we won't be isolating to tasks with mempolicies 
restricted to a particular set of nodes since we're in the memcg oom path 
here, not the global page allocator oom path.

>  extern void mem_cgroup_replace_page_cache(struct page *oldpage,
>  					struct page *newpage);
>  
> @@ -337,6 +339,11 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
>  }
>  
> +static inline void
> +dump_tasks_memcg(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
> +{
> +}
> +
>  static inline void mem_cgroup_begin_update_page_stat(struct page *page,
>  					bool *locked, unsigned long *flags)
>  {
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 20b5c46..9ba3344 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -57,6 +57,8 @@ extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  		unsigned long totalpages, const nodemask_t *nodemask,
>  		bool force_kill);
>  
> +extern inline void dump_per_task(struct task_struct *p,
> +				const nodemask_t *nodemask);

This is a global symbol, so dump_per_task() doesn't make a lot of sense: 
it would need to be prefixed with "oom_" so perhaps oom_dump_task() is 
better?

>  extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  		int order, nodemask_t *mask, bool force_kill);
>  extern int register_oom_notifier(struct notifier_block *nb);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2df5e72..fe648f8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1665,6 +1665,20 @@ static u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
>  	return min(limit, memsw);
>  }
>  
> +void dump_tasks_memcg(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
> +{
> +	struct cgroup_iter it;
> +	struct task_struct *task;
> +	struct cgroup *cgroup = memcg->css.cgroup;
> +
> +	cgroup_iter_start(cgroup, &it);
> +	while ((task = cgroup_iter_next(cgroup, &it))) {
> +		dump_per_task(task, nodemask);
> +	}
> +
> +	cgroup_iter_end(cgroup, &it);
> +}
> +
>  static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				     int order)
>  {
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4b8a6dd..aaf6237 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -367,6 +367,32 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  	return chosen;
>  }
>  
> +inline void dump_per_task(struct task_struct *p, const nodemask_t *nodemask)

No inline.

> +{
> +	struct task_struct *task;
> +
> +	if (oom_unkillable_task(p, NULL, nodemask))
> +		return;
> +
> +	task = find_lock_task_mm(p);
> +	if (!task) {
> +		/*
> +		 * This is a kthread or all of p's threads have already
> +		 * detached their mm's.  There's no need to report
> +		 * them; they can't be oom killed anyway.
> +		 */
> +		return;
> +	}
> +
> +	pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5d %s\n",
> +		task->pid, from_kuid(&init_user_ns, task_uid(task)),
> +		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
> +		task->mm->nr_ptes,
> +		get_mm_counter(task->mm, MM_SWAPENTS),
> +		task->signal->oom_score_adj, task->comm);
> +	task_unlock(task);
> +}
> +
>  /**
>   * dump_tasks - dump current memory state of all system tasks
>   * @memcg: current's memory controller, if constrained
> @@ -381,32 +407,17 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  static void dump_tasks(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
>  {
>  	struct task_struct *p;
> -	struct task_struct *task;
>  
>  	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name\n");
> -	rcu_read_lock();
> -	for_each_process(p) {
> -		if (oom_unkillable_task(p, memcg, nodemask))
> -			continue;
> -
> -		task = find_lock_task_mm(p);
> -		if (!task) {
> -			/*
> -			 * This is a kthread or all of p's threads have already
> -			 * detached their mm's.  There's no need to report
> -			 * them; they can't be oom killed anyway.
> -			 */
> -			continue;
> -		}
>  
> -		pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5d %s\n",
> -			task->pid, from_kuid(&init_user_ns, task_uid(task)),
> -			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
> -			task->mm->nr_ptes,
> -			get_mm_counter(task->mm, MM_SWAPENTS),
> -			task->signal->oom_score_adj, task->comm);
> -		task_unlock(task);
> +	if (memcg) {
> +		dump_tasks_memcg(memcg, nodemask);
> +		return;
>  	}
> +
> +	rcu_read_lock();
> +	for_each_process(p)
> +		dump_per_task(p, nodemask);
>  	rcu_read_unlock();
>  }
>  

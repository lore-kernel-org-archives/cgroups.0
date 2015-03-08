From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: print cgroup information when system panics due
 to panic_on_oom
Date: Sat, 7 Mar 2015 19:48:37 -0500
Message-ID: <20150308004837.GA23070@dhcp22.suse.cz>
References: <1425668024-20168-1-git-send-email-balasubramani_vivekanandan@mentor.com>
 <1425668024-20168-2-git-send-email-balasubramani_vivekanandan@mentor.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u9jZBZZBi4x26bOiuRRHC1WUw+gDLsBTqRl1cXEXPhg=;
        b=0bH4mblavjqojRn1SJ3NuBbZE6byx4VwAfOfzxMf929rED4fdBFQN/MOjX+YVMsXrX
         VZ4a0oTUPkBcPYpm1NOz9xZUIxwiOkFFvdeTNZRYqXDHHhNXklqkA269QHjYv6SqSnKw
         gFz8q9xQEyHNkd/geifUxhizfPA8SgIiSc4p+mXsa6DXZgBHcce2et5yCwzVE/6LeqpM
         0tByVzv7y/5ELri+xi7G6e5Yb98IpXmtd9R0gnsFD80ZzjkFuoizirDVN47OHVHHYG10
         FJwhZAYy+LAEXSLBs/BpYl3trdv8viI83NGAggM7+bpfNtJCxMZV4BGZVhoIi5L7t69d
         LOdw==
Content-Disposition: inline
In-Reply-To: <1425668024-20168-2-git-send-email-balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balasubramani Vivekanandan <balu252-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Balasubramani Vivekanandan <balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

[CCing Johannes and Andrew]

On Sat 07-03-15 00:23:44, Balasubramani Vivekanandan wrote:
> If kernel panics due to oom, caused by a cgroup reaching its limit, when
> 'compulsory panic_on_oom' is enabled, then we will only see that the OOM
> happened because of "compulsory panic_on_oom is enabled" but this
> doesn't tell the difference between mempolicy and memcg. And dumping
> system wide information is plain wrong and more confusing. This patch
> provides the information of the cgroup whose limit triggerred panic
> 
> Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks!

> ---
>  include/linux/oom.h |  3 ++-
>  mm/memcontrol.c     | 16 +++++++++-------
>  mm/oom_kill.c       |  7 ++++---
>  3 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index d5771bed..44b2f6f 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -66,7 +66,8 @@ extern bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_flags);
>  extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
>  
>  extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
> -			       int order, const nodemask_t *nodemask);
> +			       int order, const nodemask_t *nodemask,
> +			       struct mem_cgroup *memcg);
>  
>  extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  		unsigned long totalpages, const nodemask_t *nodemask,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0c86945..fb884eb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1442,15 +1442,17 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  	struct mem_cgroup *iter;
>  	unsigned int i;
>  
> -	if (!p)
> -		return;
> -
>  	mutex_lock(&oom_info_lock);
>  	rcu_read_lock();
>  
> -	pr_info("Task in ");
> -	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
> -	pr_cont(" killed as a result of limit of ");
> +	if (p) {
> +		pr_info("Task in ");
> +		pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
> +		pr_cont(" killed as a result of limit of ");
> +	} else {
> +		pr_info("Memory limit reached of cgroup ");
> +	}
> +
>  	pr_cont_cgroup_path(memcg->css.cgroup);
>  	pr_cont("\n");
>  
> @@ -1537,7 +1539,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		return;
>  	}
>  
> -	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
> +	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL, memcg);
>  	totalpages = mem_cgroup_get_limit(memcg) ? : 1;
>  	for_each_mem_cgroup_tree(iter, memcg) {
>  		struct css_task_iter it;
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 642f38c..52628c8 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -612,7 +612,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>   * Determines whether the kernel must panic because of the panic_on_oom sysctl.
>   */
>  void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
> -			int order, const nodemask_t *nodemask)
> +			int order, const nodemask_t *nodemask,
> +			struct mem_cgroup *memcg)
>  {
>  	if (likely(!sysctl_panic_on_oom))
>  		return;
> @@ -625,7 +626,7 @@ void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
>  		if (constraint != CONSTRAINT_NONE)
>  			return;
>  	}
> -	dump_header(NULL, gfp_mask, order, NULL, nodemask);
> +	dump_header(NULL, gfp_mask, order, memcg, nodemask);
>  	panic("Out of memory: %s panic_on_oom is enabled\n",
>  		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
>  }
> @@ -740,7 +741,7 @@ static void __out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
>  						&totalpages);
>  	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
> -	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
> +	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
>  
>  	if (sysctl_oom_kill_allocating_task && current->mm &&
>  	    !oom_unkillable_task(current, NULL, nodemask) &&
> -- 
> 2.3.1
> 

-- 
Michal Hocko
SUSE Labs

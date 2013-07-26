From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 5/6] mm: memcg: enable memcg OOM killer only for user
 faults
Date: Fri, 26 Jul 2013 16:16:42 +0200
Message-ID: <20130726141642.GG17761@dhcp22.suse.cz>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org>
 <1374791138-15665-6-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1374791138-15665-6-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 25-07-13 18:25:37, Johannes Weiner wrote:
> System calls and kernel faults (uaccess, gup) can handle an out of
> memory situation gracefully and just return -ENOMEM.
> 
> Enable the memcg OOM killer only for user faults, where it's really
> the only option available.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

It looks OK to me, but I have few comments bellow. Nothing really huge
but I do not like mem_cgroup_xchg_may_oom for !MEMCG.

> ---
>  include/linux/memcontrol.h | 23 +++++++++++++++++++++++
>  include/linux/sched.h      |  3 +++
>  mm/filemap.c               | 11 ++++++++++-
>  mm/memcontrol.c            |  2 +-
>  mm/memory.c                | 40 ++++++++++++++++++++++++++++++----------
>  5 files changed, 67 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7b4d9d7..9bb5eeb 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -125,6 +125,24 @@ extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
>  extern void mem_cgroup_replace_page_cache(struct page *oldpage,
>  					struct page *newpage);
>  
> +/**
> + * mem_cgroup_xchg_may_oom - toggle the memcg OOM killer for a task
> + * @p: task

Is this ever safe to call on !current? If not then I wouldn't allow to
give p as a parameter.

> + * @new: true to enable, false to disable
> + *
> + * Toggle whether a failed memcg charge should invoke the OOM killer
> + * or just return -ENOMEM.  Returns the previous toggle state.
> + */
> +static inline bool mem_cgroup_xchg_may_oom(struct task_struct *p, bool new)
> +{
> +	bool old;
> +
> +	old = p->memcg_oom.may_oom;
> +	p->memcg_oom.may_oom = new;
> +
> +	return old;
> +}
> +
>  #ifdef CONFIG_MEMCG_SWAP
>  extern int do_swap_account;
>  #endif
> @@ -348,6 +366,11 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>  {
>  }
>  
> +static inline bool mem_cgroup_xchg_may_oom(struct task_struct *p, bool new)
> +{
> +	return !new;
> +}

This looks a bit weird. MEMCG is not compiled in and yet we return that
the previous may_oom could be true. This is calling for troubles if
somebody tries to do any following decisions on the returned value.
Why not simply return false unconditionally?

[...]
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a6981fe..2932810 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
[...]
> @@ -1634,10 +1639,14 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		 * We found the page, so try async readahead before
>  		 * waiting for the lock.
>  		 */
> +		may_oom = mem_cgroup_xchg_may_oom(current, 0);

s/0/false/

below ditto

>  		do_async_mmap_readahead(vma, ra, file, page, offset);
> +		mem_cgroup_xchg_may_oom(current, may_oom);
>  	} else if (!page) {
>  		/* No page in the page cache at all */
> +		may_oom = mem_cgroup_xchg_may_oom(current, 0);
>  		do_sync_mmap_readahead(vma, ra, file, offset);
> +		mem_cgroup_xchg_may_oom(current, may_oom);
>  		count_vm_event(PGMAJFAULT);
>  		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
>  		ret = VM_FAULT_MAJOR;
[...]
> diff --git a/mm/memory.c b/mm/memory.c
> index f2ab2a8..5ea7b47 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
[...]
> @@ -3851,6 +3843,34 @@ retry:
>  	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
>  }
>  
> +int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> +		    unsigned long address, unsigned int flags)
> +{
> +	int ret;
> +
> +	__set_current_state(TASK_RUNNING);
> +
> +	count_vm_event(PGFAULT);
> +	mem_cgroup_count_vm_event(mm, PGFAULT);
> +
> +	/* do counter updates before entering really critical section. */
> +	check_sync_rss_stat(current);
> +
> +	/*
> +	 * Enable the memcg OOM handling for faults triggered in user
> +	 * space.  Kernel faults are handled more gracefully.
> +	 */
> +	if (flags & FAULT_FLAG_USER)
> +		WARN_ON(mem_cgroup_xchg_may_oom(current, true) == true);
> +
> +	ret = __handle_mm_fault(mm, vma, address, flags);
> +
> +	if (flags & FAULT_FLAG_USER)
> +		WARN_ON(mem_cgroup_xchg_may_oom(current, false) == false);

Ohh, I see why you used !new in mem_cgroup_xchg_may_oom for !MEMCG case
above. This could be fixed easily if you add mem_cgroup_{enable,disable}_oom
which would be empty for !MEMCG.

> +
> +	return ret;
> +}
> +
>  #ifndef __PAGETABLE_PUD_FOLDED
>  /*
>   * Allocate page upper directory.
> -- 
> 1.8.3.2
> 

-- 
Michal Hocko
SUSE Labs

From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to
 CONFIG_MEMCG_KMEM
Date: Mon, 1 Mar 2021 17:15:36 -0800
Message-ID: <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uqY8g06FFAV5xQpyAbRl+VapuMxesj+spaTV2MTwDE4=;
 b=TeY/yy0h8jTRLO0uvJd5T4lwDzZm9tJv9vbsBjSX5NaQ0RkXSaC8CtlVTsu3gbCNR6r6
 8EYa/ajJz1eWyP2Lplm/HZvmQxMBeYTv6uXkYY/uHcIxWEp65li2oh4HzKJHGBQsOhH8
 ItfKouwGmYs3h16wI79f+plghi8jdp4fJ8g= 
Content-Disposition: inline
In-Reply-To: <20210301062227.59292-5-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com, chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz, mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com, iamjo

On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> The remote memcg charing APIs is a mechanism to charge kernel memory
> to a given memcg. So we can move the infrastructure to the scope of
> the CONFIG_MEMCG_KMEM.

This is not a good idea, because there is nothing kmem-specific
in the idea of remote charging, and we definitely will see cases
when user memory is charged to the process different from the current.

> 
> As a bonus, on !CONFIG_MEMCG_KMEM build some functions and variables
> can be compiled out.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/sched.h    | 2 ++
>  include/linux/sched/mm.h | 2 +-
>  kernel/fork.c            | 2 +-
>  mm/memcontrol.c          | 4 ++++
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ee46f5cab95b..c2d488eddf85 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1314,7 +1314,9 @@ struct task_struct {
>  
>  	/* Number of pages to reclaim on returning to userland: */
>  	unsigned int			memcg_nr_pages_over_high;
> +#endif
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  	/* Used by memcontrol for targeted memcg charge: */
>  	struct mem_cgroup		*active_memcg;
>  #endif
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 1ae08b8462a4..64a72975270e 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -294,7 +294,7 @@ static inline void memalloc_nocma_restore(unsigned int flags)
>  }
>  #endif
>  
> -#ifdef CONFIG_MEMCG
> +#ifdef CONFIG_MEMCG_KMEM
>  DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
>  /**
>   * set_active_memcg - Starts the remote memcg charging scope.
> diff --git a/kernel/fork.c b/kernel/fork.c
> index d66cd1014211..d66718bc82d5 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -942,7 +942,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  	tsk->use_memdelay = 0;
>  #endif
>  
> -#ifdef CONFIG_MEMCG
> +#ifdef CONFIG_MEMCG_KMEM
>  	tsk->active_memcg = NULL;
>  #endif
>  	return tsk;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 39cb8c5bf8b2..092dc4588b43 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -76,8 +76,10 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
>  
>  struct mem_cgroup *root_mem_cgroup __read_mostly;
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  /* Active memory cgroup to use from an interrupt context */
>  DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
> +#endif
>  
>  /* Socket memory accounting disabled? */
>  static bool cgroup_memory_nosocket;
> @@ -1054,6 +1056,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
>  }
>  EXPORT_SYMBOL(get_mem_cgroup_from_mm);
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  static __always_inline struct mem_cgroup *active_memcg(void)
>  {
>  	if (in_interrupt())
> @@ -1074,6 +1077,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>  
>  	return false;
>  }
> +#endif
>  
>  /**
>   * mem_cgroup_iter - iterate over memory cgroup hierarchy
> -- 
> 2.11.0
> 

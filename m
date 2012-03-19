From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
Date: Mon, 19 Mar 2012 11:38:38 +0900
Message-ID: <4F669C2E.1010502@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331919570-2264-5-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/03/17 2:39), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This patch implements a memcg extension that allows us to control
> HugeTLB allocations via memory controller.
> 


If you write some details here, it will be helpful for review and
seeing log after merge.


> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  include/linux/hugetlb.h    |    1 +
>  include/linux/memcontrol.h |   42 +++++++++++++
>  init/Kconfig               |    8 +++
>  mm/hugetlb.c               |    2 +-
>  mm/memcontrol.c            |  138 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 190 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index a2675b0..1f70068 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -243,6 +243,7 @@ struct hstate *size_to_hstate(unsigned long size);
>  #define HUGE_MAX_HSTATE 1
>  #endif
>  
> +extern int hugetlb_max_hstate;
>  extern struct hstate hstates[HUGE_MAX_HSTATE];
>  extern unsigned int default_hstate_idx;
>  
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d34356..320dbad 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -429,5 +429,47 @@ static inline void sock_release_memcg(struct sock *sk)
>  {
>  }
>  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> +
> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> +extern int mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
> +					  struct mem_cgroup **ptr);
> +extern void mem_cgroup_hugetlb_commit_charge(int idx, unsigned long nr_pages,
> +					     struct mem_cgroup *memcg,
> +					     struct page *page);
> +extern void mem_cgroup_hugetlb_uncharge_page(int idx, unsigned long nr_pages,
> +					     struct page *page);
> +extern void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
> +					      struct mem_cgroup *memcg);
> +
> +#else
> +static inline int
> +mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
> +						 struct mem_cgroup **ptr)
> +{
> +	return 0;
> +}
> +
> +static inline void
> +mem_cgroup_hugetlb_commit_charge(int idx, unsigned long nr_pages,
> +				 struct mem_cgroup *memcg,
> +				 struct page *page)
> +{
> +	return;
> +}
> +
> +static inline void
> +mem_cgroup_hugetlb_uncharge_page(int idx, unsigned long nr_pages,
> +				 struct page *page)
> +{
> +	return;
> +}
> +
> +static inline void
> +mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
> +				  struct mem_cgroup *memcg)
> +{
> +	return;
> +}
> +#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
>  #endif /* _LINUX_MEMCONTROL_H */
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index 3f42cd6..f0eb8aa 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -725,6 +725,14 @@ config CGROUP_PERF
>  
>  	  Say N if unsure.
>  
> +config MEM_RES_CTLR_HUGETLB
> +	bool "Memory Resource Controller HugeTLB Extension (EXPERIMENTAL)"
> +	depends on CGROUP_MEM_RES_CTLR && HUGETLB_PAGE && EXPERIMENTAL
> +	default n
> +	help
> +	  Add HugeTLB management to memory resource controller. When you
> +	  enable this, you can put a per cgroup limit on HugeTLB usage.
> +
>  menuconfig CGROUP_SCHED
>  	bool "Group CPU scheduler"
>  	default n
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ebe245c..c672187 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -34,7 +34,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
>  static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
>  unsigned long hugepages_treat_as_movable;
>  
> -static int hugetlb_max_hstate;
> +int hugetlb_max_hstate;
>  unsigned int default_hstate_idx;
>  struct hstate hstates[HUGE_MAX_HSTATE];
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6728a7a..4b36c5e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -235,6 +235,10 @@ struct mem_cgroup {
>  	 */
>  	struct res_counter memsw;
>  	/*
> +	 * the counter to account for hugepages from hugetlb.
> +	 */
> +	struct res_counter hugepage[HUGE_MAX_HSTATE];




> +	/*
>  	 * Per cgroup active and inactive list, similar to the
>  	 * per zone LRU lists.
>  	 */
> @@ -3156,6 +3160,128 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
>  }
>  #endif
>  
> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> +static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
> +{
> +	int idx;
> +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
> +		if (memcg->hugepage[idx].usage > 0)
> +			return 1;
> +	}
> +	return 0;
> +}


Please use res_counter_read_u64() rather than reading the value directly.


> +
> +int mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
> +				   struct mem_cgroup **ptr)
> +{
> +	int ret = 0;
> +	struct mem_cgroup *memcg;
> +	struct res_counter *fail_res;
> +	unsigned long csize = nr_pages * PAGE_SIZE;
> +
> +	if (mem_cgroup_disabled())
> +		return 0;
> +again:
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(current);
> +	if (!memcg)
> +		memcg = root_mem_cgroup;
> +	if (mem_cgroup_is_root(memcg)) {
> +		rcu_read_unlock();
> +		goto done;
> +	}


One concern is.... Now, yes, memory cgroup doesn't account root cgroup
and doesn't update res->usage to avoid updating shared counter overheads
when memcg is not mounted. But memory.usage_in_bytes files works
for root memcg with reading percpu statistics.

So, how about counting usage for root cgroup even if it cannot be limited ?
Considering hugetlb fs usage, updating res_counter here doesn't have
performance problem of false sharing..
Then, you can remove root_mem_cgroup() checks inserted several places.

<snip>

>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> +	/*
> +	 * Don't allow memcg removal if we have HugeTLB resource
> +	 * usage.
> +	 */
> +	if (mem_cgroup_have_hugetlb_usage(memcg))
> +		return -EBUSY;
>  
>  	return mem_cgroup_force_empty(memcg, false);
>  }


Is this fixed by patch 8+9 ?



Thanks,
-Kame

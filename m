From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
Date: Wed, 28 Mar 2012 13:33:04 +0200
Message-ID: <20120328113304.GE20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1331919570-2264-5-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 16-03-12 23:09:24, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This patch implements a memcg extension that allows us to control
> HugeTLB allocations via memory controller.

And the infrastructure is not used at this stage (you forgot to
mention).
The changelog should be much more descriptive.

> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  include/linux/hugetlb.h    |    1 +
>  include/linux/memcontrol.h |   42 +++++++++++++
>  init/Kconfig               |    8 +++
>  mm/hugetlb.c               |    2 +-
>  mm/memcontrol.c            |  138 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 190 insertions(+), 1 deletions(-)
> 
[...]
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

How does it interact with the hard/soft limists etc...

[...]
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

Maybe we should expose for_each_hstate as well...

> +		if (memcg->hugepage[idx].usage > 0)
> +			return 1;
> +	}
> +	return 0;
> +}
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
> +	if (!css_tryget(&memcg->css)) {
> +		rcu_read_unlock();
> +		goto again;
> +	}
> +	rcu_read_unlock();
> +
> +	ret = res_counter_charge(&memcg->hugepage[idx], csize, &fail_res);
> +	css_put(&memcg->css);
> +done:
> +	*ptr = memcg;

Why do we set ptr even for the failure case after we dropped a
reference?

> +	return ret;
> +}
> +
> +void mem_cgroup_hugetlb_commit_charge(int idx, unsigned long nr_pages,
> +				      struct mem_cgroup *memcg,
> +				      struct page *page)
> +{
> +	struct page_cgroup *pc;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	pc = lookup_page_cgroup(page);
> +	lock_page_cgroup(pc);
> +	if (unlikely(PageCgroupUsed(pc))) {
> +		unlock_page_cgroup(pc);
> +		mem_cgroup_hugetlb_uncharge_memcg(idx, nr_pages, memcg);
> +		return;
> +	}
> +	pc->mem_cgroup = memcg;
> +	/*
> +	 * We access a page_cgroup asynchronously without lock_page_cgroup().
> +	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
> +	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
> +	 * before USED bit, we need memory barrier here.
> +	 * See mem_cgroup_add_lru_list(), etc.
> +	 */
> +	smp_wmb();

Is this really necessary for hugetlb pages as well?

> +	SetPageCgroupUsed(pc);
> +
> +	unlock_page_cgroup(pc);
> +	return;
> +}
> +
[...]
> @@ -4887,6 +5013,7 @@ err_cleanup:
>  static struct cgroup_subsys_state * __ref
>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  {
> +	int idx;
>  	struct mem_cgroup *memcg, *parent;
>  	long error = -ENOMEM;
>  	int node;
> @@ -4929,9 +5056,14 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  		 * mem_cgroup(see mem_cgroup_put).
>  		 */
>  		mem_cgroup_get(parent);
> +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)

Do we have to init all hstates or is hugetlb_max_hstate enough?

> +			res_counter_init(&memcg->hugepage[idx],
> +					 &parent->hugepage[idx]);
>  	} else {
>  		res_counter_init(&memcg->res, NULL);
>  		res_counter_init(&memcg->memsw, NULL);
> +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
> +			res_counter_init(&memcg->hugepage[idx], NULL);

Same here
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

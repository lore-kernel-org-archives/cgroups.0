From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in move_parent
Date: Mon, 30 Apr 2012 14:30:10 +0530
Message-ID: <87vckh8uhx.fsf@skywalker.in.ibm.com>
References: <4F9A327A.6050409@jp.fujitsu.com> <4F9A34B2.8080103@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9A34B2.8080103-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-mm@kvack.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups@vger.kernel.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> writes:

> By using res_counter_uncharge_until(), we can avoid 
> unnecessary charging.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> ---
>  mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 42 insertions(+), 21 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 613bb15..ed53d64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>  }
>
>  /*
> + * Cancel chages in this cgroup....doesn't propagates to parent cgroup.
> + * This is useful when moving usage to parent cgroup.
> + */
> +static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
> +					unsigned int nr_pages)
> +{
> +	if (!mem_cgroup_is_root(memcg)) {
> +		unsigned long bytes = nr_pages * PAGE_SIZE;
> +
> +		res_counter_uncharge_until(&memcg->res,
> +					memcg->res.parent, bytes);
> +		if (do_swap_account)
> +			res_counter_uncharge_until(&memcg->memsw,
> +						memcg->memsw.parent, bytes);
> +	}
> +}
> +
> +/*
>   * A helper function to get mem_cgroup from ID. must be called under
>   * rcu_read_lock(). The caller must check css_is_removed() or some if
>   * it's concern. (dropping refcnt from swap can be called against removed
> @@ -2677,16 +2695,28 @@ static int mem_cgroup_move_parent(struct page *page,
>  	nr_pages = hpage_nr_pages(page);
>
>  	parent = mem_cgroup_from_cont(pcg);
> -	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
> -	if (ret)
> -		goto put_back;
> +	if (!parent->use_hierarchy) {
> +		ret = __mem_cgroup_try_charge(NULL,
> +					gfp_mask, nr_pages, &parent, false);
> +		if (ret)
> +			goto put_back;
> +	}
>
>  	if (nr_pages > 1)
>  		flags = compound_lock_irqsave(page);
>
> -	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent, true);
> -	if (ret)
> -		__mem_cgroup_cancel_charge(parent, nr_pages);
> +	if (parent->use_hierarchy) {
> +		ret = mem_cgroup_move_account(page, nr_pages,
> +					pc, child, parent, false);
> +		if (!ret)
> +			__mem_cgroup_cancel_local_charge(child, nr_pages);
> +	} else {
> +		ret = mem_cgroup_move_account(page, nr_pages,
> +					pc, child, parent, true);
> +
> +		if (ret)
> +			__mem_cgroup_cancel_charge(parent, nr_pages);
> +	}
>

May be a comment around this ? I had to look closer to find why
there is a if (!ret) and if (ret) difference. 


>  	if (nr_pages > 1)
>  		compound_unlock_irqrestore(page, flags);
> @@ -3295,6 +3325,7 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  	struct cgroup *pcgrp = cgroup->parent;
>  	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
>  	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
> +	struct res_counter *counter;
>
>  	if (!get_page_unless_zero(page))
>  		goto out;
> @@ -3305,28 +3336,18 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  		goto err_out;
>
>  	csize = PAGE_SIZE << compound_order(page);
> -	/*
> -	 * If we have use_hierarchy set we can never fail here. So instead of
> -	 * using res_counter_uncharge use the open-coded variant which just
> -	 * uncharge the child res_counter. The parent will retain the charge.
> -	 */
> -	if (parent->use_hierarchy) {
> -		unsigned long flags;
> -		struct res_counter *counter;
> -
> -		counter = &memcg->hugepage[idx];
> -		spin_lock_irqsave(&counter->lock, flags);
> -		res_counter_uncharge_locked(counter, csize);
> -		spin_unlock_irqrestore(&counter->lock, flags);
> -	} else {
> +	/* If parent->use_hierarchy == 0, we need to charge parent */
> +	if (!parent->use_hierarchy) {
>  		ret = res_counter_charge(&parent->hugepage[idx],
>  					 csize, &fail_res);
>  		if (ret) {
>  			ret = -EBUSY;
>  			goto err_out;
>  		}
> -		res_counter_uncharge(&memcg->hugepage[idx], csize);
>  	}
> +	counter = &memcg->hugepage[idx];
> +	res_counter_uncharge_until(counter, counter->parent, csize);
> +
>  	pc->mem_cgroup = parent;
>  err_out:
>  	unlock_page_cgroup(pc);

-aneesh

From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Mon, 12 Jul 2021 09:15:12 +0200
Message-ID: <YOvsAG+F0n2U3c88@dhcp22.suse.cz>
References: <20210710003626.3549282-1-surenb@google.com>
 <20210710003626.3549282-2-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626074113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nfjwK/c5toDCy+hVqPWw4iw9nu/0zDGXvy8gkOkPyNU=;
        b=WIcQAWDGS4Wj8T5V/94IuYtC1/UjmNZsz4tZ7w7G80jzqek6iOfqjCCPSujb5g8a3ZQ1a0
        gFrnshQwS8T1JJT9wfL055rd6swgDhnku8ic0icAB3l4BZWIWR0Ej4bBz9dSvgU8zHgVs1
        jKorAdrvSwkY/G/cDbJ3TJgFY3l/pyI=
Content-Disposition: inline
In-Reply-To: <20210710003626.3549282-2-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Fri 09-07-21 17:36:25, Suren Baghdasaryan wrote:
> Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
> functions to perform mem_cgroup_disabled static key check inline before
> calling the main body of the function. This minimizes the memcg overhead
> in the pagefault and exit_mmap paths when memcgs are disabled using
> cgroup_disable=memory command-line option.
> This change results in ~0.4% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> configurationon on an 8-core ARM64 Android device.
> 
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

With doc updated as suggested by Muchun Song
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  include/linux/memcontrol.h | 28 +++++++++++++++++++++++++---
>  mm/memcontrol.c            | 29 ++++++++++-------------------
>  2 files changed, 35 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index bfe5c486f4ad..39fa88051a42 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -693,13 +693,35 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
>  		page_counter_read(&memcg->memory);
>  }
>  
> -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> +int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +			gfp_t gfp_mask);
> +static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +				    gfp_t gfp_mask)
> +{
> +	if (mem_cgroup_disabled())
> +		return 0;
> +	return __mem_cgroup_charge(page, mm, gfp_mask);
> +}
> +
>  int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
>  				  gfp_t gfp, swp_entry_t entry);
>  void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
>  
> -void mem_cgroup_uncharge(struct page *page);
> -void mem_cgroup_uncharge_list(struct list_head *page_list);
> +void __mem_cgroup_uncharge(struct page *page);
> +static inline void mem_cgroup_uncharge(struct page *page)
> +{
> +	if (mem_cgroup_disabled())
> +		return;
> +	__mem_cgroup_uncharge(page);
> +}
> +
> +void __mem_cgroup_uncharge_list(struct list_head *page_list);
> +static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
> +{
> +	if (mem_cgroup_disabled())
> +		return;
> +	__mem_cgroup_uncharge_list(page_list);
> +}
>  
>  void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a228cd51c4bd..cdaf7003b43d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6701,8 +6701,7 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>  			atomic_long_read(&parent->memory.children_low_usage)));
>  }
>  
> -static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> -			       gfp_t gfp)
> +static int charge_memcg(struct page *page, struct mem_cgroup *memcg, gfp_t gfp)
>  {
>  	unsigned int nr_pages = thp_nr_pages(page);
>  	int ret;
> @@ -6723,7 +6722,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
>  }
>  
>  /**
> - * mem_cgroup_charge - charge a newly allocated page to a cgroup
> + * __mem_cgroup_charge - charge a newly allocated page to a cgroup
>   * @page: page to charge
>   * @mm: mm context of the victim
>   * @gfp_mask: reclaim mode
> @@ -6736,16 +6735,14 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
>   *
>   * Returns 0 on success. Otherwise, an error code is returned.
>   */
> -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
> +int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +			gfp_t gfp_mask)
>  {
>  	struct mem_cgroup *memcg;
>  	int ret;
>  
> -	if (mem_cgroup_disabled())
> -		return 0;
> -
>  	memcg = get_mem_cgroup_from_mm(mm);
> -	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
> +	ret = charge_memcg(page, memcg, gfp_mask);
>  	css_put(&memcg->css);
>  
>  	return ret;
> @@ -6780,7 +6777,7 @@ int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
>  		memcg = get_mem_cgroup_from_mm(mm);
>  	rcu_read_unlock();
>  
> -	ret = __mem_cgroup_charge(page, memcg, gfp);
> +	ret = charge_memcg(page, memcg, gfp);
>  
>  	css_put(&memcg->css);
>  	return ret;
> @@ -6916,18 +6913,15 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>  }
>  
>  /**
> - * mem_cgroup_uncharge - uncharge a page
> + * __mem_cgroup_uncharge - uncharge a page
>   * @page: page to uncharge
>   *
>   * Uncharge a page previously charged with mem_cgroup_charge().
>   */
> -void mem_cgroup_uncharge(struct page *page)
> +void __mem_cgroup_uncharge(struct page *page)
>  {
>  	struct uncharge_gather ug;
>  
> -	if (mem_cgroup_disabled())
> -		return;
> -
>  	/* Don't touch page->lru of any random page, pre-check: */
>  	if (!page_memcg(page))
>  		return;
> @@ -6938,20 +6932,17 @@ void mem_cgroup_uncharge(struct page *page)
>  }
>  
>  /**
> - * mem_cgroup_uncharge_list - uncharge a list of page
> + * __mem_cgroup_uncharge_list - uncharge a list of page
>   * @page_list: list of pages to uncharge
>   *
>   * Uncharge a list of pages previously charged with
>   * mem_cgroup_charge().
>   */
> -void mem_cgroup_uncharge_list(struct list_head *page_list)
> +void __mem_cgroup_uncharge_list(struct list_head *page_list)
>  {
>  	struct uncharge_gather ug;
>  	struct page *page;
>  
> -	if (mem_cgroup_disabled())
> -		return;
> -
>  	uncharge_gather_clear(&ug);
>  	list_for_each_entry(page, page_list, lru)
>  		uncharge_page(page, &ug);
> -- 
> 2.32.0.93.g670b81a890-goog

-- 
Michal Hocko
SUSE Labs

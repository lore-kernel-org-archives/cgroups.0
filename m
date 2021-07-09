From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Fri, 9 Jul 2021 10:48:48 -0400
Message-ID: <YOhh0IabpRk/W/qR@cmpxchg.org>
References: <20210709000509.2618345-1-surenb@google.com>
 <20210709000509.2618345-3-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zc2BPQuzaGpps9hYR6A1SS6spRlObwvCzaY7uIl0fFs=;
        b=JjjnbfYvxPo1NWSBJyvtgC3bk+XjiBXa9XnURKljN5acQnzH15vHkDQMcFUrMK1kKy
         dllvEWiXreEpZ2IYRdzBgVDviwe/+oDhuJ+32k7xARC6sIYWxqYM47UBp/Jr2KMNe/im
         Yv1AaH5yzrL2BdSCcFsOcnLsrzO9jBE5in/utMROdxyYfh83hIDL0edY5lWunZJz4qRL
         jNzVXVUCxw6Wkf51faXzwe6+bYtOPb6hmCIqBp5dsq1c+zYiFrRDb72JlDhrA/BWwgSz
         obYUN0vGYbcCmC9EWi6WCsqUSZdvbUh5wwq6Th1zP1Jr74QYDo0ogJBNdI143IfDTXXH
         LUCw==
Content-Disposition: inline
In-Reply-To: <20210709000509.2618345-3-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Thu, Jul 08, 2021 at 05:05:08PM -0700, Suren Baghdasaryan wrote:
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

Sounds reasonable to me as well. One comment:

> @@ -693,13 +693,59 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
>  		page_counter_read(&memcg->memory);
>  }
>  
> -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> +struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
> +
> +int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> +			gfp_t gfp);
> +/**
> + * mem_cgroup_charge - charge a newly allocated page to a cgroup
> + * @page: page to charge
> + * @mm: mm context of the victim
> + * @gfp_mask: reclaim mode
> + *
> + * Try to charge @page to the memcg that @mm belongs to, reclaiming
> + * pages according to @gfp_mask if necessary. if @mm is NULL, try to
> + * charge to the active memcg.
> + *
> + * Do not use this for pages allocated for swapin.
> + *
> + * Returns 0 on success. Otherwise, an error code is returned.
> + */
> +static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +				    gfp_t gfp_mask)
> +{
> +	struct mem_cgroup *memcg;
> +	int ret;
> +
> +	if (mem_cgroup_disabled())
> +		return 0;
> +
> +	memcg = get_mem_cgroup_from_mm(mm);
> +	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
> +	css_put(&memcg->css);
> +
> +	return ret;

Why not do

int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
			gfp_t gfp_mask);

static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
				    gfp_t gfp_mask)
{
	if (mem_cgroup_disabled())
		return 0;

	return __mem_cgroup_charge(page, memcg, gfp_mask);
}

like in the other cases as well?

That would avoid inlining two separate function calls into all the
callsites...

There is an (internal) __mem_cgroup_charge() already, but you can
rename it charge_memcg().


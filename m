From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 3/8] hugetlb_cgroup: add reservation accounting for
 private mappings
Date: Wed, 29 Jan 2020 13:28:19 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001291323270.175731@chino.kir.corp.google.com>
References: <20200115012651.228058-1-almasrymina@google.com> <20200115012651.228058-3-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=6QHSV0epbJ5GjLnwh0+RSWrqsLLDJlBBjEbhEIImewk=;
        b=ENiOsZ0f46TX6ufRsYGjsJNC8xCpWbLhi4TIyRcHHUP+Ia4FhbXMIXnWxgTOibbyIY
         8S45r25tALWzmwgpFNbGezbFftN93GkVD4s+qgI8tz+915haHocfcpQAFQEmPcI7aVaj
         kCAZXT1Sxy98pIbdeLlzBTBF6SOrsilyw4s+Fc6lRzaGpSrf0WwbTlquO5FUJ+G1Ma0u
         e9TKZAC7JHJkc6Ua88CdqkK5DfKKLR7mJmLfKGJpNnboOFtnHexCda86j9FhClhQYEIT
         yuyR9rDmK72Zao5ti4A1Ts/Nc9i9md5i/3qGwjAW7jyQ1DW6D0Eh42o12gjW1kH7EDwi
         kAbQ==
In-Reply-To: <20200115012651.228058-3-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

On Tue, 14 Jan 2020, Mina Almasry wrote:

> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index dea6143aa0685..5491932ea5758 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -46,6 +46,16 @@ struct resv_map {
>  	long adds_in_progress;
>  	struct list_head region_cache;
>  	long region_cache_count;
> +#ifdef CONFIG_CGROUP_HUGETLB
> +	/*
> +	 * On private mappings, the counter to uncharge reservations is stored
> +	 * here. If these fields are 0, then either the mapping is shared, or
> +	 * cgroup accounting is disabled for this resv_map.
> +	 */
> +	struct page_counter *reservation_counter;
> +	unsigned long pages_per_hpage;
> +	struct cgroup_subsys_state *css;
> +#endif
>  };
>  extern struct resv_map *resv_map_alloc(void);
>  void resv_map_release(struct kref *ref);
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index eab8a70d5bcb5..8c320accefe87 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -25,6 +25,33 @@ struct hugetlb_cgroup;
>  #define HUGETLB_CGROUP_MIN_ORDER	2
> 
>  #ifdef CONFIG_CGROUP_HUGETLB
> +enum hugetlb_memory_event {
> +	HUGETLB_MAX,
> +	HUGETLB_NR_MEMORY_EVENTS,
> +};
> +
> +struct hugetlb_cgroup {
> +	struct cgroup_subsys_state css;
> +
> +	/*
> +	 * the counter to account for hugepages from hugetlb.
> +	 */
> +	struct page_counter hugepage[HUGE_MAX_HSTATE];
> +
> +	/*
> +	 * the counter to account for hugepage reservations from hugetlb.
> +	 */
> +	struct page_counter reserved_hugepage[HUGE_MAX_HSTATE];
> +
> +	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
> +	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
> +
> +	/* Handle for "hugetlb.events" */
> +	struct cgroup_file events_file[HUGE_MAX_HSTATE];
> +
> +	/* Handle for "hugetlb.events.local" */
> +	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
> +};
> 
>  static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page,
>  							      bool reserved)
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 62a4cf3db4090..f1b63946ee95c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -666,6 +666,17 @@ struct resv_map *resv_map_alloc(void)
>  	INIT_LIST_HEAD(&resv_map->regions);
> 
>  	resv_map->adds_in_progress = 0;
> +#ifdef CONFIG_CGROUP_HUGETLB
> +	/*
> +	 * Initialize these to 0. On shared mappings, 0's here indicate these
> +	 * fields don't do cgroup accounting. On private mappings, these will be
> +	 * re-initialized to the proper values, to indicate that hugetlb cgroup
> +	 * reservations are to be un-charged from here.
> +	 */
> +	resv_map->reservation_counter = NULL;
> +	resv_map->pages_per_hpage = 0;
> +	resv_map->css = NULL;
> +#endif

Might be better to extract out a resv_map_init() that does the 
initialization when CONFIG_CGROUP_HUGETLB is enabled?  Could be used here 
as well as hugetlb_reserve_pages().

> 
>  	INIT_LIST_HEAD(&resv_map->region_cache);
>  	list_add(&rg->link, &resv_map->region_cache);
> @@ -3194,7 +3205,11 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
> 
>  	reserve = (end - start) - region_count(resv, start, end);
> 
> -	kref_put(&resv->refs, resv_map_release);
> +#ifdef CONFIG_CGROUP_HUGETLB
> +	hugetlb_cgroup_uncharge_counter(resv->reservation_counter,
> +					(end - start) * resv->pages_per_hpage,
> +					resv->css);
> +#endif
> 
>  	if (reserve) {
>  		/*

Mike has given is Reviewed-by so likely not a big concern for the generic 
hugetlb code, but I was wondering if we can reduce the number of #ifdef's 
if we defined a CONFIG_CGROUP_HUGETLB helper to take the resv, end, and 
start?  If CONFIG_CGROUP_HUGETLB is defined, it converts into the above, 
otherwise it's a no-op and we don't run into any compile errors because we 
are accessing fields that don't exist without the option.

Otherwise looks good!

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

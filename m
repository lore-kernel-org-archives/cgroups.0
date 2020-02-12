From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: vmscan: detect file thrashing at the reclaim root
Date: Wed, 12 Feb 2020 19:28:19 +0900
Message-ID: <20200212102817.GA18107@js1304-desktop>
References: <20191107205334.158354-1-hannes@cmpxchg.org>
 <20191107205334.158354-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qrIu8Jkz2wpM8W+TP78G0aZpBZ0BfsPMDbCMB5VExMA=;
        b=ocN5cXNduPet9cp95r3WX9wfcOziPCbCA38D+muLWQZxVfN+cKGWIRGGpDKAl2qa/V
         wIF3jMZOaR5DiOYtF2+HFK7aLBBZMyw1DpAqrNqVBjeN35IFK7mm4ntm2DmiKH0A62zz
         19rTmJECA3NVqEaNP5Z+vx+fFUd7V7WNo/RTwtDu1QgoFIKJjY9+tH+Go+fopGDoGidd
         ZxHrEZ1gtfYY/0stPSVHsl3ViE+mg0GM4SLr7PM11zXODfuEcGEsJ1xUyDSkm4m1HAaX
         UuqQkdj0N2i4AWMCWbJCvLMwObhxld4Uw07ShioK14zNBX+u50AtDypMP3WGMCbO3C5V
         8k1w==
Content-Disposition: inline
In-Reply-To: <20191107205334.158354-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Johannes.

When I tested my patchset on v5.5, I found that my patchset doesn't
work as intended. I tracked down the issue and this patch would be the
reason of unintended work. I don't fully understand the patchset so I
could be wrong. Please let me ask some questions.

On Thu, Nov 07, 2019 at 12:53:33PM -0800, Johannes Weiner wrote:
...snip...
> -static void snapshot_refaults(struct mem_cgroup *root_memcg, pg_data_t *pgdat)
> +static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
>  {
> -	struct mem_cgroup *memcg;
> -
> -	memcg = mem_cgroup_iter(root_memcg, NULL, NULL);
> -	do {
> -		unsigned long refaults;
> -		struct lruvec *lruvec;
> +	struct lruvec *target_lruvec;
> +	unsigned long refaults;
>  
> -		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -		refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
> -		lruvec->refaults = refaults;
> -	} while ((memcg = mem_cgroup_iter(root_memcg, memcg, NULL)));
> +	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
> +	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE);
> +	target_lruvec->refaults = refaults;

Is it correct to just snapshot the refault for the target memcg? I
think that we need to snapshot the refault for all the child memcgs
since we have traversed all the child memcgs with the refault count
that is aggregration of all the child memcgs. If next reclaim happens
from the child memcg, workingset transition that is already considered
could be considered again.

>  }
>  
>  /*
> diff --git a/mm/workingset.c b/mm/workingset.c
> index e8212123c1c3..f0885d9f41cd 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -213,28 +213,53 @@ static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
>  	*workingsetp = workingset;
>  }
>  
> +static void advance_inactive_age(struct mem_cgroup *memcg, pg_data_t *pgdat)
> +{
> +	/*
> +	 * Reclaiming a cgroup means reclaiming all its children in a
> +	 * round-robin fashion. That means that each cgroup has an LRU
> +	 * order that is composed of the LRU orders of its child
> +	 * cgroups; and every page has an LRU position not just in the
> +	 * cgroup that owns it, but in all of that group's ancestors.
> +	 *
> +	 * So when the physical inactive list of a leaf cgroup ages,
> +	 * the virtual inactive lists of all its parents, including
> +	 * the root cgroup's, age as well.
> +	 */
> +	do {
> +		struct lruvec *lruvec;
> +
> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +		atomic_long_inc(&lruvec->inactive_age);
> +	} while (memcg && (memcg = parent_mem_cgroup(memcg)));
> +}
> +
>  /**
>   * workingset_eviction - note the eviction of a page from memory
> + * @target_memcg: the cgroup that is causing the reclaim
>   * @page: the page being evicted
>   *
>   * Returns a shadow entry to be stored in @page->mapping->i_pages in place
>   * of the evicted @page so that a later refault can be detected.
>   */
> -void *workingset_eviction(struct page *page)
> +void *workingset_eviction(struct page *page, struct mem_cgroup *target_memcg)
>  {
>  	struct pglist_data *pgdat = page_pgdat(page);
> -	struct mem_cgroup *memcg = page_memcg(page);
> -	int memcgid = mem_cgroup_id(memcg);
>  	unsigned long eviction;
>  	struct lruvec *lruvec;
> +	int memcgid;
>  
>  	/* Page is fully exclusive and pins page->mem_cgroup */
>  	VM_BUG_ON_PAGE(PageLRU(page), page);
>  	VM_BUG_ON_PAGE(page_count(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  
> -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	eviction = atomic_long_inc_return(&lruvec->inactive_age);
> +	advance_inactive_age(page_memcg(page), pgdat);
> +
> +	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
> +	/* XXX: target_memcg can be NULL, go through lruvec */
> +	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
> +	eviction = atomic_long_read(&lruvec->inactive_age);
>  	return pack_shadow(memcgid, pgdat, eviction, PageWorkingset(page));
>  }
>  
> @@ -244,10 +269,13 @@ void *workingset_eviction(struct page *page)
>   * @shadow: shadow entry of the evicted page
>   *
>   * Calculates and evaluates the refault distance of the previously
> - * evicted page in the context of the node it was allocated in.
> + * evicted page in the context of the node and the memcg whose memory
> + * pressure caused the eviction.
>   */
>  void workingset_refault(struct page *page, void *shadow)
>  {
> +	struct mem_cgroup *eviction_memcg;
> +	struct lruvec *eviction_lruvec;
>  	unsigned long refault_distance;
>  	struct pglist_data *pgdat;
>  	unsigned long active_file;
> @@ -277,12 +305,12 @@ void workingset_refault(struct page *page, void *shadow)
>  	 * would be better if the root_mem_cgroup existed in all
>  	 * configurations instead.
>  	 */
> -	memcg = mem_cgroup_from_id(memcgid);
> -	if (!mem_cgroup_disabled() && !memcg)
> +	eviction_memcg = mem_cgroup_from_id(memcgid);
> +	if (!mem_cgroup_disabled() && !eviction_memcg)
>  		goto out;
> -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	refault = atomic_long_read(&lruvec->inactive_age);
> -	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES);
> +	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
> +	refault = atomic_long_read(&eviction_lruvec->inactive_age);
> +	active_file = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);

Do we need to use the aggregation LRU count of all the child memcgs?
AFAIU, refault here is the aggregation counter of all the related
memcgs. Without using the aggregation count for LRU, active_file could
be so small than the refault distance and refault cannot happen
correctly.

Thanks.

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: check references from all memcgs for
 swapbacked memory
Date: Wed, 5 Oct 2022 10:04:05 -0400
Message-ID: <Yz2O1dGeBGBTh6SM@cmpxchg.org>
References: <20221004233446.787056-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=FXi0XoAQOBYrGesfkJtJr1D/6fSwUi+ciVYcxjp3MmE=;
        b=mJHIld8cSRSCYaAW4MMM2N5yWGRlbk2nS1p0K7//H9ccXyb44BcbTd5JtB+mm91SHc
         vj4bKWYfab3HIaX1/tARDmcGIzlgnXluW22totZD2rYJHXsO53Ld0KGtv4vDjlHyvPgc
         3h+0Z0GJG709ND7TPCiWA8Jl0OKqaVCJXUu5rLUK7hIrff6saZStgRN01tRn/upSvqRY
         ZLTSDrP0oEm9eagXypT89rzH+C0lLbywPuE/sIzA157xwrOa2+dK8MGvO2cNgJfGKkGy
         MIqr4F3cSF0X2KflYeEwEBag+4GX52eT00MimlhMUH8EdhC7N2gXHX8jIa2e/AqbJ7rb
         zDmg==
Content-Disposition: inline
In-Reply-To: <20221004233446.787056-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi Yosry,

On Tue, Oct 04, 2022 at 11:34:46PM +0000, Yosry Ahmed wrote:
> During page/folio reclaim, we check folio is referenced using
> folio_referenced() to avoid reclaiming folios that have been recently
> accessed (hot memory). The ratinale is that this memory is likely to be
> accessed soon, and hence reclaiming it will cause a refault.
> 
> For memcg reclaim, we pass in sc->target_mem_cgroup to
> folio_referenced(), which means we only check accesses to the folio
> from processes in the subtree of the target memcg. This behavior was
> originally introduced by commit bed7161a519a ("Memory controller: make
> page_referenced() cgroup aware") a long time ago. Back then, refaulted
> pages would get charged to the memcg of the process that was faulting them
> in. It made sense to only consider accesses coming from processes in the
> subtree of target_mem_cgroup. If a page was charged to memcg A but only
> being accessed by a sibling memcg B, we would reclaim it if memcg A is
> under pressure. memcg B can then fault it back in and get charged for it
> appropriately.
> 
> Today, this behavior still makes sense for file pages. However, unlike
> file pages, when swapbacked pages are refaulted they are charged to the
> memcg that was originally charged for them during swapout. Which
> means that if a swapbacked page is charged to memcg A but only used by
> memcg B, and we reclaim it when memcg A is under pressure, it would
> simply be faulted back in and charged again to memcg A once memcg B
> accesses it. In that sense, accesses from all memcgs matter equally when
> considering if a swapbacked page/folio is a viable reclaim target.
> 
> Add folio_referenced_memcg() which decides what memcg we should pass to
> folio_referenced() based on the folio type, and includes an elaborate
> comment about why we should do so. This should help reclaim make better
> decision and reduce refaults when reclaiming swapbacked memory that is
> used by multiple memcgs.

Great observation, and I agree with this change.

Just one nitpick:

> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/vmscan.c | 38 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c5a4bff11da6..f9fa0f9287e5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1443,14 +1443,43 @@ enum folio_references {
>  	FOLIOREF_ACTIVATE,
>  };
>  
> +/* What memcg should we pass to folio_referenced()? */
> +static struct mem_cgroup *folio_referenced_memcg(struct folio *folio,
> +						 struct mem_cgroup *target_memcg)
> +{
> +	/*
> +	 * We check references to folios to make sure we don't reclaim hot
> +	 * folios that are likely to be refaulted soon. We pass a memcg to
> +	 * folio_referenced() to only check references coming from processes in
> +	 * that memcg's subtree.
> +	 *
> +	 * For file folios, we only consider references from processes in the
> +	 * subtree of the target memcg. If a folio is charged to
> +	 * memcg A but is only referenced by processes in memcg B, we reclaim it
> +	 * if memcg A is under pressure. If it is later accessed by memcg B it
> +	 * will be faulted back in and charged to memcg B. For memcg A, this is
> +	 * called memory that should be reclaimed.
> +	 *
> +	 * On the other hand, when swapbacked folios are faulted in, they get
> +	 * charged to the memcg that was originally charged for them at the time
> +	 * of swapping out. This means that if a folio that is charged to
> +	 * memcg A gets swapped out, it will get charged back to A when *any*
> +	 * memcg accesses it. In that sense, we need to consider references from
> +	 * *all* processes when considering whether to reclaim a swapbacked
> +	 * folio.
> +	 */
> +	return folio_test_swapbacked(folio) ? NULL : target_memcg;
> +}
> +
>  static enum folio_references folio_check_references(struct folio *folio,
>  						  struct scan_control *sc)
>  {
>  	int referenced_ptes, referenced_folio;
>  	unsigned long vm_flags;
> +	struct mem_cgroup *memcg = folio_referenced_memcg(folio,
> +						sc->target_mem_cgroup);
>  
> -	referenced_ptes = folio_referenced(folio, 1, sc->target_mem_cgroup,
> -					   &vm_flags);
> +	referenced_ptes = folio_referenced(folio, 1, memcg, &vm_flags);
>  	referenced_folio = folio_test_clear_referenced(folio);
>  
>  	/*
> @@ -2581,6 +2610,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  
>  	while (!list_empty(&l_hold)) {
>  		struct folio *folio;
> +		struct mem_cgroup *memcg;
>  
>  		cond_resched();
>  		folio = lru_to_folio(&l_hold);
> @@ -2600,8 +2630,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  		}
>  
>  		/* Referenced or rmap lock contention: rotate */
> -		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
> -				     &vm_flags) != 0) {
> +		memcg = folio_referenced_memcg(folio, sc->target_mem_cgroup);
> +		if (folio_referenced(folio, 0, memcg, &vm_flags) != 0) {

Would you mind moving this to folio_referenced() directly? There is
already a comment and branch in there that IMO would extend quite
naturally to cover the new exception:

	/*
	 * If we are reclaiming on behalf of a cgroup, skip
	 * counting on behalf of references from different
	 * cgroups
	 */
	if (memcg) {
		rwc.invalid_vma = invalid_folio_referenced_vma;
	}

That would keep the decision-making and doc in one place.

Thanks!
Johannnes

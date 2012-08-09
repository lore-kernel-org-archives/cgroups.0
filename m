From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 07/11] mm: Allocate kernel pages to the right memcg
Date: Thu, 09 Aug 2012 09:33:03 -0700
Message-ID: <xr93boikgh4w.fsf@gthelen.mtv.corp.google.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-8-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=ig8wKLsIfsS1SYQ15EOzxGz3tVUM0bJyETkN3Ey+YXI=;
        b=mnZY8g125xz7h13RU/oTS3NicCK6752E1QjpPJvl0sAkDIlths5Q70sv/G+vBkvIst
         fvmk5e8TgFJErlDx1NHSdHrXnNrSMkZWrhaapSFe9JIOHc0bnZ2zcI6tZRfYzyTteO2U
         RoqM6o6gVEBZJ4rmfA4w4fHCCarViy5BXlrcUzm13/X/fiomk+ia0u52YAN7D1QeV8Qp
         fY1T53tGVAEYyTL7XQSOfSW/hhS3EUvnJE4DC+jBh4rPPEQsW05zYrck3iAQKp2wJax+
         Ywll6igD2SZVfiYBP07j/1nXI6Io0wIcQIOgIHeU0cgpkJdLr2T8TgtiVY6sU4rI3RfM
         G16g==
In-Reply-To: <1344517279-30646-8-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
	(Glauber Costa's message of "Thu, 9 Aug 2012 17:01:15 +0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 09 2012, Glauber Costa wrote:

> When a process tries to allocate a page with the __GFP_KMEMCG flag, the
> page allocator will call the corresponding memcg functions to validate
> the allocation. Tasks in the root memcg can always proceed.
>
> To avoid adding markers to the page - and a kmem flag that would
> necessarily follow, as much as doing page_cgroup lookups for no reason,
> whoever is marking its allocations with __GFP_KMEMCG flag is responsible
> for telling the page allocator that this is such an allocation at
> free_pages() time. This is done by the invocation of
> __free_accounted_pages() and free_accounted_pages().
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/gfp.h |  3 +++
>  mm/page_alloc.c     | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index d8eae4d..029570f 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -370,6 +370,9 @@ extern void free_pages(unsigned long addr, unsigned int order);
>  extern void free_hot_cold_page(struct page *page, int cold);
>  extern void free_hot_cold_page_list(struct list_head *list, int cold);
>  
> +extern void __free_accounted_pages(struct page *page, unsigned int order);
> +extern void free_accounted_pages(unsigned long addr, unsigned int order);
> +
>  #define __free_page(page) __free_pages((page), 0)
>  #define free_page(addr) free_pages((addr), 0)
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b956cec..da341dc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2532,6 +2532,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	struct page *page = NULL;
>  	int migratetype = allocflags_to_migratetype(gfp_mask);
>  	unsigned int cpuset_mems_cookie;
> +	void *handle = NULL;
>  
>  	gfp_mask &= gfp_allowed_mask;
>  
> @@ -2543,6 +2544,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  		return NULL;
>  
>  	/*
> +	 * Will only have any effect when __GFP_KMEMCG is set.
> +	 * This is verified in the (always inline) callee
> +	 */
> +	if (!memcg_kmem_new_page(gfp_mask, &handle, order))
> +		return NULL;
> +
> +	/*
>  	 * Check the zones suitable for the gfp_mask contain at least one
>  	 * valid zone. It's possible to have an empty zonelist as a result
>  	 * of GFP_THISNODE and a memoryless node

If memcg_kmem_new_page() succeeds then it may have obtained a memcg
reference with mem_cgroup_get().  I think this reference is leaked when
returning below:

	/*
	 * Check the zones suitable for the gfp_mask contain at least one
	 * valid zone. It's possible to have an empty zonelist as a result
	 * of GFP_THISNODE and a memoryless node
	 */
	if (unlikely(!zonelist->_zonerefs->zone))
		return NULL;

I suspect the easiest fix is to swap the call to memcg_kmem_new_page()
and the (!zonelist->_zonerefs->zone) check.

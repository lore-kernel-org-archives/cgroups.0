From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] memcg: page_alloc: skip bulk allocator for
 __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 09:13:43 -0700
Message-ID: <YWhXN8PPVq0oy2u/@carbon.DHCP.thefacebook.com>
References: <20211014151607.2171970-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+QxXeGrVygVIkPEaalUtqiu/MljAZOc12wdYnQ3/KUQ=;
 b=q69oNqhOzwUsA0tUGN+3Ger85ZzdxgR2f+LjvQqXU02X8VMWXUClI8EMYdCHkaPJtCng
 ApLN1f7blmLr9bLGdXeFCeol9EU2KvEnXP6AoO+rktBPEQJOFXYWVOD3NXdl8EL/WmAQ
 wkM/akdhcHqMDaaXqYQfj3pxKz5VRrqceyU= 
Content-Disposition: inline
In-Reply-To: <20211014151607.2171970-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 14, 2021 at 08:16:07AM -0700, Shakeel Butt wrote:
> The commit 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in
> __vmalloc_area_node()") switched to bulk page allocator for order 0
> allocation backing vmalloc. However bulk page allocator does not support
> __GFP_ACCOUNT allocations and there are several users of
> kvmalloc(__GFP_ACCOUNT).
> 
> For now make __GFP_ACCOUNT allocations bypass bulk page allocator. In
> future if there is workload that can be significantly improved with the
> bulk page allocator with __GFP_ACCCOUNT support, we can revisit the
> decision.
> 
> Fixes: 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> Changes since v1:
> - do fallback allocation instead of failure, suggested by Michal Hocko.

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

This looks indeed better! Thanks!

> 
>  mm/page_alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 668edb16446a..9ca871dc8602 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5230,6 +5230,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	if (unlikely(page_array && nr_pages - nr_populated == 0))
>  		goto out;
>  
> +	/* Bulk allocator does not support memcg accounting. */
> +	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT))
> +		goto failed;
> +
>  	/* Use the single page allocator for one page. */
>  	if (nr_pages - nr_populated == 1)
>  		goto failed;
> -- 
> 2.33.0.882.g93a45727a2-goog
> 

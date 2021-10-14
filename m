From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 09:16:04 +0200
Message-ID: <YWfZNF7T7Fm69sik@dhcp22.suse.cz>
References: <20211013194338.1804247-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634195766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=psDL5nan6SZCy/ZgVLbapa/8v4HIAOlEqUtXE6YYjOI=;
        b=ZtNJuUPQ0p6nym5BoNWMIVPfO/mXnStoFPNKokOO/JFTZ9io30gEh7DhAICNABbrvjr8hx
        RtFXUn0KBjSiUJHxZra5XdLtPbcvgswlq4KIpSpjK6BprtvbIGbNBUJrOzbOfQ2dUyiaoq
        pO+FgmBolTc78KoobQwspZnzuD5cx5w=
Content-Disposition: inline
In-Reply-To: <20211013194338.1804247-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 13-10-21 12:43:38, Shakeel Butt wrote:
[...]
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 668edb16446a..b3acad4615d3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5215,6 +5215,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
>  	int nr_populated = 0, nr_account = 0;
>  
> +	/* Bulk allocator does not support memcg accounting. */
> +	if (unlikely(gfp & __GFP_ACCOUNT))
> +		goto out;

Did you mean goto failed here? This would break some which do not
have any fallback. E.g. xfs_buf_alloc_pages but likely more.

Sorry I could have been more specific when talking about bypassing the
bulk allocator. It is quite confusing because the bulk allocator
interface consists of the bulk allocator and the fallback to the normal
page allocator.

> +
>  	/*
>  	 * Skip populated array elements to determine if any pages need
>  	 * to be allocated before disabling IRQs.
> -- 
> 2.33.0.882.g93a45727a2-goog

-- 
Michal Hocko
SUSE Labs

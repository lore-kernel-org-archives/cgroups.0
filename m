From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/page_owner: Use scnprintf() to avoid excessive
 buffer overrun check
Date: Mon, 31 Jan 2022 22:43:09 +0200
Message-ID: <YfhJ3VT8KCjd3iGR@kernel.org>
References: <20220131192308.608837-1-longman@redhat.com>
 <20220131192308.608837-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643661802;
        bh=JFWeeOeX6cMALtKM2vqlyIArFqrtqdWgyAlR/K0BiiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DsVbUZNgXSXX7Vp5kx/hp3fv7i7TnEaNCHHSpAWfjrnPft8jTlVvpAtPufljeq1NE
         eWe1mBdkC1Z4+gVowCiXW4qrWXlG2iwlJHSclBz0Ux7V/VbeAhwYNo3LAWkId15GsC
         iCXP+yboTKXgO/3Z8VOFu4eqSFjgRzQmv4DcT9MBx5gdlm+b2EN5teo5zHx3JIxVZW
         ABTIfiVdi1r3KpasmC4hvjLckFnXafw1C+MWr8F09FOv59/iWA+Ce4rtL4NU7Snm4h
         e0K5GjuDAMQ0xiipMEOk4LXXyCYRoCMw8mcsE+MEGhucgc+MlcVcKkyCmS7Afh08PT
         gcVkJDy3o3j/w==
Content-Disposition: inline
In-Reply-To: <20220131192308.608837-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 31, 2022 at 02:23:06PM -0500, Waiman Long wrote:
> The snprintf() function can return a length greater than the given
> input size. That will require a check for buffer overrun after each
> invocation of snprintf(). scnprintf(), on the other hand, will never
> return a greater length. By using scnprintf() in selected places, we
> can avoid some buffer overrun checks except after stack_depot_snprint()
> and after the last snprintf().
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

> ---
>  mm/page_owner.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 99e360df9465..28dac73e0542 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -338,19 +338,16 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> -	ret = snprintf(kbuf, count,
> +	ret = scnprintf(kbuf, count,
>  			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
>  			page_owner->order, page_owner->gfp_mask,
>  			&page_owner->gfp_mask, page_owner->pid,
>  			page_owner->ts_nsec, page_owner->free_ts_nsec);
>  
> -	if (ret >= count)
> -		goto err;
> -
>  	/* Print information relevant to grouping pages by mobility */
>  	pageblock_mt = get_pageblock_migratetype(page);
>  	page_mt  = gfp_migratetype(page_owner->gfp_mask);
> -	ret += snprintf(kbuf + ret, count - ret,
> +	ret += scnprintf(kbuf + ret, count - ret,
>  			"PFN %lu type %s Block %lu type %s Flags %pGp\n",
>  			pfn,
>  			migratetype_names[page_mt],
> @@ -358,19 +355,14 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migratetype_names[pageblock_mt],
>  			&page->flags);
>  
> -	if (ret >= count)
> -		goto err;
> -
>  	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>  	if (ret >= count)
>  		goto err;
>  
>  	if (page_owner->last_migrate_reason != -1) {
> -		ret += snprintf(kbuf + ret, count - ret,
> +		ret += scnprintf(kbuf + ret, count - ret,
>  			"Page has been migrated, last migrate reason: %s\n",
>  			migrate_reason_names[page_owner->last_migrate_reason]);
> -		if (ret >= count)
> -			goto err;
>  	}
>  
>  	ret += snprintf(kbuf + ret, count - ret, "\n");
> -- 
> 2.27.0
> 
> 

-- 
Sincerely yours,
Mike.

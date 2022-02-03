From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 2/4] mm/page_owner: Use scnprintf() to avoid excessive
 buffer overrun check
Date: Thu, 3 Feb 2022 16:46:52 +0100
Message-ID: <5c03fa31-35a5-4cbc-6b0e-872d5db82a41@suse.cz>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-3-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643903212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qag6tkHAZgc8uXx2cxv+vocoYireohjHqFyNa8NETMI=;
        b=IJEnoj6Ibm8O0mi19d4TNUqFyp2wpMTSCVGmu9cHcTlRkWY0oDReLijm6fDsu8yDJTR4Z/
        KJ3e2YFJHaSfaRfK878zktY5ktc0HrNMFgmm2xpgAAwIa1N3opczoy2jUl/P/QJGOh8tRh
        qkCHq1CJu4GamRMXZWGd0h+Ei44tdCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643903212;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qag6tkHAZgc8uXx2cxv+vocoYireohjHqFyNa8NETMI=;
        b=Q69+nu2srD89INEG52kptlrsTaoOM/1DpVHi2Uck2IJEmU41qsb3pcMazGHaZH0ak1J3zv
        A7bw+lIbHiGm2LDA==
Content-Language: en-US
In-Reply-To: <20220202203036.744010-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/2/22 21:30, Waiman Long wrote:
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

Looks like this will work, but note that if the purpose of patch 1/4 was
that after the first scnprintf() that overflows the following calls will be
short-cut thanks to passing the size as 0, AFAICS that won't work. Because
scnprintf() returns the number without trailing zero, 'ret' will be 'count -
1' after the overflow, so 'count - ret' will be 1, never 0.

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


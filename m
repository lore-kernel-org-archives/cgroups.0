From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 4/4] mm/page_owner: Record task command name
Date: Tue, 1 Feb 2022 16:28:13 +0100
Message-ID: <YflRjeoC0jbzArDG@dhcp22.suse.cz>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220131220328.622162-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643729294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RQRLOb3bXZrYGcNHUZwT7I3GzHLLZBfOqR/e/Ky19U0=;
        b=tDzwQ3OjYZK3aArHn/DGQi+rmnL8fLeYFwWwbSDdHLFkDbcOwnJFUTVS+NZ85Rjjyif4OL
        4cG7+qsLAUyiem/flUf/ml1EdAtz9FkrFl0P6eTUIHlJb2YyJPcY9gp7M2WpRHeZgJDSrH
        gXiAvAE+gYsHBZSWmYOWm7RRKNspuHM=
Content-Disposition: inline
In-Reply-To: <20220131220328.622162-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Cc Vlastimil

On Mon 31-01-22 17:03:28, Waiman Long wrote:
> The page_owner information currently includes the pid of the calling
> task. That is useful as long as the task is still running. Otherwise,
> the number is meaningless. To have more information about the allocating
> tasks that had exited by the time the page_owner information is
> retrieved, we need to store the command name of the task.
> 
> Add a new comm field into page_owner structure to store the command name
> and display it when the page_owner information is retrieved.

I completely agree that pid is effectivelly useless (if not misleading)
but is comm really telling all that much to compensate for the
additional storage required for _each_ page in the system?

> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/page_owner.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index a471c74c7fe0..485542155483 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -29,6 +29,7 @@ struct page_owner {
>  	depot_stack_handle_t free_handle;
>  	u64 ts_nsec;
>  	u64 free_ts_nsec;
> +	char comm[TASK_COMM_LEN];
>  	pid_t pid;
>  };
>  
> @@ -146,6 +147,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  		page_owner = get_page_owner(page_ext);
>  		page_owner->free_handle = handle;
>  		page_owner->free_ts_nsec = free_ts_nsec;
> +		page_owner->comm[0] = '\0';
>  		page_ext = page_ext_next(page_ext);
>  	}
>  }
> @@ -165,6 +167,8 @@ static inline void __set_page_owner_handle(struct page_ext *page_ext,
>  		page_owner->last_migrate_reason = -1;
>  		page_owner->pid = current->pid;
>  		page_owner->ts_nsec = local_clock();
> +		strlcpy(page_owner->comm, current->comm,
> +			sizeof(page_owner->comm));
>  		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
>  		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
>  
> @@ -232,6 +236,7 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>  	new_page_owner->pid = old_page_owner->pid;
>  	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
>  	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
> +	strcpy(new_page_owner->comm, old_page_owner->comm);
>  
>  	/*
>  	 * We don't clear the bit on the old folio as it's going to be freed
> @@ -376,10 +381,11 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  		return -ENOMEM;
>  
>  	ret = scnprintf(kbuf, count,
> -			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
> +			"Page allocated via order %u, mask %#x(%pGg), pid %d (%s), ts %llu ns, free_ts %llu ns\n",
>  			page_owner->order, page_owner->gfp_mask,
>  			&page_owner->gfp_mask, page_owner->pid,
> -			page_owner->ts_nsec, page_owner->free_ts_nsec);
> +			page_owner->comm, page_owner->ts_nsec,
> +			page_owner->free_ts_nsec);
>  
>  	/* Print information relevant to grouping pages by mobility */
>  	pageblock_mt = get_pageblock_migratetype(page);
> @@ -446,9 +452,10 @@ void __dump_page_owner(const struct page *page)
>  	else
>  		pr_alert("page_owner tracks the page as freed\n");
>  
> -	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, ts %llu, free_ts %llu\n",
> +	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d (%s), ts %llu, free_ts %llu\n",
>  		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
> -		 page_owner->pid, page_owner->ts_nsec, page_owner->free_ts_nsec);
> +		 page_owner->pid, page_owner->comm, page_owner->ts_nsec,
> +		 page_owner->free_ts_nsec);
>  
>  	handle = READ_ONCE(page_owner->handle);
>  	if (!handle)
> -- 
> 2.27.0

-- 
Michal Hocko
SUSE Labs

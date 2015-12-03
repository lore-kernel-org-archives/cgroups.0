From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: use list_{first,next}_entry
Date: Thu, 3 Dec 2015 17:27:18 +0100
Message-ID: <20151203162718.GK9264@dhcp22.suse.cz>
References: <9e62e3006561653fcbf0c49cf0b9c2b653a8ed0e.1449152124.git.geliangtang@163.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9e62e3006561653fcbf0c49cf0b9c2b653a8ed0e.1449152124.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 03-12-15 22:16:55, Geliang Tang wrote:
> To make the intention clearer, use list_{first,next}_entry instead
> of list_entry.

Does this really help readability? This function simply uncharges the
given list of pages. Why cannot we simply use list_for_each_entry
instead...

> Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
> ---
>  mm/memcontrol.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 79a29d5..a6301ea 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5395,16 +5395,12 @@ static void uncharge_list(struct list_head *page_list)
>  	unsigned long nr_file = 0;
>  	unsigned long nr_huge = 0;
>  	unsigned long pgpgout = 0;
> -	struct list_head *next;
>  	struct page *page;
>  
> -	next = page_list->next;
> +	page = list_first_entry(page_list, struct page, lru);
>  	do {
>  		unsigned int nr_pages = 1;
>  
> -		page = list_entry(next, struct page, lru);
> -		next = page->lru.next;
> -
>  		VM_BUG_ON_PAGE(PageLRU(page), page);
>  		VM_BUG_ON_PAGE(page_count(page), page);
>  
> @@ -5440,7 +5436,8 @@ static void uncharge_list(struct list_head *page_list)
>  		page->mem_cgroup = NULL;
>  
>  		pgpgout++;
> -	} while (next != page_list);
> +	} while (!list_is_last(&page->lru, page_list) &&
> +		 (page = list_next_entry(page, lru)));
>  
>  	if (memcg)
>  		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
> -- 
> 2.5.0
> 

-- 
Michal Hocko
SUSE Labs

From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: replace the loop with a
 list_for_each_entry()
Date: Fri, 5 Feb 2021 10:53:42 +0800
Message-ID: <6f8d9e82-5903-e983-8c93-9dfe3e9b14ca@huawei.com>
References: <20210204163055.56080-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210204163055.56080-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hi:
On 2021/2/5 0:30, Muchun Song wrote:
> The rule of list walk has gone since:
> 
>  commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")
> 
> So remove the strange comment and replace the loop with a
> list_for_each_entry().
> 
> There is only one caller of the uncharge_list(). So just fold it into
> mem_cgroup_uncharge_list() and remove it.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

LGTM. Thanks.
Reviewed-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> ---
> v2:
>  - Fold uncharge_list() to mem_cgroup_uncharge_list().
> 
>  mm/memcontrol.c | 35 ++++++++---------------------------
>  1 file changed, 8 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ed5cc78a8dbf..8c035846c7a4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6862,31 +6862,6 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>  	css_put(&ug->memcg->css);
>  }
>  
> -static void uncharge_list(struct list_head *page_list)
> -{
> -	struct uncharge_gather ug;
> -	struct list_head *next;
> -
> -	uncharge_gather_clear(&ug);
> -
> -	/*
> -	 * Note that the list can be a single page->lru; hence the
> -	 * do-while loop instead of a simple list_for_each_entry().
> -	 */
> -	next = page_list->next;
> -	do {
> -		struct page *page;
> -
> -		page = list_entry(next, struct page, lru);
> -		next = page->lru.next;
> -
> -		uncharge_page(page, &ug);
> -	} while (next != page_list);
> -
> -	if (ug.memcg)
> -		uncharge_batch(&ug);
> -}
> -
>  /**
>   * mem_cgroup_uncharge - uncharge a page
>   * @page: page to uncharge
> @@ -6918,11 +6893,17 @@ void mem_cgroup_uncharge(struct page *page)
>   */
>  void mem_cgroup_uncharge_list(struct list_head *page_list)
>  {
> +	struct uncharge_gather ug;
> +	struct page *page;
> +
>  	if (mem_cgroup_disabled())
>  		return;
>  
> -	if (!list_empty(page_list))
> -		uncharge_list(page_list);
> +	uncharge_gather_clear(&ug);
> +	list_for_each_entry(page, page_list, lru)
> +		uncharge_page(page, &ug);
> +	if (ug.memcg)
> +		uncharge_batch(&ug);
>  }
>  
>  /**
> 


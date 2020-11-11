From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v21 12/19] mm/mlock: remove lru_lock on
 TestClearPageMlocked
Date: Wed, 11 Nov 2020 14:03:54 +0100
Message-ID: <0df624ca-a0d2-6a9f-f114-04f91bf35415@suse.cz>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-13-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1604566549-62481-13-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 11/5/20 9:55 AM, Alex Shi wrote:
> In the func munlock_vma_page, comments mentained lru_lock needed for
> serialization with split_huge_pages. But the page must be PageLocked
> as well as pages in split_huge_page series funcs. Thus the PageLocked
> is enough to serialize both funcs.
> 
> Further more, Hugh Dickins pointed: before splitting in
> split_huge_page_to_list, the page was unmap_page() to remove pmd/ptes
> which protect the page from munlock. Thus, no needs to guard
> __split_huge_page_tail for mlock clean, just keep the lru_lock there for
> isolation purpose.
> 
> LKP found a preempt issue on __mod_zone_page_state which need change
> to mod_zone_page_state. Thanks!
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Nit below:

> ---
>   mm/mlock.c | 26 +++++---------------------
>   1 file changed, 5 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 884b1216da6a..796c726a0407 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -187,40 +187,24 @@ static void __munlock_isolation_failed(struct page *page)
>   unsigned int munlock_vma_page(struct page *page)
>   {
>   	int nr_pages;
> -	pg_data_t *pgdat = page_pgdat(page);
>   
>   	/* For try_to_munlock() and to serialize with page migration */

Now the reasons for locking are expanded?

>   	BUG_ON(!PageLocked(page));
> -
>   	VM_BUG_ON_PAGE(PageTail(page), page);
>   
> -	/*
> -	 * Serialize with any parallel __split_huge_page_refcount() which
> -	 * might otherwise copy PageMlocked to part of the tail pages before
> -	 * we clear it in the head page. It also stabilizes thp_nr_pages().
> -	 */
> -	spin_lock_irq(&pgdat->lru_lock);
> -
>   	if (!TestClearPageMlocked(page)) {
>   		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
> -		nr_pages = 1;
> -		goto unlock_out;
> +		return 0;
>   	}
>   
>   	nr_pages = thp_nr_pages(page);
> -	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
> +	mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
>   
> -	if (__munlock_isolate_lru_page(page, true)) {
> -		spin_unlock_irq(&pgdat->lru_lock);
> +	if (!isolate_lru_page(page))
>   		__munlock_isolated_page(page);
> -		goto out;
> -	}
> -	__munlock_isolation_failed(page);
> -
> -unlock_out:
> -	spin_unlock_irq(&pgdat->lru_lock);
> +	else
> +		__munlock_isolation_failed(page);
>   
> -out:
>   	return nr_pages - 1;
>   }
>   
> 


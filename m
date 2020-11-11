From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v21 16/19] mm/swap.c: serialize memcg changes in
 pagevec_lru_move_fn
Date: Wed, 11 Nov 2020 19:00:10 +0100
Message-ID: <0af28702-8f75-6974-5b66-c0633eb83d7c@suse.cz>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-17-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1604566549-62481-17-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 11/5/20 9:55 AM, Alex Shi wrote:
> Hugh Dickins' found a memcg change bug on original version:
> If we want to change the pgdat->lru_lock to memcg's lruvec lock, we have
> to serialize mem_cgroup_move_account during pagevec_lru_move_fn. The
> possible bad scenario would like:
> 
> 	cpu 0					cpu 1
> lruvec = mem_cgroup_page_lruvec()
> 					if (!isolate_lru_page())
> 						mem_cgroup_move_account
> 
> spin_lock_irqsave(&lruvec->lru_lock <== wrong lock.
> 
> So we need TestClearPageLRU to block isolate_lru_page(), that serializes
> the memcg change. and then removing the PageLRU check in move_fn callee
> as the consequence.
> 
> __pagevec_lru_add_fn() is different from the others, because the pages
> it deals with are, by definition, not yet on the lru.  TestClearPageLRU
> is not needed and would not work, so __pagevec_lru_add() goes its own
> way.
> 
> Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

> ---
>   mm/swap.c | 44 +++++++++++++++++++++++++++++++++++---------
>   1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 2681d9023998..1838a9535703 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -222,8 +222,14 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>   			spin_lock_irqsave(&pgdat->lru_lock, flags);
>   		}
>   
> +		/* block memcg migration during page moving between lru */
> +		if (!TestClearPageLRU(page))
> +			continue;
> +
>   		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   		(*move_fn)(page, lruvec);
> +
> +		SetPageLRU(page);
>   	}
>   	if (pgdat)
>   		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> @@ -233,7 +239,7 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>   
>   static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
>   {
> -	if (PageLRU(page) && !PageUnevictable(page)) {
> +	if (!PageUnevictable(page)) {
>   		del_page_from_lru_list(page, lruvec, page_lru(page));
>   		ClearPageActive(page);
>   		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
> @@ -306,7 +312,7 @@ void lru_note_cost_page(struct page *page)
>   
>   static void __activate_page(struct page *page, struct lruvec *lruvec)
>   {
> -	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
> +	if (!PageActive(page) && !PageUnevictable(page)) {
>   		int lru = page_lru_base_type(page);
>   		int nr_pages = thp_nr_pages(page);
>   
> @@ -362,7 +368,8 @@ static void activate_page(struct page *page)
>   
>   	page = compound_head(page);
>   	spin_lock_irq(&pgdat->lru_lock);
> -	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
> +	if (PageLRU(page))
> +		__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
>   	spin_unlock_irq(&pgdat->lru_lock);
>   }
>   #endif
> @@ -519,9 +526,6 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
>   	bool active;
>   	int nr_pages = thp_nr_pages(page);
>   
> -	if (!PageLRU(page))
> -		return;
> -
>   	if (PageUnevictable(page))
>   		return;
>   
> @@ -562,7 +566,7 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
>   
>   static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
>   {
> -	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
> +	if (PageActive(page) && !PageUnevictable(page)) {
>   		int lru = page_lru_base_type(page);
>   		int nr_pages = thp_nr_pages(page);
>   
> @@ -579,7 +583,7 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
>   
>   static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec)
>   {
> -	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
> +	if (PageAnon(page) && PageSwapBacked(page) &&
>   	    !PageSwapCache(page) && !PageUnevictable(page)) {
>   		bool active = PageActive(page);
>   		int nr_pages = thp_nr_pages(page);
> @@ -1021,7 +1025,29 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
>    */
>   void __pagevec_lru_add(struct pagevec *pvec)
>   {
> -	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
> +	int i;
> +	struct pglist_data *pgdat = NULL;
> +	struct lruvec *lruvec;
> +	unsigned long flags = 0;
> +
> +	for (i = 0; i < pagevec_count(pvec); i++) {
> +		struct page *page = pvec->pages[i];
> +		struct pglist_data *pagepgdat = page_pgdat(page);
> +
> +		if (pagepgdat != pgdat) {
> +			if (pgdat)
> +				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +			pgdat = pagepgdat;
> +			spin_lock_irqsave(&pgdat->lru_lock, flags);
> +		}
> +
> +		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +		__pagevec_lru_add_fn(page, lruvec);
> +	}
> +	if (pgdat)
> +		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +	release_pages(pvec->pages, pvec->nr);
> +	pagevec_reinit(pvec);
>   }
>   
>   /**
> 


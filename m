From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 21/32] mm/lru: introduce the relock_page_lruvec
 function
Date: Mon, 21 Sep 2020 22:40:10 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009212229270.6434@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-22-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=6LZJbo2wShWpm8ovGLzdTSaw70v+wjIXX2UN2lui5KE=;
        b=Tdwv7P0gQGa7UVTHfNJwLlNsLU/GP+aKq88wZ8ejQgYw/uyivNES8YKU7x42iIbiRb
         0BfBgo4om6rzyK0w1tBnPsR/RJ5sn4At3bjR/3SJUzewnTwT+C8Rpf6ikrzPDJrlpwA/
         FLpYO9QCCWEFNBFK8FJiKS80H0ONIqZKl2gMxw01WHWdmqNWd8Xeae2kbjJNdWqL+MOv
         OkMQRMA2/RX+s0m3blLkUBBDAXlMUoU2F/o09GsMfybWflDu3PPxjFggZQ7NrUzdgYgo
         q2XqJWH0IGp6jwYoXottUuBFTgKBAHy6p1booeRcvVxxJLZCLUzsZuYez0C5q/s6TMyf
         ju6Q==
In-Reply-To: <1598273705-69124-22-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

On Mon, 24 Aug 2020, Alex Shi wrote:

> From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Use this new function to replace repeated same code, no func change.
> 
> When testing for relock we can avoid the need for RCU locking if we simply
> compare the page pgdat and memcg pointers versus those that the lruvec is
> holding. By doing this we can avoid the extra pointer walks and accesses of
> the memory cgroup.
> 
> In addition we can avoid the checks entirely if lruvec is currently NULL.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Again, I'll wait to see __munlock_pagevec() fixed before Acking this
one, but that's the only issue.  And I've suggested that you use
lruvec_holds_page_lru_lock() in mm/vmscan.c move_pages_to_lru(),
to replace the uglier and less efficient VM_BUG_ON_PAGE there.

Oh, there is one other issue: 0day robot did report (2020-06-19)
that sparse doesn't understand relock_page_lruvec*(): I've never
got around to working out how to write what it needs, conditional
__release plus __acquire in some form, I imagine. I've never got
into sparse annotations before, I'll give it a try, but if anyone
beats me that will be welcome: and there are higher priorities -
I do not think you should wait for the sparse warning to be fixed
before reposting.

> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
> Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/memcontrol.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++
>  mm/mlock.c                 |  9 +-------
>  mm/swap.c                  | 33 +++++++----------------------
>  mm/vmscan.c                |  8 +------
>  4 files changed, 61 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7b170e9028b5..ee6ef2d8ad52 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -488,6 +488,22 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>  
>  struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
>  
> +static inline bool lruvec_holds_page_lru_lock(struct page *page,
> +					      struct lruvec *lruvec)
> +{
> +	pg_data_t *pgdat = page_pgdat(page);
> +	const struct mem_cgroup *memcg;
> +	struct mem_cgroup_per_node *mz;
> +
> +	if (mem_cgroup_disabled())
> +		return lruvec == &pgdat->__lruvec;
> +
> +	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> +	memcg = page->mem_cgroup ? : root_mem_cgroup;
> +
> +	return lruvec->pgdat == pgdat && mz->memcg == memcg;
> +}
> +
>  struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
>  
>  struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
> @@ -1023,6 +1039,14 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
>  	return &pgdat->__lruvec;
>  }
>  
> +static inline bool lruvec_holds_page_lru_lock(struct page *page,
> +					      struct lruvec *lruvec)
> +{
> +		pg_data_t *pgdat = page_pgdat(page);
> +
> +		return lruvec == &pgdat->__lruvec;
> +}
> +
>  static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
>  {
>  	return NULL;
> @@ -1469,6 +1493,34 @@ static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
>  	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
>  }
>  
> +/* Don't lock again iff page's lruvec locked */
> +static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
> +		struct lruvec *locked_lruvec)
> +{
> +	if (locked_lruvec) {
> +		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
> +			return locked_lruvec;
> +
> +		unlock_page_lruvec_irq(locked_lruvec);
> +	}
> +
> +	return lock_page_lruvec_irq(page);
> +}
> +
> +/* Don't lock again iff page's lruvec locked */
> +static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
> +		struct lruvec *locked_lruvec, unsigned long *flags)
> +{
> +	if (locked_lruvec) {
> +		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
> +			return locked_lruvec;
> +
> +		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
> +	}
> +
> +	return lock_page_lruvec_irqsave(page, flags);
> +}
> +
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  
>  struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 177d2588e863..0448409184e3 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -302,17 +302,10 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
>  	/* Phase 1: page isolation */
>  	for (i = 0; i < nr; i++) {
>  		struct page *page = pvec->pages[i];
> -		struct lruvec *new_lruvec;
>  
>  		/* block memcg change in mem_cgroup_move_account */
>  		lock_page_memcg(page);
> -		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -		if (new_lruvec != lruvec) {
> -			if (lruvec)
> -				unlock_page_lruvec_irq(lruvec);
> -			lruvec = lock_page_lruvec_irq(page);
> -		}
> -
> +		lruvec = relock_page_lruvec_irq(page, lruvec);
>  		if (TestClearPageMlocked(page)) {
>  			/*
>  			 * We already have pin from follow_page_mask()
> diff --git a/mm/swap.c b/mm/swap.c
> index b67959b701c0..2ac78e8fab71 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -209,19 +209,12 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>  
>  	for (i = 0; i < pagevec_count(pvec); i++) {
>  		struct page *page = pvec->pages[i];
> -		struct lruvec *new_lruvec;
>  
>  		/* block memcg migration during page moving between lru */
>  		if (!TestClearPageLRU(page))
>  			continue;
>  
> -		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -		if (lruvec != new_lruvec) {
> -			if (lruvec)
> -				unlock_page_lruvec_irqrestore(lruvec, flags);
> -			lruvec = lock_page_lruvec_irqsave(page, &flags);
> -		}
> -
> +		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
>  		(*move_fn)(page, lruvec);
>  
>  		SetPageLRU(page);
> @@ -865,17 +858,12 @@ void release_pages(struct page **pages, int nr)
>  		}
>  
>  		if (PageLRU(page)) {
> -			struct lruvec *new_lruvec;
> -
> -			new_lruvec = mem_cgroup_page_lruvec(page,
> -							page_pgdat(page));
> -			if (new_lruvec != lruvec) {
> -				if (lruvec)
> -					unlock_page_lruvec_irqrestore(lruvec,
> -									flags);
> +			struct lruvec *prev_lruvec = lruvec;
> +
> +			lruvec = relock_page_lruvec_irqsave(page, lruvec,
> +									&flags);
> +			if (prev_lruvec != lruvec)
>  				lock_batch = 0;
> -				lruvec = lock_page_lruvec_irqsave(page, &flags);
> -			}
>  
>  			VM_BUG_ON_PAGE(!PageLRU(page), page);
>  			__ClearPageLRU(page);
> @@ -982,15 +970,8 @@ void __pagevec_lru_add(struct pagevec *pvec)
>  
>  	for (i = 0; i < pagevec_count(pvec); i++) {
>  		struct page *page = pvec->pages[i];
> -		struct lruvec *new_lruvec;
> -
> -		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -		if (lruvec != new_lruvec) {
> -			if (lruvec)
> -				unlock_page_lruvec_irqrestore(lruvec, flags);
> -			lruvec = lock_page_lruvec_irqsave(page, &flags);
> -		}
>  
> +		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
>  		__pagevec_lru_add_fn(page, lruvec);
>  	}
>  	if (lruvec)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 789444ae4c88..2c94790d4cb1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4280,15 +4280,9 @@ void check_move_unevictable_pages(struct pagevec *pvec)
>  
>  	for (i = 0; i < pvec->nr; i++) {
>  		struct page *page = pvec->pages[i];
> -		struct lruvec *new_lruvec;
>  
>  		pgscanned++;
> -		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -		if (lruvec != new_lruvec) {
> -			if (lruvec)
> -				unlock_page_lruvec_irq(lruvec);
> -			lruvec = lock_page_lruvec_irq(page);
> -		}
> +		lruvec = relock_page_lruvec_irq(page, lruvec);
>  
>  		if (!PageLRU(page) || !PageUnevictable(page))
>  			continue;
> -- 
> 1.8.3.1

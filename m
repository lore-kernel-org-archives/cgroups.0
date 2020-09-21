From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 16/32] mm/lru: introduce TestClearPageLRU
Date: Mon, 21 Sep 2020 16:16:16 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009211504200.5214@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-17-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=BcuKgc3jGxItkyWiUdeL+SY34z52t2Wt1/MsImKvlh8=;
        b=OwUkAegznMAyRepl3dJUGb6AvehwhPSLy4u20VbZg7b+iDXgW9jL56zxMha44sB13R
         b7CQj+PEtHbo/sPf6l9KPOdgDx/la5T3n/cKY2W4QElvKFp/TMCWvLVXJN/ciFtjjO5d
         Va3JBo4OiFysnblBrHIAXeOeESaLSYPEmu5M068HhHikVBrqb1OowVkOfw4xMWoLFr+Q
         zzLJjj36wE2eg3hiGR4dehp4k+9zAkBkwU7M69DTdJtkWY/FViEjHFgZ1bO0A6mTE+lb
         jMtXZLwDIw7LH1GX0vl/tXViaZYdZx3tgTlmsmIwpb1bfnEn9bLowtektJJksCMuf4G3
         oC4A==
In-Reply-To: <1598273705-69124-17-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, 24 Aug 2020, Alex Shi wrote:

> Currently lru_lock still guards both lru list and page's lru bit, that's
> ok. but if we want to use specific lruvec lock on the page, we need to
> pin down the page's lruvec/memcg during locking. Just taking lruvec
> lock first may be undermined by the page's memcg charge/migration. To
> fix this problem, we could clear the lru bit out of locking and use
> it as pin down action to block the page isolation in memcg changing.
> 
> So now a standard steps of page isolation is following:
> 	1, get_page(); 	       #pin the page avoid to be free
> 	2, TestClearPageLRU(); #block other isolation like memcg change
> 	3, spin_lock on lru_lock; #serialize lru list access
> 	4, delete page from lru list;
> The step 2 could be optimzed/replaced in scenarios which page is
> unlikely be accessed or be moved between memcgs.
> 
> This patch start with the first part: TestClearPageLRU, which combines
> PageLRU check and ClearPageLRU into a macro func TestClearPageLRU. This
> function will be used as page isolation precondition to prevent other
> isolations some where else. Then there are may !PageLRU page on lru
> list, need to remove BUG() checking accordingly.
> 
> There 2 rules for lru bit now:
> 1, the lru bit still indicate if a page on lru list, just in some
>    temporary moment(isolating), the page may have no lru bit when
>    it's on lru list.  but the page still must be on lru list when the
>    lru bit set.
> 2, have to remove lru bit before delete it from lru list.
> 
> Hugh Dickins pointed that when a page is in free path and no one is
> possible to take it, non atomic lru bit clearing is better, like in
> __page_cache_release and release_pages.
> And no need get_page() before lru bit clear in isolate_lru_page,
> since it '(1) Must be called with an elevated refcount on the page'.

Delete that paragraph: you're justifying changes made during the
course of earlier review, but not needed here.  If we start to
comment on everything that is not done...!

> 
> As Andrew Morton mentioned this change would dirty cacheline for page
> isn't on LRU. But the lost would be acceptable with Rong Chen
> <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> report:
> https://lkml.org/lkml/2020/3/4/173

Please use a lore link instead, lkml.org is nice but unreliable:
https://lore.kernel.org/lkml/20200304090301.GB5972@shao2-debian/

> 
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
when you make the changes suggested above and below.

I still have long-standing reservations about this TestClearPageLRU
technique (it's hard to reason about, and requires additional atomic ops
in some places); but it's working, so I'd like it to go in, then later
we can experiment with whether lock_page_memcg() does a better job, or
rechecking memcg when getting the lru_lock (my original technique).

> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/page-flags.h |  1 +
>  mm/mlock.c                 |  3 +--
>  mm/swap.c                  |  5 ++---
>  mm/vmscan.c                | 18 +++++++-----------
>  4 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 6be1aa559b1e..9554ed1387dc 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -326,6 +326,7 @@ static inline void page_init_poison(struct page *page, size_t size)
>  PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
>  	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
>  PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
> +	TESTCLEARFLAG(LRU, lru, PF_HEAD)
>  PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
>  	TESTCLEARFLAG(Active, active, PF_HEAD)
>  PAGEFLAG(Workingset, workingset, PF_HEAD)
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 93ca2bf30b4f..3762d9dd5b31 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -107,13 +107,12 @@ void mlock_vma_page(struct page *page)
>   */
>  static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
>  {
> -	if (PageLRU(page)) {
> +	if (TestClearPageLRU(page)) {
>  		struct lruvec *lruvec;
>  
>  		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
>  		if (getpage)
>  			get_page(page);
> -		ClearPageLRU(page);
>  		del_page_from_lru_list(page, lruvec, page_lru(page));
>  		return true;
>  	}
> diff --git a/mm/swap.c b/mm/swap.c
> index f80ccd6f3cb4..446ffe280809 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -83,10 +83,9 @@ static void __page_cache_release(struct page *page)
>  		struct lruvec *lruvec;
>  		unsigned long flags;
>  
> +		__ClearPageLRU(page);
>  		spin_lock_irqsave(&pgdat->lru_lock, flags);
>  		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> -		VM_BUG_ON_PAGE(!PageLRU(page), page);
> -		__ClearPageLRU(page);
>  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
>  		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>  	}
> @@ -880,9 +879,9 @@ void release_pages(struct page **pages, int nr)
>  				spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
>  			}
>  
> -			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>  			VM_BUG_ON_PAGE(!PageLRU(page), page);
>  			__ClearPageLRU(page);
> +			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>  			del_page_from_lru_list(page, lruvec, page_off_lru(page));
>  		}
>  

Please delete all those mods to mm/swap.c from this patch.  This patch
is about introducing TestClearPageLRU, but that is not involved here.
Several versions ago, yes it was, then I pointed out that these are
operations on refcount 0 pages, and we don't want to add unnecessary
atomic operations on them.  I expect you want to keep the rearrangements,
but do them where you need them later (I expect that's in 20/32).

And I notice that one VM_BUG_ON_PAGE was kept and the other deleted:
though one can certainly argue that they're redundant (as all BUGs
should be), I think most people will feel safer to keep them both.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7b7b36bd1448..1b3e0eeaad64 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1665,8 +1665,6 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  		page = lru_to_page(src);
>  		prefetchw_prev_lru_page(page, src, flags);
>  
> -		VM_BUG_ON_PAGE(!PageLRU(page), page);
> -
>  		nr_pages = compound_nr(page);
>  		total_scan += nr_pages;
>  

It is not enough to remove just that one VM_BUG_ON_PAGE there.
This is a patch series, and we don't need it to be perfect at every
bisection point between patches, but we do need it to be reasonably
robust, so as not to waste unrelated bughunters' time.  It didn't
take me very long to crash on the "default: BUG()" further down
isolate_lru_pages(), because now PageLRU may get cleared at any
instant, whatever locks are held.

(But you're absolutely right to leave the compaction and pagevec
mods to subsequent patches: it's fairly safe to separate those out,
and much easier for reviewers that you did so.)

This patch is much more robust with __isolate_lru_page() mods below
on top.  I agree there's other ways to do it, but given that nobody
cares what the error return is from __isolate_lru_page(), except for
the isolate_lru_pages() switch statement BUG() which has become
invalid, I suggest just use -EBUSY throughout __isolate_lru_page().
Yes, we can and should change that switch statement to an
"if {} else {}" without any BUG(), but I don't want to mess
you around at this time, leave cleanup like that until later.
Please fold in this patch on top:

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1540,7 +1540,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
  */
 int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 {
-	int ret = -EINVAL;
+	int ret = -EBUSY;
 
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
@@ -1550,8 +1550,6 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
-	ret = -EBUSY;
-
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
 	 * wants to isolate pages it will be able to operate on without
@@ -1598,8 +1596,10 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		ClearPageLRU(page);
-		ret = 0;
+		if (TestClearPageLRU(page))
+			ret = 0;
+		else
+			put_page(page);
 	}
 
 	return ret;

> @@ -1763,21 +1761,19 @@ int isolate_lru_page(struct page *page)
>  	VM_BUG_ON_PAGE(!page_count(page), page);
>  	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
>  
> -	if (PageLRU(page)) {
> +	if (TestClearPageLRU(page)) {
>  		pg_data_t *pgdat = page_pgdat(page);
>  		struct lruvec *lruvec;
> +		int lru = page_lru(page);
>  
> -		spin_lock_irq(&pgdat->lru_lock);
> +		get_page(page);
>  		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> -		if (PageLRU(page)) {
> -			int lru = page_lru(page);
> -			get_page(page);
> -			ClearPageLRU(page);
> -			del_page_from_lru_list(page, lruvec, lru);
> -			ret = 0;
> -		}
> +		spin_lock_irq(&pgdat->lru_lock);
> +		del_page_from_lru_list(page, lruvec, lru);
>  		spin_unlock_irq(&pgdat->lru_lock);
> +		ret = 0;
>  	}
> +
>  	return ret;
>  }

And a small mod to isolate_lru_page() to be folded in.  I had
never noticed this before, but here you are evaluating page_lru()
after clearing PageLRU, but before getting lru_lock: that seems unsafe.
I'm pretty sure it's unsafe at this stage of the series; I did once
persuade myself that it becomes safe by the end of the series,
but I've already forgotten the argument for that (I have already
said TestClearPageLRU is difficult to reason about).  Please don't
force us to have to think about this! Just get page_lru after lru_lock.

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1764,12 +1764,11 @@ int isolate_lru_page(struct page *page)
 	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat = page_pgdat(page);
 		struct lruvec *lruvec;
-		int lru = page_lru(page);
 
 		get_page(page);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 		spin_lock_irq(&pgdat->lru_lock);
-		del_page_from_lru_list(page, lruvec, lru);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		spin_unlock_irq(&pgdat->lru_lock);
 		ret = 0;
 	}

And lastly, please do check_move_unevictable_pages()'s TestClearPageLRU
mod here at the end of mm/vmscan.c in this patch: I noticed that your
lruv19 branch is doing it in a later patch, but it fits better here.

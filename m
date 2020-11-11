From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v21 06/19] mm/rmap: stop store reordering issue on
 page->mapping
Date: Tue, 10 Nov 2020 23:41:52 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2011102330040.1183@eggly.anvils>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com> <1604566549-62481-7-git-send-email-alex.shi@linux.alibaba.com> <e66ef2e5-c74c-6498-e8b3-56c37b9d2d15@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=mDvH6OSBbzyVCoxpj+jRSF1gIjRVsvCyNLrBtPFpWYQ=;
        b=XwLW/dm2fkNO4NNgVz1CcrM/+4th1lp0Jt1bmAwnUZGl5dzjKemMasbPgwGnm7sQkg
         /PwXw9SmI+nYdxKqcd1DcJmG+OC6tv+/684uyIJnF5bYkgBz1J4Pd7XPZo0diSb6YqZT
         6i7lJbk2dzaAogV6yRKFpbSWLUwZZ26EgXioV654U6SiWxCY0kfRq9bCvmkfJk1g1Rq/
         yptFOUeq1uRAUi2CdvOUt/xavBHdVg7LLBhjyZTVVa/qAuIyzosmWgKaxwLu24+W3BAi
         DBDDEVugLoEVZNqTylkB7ei6iYsePtTj7jhWn5yAR6P/l0GMD6S8sEHGHd8Mgeu6afRl
         ZA4w==
In-Reply-To: <e66ef2e5-c74c-6498-e8b3-56c37b9d2d15@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Minchan Kim <minchan@kernel.org>

On Fri, 6 Nov 2020, Alex Shi wrote:
> 
> updated for comments change from Johannes
> 
> 
> From 2fd278b1ca6c3e260ad249808b62f671d8db5a7b Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linux.alibaba.com>
> Date: Thu, 5 Nov 2020 11:38:24 +0800
> Subject: [PATCH v21 06/19] mm/rmap: stop store reordering issue on
>  page->mapping
> 
> Hugh Dickins and Minchan Kim observed a long time issue which
> discussed here, but actully the mentioned fix missed.
> https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop/
> The store reordering may cause problem in the scenario:
> 
> 	CPU 0						CPU1
>    do_anonymous_page
> 	page_add_new_anon_rmap()
> 	  page->mapping = anon_vma + PAGE_MAPPING_ANON
> 	lru_cache_add_inactive_or_unevictable()
> 	  spin_lock(lruvec->lock)
> 	  SetPageLRU()
> 	  spin_unlock(lruvec->lock)
> 						/* idletacking judged it as LRU
> 						 * page so pass the page in
> 						 * page_idle_clear_pte_refs
> 						 */
> 						page_idle_clear_pte_refs
> 						  rmap_walk
> 						    if PageAnon(page)
> 
> Johannes give detailed examples how the store reordering could cause
> a trouble:
> "The concern is the SetPageLRU may get reorder before 'page->mapping'
> setting, That would make CPU 1 will observe at page->mapping after
> observing PageLRU set on the page.
> 
> 1. anon_vma + PAGE_MAPPING_ANON
> 
>    That's the in-order scenario and is fine.
> 
> 2. NULL
> 
>    That's possible if the page->mapping store gets reordered to occur
>    after SetPageLRU. That's fine too because we check for it.
> 
> 3. anon_vma without the PAGE_MAPPING_ANON bit
> 
>    That would be a problem and could lead to all kinds of undesirable
>    behavior including crashes and data corruption.
> 
>    Is it possible? AFAICT the compiler is allowed to tear the store to
>    page->mapping and I don't see anything that would prevent it.
> 
> That said, I also don't see how the reader testing PageLRU under the
> lru_lock would prevent that in the first place. AFAICT we need that
> WRITE_ONCE() around the page->mapping assignment."
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

Many thanks to Johannes for spotting my falsehood in the next patch,
and to Alex for making it true with this patch.  As I just remarked
against the v20, I do have some more of these WRITE_ONCEs, but consider
them merely theoretical: so please don't let me hold this series up.

Andrew, I am hoping that Alex's v21 will appear in the next mmotm?

Thanks,
Hugh


> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  mm/rmap.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1b84945d655c..380c6b9956c2 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1054,8 +1054,14 @@ static void __page_set_anon_rmap(struct page *page,
>  	if (!exclusive)
>  		anon_vma = anon_vma->root;
>  
> +	/*
> +	 * page_idle does a lockless/optimistic rmap scan on page->mapping.
> +	 * Make sure the compiler doesn't split the stores of anon_vma and
> +	 * the PAGE_MAPPING_ANON type identifier, otherwise the rmap code
> +	 * could mistake the mapping for a struct address_space and crash.
> +	 */
>  	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
> -	page->mapping = (struct address_space *) anon_vma;
> +	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
>  	page->index = linear_page_index(vma, address);
>  }
>  
> -- 
> 1.8.3.1

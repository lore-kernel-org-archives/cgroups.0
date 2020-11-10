From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v21 06/19] mm/rmap: stop store reordering issue on
 page->mapping
Date: Tue, 10 Nov 2020 14:06:35 -0500
Message-ID: <20201110190635.GE850433@cmpxchg.org>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-7-git-send-email-alex.shi@linux.alibaba.com>
 <e66ef2e5-c74c-6498-e8b3-56c37b9d2d15@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/P6FAAbZyAhrgG09vfP1BCKKHct1LeQm/LdrSl6xbo=;
        b=SEkve2d6VJEm0fVm001sIsH50qhvSC+fkG3XYb4FWVK0N4jo3NezX45gV3V1c2JJxR
         RlB9BUM6fCLmSo3s6Y+Ijb8MGuKJEYSBWECV+upj1zkIkqu9mmBWoc3OHP5rnb7Z8dMI
         XqnnLdzqv17RKQKD79XOWA0pV6et/HWzqgsbx8EIrk+jEXGI7wXbGmDPKkz87HtaKW2k
         ynWMuyHTCvF6/PVzX8n0E5VJp1o/mlS6Z9aZR3UXWdad07hThGZp/CFnMmCPtki3dz9U
         Uhu2qAohDJR7toQ5Ir44j97UxPf8mIj/iyXfszUSca9FeYv2Wgvw3oDYY6qsSTqVH0lq
         B18g==
Content-Disposition: inline
In-Reply-To: <e66ef2e5-c74c-6498-e8b3-56c37b9d2d15@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Minchan Kim <minchan@kernel.org>

On Fri, Nov 06, 2020 at 09:20:04AM +0800, Alex Shi wrote:
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
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Alex!

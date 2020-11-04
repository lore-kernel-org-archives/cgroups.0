From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Wed, 4 Nov 2020 12:46:03 -0500
Message-ID: <20201104174603.GB744831@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
 <20201102144927.GN27442@casper.infradead.org>
 <20201102202003.GA740958@cmpxchg.org>
 <b4038b87-cf5a-fcb7-06f4-b98874029615@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7p9nMEZ9CzGNR2nnoc/NmQ6U82GjuP7yX7DwiANzfMc=;
        b=rli6FwsWHB6cip/0jF9V7BsRWZHrrjIg7apvuKsE1Kge0E1dkDcIwIFohwKtLUNDAk
         wz/XglDjWFEulLaAfpTOkI/0Uc4V5g+ashXdnCpUU5Y67NkbPnjYcHowLSGV3qpV1sm8
         PXa4wmOaVMSbRNKZO03cdu+YlTVXPEjInI04LrO59b8qeBsErr+oo5tT/Kqu6AQo2ZRk
         65sCqy2Xavh+oMTSK1yv/QuMP9HCT8mS1vrN5D4TUL9Ved1CVkPbN6xpb49UcVVNb2VC
         YNORrzogpHxam/vez2HbOF4GRctTlLzbSWFf3SULmRcwcG/9bFvtEV/CyaxRuImJqqNG
         bpXA==
Content-Disposition: inline
In-Reply-To: <b4038b87-cf5a-fcb7-06f4-b98874029615-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, Nov 04, 2020 at 07:27:21PM +0800, Alex Shi wrote:
> 在 2020/11/3 上午4:20, Johannes Weiner 写道:
> > On Mon, Nov 02, 2020 at 02:49:27PM +0000, Matthew Wilcox wrote:
> >> On Mon, Nov 02, 2020 at 09:41:10AM -0500, Johannes Weiner wrote:
> >>> On Thu, Oct 29, 2020 at 06:44:53PM +0800, Alex Shi wrote:
> >>>> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>>>
> >>>> It is necessary for page_idle_get_page() to recheck PageLRU() after
> >>>> get_page_unless_zero(), but holding lru_lock around that serves no
> >>>> useful purpose, and adds to lru_lock contention: delete it.
> >>>>
> >>>> See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
> >>>> discussion that led to lru_lock there; but __page_set_anon_rmap() now
> >>>> uses WRITE_ONCE(),
> >>>
> >>> That doesn't seem to be the case in Linus's or Andrew's tree. Am I
> >>> missing a dependent patch series?
> >>>
> >>>> and I see no other risk in page_idle_clear_pte_refs() using
> >>>> rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly but
> >>>> not entirely prevented by page_count() check in ksm.c's
> >>>> write_protect_page(): that risk being shared with page_referenced()
> >>>> and not helped by lru_lock).
> >>>
> >>> Isn't it possible, as per Minchan's description, for page->mapping to
> >>> point to a struct anon_vma without PAGE_MAPPING_ANON set, and rmap
> >>> thinking it's looking at a struct address_space?
> >>
> >> I don't think it can point to an anon_vma without the ANON bit set.
> >> Minchan's concern in that email was that it might still be NULL.
> > 
> > Hm, no, the thread is a lengthy discussion about whether the store
> > could be split such that page->mapping is actually pointing to
> > something invalid (anon_vma without the PageAnon bit).
> > 
> > From his email:
> > 
> >         CPU 0                                                                           CPU 1
> > 
> > do_anonymous_page
> >   __page_set_anon_rmap
> >   /* out of order happened so SetPageLRU is done ahead */
> >   SetPageLRU(page)
> 
> This SetPageLRU done in __pagevec_lru_add_fn() which under the lru_lock
> protection, so the original memory barrier or lock concern isn't
> correct. that means, the SetPageLRU isn't possible to be here.
> And then no warry on right side 'CPU 1' problem.

The SetPageLRU is done under lru_lock, but the store to page->mapping
is not, so what ensures ordering between them? And what prevents the
compiler from tearing the store to page->mapping?

The writer does this:

	CPU 0
	page_add_new_anon_rmap()
	  page->mapping = anon_vma + PAGE_MAPPING_ANON
	lru_cache_add_inactive_or_unevictable()
	  spin_lock(lruvec->lock)
	  SetPageLRU()
	  spin_unlock(lruvec->lock)

The concern is what CPU 1 will observe at page->mapping after
observing PageLRU set on the page.

1. anon_vma + PAGE_MAPPING_ANON

   That's the in-order scenario and is fine.

2. NULL

   That's possible if the page->mapping store gets reordered to occur
   after SetPageLRU. That's fine too because we check for it.

3. anon_vma without the PAGE_MAPPING_ANON bit

   That would be a problem and could lead to all kinds of undesirable
   behavior including crashes and data corruption.

   Is it possible? AFAICT the compiler is allowed to tear the store to
   page->mapping and I don't see anything that would prevent it.

That said, I also don't see how the reader testing PageLRU under the
lru_lock would prevent that in the first place. AFAICT we need that
WRITE_ONCE() around the page->mapping assignment that's referenced in
the changelog of this patch but I cannot find in any tree or patch.

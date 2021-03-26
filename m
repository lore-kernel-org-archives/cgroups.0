From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: page_alloc: fix memcg accounting leak in speculative
 cache lookup
Date: Thu, 25 Mar 2021 18:55:42 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2103251716160.12404@eggly.anvils>
References: <20210319071547.60973-1-hannes@cmpxchg.org> <alpine.LSU.2.11.2103191814040.1043@eggly.anvils> <YFo7SOni0s0TbXUm@cmpxchg.org> <alpine.LSU.2.11.2103231310020.5513@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=ZvZ0RS30oAxTLDWRkfqE/2UEJY6hgUZS7U8cJyx4zLY=;
        b=gyRHPbPgpyrmyP7q7H1xnW9kekZkeD2scJjWrijqz9tR9VgWop6RmZNIwDMI4yG7cn
         Q0rK2u3XBKItnj1+UZd+C+qLWkzvPrIeICeY0Ee9WBDWJiMH+iqPVqDaaBy6F5ddAQxb
         +tw/1SxSYWNkvdSPaLz4M/yqNGhJ4XQS22oJlBcXmIWWEcLg1cPotmBtQNL+aURpfjSe
         qZOo3xJWH+7TbPr6GvF7OSOEyyLpUTHDES+WHxjRmelNrkyNhI+Thv1D9lestAosK297
         sLGaOuufx0zQfPXxzCVdzpmM0SKOv6VjOKLYfoK488ehJdEiwEmcJRhuIsN61nNB6WS5
         8pEg==
In-Reply-To: <alpine.LSU.2.11.2103231310020.5513-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Zhou Guanghui <zhouguanghui1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, 23 Mar 2021, Hugh Dickins wrote:
> On Tue, 23 Mar 2021, Johannes Weiner wrote:
> > From f6f062a3ec46f4fb083dcf6792fde9723f18cfc5 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date: Fri, 19 Mar 2021 02:17:00 -0400
> > Subject: [PATCH] mm: page_alloc: fix allocation imbalances from speculative
> >  cache lookup
> > 
> > When the freeing of a higher-order page block (non-compound) races
> > with a speculative page cache lookup, __free_pages() needs to leave
> > the first order-0 page in the chunk to the lookup but free the buddy
> > pages that the lookup doesn't know about separately.
> > 
> > There are currently two problems with it:
> > 
> > 1. It checks PageHead() to see whether we're dealing with a compound
> >    page after put_page_testzero(). But the speculative lookup could
> >    have freed the page after our put and cleared PageHead, in which
> >    case we would double free the tail pages.
> > 
> >    To fix this, test PageHead before the put and cache the result for
> >    afterwards.
> > 
> > 2. If such a higher-order page is charged to a memcg (e.g. !vmap
> >    kernel stack)), only the first page of the block has page->memcg
> >    set. That means we'll uncharge only one order-0 page from the
> >    entire block, and leak the remainder.
> > 
> >    To fix this, add a split_page_memcg() before it starts freeing tail
> >    pages, to ensure they all have page->memcg set up.
> > 
> > While at it, also update the comments a bit to clarify what exactly is
> > happening to the page during that race.
> > 
> > Fixes: e320d3012d25 mm/page_alloc.c: fix freeing non-compound pages

Whoops, misses ("...") around the title.

> > Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reported-by: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.10+
> 
> This is great, thanks Hannes.
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Sorry, I am ashamed to do this, but now I renege and say NAK:
better now than before Andrew picks it up.

The first reason occurred to me this morning.  I thought I had been
clever to spot the PageHead race which you fix here.  But now I just feel
very stupid not to have spotted the very similar memcg_data race.  The
speculative racer may call mem_cgroup_uncharge() from __put_single_page(),
and the new call to split_page_memcg() do nothing because page_memcg(head)
is already NULL.

And is it even safe there, to sprinkle memcg_data through all of those
order-0 subpages, when free_the_page() is about to be applied to a
series of descending orders?  I could easily be wrong, but I think
free_pages_prepare()'s check_free_page() will find that is not
page_expected_state().

And what gets to do the uncharging when memcg_data is properly set
on the appropriate order-N subpages?  I believe it's the (second)
__memcg_kmem_uncharge_page() in free_pages_prepare(), but that's
only called if PageMemcgKmem().  Ah, good, Roman's changes have put
that flag into memcg_data, so it will automatically be set: but this
patch will not port back to 5.10 without some addition.

But, after all that, I'm now thinking that Matthew's original
e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
is safer reverted.  The put_page_testzero() in __free_pages() was
not introduced for speculative pagecache: it was there in 2.4.0,
and atomic_dec_and_test() in 2.2, I don't have older trees to hand.

So, it has "always" been accepted that multiple references to a
high-order non-compound page can be given out and released: maybe
they were all released with __free_pages() of the right order, or
maybe only the last had to get that right; but as __free_pages()
stands today, all but the last caller frees all but the first
subpage.  A very rare leak seems much safer.

I don't have the answer (find somewhere in struct page to squirrel
away the order, even when it's a non-compound page?), and I think
each of us would much rather be thinking about other things at the
moment.  But for now it looks to me like NAK to this patch, and
revert of e320d3012d25.

> 
> I know that 5.10-stable rejected the two split_page_memcg() patches:
> we shall need those in, I'll send GregKH the fixups, but not today.

Done, and Sasha has picked them up.  But in writing that "Ah, good,
Roman's changes ..." paragraph, I've begun to wonder if what I sent
was complete - does a 5.10 split_page_memcg(), when called from
split_page(), also need to copy head's PageKmemcg? I rather think
yes, but by now I'm unsure of everything...

Hugh

> 
> > ---
> >  mm/page_alloc.c | 41 +++++++++++++++++++++++++++++++++++------
> >  1 file changed, 35 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c53fe4fa10bf..8aab1e87fa3c 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5112,10 +5112,9 @@ static inline void free_the_page(struct page *page, unsigned int order)
> >   * the allocation, so it is easy to leak memory.  Freeing more memory
> >   * than was allocated will probably emit a warning.
> >   *
> > - * If the last reference to this page is speculative, it will be released
> > - * by put_page() which only frees the first page of a non-compound
> > - * allocation.  To prevent the remaining pages from being leaked, we free
> > - * the subsequent pages here.  If you want to use the page's reference
> > + * This function isn't a put_page(). Don't let the put_page_testzero()
> > + * fool you, it's only to deal with speculative cache references. It
> > + * WILL free pages directly. If you want to use the page's reference
> >   * count to decide when to free the allocation, you should allocate a
> >   * compound page, and use put_page() instead of __free_pages().
> >   *
> > @@ -5124,11 +5123,41 @@ static inline void free_the_page(struct page *page, unsigned int order)
> >   */
> >  void __free_pages(struct page *page, unsigned int order)
> >  {
> > -	if (put_page_testzero(page))
> > +	bool compound = PageHead(page);
> > +
> > +	/*
> > +	 * Drop the base reference from __alloc_pages and free. In
> > +	 * case there is an outstanding speculative reference, from
> > +	 * e.g. the page cache, it will put and free the page later.
> > +	 */
> > +	if (likely(put_page_testzero(page))) {
> >  		free_the_page(page, order);
> > -	else if (!PageHead(page))
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Ok, the speculative reference will put and free the page.
> > +	 *
> > +	 * - If this was an order-0 page, we're done.
> > +	 *
> > +	 * - If the page was compound, the other side will free the
> > +	 *   entire page and we're done here as well. Just note that
> > +	 *   freeing clears PG_head, so it can only be read reliably
> > +	 *   before the put_page_testzero().
> > +	 *
> > +	 * - If the page was of higher order but NOT marked compound,
> > +	 *   the other side will know nothing about our buddy pages
> > +	 *   and only free the order-0 page at the start of our block.
> > +	 *   We must split off and free the buddy pages here.
> > +	 *
> > +	 *   The buddy pages aren't individually refcounted, so they
> > +	 *   can't have any pending speculative references themselves.
> > +	 */
> > +	if (order > 0 && !compound) {
> > +		split_page_memcg(page, 1 << order);
> >  		while (order-- > 0)
> >  			free_the_page(page + (1 << order), order);
> > +	}
> >  }
> >  EXPORT_SYMBOL(__free_pages);
> >  
> > -- 
> > 2.31.0

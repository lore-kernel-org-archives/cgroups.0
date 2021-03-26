From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: page_alloc: fix memcg accounting leak in speculative
 cache lookup
Date: Thu, 25 Mar 2021 21:04:40 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2103252018170.13067@eggly.anvils>
References: <20210319071547.60973-1-hannes@cmpxchg.org> <alpine.LSU.2.11.2103191814040.1043@eggly.anvils> <YFo7SOni0s0TbXUm@cmpxchg.org> <alpine.LSU.2.11.2103231310020.5513@eggly.anvils> <alpine.LSU.2.11.2103251716160.12404@eggly.anvils>
 <20210326025143.GB1719932@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xeJRI/bSrn1eC4w9Rqatogj3zx30m75cryPTZk0CO7o=;
        b=wIoSYann9vLV5TBBngoEF/fhWRXoVEs2/a/Nma/eiT81J6J79Ec1J2FRlo036zBd17
         6j2v7Nrk+eQlCwdKc/b5X3Cn4GStVjxNug8VVdVnB66+vhUE4q1EvVG8NfXfCQIa4jnm
         8Lkn0zKQX9xndeM9wR6TU2ecnWyT5QdGfDzcELVCrwlA0f/n9QTzWowTd3AWTFvEUuRX
         KSp5F435PbNcqtkv3K0aliXXoGKExDfDBAQ7LW24N8EPrdK5b3xeN370kioD4ps9ECS8
         ibR60tg+18LUMuZ5XOLjeQvWY9Hd5WGylFGu6Sj7m6HPwE8lRARm/JLe0Ih09NibUU38
         PEWQ==
In-Reply-To: <20210326025143.GB1719932-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Zhou Guanghui <zhouguanghui1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, 26 Mar 2021, Matthew Wilcox wrote:
> On Thu, Mar 25, 2021 at 06:55:42PM -0700, Hugh Dickins wrote:
> > The first reason occurred to me this morning.  I thought I had been
> > clever to spot the PageHead race which you fix here.  But now I just feel
> > very stupid not to have spotted the very similar memcg_data race.  The
> > speculative racer may call mem_cgroup_uncharge() from __put_single_page(),
> > and the new call to split_page_memcg() do nothing because page_memcg(head)
> > is already NULL.
> > 
> > And is it even safe there, to sprinkle memcg_data through all of those
> > order-0 subpages, when free_the_page() is about to be applied to a
> > series of descending orders?  I could easily be wrong, but I think
> > free_pages_prepare()'s check_free_page() will find that is not
> > page_expected_state().
> 
> So back to something more like my original patch then?
> 
> +++ b/mm/page_alloc.c
> @@ -5081,9 +5081,15 @@ void __free_pages(struct page *page, unsigned int order)
>  {
>         if (put_page_testzero(page))
>                 free_the_page(page, order);
> -	else if (!PageHead(page))
> -               while (order-- > 0)
> -                       free_the_page(page + (1 << order), order);
> +       else if (!PageHead(page)) {
> +               while (order-- > 0) {
> +                       struct page *tail = page + (1 << order);
> +#ifdef CONFIG_MEMCG
> +                       tail->memcg_data = page->memcg_data;
> +#endif
> +                       free_the_page(tail, order);
> +               }
> +       }
>  }
>  EXPORT_SYMBOL(__free_pages);
> 
> We can cache page->memcg_data before calling put_page_testzero(),
> just like we cache the Head flag in Johannes' patch.

If I still believed in e320d3012d25, yes, that would look right
(but I don't have much faith in my judgement after all this).

I'd fallen in love with split_page_memcg() when you posted that
one, and was put off by your #ifdef, so got my priorities wrong
and went for the split_page_memcg().

> 
> > But, after all that, I'm now thinking that Matthew's original
> > e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
> > is safer reverted.  The put_page_testzero() in __free_pages() was
> > not introduced for speculative pagecache: it was there in 2.4.0,
> > and atomic_dec_and_test() in 2.2, I don't have older trees to hand.
> 
> I think you're confused in that last assertion.  According to
> linux-fullhistory, the first introduction of __free_pages was 2.3.29pre3
> (September 1999), where it did indeed use put_page_testzero:

Not confused, just pontificating from a misleading subset of the data.
I knew there's an even-more-history-than-tglx git tree somewhere, but
what I usually look back to is 2.4 trees, plus a 2.2.26 tree - but of
course that's a late 2.2, from 2004, around the same time as 2.6.3.
That tree shows a __free_pages() using atomic_dec_and_test().

But we digress...

> 
> +extern inline void __free_pages(struct page *page, unsigned long order)
> +{
> +       if (!put_page_testzero(page))
> +               return;
> +       __free_pages_ok(page, order);
> +}
> 
> Before that, we had only free_pages() and __free_page().
> 
> > So, it has "always" been accepted that multiple references to a
> > high-order non-compound page can be given out and released: maybe
> > they were all released with __free_pages() of the right order, or
> > maybe only the last had to get that right; but as __free_pages()
> > stands today, all but the last caller frees all but the first
> > subpage.  A very rare leak seems much safer.
> > 
> > I don't have the answer (find somewhere in struct page to squirrel
> > away the order, even when it's a non-compound page?), and I think
> > each of us would much rather be thinking about other things at the
> > moment.  But for now it looks to me like NAK to this patch, and
> > revert of e320d3012d25.
> 
> We did discuss that possibility prior to the introduction of
> e320d3012d25.  Here's one such:
> https://lore.kernel.org/linux-mm/20200922031215.GZ32101-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org/T/#m0b08c0c3430e09e20fa6648877dc42b04b18e6f3

Thanks for the link. And I'll willingly grant that your experience is
vast compared to mine. But "Drivers don't do that, in my experience"
is not a convincing reason to invalidate a way of working that the
code has gone out of its way to allow for, for over twenty years.

But you make a good point on the "Bad page" reports that would now
be generated: maybe that will change my mind later on.

Hugh

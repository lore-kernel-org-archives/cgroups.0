From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: swap: fix update_page_reclaim_stat for huge pages
Date: Sat, 9 May 2020 07:06:48 -0700
Message-ID: <CALvZod5DyMK0uGhPD5oYjds0Q8ew=1LTqjbHK4YLdsqrfYQqWg@mail.gmail.com>
References: <20200508212215.181307-1-shakeelb@google.com> <20200508212215.181307-3-shakeelb@google.com>
 <20200508215122.GB226164@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jc93T48//PCz7sdPyS0gIAsQLpsU+tV5Kt0CzqYwNik=;
        b=uF4uQoe+Y/Rjx41fEplRhUf+B9x5B5F/LKDeKQu+D8rktHPDMcvcrKJ2M9QRQslZfS
         pxpEfjWspPHF07KZa4jVhaeDrW9r2+L6O38kBjVzIONl+siiFRvZHre6UUqVfO5njY4B
         dclVPiAKKVgD9sk/qgxT+kxi1bWfRfD1eDSbafMPpBgtnE3jIzAu//+1lQ4e92NmJfmj
         LCTOgnamNTrgmOw5HmZ+CAhGi7SIJy6XSOZNlSbK8eezV94DWGSsmsC1Idq4uY50QrbP
         w0b4AnWsem9n7jdd6EvNgGuGM5FgnEYGAQe4NPYrBycRSJed3lj+S+y6HdS2UnvQtkqG
         9oyQ==
In-Reply-To: <20200508215122.GB226164-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 8, 2020 at 2:51 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Fri, May 08, 2020 at 02:22:15PM -0700, Shakeel Butt wrote:
> > Currently update_page_reclaim_stat() updates the lruvec.reclaim_stats
> > just once for a page irrespective if a page is huge or not. Fix that by
> > passing the hpage_nr_pages(page) to it.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> https://lore.kernel.org/patchwork/patch/685703/
>
> Laughs, then cries.
>

What happened to that patch? Fell through the cracks?

> > @@ -928,7 +928,7 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
> >       }
> >
> >       if (!PageUnevictable(page))
> > -             update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
> > +             update_page_reclaim_stat(lruvec, file, PageActive(page_tail), 1);
>
> The change to __pagevec_lru_add_fn() below makes sure the tail pages
> are already accounted. This would make them count twice.
>

Yes, you are right. I will just re-send your patch after rebase.



> >  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >
> > @@ -973,7 +973,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
> >       if (page_evictable(page)) {
> >               lru = page_lru(page);
> >               update_page_reclaim_stat(lruvec, page_is_file_lru(page),
> > -                                      PageActive(page));
> > +                                      PageActive(page), nr_pages);
> >               if (was_unevictable)
> >                       __count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
> >       } else {

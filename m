From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/5] mm: Split release_pages work into 3 passes
Date: Wed, 19 Aug 2020 07:57:16 -0700
Message-ID: <CAKgT0UepdfjXn=j8e4xEBFmsNJdzJyN57em8dscr-Er4OBZCOg@mail.gmail.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042730.23414.41309.stgit@localhost.localdomain> <15edf807-ce03-83f7-407d-5929341b2b4e@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VDgt+NfpwH6U6r2hvHr0dBMMv6qNBbALooemz8NFh5U=;
        b=f+ZY76s5TRKLUXDOUW1UKWMOshJmecMeQftVcBsCsWkWr4125JZu9WJtY2mpOhQoPG
         qsJ/dGsIR4iuWMWEBeaCXI22z2X+muEGh5TnoFmIDerzN/VXAPAsbPN/7xR8Dk2eGWx4
         w4VaCqCZAoGVIR1bl2Smo3+3TxHihbXBwp9Ciz1699llS6GM6yAvU/XbPjS9Q72K3Pge
         qtxmOF26p1U8NUaDlBngBuqZz1LHwJQqQGV9gjb/PYz4tx7Z16p/BVOLCP4Bur07EFLS
         R2gYxBW87NUAFuNuUQubaJdFH84qd2+y7N8LItneA+hKUh1pddYAeHTHUiPrPqKxB4ke
         G4dA==
In-Reply-To: <15edf807-ce03-83f7-407d-5929341b2b4e-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Wed, Aug 19, 2020 at 12:54 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrot=
e:
>
>
>
> =E5=9C=A8 2020/8/19 =E4=B8=8B=E5=8D=8812:27, Alexander Duyck =E5=86=99=E9=
=81=93:
> > From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > The release_pages function has a number of paths that end up with the
> > LRU lock having to be released and reacquired. Such an example would be=
 the
> > freeing of THP pages as it requires releasing the LRU lock so that it c=
an
> > be potentially reacquired by __put_compound_page.
> >
> > In order to avoid that we can split the work into 3 passes, the first
> > without the LRU lock to go through and sort out those pages that are no=
t in
> > the LRU so they can be freed immediately from those that can't. The sec=
ond
> > pass will then go through removing those pages from the LRU in batches =
as
> > large as a pagevec can hold before freeing the LRU lock. Once the pages=
 have
> > been removed from the LRU we can then proceed to free the remaining pag=
es
> > without needing to worry about if they are in the LRU any further.
> >
> > The general idea is to avoid bouncing the LRU lock between pages and to
> > hopefully aggregate the lock for up to the full page vector worth of pa=
ges.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  mm/swap.c |  109 +++++++++++++++++++++++++++++++++++++----------------=
--------
> >  1 file changed, 67 insertions(+), 42 deletions(-)
> >
> > diff --git a/mm/swap.c b/mm/swap.c
> > index fe53449fa1b8..b405f81b2c60 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -795,6 +795,54 @@ void lru_add_drain_all(void)
> >  }
> >  #endif
> >
> > +static void __release_page(struct page *page, struct list_head *pages_=
to_free)
> > +{
> > +     if (PageCompound(page)) {
> > +             __put_compound_page(page);
> > +     } else {
> > +             /* Clear Active bit in case of parallel mark_page_accesse=
d */
> > +             __ClearPageActive(page);
> > +             __ClearPageWaiters(page);
> > +
> > +             list_add(&page->lru, pages_to_free);
> > +     }
> > +}
> > +
> > +static void __release_lru_pages(struct pagevec *pvec,
> > +                             struct list_head *pages_to_free)
> > +{
> > +     struct lruvec *lruvec =3D NULL;
> > +     unsigned long flags =3D 0;
> > +     int i;
> > +
> > +     /*
> > +      * The pagevec at this point should contain a set of pages with
> > +      * their reference count at 0 and the LRU flag set. We will now
> > +      * need to pull the pages from their LRU lists.
> > +      *
> > +      * We walk the list backwards here since that way we are starting=
 at
> > +      * the pages that should be warmest in the cache.
> > +      */
> > +     for (i =3D pagevec_count(pvec); i--;) {
> > +             struct page *page =3D pvec->pages[i];
> > +
> > +             lruvec =3D relock_page_lruvec_irqsave(page, lruvec, &flag=
s);
>
> the lock bounce is better with the patch, would you like to do further
> like using add_lruvecs to reduce bounce more?
>
> Thanks
> Alex

I'm not sure how much doing something like that would add. In my case
I had a very specific issue that this is addressing which is the fact
that every compound page was taking the LRU lock and zone lock
separately. With this patch that is reduced to one LRU lock per 15
pages and then the zone lock per page. By adding or sorting pages by
lruvec I am not sure there will be much benefit as I am not certain
how often we will end up with pages being interleaved between multiple
lruvecs. In addition as I am limiting the quantity to a pagevec which
limits the pages to 15 I am not sure there will be much benefit to be
seen for sorting the pages beforehand.

Thanks.

- Alex

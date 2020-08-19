From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 5/5] mm: Split move_pages_to_lru into 3 separate passes
Date: Wed, 19 Aug 2020 07:42:41 -0700
Message-ID: <CAKgT0Ud3CZ8KHLXCrWNGJAX85x23-EWLnAV63-NMmJ+5vD1JAA@mail.gmail.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042738.23414.60815.stgit@localhost.localdomain> <084c58a7-7aac-820c-9606-19391c35b9b5@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mcVXNr/miBqBqBzPd9zMl9/P3yj0Py/DDVO/2K9/W8w=;
        b=We78s8aeZBHNS8HsXJOECFtjGX0yBLXCmD9JNUeoRZJB6mQznUcKYUARlp2d8bBHSj
         3MYtOox2aoiTCMZJHQ0aLbKAufrXDvLthlw1SYtqfpmsKIMKJ2AKJcyGEV9+c8l1w3Z1
         gCVfjavBkDJIkR3fUr3gg57fqGnCjcqa0v128cNDQur3H2RzKvtWNedO3MfQvg9dIMe3
         FJzHgpcTQvnbz5Ng96Mgg/91NthBPq/wlMFrT2EQKdfpKbLD5aEGeARJ24zu4Vn9Jf2V
         ilqu/6IJiEUpeCdUs/PwxW30G3jBBEkpPghitItA81NmeiUXeGHVXCopiMY4J/OlNh08
         ToMQ==
In-Reply-To: <084c58a7-7aac-820c-9606-19391c35b9b5-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Wed, Aug 19, 2020 at 12:58 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrot=
e:
>
>
>
> =E5=9C=A8 2020/8/19 =E4=B8=8B=E5=8D=8812:27, Alexander Duyck =E5=86=99=E9=
=81=93:
> > From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > The current code for move_pages_to_lru is meant to release the LRU lock
> > every time it encounters an unevictable page or a compound page that mu=
st
> > be freed. This results in a fair amount of code bulk because the lruvec=
 has
> > to be reacquired every time the lock is released and reacquired.
> >
> > Instead of doing this I believe we can break the code up into 3 passes.=
 The
> > first pass will identify the pages we can move to LRU and move those. I=
n
> > addition it will sort the list out leaving the unevictable pages in the
> > list and moving those pages that have dropped to a reference count of 0=
 to
> > pages_to_free. The second pass will return the unevictable pages to the
> > LRU. The final pass will free any compound pages we have in the
> > pages_to_free list before we merge it back with the original list and
> > return from the function.
> >
> > The advantage of doing it this way is that we only have to release the =
lock
> > between pass 1 and 2, and then we reacquire the lock after pass 3 after=
 we
> > merge the pages_to_free back into the original list. As such we only ha=
ve
> > to release the lock at most once in an entire call instead of having to
> > test to see if we need to relock with each page.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  mm/vmscan.c |   68 ++++++++++++++++++++++++++++++++++-----------------=
--------
> >  1 file changed, 39 insertions(+), 29 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3ebe3f9b653b..6a2bdbc1a9eb 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1850,22 +1850,21 @@ static unsigned noinline_for_stack move_pages_t=
o_lru(struct lruvec *lruvec,
> >  {
> >       int nr_pages, nr_moved =3D 0;
> >       LIST_HEAD(pages_to_free);
> > -     struct page *page;
> > -     struct lruvec *orig_lruvec =3D lruvec;
> > +     struct page *page, *next;
> >       enum lru_list lru;
> >
> > -     while (!list_empty(list)) {
> > -             page =3D lru_to_page(list);
> > +     list_for_each_entry_safe(page, next, list, lru) {
> >               VM_BUG_ON_PAGE(PageLRU(page), page);
> > -             list_del(&page->lru);
> > -             if (unlikely(!page_evictable(page))) {
> > -                     if (lruvec) {
> > -                             spin_unlock_irq(&lruvec->lru_lock);
> > -                             lruvec =3D NULL;
> > -                     }
> > -                     putback_lru_page(page);
> > +
> > +             /*
> > +              * if page is unevictable leave it on the list to be retu=
rned
> > +              * to the LRU after we have finished processing the other
> > +              * entries in the list.
> > +              */
> > +             if (unlikely(!page_evictable(page)))
> >                       continue;
> > -             }
> > +
> > +             list_del(&page->lru);
> >
> >               /*
> >                * The SetPageLRU needs to be kept here for list intergri=
ty.
> > @@ -1878,20 +1877,14 @@ static unsigned noinline_for_stack move_pages_t=
o_lru(struct lruvec *lruvec,
> >                *     list_add(&page->lru,)
> >                *                                        list_add(&page-=
>lru,)
> >                */
> > -             lruvec =3D relock_page_lruvec_irq(page, lruvec);
>
> It's actually changed the meaning from current func. which I had seen a b=
ug if no relock.
> but after move to 5.9 kernel, I can not reprodce the bug any more. I am n=
ot sure if 5.9 fixed
> the problem, and we don't need relock here.

So I am not sure what you mean here about "changed the meaning from
the current func". Which function are you referring to and what
changed?

From what I can tell the pages cannot change memcg because they were
isolated and had the LRU flag stripped. They shouldn't be able to
change destination LRU vector as a result. Assuming that, then they
can all be processed under same LRU lock and we can avoid having to
release it until we are forced to do so to call putback_lru_page or
destroy the compound pages that were freed while we were shrinking the
LRU lists.

> For the rest of this patch.
> Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Thanks for the review.

- Alex

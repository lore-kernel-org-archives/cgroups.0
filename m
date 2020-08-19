From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/5] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 19 Aug 2020 07:52:09 -0700
Message-ID: <CAKgT0UeZa_-hpeV5X_PEf3sz9HSRsnLMgPSu6Zqb5wZ-H0jEhw@mail.gmail.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042722.23414.2654.stgit@localhost.localdomain> <cc993d93-a5af-dd29-19f4-176ba86000e1@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tScvbNwkYnRqhhATPJ7UjpnLY9tTLi+iAPlBc9rB3iY=;
        b=VNV2FDB4prOhD7krvEKqNRccc1tIE3ic5uWeIuDwt90ZWFOeL9havI3q4VWlHeDNlD
         uX4QctT6sFkcZWlNwOUZBAhC/iupzupsuaErPhzT+hlDNLUmnr4kgfjEGWXt8gMext8c
         cwcsyhcty5Qifn13F1KfJQf+979yllT0BJpyWnMYHpQWw+goI30FSA2OJ9jnDoHnwrvx
         idKl3jZ7EBFt5GgiHIEFz8JalGse5Hvwjr4tsZsSU9/99CqD/yc0FyUux/NERNg/tT9L
         /GQFmg6aYSFpKCG/utfJlBNzWbz8PKJEZx5Th8eOvf+1KdoanUNVoXNh55++qa10pIl2
         gQIA==
In-Reply-To: <cc993d93-a5af-dd29-19f4-176ba86000e1-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Wed, Aug 19, 2020 at 12:52 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrot=
e:
>
>
>
> =E5=9C=A8 2020/8/19 =E4=B8=8B=E5=8D=8812:27, Alexander Duyck =E5=86=99=E9=
=81=93:
> > From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > In isolate_lru_pages we have an exception path where if we call
> > get_page_unless_zero and that succeeds, but TestClearPageLRU fails we c=
all
> > put_page. Normally this would be problematic but due to the way that th=
e
> > calls are ordered and the fact that we are holding the LRU lock we know
> > that the caller must be holding another reference for the page. Since w=
e
> > can assume that we can replace the put_page with a call to
> > put_page_testzero contained within a WARN_ON. By doing this we should s=
ee
> > if we ever leak a page as a result of the reference count somehow hitti=
ng
> > zero when it shouldn't, and can avoid the overhead and confusion of usi=
ng
> > the full put_page call.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  mm/vmscan.c |    9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 5bc0c2322043..3ebe3f9b653b 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned=
 long nr_to_scan,
> >
> >                       if (!TestClearPageLRU(page)) {
> >                               /*
> > -                              * This page may in other isolation path,
> > -                              * but we still hold lru_lock.
> > +                              * This page is being isolated in another
> > +                              * thread, but we still hold lru_lock. Th=
e
> > +                              * other thread must be holding a referen=
ce
> > +                              * to the page so this should never hit a
> > +                              * reference count of 0.
> >                                */
> > -                             put_page(page);
> > +                             WARN_ON(put_page_testzero(page));
>
> seems WARN_ON is always enabled.
>
> Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Yeah, it is always enabled however it should never be triggered. I had
considered just putting a page_ref_dec here since in theory this path
should never be triggered but I thought as a debug catch I add the
WARN_ON and put_page_testzero. If we ever do encounter this being
triggered then it will leak a page of memory which isn't the end of
the world but I thought would warrant a WARN_ON.

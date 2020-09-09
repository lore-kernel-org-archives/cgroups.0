From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 31/32] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 9 Sep 2020 08:43:38 -0700
Message-ID: <CAKgT0UcjNx=00OgAQNWezc7UjLmF2NcDH0p7kzZ5D23PaFrFXA@mail.gmail.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-32-git-send-email-alex.shi@linux.alibaba.com> <20200909010118.GB6583@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=njXoLvZWKDzgHgUldBb8FCQl7wLEH3o051fzPgYKUzA=;
        b=OXYBsOpJaPJjHDyrkcUk+PyH9weu7WrPHfYqhpvGyOnyptfQy0qhQz4xgNrVbzAPhG
         4EznyVNSEsu9VZOqoDRavkm19wlITmVn+L4ArXSdcDx3H5CtJXyc04NkdjUY3lRN+9WL
         sk25yW/qryEHSt/mBDKjbyrMFUXSkqajY5GNs5vitrGm+uixoAlcmTXu/i+GhuHe7jvy
         9iL8WzWtmYOb1r8mplrdU9Q06Vz/oiqndgajAhg3ejSIcCONS/qfX28RPQ2dn0VxZiVi
         GixDzQM8W6Qo6vBu/aW4LWCkllKJ1sFszcT4QDnPBxD4kkjptM1gJ3X5+GerPu81XW4F
         5fUQ==
In-Reply-To: <20200909010118.GB6583-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Alexander Duyck <alexander.>

On Tue, Sep 8, 2020 at 6:01 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Mon, Aug 24, 2020 at 08:55:04PM +0800, Alex Shi wrote:
> > +++ b/mm/vmscan.c
> > @@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> >
> >                       if (!TestClearPageLRU(page)) {
> >                               /*
> > -                              * This page may in other isolation path,
> > -                              * but we still hold lru_lock.
> > +                              * This page is being isolated in another
> > +                              * thread, but we still hold lru_lock. The
> > +                              * other thread must be holding a reference
> > +                              * to the page so this should never hit a
> > +                              * reference count of 0.
> >                                */
> > -                             put_page(page);
> > +                             WARN_ON(put_page_testzero(page));
> >                               goto busy;
>
> I read Hugh's review and that led me to take a look at this.  We don't
> do it like this.  Use the same pattern as elsewhere in mm:
>
>         page_ref_sub(page, nr);
>         VM_BUG_ON_PAGE(page_count(page) <= 0, page);
>
>

Actually for this case page_ref_dec(page) would make more sense
wouldn't it? Otherwise I agree that would be a better change if that
is the way it has been handled before. I just wasn't familiar with
those other spots.

Thanks.

- Alex

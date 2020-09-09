From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v18 31/32] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 9 Sep 2020 18:07:17 +0100
Message-ID: <20200909170717.GK6583@casper.infradead.org>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-32-git-send-email-alex.shi@linux.alibaba.com>
 <20200909010118.GB6583@casper.infradead.org>
 <CAKgT0UcjNx=00OgAQNWezc7UjLmF2NcDH0p7kzZ5D23PaFrFXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6BdBPXJ8XQ6dfeqF8dncKUjTFopmPuRS/B/dl8JZcac=; b=hfgEADwyatdZgRCv4HedPewUgr
        Z5yHyqRWXGgLxnBngNkckmik9vLonqHLyt6/X2g0X64afWCiiVrXixO7LMWLj5L65iwEQ04DOAIqW
        W0pR5PZbCGyIMkEO713IdjH8mBkU/FmFPGEWPXSQ4hC6jURyfYG6idODxcWpMgdxyrIgUHxZBlLv9
        +8rLnXwL1R7IW/voe+UYGk6bwztj7l+VQpqkLfxrHU10aEcahIA7WaxW486c2weui77TBhr9DECJ7
        R9nMf6JsMmQTjIHXKEcHK0QPRg1x8DKJJ+iB4U2GbKJNdRsI07LfPl3hXVGRn45fFkhqn6+2MIZzs
        Xi+cpe4A==;
Content-Disposition: inline
In-Reply-To: <CAKgT0UcjNx=00OgAQNWezc7UjLmF2NcDH0p7kzZ5D23PaFrFXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Alexander Duyck <alexander.>

On Wed, Sep 09, 2020 at 08:43:38AM -0700, Alexander Duyck wrote:
> On Tue, Sep 8, 2020 at 6:01 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Mon, Aug 24, 2020 at 08:55:04PM +0800, Alex Shi wrote:
> > > +++ b/mm/vmscan.c
> > > @@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > >
> > >                       if (!TestClearPageLRU(page)) {
> > >                               /*
> > > -                              * This page may in other isolation path,
> > > -                              * but we still hold lru_lock.
> > > +                              * This page is being isolated in another
> > > +                              * thread, but we still hold lru_lock. The
> > > +                              * other thread must be holding a reference
> > > +                              * to the page so this should never hit a
> > > +                              * reference count of 0.
> > >                                */
> > > -                             put_page(page);
> > > +                             WARN_ON(put_page_testzero(page));
> > >                               goto busy;
> >
> > I read Hugh's review and that led me to take a look at this.  We don't
> > do it like this.  Use the same pattern as elsewhere in mm:
> >
> >         page_ref_sub(page, nr);
> >         VM_BUG_ON_PAGE(page_count(page) <= 0, page);
> 
> Actually for this case page_ref_dec(page) would make more sense
> wouldn't it? Otherwise I agree that would be a better change if that
> is the way it has been handled before. I just wasn't familiar with
> those other spots.

Yes, page_ref_dec() should be fine.  It's hard to remember which of
VM_BUG_ON, WARN_ON, etc, compile down to nothing with various CONFIG
options, and which ones actually evalauate their arguments.  Safer not
to put things with side-effects inside macros.

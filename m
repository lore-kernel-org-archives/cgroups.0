From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 4/6] mm: unify SLAB and SLUB page accounting
Date: Wed, 24 Apr 2019 12:40:59 -0700
Message-ID: <CALvZod7sG+sD76dQmMhXa92=zpXz=wdUcsR9ah7YRj13g=YT+g@mail.gmail.com>
References: <20190423213133.3551969-1-guro@fb.com> <20190423213133.3551969-5-guro@fb.com>
 <CALvZod6A43nQgkYj38K4h_ZYLSmYp0xJwO7n44kGJx2Ut7-EVg@mail.gmail.com> <20190424191706.GA26707@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yniv5sy+5BQNRUjtlaSRpscFDyrU4/SisoLwlgAM2ng=;
        b=HSQGlCABvRIZPxZA8AOq9czRV7ZfXLMVbzQJ3+KvICA6fAiq4fTXLdIW4I9pcAK5Ar
         J+DJ/nbaXuY3mcsBwclwSQbl8CvBRvPVpIS3X80Q33eYOZKD7jYDyFucYjA3EpdqGupt
         K2FB85/z9856MjrPeLO6FF0Jm97fu+CWhTWj1Vdn3CGKACt4d1cJFkbwKCIGLs/yOjCd
         MngXQA1Gc0EtXw+FzBHSUypHSaaqwPOeSCyBaCn8Hus3JFZtQSJIdPAtrU1hGAOOuF+/
         g1VzjfOuDMEfuueQgSzVFMoHMKMeE5PDBn3VG6Wr6EjzwrAJY4zJq+5zS72iouyIgmNg
         XZwQ==
In-Reply-To: <20190424191706.GA26707@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 24, 2019 at 12:17 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Wed, Apr 24, 2019 at 10:23:45AM -0700, Shakeel Butt wrote:
> > Hi Roman,
> >
> > On Tue, Apr 23, 2019 at 9:30 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > Currently the page accounting code is duplicated in SLAB and SLUB
> > > internals. Let's move it into new (un)charge_slab_page helpers
> > > in the slab_common.c file. These helpers will be responsible
> > > for statistics (global and memcg-aware) and memcg charging.
> > > So they are replacing direct memcg_(un)charge_slab() calls.
> > >
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > ---
> > >  mm/slab.c | 19 +++----------------
> > >  mm/slab.h | 22 ++++++++++++++++++++++
> > >  mm/slub.c | 14 ++------------
> > >  3 files changed, 27 insertions(+), 28 deletions(-)
> > >
> > > diff --git a/mm/slab.c b/mm/slab.c
> > > index 14466a73d057..53e6b2687102 100644
> > > --- a/mm/slab.c
> > > +++ b/mm/slab.c
> > > @@ -1389,7 +1389,6 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
> > >                                                                 int nodeid)
> > >  {
> > >         struct page *page;
> > > -       int nr_pages;
> > >
> > >         flags |= cachep->allocflags;
> > >
> > > @@ -1399,17 +1398,11 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
> > >                 return NULL;
> > >         }
> > >
> > > -       if (memcg_charge_slab(page, flags, cachep->gfporder, cachep)) {
> > > +       if (charge_slab_page(page, flags, cachep->gfporder, cachep)) {
> > >                 __free_pages(page, cachep->gfporder);
> > >                 return NULL;
> > >         }
> > >
> > > -       nr_pages = (1 << cachep->gfporder);
> > > -       if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
> > > -               mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, nr_pages);
> > > -       else
> > > -               mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, nr_pages);
> > > -
> > >         __SetPageSlab(page);
> > >         /* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
> > >         if (sk_memalloc_socks() && page_is_pfmemalloc(page))
> > > @@ -1424,12 +1417,6 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
> > >  static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
> > >  {
> > >         int order = cachep->gfporder;
> > > -       unsigned long nr_freed = (1 << order);
> > > -
> > > -       if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
> > > -               mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, -nr_freed);
> > > -       else
> > > -               mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, -nr_freed);
> > >
> > >         BUG_ON(!PageSlab(page));
> > >         __ClearPageSlabPfmemalloc(page);
> > > @@ -1438,8 +1425,8 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
> > >         page->mapping = NULL;
> > >
> > >         if (current->reclaim_state)
> > > -               current->reclaim_state->reclaimed_slab += nr_freed;
> > > -       memcg_uncharge_slab(page, order, cachep);
> > > +               current->reclaim_state->reclaimed_slab += 1 << order;
> > > +       uncharge_slab_page(page, order, cachep);
> > >         __free_pages(page, order);
> > >  }
> > >
> > > diff --git a/mm/slab.h b/mm/slab.h
> > > index 4a261c97c138..0f5c5444acf1 100644
> > > --- a/mm/slab.h
> > > +++ b/mm/slab.h
> > > @@ -205,6 +205,12 @@ ssize_t slabinfo_write(struct file *file, const char __user *buffer,
> > >  void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
> > >  int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
> > >
> > > +static inline int cache_vmstat_idx(struct kmem_cache *s)
> > > +{
> > > +       return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> > > +               NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> > > +}
> > > +
> > >  #ifdef CONFIG_MEMCG_KMEM
> > >
> > >  /* List of all root caches. */
> > > @@ -352,6 +358,22 @@ static inline void memcg_link_cache(struct kmem_cache *s,
> > >
> > >  #endif /* CONFIG_MEMCG_KMEM */
> > >
> > > +static __always_inline int charge_slab_page(struct page *page,
> > > +                                           gfp_t gfp, int order,
> > > +                                           struct kmem_cache *s)
> > > +{
> > > +       memcg_charge_slab(page, gfp, order, s);
> >
> > This does not seem right. Why the return of memcg_charge_slab is ignored?
>
> Hi Shakeel!
>
> Right, it's a bug. It's actually fixed later in the patchset
> (in "mm: rework non-root kmem_cache lifecycle management"),
> so the final result looks correct to me. Anyway, I'll fix it.
>
> How does everything else look to you?
>
> Thank you!

I caught this during quick glance. Another high level issue I found is
breakage of /proc/kpagecgroup for the slab pages which is easy to fix.

At the moment I am kind of stuck on some other stuff but will get back
to this in a week or so.

Shakeel

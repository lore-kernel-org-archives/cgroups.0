From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 4/6] mm: unify SLAB and SLUB page accounting
Date: Wed, 24 Apr 2019 19:17:12 +0000
Message-ID: <20190424191706.GA26707@tower.DHCP.thefacebook.com>
References: <20190423213133.3551969-1-guro@fb.com>
 <20190423213133.3551969-5-guro@fb.com>
 <CALvZod6A43nQgkYj38K4h_ZYLSmYp0xJwO7n44kGJx2Ut7-EVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YaopUjZJy+hmGVptkNC+a3/dCOZGizWEQXEvUySQ7qA=;
 b=RlEhoc/kw5Roh6ogLWx45qe5yRQZLRK90uQZbGvl048xjbuvSxz6L1g0QKf1OLFJdJcx
 GDQr6ljSoMzZhmSFe/TDG04R3W3QU5U6Z6Rjg9GUsND7osnxh7zZLPJNMd82mSXnoxGm
 YVpKwk1aUJ8NOAdarIrBQ4nd8bhvWW0mWeQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaopUjZJy+hmGVptkNC+a3/dCOZGizWEQXEvUySQ7qA=;
 b=I3YTA9pzR9DqPZ7I0CR8A4ZGolLHkHL8FCmbicpxEFSk6a4L74E2khRimiVbgM5P988NkmeQT2lPks7gQ50NxPF9RlFaxyr2n2OMvRZXo2s6pk7ERZCwSvUFqW90/pGoz0+uRo91YIiUp0T/dwMSuWwTorBlGIjs1jcG9vVMAkU=
In-Reply-To: <CALvZod6A43nQgkYj38K4h_ZYLSmYp0xJwO7n44kGJx2Ut7-EVg@mail.gmail.com>
Content-Language: en-US
Content-ID: <6FAACE41325E304CBA651E0E42932B9F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 24, 2019 at 10:23:45AM -0700, Shakeel Butt wrote:
> Hi Roman,
>=20
> On Tue, Apr 23, 2019 at 9:30 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > Currently the page accounting code is duplicated in SLAB and SLUB
> > internals. Let's move it into new (un)charge_slab_page helpers
> > in the slab_common.c file. These helpers will be responsible
> > for statistics (global and memcg-aware) and memcg charging.
> > So they are replacing direct memcg_(un)charge_slab() calls.
> >
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  mm/slab.c | 19 +++----------------
> >  mm/slab.h | 22 ++++++++++++++++++++++
> >  mm/slub.c | 14 ++------------
> >  3 files changed, 27 insertions(+), 28 deletions(-)
> >
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 14466a73d057..53e6b2687102 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -1389,7 +1389,6 @@ static struct page *kmem_getpages(struct kmem_cac=
he *cachep, gfp_t flags,
> >                                                                 int nod=
eid)
> >  {
> >         struct page *page;
> > -       int nr_pages;
> >
> >         flags |=3D cachep->allocflags;
> >
> > @@ -1399,17 +1398,11 @@ static struct page *kmem_getpages(struct kmem_c=
ache *cachep, gfp_t flags,
> >                 return NULL;
> >         }
> >
> > -       if (memcg_charge_slab(page, flags, cachep->gfporder, cachep)) {
> > +       if (charge_slab_page(page, flags, cachep->gfporder, cachep)) {
> >                 __free_pages(page, cachep->gfporder);
> >                 return NULL;
> >         }
> >
> > -       nr_pages =3D (1 << cachep->gfporder);
> > -       if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
> > -               mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, nr_pag=
es);
> > -       else
> > -               mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, nr_p=
ages);
> > -
> >         __SetPageSlab(page);
> >         /* Record if ALLOC_NO_WATERMARKS was set when allocating the sl=
ab */
> >         if (sk_memalloc_socks() && page_is_pfmemalloc(page))
> > @@ -1424,12 +1417,6 @@ static struct page *kmem_getpages(struct kmem_ca=
che *cachep, gfp_t flags,
> >  static void kmem_freepages(struct kmem_cache *cachep, struct page *pag=
e)
> >  {
> >         int order =3D cachep->gfporder;
> > -       unsigned long nr_freed =3D (1 << order);
> > -
> > -       if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
> > -               mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, -nr_fr=
eed);
> > -       else
> > -               mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, -nr_=
freed);
> >
> >         BUG_ON(!PageSlab(page));
> >         __ClearPageSlabPfmemalloc(page);
> > @@ -1438,8 +1425,8 @@ static void kmem_freepages(struct kmem_cache *cac=
hep, struct page *page)
> >         page->mapping =3D NULL;
> >
> >         if (current->reclaim_state)
> > -               current->reclaim_state->reclaimed_slab +=3D nr_freed;
> > -       memcg_uncharge_slab(page, order, cachep);
> > +               current->reclaim_state->reclaimed_slab +=3D 1 << order;
> > +       uncharge_slab_page(page, order, cachep);
> >         __free_pages(page, order);
> >  }
> >
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 4a261c97c138..0f5c5444acf1 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -205,6 +205,12 @@ ssize_t slabinfo_write(struct file *file, const ch=
ar __user *buffer,
> >  void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
> >  int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void *=
*);
> >
> > +static inline int cache_vmstat_idx(struct kmem_cache *s)
> > +{
> > +       return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> > +               NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> > +}
> > +
> >  #ifdef CONFIG_MEMCG_KMEM
> >
> >  /* List of all root caches. */
> > @@ -352,6 +358,22 @@ static inline void memcg_link_cache(struct kmem_ca=
che *s,
> >
> >  #endif /* CONFIG_MEMCG_KMEM */
> >
> > +static __always_inline int charge_slab_page(struct page *page,
> > +                                           gfp_t gfp, int order,
> > +                                           struct kmem_cache *s)
> > +{
> > +       memcg_charge_slab(page, gfp, order, s);
>=20
> This does not seem right. Why the return of memcg_charge_slab is ignored?

Hi Shakeel!

Right, it's a bug. It's actually fixed later in the patchset
(in "mm: rework non-root kmem_cache lifecycle management"),
so the final result looks correct to me. Anyway, I'll fix it.

How does everything else look to you?

Thank you!

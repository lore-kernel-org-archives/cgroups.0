From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 4/6] mm: unify SLAB and SLUB page accounting
Date: Wed, 24 Apr 2019 19:51:17 +0000
Message-ID: <20190424195112.GB26707@tower.DHCP.thefacebook.com>
References: <20190423213133.3551969-1-guro@fb.com>
 <20190423213133.3551969-5-guro@fb.com>
 <CALvZod6A43nQgkYj38K4h_ZYLSmYp0xJwO7n44kGJx2Ut7-EVg@mail.gmail.com>
 <20190424191706.GA26707@tower.DHCP.thefacebook.com>
 <CALvZod7sG+sD76dQmMhXa92=zpXz=wdUcsR9ah7YRj13g=YT+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tS+a+MHZixdLX1Hby0gWxiTjUrqcSq39If4EyiZkPaE=;
 b=Pli0gShJA+G5HcMZcfIbTLOQIKE1pG3gvJXEM2CcPDIySko9Limpc9cGeuuQg1nKt2jx
 cdQoNPuFxiVQlxPV9aQz3yN9nRlZf0ExNDrKBqP+cMQz/bVvSZcdBJrbdzfy4+9iaSkX
 kIPKNohC/88TmSOe020b7G5hto08AOKmcss= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tS+a+MHZixdLX1Hby0gWxiTjUrqcSq39If4EyiZkPaE=;
 b=Qeq3AAqAUNLrcUWsZ7jLc7Cc/ORE/jE0tQtWiJH9rA2VKyBwVrEtaFSfraL0qLfQxTlDEUFZcuJaFg4dx5itBSHAxAzvsGzW32cK3ZYO5QdJvcZo7qIsVeuy9GCgsHwDRso7o0FUim7X1BznmVoSKslzxm5Fjijj1xlU2A+T63c=
In-Reply-To: <CALvZod7sG+sD76dQmMhXa92=zpXz=wdUcsR9ah7YRj13g=YT+g@mail.gmail.com>
Content-Language: en-US
Content-ID: <F45B68BFB4D7F84B9711AC2AE8B29159@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 24, 2019 at 12:40:59PM -0700, Shakeel Butt wrote:
> On Wed, Apr 24, 2019 at 12:17 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Wed, Apr 24, 2019 at 10:23:45AM -0700, Shakeel Butt wrote:
> > > Hi Roman,
> > >
> > > On Tue, Apr 23, 2019 at 9:30 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > Currently the page accounting code is duplicated in SLAB and SLUB
> > > > internals. Let's move it into new (un)charge_slab_page helpers
> > > > in the slab_common.c file. These helpers will be responsible
> > > > for statistics (global and memcg-aware) and memcg charging.
> > > > So they are replacing direct memcg_(un)charge_slab() calls.
> > > >
> > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > ---
> > > >  mm/slab.c | 19 +++----------------
> > > >  mm/slab.h | 22 ++++++++++++++++++++++
> > > >  mm/slub.c | 14 ++------------
> > > >  3 files changed, 27 insertions(+), 28 deletions(-)
> > > >
> > > > diff --git a/mm/slab.c b/mm/slab.c
> > > > index 14466a73d057..53e6b2687102 100644
> > > > --- a/mm/slab.c
> > > > +++ b/mm/slab.c
> > > > @@ -1389,7 +1389,6 @@ static struct page *kmem_getpages(struct kmem=
_cache *cachep, gfp_t flags,
> > > >                                                                 int=
 nodeid)
> > > >  {
> > > >         struct page *page;
> > > > -       int nr_pages;
> > > >
> > > >         flags |=3D cachep->allocflags;
> > > >
> > > > @@ -1399,17 +1398,11 @@ static struct page *kmem_getpages(struct km=
em_cache *cachep, gfp_t flags,
> > > >                 return NULL;
> > > >         }
> > > >
> > > > -       if (memcg_charge_slab(page, flags, cachep->gfporder, cachep=
)) {
> > > > +       if (charge_slab_page(page, flags, cachep->gfporder, cachep)=
) {
> > > >                 __free_pages(page, cachep->gfporder);
> > > >                 return NULL;
> > > >         }
> > > >
> > > > -       nr_pages =3D (1 << cachep->gfporder);
> > > > -       if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
> > > > -               mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, nr=
_pages);
> > > > -       else
> > > > -               mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, =
nr_pages);
> > > > -
> > > >         __SetPageSlab(page);
> > > >         /* Record if ALLOC_NO_WATERMARKS was set when allocating th=
e slab */
> > > >         if (sk_memalloc_socks() && page_is_pfmemalloc(page))
> > > > @@ -1424,12 +1417,6 @@ static struct page *kmem_getpages(struct kme=
m_cache *cachep, gfp_t flags,
> > > >  static void kmem_freepages(struct kmem_cache *cachep, struct page =
*page)
> > > >  {
> > > >         int order =3D cachep->gfporder;
> > > > -       unsigned long nr_freed =3D (1 << order);
> > > > -
> > > > -       if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
> > > > -               mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, -n=
r_freed);
> > > > -       else
> > > > -               mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, =
-nr_freed);
> > > >
> > > >         BUG_ON(!PageSlab(page));
> > > >         __ClearPageSlabPfmemalloc(page);
> > > > @@ -1438,8 +1425,8 @@ static void kmem_freepages(struct kmem_cache =
*cachep, struct page *page)
> > > >         page->mapping =3D NULL;
> > > >
> > > >         if (current->reclaim_state)
> > > > -               current->reclaim_state->reclaimed_slab +=3D nr_free=
d;
> > > > -       memcg_uncharge_slab(page, order, cachep);
> > > > +               current->reclaim_state->reclaimed_slab +=3D 1 << or=
der;
> > > > +       uncharge_slab_page(page, order, cachep);
> > > >         __free_pages(page, order);
> > > >  }
> > > >
> > > > diff --git a/mm/slab.h b/mm/slab.h
> > > > index 4a261c97c138..0f5c5444acf1 100644
> > > > --- a/mm/slab.h
> > > > +++ b/mm/slab.h
> > > > @@ -205,6 +205,12 @@ ssize_t slabinfo_write(struct file *file, cons=
t char __user *buffer,
> > > >  void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
> > > >  int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, vo=
id **);
> > > >
> > > > +static inline int cache_vmstat_idx(struct kmem_cache *s)
> > > > +{
> > > > +       return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> > > > +               NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> > > > +}
> > > > +
> > > >  #ifdef CONFIG_MEMCG_KMEM
> > > >
> > > >  /* List of all root caches. */
> > > > @@ -352,6 +358,22 @@ static inline void memcg_link_cache(struct kme=
m_cache *s,
> > > >
> > > >  #endif /* CONFIG_MEMCG_KMEM */
> > > >
> > > > +static __always_inline int charge_slab_page(struct page *page,
> > > > +                                           gfp_t gfp, int order,
> > > > +                                           struct kmem_cache *s)
> > > > +{
> > > > +       memcg_charge_slab(page, gfp, order, s);
> > >
> > > This does not seem right. Why the return of memcg_charge_slab is igno=
red?
> >
> > Hi Shakeel!
> >
> > Right, it's a bug. It's actually fixed later in the patchset
> > (in "mm: rework non-root kmem_cache lifecycle management"),
> > so the final result looks correct to me. Anyway, I'll fix it.
> >
> > How does everything else look to you?
> >
> > Thank you!
>=20
> I caught this during quick glance. Another high level issue I found is
> breakage of /proc/kpagecgroup for the slab pages which is easy to fix.

Good point! I'll add it in the next iteration.

>=20
> At the moment I am kind of stuck on some other stuff but will get back
> to this in a week or so.

I'm looking forward then... I'm also repeating my long-term test with this
iteration, and I'll have updated results in few days.

Thank you for looking into it!

Roman

From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 19/40] change alloc_pages name in dma_map_ops to avoid
 name conflicts
Date: Tue, 2 May 2023 13:41:49 -0700
Message-ID: <CAJuCfpE2wBnekxOTNpCaHRwnMznPgBkSUJNHk5y1-togkAtkHw@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-20-surenb@google.com>
 <20230502175052.43814202@meshulam.tesarici.cz> <CAJuCfpGSLK50eKQ2-CE41qz1oDPM6kC8RmqF=usZKwFXgTBe8g@mail.gmail.com>
 <20230502220909.3f55ae41@meshulam.tesarici.cz> <CAJuCfpGGB204PKuqjjkPBn_XHL-xLPkn0bF6xc12Bfj8=Qzcrw@mail.gmail.com>
 <20230502223915.6b38f8c4@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683060121; x=1685652121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jeq6+nx3g2wrW78uPfEerLbf18qIDqHe8kQ7v5/JI60=;
        b=USgXLop66yK89JWxFP/fxzpFn6QCWIJ873ogcbMDaInHtoy86T0N+nDV3beDNUkq/4
         7c06Jya3MtjCRVJM+uNiMRs8RsEjcuOOGWIJrQZZueHpb8sE4DfQf9CM/q0ZS2jcLOLw
         Zxz0Iz+Ftxu+bdb4q4rBZ/RbfwNX8QwPVZ0QhmH+LWE19e3eVerx9UKRt0gEIZVUeoQU
         bQ9rPDFBUQenVP8rXbU2Tw3/ndUSRGc8QMnj9BCeiemAFsvcZKGpt9grfpkHrYcao6rB
         iJHXwyF5Ilbx83HWZbdXNDDSJARcklUlVWFftnhagZVtN2T4a20Nb9A365j2QrPSNgF4
         B25Q==
In-Reply-To: <20230502223915.6b38f8c4-TD/jYOLh/Qr2G+KSGY6Hrl+YFMdMcpeZ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <petr-hIRrMMry8ebtwjQa/ONI9g@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl@gmail.

On Tue, May 2, 2023 at 1:39=E2=80=AFPM Petr Tesa=C5=99=C3=ADk <petr@tesaric=
i.cz> wrote:
>
> On Tue, 2 May 2023 13:24:37 -0700
> Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > On Tue, May 2, 2023 at 1:09=E2=80=AFPM Petr Tesa=C5=99=C3=ADk <petr@tes=
arici.cz> wrote:
> > >
> > > On Tue, 2 May 2023 11:38:49 -0700
> > > Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > > On Tue, May 2, 2023 at 8:50=E2=80=AFAM Petr Tesa=C5=99=C3=ADk <petr=
@tesarici.cz> wrote:
> > > > >
> > > > > On Mon,  1 May 2023 09:54:29 -0700
> > > > > Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > >
> > > > > > After redefining alloc_pages, all uses of that name are being r=
eplaced.
> > > > > > Change the conflicting names to prevent preprocessor from repla=
cing them
> > > > > > when it's not intended.
> > > > > >
> > > > > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > > > ---
> > > > > >  arch/x86/kernel/amd_gart_64.c | 2 +-
> > > > > >  drivers/iommu/dma-iommu.c     | 2 +-
> > > > > >  drivers/xen/grant-dma-ops.c   | 2 +-
> > > > > >  drivers/xen/swiotlb-xen.c     | 2 +-
> > > > > >  include/linux/dma-map-ops.h   | 2 +-
> > > > > >  kernel/dma/mapping.c          | 4 ++--
> > > > > >  6 files changed, 7 insertions(+), 7 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/am=
d_gart_64.c
> > > > > > index 56a917df410d..842a0ec5eaa9 100644
> > > > > > --- a/arch/x86/kernel/amd_gart_64.c
> > > > > > +++ b/arch/x86/kernel/amd_gart_64.c
> > > > > > @@ -676,7 +676,7 @@ static const struct dma_map_ops gart_dma_op=
s =3D {
> > > > > >       .get_sgtable                    =3D dma_common_get_sgtabl=
e,
> > > > > >       .dma_supported                  =3D dma_direct_supported,
> > > > > >       .get_required_mask              =3D dma_direct_get_requir=
ed_mask,
> > > > > > -     .alloc_pages                    =3D dma_direct_alloc_page=
s,
> > > > > > +     .alloc_pages_op                 =3D dma_direct_alloc_page=
s,
> > > > > >       .free_pages                     =3D dma_direct_free_pages=
,
> > > > > >  };
> > > > > >
> > > > > > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iomm=
u.c
> > > > > > index 7a9f0b0bddbd..76a9d5ca4eee 100644
> > > > > > --- a/drivers/iommu/dma-iommu.c
> > > > > > +++ b/drivers/iommu/dma-iommu.c
> > > > > > @@ -1556,7 +1556,7 @@ static const struct dma_map_ops iommu_dma=
_ops =3D {
> > > > > >       .flags                  =3D DMA_F_PCI_P2PDMA_SUPPORTED,
> > > > > >       .alloc                  =3D iommu_dma_alloc,
> > > > > >       .free                   =3D iommu_dma_free,
> > > > > > -     .alloc_pages            =3D dma_common_alloc_pages,
> > > > > > +     .alloc_pages_op         =3D dma_common_alloc_pages,
> > > > > >       .free_pages             =3D dma_common_free_pages,
> > > > > >       .alloc_noncontiguous    =3D iommu_dma_alloc_noncontiguous=
,
> > > > > >       .free_noncontiguous     =3D iommu_dma_free_noncontiguous,
> > > > > > diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dm=
a-ops.c
> > > > > > index 9784a77fa3c9..6c7d984f164d 100644
> > > > > > --- a/drivers/xen/grant-dma-ops.c
> > > > > > +++ b/drivers/xen/grant-dma-ops.c
> > > > > > @@ -282,7 +282,7 @@ static int xen_grant_dma_supported(struct d=
evice *dev, u64 mask)
> > > > > >  static const struct dma_map_ops xen_grant_dma_ops =3D {
> > > > > >       .alloc =3D xen_grant_dma_alloc,
> > > > > >       .free =3D xen_grant_dma_free,
> > > > > > -     .alloc_pages =3D xen_grant_dma_alloc_pages,
> > > > > > +     .alloc_pages_op =3D xen_grant_dma_alloc_pages,
> > > > > >       .free_pages =3D xen_grant_dma_free_pages,
> > > > > >       .mmap =3D dma_common_mmap,
> > > > > >       .get_sgtable =3D dma_common_get_sgtable,
> > > > > > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xe=
n.c
> > > > > > index 67aa74d20162..5ab2616153f0 100644
> > > > > > --- a/drivers/xen/swiotlb-xen.c
> > > > > > +++ b/drivers/xen/swiotlb-xen.c
> > > > > > @@ -403,6 +403,6 @@ const struct dma_map_ops xen_swiotlb_dma_op=
s =3D {
> > > > > >       .dma_supported =3D xen_swiotlb_dma_supported,
> > > > > >       .mmap =3D dma_common_mmap,
> > > > > >       .get_sgtable =3D dma_common_get_sgtable,
> > > > > > -     .alloc_pages =3D dma_common_alloc_pages,
> > > > > > +     .alloc_pages_op =3D dma_common_alloc_pages,
> > > > > >       .free_pages =3D dma_common_free_pages,
> > > > > >  };
> > > > > > diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-ma=
p-ops.h
> > > > > > index 31f114f486c4..d741940dcb3b 100644
> > > > > > --- a/include/linux/dma-map-ops.h
> > > > > > +++ b/include/linux/dma-map-ops.h
> > > > > > @@ -27,7 +27,7 @@ struct dma_map_ops {
> > > > > >                       unsigned long attrs);
> > > > > >       void (*free)(struct device *dev, size_t size, void *vaddr=
,
> > > > > >                       dma_addr_t dma_handle, unsigned long attr=
s);
> > > > > > -     struct page *(*alloc_pages)(struct device *dev, size_t si=
ze,
> > > > > > +     struct page *(*alloc_pages_op)(struct device *dev, size_t=
 size,
> > > > > >                       dma_addr_t *dma_handle, enum dma_data_dir=
ection dir,
> > > > > >                       gfp_t gfp);
> > > > > >       void (*free_pages)(struct device *dev, size_t size, struc=
t page *vaddr,
> > > > > > diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> > > > > > index 9a4db5cce600..fc42930af14b 100644
> > > > > > --- a/kernel/dma/mapping.c
> > > > > > +++ b/kernel/dma/mapping.c
> > > > > > @@ -570,9 +570,9 @@ static struct page *__dma_alloc_pages(struc=
t device *dev, size_t size,
> > > > > >       size =3D PAGE_ALIGN(size);
> > > > > >       if (dma_alloc_direct(dev, ops))
> > > > > >               return dma_direct_alloc_pages(dev, size, dma_hand=
le, dir, gfp);
> > > > > > -     if (!ops->alloc_pages)
> > > > > > +     if (!ops->alloc_pages_op)
> > > > > >               return NULL;
> > > > > > -     return ops->alloc_pages(dev, size, dma_handle, dir, gfp);
> > > > > > +     return ops->alloc_pages_op(dev, size, dma_handle, dir, gf=
p);
> > > > > >  }
> > > > > >
> > > > > >  struct page *dma_alloc_pages(struct device *dev, size_t size,
> > > > >
> > > > > I'm not impressed. This patch increases churn for code which does=
 not
> > > > > (directly) benefit from the change, and that for limitations in y=
our
> > > > > tooling?
> > > > >
> > > > > Why not just rename the conflicting uses in your local tree, but =
then
> > > > > remove the rename from the final patch series?
> > > >
> > > > With alloc_pages function becoming a macro, the preprocessor ends u=
p
> > > > replacing all instances of that name, even when it's not used as a
> > > > function. That what necessitates this change. If there is a way to
> > > > work around this issue without changing all alloc_pages() calls in =
the
> > > > source base I would love to learn it but I'm not quite clear about
> > > > your suggestion and if it solves the issue. Could you please provid=
e
> > > > more details?
> > >
> > > Ah, right, I admit I did not quite understand why this change is
> > > needed. However, this is exactly what I don't like about preprocessor
> > > macros. Each macro effectively adds a new keyword to the language.
> > >
> > > I believe everything can be solved with inline functions. What exactl=
y
> > > does not work if you rename alloc_pages() to e.g. alloc_pages_caller(=
)
> > > and then add an alloc_pages() inline function which calls
> > > alloc_pages_caller() with _RET_IP_ as a parameter?
> >
> > I don't think that would work because we need to inject the codetag at
> > the file/line of the actual allocation call. If we pass _REP_IT_ then
> > we would have to lookup the codetag associated with that _RET_IP_
> > which results in additional runtime overhead.
>
> OK. If the reference to source code itself must be recorded in the
> kernel, and not resolved later (either by the debugfs read fops, or by
> a tool which reads the file), then this information can only be
> obtained with a preprocessor macro.
>
> I was hoping that a debugging feature could be less intrusive. OTOH
> it's not my call to balance the tradeoffs.
>
> Thank you for your patient explanations.

Thanks for reviewing and the suggestions! I'll address the actionable
ones in the next version.
Suren.

>
> Petr T
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>

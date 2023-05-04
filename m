From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 34/40] lib: code tagging context capture support
Date: Thu, 4 May 2023 10:04:56 +0200
Message-ID: <ZFNnKHR2nCSimjQf@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-35-surenb@google.com>
 <ZFIO3tXCbmTn53uv@dhcp22.suse.cz>
 <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683187497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lYLdfOt08WRIoWLSWjtWBNIua1sIqT9o2eFAe/IM87Y=;
        b=WD6TCa4jYWbqZpu2D7Zb2B+BhRIJyhUQGBglt00z8ZhtfhV3/fydlU6djL/QoNMPqjwoeL
        ieaUVIQ6L9H9iUbbQ0PpFyveQh/YxSLS4fBx0/E1sXV2d2/aOAODrXdIYK5SZV+w1RdQgZ
        IQoRwApboG5KZded7fCfIHcuIYuLzr4=
Content-Disposition: inline
In-Reply-To: <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook@chr

On Wed 03-05-23 08:18:39, Suren Baghdasaryan wrote:
> On Wed, May 3, 2023 at 12:36=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@=
public.gmane.org> wrote:
> >
> > On Mon 01-05-23 09:54:44, Suren Baghdasaryan wrote:
> > [...]
> > > +static inline void add_ctx(struct codetag_ctx *ctx,
> > > +                        struct codetag_with_ctx *ctc)
> > > +{
> > > +     kref_init(&ctx->refcount);
> > > +     spin_lock(&ctc->ctx_lock);
> > > +     ctx->flags =3D CTC_FLAG_CTX_PTR;
> > > +     ctx->ctc =3D ctc;
> > > +     list_add_tail(&ctx->node, &ctc->ctx_head);
> > > +     spin_unlock(&ctc->ctx_lock);
> >
> > AFAIU every single tracked allocation will get its own codetag_ctx.
> > There is no aggregation per allocation site or anything else. This looks
> > like a scalability and a memory overhead red flag to me.
>=20
> True. The allocations here would not be limited. We could introduce a
> global limit to the amount of memory that we can use to store contexts
> and maybe reuse the oldest entry (in LRU fashion) when we hit that
> limit?

Wouldn't it make more sense to aggregate same allocations? Sure pids
get recycled but quite honestly I am not sure that information is all
that interesting. Precisely because of the recycle and short lived
processes reasons. I think there is quite a lot to think about the
detailed context tracking.
=20
> >
> > > +}
> > > +
> > > +static inline void rem_ctx(struct codetag_ctx *ctx,
> > > +                        void (*free_ctx)(struct kref *refcount))
> > > +{
> > > +     struct codetag_with_ctx *ctc =3D ctx->ctc;
> > > +
> > > +     spin_lock(&ctc->ctx_lock);
> >
> > This could deadlock when allocator is called from the IRQ context.
>=20
> I see. spin_lock_irqsave() then?

yes. I have checked that the lock is not held over the all list
traversal which is good but the changelog could be more explicit about
the iterators and lock hold times implications.

--=20
Michal Hocko
SUSE Labs

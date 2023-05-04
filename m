From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 34/40] lib: code tagging context capture support
Date: Thu, 4 May 2023 07:31:05 -0700
Message-ID: <CAJuCfpF7WeVuJpmZN3KEu=FAUH34xfYG4wPg-YNjxj+GtmdBXQ@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-35-surenb@google.com>
 <ZFIO3tXCbmTn53uv@dhcp22.suse.cz> <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg@mail.gmail.com>
 <ZFNnKHR2nCSimjQf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683210677; x=1685802677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JS6msPuToyJynO3sTVIKpHDiqUqJNNgVeQDo4ExI+FY=;
        b=B5odhRz5pl82Qodj9r2guUYfauBi1/TsFjLxRQqEz3zjcJjd//DMmZjNJKPPi7+nQ5
         xuKBZ6j/WQW0W3dcKfsj589Fsc+uJ6BYPO2OLNobtTmF3hvusxOFblAjFzy4VuEOrD27
         shVv5j4flGfZP5ZKf0oD9z3I5mcfEgazfAAXF3El44hYhX1ZRJaYFp+RYh8KC456HFZc
         kSCAd/ObzJ2UJVsrp6Z49s4y6jg7flU32RKu03oDmXNXsZW8yRicseUXEdJ33k/uoDns
         3t9BrSAOH3jBGP78RFzGvpDDNA510GhlcIeVQC/3SRIP7nZ/gPC/uJcOwTrT82pyTD6i
         AF6A==
In-Reply-To: <ZFNnKHR2nCSimjQf@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Thu, May 4, 2023 at 1:04=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Wed 03-05-23 08:18:39, Suren Baghdasaryan wrote:
> > On Wed, May 3, 2023 at 12:36=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Mon 01-05-23 09:54:44, Suren Baghdasaryan wrote:
> > > [...]
> > > > +static inline void add_ctx(struct codetag_ctx *ctx,
> > > > +                        struct codetag_with_ctx *ctc)
> > > > +{
> > > > +     kref_init(&ctx->refcount);
> > > > +     spin_lock(&ctc->ctx_lock);
> > > > +     ctx->flags =3D CTC_FLAG_CTX_PTR;
> > > > +     ctx->ctc =3D ctc;
> > > > +     list_add_tail(&ctx->node, &ctc->ctx_head);
> > > > +     spin_unlock(&ctc->ctx_lock);
> > >
> > > AFAIU every single tracked allocation will get its own codetag_ctx.
> > > There is no aggregation per allocation site or anything else. This lo=
oks
> > > like a scalability and a memory overhead red flag to me.
> >
> > True. The allocations here would not be limited. We could introduce a
> > global limit to the amount of memory that we can use to store contexts
> > and maybe reuse the oldest entry (in LRU fashion) when we hit that
> > limit?
>
> Wouldn't it make more sense to aggregate same allocations? Sure pids
> get recycled but quite honestly I am not sure that information is all
> that interesting. Precisely because of the recycle and short lived
> processes reasons. I think there is quite a lot to think about the
> detailed context tracking.

That would be a nice optimization. I'll need to look into the
implementation details. Thanks for the idea.

>
> > >
> > > > +}
> > > > +
> > > > +static inline void rem_ctx(struct codetag_ctx *ctx,
> > > > +                        void (*free_ctx)(struct kref *refcount))
> > > > +{
> > > > +     struct codetag_with_ctx *ctc =3D ctx->ctc;
> > > > +
> > > > +     spin_lock(&ctc->ctx_lock);
> > >
> > > This could deadlock when allocator is called from the IRQ context.
> >
> > I see. spin_lock_irqsave() then?
>
> yes. I have checked that the lock is not held over the all list
> traversal which is good but the changelog could be more explicit about
> the iterators and lock hold times implications.

Ack. Will add more information.

>
> --
> Michal Hocko
> SUSE Labs

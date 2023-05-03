From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 34/40] lib: code tagging context capture support
Date: Wed, 3 May 2023 08:18:39 -0700
Message-ID: <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-35-surenb@google.com>
 <ZFIO3tXCbmTn53uv@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683127132; x=1685719132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4wxKwRBUKexs/Rpj6bBCWyCDPYyPPHlLlNupBtzYaw=;
        b=uY9LZ4++hkvUyhbn5c4syfgYI214i342bZOqq7w3PZ5UnX1WOR8kP1Dd5DgdTFpHBZ
         YFrejpNwEwyVtgjJ2h7DJZZwM3wlarwFrdmlWF4/IbYdcLzhZu9eWfASeY3cBcMIJeWN
         TmMwBt2giD3P+L/dV8xN4DWdOteVRuLxU576D+QIIYn5IEbMmRqCsDy6wH6RisaS2En+
         77gau1VuW9LbpE+De59atSjH+/wZB+Rihg2dpbAxr/rgo94K50BySclFMG/5QR1qXpJU
         YHFq9FmHNI3H6tgkwrY1pQTOJWYJg3qmXEmnIBPxV25YxcUtyGvErDZS2P4I8lHhi3Z5
         NkBA==
In-Reply-To: <ZFIO3tXCbmTn53uv@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Wed, May 3, 2023 at 12:36=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Mon 01-05-23 09:54:44, Suren Baghdasaryan wrote:
> [...]
> > +static inline void add_ctx(struct codetag_ctx *ctx,
> > +                        struct codetag_with_ctx *ctc)
> > +{
> > +     kref_init(&ctx->refcount);
> > +     spin_lock(&ctc->ctx_lock);
> > +     ctx->flags =3D CTC_FLAG_CTX_PTR;
> > +     ctx->ctc =3D ctc;
> > +     list_add_tail(&ctx->node, &ctc->ctx_head);
> > +     spin_unlock(&ctc->ctx_lock);
>
> AFAIU every single tracked allocation will get its own codetag_ctx.
> There is no aggregation per allocation site or anything else. This looks
> like a scalability and a memory overhead red flag to me.

True. The allocations here would not be limited. We could introduce a
global limit to the amount of memory that we can use to store contexts
and maybe reuse the oldest entry (in LRU fashion) when we hit that
limit?

>
> > +}
> > +
> > +static inline void rem_ctx(struct codetag_ctx *ctx,
> > +                        void (*free_ctx)(struct kref *refcount))
> > +{
> > +     struct codetag_with_ctx *ctc =3D ctx->ctc;
> > +
> > +     spin_lock(&ctc->ctx_lock);
>
> This could deadlock when allocator is called from the IRQ context.

I see. spin_lock_irqsave() then?

Thanks for the feedback!
Suren.

>
> > +     /* ctx might have been removed while we were using it */
> > +     if (!list_empty(&ctx->node))
> > +             list_del_init(&ctx->node);
> > +     spin_unlock(&ctc->ctx_lock);
> > +     kref_put(&ctx->refcount, free_ctx);
> --
> Michal Hocko
> SUSE Labs

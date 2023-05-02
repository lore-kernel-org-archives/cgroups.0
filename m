From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 09/40] mm: introduce __GFP_NO_OBJ_EXT flag to selectively
 prevent slabobj_ext creation
Date: Tue, 2 May 2023 11:33:15 -0700
Message-ID: <CAJuCfpGA9SMwyQ44XHRHHVf32MPu4o6wy1Q6H=AfJy61Ez-06Q@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-10-surenb@google.com>
 <20230502145014.24b28e64@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683052406; x=1685644406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HVL3xDTGrQVKytv3307oE4wI2qXt6O5pXdSbfIsmfw=;
        b=1qOKHMcI8DulkSfoRMvX8Pr+Zk5uyPKcuzTjDblLNP1XefPQJkSAxIcSan4hxrkYmM
         mijXYJDbwYfBriku1yo2jZFFkuGOQV27nGEoociEa+x4EBkt6xdc8TTdBr8ExPJqJxj3
         I+cfPJCKCtCybq2dUPwiVCF4ankuJVJJAVwM7AetAdBoRpl61AdRNAdTS18dObY9arIk
         e9qSsTvg8C0oNmcsYUHHNiUOhvlpSnEvLmwlJBc13gXCsXeR7WXU4bYyLgUPMLC/5oWj
         1vsg/b1NFVc8TUatQihkDpPMckBOmQMwujeGiTah+4Xw72cOHRDooXz8s6AG9qHHNqgj
         yg7g==
In-Reply-To: <20230502145014.24b28e64@meshulam.tesarici.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <petr@tesarici.cz>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.

On Tue, May 2, 2023 at 5:50=E2=80=AFAM Petr Tesa=C5=99=C3=ADk <petr@tesaric=
i.cz> wrote:
>
> On Mon,  1 May 2023 09:54:19 -0700
> Suren Baghdasaryan <surenb@google.com> wrote:
>
> > Introduce __GFP_NO_OBJ_EXT flag in order to prevent recursive allocatio=
ns
> > when allocating slabobj_ext on a slab.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  include/linux/gfp_types.h | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> > index 6583a58670c5..aab1959130f9 100644
> > --- a/include/linux/gfp_types.h
> > +++ b/include/linux/gfp_types.h
> > @@ -53,8 +53,13 @@ typedef unsigned int __bitwise gfp_t;
> >  #define ___GFP_SKIP_ZERO     0
> >  #define ___GFP_SKIP_KASAN    0
> >  #endif
> > +#ifdef CONFIG_SLAB_OBJ_EXT
> > +#define ___GFP_NO_OBJ_EXT       0x4000000u
> > +#else
> > +#define ___GFP_NO_OBJ_EXT       0
> > +#endif
> >  #ifdef CONFIG_LOCKDEP
> > -#define ___GFP_NOLOCKDEP     0x4000000u
> > +#define ___GFP_NOLOCKDEP     0x8000000u
>
> So now we have two flags that depend on config options, but the first
> one is always allocated in fact. I wonder if you could use an enum to
> let the compiler allocate bits. Something similar to what Muchun Song
> did with section flags.
>
> See commit ed7802dd48f7a507213cbb95bb4c6f1fe134eb5d for reference.

Thanks for the reference. I'll take a closer look and will try to clean it =
up.

>
> >  #else
> >  #define ___GFP_NOLOCKDEP     0
> >  #endif
> > @@ -99,12 +104,15 @@ typedef unsigned int __bitwise gfp_t;
> >   * node with no fallbacks or placement policy enforcements.
> >   *
> >   * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
> > + *
> > + * %__GFP_NO_OBJ_EXT causes slab allocation to have no object
> > extension. */
> >  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
> >  #define __GFP_WRITE  ((__force gfp_t)___GFP_WRITE)
> >  #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
> >  #define __GFP_THISNODE       ((__force gfp_t)___GFP_THISNODE)
> >  #define __GFP_ACCOUNT        ((__force gfp_t)___GFP_ACCOUNT)
> > +#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
> >
> >  /**
> >   * DOC: Watermark modifiers
> > @@ -249,7 +257,7 @@ typedef unsigned int __bitwise gfp_t;
> >  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
> >
> >  /* Room for N __GFP_FOO bits */
> > -#define __GFP_BITS_SHIFT (26 + IS_ENABLED(CONFIG_LOCKDEP))
> > +#define __GFP_BITS_SHIFT (27 + IS_ENABLED(CONFIG_LOCKDEP))
>
> If the above suggestion is implemented, this could be changed to
> something like __GFP_LAST_BIT (the enum's last identifier).

Ack.

Thanks for reviewing!
Suren.

>
> Petr T

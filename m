Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED322BEC3F
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 02:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788403740; cv=pass; b=Q9Fw3VpM5Wy3YAQKzeNvMehu3hqBGWkyeTx0bmKXwle6Jo4+3rpa8D7XRhRwkI88wv7EWmm49j0S+hakSTlLUYkqh1vF78DGKkiYac01H3HKbp3hDG0i8+9c5kJbhsw4iaEAdF9ile+hpckvdtT80GQ5+a4yyANDe1wIJj/NBk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788403740; c=relaxed/simple;
	bh=dnQWjMZqEmzZ1sNTY4Bt+zK1nOjuolWMZGoiPQkzzeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uldjgsc4G+H2U7PpvnSZY+JmC4ueXLQ1rXVoaIwaSMVSHdMaFU9fj7xmmKnHMOEZIBy5+Uc1PM7FsWl+19QtYp/pufu7ENNtZOKqP608bNdUPKEYgKWG9987urwKZ+7bpizILngBTA7KqhnhSreqIuXNdn2WOl8TwAsmIHulgMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lEkuzcrX; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEkuzcrX"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c25ed8a8a43so115465966b.3
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 19:48:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788403736; cv=none;
        d=google.com; s=arc-20260327;
        b=LtAgT41IOz4zsnsQRooAntrQJacKUfT9unp7Ma7Qhiado32RGyYNd0MyYONpBPg/Ek
         frMFRLWSxiOxR5odLjLsxzuRD1m+vnVqWhhHRNkUxfaT6DA3evL+BZ1FEXa6KfWMcBmD
         YWKTw4vhEROmSAohkXOq7HbLkYNCBFoq6EkVSkKCxBpN4L9PkJq+qssVoLyMxNEH0YpJ
         so126mTe7zVq9/YCVWqVnGA7J/VeN3nUCGlshUAdZToZqmJBlnyMq8mHiopUsykMudvd
         OUT1X9ihb69mqlQjLX3LHINnrhYiKnqWmzZuoek/cghm4FJbeODzTXBcB+8V1wHZ8ccJ
         N4vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
        fh=08Un7AEgObiZd3d3ypk4w2w5DpvosxWJQJcHGo2xAuw=;
        b=Bsow3m6mc128QuFVqrg2GQ94YTbpoMpV12lgEf5M5vjdA7qKiEI5EcWL3N2MA7O97e
         aR3vKtrOIjwUDj9XegOPMNrARGf71aydcHRU3QvR31TAOb/afqhsTVqpK7A9FZisQoqv
         bmdUgv5Z2bhL2dZV4E+R3nesd25FRNZgXTKWwhIKteQgV1OM7AZBK4m+C5/lqk60Bvtb
         GJTfLt2jNEsBMNKDBUgc6agCax6lcVOO3XU0ar0ETIasxiaszDKCJ57n0NVnN4SYCWFJ
         oJO/WxjM7O90n5ekTkGCiiqwj5gRXVa3Debuy3A3aT+K70AbV4VReJbavO92RGYmoWI6
         Sykg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788403736; x=1789008536; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
        b=lEkuzcrX/r0E6mxzOMZc7xelkXGcY0hiEfTjVHioaAQII7rMnerM19Zh71TGfZwDwd
         TQbWFgNxnvK2zvHxQNq0WIzWM7zPeaWYOsARymN3xvzD+zmTZGYcaV/nW7RNg36CJGn1
         4+cEBYxlMywUWWsDH7sAeJI+yby0gSAxix407J+khRKinVF0RsjIcl/SBlwkFc216aq0
         0UV+yMORpDSzwiN6PFjjZS1HtxWHSKIhUldnsouGSZZx7FYguPRI9AthEf+KBGom9WK0
         7Skoe4VcxDly7PNBKezKI9OluCMDjxZABal9Kk1CeGXmMiEp+CHnpE8IQMmzFChMlXQg
         H/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788403736; x=1789008536;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
        b=Ae2WvP4y7xGlr65dcoHLTt3DFZ0AyH1xg8hRJ6rWphd+xnwXFRm0txi1tEs6nJ1qzu
         JibcmRUVdDNO/LkqaHzdegE48Tyd9kCykcJnewwvvwpZR+3j4r/rDAwsdo5MNJ6AgBZ5
         CK6ellgTF6d6JzCMdbD1eNJmUFgAzzqeo9N2TpkN/eTU/yYQKk5jqIS7U/3f+6YMQ3PS
         nzyv0stf6Ye/e7y3Wz1LL7rnlsnx2k5G3WybC/ioiD2o/s0Ehou8/t2shY4BYk5u5V5v
         g/at7f21nsTI5csjviPCvMkUyjmcXwZPrSX0I3Zs+oDisYpH1tm5yZ4CTPNshrSnM0eT
         XHDA==
X-Forwarded-Encrypted: i=1; AKwUvBwcN1Kx3cizqV5xq9NGe3ud82IaN83gumXEN2i31zayxVho6OMscdpemUZKehGFh01TDRWuku7Z@vger.kernel.org
X-Gm-Message-State: AFuF++kzSEi9JL26HiILj23GFZc7h3n0tAPl6fsrvKbHL0g+/PN8kE+C
	0BxFCaWE+tVqtLv0eNxPllj/tR7g0I5KvWbFT8GOc2YLP/93ot6eS6VgnDC4NIxbfdTsBun3Lbn
	Y1NNU1aW48MctuZ9CUosFSCUt/wfT8EE=
X-Gm-Gg: AYBFou2lhhPeom7e0gwn2J/E/0hpE5ajCyUYPVvZ2SeaMfN67jPgzRmF2qcRB5+hZlZ
	V/bqlize0ofsuwjNi+h/rENXpYzbWxaL7MrehbRbqecqlszXULt6hdJVKjwqMM6qJ/VpngHh4lI
	t7VHeLFyHnhsDqM7qACOnsdYKFSpB7Km9Nh5U4t2W4/YYf4gvHEzgOF5wydcHKNG9lPAR8KpBwr
	HJAdmKs1k3bP+jkiZQg92xbIbBMFV2cXk6H+u/NAoMFAlgjSx3r/Rl4+pFJC6mzhnYS+bJs6LAs
	CSIslH03vc7qg1Yx2DEPuKtkRF6Ra3NJfyr0MgGGQyMMtz6tpRilL5aUgIRDf4Se8sazBPccj+Y
	h
X-Received: by 2002:a17:906:9c93:b0:c16:26c7:6ba8 with SMTP id
 a640c23a62f3a-c25d5271fb9mr509886866b.6.1788403736382; Wed, 02 Sep 2026
 19:48:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org> <20260902223124.48962-1-baohua@kernel.org>
In-Reply-To: <20260902223124.48962-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 3 Sep 2026 10:48:18 +0800
X-Gm-Features: AcwNN1XM9Te18M3BnRlh16HF2KsCBVP2a1M5Yd0ROWFwVgcVEIjqGzJrEaqft9o
Message-ID: <CAMgjq7CW7=OQva9EOM32To244eCXVJmkKUg=ZvGc4qOB9x2JVA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chrisl@kernel.org, david@kernel.org, devnull+kasong.tencent.com@kernel.org, 
	hannes@cmpxchg.org, liam@infradead.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	vbabka@kernel.org, weixugc@google.com, yuanchu@google.com, yuzhao@google.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 6:31=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.o=
rg> wrote:
>
> I rebased Kairui's series on top of `mm-new`. I guess all we need is to
> make patch 2 look like this:
>
> From 01e2013722443f685d47b42e7d9b11aadef58722 Mon Sep 17 00:00:00 2001
> From: Kairui Song <kasong@tencent.com>
> Date: Wed, 2 Sep 2026 17:50:55 +0800
> Subject: [PATCH 2/6] mm/mglru: introduce helpers for manipulating gen and=
 refs
>  flags
>
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
>
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/mm_inline.h | 84 +++++++++++++++++++++++++++++++++++----
>  include/linux/mmzone.h    |  1 +
>  mm/folio.c                | 19 +++++----
>  mm/vmscan.c               | 60 ++++++++++++++++------------
>  4 files changed, 122 insertions(+), 42 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..3f4bd5b02b54 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,66 @@ static inline int lru_tier_from_refs(int refs, bool=
 workingset)
>         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>  }
>
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_set_gen_flags - Set the LRU generation number to specified folio =
flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
> + */
> +static inline void lru_set_gen_flags(unsigned long *flags, int gen)
> +{
> +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> +       /* Store gen offset by 1, zero means the folio is off-list. */
> +       *flags &=3D ~LRU_GEN_MASK;
> +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> +}
> +
> +/**
> + * lru_get_gen_flags - Return the LRU generation number from folio flags=
.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_get_gen_flags(unsigned long flags)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
> +       /* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison =
*/
> +       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> +       return gen;
> +}
> +
> +/**
> + * lru_set_refs_flags - Set the LRU referenced count to folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, =
inclusive.
> + *
> + * For MGLRU, PG_referenced holds the first ref, and the extra bits hold=
 the
> + * remaining refs. For classical LRU the extra bits are not used, so it =
can
> + * also be seen as the refs count never exceeds 1. In both cases, refs =
=3D=3D 1
> + * means PG_referenced is set and the extra bits are zero, and refs =3D=
=3D 0 means
> + * PG_referenced and the extra bits are all unset.
> + */
> +static inline void lru_set_refs_flags(unsigned long *flags, unsigned int=
 refs)
> +{
> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGOFF) =
+ 1);
> +
> +       *flags &=3D ~LRU_REFS_FLAGS;
> +       if (!refs)
> +               return;
> +       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF=
));
> +}
> +
> +/**
> + * lru_get_refs_flags - Return LRU referenced / access count from folio =
flags.
> + * @flags: folio flags
> + *
> + * Reads the LRU referenced count set by lru_set_refs_flags().
> + */
> +static inline int lru_get_refs_flags(unsigned long flags)
> +{
>         if (!(flags & BIT(PG_referenced)))
>                 return 0;
>         /*
> @@ -155,11 +211,24 @@ static inline int folio_lru_refs(const struct folio=
 *folio)
>         return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>  }
>
> -static inline int folio_lru_gen(const struct folio *folio)
> +static inline int folio_lru_refs(const struct folio *folio)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0))=
);
> +}
> +
> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int =
refs)
> +{
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +
> +       do {
> +               new_flags =3D old_flags;
> +               lru_set_refs_flags(&new_flags, refs);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +}
>
> -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +       return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
>  }
>
>  static inline bool lru_gen_is_active(const struct lruvec *lruvec, int ge=
n)
> @@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         gen =3D lru_gen_from_seq(seq);
>         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>         /* see the comment on MIN_NR_GENS about PG_active */
> -       set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), fla=
gs);
> +       set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
>         /* for folio_rotate_reclaimable() */
> @@ -295,7 +364,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>
>         /* for folio_migrate_flags() */
>         flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_=
active) : 0;
> -       flags =3D set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flag=
s);
>         gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +408,6 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>
>  static inline void folio_migrate_refs(struct folio *new, const struct fo=
lio *old)
>  {
> -
>  }
>  #endif /* CONFIG_LRU_GEN */
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 84e237f2c17d..775d6279dfea 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -500,6 +500,7 @@ enum lruvec_flags {
>
>  #define LRU_GEN_MASK           ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOF=
F)
>  #define LRU_REFS_MASK          ((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PG=
OFF)
> +#define LRU_REFS_MAX           BIT(LRU_REFS_WIDTH)
>
>  /*
>   * For folios accessed multiple times through file descriptors,
> diff --git a/mm/folio.c b/mm/folio.c
> index c02dcea9c03c..fb874fe492b2 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio=
 *folio)
>
>  static void lru_gen_inc_refs(struct folio *folio)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +       int refs;
>
>         if (folio_test_unevictable(folio))
>                 return;
>
>         /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_test_referenced(folio)) {
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +       if (!folio_lru_refs(folio)) {
> +               folio_set_lru_refs(folio, 1);
>                 return;
>         }
>
>         do {
> -               if ((old_flags & LRU_REFS_MASK) =3D=3D LRU_REFS_MASK) {
> +               new_flags =3D old_flags;
> +               refs =3D lru_get_refs_flags(old_flags);
> +               if (refs =3D=3D LRU_REFS_MAX) {
>                         if (!folio_test_workingset(folio))
>                                 folio_set_workingset(folio);
>                         return;
>                 }
> -
> -               new_flags =3D old_flags + BIT(LRU_REFS_PGOFF);
> -       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +               lru_set_refs_flags(&new_flags, refs + 1);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
>  static bool lru_gen_clear_refs(struct folio *folio)
> @@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
>         if (gen < 0)
>                 return true;
>
> -       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset=
), 0);
> +       folio_set_lru_refs(folio, 0);
> +       folio_clear_workingset(folio);
>
>         rcu_read_lock();
>         seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bf2786c7247d..71adf4bf5074 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -863,19 +863,22 @@ static bool lru_gen_set_refs(struct folio *folio, c=
onst vma_flags_t *vma_flags)
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
>                 /* Activate file-backed executable folios after first usa=
ge. */
>                 if (is_exec_file_folio(folio, vma_flags)) {
> -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BI=
T(PG_workingset));
> +                       folio_set_workingset(folio);
> +                       folio_set_lru_refs(folio, 0);
>                         return true;
>                 }
>
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +               folio_set_lru_refs(folio, 1);
>                 return false;
>         }
>
>         /* Promote on second access */
> -       if (folio_lru_refs(folio) > 1)
> -               set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_wor=
kingset));
> -       else
> +       if (folio_lru_refs(folio) > 1) {
> +               folio_set_workingset(folio);
> +               folio_set_lru_refs(folio, 0);
> +       } else {
>                 folio_mark_accessed(folio);
> +       }
>         return true;
>  }
>  #else
> @@ -3291,11 +3294,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp=
, struct ctrl_pos *pv)
>   ***********************************************************************=
*******/
>
>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int gen, const vma_flag=
s_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, const vma_=
flags_t *vma_flags)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
> -
> -       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +       int old_gen;
>
>         /*
>          * See the comment on LRU_REFS_FLAGS, and activate file-backed
> @@ -3304,31 +3306,34 @@ static int folio_update_gen(struct folio *folio, =
int gen, const vma_flags_t *vma
>          */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
) &&
>             !is_exec_file_folio(folio, vma_flags)) {
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +               folio_set_lru_refs(folio, 1);
>                 return -1;
>         }
>
>         do {
> +               old_gen =3D lru_get_gen_flags(old_flags);
> +               new_flags =3D old_flags;
> +
>                 /* lru_gen_del_folio() has isolated this page? */
> -               if (!(old_flags & LRU_GEN_MASK))
> -                       return -1;
> +               if (old_gen < 0)
> +                       break;
>
> -               new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS=
);
> -               new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_wo=
rkingset);
> -       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +               lru_set_gen_flags(&new_flags, new_gen);
> +               lru_set_refs_flags(&new_flags, 0);
> +               new_flags |=3D BIT(PG_workingset);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -       return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +       return old_gen;
>  }
>
>  static int __folio_inc_gen(struct folio *folio, int old_gen, bool *incre=
ased)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
>         int new_gen;
>
> -       VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
> -
>         do {
> -               new_gen =3D ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF)=
 - 1;
> +               new_gen =3D lru_get_gen_flags(old_flags);
> +
>                 /* folio_update_gen() has promoted this page? */
>                 if (new_gen >=3D 0 && new_gen !=3D old_gen) {
>                         if (increased)
> @@ -3336,11 +3341,12 @@ static int __folio_inc_gen(struct folio *folio, i=
nt old_gen, bool *increased)
>                         return new_gen;
>                 }
>
> +               new_flags =3D old_flags;
>                 new_gen =3D (old_gen + 1) % MAX_NR_GENS;
>
> -               new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS=
);
> -               new_flags |=3D (new_gen + 1UL) << LRU_GEN_PGOFF;
> -       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +               lru_set_gen_flags(&new_flags, new_gen);
> +               lru_set_refs_flags(&new_flags, 0);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
>         if (increased)
>                 *increased =3D true;
> @@ -4785,7 +4791,7 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio))
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
> +               folio_set_lru_refs(folio, 0);
>
>         success =3D lru_gen_del_folio(lruvec, folio, true);
>         VM_WARN_ON_ONCE_FOLIO(!success, folio);
> @@ -5017,8 +5023,10 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>                 }
>
>                 /* don't add rejected folios to the oldest generation */
> -               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
> -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BI=
T(PG_active));
> +               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type]) {
> +                       folio_set_lru_refs(folio, 0);
> +                       folio_set_active(folio);
> +               }
>         }
>
>         move_folios_to_lru(&list);
> --
> 2.39.3 (Apple Git-146)
>
>
> >
> > Thanks.
>

Thanks a lot! This looks good to me. I tried a rebase locally, which
resulted in the same thing. I think we can continue the merge with
this version.

Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24746396579
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 07:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787989705; cv=pass; b=aYZMAysfD3t8JpEaC6uZKI1JoqEtyGTDosaBzWZRoIIKW6iFaJjM1MyFCwI7izGiC1dUv0pEr9bpO8xsaVJvfcIGAV+qxOXmpAX3Svg3mv7eQIrjowS+1VA/XUYgNKnh7RO9Cxt3tcZEuHr9kSqyKt04KIenD5z7kYQR+eF5EjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787989705; c=relaxed/simple;
	bh=RUm+MaV1BRFqRa8WV8YX3+t2SNNM6Eqk/2PIfJZlJCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AKbr1fWE7jx5lQ083cHEniEbbr0QrpISTzYE/gPvZpsefyw2UccwbrgFTn8LPsJRULvc3OjD4tt9HgwgrHm868gl3ePe3q+hx6zcSfHlsQ53P08wbficKicd4JbNIxTUd3SZglVdYB5R2uwjON3n2pd/f8qHYK/EFuaZj40WZOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyVZPEbf; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyVZPEbf"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c207cb16cf5so283737566b.1
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 00:48:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787989699; cv=none;
        d=google.com; s=arc-20260327;
        b=Wme/uUtU0dUAfy4ublDp/C+kcG+3g97uP18Nl8cZk7+XQ16nkWNICP1E2NW7P0ro8m
         zlTP+f37c6m6oQoAT5rIwCF0oRiKFjEaucvHEqi7BsSCX8Ta9k3fQbMvbxsTeknNPZjS
         t3dG6LY+Mr2df1rw5y0G/DltmnfKw4G0nkhHHcdObWMOszAVp5zV0q7T2qJw3hYx+2ML
         pfZiAtMdgQ2/tMMUxBCFtp7S7x+TUGdwDqow1DgQoktS3ahc/prp1R8KUW8js/qulTrr
         /VR5RYtn+YmnacQvysQGDhRalMr2ffT/LSk9xEQXtdtR9YQ5P+xoVQeHqrHLS+Q2JYik
         dueA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
        fh=P1BkAPcp/HPQG1sxKs/iJ3f4TDrGiwTw7kXoWfE+rBo=;
        b=jXstiL8zyYliOPiaDMdVzFIuozepTIZ2sXrNTxuGfVyxfSAfdNsCTSQzBBIvBNYB0j
         xk7fVNiu1ZYk5JKTaMbz4DhM+5AyDRgM///7VprroYokfsWreLIRAhJBxGLaMQ1X9K7F
         JeyaVxlxnZC+On8VnbJMqmULEYof7ZJklaSD64MORbDPCAd95wixG5rBqndbESaylEx3
         /LgQjysnzSLnT5cyKUWpPJAsGt4jUGBJ/kU5F3ySVKPTvlUmsnrt5uTEdnw9hhnQ/Owh
         VMcdv7ikMNgj5tlslC9h2S1VzgxrO61vF2Q7sE6u46uE5dpnf+RlaTU14/3NBeOsGU7I
         UAPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989699; x=1788594499; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
        b=CyVZPEbf2j+e2+C9SgeqCb3z8EvOZQi/d77e18Bgt5mD9Gy8lLr1ir8WVtQZiAqQ4G
         wxQ33lQsiZpXt9xP6OOXXhYoTiArlKPJDxDYXAB71+ogGaE8IZZHc67wvKkOn+cIbzjY
         EtzlCdp8zPDig4nWO6QSOxLZ2l5WWx4BfgxYp3Noe44eA4bDe/MuEnkjFCn4KARZSyQ9
         XqOI94wocON7RK77+BKSXPOyCJ2IRfw7/JhRiTskYYxFFwn06aSWPIPhYerG57As3hgk
         GIMZemEuKxIV0iW1AaiFe+yN82Gz0PkZNddMBJ8TgRk1xHOIerSsdAZN3L6WPUXOWutd
         x7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989699; x=1788594499;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
        b=Ns2sTGDUDkh3irq5MfjzmmFi9/1IYb6sD/3CQ4/7cptH6LZ5ennspZOUiPsCJ6tDiY
         B/7EKCRKiN+KVBWLLR/UD6yrZmjv2m/6v+UTLjmZZHFTb/hgUfpcB4o8RxnODfR6Qp5s
         M3rK/xeToA/uDKCvXhFak0aUyBMJ0xpHG2op8HipZhfaz+JEP+uJGcLNVmfk+VruqlX1
         sHA515irU5qLHAv9AKL3O32AnpkKrKRheaZ2kcbJ9GZMSr1XeIDuYB/g/uNxEqSkTFpu
         3XfIoa+mQHqdFXk7Ky5pLvkgrbMrkmKJrmfhH+dqT7X6KD1cC1n0P9GWOSLvosrNeVUu
         Un+w==
X-Forwarded-Encrypted: i=1; AHgh+RrQ9NsTV8G13dHaotxyajRT2KxhuQOgEaRMKIipA8wjmClIazbZS57f8ICcURP24reqPwhNlmH+@vger.kernel.org
X-Gm-Message-State: AFuF++ljqFRDIX/pLQnGR3f3/c3pJSyE92P1j6U87pNdN/1ZV1V5q7vr
	b/E+8OkRSyJsjM6uL/XbbwmdcRuSgVrFzlzc0uOhqIWCB9sDIjjYFfAxVfxSTANZtvetE+Yh+9E
	z+ry4lsAHRZB+bzpzQVOm6nY17mrrBf8=
X-Gm-Gg: AR+sD128NyymUyfqMc1W6P/h4/jXk+UI0VhHml/kM8O/d0GJXpQkFhWg4KOs6mKQySd
	QTizYId+gYW8gbbnT8CGh00PzAwPWMzTcRIecfhLslSi3oGocwjw22rkQWFZ3ncJNwYxxZ5k8fP
	tszH64twv9RUGB3KmV1+AXhc4/TUQtSY6ZOjBApL3wqU6OeuitHUiOSa6TuA/EfyhU264HmIu8S
	ANc9WgSYkOjbvahXbQqqLbLOjemrSMuNWrQPbUGh0Pv4j/G3GsbBzJ5ToqIEhpN07QyoO6fVHRs
	AxVJhbutP+Nz4G5sEboiBqyqkkdM3pLW6w5GiwszGSLfvE9anrdyPvHfOfjuD31cP8PQSk5KaJQ
	e
X-Received: by 2002:a17:907:d0a:b0:c25:32b0:e56c with SMTP id
 a640c23a62f3a-c2556bc8abfmr1111092566b.4.1787989699264; Sat, 29 Aug 2026
 00:48:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com> <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 29 Aug 2026 15:47:42 +0800
X-Gm-Features: AcwNN1VPg-XLWwgQTNShvKrK-YhiJ14GL2XJlZsGpzpk42yCs3IhhH0zUnSFR9I
Message-ID: <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 12:22=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting a folio's refs and generation info, making the code easier
> > to debug and understand.
> >
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states. There is
> > no measurable performance impact, and some paths even look slightly
> > better in the generated assembly.
>
> Hi Kairui,
>
> I like your idea. Overall, it looks good to me. With some cleanup,
> we might have the following:
>
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 76 +++++++++++++++++++++++++++++++++++++++=
+++-----
> >  include/linux/mmzone.h    |  1 +
> >  mm/folio.c                | 19 +++++++-----
> >  mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
> >  4 files changed, 114 insertions(+), 43 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 621c8653d8f7..edfaf2661812 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bo=
ol workingset)
> >         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> >  }
> >
> > -static inline int folio_lru_refs(const struct folio *folio)
> > +/**
> > + * lru_gen_from_flags - Return the LRU generation number from folio fl=
ags.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > + * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > + */
> > +static inline int lru_gen_from_flags(unsigned long flags)
> > +{
> > +       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> > +       gen -=3D 1;
> > +       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
>
> Since `gen` is an `int`, it seems a bit odd to have
> `gen !=3D -1 && gen >=3D MAX_NR_GENS` combined here.
>
> Do you actually mean the following instead?
>
> VM_WARN_ON_ONCE(gen < -1 || gen >=3D MAX_NR_GENS);

Thanks for the review!

Yeah, thats's a better sanity check, will udpate it.

> > +}
> > +
> > +/**
> > + * lru_gen_set_flags - Set the LRU generation number to specified foli=
o flags.
> > + * @flags: pointer to the folio flags
> > + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive=
.
> > + */
> > +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
> >  {
> > -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> > +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> > +
> > +       *flags &=3D ~LRU_GEN_MASK;
> > +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> > +}
>
> It seems that we are setting the gen in the flags, rather than
> setting the flags themselves.
>
> The current name makes me think that the function is setting the
> entire flags field, especially since `lru_gen` is used as the
> namespace for various MGLRU functions, e.g.:
>
> void lru_gen_add_mm(struct mm_struct *mm);
> void lru_gen_del_mm(struct mm_struct *mm);
> void lru_gen_migrate_mm(struct mm_struct *mm);
> struct lru_gen_folio;
> lru_gen_update_size(lruvec, folio, old_gen, new_gen);
>
> However, this function only sets the gen bits in the flags.
> Maybe we could use a name that makes this distinction clearer?
>
> Could they be named as below, or is there a better naming option?
>
> set_gen_to_flags(unsigned long *flags, int gen);
> get_gen_from_flags(unsigned long flags);
>
> Or something like flags_to_gen() or gen_from_flags()?

I think having lru_gen as the prefix is a good idea actually since the
header here is a very generic one, the word "gen" could be used my
many other subsystem or drivers, gen_to_flags sounds too generic..
While lru_gen is a very specific MGLRU thing.

How about just rename it lru_set_gen_flags / lru_get_gen_flags? And we
will have lru_set_refs_flags / lru_get_refs_flags below.

>
> >
> > +/**
> > + * lru_refs_from_flags - Return LRU referenced / access count from fol=
io flags.
> > + * @flags: folio flags
> > + */
> > +static inline int lru_refs_from_flags(unsigned long flags)
> > +{
> >         if (!(flags & BIT(PG_referenced)))
> >                 return 0;
> >         /*
> > @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct fol=
io *folio)
> >         return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
> >  }
> >
> > -static inline int folio_lru_gen(const struct folio *folio)
> > +/**
> > + * lru_refs_set_flags - Set the LRU referenced / access count to speci=
fied folio flags.
> > + * @flags: pointer to the folio flags
> > + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX=
, inclusive.
> > + */
> > +static inline void lru_refs_set_flags(unsigned long *flags, unsigned i=
nt refs)
> > +{
> > +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> > +       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGOFF=
) + 1);
> > +
> > +       *flags &=3D ~LRU_REFS_FLAGS;
> > +       if (!refs)
> > +               return;
> > +       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGO=
FF));
> > +}
>
> Similar to the above, maybe we could use more descriptive names?

And here we have lru_set_refs_flags?
>
> > +
> > +static inline int folio_lru_refs(const struct folio *folio)
> >  {
> > -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> > +       return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, =
0)));
> > +}
> > +
> > +static inline void folio_set_lru_refs(struct folio *folio, unsigned in=
t refs)
> > +{
> > +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(f=
olio, 0));
> > +
> > +       do {
> > +               new_flags =3D old_flags;
> > +               lru_refs_set_flags(&new_flags, refs);
> > +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_fl=
ags));
> > +}
> >
> > -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
> [...]
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 73a81b4a3e16..9ee9f8dc6805 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio,=
 const vma_flags_t *vma_flags)
> >         if (!folio_test_referenced(folio) && !folio_test_workingset(fol=
io)) {
> >                 /* Activate file-backed executable folios after first u=
sage. */
> >                 if (is_exec_file_folio(folio, vma_flags)) {
> > -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, =
BIT(PG_workingset));
> > +                       folio_set_workingset(folio);
> > +                       folio_set_lru_refs(folio, 0);
> >                         return true;
> >                 }
> >
> > -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_re=
ferenced));
> > +               folio_set_lru_refs(folio, 1);
>
> We have quite a few instances of folio_set_lru_refs(folio, 1) and
> folio_set_lru_refs(folio, 0). Do these values have any special
> meaning? Could we add wrapper helpers to make the code more readable?
>
> `1` just means `PG_referenced`, right? Could we add a comment or
> changelog description to clarify that `1` actually means `refs =3D 0`,
> but `PG_referenced` is set?

Right, I introduced a LRU_REFS_REFERENCED in a later series. Now a
comment could be good enough, as in fact PG_referenced is already kind
of a unstable page flags under both MGLRU and CLRU. For MGLRU it only
mean the refs count is larger than 1 so using a strict 1 here seems
even cleaner, but it still keep getting cleared in many places. As for
CLRU, the flag keeps getting reset when a folio is activated leading
to an under-accounted value from smap and other components. So
sanitizing its usage is a long-term goal.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B521FF2E
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 08:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787991993; cv=none; b=V5uJGYtupsK6lYDtQ8jPjNx37RkHCw62mpJP5RcqnV9B7SRsl/BA1sAum9Uhs4oKtddY5frAMLja77RsR8NQBTLDieyqY+6GuU4u64om6tQfdK3P/gpjZKVwZ1dcVfWP9KBMbPxd3xOktJ6e29J75sLYMKwlINqCebWcwZXK26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787991993; c=relaxed/simple;
	bh=QlpEr6psokW89EvWptF0Mm+nNLInCn2pyJ8lW/QPn8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d4FYQjVS3X+3C6WMdaahl3MbUEUc2dr2jxLqrTLpASAEQ4/SYkUhhTTs9L2lMFJ5MnchKGCC6O0GDalc+E/gmJcBhmU6xPAW/nMyg4uWgaXddT4k+FONGC1/Smdz93sb+qF6bCkZ+vTF5QoI47+cH0YFV9xkgGvSQk0betIsC0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VX3mGmcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VX3mGmcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D22D1F01558
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 08:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787991992;
	bh=ELz8WpSjJQ38zjegY/jVb779cX2lY7cfwp1pllayTUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VX3mGmcwK3arZBZaxnK+cLQQYM75+vBP4n+6HcOqKFptpaZqeOC+MYXommfOyItgJ
	 swHsvPpCgTE3WvLmZqhHBwFNIZ/uOytolr4D8399ZL1UhHyeDsxIpRMgCp8oyTHKL7
	 1zWgFobF0P7xX0A1Nki6UMpR5fkwcDMbYhmnD7b4qwxRIJUpPOYseuQ2vOWQmdd5/H
	 /609oaOqp1k6M18mTaqFq4cV3HEx1yGp8BfaXdxs8TZFfa6c3vzs1BAzC9GcU5eNwN
	 wConOUZXx+3CQTdsLXtXjey8YgS6KgFfwQxfgmhRwnegQx0vNNVBHEim/4gG2fYB+S
	 1xmwww2NXkhvg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-936dfd009d1so268950185a.1
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 01:26:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqsCCBjJVqUer/M0X9AOxrGoUPXygwR+GynN4KCygZgQOgQ4eYKDnrLC+2jlxbuVHGUwx7qlIbC@vger.kernel.org
X-Gm-Message-State: AFuF++kAhrbMplaRR5gZZwsXREtXKx6euhK4Cts0pnt9m8xhYpc++NF3
	8mbKwwA4wwuH0stk/+ndV2WHbmb8CNmSMTR0ZyvVoavE9GH8qvOteS+BaFQktwCLSTKtzysViMT
	tbMCHUXIhk22iCcU6bdvTL1z28v9rTiE=
X-Received: by 2002:a05:620a:2901:b0:92e:57ea:8c8b with SMTP id
 af79cd13be357-938ff9abf4fmr2092839685a.0.1787991991229; Sat, 29 Aug 2026
 01:26:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com> <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
In-Reply-To: <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 16:26:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z0f=gN58BgneY8GMyOPk+T-D9kY99Fo5FA1MKx2sADyA@mail.gmail.com>
X-Gm-Features: AcwNN1Vh8SvUhrDJHT68EhT8q8n0BxzVKAvDoklCBhtG9RXuinmOYLs_SOCYxYw
Message-ID: <CAGsJ_4z0f=gN58BgneY8GMyOPk+T-D9kY99Fo5FA1MKx2sADyA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Kairui Song <ryncsn@gmail.com>
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

On Sat, Aug 29, 2026 at 3:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
[...]

> > > + * lru_gen_set_flags - Set the LRU generation number to specified fo=
lio flags.
> > > + * @flags: pointer to the folio flags
> > > + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusi=
ve.
> > > + */
> > > +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
> > >  {
> > > -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> > > +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> > > +
> > > +       *flags &=3D ~LRU_GEN_MASK;
> > > +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> > > +}
> >
> > It seems that we are setting the gen in the flags, rather than
> > setting the flags themselves.
> >
> > The current name makes me think that the function is setting the
> > entire flags field, especially since `lru_gen` is used as the
> > namespace for various MGLRU functions, e.g.:
> >
> > void lru_gen_add_mm(struct mm_struct *mm);
> > void lru_gen_del_mm(struct mm_struct *mm);
> > void lru_gen_migrate_mm(struct mm_struct *mm);
> > struct lru_gen_folio;
> > lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> >
> > However, this function only sets the gen bits in the flags.
> > Maybe we could use a name that makes this distinction clearer?
> >
> > Could they be named as below, or is there a better naming option?
> >
> > set_gen_to_flags(unsigned long *flags, int gen);
> > get_gen_from_flags(unsigned long flags);
> >
> > Or something like flags_to_gen() or gen_from_flags()?
>
> I think having lru_gen as the prefix is a good idea actually since the
> header here is a very generic one, the word "gen" could be used my
> many other subsystem or drivers, gen_to_flags sounds too generic..
> While lru_gen is a very specific MGLRU thing.

Yes. The current problem is that `lru_gen` has been used as a
generic prefix for MGLRU functions. Here, however, we mean the
actual generation (`gen`), rather than `lru_gen` as the MGLRU
namespace.

>
> How about just rename it lru_set_gen_flags / lru_get_gen_flags? And we
> will have lru_set_refs_flags / lru_get_refs_flags below.

sounds good to me.

[...]

> > > +static inline void lru_refs_set_flags(unsigned long *flags, unsigned=
 int refs)
> > > +{
> > > +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> > > +       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGO=
FF) + 1);
> > > +
> > > +       *flags &=3D ~LRU_REFS_FLAGS;
> > > +       if (!refs)
> > > +               return;
> > > +       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_P=
GOFF));
> > > +}
> >
> > Similar to the above, maybe we could use more descriptive names?
>
> And here we have lru_set_refs_flags?

sounds good to me.

[...]

> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *foli=
o, const vma_flags_t *vma_flags)
> > >         if (!folio_test_referenced(folio) && !folio_test_workingset(f=
olio)) {
> > >                 /* Activate file-backed executable folios after first=
 usage. */
> > >                 if (is_exec_file_folio(folio, vma_flags)) {
> > > -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS=
, BIT(PG_workingset));
> > > +                       folio_set_workingset(folio);
> > > +                       folio_set_lru_refs(folio, 0);
> > >                         return true;
> > >                 }
> > >
> > > -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_=
referenced));
> > > +               folio_set_lru_refs(folio, 1);
> >
> > We have quite a few instances of folio_set_lru_refs(folio, 1) and
> > folio_set_lru_refs(folio, 0). Do these values have any special
> > meaning? Could we add wrapper helpers to make the code more readable?
> >
> > `1` just means `PG_referenced`, right? Could we add a comment or
> > changelog description to clarify that `1` actually means `refs =3D 0`,
> > but `PG_referenced` is set?
>
> Right, I introduced a LRU_REFS_REFERENCED in a later series. Now a
> comment could be good enough, as in fact PG_referenced is already kind
> of a unstable page flags under both MGLRU and CLRU. For MGLRU it only
> mean the refs count is larger than 1 so using a strict 1 here seems
> even cleaner, but it still keep getting cleared in many places. As for
> CLRU, the flag keeps getting reset when a folio is activated leading
> to an under-accounted value from smap and other components. So
> sanitizing its usage is a long-term goal.

Ok.

Best Regards
Barry

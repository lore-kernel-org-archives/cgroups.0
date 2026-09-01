Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065EB37E5EA
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 11:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788262450; cv=none; b=XW8K60OGo1kOq1AyAOP4PDrp5LuSRE8Tf0xJ5tsa4bJJKSv7TEkmC7UggNOCOeKZ63HLq7kiuyYewAVV+aVioxs3V/GLzOV4D8LkdoY2sBHPxOcbhVxy8CMLhDEs3AuTTj8O363tPj81C6v8IYbo4DS/XjB2saVQhXJb+Z2I9lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788262450; c=relaxed/simple;
	bh=bT/pXRnq1a0Oso3wGRNBQ2bKPv8POB+ho7CxuWlP+6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bwjn6FBoQWMbRYDYVt2bu4s7hNOCRHAzwUKt8mhjGbDQ7iQMo79xU2JpzGYqn5CcBYsFYpPPRg0vJFHUpCqfJq1cDeDsOKspifSHeg+Qp94jukztJCFW9zrHp/NzkXr5D0Mmqrh8KRXhRH41Jai+QpB/mnMZeNSAL8p/ZEh6SIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0hOIDPS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0hOIDPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54B91F0155C
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788262448;
	bh=xF9QmkpYR3qgfY873N8V29mRSsytqFszdnNsBX/pLXk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f0hOIDPS0Q9O0NDOUwT1+3cAmNujvY626UF7Fj9LoHsQekd/bUeEofdESU+l131oX
	 1pD02uxaA9N44WF7W36MuDX9AWKSVrQiZ3f5rNYBFq2/GPvtaJf/7hTDa4vTpCdLk/
	 xFyi2lmQEIh8JufGCAkIZ5DMQOxUJV9TETWFBpWYs6B9+L+sa3hUwB1qvvStQ5Gu0V
	 7SWl9rdGmbgLyjLHiWssfIGosKEL8/Cr8ZLIyNhL4Qc72Xb1dsf1aWVwC1RpbqjYwo
	 jZDwlxaa89Qb9AlWq1Bu3P5zdXhfVnruK4+OUUi9XecQZqa/zCivsfjP4tq90UhDSV
	 rp/YHKjjJAneg==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93959320373so10521685a.1
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 04:34:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpfEd9TUYkvkn7PGYNxxyicOUZIQs7i6DV9VBh1ntadlz+yoKumgj29a3sckaAawZnKHtOCcxWG@vger.kernel.org
X-Gm-Message-State: AFuF++lrhz9wfjzHXzeiFNXlmTug2lhiknpewqj44vowONtOPa+WzO3a
	ZdDB0bw/h1QkE7ORn20GU8UZZlQTYEtytElycvWYlH7BQVV8XB6S6MiYj/PbB2sSyMVLsxFAb7E
	NOW6xn0gby99iL/k2BD1sDIseguyBxcY=
X-Received: by 2002:a05:620a:448a:b0:936:cae5:8b38 with SMTP id
 af79cd13be357-939137fb875mr3424952185a.10.1788262447895; Tue, 01 Sep 2026
 04:34:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-6-2d15dde0d7ee@tencent.com>
 <CAGsJ_4y7MrUeHn4NvtpyyZ3EY-6dTUD4vhitw6Sy6tfRq6Tf9A@mail.gmail.com> <CAMgjq7CiewVYOsBoXMjg+tgbUMsXgYoTe1gJiEoADQdusffeng@mail.gmail.com>
In-Reply-To: <CAMgjq7CiewVYOsBoXMjg+tgbUMsXgYoTe1gJiEoADQdusffeng@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 19:33:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zaKfAzggCM=TN4ONgymcPyKSkW7AWqu+TnqD530X2OGQ@mail.gmail.com>
X-Gm-Features: AcwNN1XvdXl1z36F6kMBWRMqp5qE1QnodBYOqZkwoOs2kZlU3JiJ64EkO1iAKGA
Message-ID: <CAGsJ_4zaKfAzggCM=TN4ONgymcPyKSkW7AWqu+TnqD530X2OGQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] mm/mglru: fix potential generation folio number leak
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 7:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
[...]
> > >  static inline int folio_is_file_lru(const struct folio *folio)
> > >  {
> > > -       return !folio_test_swapbacked(folio);
> > > +       return folio_flags_is_file_lru(const_folio_flags(folio, 0));
> > >  }
> >
> > I guess we don't need to change this function? It seems more natural to
> > me to keep using `!folio_test_swapbacked(folio)` here.
> >
> > In `folio_update_gen()`, you already use
> > `*is_file =3D folio_flags_is_file_lru(&old_flags)` to get the type from
> > `old_flags`. I guess that's all we need?
>
> Yeah, that's all we need, I was thinking that using
> folio_flags_is_file_lru here can avoid any further change to
> PG_swapbacked causing inconsistency of folio_is_file_lru and
> folio_flags_is_file_lru, seems a bit easier to maintain.

Not quite sure. folio_is_file_lru() is based on the folio, so I guess we co=
uld
just check against the folio with folio_test_swapbacked(folio)?

Anyway, I=E2=80=99m not particularly strong on this. Either way is fine wit=
h me.

>
> >
> > >
> > >  static __always_inline void __update_lru_size(struct lruvec *lruvec,
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 724b6e034e69..87e667c410ed 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *=
sp, struct ctrl_pos *pv)
> > >   *******************************************************************=
***********/
> > >
> > >  /* promote pages accessed through page tables */
> > > -static int folio_update_gen(struct folio *folio, int new_gen, const =
vma_flags_t *vma_flags)
> > > +static int folio_update_gen(struct folio *folio, int new_gen, int *i=
s_file,
> >
> > Rather than is_file, I feel was_file would be more accurate here,
> > since it doesn't represent what the folio is now.
>
> I'm fine either way, is_file seems more natual to me. Or maybe simply
> rename it as "type"? Just the below:
>
> > > @@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm=
_walk *walk, struct vm_area_struc
> > >                 folio_mark_dirty(folio);
> > >
> > >         if (walk) {
> > > -               old_gen =3D folio_update_gen(folio, new_gen, &vma->fl=
ags);
> > > +               old_gen =3D folio_update_gen(folio, new_gen, &file, &=
vma->flags);
> > >                 if (old_gen >=3D 0 && old_gen !=3D new_gen)
> > > -                       update_batch_size(walk, folio, old_gen, new_g=
en);
> > > +                       update_batch_size(walk, folio, old_gen, new_g=
en, file);
> >
> > This is one more place where we rely on `LRU_GEN_ANON =3D 0` and
> > `LRU_GEN_FILE =3D 1`.
> >
> > We do this kind of thing quite often in MGLRU, such as `type =3D !type`=
.
> > It relies on the numeric values of the type constants, which is sort of
> > a semantic abuse, but it's hard to find a shorter way to express it.
>
> We also ahve WORKINGSET_ANON, WORKINGSET_FILE, ANON_AND_FILE. I can
> rename the newly added parameter to "type" here if that looks better.

Yes. Using the type seems clearer and easier to understand, and
it=E2=80=99s also consistent across multiple functions.

Best Regards
Barry

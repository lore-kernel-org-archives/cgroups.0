Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350B13A875B
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 10:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786790216; cv=pass; b=QnfAlRbOULclQUR0Du2yp+tDmw9su7GhdOacKjTJGDYft/K0sRHZneI3bW7P8Rf5tyfDMNES4Huiu7r0O0HO0FhRwnIlBmJY9QINCxHdgq4ggzBhsBctFE4QFhoEXkV1gKUDGSvamNc+lOV9lBMTFibbyL2HfQXqdwtDbscyj0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786790216; c=relaxed/simple;
	bh=DS6yB2qeQqbi7FySMxFQ+9vfVEdMwSKHStU8l98tnh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hU2qaXqDQNMpF82gWkALpPubDz4jnFfCPEVjLOomZmun05Ei49pgyaIW+UIFNFVYVkc2+obsK5BYa8G2eRrrAyzlRuktwORZfBYQDjrw96nNbH9/vVqWtfm7hIekMQRPW96khnZDE4BfXi6M64aLeYEnloQn3HSxowjEZoJvCyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PSK8CkPj; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PSK8CkPj"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so199522766b.1
        for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 03:36:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786790213; cv=none;
        d=google.com; s=arc-20260327;
        b=g0GfrU5l/l4OU2w7rAh/6PHh6PPxNc3GZR5nYZjfWgWk0uboz76Mo9fdw/4qi9yKWl
         LXNHMUCHkPuBNpJNaOgjl8rnmWDiWvUGHoiejTWFcWFvPmnPbcSKZ1ETlYQzgAbI08LQ
         6NnlbOM/3XCN/R6Gc9IZz1ZvsoRcgUxgZX4hgtTk1dlSP+ZJH30HqJdt20EmnbM+zMgM
         XAoUFhEfEvUoPtgR+y4kzp4hNxZo2sDPQfFbriGgWe7dkj4mesLLuNWBqDWRDcNrxSU0
         MRPh1+nrlojv3mL0oN5t5khOzXOLPrCWaurBlZJfOouV+UOfC9SgsrV+fdXqd2yQqhG9
         6QEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
        fh=lvgL9+W9QJMS0H6kAEiegDkK8qPZ3yfm+DrtwcBizfA=;
        b=RdYFh8uQLaCjWKand9VoQE6BZcDBiGkuyICzWecCI56jnfKLRvPvEtyxLy7yq16SR7
         P2iJY4c0F1lZpOpyVX98Ms17mhPtE8fDzXMjYhWPsvqCOUeNIOGtYA6rQ9aOuxaupVQK
         R6RXvFNxSYt9hk/Jv3m4KHCRxSP/fjluoX11JiYAkcU5lsn/Or2DJVgEZBxV+PRJJupN
         RnTFcpZ6/l1cdPLKKJcl74bwGZgoMzFtQ1ymfTKlGs+xpaOaoZnYXxoBB+ReLgMrKDzk
         g/t546Xg4xY9aPB1s4skPAdylT5Y+2e1cnIBxoVT0Vlr8jDMD9RrqHllIdUm8PK8kXVe
         J+bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786790213; x=1787395013; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
        b=PSK8CkPj9/jrTffXAcLl1A7WeN4N3qXMraMbfNgbk76CjauLI18cie/a5g0XyAMWAw
         EQl2VB68TMAqTtztFwnpFmfgS2vDYziS5DTJMM5g0fRGANIdZEHd0i1g4vEQB3Lj2vFD
         aaO8sWdPdn+2kyzVtkk9l4o6ILEop3SsMiiK3BAxvT8fxJ7AhnQiCbkIAlOfqY1LigJI
         XdM683plcSuJczGdyf6TFE5AqcB5yTLiNOHD2bf2dEzWXfSnJw7LNC4I+voVEMNtTz2o
         V+gpJj8OvLMMARwKOFXnX8+pLGvq2o3BX89+35o9n6c55iij6DXNGga3V2NfYTWp528E
         givg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786790213; x=1787395013;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
        b=ZMEh2pBvK/KwWVvkCulawvmhy/L6aa0Gbq6/spQjEz/bqcRvZYCJAUC7g08JHYQC73
         sh0uLen+U3wwGSByBS0Wn8T/fEAXA9gbjgMQsU2VqMFkEuCAULPamda0bzVBV9fplxz8
         JJalnHE0NijehP3UyvCwNv6BKWTyYlf1/seyE0vKGbPFs04JUNG4SfbFweT5TpDK+4VD
         U/ShMkviZUePqA55KfXF1dMGWsO5+B4+S4F/vFKwTt08u5iE5OQQR+HYw545wg7so/q3
         puIr/Q3/9lbN8Z2DTR4vsWW/JXdlp5nNlC88m4q2Fk2A/JcoKKmrUlbxO/pjf6J+vVoN
         wtfg==
X-Forwarded-Encrypted: i=1; AHgh+RpiMsthImhesrHZSqQPI/MLiBWdvPCjVWhNFJn/XySk0VJmUtdIp7yJlK9nSvHpoMv2f66SBhw0@vger.kernel.org
X-Gm-Message-State: AOJu0YyusBy24FUJPAOoG2ick6uNVe4GEZr0jCmT7MOgD0AubgGEF6r5
	bgiNCUHD3Wkg3vMLc8HLevebxQl5WCJMH0oe/CYEBtL4CGhm/AJA2R0Pm6KUQ7z9aAF0/oJZY4Z
	S/NaGfD/rbKw9lPV6J2CX8w6DWhsB1JI=
X-Gm-Gg: AR+sD11rRRfT3LO/ZNowkskPbVDKR2J5XKjT9VsHWl3ll+1ifb2/JWolh/FZHSoW3CE
	oPtcfXk5+vRBKeXXWqzFv7prxBxyqzlHRbL1xJRBC8OPkvgoHuE65AfAfhpSDhZuDEw+6P8U3V5
	BxLR2B/7WxtKbK8uQdflVXHQGx6Ob7iUhXi2s2UNnbiJRdf0yjuQk2RgRKW9RA8cMkvJSmMQyPX
	TUUEiJJV02aL37dWP7cU+Y/nBSeMgRoIfEBo7y3dVqB3bPGZppmpp2jlnlBNFlYJ3c5PuC/MNfO
	ZEUamSFbl0HplyYn3+YrnKYsmf1cTcjthQihyUOlq8jn8YmXvOAOUhfCtYmbGuQ7SXGSkiogjyT
	NRA==
X-Received: by 2002:a17:906:ee8d:b0:c21:792:8257 with SMTP id
 a640c23a62f3a-c212a1d6bd0mr501209266b.15.1786790213101; Sat, 15 Aug 2026
 03:36:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com> <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 15 Aug 2026 18:36:16 +0800
X-Gm-Features: AcwNN1XEDc-Qh3T6u4zhkGsXahR_kqoZIfVrMMEdKsYYSFr5PwD4n2Kn-yhytdE
Message-ID: <CAMgjq7Bg9wHC0MS8DGNzU7WFxHd2Lz5OrerUh=TLYYbiUppiQA@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 1:25=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > read_ctrl_pos() encodes the tier range in a single "tier" parameter
> > via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> > as the end.  This is hard to follow or maintain or extend. Tier
> > values 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS select=
s
> > the full range.
> >
> > Replace it with explicit (tier_min, tier_max) parameters using a
> > half-open [tier_min, tier_max) interval, which is the conventional C
> > idiom.  The call sites become self-documenting:
> >
> >   - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
> >   - get_type_to_scan: (0, MAX_NR_TIERS) for the full range
>
> I agree, this is a nice cleanup. The existing code is really hard to
> read. The magic is in i =3D tier % MAX_NR_TIERS, but I've been bitten
> by this magic a couple of times.
>
> But could we make the range inclusive? Right now, it still feels a bit
> difficult to follow.
>
> Since tier_min and tier_max are tier indices rather than a typical
> array range, would an inclusive [tier_min, tier_max] range be easier
> to read here? In particular, tier, tier + 1 at the call sites still
> requires the reader to know that tier_max is exclusive.
>
> >
> > No functional change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index c2ea92c2b69e..a359d5a1ff41 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3192,8 +3192,8 @@ struct ctrl_pos {
> >         int gain;
> >  };
> >
> > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, i=
nt gain,
> > -                         struct ctrl_pos *pos)
> > +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_mi=
n,
> > +                         int tier_max, int gain, struct ctrl_pos *pos)
> >  {
> >         int i;
> >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > @@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, =
int type, int tier, int gain,
> >         pos->gain =3D gain;
> >         pos->refaulted =3D pos->total =3D 0;
> >
> > -       for (i =3D tier % MAX_NR_TIERS; i <=3D min(tier, MAX_NR_TIERS -=
 1); i++) {
> > +       for (i =3D tier_min; i < tier_max; i++) {
> >                 pos->refaulted +=3D lrugen->avg_refaulted[type][i] +
> >                                   atomic_long_read(&lrugen->refaulted[h=
ist][type][i]);
> >                 pos->total +=3D lrugen->avg_total[type][i] +
> > @@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, in=
t type)
> >          * This value is chosen because any other tier would have at le=
ast twice
> >          * as many refaults as the first tier.
> >          */
> > -       read_ctrl_pos(lruvec, type, 0, 2, &sp);
> > +       read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
>
> It's still a bit of a headache when three integers are put together.
> Could we somehow make the 0 more self-explanatory, such as using
> TIER_MIN or a named constant?
>
> >         for (tier =3D 1; tier < MAX_NR_TIERS; tier++) {
> > -               read_ctrl_pos(lruvec, type, tier, 3, &pv);
> > +               read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
> >                 if (!positive_ctrl_err(&sp, &pv))
> >                         break;
> >         }
> > @@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec=
, int swappiness)
> >          * Compare the sum of all tiers of anon with that of file to de=
termine
> >          * which type to scan.
> >          */
> > -       read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &=
sp);
> > -       read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINES=
S - swappiness, &pv);
> > +       read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness=
, &sp);
> > +       read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPI=
NESS - swappiness, &pv);
> >
>
> Maybe we could introduce macros such as TIER_MIN and TIER_MAX to
> make the intent clearer?
>
> #define TIER_MIN 0
> #define TIER_MAX (MAX_NR_TIERS - 1)
>
> Best Regards
> Barry

Sounds good to me. Thanks for the review!

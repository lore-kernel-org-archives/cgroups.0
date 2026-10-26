Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793054089;
	b=AuzE40kojbz0cCIg+uc836VYRoM/n/PKxQu8MXnYKnbOD8r5LTkX7p0RAy9y3P7aHuHs
	 VMaoWnm1yfW1fW5BsV+xB5CJdmJC8kw9GPLfuCONZjwn/1c1ds2Mx4iH0+WBV7ww0zmUM
	 gyigSLGhGGQVG3ePkTjHN2I89G3UrFPtBmA4j2jtipPUTzMcQOoHuVeOBrfLeEIt8ydUo
	 3XNkyRN0nOl4bwzKP0cxlmbJbgE27EX0M1Kn1Vq85T4WcCDMWVyJm9VphHKVaFFWQuSMA
	 gFdI6LST0tfcGc2tP3jbJDzHzkCHSuw8gKQMimNB1WawXes+GdSsoe/T3b7O5u/2+fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793054089;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=HcaAjZorHHb3l5RdR8AVzhqeikVAxrwM1RaByGmw9Yc=;
	b=22L7oz+PptT/9aSLT3FeV3QFMgxeprnh00TVdC7GaenrWlHBaYPzqjFhouEpazcGCj4s
	 O2T12AHzIMKc5NrrVK7TGfi59+VWhb+ixNfzoDMR6yasDXbN6TYmzkbnOXmmiEhU4TYyN
	 1hKVW5wbHxpvaaBKy5lPlZ5MgGYwZ0MCFBXFoiFAtC+YBbuUuFR2/NSLk73kUrlk/aeuY
	 U/Jy2jxmQNLDh6+Sdr6oD+Ov462qf/ysrs9sdfkkeN8+Br/yEdOYIueDmNSG/2qASUu8j
	 4kf4BUIeVVnrm/bbVGQ7krQqSTTB4U+AmwprynTg0rKn86FUfVlO0gxrat3/chCb3dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jtr2b4rd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F3E606A32F
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jtr2b4rd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F010A1F031EB
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793054088;
	bh=HcaAjZorHHb3l5RdR8AVzhqeikVAxrwM1RaByGmw9Yc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jtr2b4rdy80J8VXiCReV1XjeedXzj0+9hEEOpA7+ZGMMVLgPlChKO1fo5Lyn1x65K
	 Y+fRecewIzI7QuNArsdnvpTGEuYMCdvJ9m0cWaclc/G0sHFNg1Kc1lu8NYkBrDVgqj
	 CndmPLaoJLrX5U8Fr1HpinhseNWZwhMw7sBfT19ArnOsZ9SJGoG90qPMdrK74joRd0
	 fqQTk//dULfyDjSl56Gk8MgXDFQ9PzcCPft5XPGrZe8MmGfiX7WK8UycxRY+ml9hfe
	 wMCeQi5vIFFnZxmzk48UtEfPEHL7heI9ePDOEAwqrx7pn33V2Eql5FnZar1giwgXlx
	 2u9A62QSAd4ww==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5364042eecfso45879441cf.2
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 15:34:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSDYwdJbAJnPUJnvuIh30vcQQqiHAbkMDe4nPlafR1T4iNCwE/HzRsGReDrrc4pSTvKV0zTCWT@vger.kernel.org
X-Gm-Message-State: AFq9FYJGk6ANleTzYsY5zXXxv3evm310ISItGUI6Zmz3vOFp6lRTZtc+
	zAZ/a2azvixJNnSCBAs7DnOQMi40minGbQLPN2IdGGqOhqJgDSt6KRYXxS47uK8sxwfNzq109ui
	lqlJfipmtfPtbjG+S0DSFgExWpsNoFyg=
X-Received: by 2002:a05:620a:4487:b0:93f:22ae:f8ff with SMTP id
 af79cd13be357-940ef8ea2a0mr1252625785a.46.1793054086667; Mon, 26 Oct 2026
 15:34:46 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-4-2106750c0bfa@tencent.com> <CAGsJ_4z3q_q-qyWdj85ZkMZvKOsXu7eO6qkiuQcppnd2oE3dTQ@mail.gmail.com>
 <CAMgjq7Dqa5Thm+tXUMrg5D1oSJxwyuJR5UOU+w33OgiebGvcJw@mail.gmail.com>
In-Reply-To: <CAMgjq7Dqa5Thm+tXUMrg5D1oSJxwyuJR5UOU+w33OgiebGvcJw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 27 Oct 2026 06:34:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yOtb+qaDtLAEC9-JEGp=1nSE7EVAExusKpuLX=Jy9t0g@mail.gmail.com>
X-Gm-Features: AclHuK_EgWblfKLU5vwI51ApCslBvbMrsiLYxVpzxVXvBo33Mt1M-XVAW31COos
Message-ID: <CAGsJ_4yOtb+qaDtLAEC9-JEGp=1nSE7EVAExusKpuLX=Jy9t0g@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 8:09=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Oct 19, 2026 at 6:10=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
[...]
> >
> > So this is the main course, with the earlier ones as appetizers and
> > the later ones as desserts?
> > Overall, this dish looks very delicious to me.
> >
> > I ran kernel build on my machine, the result is quite similar with[1].
> >
> > W/o patch:
> >
> > eal    1m49.094s
> > user    25m31.484s
> > sys     3m40.959s
> > pswpin: 662112
> > pswpout: 2504415
> > pgpgin: 4424336
> > pgpgout: 10355273
> > refault_file: 359626
> > refault_anon: 670724
> >
> > W/ patch:
> >
> > real 1m48.944s
> > user 25m30.987s
> > sys 3m34.605s
> > pswpin: 467952
> > pswpout: 2319080
> > pgpgin: 3481187
> > pgpgout: 9603332
> > swpout_zero: 602042
> > swpin_zero: 6250
> > refault_file: 310538
> > refault_anon: 474154
> >
> > But it behaves in a much more sensible way.
>
> Hi Barry,
>
> Thanks for the review and testing. Glad to see it worked for you.
>
> >
> > I've had a preliminary look, but haven't reviewed it in detail yet.
> > I have a few comments.
> >
> > [1] https://lore.kernel.org/linux-mm/20261016213115.70515-1-baohua@kern=
el.org/
>
> Right there could be some similarities, and some differences, e.g. no
> more lru_gen_in_fault hanlding here, or difference between anon /
> file. BTW did you test the whole series or just this patch? This patch

I tested the whole series rather than this patch in isolation.

[...]

> > Could we use the following instead? Coming from a hardware register bac=
kground,
> > this looks more like register encoding to me:
> >
> > static inline int lru_get_refs_flags(unsigned long flags)
> > {
> >     int refs;
> >
> >     refs  =3D !!(flags & BIT(PG_referenced));
> >     refs |=3D !!(flags & BIT(PG_workingset)) << 1;
> >     refs |=3D ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> >     return refs;
> > }
>
> No problem; it means the same thing and looks better indeed. I think I
> better change the return type to unsigned too, refs can never be
> negative (gen could be though, as a reserved value).

make sense to me. lru_get_refs_flags() is impossible to be negative.

>
> >
> > >
> > >  static inline int folio_lru_refs(const struct folio *folio)
> > > @@ -236,14 +240,29 @@ static inline void folio_set_lru_refs(struct fo=
lio *folio, unsigned int refs)
> > >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_=
flags));
> > >  }
> > >
> > > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> > > +
> > >  static inline int folio_lru_gen(const struct folio *folio)
> > >  {
> > >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, =
0)));
> > >  }
> > >
> > > +static inline bool lru_gen_at_tail(struct lruvec *lruvec, int type, =
int gen)
> > > +{
> > > +       unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[ty=
pe]);
> > > +
> > > +       /*
> > > +        * Consider a folio is at the tail of its LRU when it is with=
in
> > > +        * MIN_NR_GENS of the oldest generation of its own type
> > > +        */
> > > +       BUILD_BUG_ON(MIN_NR_GENS !=3D 2);
> > > +       return gen =3D=3D lru_gen_from_seq(min_seq) ||
> > > +              gen =3D=3D lru_gen_from_seq(min_seq + 1);
> > > +}
> >
> > If only two generations remain, should both be considered hot?
> > If three generations remain, is only the oldest generation old?
> >
> > Also, the name is a bit confusing, as "tail" usually refers
> > to a list. Could we rename it to one of the following?
> >
> > lru_gen_is_old()
> > or
> > lru_gen_is_near_oldest()
>
> Right, I wanted to introduce an idea of something called tailing gens
> (e.g. 8 tailing gens when there are 64 gens in total, folios in
> tailing gens are promoted on each access instead of multiple access,
> this works really well for fine grained hotness detection, and avoids
> over protection too). But for now this helper is just meant to tell
> the caller if the folio is close to be evicted or not, checking
> min_seq only could easily fall into a pitfall where the oldest gen is
> very short.
>
> Maybe lru_gen_at_expiry? Or lru_gen_at_salvage?
>

at_expiry gives the impression that a timer is involved in
triggering a timeout, while at_salvage is not very intuitive
for non-native English speakers.

I'd still prefer lru_gen_is_old(); it's simpler and easier to understand.

> BTW the whole picture involves three kinds of gens:
> {tailing/expiry/salvage} gens (promote by one gen on each one FD
> access), frequency gens (promote by one gen on multiple FD access),
> times gens (promote to latest gen on PTE access); We now only have
> expiry gens and frequency gens, timed gens are extensions for the
> workingset report or pghot design. e.g we have 64 gens, then 8 tailing
> gens are expiry gens, 16 frequency gens, and 48 newest gens are timed
> gens.
> https://lwn.net/Articles/976985/
>
> I mentioned this in the cover letter that the "climbing of the file
> cache" will stop at 8 gens or 16 gens, this is the whole story, there
> is a lot of context and plan so I trimed them off to focus on the FG
> improvement first..
>
[...]
> > >         if (folio_test_active(folio))
> > > -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> > > +               gen =3D MIN_NR_GENS - (refs >=3D LRU_REFS_WORKINGSET)=
;
> >
> > Could we define the "workingset" variant earlier so we can reuse it her=
e?
> >
> > workingset =3D refs >=3D LRU_REFS_WORKINGSET;
>
> Looks good, will do.

thanks!


>
> > > +/*
> > > + * Update the folio's lru refs indicator. The caller doesn't need to=
 hold
> > > + * the folio lock, isolate the folio, or hold the lruvec lock. Used =
by both
> > > + * cache access (flags =3D=3D 0) and page table access (LRU_REF_MAPP=
ED,
> > > + * optionally with LRU_REF_EXEC).
> > > + */
> > > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > > +{
> > > +       int max_gen;
> > > +       int type, refs, old_gen, gen;
> > > +       unsigned long new_flags, old_flags, max_seq;
> > > +       struct lru_gen_folio *lrugen;
> > > +       struct lruvec *lruvec =3D NULL;
> > > +
> > > +       type =3D folio_is_file_lru(folio);
> > > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > > +       do {
> > > +               new_flags =3D old_flags;
> > > +               old_gen =3D lru_get_gen_flags(old_flags);
> > > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > > +               gen =3D old_gen;
> > > +               if (old_gen < 0)
> > > +                       goto out;
> > > +               /*
> > > +                * Lock the lruvec if the folio is on-list. We are al=
ready
> > > +                * doing lazy promotion so in theory we don't need th=
is,
> > > +                * but for now, concurrent aging would still corrupt =
the
> > > +                * size counters.  This is a temporary limitation and
> > > +                * will be lifted very soon, so the lock here is not =
a
> > > +                * performance concern.
> > > +                */
> > > +               if (!lruvec) {
> > > +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(=
folio));
> > > +                       lrugen =3D &lruvec->lrugen;
> > >                 }
> > > +               max_seq =3D READ_ONCE(lrugen->max_seq);
> > > +               max_gen =3D lru_gen_from_seq(max_seq);
> > > +               if (old_gen =3D=3D max_gen)
> > > +                       goto out;
> > >
> > > -               folio_set_lru_refs(folio, 1);
> > > -               return false;
> > > -       }
> > > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > > +                       /* Promote second page table access or execut=
able */
> > > +                       if (refs > LRU_REFS_REFERENCED || flags & LRU=
_REF_EXEC)
> > > +                               gen =3D max_gen;
> >
> > This looks a bit odd to me. Could we handle LRU_REF_EXEC in a
> > separate branch instead of mixing it with refs > LRU_REFS_REFERENCED?
>
> Not sure how? They seem to want the same thing: promote the folio.

I mean we could have a separate branch for LRU_REF_EXEC | LRU_REF_FORCE:

                if (flags & (LRU_REF_EXEC | LRU_REF_FORCE)) {
                        gen =3D max_gen;
                        refs =3D min(refs, LRU_REFS_PROTECTED);
                } else if (flags & LRU_REF_MAPPED) {
                        if (refs > LRU_REFS_REFERENCED)
                                gen =3D max_gen;
                        /* First access only defers eviction of a tail gen =
*/
                        else if (lru_gen_at_tail(lruvec, file, old_gen))
                                gen =3D (old_gen + 1) % MAX_NR_GENS;
                        refs =3D min(refs, LRU_REFS_PROTECTED);
                } else if (refs > LRU_REFS_MAX) {


right now, it is:

                if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORCE)=
) {
                        if (refs > LRU_REFS_REFERENCED ||
                            flags & (LRU_REF_EXEC | LRU_REF_FORCE))
                                gen =3D max_gen;
                        /* First access only defers eviction of a tail gen =
*/
                        else if (lru_gen_at_tail(lruvec, file, old_gen))
                                gen =3D (old_gen + 1) % MAX_NR_GENS;
                        refs =3D min(refs, LRU_REFS_PROTECTED);
                } else if (refs > LRU_REFS_MAX) {

a bit hard to follow.

>
> > > +                       /* First access only defers eviction of a tai=
l gen */
> > > +                       else if (lru_gen_at_tail(lruvec, type, old_ge=
n))
> > > +                               gen =3D (old_gen + 1) % MAX_NR_GENS;
> >
> > The logic makes a lot of sense to me. It should be able to
> > differentiate readahead folios from those that are actually mapped
> > and likely to be accessed more than once.
> >
> > If we allow two generations to remain, this could be a problem
> > because old_gen + 1 would overflow. Maybe add a
> > VM_WARN_ON() to guard against this case?
>
> We just checked if (old_gen =3D=3D max_gen), so this should be fine? I
> mean overflow and the mod MAX_NR_GENS is also part of the sliding
> window logic.

Yep, I missed your check:

                if (old_gen =3D=3D max_gen)
                        goto out;

[...]
> > Sometimes you use >=3D LRU_REFS_WORKINGSET, while elsewhere
> > you use refs > LRU_REFS_REFERENCED. Can we unify these
> > checks or define a workingset variant?
>
> No problem; I can use a macro for that, as they mean the same thing.

right, thanks!

>
> > > +/*
> > > + * Update the lru refs indicator of an isolated folio, only used on
> > > + * mapped folios upon the final eviction.
> > > + *
> > > + * Increments the refs count (capped at LRU_REFS_PROTECTED, evict_fo=
lios()
> > > + * then caps it at LRU_REFS_WORKINGSET).  Returns true if the caller=
 should
> > > + * activate the folio (second access or executable), false to put it=
 back
> > > + * for a second chance.
> > > + */
> > > +static bool folio_inc_lru_refs_isolated(struct folio *folio, const v=
ma_flags_t *vma_flags)
> > > +{
> > > +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags=
(folio, 0));
> > > +       int refs;
> > > +
> > > +       do {
> > > +               new_flags =3D old_flags;
> > > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > > +               lru_set_refs_flags(&new_flags, min(refs, LRU_REFS_PRO=
TECTED));
> >
> > I'm having a hard time understanding why an activated folio
> > still keeps LRU_REFS_PROTECTED, since it will be promoted
> > to the active list anyway :-)
>
> Right the FG idea is to always retain the frequency counts, instead of
> resetting them to 0, so folio_inc_lru_refs can promote FD accessed
> folios much more proactively, when a folio reaches LRU_REFS_MAX it
> will be promoted by one gen.
>

folio_inc_lru_refs_isolated() is only called when
referenced_ptes is true, so these should always be mapped
folios:

if (lru_gen_enabled() && !lru_gen_switching()) {
      if (!referenced_ptes)
             return FOLIOREF_RECLAIM;

      return folio_inc_lru_refs_isolated(folio, &vma_flags) ?
        FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
}

When you say "FD-accessed folios" here, do you mean that
these mapped folios can also be accessed through syscalls,
and that you keep the refs to detect further FD accesses?

> I did a in depth analyze of runtime distribution, with this, we can
> see very hot folio being promoted from max_seq - 1 to max_seq, and
> after aging, the hotness info is still kept and workingset stay stable
> and accurate (it's like the global aging of traditional LFU, which is
> obsoluted in upstream due to overhead despite having better accuracy,
> but now it comes with almost zero cost).
>
> >
> > Later, I see that you set it to LRU_REFS_WORKINGSET in
> > evict_folios():
> >
> > folio_set_lru_refs(folio, min(folio_lru_refs(folio), LRU_REFS_WORKINGSE=
T));
>
> Right that part is meant for aging the older folios and PID controller
> though. LRU_REFS_WORKINGSET could means historical workingset, and
> LRU_REFS_PROTECTED means folios being currently actively protected.
>

folio_inc_lru_refs_isolated() is called from the eviction path.
Folios that are not reclaimed will go through:

__folio_set_lru_refs(folio, min(folio_lru_refs(folio), LRU_REFS_WORKINGSET)=
);

in evict_folios().

So LRU_REFS_PROTECTED eventually becomes
LRU_REFS_WORKINGSET(or 0, 1).

I'm still struggling to understand why we need a transition
from LRU_REFS_PROTECTED to LRU_REFS_WORKINGSET (or 0/1 if
folio_lru_refs() < LRU_REFS_WORKINGSET), since those folios
will always end up in LRU_REFS_WORKINGSET (or 0/1) anyway.

Thanks
Barry

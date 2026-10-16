Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970EE392C21
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 03:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121023; cv=pass; b=sOa1CaEyJY/HWSLJExW7DhSOHk81LxCAvaH/YxpwWAfpP05Qgj9MZ8lewJptkrdGJL7IUhzbQ/6PQoEBLnmLh0yzJ67Il2O4ffHK4WWH4TIv77wERSvsV3uqdKRwHwMbIEDJqbP+C/gInrHb2BTuQnrrj5dw7tcQF6MJWimugKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121023; c=relaxed/simple;
	bh=cIDew5yWJsVRzcclhzpz41GAk/yQ0E2hQ6SrIkR6mLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zw5xDHbMXXTlQsshBKonY0Jbj1BM54fcXjj7A7ZnRRXLmw+7vjtMaXF9cn+veKD9hUOsNxa3xWx9nGh/2Y2+09FjfQs+PLtfuTwmSo4TXuIGgXQkz/7DZx81LVujW0PRw0ouS5OFWz0KX1EAQY3o2ZtCDUxOF1n/jpIOJMsfDH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRNZhxNW; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRNZhxNW"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a172eb31f0so52646605e9.1
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 20:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792121020; cv=none;
        d=google.com; s=arc-20260327;
        b=nQ4d5i3ipxhyMPA4Rm7gOs0X1Xzx0FJC5tK08xJ11zkzCXkWb5ZpJBfHA1XfDxOVTV
         U4rZ6KxCArKoxLe26s6GBLcbFP39lZluWC1MAFE1wn7MZfCvqeSiu/uAum/w6puFxniq
         C7i4nWCOmBvOAtzJhlfBHe6JdDkjXe+EPR+ZS/rKP5qXv6fg5Cv4DqrXn/ZGWOoaIqI9
         bexWJtEhsXr1PpG7vEgourGwnplQApGJpM1HYX6QNtss2cH8oBe37Jl5g8tdx2XANth9
         K+9V1ncAuQrObZtx2glkmWpfxOIZoMYS9SldeVgKGN32V/OJJqcts3xQdMOAfojTQBbA
         CxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
        fh=EcjKT0IO2nDl9IoLqw8ejIJ4EluoDHnO31dZbdq4R6A=;
        b=hyUzyzP40kYQBJ9/Kqq87GVJ/dKRDMPlq8TRLlW1GqzYzfX7mzr300XZFaqogN2W4N
         4f3vRAdpFROEUemWhTNSDq54QwedZ6qbT7RNfFq6LFDukaCEZOT3qBZFnolH/UfqRWx8
         F4zrKFNKaViGHYI8gssNMjJWAhL8HqBvifGX0tGsgOf6f9GIAcOZKuW1sFejtvd4vlhW
         AuLwKXausQY4YKbnM5QaYGYllPXvHMZbRN8Zavld0YLYPa1cF62ihoU4DieBkcnkVTxY
         NQHtQk+KIIU6olhlp0wa7+A4648b7MdiFFsWU6k15yXjtGR5Ii9iPbwSOoTMfXbD0gdZ
         oNBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792121020; x=1792725820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
        b=QRNZhxNWJ1gijYVZoCNWvSCsvIJNEG+5lwWDAD1lRX+fnAKy4dA/lrbkmZZg9dP4CE
         Q/LjZ8elBixqoTm2SDVzZWfiWmUa6oXQupWCjX4py8lbBPOoEv2PLRAkHOq62XdyQkE3
         9yiHbHZP35STCLdXLgpWajCNThvNAaLzrMbNg+64/jcpkXTJ+N87DscQoIHdPW2wDyCo
         FfukSvDQV2eymVDhzoH9NOgPy9+Osr56mafaLNK4tqoTvk8gVnXqJsQaLz9bcdEWB29t
         9+LqD4hnYdtVkerlDhhQFFYabn6GJ8ks99ql6hWmPkM+cXrQ4cekQyuAF2EC/ROujav4
         eJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792121020; x=1792725820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
        b=GpornKplDF5EiFw35PaXyHa53zCyb0FxioRFf2CyeZAbrpLvfhizKqKy3+srqBVM/l
         8LyePP4f4Esd2d4dpCxzffRC/z+G2MHr0V8pD02tfIo86VUueU8sS6cB9LWMoZWyLKzg
         GiEnEIVvQM5XHQwdump66a98mjjDr3V0IU+fF9widuqe0wZkVxX0mB5Vt/xYrK9/3yCL
         vc+5Ijw3zanYziam592PihYQsvbB/TJ5n0E3LoxYbj7NsxNsYHaiA3M9ypUrUlFVdAP0
         OvL72ns1zRYpD8EZTBI5LCStSt8Mzf7oA3LC2o87iv570eiRNSixO1l8THG01VOeWMXy
         VmwQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMbBD9cKAmF2SoVO0xZFaJbtZvCBQcUYFHfG60Rh+rbTEKRU0jHWCFWqPiFOFIZY2OSG3/50SK@vger.kernel.org
X-Gm-Message-State: AFq9FYIMV/1VycSOKbYKE7WyEyuQMkv9UIScaf6QzYFh6hFjC1B9FJ/0
	UbbeCfO0+2M5HpgT3JlpMr+KH+nuyHMGqJWTtohnsEHrCBN6/d3k9V49kPAaQWIm3IdYfJCdWT/
	cyMX++re1z2RufQB0T187OuQuvqENwjQ=
X-Gm-Gg: AYBFou3GlgKNpvOIC5vewGAFBbiMbhMpS6eXMQfbLiCcnczOt+TeZQreZSfbLjtdcal
	zEagJXS2utfJTtbihOLQfTKU90vGOf9v1P9V76xMFm4Y2t1Y8gJ0FMw8hvi91N5hsCQ8+DtL1FJ
	KXL256W4LCK7Ak5A6a3u1IS1oKzJbp7V1xF8GMrgOOsB4MH/PxNcNBAINTOfGppIOk3D3poHo3C
	2YkPJfJSiR+53TgENGKykMHhcMiTpCgq1yS7mXNzpgl0HDKAmXUw351//qggorfBsGQsyCs5AZf
	05bi9wBDMXAgc6B1uvUHaH0R2x3uXN2Z7Wdb/gcdZdQroNAo9X2m1OiP
X-Received: by 2002:a05:600c:1d0b:b0:4a0:13ea:2ec3 with SMTP id
 5b1f17b1804b1-4a18e4ddca6mr422203805e9.35.1792121018258; Thu, 15 Oct 2026
 20:23:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
 <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com> <CAN_Opa-GVYVg1mUc=PJFfE8ZLCoAWjzDoWoxA8FEfsPAYGdijA@mail.gmail.com>
 <atBL2inthrJH_ng4@KASONG-MC4>
In-Reply-To: <atBL2inthrJH_ng4@KASONG-MC4>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 16 Oct 2026 11:23:26 +0800
X-Gm-Features: AclHuK_N9VwznAnK-_rOKQvlcBwO7N2BPlytUJO1x0sN6vdiDFScfhSSqrqgPcw
Message-ID: <CAN_Opa-42w3BwKV-DBjy-x-Ldi+RQgbRcgjGmsT_jzM4+4=K+g@mail.gmail.com>
Subject: Re: [PATCH RFC v3 13/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 11:46=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Mon, Oct 05, 2026 at 01:29:00AM +0800, KunWu Chan wrote:
> > On Sat, Oct 3, 2026 at 8:55=E2=80=AFPM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > > concurrent aging from corrupting the size counters.  This is no
> > > longer needed: the per-generation counters are atomic, and the
> > > active/inactive ABI counters are updated per folio and linearized by
> > > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > > them.  The same argument already allowed folio_reset_lru_refs() to
> > > drop the lock.
> > >
> > > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > > read lock around the lruvec lookup, and drop the spinlock entirely.
> > >
> > > Without the lock, aging can advance max_seq while a promotion is in
> > > flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> > > flags can return to the value read earlier and the cmpxchg succeeds
> > > with a target gen computed from a stale max_seq.  Recheck max_seq aft=
er
> > > a gen-changing cmpxchg: if it moved, account the committed update and
> > > retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> > > The retry may count the access twice, which is acceptable and avoids
> > > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> > > orders the flags read, including the one returned by a failed
> > > cmpxchg(), before the max_seq read.
> > >
> > > Also simplify the post-CAS accounting guards: gen is only assigned
> > > non-negative values after the old_gen < 0 early exit, so gen !=3D old=
_gen
> > > implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard=
.
> > > The active/inactive ABI update keeps its gen >=3D 0 check because an
> > > off-LRU folio has no lruvec to update.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  include/linux/mm_inline.h | 10 +++++-----
> > >  include/linux/mmzone.h    |  3 ++-
> > >  mm/vmscan.c               | 47 ++++++++++++++++++++++++++++---------=
----------
> > >  3 files changed, 35 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index ee7fcbe2366b..b68d68101248 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct fol=
io *folio)
> > >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, =
0)));
> > >  }
> > >
> > > -static inline void lru_gen_update_size(struct lruvec *lruvec, struct=
 folio *folio,
> > > -                                      int old_gen, int new_gen)
> > > +static inline void lru_gen_update_size(struct lruvec *lruvec, int ty=
pe,
> > > +               struct folio *folio, int old_gen, int new_gen)
> > >  {
> > > -       int type =3D folio_is_file_lru(folio);
> > >         int zone =3D folio_zonenum(folio);
> > >         int delta =3D folio_nr_pages(folio);
> > >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > @@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >         /* use the refs from the atomic snapshot to avoid raced updat=
e */
> > >         refs =3D lru_get_refs_flags(flags);
> > >
> > > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> > >         if (lru_refs_is_active(refs))
> > >                 lru +=3D LRU_ACTIVE;
> > >         __update_lru_size(lruvec, lru, zone, delta);
> > > @@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >  {
> > >         unsigned long flags;
> > >         int gen, refs;
> > > +       int type =3D folio_is_file_lru(folio);
> > >         int zone =3D folio_zonenum(folio);
> > >         int delta =3D folio_nr_pages(folio);
> > >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE=
_FILE;
> > > @@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_G=
ENS)
> > >                 folio_set_active(folio);
> > >
> > > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> > >         if (lru_refs_is_active(refs))
> > >                 lru +=3D LRU_ACTIVE;
> > >         __update_lru_size(lruvec, lru, zone, -delta);
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index e096fd0a5047..d78e3f97423e 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -558,9 +558,10 @@ enum lruvec_flags {
> > >  #define LRU_TIER_MIN           0U
> > >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> > >
> > > -/* Access source flags for folio_inc_lru_refs() */
> > > +/* Flags for folio_inc_lru_refs() */
> > >  #define LRU_REF_MAPPED         0x1U
> > >  #define LRU_REF_EXEC           0x2U
> > > +#define LRU_REF_FORCE          0x4U
> > >
> > >  #define LRU_REFS_REFERENCED    0x1
> > >  #define LRU_REFS_WORKINGSET    0x2
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index ae4a0522a8d5..9cc06a95d931 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -982,38 +982,33 @@ void folio_inc_lru_refs(struct folio *folio, un=
signed int flags)
> > >         long nr_pages =3D folio_nr_pages(folio);
> > >         struct lru_gen_folio *lrugen;
> > >         struct lruvec *lruvec =3D NULL;
> > > +       bool aged =3D false;
> > >
> > > +retry:
> > >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > >         do {
> > >                 new_flags =3D old_flags;
> > >                 old_gen =3D lru_get_gen_flags(old_flags);
> > >                 old_refs =3D lru_get_refs_flags(old_flags);
> > > -               file =3D folio_flags_is_file_lru(&old_flags);
> > >                 refs =3D old_refs + 1;
> > >                 gen =3D old_gen;
> > > +               file =3D folio_flags_is_file_lru(&old_flags);
> > >                 if (old_gen < 0)
> > >                         goto out;
> > > -               /*
> > > -                * Lock the lruvec if the folio is on-list. We are al=
ready
> > > -                * doing lazy promotion so in theory we don't need th=
is,
> > > -                * but for now, concurrent aging would still corrupt =
the
> > > -                * size counters.  This is a temporary limitation and
> > > -                * will be lifted very soon, so the lock here is not =
a
> > > -                * performance concern.
> > > -                */
> > >                 if (!lruvec) {
> > > -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(=
folio));
> > > +                       lruvec =3D folio_lruvec_live_get(folio);
> > >                         lrugen =3D &lruvec->lrugen;
> > >                 }
> > > +               /* Failed cmpxchg() does not order old_flags before m=
ax_seq. */
> > > +               smp_rmb();
> > >                 max_seq =3D READ_ONCE(lrugen->max_seq);
> > >                 max_gen =3D lru_gen_from_seq(max_seq);
> > >                 min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_se=
q[file]));
> > >                 if (old_gen =3D=3D max_gen)
> > >                         goto out;
> > > -
> > > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > > -                       /* Promote second page table access or execut=
able */
> > > -                       if (refs > LRU_REFS_REFERENCED || flags & LRU=
_REF_EXEC)
> > > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_=
FORCE)) {
> > > +                       if (refs > LRU_REFS_REFERENCED ||
> > > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
> > >                                 gen =3D max_gen;
> > >                         /* First access only defers eviction from the=
 oldest gen */
> > >                         else if (old_gen =3D=3D min_gen)
> > > @@ -1037,9 +1032,19 @@ void folio_inc_lru_refs(struct folio *folio, u=
nsigned int flags)
> > >                         break;
> > >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_=
flags));
> > >
> > > -       if (gen !=3D old_gen)
> > > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > > -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs=
) && old_gen >=3D 0) {
> > > +       if (gen !=3D old_gen) {
> > > +               /*
> > > +                * Gen-index reuse can fool cmpxchg(). Retry lockless=
ly, accepting
> > > +                * an extra reference to avoid folio_activate() laten=
cy.
> > > +                */
> > > +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)=
) {
> > > +                       flags =3D LRU_REF_FORCE;
> > > +                       aged =3D true;
> > > +               }
> > > +               lru_gen_update_size(lruvec, file, folio, old_gen, gen=
);
> > > +       }
> > > +
> > > +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs=
) && gen >=3D 0) {
> > >                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
> > >
> >
> > Hi Kairui,
> >
> > One question about the retry path.
> >
> > When `max_seq` changes after a gen-changing cmpxchg, the retry uses
> > `LRU_REF_FORCE` and promotes the folio directly to `max_gen`. In the
> > normal first `LRU_REF_MAPPED` access path, the same folio is only moved
> > to the next generation when it is in the oldest generation.
> >
> > Is the stronger promotion on the retry intentional? In other words,
> > does detecting that `max_seq` advanced during the update justify
> > promoting the folio all the way to the newest generation, rather than
> > re-evaluating the original promotion policy with the new `max_seq`?
>
> I think we are fine, that window is very very rare already, and the
> problem is we may cause hotness inversion if the gen number lapped
> with each other. To making things easier, if the max_seq changed,
> just force promote it so we won't lose any hotness info. It may
> over protect but the chance is like once in a million so I think
> it's fine.

Makes sense =E2=80=94 over-protecting once in a million is clearly the
safer side.
Thanks for the explanation. I'll look at v4 and follow up there.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D133AF662
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 10:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404658; cv=none; b=QzzuDO1urOTnggpz/vsp6y/IEvQ0NvQAJYjAUC3t9ewcPPhM6BNWK8fHyLWYKlUXNgj4bK2cWYCnB78C2s6f0nK/hkQTQ9uBqrlvW8a07tOVrujG8JfE2Ftxj7L+yGLm5XewfYRXNhiZ6lb9KhQ70Ykrw5SsWLhPPq8e+YHq+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404658; c=relaxed/simple;
	bh=AKzprNYUiAAFYTK4NTopFzOHj7pz9hUW3++zTyp+FwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dk/oeZdhoe+RXK2y826kJm0dDYwwYgscYYhrMrXb9JC2CGZPJx/8w9W6tgX0OKd71ComlZHtULfz6g4nIbZ1ZtC8NvTo+kGz4c6+ZGbwA1v28qZh9A9DLvlOhLVOFESBjg9zqll/lYSoNlwe0JujySggCg2DeBRgaIcNfqnhSJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZP9QvOu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZP9QvOu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9641F000C8
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 10:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792404655;
	bh=WaA+l1XJSZ9HiN/z/vQVDCApDqsi4qZA41ztoAPUQsA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZP9QvOu1dcDkdJ2PMGmunzGgcTGwU0GXHm+PBr+zTo2TSm4YiWnk3WSwrRVy/uq7x
	 JkEmT08xvDycBTqGV0Asrn9M2O8B6o4TUXJbXsElFBW+GR60pqoIgU+mTrLka+v5Pw
	 YKfeEULaFql4gdlBBEf+oc6wVpxNu0H9XK3BUt79/oNNqeN6NLcCP+0DiL3gxp7pOs
	 AZRD0Hx1Q7m7oaidTDMsmfDNlD7hiFu5b8MREJHEDsF0QnltU5U4ARFMWDQcCQe+Dx
	 64x6eX6+EYdPqvUobCs0CsO/fZzTNaP6XGwAGq6L0cHe1nm/xJa//R359c5FhmHo5U
	 8C8C1oXZeSscA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93e762768f3so245651985a.0
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 03:10:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByN6h1fuR7LOzMDsP248ZjInGRn+f0X19nIK5b8VAGP+Hj4htN+HBFyHz5adSR2x8nIXBcFW75B@vger.kernel.org
X-Gm-Message-State: AFq9FYKDUk+DFJRXEZTqpoG7Zr1EBO0laqJN/haTcYo/6oG/uiGX/avi
	WxbyMc6VVIB8xeTPbJCMFikVC5NneIptn7pTnMf4PhunOpedWj2wW1yB+D1cRui77Z4Jh4nisNl
	8lPx1sbrV8h8cAwyR/bZd9rdEGNee89E=
X-Received: by 2002:a05:620a:2609:b0:93f:2938:48ba with SMTP id
 af79cd13be357-93f29d9616dmr1176028685a.55.1792404654435; Mon, 19 Oct 2026
 03:10:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016-mglru-fg-v4-4-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-4-2106750c0bfa@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 19 Oct 2026 18:10:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z3q_q-qyWdj85ZkMZvKOsXu7eO6qkiuQcppnd2oE3dTQ@mail.gmail.com>
X-Gm-Features: AclHuK_DEbb17yC9hvV-4abHRcfyWeYb3j-jtgH6f7SQSkhdUrFT4L0vMRS40vE
Message-ID: <CAGsJ_4z3q_q-qyWdj85ZkMZvKOsXu7eO6qkiuQcppnd2oE3dTQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
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
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Complement MGLRU's eviction-time tier-PID protection with access-time
> frequency-guided promotion.  Introduce a unified set of helpers built bas=
ed
> on referenced (access) count of a folio.
>
> Each access increments a folio's referenced count stored in folio flags
> (refs), refs still maps to a logarithmic tier just like before, but with
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX (7). When refs reaches a certain threshold, the folio is
> promoted proactively instead of waiting for the PID controller to kick in=
.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced: they
> become the low two bits of the refs count, with the higher bits
> provided by LRU_REFS_MASK.  This reduces MGLRU's original refs count
> bit usage by one, since only one extra bit is now needed to record a
> max referenced count of 7, and makes MGLRU's refs accounting more
> accurate.
>
> This doesn't affect classical LRU in any way, and it addresses several
> shortcomings of MGLRU's old tier-only cache protection model:
>
> - Long feedback loop: protection only activated after enough re-faults,
>   by which time the hot folios are already evicted, or no longer hot.
>
> - Limited tier resolution: once referenced count exceeded the bits
>   limit (8 previously), MGLRU could no longer distinguish hotter folios a=
s
>   they are capped by the tier.  And what's worse, PG_workingset forces
>   a folio to stay on tier 3.
>
> - Eviction hotness reversion: because PID protection activates upon
>   eviction and always targets the LRU tail, it tends to protect cold tail
>   folios at the expense of hotter head folios.  Once the tail folios
>   consume the PID protection budget, head folios lose their protection.
>
> - Additionally, the PID cannot distinguish the access time of folios
>   that share the same reference count, and there are only 4 tiers.
>
> To achieve a frequency-guided framework, this commit introduces and rewor=
ks
> the LRU_REFS related helpers and definitions; most of the work is done by
> the helpers below, and their inline comments describe the details.
>
> - folio_inc_lru_refs(): Called on any cache access (folio_mark_accessed)
>   or page table access.  This is the main helper: it promotes folios
>   according to their access frequency.
>
>   A first access only defers eviction for a folio at the tail of its
>   LRU, i.e., in one of the MIN_NR_GENS oldest generations of its own
>   type (see lru_gen_at_tail()), and a workingset folio accessed through
>   a file descriptor is deferred from the same tail.  Those are the
>   generations the eviction scans next, so the deferral moves the folio
>   out of its way for one generation.
>
>   Promotion is lazy: the gen bits and size counters are updated eagerly,
>   while the list move is deferred to the next isolation.  NOTE: For now,
>   the lruvec lock is unconditionally taken on every on-list access to
>   block concurrent aging; a lockless fast path will be implemented very
>   soon in a following commit.
>
> - folio_inc_lru_refs_walk(): Used by the PTE walk path during aging and
>   by the batched look-around, both without the LRU lock, so max_seq may
>   be stale.  A first page table access only advances a folio at the tail
>   of its LRU, i.e., in one of the MIN_NR_GENS oldest generations of its
>   own type (second chance), a second access promotes it to the newest
>   generation; this also performs lazy promotion.
>
> - folio_inc_lru_refs_isolated(): Used by the rmap check before
>   eviction.  The folio is isolated and hence this doesn't perform
>   promotion by itself; the folio will be added back to the right gen
>   upon return according to the access frequency.  This path also has a
>   higher promotion bias.
>
> The eviction-time folio_inc_gen() still handles PID protection, but the
> protection ratio is softer than before since proactive promotion is
> mostly good enough already.  The PID gain factors are relaxed from
> (2:3) to (1:2) and the setpoint now spans the cumulative mass of the
> tiers below the candidate instead of tier 0 alone.  folio_inc_gen()
> caps refs at WORKINGSET so the folio retains enough history to stay
> above the cold tier.  Tier 1 is the fallback tier for PID, and tier 2
> is the fallback tier for frequency-guided promotion.  The forced
> protection for full-refs folios is removed, obsoleted by the proactive
> promotion.
>
> Refaults are now activated purely according to access frequency:
> the old fault bias applied in folio_add_lru() is simplified, since a
> folio's access history is a more consistent signal than the context of
> the faulting task.  Page table access is still considered a slightly
> stronger signal.
>
> Consequently the placement hint for newly added file folios also uses
> LRU_REFS_WORKINGSET instead of PG_referenced, so a folio accessed only
> once now starts in the oldest generation rather than the second oldest.
> The previous one-generation grace was an artifact of the fault bias which
> is well described in the cover letter of this series, and it depended
> on LRU drain timing.
>
> This also redefines PG_workingset and PG_referenced as the low two
> bits of the refs count, eliminating the old restriction where
> LRU_REFS_MASK was only valid when PG_referenced was set, and allows
> all paths to use the same encoding consistently.  Following this idea,
> a workingset folio is now defined as refs >=3D LRU_REFS_WORKINGSET (2),
> matching the active/inactive LRU's definition and giving in-kernel
> consumers (PSI, readahead) consistent behavior on MGLRU, fixing the
> longstanding issue that these users don't work well with MGLRU.
>
> PG_workingset and PG_referenced are no longer independent flags under
> MGLRU.  Adjusting existing raw folio_test_*() callers to the new
> semantics is left as follow-ups.

So this is the main course, with the earlier ones as appetizers and
the later ones as desserts?
Overall, this dish looks very delicious to me.

I ran kernel build on my machine, the result is quite similar with[1].

W/o patch:

eal    1m49.094s
user    25m31.484s
sys     3m40.959s
pswpin: 662112
pswpout: 2504415
pgpgin: 4424336
pgpgout: 10355273
refault_file: 359626
refault_anon: 670724

W/ patch:

real 1m48.944s
user 25m30.987s
sys 3m34.605s
pswpin: 467952
pswpout: 2319080
pgpgin: 3481187
pgpgout: 9603332
swpout_zero: 602042
swpin_zero: 6250
refault_file: 310538
refault_anon: 474154

But it behaves in a much more sensible way.

I've had a preliminary look, but haven't reviewed it in detail yet.
I have a few comments.

[1] https://lore.kernel.org/linux-mm/20261016213115.70515-1-baohua@kernel.o=
rg/

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  96 ++++++++------
>  include/linux/mmzone.h    | 145 +++++++++++++++------
>  kernel/bounds.c           |   2 +-
>  mm/folio.c                |  50 +-------
>  mm/vmscan.c               | 320 +++++++++++++++++++++++++++++++---------=
------
>  mm/workingset.c           |  45 ++++---
>  6 files changed, 409 insertions(+), 249 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index f52f02e8e5be..74d1b7a04ca1 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -144,12 +144,13 @@ static inline int lru_hist_from_seq(unsigned long s=
eq)
>         return seq % NR_HIST_GENS;
>  }
>
> -static inline int lru_tier_from_refs(int refs, bool workingset)
> +static inline int lru_tier_from_refs(unsigned int refs)
>  {
> -       VM_WARN_ON_ONCE(refs > BIT(LRU_REFS_WIDTH));
> -
> -       /* see the comment on MAX_NR_TIERS */
> -       return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> +       BUILD_BUG_ON(fls(LRU_REFS_MAX - 1) > MAX_NR_TIERS - 1);
> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +       if (refs < LRU_REFS_WORKINGSET)
> +               return 0;
> +       return fls(refs - 1);
>  }
>
>  /**
> @@ -187,21 +188,24 @@ static inline int lru_get_gen_flags(unsigned long f=
lags)
>   * @flags: pointer to the folio flags
>   * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, =
inclusive.
>   *
> - * For MGLRU, PG_referenced holds the first ref, and the extra bits hold=
 the
> - * remaining refs. For classical LRU the extra bits are not used, so it =
can
> - * also be seen as the refs count never exceeds 1. In both cases, refs =
=3D=3D 1
> - * means PG_referenced is set and the extra bits are zero, and refs =3D=
=3D 0 means
> - * PG_referenced and the extra bits are all unset.
> + * For MGLRU, PG_referenced, PG_workingset are used as the lower two bit=
s of
> + * refs counter, and extra bits hold the remaining higher bits. For clas=
sical
> + * LRU the extra bits are not used, and the two flags has no direct
> + * relationship with each other, but this helper can still be used to sy=
nc
> + * them. For both cases, refs =3D=3D 0 means these two flags and the ext=
ra bits
> + * are all unset. And refs =3D=3D 1 / 2 / 3 means PG_referenced and PG_w=
orkingset
> + * are set in an bit order way, which is more meaningful for MGLRU thoug=
h.
>   */
>  static inline void lru_set_refs_flags(unsigned long *flags, unsigned int=
 refs)
>  {
>         VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> -       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGOFF) =
+ 1);
> -
> +       BUILD_BUG_ON(LRU_REFS_MASK & (BIT(PG_referenced) | BIT(PG_working=
set)));
>         *flags &=3D ~LRU_REFS_FLAGS;
> -       if (!refs)
> -               return;
> -       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF=
));
> +       if (refs & BIT(0))
> +               *flags |=3D BIT(PG_referenced);
> +       if (refs & BIT(1))
> +               *flags |=3D BIT(PG_workingset);
> +       *flags |=3D ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
>  }
>
>  /**
> @@ -212,13 +216,13 @@ static inline void lru_set_refs_flags(unsigned long=
 *flags, unsigned int refs)
>   */
>  static inline int lru_get_refs_flags(unsigned long flags)
>  {
> -       if (!(flags & BIT(PG_referenced)))
> -               return 0;
> -       /*
> -        * Return the total number of accesses including PG_referenced. A=
lso see
> -        * the comment on LRU_REFS_FLAGS.
> -        */
> -       return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
> +       int refs;
> +
> +       /* Return the total number of accesses. See the comment above MAX=
_NR_TIERS. */
> +       refs =3D (flags & BIT(PG_referenced)) ? BIT(0) : 0;
> +       refs +=3D (flags & BIT(PG_workingset)) ? BIT(1) : 0;
> +       refs +=3D ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> +       return refs;
>  }

Could we use the following instead? Coming from a hardware register backgro=
und,
this looks more like register encoding to me:

static inline int lru_get_refs_flags(unsigned long flags)
{
    int refs;

    refs  =3D !!(flags & BIT(PG_referenced));
    refs |=3D !!(flags & BIT(PG_workingset)) << 1;
    refs |=3D ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
    return refs;
}

>
>  static inline int folio_lru_refs(const struct folio *folio)
> @@ -236,14 +240,29 @@ static inline void folio_set_lru_refs(struct folio =
*folio, unsigned int refs)
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> +void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> +
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
>  }
>
> +static inline bool lru_gen_at_tail(struct lruvec *lruvec, int type, int =
gen)
> +{
> +       unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[type])=
;
> +
> +       /*
> +        * Consider a folio is at the tail of its LRU when it is within
> +        * MIN_NR_GENS of the oldest generation of its own type
> +        */
> +       BUILD_BUG_ON(MIN_NR_GENS !=3D 2);
> +       return gen =3D=3D lru_gen_from_seq(min_seq) ||
> +              gen =3D=3D lru_gen_from_seq(min_seq + 1);
> +}

If only two generations remain, should both be considered hot?
If three generations remain, is only the oldest generation old?

Also, the name is a bit confusing, as "tail" usually refers
to a list. Could we rename it to one of the following?

lru_gen_is_old()
or
lru_gen_is_near_oldest()

> +
>  static inline bool lru_gen_is_active(const struct lruvec *lruvec, int ge=
n)
>  {
> -       unsigned long max_seq =3D lruvec->lrugen.max_seq;
> +       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
>
>         VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
>
> @@ -300,23 +319,24 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
>                                               bool reclaiming)
>  {
>         int gen;
> +       int refs =3D folio_lru_refs(folio);
>         int type =3D folio_is_file_lru(folio);
>         const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         /*
> -        * +-----------------------------------+-------------------------=
----------+
> -        * | Accessed through page tables and  | Accessed through file de=
scriptors |
> -        * | promoted by folio_update_gen()    | and protected by folio_i=
nc_gen()  |
> -        * +-----------------------------------+-------------------------=
----------+
> -        * | PG_active (set while isolated)    |                         =
          |
> -        * +-----------------+-----------------+-----------------+-------=
----------+
> -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_R=
EFS_FLAGS |
> -        * +-----------------------------------+-------------------------=
----------+
> -        * |<---------- MIN_NR_GENS ---------->|                         =
          |
> -        * |<---------------------------- MAX_NR_GENS -------------------=
--------->|
> +        * +------------------------------------------+------------------=
------------------------+
> +        * |     Accessed through page tables and     |     Accessed thro=
ugh file descriptors    |
> +        * | promoted by folio_inc_lru_refs_walk()    | protected by foli=
o_inc_lru_refs/inc_gen  |
> +        * +------------------------------------------+------------------=
------------------------+
> +        * | PG_active (set at isolation or refault)  |                  =
                        |
> +        * +--------------------+---------------------+------------------=
--+---------------------+
> +        * |     LRU_REFS_MAX   | LRU_REFS_WORKINGSET |    LRU_REFS_MAX  =
  | LRU_REFS_WORKINGSET |
> +        * +------------------------------------------+------------------=
------------------------+
> +        * |<-------------- MIN_NR_GENS ------------->|                  =
                        |
> +        * |<----------------------------------- MAX_NR_GENS ------------=
----------------------->|
>          */
>         if (folio_test_active(folio))
> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +               gen =3D MIN_NR_GENS - (refs >=3D LRU_REFS_WORKINGSET);

Could we define the "workingset" variant earlier so we can reuse it here?

workingset =3D refs >=3D LRU_REFS_WORKINGSET;


>         else if (reclaiming)
>                 gen =3D MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(foli=
o)) ||
> @@ -324,7 +344,7 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio)=
)))
>                 gen =3D MIN_NR_GENS;
>         else
> -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
> +               gen =3D MAX_NR_GENS - (refs >=3D LRU_REFS_WORKINGSET);

As above.

>
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
> @@ -338,6 +358,7 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         int zone =3D folio_zonenum(folio);
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
> +       BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
>         VM_WARN_ON_ONCE_FOLIO(gen !=3D -1, folio);
>
>         if (folio_test_unevictable(folio) || !lrugen->enabled)
> @@ -392,7 +413,6 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>   */
>  static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
>  {
> -       BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
>         folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>  #else /* !CONFIG_LRU_GEN */
> @@ -422,6 +442,10 @@ static inline bool lru_gen_del_folio(struct lruvec *=
lruvec, struct folio *folio,
>         return false;
>  }
>
> +static inline void folio_inc_lru_refs(struct folio *folio, unsigned int =
flags)
> +{
> +}
> +
>  static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
>  {
>         if (folio_test_referenced(old))
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 09ce82fa841a..b5a3769fdcab 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -453,57 +453,122 @@ enum lruvec_flags {
>  #define MAX_NR_GENS            4U
>
>  /*
> - * Each generation is divided into multiple tiers. A folio accessed N ti=
mes
> - * through file descriptors is in tier order_base_2(N). A folio in the f=
irst
> - * tier (N=3D0,1) is marked by PG_referenced unless it was faulted in th=
rough page
> - * tables or read ahead. A folio in the last tier (MAX_NR_TIERS-1) is ma=
rked by
> - * PG_workingset. A folio in any other tier (1<N<5) between the first an=
d last
> - * is marked by additional bits of LRU_REFS_WIDTH in folio->flags.
> + * Each generation is divided into multiple tiers. A folio's referenced
> + * count maps to a tier as shown below:
>   *
> - * In contrast to moving across generations which requires the LRU lock,=
 moving
> - * across tiers only involves atomic operations on folio->flags and ther=
efore
> - * has a negligible cost in the buffered access path. In the eviction pa=
th,
> - * comparisons of refaulted/(evicted+protected) from the first tier and =
the rest
> - * infer whether folios accessed multiple times through file descriptors=
 are
> - * statistically hot and thus worth protecting.
> + * MGLRU (frequency guidance)
> + *  Refs  Tier  |- Refs: how many times (at least) a folio has been refe=
renced.
> + *   0      0   |- Mostly cold pages, readahead, etc. [1]
> + *   1      0   |=3D LRU_REFS_REFERENCED: Used at least once. [2]
> + * -WORKINGSET-+|- Pages beyond are workingset and never fall below this=
 floor. [3]
> + *   2      1<-+|=3D LRU_REFS_WORKINGSET: Classical workingset, accessed=
 twice, protected. [4]
> + *   3      2   |- LRU_REFS_PROTECTED: Protected workingset, promoted pa=
ges capped at here. [5]
> + *   4      2   |
> + *   5      3   |- The tier here is MAX_NR_TIERS - 1
> + *   6      3   |
> + *   7      3   |=3D LRU_REFS_MAX: Promotion candidate. [6]
> + * -PROMOTION->-/
>   *
> - * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice =
the
> - * number of categories of the active/inactive LRU when keeping track of
> - * accesses through file descriptors. This uses MAX_NR_TIERS-2 spare bit=
s in
> - * folio->flags, masked by LRU_REFS_MASK.
> + * Ideally each tier holds folios of similar access patterns: lower tier=
s
> + * are less important and evicted faster.  A page's reference count and
> + * tier are capped when it changes generation, preventing it from
> + * dominating the new generation based on old-generation access history.
> + * Generation ordering already ensures a newer-gen page is hotter than a=
n
> + * older-gen one regardless of tier.
> + *
> + * Refs tracks accesses from two sources: page table (lazily collected b=
y
> + * the page table aging walk or rmap eviction lookup) and file descripto=
rs
> + * (by folio_mark_accessed).  Page table accesses are weighted heavier
> + * because the accessed bit is sticky (undercounts repeated accesses),
> + * passively collected, and page faults are generally more important as
> + * userspace does not expect a memory access to block on reclaim.  Both
> + * access types increment refs by one; the result is capped at
> + * LRU_REFS_PROTECTED on promotion or deferral, or LRU_REFS_MAX otherwis=
e.
> + *
> + * 1. Tier is fls(N-1) for N > 1, 0 otherwise.  Folios with zero
> + *    accesses (refs =3D=3D 0) are generally cold, e.g. readahead folios=
.
> + *
> + *    Freshly allocated folios start with refs =3D=3D 0; faulted and map=
ped
> + *    folios have their page table access bit set, so the first page tab=
le
> + *    access check always sets LRU_REFS_REFERENCED.  That is the second
> + *    chance described above MIN_NR_GENS: it moves the folio one
> + *    generation forward if it is at the tail of its LRU, i.e., in one
> + *    of the two oldest generations of its type.
> + *
> + * 2. Folios accessed once stay on tier 0: one-time usage does not
> + *    qualify for protection.  A second access advances the folio,
> + *    aligning with classical LRU's use-twice threshold.  A second page
> + *    table access promotes to the latest gen; file access only defers
> + *    eviction from the tail gens of its type.
> + *
> + * 3. Folios accessed at least twice are considered workingset.  This
> + *    mostly aligns with classical LRU: at least one I/O is saved by
> + *    keeping them in memory.  Folios at or above this level never fall
> + *    below tier 1 (the workingset floor), so tier 0 stays a clean tier
> + *    for cold cache while tier 1 serves as the fallback line for
> + *    actually reused or historically hot folios.
> + *
> + *    Folios refaulted through a page fault at refs 1 will enter the sec=
ond
> + *    newest gen, so faulting will be protected better.
> + *
> + * 4. Starting from tier 1, PID protection sacrifices lower tiers to
> + *    protect higher tiers by comparing refault rates for long-term
> + *    accuracy, and caps higher refs to this value.  Since PID protectio=
n
> + *    bypasses page table lookup and clearing, when a further eviction
> + *    attempt occurs after PID loosens, the folio's page table access is
> + *    rechecked and a referenced folio is put back with refs capped to
> + *    this value as well.  This also gives folios a fair opportunity to =
be
> + *    promoted by file access again.
> + *
> + *    Folios refaulted through a page fault at tier 1 or above are activ=
ated
> + *    and enter the newest gen. Non fault page will enter second oldest =
gen,
> + *    driving aging and workingset shifting.
> + *
> + * 5. Pages beyond the ordinary workingset tier form new tiers for the
> + *    PID controller to protect differently.  Folios at or above this
> + *    level are capped at LRU_REFS_PROTECTED on promotion or deferral,
> + *    and at LRU_REFS_WORKINGSET under PID protection in the oldest
> + *    generation, where they represent a historical workingset.
> + *
> + * 6. Folios that reach LRU_REFS_MAX are advanced to the next generation
> + *    on further access, with refs capped to LRU_REFS_PROTECTED.  This
> + *    gives them a fair start for advancement to an even newer generatio=
n
> + *    while keeping hot folios distinguishable.
> + *
> + * Tiering uses PG_referenced and PG_workingset as the lower two bits,
> + * and the bits masked by LRU_REFS_MASK as the higher bits, so the refs
> + * count ranges from 0 to LRU_REFS_MAX.  A folio is on the workingset
> + * tier once accessed at least twice, which is more consistent with the
> + * classical LRU.
> + *
> + * A folio's referenced count never goes backwards except upon gen
> + * increase as described above, or when explicitly reset by
> + * lru_gen_clear_refs().  Refault of a reclaimed folio restores
> + * its referenced count, capped at LRU_REFS_PROTECTED, which aligns with
> + * promotion.  Page table refaults of previous workingset folios send
> + * them to the latest gen, driving aging faster.
> + *
> + * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice
> + * the number of categories of the active/inactive LRU.
>   */
>  #define MAX_NR_TIERS           4U
>  #define LRU_TIER_MIN           0U
>  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
>
> +/* Access source flags for folio_inc_lru_refs() */
> +#define LRU_REF_MAPPED         0x1U
> +#define LRU_REF_EXEC           0x2U
> +
> +#define LRU_REFS_REFERENCED    0x1
> +#define LRU_REFS_WORKINGSET    0x2
> +#define LRU_REFS_PROTECTED     0x3
> +
>  #ifndef __GENERATING_BOUNDS_H
>
>  #define LRU_GEN_MASK           ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOF=
F)
>  #define LRU_REFS_MASK          ((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PG=
OFF)
> -#define LRU_REFS_MAX           BIT(LRU_REFS_WIDTH)
> -
> -/*
> - * For folios accessed multiple times through file descriptors,
> - * lru_gen_inc_refs() sets additional bits of LRU_REFS_WIDTH in folio->f=
lags
> - * after PG_referenced, then PG_workingset after LRU_REFS_WIDTH. After a=
ll its
> - * bits are set, i.e., LRU_REFS_FLAGS|BIT(PG_workingset), a folio is laz=
ily
> - * promoted into the second oldest generation in the eviction path. And =
when
> - * folio_inc_gen() does that, it clears LRU_REFS_FLAGS so that
> - * lru_gen_inc_refs() can start over. Note that for this case, LRU_REFS_=
MASK is
> - * only valid when PG_referenced is set.
> - *
> - * For folios accessed multiple times through page tables, folio_update_=
gen()
> - * from a page table walk or lru_gen_set_refs() from a rmap walk sets
> - * PG_referenced after the accessed bit is cleared for the first time.
> - * Thereafter, those two paths set PG_workingset and promote folios to t=
he
> - * youngest generation. Like folio_inc_gen(), folio_update_gen() also cl=
ears
> - * PG_referenced. Note that for this case, LRU_REFS_MASK is not used.
> - *
> - * For both cases above, after PG_workingset is set on a folio, it remai=
ns until
> - * this folio is either reclaimed, or "deactivated" by lru_gen_clear_ref=
s(). It
> - * can be set again if lru_gen_test_recent() returns true upon a refault=
.
> - */
> -#define LRU_REFS_FLAGS         (LRU_REFS_MASK | BIT(PG_referenced))
> +#define LRU_REFS_FLAGS         (LRU_REFS_MASK | BIT(PG_referenced) | BIT=
(PG_workingset))
> +#define LRU_REFS_MAX           (BIT(LRU_REFS_WIDTH + 2) - 1)
>
>  struct lruvec;
>  struct page_vma_mapped_walk;
> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index 02b619eb6106..06a034713b5d 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -25,7 +25,7 @@ int main(void)
>         DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
>  #ifdef CONFIG_LRU_GEN
>         DEFINE(LRU_GEN_WIDTH, order_base_2(MAX_NR_GENS + 1));
> -       DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 2);
> +       DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 3);
>  #else
>         DEFINE(LRU_GEN_WIDTH, 0);
>         DEFINE(__LRU_REFS_WIDTH, 0);
> diff --git a/mm/folio.c b/mm/folio.c
> index 35e242b48870..e200efab814f 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -273,7 +273,6 @@ static void lru_activate(struct lruvec *lruvec, struc=
t folio *folio)
>         if (folio_test_active(folio) || folio_test_unevictable(folio))
>                 return;
>
> -
>         lruvec_del_folio(lruvec, folio);
>         folio_set_active(folio);
>         lruvec_add_folio(lruvec, folio);
> @@ -352,32 +351,6 @@ static void __lru_cache_activate_folio(struct folio =
*folio)
>
>  #ifdef CONFIG_LRU_GEN
>
> -static void lru_gen_inc_refs(struct folio *folio)
> -{
> -       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> -       int refs;
> -
> -       if (folio_test_unevictable(folio))
> -               return;
> -
> -       /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_lru_refs(folio)) {
> -               folio_set_lru_refs(folio, 1);
> -               return;
> -       }
> -
> -       do {
> -               new_flags =3D old_flags;
> -               refs =3D lru_get_refs_flags(old_flags);
> -               if (refs =3D=3D LRU_REFS_MAX) {
> -                       if (!folio_test_workingset(folio))
> -                               folio_set_workingset(folio);
> -                       return;
> -               }
> -               lru_set_refs_flags(&new_flags, refs + 1);
> -       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> -}
> -
>  static bool lru_gen_clear_refs(struct folio *folio)
>  {
>         int gen =3D folio_lru_gen(folio);
> @@ -388,7 +361,6 @@ static bool lru_gen_clear_refs(struct folio *folio)
>                 return true;
>
>         folio_set_lru_refs(folio, 0);
> -       folio_clear_workingset(folio);
>
>         rcu_read_lock();
>         seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> @@ -399,10 +371,6 @@ static bool lru_gen_clear_refs(struct folio *folio)
>
>  #else /* !CONFIG_LRU_GEN */
>
> -static void lru_gen_inc_refs(struct folio *folio)
> -{
> -}
> -
>  static bool lru_gen_clear_refs(struct folio *folio)
>  {
>         return false;
> @@ -428,7 +396,8 @@ void folio_mark_accessed(struct folio *folio)
>         if (folio_test_dropbehind(folio))
>                 return;
>         if (lru_gen_enabled()) {
> -               lru_gen_inc_refs(folio);
> +               if (!folio_test_unevictable(folio))
> +                       folio_inc_lru_refs(folio, 0);
>                 return;
>         }
>
> @@ -474,21 +443,6 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /*
> -        * For refaulted workingset folios, set PG_active so they
> -        * can be added to active generations.
> -        * For prefaulted file folios, folio_mark_accessed() sets
> -        * PG_referenced so lru_gen_folio_seq() places them into
> -        * the second oldest generation.
> -        */
> -       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -               if (folio_test_workingset(folio))
> -                       folio_set_active(folio);
> -               else if (!folio_test_referenced(folio))
> -                       folio_mark_accessed(folio);
> -       }
> -
>         folio_batch_add_and_move(folio, lru_add);
>  }
>  EXPORT_SYMBOL(folio_add_lru);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index cab3ba14d20c..d0f0e5a25d87 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -931,38 +931,186 @@ enum folio_references {
>  };
>
>  #ifdef CONFIG_LRU_GEN
> +/***********************************************************************=
*******
> + *                     Referenced count feedback
> + ***********************************************************************=
*******/
> +
>  /*
> - * Only used on a mapped folio in the eviction (rmap walk) path, where p=
romotion
> - * needs to be done by taking the folio off the LRU list and then adding=
 it back
> - * with PG_active set. In contrast, the aging (page table walk) path use=
s
> - * folio_update_gen().
> + * The folio_inc_lru_refs{_*} helpers below collect the referenced info
> + * (hotness) from other parts, including the page table walker, the rmap=
 walk
> + * upon eviction, the rmap lookaround, and file descriptors
> + * (folio_mark_accessed).
> + *
> + * Page table accesses use refs from either source. The first reference
> + * advances tail-gen folios by one generation; a second promotes to the
> + * newest. Executable file folios promote on their first access to avoid
> + * I/O thrashing. Isolated rmap accesses use evict_folios() for putback.
> + *
> + * Promotion changes folio->flags; sort_folio() or inc_min_seq() moves t=
he
> + * folio later. Young PTEs found during unmapping use folio_mark_accesse=
d()
> + * and follow the file descriptor rules below.
> + *
> + * File descriptor accesses do not promote.  They only defer eviction fr=
om
> + * the tail gens of their type, and only once the folio is a workingset
> + * folio (LRU_REFS_WORKINGSET), leaving the rest to PID protection.  Pag=
e
> + * table accesses are treated more generously because the accessed bit i=
s
> + * sticky (it under-counts repeated accesses) and because a page fault i=
s
> + * more costly than file descriptor I/O.
> + *
> + * PID protection operates on tier > 0 folios.  The one proactive promot=
ion
> + * outside of it and the page table path is the overflow case where the
> + * referenced count exceeds LRU_REFS_MAX, which means the folio is hotte=
r
> + * than everything else in its generation.
> + *
> + * Whenever a folio changes generation here its referenced count is capp=
ed at
> + * LRU_REFS_PROTECTED, so it starts at or below the protected tier regar=
dless
> + * of its old-generation access history.  PID protection (folio_inc_gen)=
 caps
> + * at LRU_REFS_WORKINGSET independently.
>   */
> -static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma=
_flags)
> -{
> -       /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
> -               /* Activate file-backed executable folios after first usa=
ge. */
> -               if (is_exec_file_folio(folio, vma_flags)) {
> -                       folio_set_workingset(folio);
> -                       folio_set_lru_refs(folio, 0);
> -                       return true;
> +
> +/*
> + * Update the folio's lru refs indicator. The caller doesn't need to hol=
d
> + * the folio lock, isolate the folio, or hold the lruvec lock. Used by b=
oth
> + * cache access (flags =3D=3D 0) and page table access (LRU_REF_MAPPED,
> + * optionally with LRU_REF_EXEC).
> + */
> +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> +{
> +       int max_gen;
> +       int type, refs, old_gen, gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec =3D NULL;
> +
> +       type =3D folio_is_file_lru(folio);
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags =3D old_flags;
> +               old_gen =3D lru_get_gen_flags(old_flags);
> +               refs =3D lru_get_refs_flags(old_flags) + 1;
> +               gen =3D old_gen;
> +               if (old_gen < 0)
> +                       goto out;
> +               /*
> +                * Lock the lruvec if the folio is on-list. We are alread=
y
> +                * doing lazy promotion so in theory we don't need this,
> +                * but for now, concurrent aging would still corrupt the
> +                * size counters.  This is a temporary limitation and
> +                * will be lifted very soon, so the lock here is not a
> +                * performance concern.
> +                */
> +               if (!lruvec) {
> +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(foli=
o));
> +                       lrugen =3D &lruvec->lrugen;
>                 }
> +               max_seq =3D READ_ONCE(lrugen->max_seq);
> +               max_gen =3D lru_gen_from_seq(max_seq);
> +               if (old_gen =3D=3D max_gen)
> +                       goto out;
>
> -               folio_set_lru_refs(folio, 1);
> -               return false;
> -       }
> +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> +                       /* Promote second page table access or executable=
 */
> +                       if (refs > LRU_REFS_REFERENCED || flags & LRU_REF=
_EXEC)
> +                               gen =3D max_gen;

This looks a bit odd to me. Could we handle LRU_REF_EXEC in a
separate branch instead of mixing it with refs > LRU_REFS_REFERENCED?

> +                       /* First access only defers eviction of a tail ge=
n */
> +                       else if (lru_gen_at_tail(lruvec, type, old_gen))
> +                               gen =3D (old_gen + 1) % MAX_NR_GENS;

The logic makes a lot of sense to me. It should be able to
differentiate readahead folios from those that are actually mapped
and likely to be accessed more than once.

If we allow two generations to remain, this could be a problem
because old_gen + 1 would overflow. Maybe add a
VM_WARN_ON() to guard against this case?


> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> +               } else if (refs > LRU_REFS_MAX) {
> +                       /* LRU refs counting overflow, bump the gen */
> +                       gen =3D (old_gen + 1) % MAX_NR_GENS;
> +                       refs =3D LRU_REFS_PROTECTED;
> +               } else if (lru_gen_at_tail(lruvec, type, old_gen) && refs=
 >=3D LRU_REFS_WORKINGSET) {

Sometimes you use >=3D LRU_REFS_WORKINGSET, while elsewhere
you use refs > LRU_REFS_REFERENCED. Can we unify these
checks or define a workingset variant?

> +                       /* Defer eviction of just accessed workingset */
> +                       gen =3D (old_gen + 1) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> +               }
> +out:
> +               refs =3D min(refs, LRU_REFS_MAX);
> +               lru_set_refs_flags(&new_flags, refs);
> +               if (gen !=3D old_gen)
> +                       lru_set_gen_flags(&new_flags, gen);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -       /* Promote on second access */
> -       if (folio_lru_refs(folio) > 1) {
> -               folio_set_workingset(folio);
> -               folio_set_lru_refs(folio, 0);
> -       } else {
> -               folio_mark_accessed(folio);
> -       }
> -       return true;
> +       if (gen !=3D old_gen)
> +               lru_gen_update_size(lruvec, folio, old_gen, gen);
> +       if (lruvec)
> +               lruvec_unlock_irq(lruvec);
> +}
> +
> +/*
> + * Update the folio's lru refs indicator during a page table walk or the
> + * look-around. max_seq can be stale as neither holds the LRU lock.
> + *
> + * Returns the old generation and stores the new generation in @new_gen =
if
> + * the folio is on the LRU and not in the newest generation, or -1 other=
wise.
> + */
> +static int folio_inc_lru_refs_walk(struct folio *folio, struct lruvec *l=
ruvec,
> +                                  const vma_flags_t *vma_flags,
> +                                  int *new_gen, int *type)
> +{
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +       int refs, gen, max_gen, ret;
> +       unsigned long max_seq;
> +
> +       do {
> +               max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> +               max_gen =3D lru_gen_from_seq(max_seq);
> +               gen =3D lru_get_gen_flags(old_flags);
> +               refs =3D lru_get_refs_flags(old_flags) + 1;
> +               *type =3D folio_flags_is_file_lru(&old_flags);
> +               new_flags =3D old_flags;
> +
> +               if (gen >=3D 0 && gen !=3D max_gen) {
> +                       ret =3D gen;
> +                       /* Promote second page table access or executable=
 */
> +                       if (refs > LRU_REFS_REFERENCED || is_exec_file_fo=
lio(folio, vma_flags))
> +                               *new_gen =3D max_gen;
> +                       /* First access only defers eviction of a tail ge=
n */
> +                       else if (lru_gen_at_tail(lruvec, *type, gen))
> +                               *new_gen =3D (gen + 1) % MAX_NR_GENS;
> +                       else
> +                               *new_gen =3D gen;
> +                       lru_set_gen_flags(&new_flags, *new_gen);
> +                       lru_set_refs_flags(&new_flags, min(refs, LRU_REFS=
_PROTECTED));
> +               } else {
> +                       ret =3D -1;
> +                       lru_set_refs_flags(&new_flags, min(refs, LRU_REFS=
_MAX));
> +               }
> +               if (new_flags =3D=3D old_flags)
> +                       break;
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +
> +       return ret;
> +}
> +
> +/*
> + * Update the lru refs indicator of an isolated folio, only used on
> + * mapped folios upon the final eviction.
> + *
> + * Increments the refs count (capped at LRU_REFS_PROTECTED, evict_folios=
()
> + * then caps it at LRU_REFS_WORKINGSET).  Returns true if the caller sho=
uld
> + * activate the folio (second access or executable), false to put it bac=
k
> + * for a second chance.
> + */
> +static bool folio_inc_lru_refs_isolated(struct folio *folio, const vma_f=
lags_t *vma_flags)
> +{
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +       int refs;
> +
> +       do {
> +               new_flags =3D old_flags;
> +               refs =3D lru_get_refs_flags(old_flags) + 1;
> +               lru_set_refs_flags(&new_flags, min(refs, LRU_REFS_PROTECT=
ED));

I'm having a hard time understanding why an activated folio
still keeps LRU_REFS_PROTECTED, since it will be promoted
to the active list anyway :-)

Later, I see that you set it to LRU_REFS_WORKINGSET in
evict_folios():

folio_set_lru_refs(folio, min(folio_lru_refs(folio), LRU_REFS_WORKINGSET));

So, is the purpose to distinguish between max_seq and
max_seq - 1 even when we know the folio will be placed
on the active list?

My concern is that after the folio is moved to the
appropriate generation, LRU_REFS_PROTECTED or
LRU_REFS_WORKINGSET may still remain set. Are these
flags cleared somewhere?


> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +
> +       /* Promote second page table access or executable */
> +       return refs > LRU_REFS_REFERENCED || is_exec_file_folio(folio, vm=
a_flags);
>  }
>  #else
> -static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma=
_flags)
> +static bool folio_inc_lru_refs_isolated(struct folio *folio, const vma_f=
lags_t *vma_flags)
>  {
>         return false;
>  }
> @@ -997,7 +1145,8 @@ static enum folio_references folio_check_references(=
struct folio *folio,
>                 if (!referenced_ptes)
>                         return FOLIOREF_RECLAIM;
>
> -               return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACT=
IVATE : FOLIOREF_KEEP;
> +               return folio_inc_lru_refs_isolated(folio, &vma_flags) ?
> +                      FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
>         }
>
>         referenced_folio =3D folio_test_clear_referenced(folio);

Thanks
Barry

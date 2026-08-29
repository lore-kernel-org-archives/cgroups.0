Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EE92EEE83
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 04:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787977328; cv=none; b=KYn3hvFLvfU7F267aJraeR/R5Kvx1RJ65lJ2gfjwoOvCgF5W4yNVCtO+injK7LCsxUEMwu45dnyhtHvCL2E0LmlJUZo33s4FVVugepVTpVohSe+agOuNOA9YSv1l2SomArTF9q7VRmb8O7tYhiXlBEoAvz5VXhDdo3PwrmGil+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787977328; c=relaxed/simple;
	bh=r4WYyzkkBE0mPXm48wvbwttD83o4g4knOqtalsEAxp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fQPHhV8NMXg5pDA9T/k3sQwPGzHLSG8Ebjw1mI1r/TPJjC8sy7V5YAFmFSCZX6vKAehmWxseW0cIIvE1yFPMPxRpRCX7XlqkTviQ7+s3LozPgmpqYWvSljd8vK1kRvKfST9xUei76ZSEUTGx/D7LC0BfLKx74zSZmZ4HzNic9C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/nXLGS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/nXLGS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBF41F01559
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 04:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787977326;
	bh=sUIdUAglUHvjQA5UstqimaCYpxUJXrO5+6o5g4iKAhY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A/nXLGS3XO7kCgDykLFF++paQhssBgcInwc44XOvJb07xqD5Ta4pvYkPNB1vKuhdR
	 BK7F09EHC9TSkHBk0Slt4RJVoLJklMVOUy1QIo94gVZsbOhCJA7lxYWDkNeHMbvlEh
	 8LMM70HCHRmPSC6iVeo7R2A7sjITO3XXK+4RgXyxuETvOPNpmkg/ig5GOKqWpAmydr
	 pgw+1CZvVanLQAznnYqjHO0X99OJgiIwphSwQu9m8AztStyGmyFyPNrKHlfGQRVdBm
	 mPxvt4eL2Z0MPggRYmVOlvJjDIWzo6ndACb7KSmUIYPXZliEzKmf86XEENLx0HXoiX
	 zV3+HT16B52sg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9384cb251fbso80342585a.2
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 21:22:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpK2WlRJzWLQkOghu7uQ9STtgSzkjstTUDMUxzmEcDA8Ji+KeJHsRUAiIAZNCrjgq4qKBtFR7P+@vger.kernel.org
X-Gm-Message-State: AFuF++kNwvN6XT+ipq9h7OJZW9DL2fEVBp8UdQnVeEwV2TRprOKFP6H2
	KMd7X+eAi3Nd45YgIJBF/Xm6mXmH2X2MCDTkmVVdsGsNJUXfayOgd6zlE7cf8edwRRfL9H7KSas
	n9IvpD0ECdlNcvJnPBIyerwUEIEd4XYo=
X-Received: by 2002:a05:620a:a0c8:10b0:938:fdde:34e6 with SMTP id
 af79cd13be357-939138cc83cmr1095067085a.28.1787977325593; Fri, 28 Aug 2026
 21:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 12:21:54 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
X-Gm-Features: AcwNN1VaDGpkXHfKukH9YIZjF_aPKgVmjSjw_MaStPGCt6H3-UaoYVrIk9ZAVQI
Message-ID: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
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
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
>
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.

Hi Kairui,

I like your idea. Overall, it looks good to me. With some cleanup,
we might have the following:

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 76 +++++++++++++++++++++++++++++++++++++++++=
+-----
>  include/linux/mmzone.h    |  1 +
>  mm/folio.c                | 19 +++++++-----
>  mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>  4 files changed, 114 insertions(+), 43 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..edfaf2661812 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool=
 workingset)
>         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>  }
>
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flag=
s.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +       gen -=3D 1;
> +       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);

Since `gen` is an `int`, it seems a bit odd to have
`gen !=3D -1 && gen >=3D MAX_NR_GENS` combined here.

Do you actually mean the following instead?

VM_WARN_ON_ONCE(gen < -1 || gen >=3D MAX_NR_GENS);

> +       return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio =
flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> +
> +       *flags &=3D ~LRU_GEN_MASK;
> +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> +}

It seems that we are setting the gen in the flags, rather than
setting the flags themselves.

The current name makes me think that the function is setting the
entire flags field, especially since `lru_gen` is used as the
namespace for various MGLRU functions, e.g.:

void lru_gen_add_mm(struct mm_struct *mm);
void lru_gen_del_mm(struct mm_struct *mm);
void lru_gen_migrate_mm(struct mm_struct *mm);
struct lru_gen_folio;
lru_gen_update_size(lruvec, folio, old_gen, new_gen);

However, this function only sets the gen bits in the flags.
Maybe we could use a name that makes this distinction clearer?

Could they be named as below, or is there a better naming option?

set_gen_to_flags(unsigned long *flags, int gen);
get_gen_from_flags(unsigned long flags);

Or something like flags_to_gen() or gen_from_flags()?

>
> +/**
> + * lru_refs_from_flags - Return LRU referenced / access count from folio=
 flags.
> + * @flags: folio flags
> + */
> +static inline int lru_refs_from_flags(unsigned long flags)
> +{
>         if (!(flags & BIT(PG_referenced)))
>                 return 0;
>         /*
> @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio=
 *folio)
>         return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>  }
>
> -static inline int folio_lru_gen(const struct folio *folio)
> +/**
> + * lru_refs_set_flags - Set the LRU referenced / access count to specifi=
ed folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, =
inclusive.
> + */
> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int=
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

Similar to the above, maybe we could use more descriptive names?

> +
> +static inline int folio_lru_refs(const struct folio *folio)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)=
));
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
> +               lru_refs_set_flags(&new_flags, refs);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +}
>
> -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;

[...]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 73a81b4a3e16..9ee9f8dc6805 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, c=
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

We have quite a few instances of folio_set_lru_refs(folio, 1) and
folio_set_lru_refs(folio, 0). Do these values have any special
meaning? Could we add wrapper helpers to make the code more readable?

`1` just means `PG_referenced`, right? Could we add a comment or
changelog description to clarify that `1` actually means `refs =3D 0`,
but `PG_referenced` is set?

Thanks
Barry

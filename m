Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA63939AD51
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260196; cv=none; b=JFlCMzpR9W/gze3Wwkn0zfrNMomr6GrFfEa0e2fUYMcNy/l1gXfXEtuRGcyx9ivfvFFJWlA4+YPKjjy9DcskX+AH9T+009O0WarQLSCli1Z7tFOHSuYQ/KIQC9UQSTVAJaoMlXA5Hhoy2tr8YFlcoMnl2lvxMDz9WzUz4vBaqEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260196; c=relaxed/simple;
	bh=xgJO17smNejyBIwcrwyDqoECJvhlsyuBONlAsXAmG8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hI6P0lgvLHjRcI69x+n3c8egrPby1N+bAySMCrJYnSyFlAa1ndK/VKf3HR0tx0hVXL5mDguK8kngTl1b2JBEzx6hTgOsYcI+dUIHTk7v78IPVD4OYhL9PTcDpuUilCwQVq5gZg2ybjloRJrUEIo81LJuMVIOwzGZuTfqFso9jZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjCLmWal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjCLmWal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A301F00ADF
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 10:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260191;
	bh=IrG48nudf8Db8eH9Q2rYlGxrD+mM6V+4qGZaDfjF11Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MjCLmWalYXlLWJxWXjbT6tB96cG5bH+PfZ0C2w/5CrWMRAV6oJbWAPkTXlMvGyQ7z
	 XDBMtzAIES0WhC8xRLIuLXN105B2KDNFGHy5ZJ4gmcMf5P+D3tq7fwHCM/WEvV4w/M
	 VaX6hHXwrrBuoXSpzzHNH77U4SbN8Id889Xet+lcoiaNplbrBnv8bIzdhh4+pvIUbL
	 hODxPbU3bKzdlb8r368n8BaKY0PdboqyNadv1BnWDJQqQdpR8F5UWUREjqJUaz3+rK
	 X4RGGbmJT7vDxz6+vDXhFv+vAI9UNTfLPiHFkc4wHd9bFE30ioGt4A94O3SKMxWKLl
	 E9e6RRbQ9Nxqg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93903d81a82so383647985a.2
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 03:56:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqi1JPU9B+nmfswtTz+lQ2d9jWu6YkB5DjjoeFov5ZSxTaWfOMlDrQBaONZPjnVNF8EcZFCahD6@vger.kernel.org
X-Gm-Message-State: AFuF++mWPkIgSAVCuHM6ZRJiu3zPbhuuFP2r4L7g7rA7x1P6JDaD/oem
	I5y0dQyddv4A8bbJxNhr4l51Xsa68LIQXxGSW+nvcrMIaB50eMpxGw5ecRu5oeUec9IJDsGieDc
	rbCRvjzlWy3hyo0Vof2bDlkA8WzNByxg=
X-Received: by 2002:a05:620a:a409:20b0:936:9f47:e908 with SMTP id
 af79cd13be357-9394805aa9fmr798556785a.19.1788260191171; Tue, 01 Sep 2026
 03:56:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com> <20260831-mglru-flags-cleanup-v4-6-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-6-2d15dde0d7ee@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 18:56:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y7MrUeHn4NvtpyyZ3EY-6dTUD4vhitw6Sy6tfRq6Tf9A@mail.gmail.com>
X-Gm-Features: AcwNN1XnJ-vUwtXvUynuDK4bSBGCxwvSia1E-LheZ-OirsmZyvEnKkM9ehQEeH8
Message-ID: <CAGsJ_4y7MrUeHn4NvtpyyZ3EY-6dTUD4vhitw6Sy6tfRq6Tf9A@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] mm/mglru: fix potential generation folio number leak
To: kasong@tencent.com
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
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 2:43=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Each generation of MGLRU accounts anon and file folio numbers
> separately, and the page table walker updates each generation's
> counters in batch once the walk is done. The walker promotes a
> folio's generation with a cmpxchg on folio->flags, and
> update_batch_size() then reads the live flags again to pick the
> anon/file column to charge. The walk holds neither the lruvec lock nor
> the folio lock, so the type can flip between the cmpxchg and that
> read: the lazyfree path clears PG_swapbacked, and reclaim sets it back
> on a dirty lazyfree folio. The batched delta pair is then recorded in
> the wrong type column. Nothing reconciles it afterwards, permanently
> skewing lrugen->nr_pages and the reclaim budgets derived from it.
>
> Fix it by capturing the type from the flags snapshot the cmpxchg
> linearized against: folio_update_gen() returns the type of the state
> it transitioned from, and update_batch_size() accounts with that.
>
> A folio's type only changes while it is off the LRU list, inside a
> del/add pair under the lruvec lock, with the gen bits cleared in
> between. The generation and PG_swapbacked sit in the same
> folio->flags word, so the cmpxchg snapshot captures them together.
> Let G be the generation that snapshot captured (old_gen) and G' the
> one it wrote (new_gen); the CAS can land in only three places:
>
>   - before the del: the folio is anon at G; the batch records anon
>     G -> G', and the del later removes the folio from the anon
>     counters;
>   - between del and add: gen =3D=3D -1, so folio_update_gen() returns -1
>     without touching the flags and no batch is recorded; the del/add
>     pair accounts for the move alone;
>   - after the add: the folio is file at the fresh generation the add
>     charged; the batch records file, that gen -> G', matching that
>     charge.
>
> Unlike the drift of lazy promotions, which sort_folio() repairs under
> the lruvec lock, the phantom deltas from before this fix land in a
> column the folio never occupies again, so nothing ever repairs them.
>
> Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  7 ++++++-
>  mm/vmscan.c               | 13 +++++++------
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 047295ae6e8a..7e487c23aff7 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -10,6 +10,11 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/leafops.h>
>
> +static inline int folio_flags_is_file_lru(const unsigned long *flags)
> +{
> +       return !test_bit(PG_swapbacked, flags);
> +}
> +
>  /**
>   * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
>   * @folio: The folio to test.
> @@ -27,7 +32,7 @@
>   */
>  static inline int folio_is_file_lru(const struct folio *folio)
>  {
> -       return !folio_test_swapbacked(folio);
> +       return folio_flags_is_file_lru(const_folio_flags(folio, 0));
>  }

I guess we don't need to change this function? It seems more natural to
me to keep using `!folio_test_swapbacked(folio)` here.

In `folio_update_gen()`, you already use
`*is_file =3D folio_flags_is_file_lru(&old_flags)` to get the type from
`old_flags`. I guess that's all we need?

>
>  static __always_inline void __update_lru_size(struct lruvec *lruvec,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 724b6e034e69..87e667c410ed 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, =
struct ctrl_pos *pv)
>   ***********************************************************************=
*******/
>
>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int new_gen, const vma_=
flags_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, int *is_fi=
le,

Rather than is_file, I feel was_file would be more accurate here,
since it doesn't represent what the folio is now.

> +                           const vma_flags_t *vma_flags)
>  {
>         unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
>         int old_gen;
> @@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio *folio, in=
t new_gen, const vma_flags_t
>                 new_flags |=3D BIT(PG_workingset);
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> +       *is_file =3D folio_flags_is_file_lru(&old_flags);
>         return old_gen;
>  }
>
> @@ -3328,9 +3330,8 @@ static int folio_inc_gen(struct lruvec *lruvec, str=
uct folio *folio)
>  }
>
>  static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio=
 *folio,
> -                             int old_gen, int new_gen)
> +                             int old_gen, int new_gen, int type)
>  {
> -       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>
> @@ -3519,7 +3520,7 @@ static bool suitable_to_scan(int total, int young)
>  static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_ar=
ea_struct *vma,
>                 struct lruvec *lruvec, struct folio *folio, bool dirty)
>  {
> -       int new_gen, old_gen;
> +       int new_gen, old_gen, file;
>
>         if (!folio)
>                 return;
> @@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm_wal=
k *walk, struct vm_area_struc
>                 folio_mark_dirty(folio);
>
>         if (walk) {
> -               old_gen =3D folio_update_gen(folio, new_gen, &vma->flags)=
;
> +               old_gen =3D folio_update_gen(folio, new_gen, &file, &vma-=
>flags);
>                 if (old_gen >=3D 0 && old_gen !=3D new_gen)
> -                       update_batch_size(walk, folio, old_gen, new_gen);
> +                       update_batch_size(walk, folio, old_gen, new_gen, =
file);

This is one more place where we rely on `LRU_GEN_ANON =3D 0` and
`LRU_GEN_FILE =3D 1`.

We do this kind of thing quite often in MGLRU, such as `type =3D !type`.
It relies on the numeric values of the type constants, which is sort of
a semantic abuse, but it's hard to find a shorter way to express it.

Best Regards
Barry

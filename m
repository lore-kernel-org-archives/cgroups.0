Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFA03F6C4F
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788417759; cv=none; b=sGLPUqh8ZucETlfLA4fHheYe0MRieH632b80lhXW+JnHuDz+thA6fvDq/cQQAJsdyyctKCbJXTrF96vHkEvLFNVftcbaEz/kHzjkYxK4ZH6VIikFgpzsaRpVrWnpeFD/snMIzcvWBl6nsmZuYvYX6X0YwRtW5hp73Paf/N+vi5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788417759; c=relaxed/simple;
	bh=lCLTsbc8doJehgprLLiB9xv9y/OGAJGue/VR8RpR0hU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+3mfM1+NaWooIJ/I5bfQWJOUqJsZ3uiTYltHlfQhTZwN/30GrPf4/qVJ1GiMY0QCHUdZxzEtjzxZFFwzoC7y1aRXQ8sg6nlo/p1dQuVWT9vDP9lUVaJFgz2Z0tewpHykPRofs+iKHv5N+e0SvrNgmsnrj2prHRVSXNqjDAIVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhbKpu4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhbKpu4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85701F0155D
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 06:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788417748;
	bh=NoreS1c67SI6AUlE45CnZ5o1zP8316Y/FnI+L8qchEI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NhbKpu4euU3J54kuBewdoHitvzC4s0XKkJbtFRar7UcMxbaZ7Gv7lBMvrP9w36xSw
	 2+8iojnoVDwxMeAUCOee93Mp8p1ONeExTpgtO8oFLQd96LjWAWbZ9lpmZqHzaT0Upd
	 ct1nRoEbswWioW6g6JRN2Pvs/vnUvVWAFi9Dt6l/QpSwO9TUMwrXv72SZwdCPvY2Oo
	 yfFYdVNNR4rvKO0cTOvavhsjC8NOIA8wNKksOuQdp8/6GrYxzo/NBnpk8wJVf6ewmA
	 mImhjfdQ1Lh9psq3Yphl5NJsOdXPzLPM9QVumnmXilSJ/vtpspNlPJe8LjfFACA91O
	 t69ZgAaWQXTOQ==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92ed3993c1eso127941085a.1
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 23:42:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy+ebcum4SQ+xZaIVhpCZvs6j5zFoFMxujyFJ6tknARrvKrspnZUvrWKCKCYw+lA+66SLqq6/p+@vger.kernel.org
X-Gm-Message-State: AFuF++lBYqGnNQ8oOn4itxj1byAgy8EEIvvNAMU/cPI1Uzym7iveF/TO
	JXM8u3khT/jpvyvp/CAH3O62IwJTEJhNENVusGFxcmYnMBsYfGQRT4zOhyH7wVozo9H6V9tkfh6
	rbTDr8zRdpSeOqqT2lvWuGFGIsPLs/L8=
X-Received: by 2002:a05:620a:a20e:b0:939:3b56:c416 with SMTP id
 af79cd13be357-93960ca35cfmr1181035685a.8.1788417748183; Wed, 02 Sep 2026
 23:42:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com> <20260902-mglru-flags-cleanup-v5-6-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-6-9db761d779ef@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 14:42:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yqwfMJCaonibg4Bc9AosthroQBwM272eg+Qx3oa89PMA@mail.gmail.com>
X-Gm-Features: AcwNN1VD2akl2VUX8YhUPLeb6jEb8u2mnb-VNQovUDSfTJ95mvMn_WCutxEh8is
Message-ID: <CAGsJ_4yqwfMJCaonibg4Bc9AosthroQBwM272eg+Qx3oa89PMA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] mm/mglru: fix potential generation folio number leak
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

On Wed, Sep 2, 2026 at 5:51=E2=80=AFPM Kairui Song via B4 Relay
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
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

[...]

>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int new_gen, const vma_=
flags_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, int *type,
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
> +       *type =3D folio_flags_is_file_lru(&old_flags);

Though it is a bit ugly that an `is_file` value can be assigned to
a `type`, it is not your fault. We've been doing this throughout
MGLRU. Technically, it should be:

if (folio_flags_is_file_lru(&old_flags))
   *type =3D LRU_GEN_FILE;
else
  *type =3D LRU_GEN_ANON;

But that would be too long, so I'm fine with the current code :-)

Best Regards
Barry

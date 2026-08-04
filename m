Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D65D305660
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 03:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785812882; cv=pass; b=igZG7/H4vJaGXfGD7bTxT6eKFBAYN9Wu3XcaMmEYW2pHOrHGz+itxxmPEAfN+dYrk+tLzLGaw8V2nPauLoQ5KmaoAM8xVvzs9mtgXDC88uieHDuxLRq+30eVsuiKjrWzoi3C6Inix6nCLwk0w1rK97zqmdlBoxroPIs6aQDmNq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785812882; c=relaxed/simple;
	bh=iOvqHMljlhWowdpVhg0gR/Tofw/n2P1wPA3o9hgQSdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d1bNhH7RgPf7qerqDfL9rFNOeFYVjsAvk075Av30aih6wA7BnV67DEsw6TA6XZuHqRiV3ZJTOa3+Ocx6IPdkYQyC0CyZolTjeayK4Zwkk2a1xlzuXh/pbcnCxpSTJyLNFfiL09Mei1skVGs7u38KYp6f+XDHWC0oYnARL3N9apQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OG5HO3xu; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OG5HO3xu"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so473899166b.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 20:08:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785812878; cv=none;
        d=google.com; s=arc-20260327;
        b=SSa22QILTJ/vD0VL8DG1O5SWmJhEuEkIvZ+j42uwJGOd8uVQErKYL+OL6wg6hn1eLC
         XkZVRq54/j1yy8Lkf/X0u8C7k9iFBG3gcT9tecnOyhZ1j1Rtclt1RtEDcT15ss9oaT82
         GB4n/a/P8dY3bcs+r5aCNeptH6bSBS4CCnMDzOVmfcGYcAKDAdHuTHhF9YiYha7ZgQ8W
         2b3f9F111o503ufIlhhLloV6gWlo3BsMpQpnvPToat2M0tATeOW/+Vo55hvWzQ+1bwJY
         EBEBIsDXeNM4t8sQbAhKBxVMW9Mini9nbgiA5Nx3wHsHwiZFSXVQ8IgDHMDtHNYVUqMV
         cL9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
        fh=SC9qHKB0YujnjZOhK5Wh9LbXhVjyAtna/t6vDPVKyuE=;
        b=mWNOAAWmucQOJj2XXidPP92XSV4+alyUIiuArP3ZU0An8sVmp7BJhEYmwR14byY4ro
         i4s3Ov9ZyEs4bWjTEvPKT6SOn6bBxeSApvY3QQacFg7KqFZNvZj8o8sjG6hPQuDVYJHd
         GPCxzXKHm2ZSnMDgNjD7OzDVjClB/DAEIwP07wp8OgyBUJyB6kL8Vz0NQOJbPpjWuXFb
         H5AxvXC+ZUXgLTLPBkuM7ELLdHyhBSKldjH0av1zktuUr/DmQa+edVMa0X9/No6UdGkQ
         ZO4wz89XLOXam1qtuPuoPFK2NHh8L4h3svmWywBmGsOSOXnLtZe8ggANHWYzLPyqqyVm
         VJ6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785812878; x=1786417678; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
        b=OG5HO3xuW0L5gG+rVzhCZCRo4mszYOFi1MN5sTcsfGdkovBb5p5kRJgGickUKZCRPG
         b68I+kb+js2415LbPkUTcqS2iS4H0xIjH7DhZV7jA6YVhxmmmGvMcFSVNHAASt4Wuj/S
         Hp2kZtUDz/8N40Hz7BH+b9xvB70NUH+tJkA/94iIECL9+uf1J+nzEHbAe+fe4tT1jpK9
         zkB+aPt/fjdG6NFG9hS+0P6HtlZJVOWzYdU/z9LtzIsAafK7tVgxAHRk1ndiNffCr9Tu
         /Df0Aq0ijOEW+LspYS2ixxp/vmD7AuHEJUDt/OqNIPLHFmt7ZC18d8J+3JszjhM2+Pds
         ZtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785812878; x=1786417678;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
        b=D7eHED8OEYRYs+jG58yTV22rerdsZHVET04gIyNsPz33WGGAQrzAYaCaDC1AHH8jYd
         /wxEBDYeKWFjOW4ypRWpjXI+h1Ggb7sfxYLu8x+3cosQ/dZMKlmtzSImkR2JP1LTUDSY
         //UnFAs1jiGijNoexOEGgvU/wRuTXSD0TAupYWZB0r9vnXzcsDxRZRt25nE4ptONPHgS
         /eyj5UYq4/um9Y7WFNA46A9ZBePGyDSlU9U23eegQTngAgwyDCGVaYQMA6x7dil7AHpn
         E7JNGZSG2sI+4Bpn1iVmEdOmhU5mwkKoIVuOMYhRIM8LyJkK8U7159bTgMrMJJa8dW1v
         Xu0g==
X-Forwarded-Encrypted: i=1; AHgh+RpCECJvuA+FSYbLXdZouxvaG1ILDFA7UFZBqzfEkkXATzidJC10qZWb+iXxJTODlXyn1ruJyv62@vger.kernel.org
X-Gm-Message-State: AOJu0Yx49VsZhtZd7ZTe3+kTcI6p/GwvCuwsjiRt/ieFzywIAVwIN/Pa
	UIqMR2JmL3zQFdMt7w7vGvqez9W4nXXsJSL3XN0+9iGBONk81DpyhnQRmyLsQT4xmY78Mqv9ETs
	N5sFD2xtryccr12UaIBZbGo1vHV0+Fds=
X-Gm-Gg: AR+sD13yitc78r3duOfExTdxGGB4iF56lYLsSmpWMAnm9DEtWx6PnhMa6+8XIVO1p3Q
	RkhTPi64nmBzRECOHILB/hcneGxAy3eYlA39tcd4uFzeB9GkNpY6nvXjU0Hn+6vzzYCI4bx9eh1
	uBRdzLJjspmXNvFw39nLH9wvK1QcdZOi5sqybH+uw2DFQ388n1Gu0mShfVlpgDwSe4AfG0x0bCh
	0IVSuNBFzhij0WCK1MfU0I6iZTueOJRo3ug1Ju3n9HbF89+80PyItUPBYAKMLmB6KmbOlDYA0fF
	HEopj447XdYLIAw/g88hK0aw6iK/OqnEm7MCWbmQEiHbne4TfzhY9KTk3sIkhocTG3iZgJ1bcTr
	O1g==
X-Received: by 2002:a17:907:d09:b0:c20:2b23:71cc with SMTP id
 a640c23a62f3a-c202b2372e7mr41676866b.10.1785812878197; Mon, 03 Aug 2026
 20:07:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 11:07:20 +0800
X-Gm-Features: AUfX_mxLDAxbcZrL7EYWPUhuMXrQt62cceqHcQR2T0bfe55TgV-_Dmxaq3nq83I
Message-ID: <CAMgjq7A0FvEDfm_04EzOhK4XHMeKmSW82x8+zeyD6OO9DLJe7g@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
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
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
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
> (refs), refs still mappes to a logarithmic tier just like before, but wit=
h
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> promoted proactively instead of wait for the PID controller to kick in.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> these 2 flags are purely used as the lower 2 bit of refs for MGLRU. This
> doesn't effect classical LRU in any way. This will actually simplify and
> make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> original tier / referenced count bit by one since only one extra bit is
> now needed to record a max referenced count of 7 (previously 2 extra bits
> are needed). This changes make sense because MGLRU doesn't have demotion
> so these 2 flags are never separately useful for MGLRU.
>
> This addresses several shortcomings of the old model:
>
> - Long feedback loop: protection only activated after enough
>   re-faults, by which time the folio is often no longer hot.
>
> - Limited tier resolution: once referenced count exceeded the bits
>   limit (8 previously), MGLRU could no longer distinguish hotter folios a=
s
>   they are capped by the tier.  And what's worse, PG_workingset
>   forces a folio to stay on tier 3.
>
> - Eviction-time bias: because PID protection activates upon eviction
>   and always targets the LRU tail, it tends to protect cold tail
>   folios at the expense of hotter head folios.  Once the tail folios
>   consume the PID protection budget, head folios lose their
>   protection.  Additionally, the PID cannot distinguish the access
>   time of folios that share the same reference count.
>
> Besides reworking the LRU_REFS related helpers and definitions, most of
> the work is done by the helpers below; the implementation details are
> described in their inline comments.
>
> - folio_inc_lru_refs(): Used by both cache access (folio_mark_accessed)
>   and page table access.  The folio could be off-list (isolated),
>   unlocked, or unmapped.  This helper uses PG_lru to stabilize the
>   folio and performs a speculative and lazy promotion.
>
> - folio_inc_lru_refs_walk(): Used by the PTE walk path during aging,
>   where generations are stable; performs lazy promotion.
>
> - folio_inc_lru_refs_isolated(): Used by the rmap check before
>   eviction.  The folio is isolated and hence this doesn't perform
>   promotion by itself; the folio will be added back to the right gen
>   upon return.
>
> The eviction-time folio_inc_gen() still handles PID protection, but the
> protection ratio is softer than before, and it caps refs at WORKINGSET
> so the folio retains enough history to stay above the cold tier.
>
> The PID controller gain factors in get_tier_idx() are also relaxed from
> (2:3) to (1:2).  Since the new folio gen bump paths already proactively
> protect hot folios, PID protection can afford to be more permissive
> without increasing the refault rate.
>
> PG_workingset and PG_referenced are repurposed as the low two bits
> of the unified LRU reference count.  LRU_REFS_MASK provides the
> higher bits.  This eliminates the old restriction where LRU_REFS_MASK
> was only valid when PG_referenced was set, and allows all paths to use
> the same encoding consistently.
>
> Hence, a workingset folio is now defined as refs >=3D LRU_REFS_WORKINGSET
> (2), matching the active/inactive LRU's definition and giving in-kernel
> consumers (PSI, readahead) consistent behavior on MGLRU, which will be
> done in later commits.
>
> Note that PG_workingset and PG_referenced are no longer independent
> flags under MGLRU.  Adjusting existing raw folio_test_*() callers
> to the new semantics is left as follow-ups.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  83 ++++++++-----
>  include/linux/mmzone.h    | 135 ++++++++++++++-------
>  kernel/bounds.c           |   2 +-
>  mm/folio.c                |  46 +-------
>  mm/vmscan.c               | 290 ++++++++++++++++++++++++++++++----------=
------
>  mm/workingset.c           |  55 ++++++---
>  6 files changed, 385 insertions(+), 226 deletions(-)
>


> +/*
> + * Update the folio's lru refs indicator without taking the folio lock,
> + * isolation, or lruvec lock. Used by both page table access (@is_fault=
=3Dtrue)
> + * and by file access (@is_fault=3Dfalse).
> + */
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{
> +       int max_gen, min_gen;
> +       int type, refs, gen, new_gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec;
> +
> +       type =3D folio_is_file_lru(folio);
> +       lruvec =3D folio_lruvec_live_get(folio);
> +       lrugen =3D &lruvec->lrugen;
> +
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags =3D old_flags;
> +               gen =3D lru_gen_from_flags(old_flags);
> +               refs =3D lru_refs_from_flags(old_flags) + 1;
> +               new_gen =3D gen;
> +               if (!(old_flags & BIT(PG_lru)) || gen < 0)
> +                       goto out;
> +
> +               max_seq =3D READ_ONCE(lrugen->max_seq);
> +               max_gen =3D lru_gen_from_seq(max_seq);
> +               min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[ty=
pe]));
> +               if (gen =3D=3D max_gen)
> +                       goto out;
> +
> +               if (is_fault || is_exec) {
> +                       /* Promote second page table access or executable=
 */
> +                       if (refs > LRU_REFS_REFERENCED || is_exec)
> +                               new_gen =3D max_gen;
> +                       else
> +                               new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> +               } else if (refs > LRU_REFS_MAX) {
> +                       /* LRU refs counting overflow, bump the gen */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D LRU_REFS_PROTECTED;
> +               } else if (gen =3D=3D min_gen && refs >=3D LRU_REFS_WORKI=
NGSET) {
> +                       /* Defer eviction of just accessed workingset */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
>                 }
> +out:
> +               refs =3D min(refs, LRU_REFS_MAX);
> +               lru_refs_set_flags(&new_flags, refs);
> +               if (new_gen >=3D 0)
> +                       lru_gen_set_flags(&new_flags, new_gen);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -               folio_set_lru_refs(folio, 1);
> -               return false;
> +       if (new_gen !=3D gen) {
> +               /*
> +                * Gen can only go forward, so concurrent aging is
> +                * usually fine, except when multiple aging increase
> +                * max_seq multiple times, new_gen may have go beyond
> +                * the new max_seq's current gen border and causes
> +                * hotness inversion. In that very unlikely case,
> +                * just activate the folio.
> +                */
> +               lru_gen_update_size(lruvec, folio, gen, new_gen);
> +               if (unlikely(READ_ONCE(lrugen->max_seq) - max_seq > MIN_N=
R_GENS))
> +                       folio_activate(folio);
>         }

So sashiko complained about a potential race here, which I suspected
but let through for this RFC:

lru_gen_update_size is lockless here, so if the folio is move between
active and inactive gen and a concurrent aging occurs, we might lost a
active / inactive counter update and drift the reading. The chance is
tiny and active/inactive counts are just metrics reading for MGLRU so
this should have no effect on performance.

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
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
> (refs), refs still mappes to a logarithmic tier just like before, but wit=
h
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> promoted proactively instead of wait for the PID controller to kick in.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> these 2 flags are purely used as the lower 2 bit of refs for MGLRU. This
> doesn't effect classical LRU in any way. This will actually simplify and
> make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> original tier / referenced count bit by one since only one extra bit is
> now needed to record a max referenced count of 7 (previously 2 extra bits
> are needed). This changes make sense because MGLRU doesn't have demotion
> so these 2 flags are never separately useful for MGLRU.
>
> This addresses several shortcomings of the old model:
>
> - Long feedback loop: protection only activated after enough
>   re-faults, by which time the folio is often no longer hot.
>
> - Limited tier resolution: once referenced count exceeded the bits
>   limit (8 previously), MGLRU could no longer distinguish hotter folios a=
s
>   they are capped by the tier.  And what's worse, PG_workingset
>   forces a folio to stay on tier 3.
>
> - Eviction-time bias: because PID protection activates upon eviction
>   and always targets the LRU tail, it tends to protect cold tail
>   folios at the expense of hotter head folios.  Once the tail folios
>   consume the PID protection budget, head folios lose their
>   protection.  Additionally, the PID cannot distinguish the access
>   time of folios that share the same reference count.
>
> Besides reworking the LRU_REFS related helpers and definitions, most of
> the work is done by the helpers below; the implementation details are
> described in their inline comments.
>
> - folio_inc_lru_refs(): Used by both cache access (folio_mark_accessed)
>   and page table access.  The folio could be off-list (isolated),
>   unlocked, or unmapped.  This helper uses PG_lru to stabilize the
>   folio and performs a speculative and lazy promotion.
>
> - folio_inc_lru_refs_walk(): Used by the PTE walk path during aging,
>   where generations are stable; performs lazy promotion.
>
> - folio_inc_lru_refs_isolated(): Used by the rmap check before
>   eviction.  The folio is isolated and hence this doesn't perform
>   promotion by itself; the folio will be added back to the right gen
>   upon return.
>
> The eviction-time folio_inc_gen() still handles PID protection, but the
> protection ratio is softer than before, and it caps refs at WORKINGSET
> so the folio retains enough history to stay above the cold tier.
>
> The PID controller gain factors in get_tier_idx() are also relaxed from
> (2:3) to (1:2).  Since the new folio gen bump paths already proactively
> protect hot folios, PID protection can afford to be more permissive
> without increasing the refault rate.
>
> PG_workingset and PG_referenced are repurposed as the low two bits
> of the unified LRU reference count.  LRU_REFS_MASK provides the
> higher bits.  This eliminates the old restriction where LRU_REFS_MASK
> was only valid when PG_referenced was set, and allows all paths to use
> the same encoding consistently.
>
> Hence, a workingset folio is now defined as refs >=3D LRU_REFS_WORKINGSET
> (2), matching the active/inactive LRU's definition and giving in-kernel
> consumers (PSI, readahead) consistent behavior on MGLRU, which will be
> done in later commits.
>
> Note that PG_workingset and PG_referenced are no longer independent
> flags under MGLRU.  Adjusting existing raw folio_test_*() callers
> to the new semantics is left as follow-ups.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  83 ++++++++-----
>  include/linux/mmzone.h    | 135 ++++++++++++++-------
>  kernel/bounds.c           |   2 +-
>  mm/folio.c                |  46 +-------
>  mm/vmscan.c               | 290 ++++++++++++++++++++++++++++++----------=
------
>  mm/workingset.c           |  55 ++++++---
>  6 files changed, 385 insertions(+), 226 deletions(-)
>


> +/*
> + * Update the folio's lru refs indicator without taking the folio lock,
> + * isolation, or lruvec lock. Used by both page table access (@is_fault=
=3Dtrue)
> + * and by file access (@is_fault=3Dfalse).
> + */
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{
> +       int max_gen, min_gen;
> +       int type, refs, gen, new_gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec;
> +
> +       type =3D folio_is_file_lru(folio);
> +       lruvec =3D folio_lruvec_live_get(folio);
> +       lrugen =3D &lruvec->lrugen;
> +
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags =3D old_flags;
> +               gen =3D lru_gen_from_flags(old_flags);
> +               refs =3D lru_refs_from_flags(old_flags) + 1;
> +               new_gen =3D gen;
> +               if (!(old_flags & BIT(PG_lru)) || gen < 0)
> +                       goto out;
> +
> +               max_seq =3D READ_ONCE(lrugen->max_seq);
> +               max_gen =3D lru_gen_from_seq(max_seq);
> +               min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[ty=
pe]));
> +               if (gen =3D=3D max_gen)
> +                       goto out;
> +
> +               if (is_fault || is_exec) {
> +                       /* Promote second page table access or executable=
 */
> +                       if (refs > LRU_REFS_REFERENCED || is_exec)
> +                               new_gen =3D max_gen;
> +                       else
> +                               new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> +               } else if (refs > LRU_REFS_MAX) {
> +                       /* LRU refs counting overflow, bump the gen */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D LRU_REFS_PROTECTED;
> +               } else if (gen =3D=3D min_gen && refs >=3D LRU_REFS_WORKI=
NGSET) {
> +                       /* Defer eviction of just accessed workingset */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
>                 }
> +out:
> +               refs =3D min(refs, LRU_REFS_MAX);
> +               lru_refs_set_flags(&new_flags, refs);
> +               if (new_gen >=3D 0)
> +                       lru_gen_set_flags(&new_flags, new_gen);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -               folio_set_lru_refs(folio, 1);
> -               return false;
> +       if (new_gen !=3D gen) {
> +               /*
> +                * Gen can only go forward, so concurrent aging is
> +                * usually fine, except when multiple aging increase
> +                * max_seq multiple times, new_gen may have go beyond
> +                * the new max_seq's current gen border and causes
> +                * hotness inversion. In that very unlikely case,
> +                * just activate the folio.
> +                */
> +               lru_gen_update_size(lruvec, folio, gen, new_gen);
> +               if (unlikely(READ_ONCE(lrugen->max_seq) - max_seq > MIN_N=
R_GENS))
> +                       folio_activate(folio);
>         }

So sashiko complained about a potential race here, which I suspected
but let through for this RFC:

lru_gen_update_size is lockless here, so if the folio is move between
active and inactive gen and a concurrent aging occurs, we might lost a
active / inactive counter update and drift the reading. The chance is
tiny and active/inactive counts are just metrics reading for MGLRU so
this should have no effect on performance.

I'll need to figure out a way to fix this, hopefully without any lock
because this is a hot path where overheads are critical.

One idea is that we directly jump to the part where we decouple the
active/inactive counter with MGLRU's gens (I mentiones this before
just didn't post any code about it yet)? If you use MGLRU in a fleet
you should already have noticed that the active / inactive reading is
almost unusable, because MGLRU's aging moves folios in whole
generations. Because the active/inactive count is bounded by
generations, you will see the numbers are very "jumpy," and almost all
page cache is always reported as inactive since the PID can only
promote the page cache to the second oldest generation, which is
considered "inactive." This is incorrect and breaks things like
cAdvisor in K8s, which uses the inactive reading to determine how much
of the page cache is actually used.

So instead, if we bound active / inactive with tiers instead of gens,
all the issues are gone. I planned to do that later, but if everyone
is OK with it, we can do this earlier.

Or else, some fancy atomic / barrier might be needed, I think that's
still doable though but kind of complex and maybe ugly.

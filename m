Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795163761;
	b=O0aWuMCxWxUCZqdyobwyIS6KYAEk2QGr64Bq7/HXDVbYNrvG/c++wk4rKQk5/IpXW/DU
	 lahaj+Y/qxi+12StroNgKeoXYkY++zS9YsmJ23S5GsmIq1huYXnC8KnZ3e8pzb3IKY405
	 1cbHg+aLJPvLrQSgrBGLAWkCBsa3aFRdK61SnDoM75AXfBzgqNXuO3PYy/YPmuQuuHzuz
	 rwJdXDW/g2eDjKTQXtQSif2JWhCNxpww87tl210AA1RNomeH3oNH9J1oqWiz5RK74UuqC
	 MtCoK6SWr3vHK3Kq95y28SxbAd3wtfzMOGuZc+N2hd8jPXBexFKe3LgG81c7yNYiWJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163761;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
	b=FwgbXzO0B+e+gbODVXqQoT+oyen2a4cIKUB/6fWtUqCUP5wWOG8e9rs0YkQIbQuwP0QN
	 JwBc4cZIZkrmba3Yw0Jl5haXaJpsoiIJrLWUcaf42bsC0dlWcxjTpHD8BIrOW/1dvp37k
	 MNhklxkRzVwSg4BwZdHgzZrEXRpCmBoVmuEsYjfF2lD5Nu4C/hvg2oOzGPxiHWnCdkbw0
	 B+SdUfhoBQJQEZo0bsoXojY+dBJJWFGvzp3rB1kOUo6MzXLO5AIp3Bs1Ux98qcjEFs4Zd
	 9AU65y3itk4/IJk+OhE/ogY/IdyU2I6KojirUfFqTuYlnlf8MYed+fIFnwnYply0OVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HnIvXDKy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE87606A320
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAE87606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HnIvXDKy
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so922883a12.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:36:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795163759; cv=none;
        d=google.com; s=arc-20260327;
        b=Ip6Kn9spUeXmYtb9otleKufgBqRy1ME3iVQlC+iwTy5JX+/g5A3iBgQk5mBKOgdp7I
         9j6Ma+98V0HALQnDmofeeCqrwlKmupd6Ufrluua36QsY9dkwachbn2Y9tJXa5cd4ULiX
         Ecbpq09nF71wkgJ+dmQ2SBQbBkNmU8pKEx/7uY/IlpnpcKi8NK1zJCqTXp7yvOvzixEi
         wCBajG4yivpZ41pjupffpJXfyr2uqvirkAPeWimrlMoGHvAXe63kYHPhGkMrq/sNFCNL
         8wbVjNSFGrOQSJeI77Nzk0ReHWTpTsYP/KRWhPZ0tlT5aMartKMWviBo1z/GXyWzDZeD
         Aoyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
        fh=c3xDrRILhtCpEASvoBbEMDmRKzbMWpagCjZgAPNTlsc=;
        b=pxcggHwyASystLMm1GOuAVSt3h7elY1eFeVyA3T/ifE/FfG3sqS4LkjXUiFJjTPrt4
         kKe8sJMBp29XRNmnaAHWHzHHLctn2ay9IESfbPK2r0ljj8C+69oIlBL6fT27avlH1Xpp
         ll1v0lGdKMTYdD5ORCaM+yJToC55MvVV038Y5zgVLFEmIh1L4qR8YFJy+IG9ZqIVtctj
         q7Alct0TVBQ0D+avvPFqwAFpEqJG78uYSd2s8RWuYZxKu+jm2cnBvrhIS7qsPw27Z4OV
         BkmMiIl6DMyIAVSzvPwPHRt7Tg0qvEDNeiMJDoXSv8yYt6wjz7DFMhvmrOPe/qNKREWL
         NYRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795163759; x=1795768559; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
        b=HnIvXDKyzH4JiePmNccI5gCzaP0sZv16UqMoTav9WMqv1SSDqPACZ7kJfHNCoD5ear
         jK7cJN7E42L5M4IrQDHprzQZ393zAttFTXlCdoBuUnzCBKj50B4+u75KBIkmEhdC4YFE
         4OyC0lk7Z16Bfg5PodWjYD8mZ+xUTRHfmVWZt37I/y8fRu1EQSfUWi11K9gyHnchHtrJ
         7XhMWozeO8QeG10mLJblq1tgQz9Wa/zJolBY4rdI2lZ/ZZ8wZRjwS+fY8F5UY4mCEeb3
         0sDk6t/6942QJJCdKopHs0KBmRiGQrs0j28UPiLPzFb3tfykx0Ht/4lWb9Hbvg39ylrW
         0COQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163759; x=1795768559;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DSuUtXGnjpMqHENNRIfD4nz00o+v1iSCypFww/wg4kA=;
        b=SDk4Y/tc5NrtMQcq8Ei8TRrOVuWFbKvK9FnaOYzV+74e7ooMmsojzhFQDoaL4X24AJ
         J56ZmMgC00Dlg+ME0Bvjppe8pgLEM74hSne9nLPl0knoptIMwDncrt74torG2AYY1IRl
         bCtTV1I94UFpuoCh68xCUsNCBHTzqKd0weMsQjXXE8S7U7dMm7KPcq4mOCfXYu8eVB6+
         U5eCh9F1ivR74W7OL+EdZQCmqsGwr72rF2NeTFxpXqZZsGn8Lvvq60DCzMiDNvkGZxTF
         cIj05/OyM4kePVLrCHaLUJkxAHAdjw8v3iZOzT3TU7h3v4LnQJoZJZVy2qrzwfikuvOy
         7zaA==
X-Forwarded-Encrypted: i=1; AL+hErFK79FHFfnkO4rJ5yE85l3D1yQK6GmwJl49x33on16Iq8WeOr48WgbgRcIW5nz0wrAq8lTz/1WG@vger.kernel.org
X-Gm-Message-State: APuU4Z8W0Hcje9+I8VNr6IsQ7gwq1hae/Zc/mWGhOOTnhbvSb7Taw29k
	zly3mUYDgbXcuF9Blifuji3bdOYLVhtSJlBsXvaGup0DB1vvjpQm3pxO1KYB0vF7QWA7pFF1jAw
	4ybt3peNI7LdS7OP60WJ7BHERlHNXDnE=
X-Gm-Gg: AZFdTZfBkm21Qf5izjGl1/cuG8tZsN7kcYDUqubkKGpxP5DLBs0i1fb6adIU9h8QtCh
	sRq8xwqZNu69y5iK1BN3DdxIfPK1DSAxjI7P1uXk0MNp2ZQHyan0mp73npiiZeTrLm1fc4XYCVj
	a9Dry9aa7uKzh1SeIGLeJpGKMo5+rjUdLssUaMfBFWcNwnAPfM/2Jmppt+OqfR3ONi8NOqN1KaA
	t0vVT/GmxqWh5VEnKfNmPi3kJZfL7vif7cM5sQphy/wIYmQUA/qg0lniIKegFlOSPcFWd991BBC
	NZ6miOz9EVg6S3BDAGVFoOPUdHEtBeaYq/xub5GDTwSqLe7dWYL1yMjJGXaBCjZsWlTX/vQ3L+l
	C4R7v9f3dJTdYtpw+KLSowoLs14qJYwYxr66MyTp7gX/sN8CGyqpVj8zEUXUjGAUz5Q==
X-Received: by 2002:a05:6402:454d:b0:6b6:fec8:d0a8 with SMTP id
 4fb4d7f45d1cf-6ba37ece7b4mr1180315a12.43.1795163758738; Fri, 20 Nov 2026
 00:35:58 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-13-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-13-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:35:45 +0800
X-Gm-Features: AclHuK-_GFG5PkAWFBgYarA_ZH8s5VuYTvaSRhCd3qxcRhatbnu155-OV8JZlEE
Message-ID: <CAN_Opa9WKYNXyuJDixgbCzW-yWYXuoBTujSA_SWeQLzQzp_26w@mail.gmail.com>
Subject: Re: [PATCH v5 13/17] mm/madvise: adapt for LRU refs based operations
 for MGLRU
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> For the active/inactive LRU, madvise clears PG_referenced so that one mor=
e
> access is not enough to reactivate a folio, and keeps PG_workingset on a
> folio demoted out of the active list so its refault is still accounted as
> a workingset refault (PSI).
>
> MGLRU keeps that history in the folio's refs count instead, which now
> lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
> those bits directly corrupts the count. The two hints want different
> things:
>
> - MADV_COLD resets the count in folio_deactivate(), which also requests
>   deactivation.
> - MADV_PAGEOUT clears non-workingset refs and caps the rest at
>   LRU_REFS_WORKINGSET after isolation, before handing the folio to
>   reclaim_pages(). The hint marks the folio as cold, so the
>   eviction shadow records the capped count and does not inflate the
>   eviction/refault counters of the hot tiers that drive aging, while
>   folios at or above the workingset threshold keep their PSI
>   classification.
>
> PG_young is cleared for both LRUs as before, so the referenced walk does
> not count stale history as a recent access.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/madvise.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 40 insertions(+), 14 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 2d54cb9863ea..7486c492f437 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batch(unsigned l=
ong addr, unsigned long end,
>                                      FPB_MERGE_YOUNG_DIRTY);
>  }
>
> +static void madvise_cold_prep_folio(struct folio *folio)
> +{
> +       /*
> +        * VM couldn't reclaim the folio unless we clear PG_young.
> +        * As a side effect, idle-page tracking loses recent referenced h=
istory.
> +        */
> +       folio_test_clear_young(folio);
> +
> +       /*
> +        * For the active/inactive LRU, a folio demoted out of the active
> +        * list should have PG_workingset so its refault is still account=
ed
> +        * as a workingset refault, and the referenced bit always needs t=
o
> +        * be cleared even for inactive folios. For MGLRU, MADV_COLD clea=
rs
> +        * refs in folio_deactivate(); MADV_PAGEOUT handles refs after is=
olation.
> +        */
> +       if (!lru_gen_enabled()) {
> +               folio_clear_referenced(folio);
> +               if (folio_test_active(folio))
> +                       folio_set_workingset(folio);
> +       }
> +}
> +
> +static void madvise_pageout_prep_folio(struct folio *folio)
> +{
> +       unsigned int refs =3D folio_lru_refs(folio);
> +
> +       /*
> +        * For MGLRU, clear refs below LRU_REFS_WORKINGSET and cap
> +        * the rest at it: MADV suggests the folio is cold, so the evicti=
on shadow
> +        * should not record its hotness in the high tier counters, but
> +        * the workingset classification is preserved for PSI.
> +        */
> +       if (lru_gen_enabled())
> +               folio_set_lru_refs(folio, refs >=3D LRU_REFS_WORKINGSET ?=
 LRU_REFS_WORKINGSET : 0);
> +}
> +
>  static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>                                 unsigned long addr, unsigned long end,
>                                 struct mm_walk *walk)
> @@ -434,12 +470,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t =
*pmd,
>                         tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>                 }
>
> -               folio_clear_referenced(folio);
> -               folio_test_clear_young(folio);
> -               if (folio_test_active(folio))
> -                       folio_set_workingset(folio);
> +               madvise_cold_prep_folio(folio);
>                 if (pageout) {
>                         if (folio_isolate_lru(folio)) {
> +                               madvise_pageout_prep_folio(folio);
>                                 if (folio_test_unevictable(folio))
>                                         folio_putback_lru(folio);
>                                 else
> @@ -544,18 +578,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t =
*pmd,
>                         tlb_remove_tlb_entries(tlb, pte, nr, addr);
>                 }
>
> -               /*
> -                * We are deactivating a folio for accelerating reclaimin=
g.
> -                * VM couldn't reclaim the folio unless we clear PG_young=
.
> -                * As a side effect, it makes confuse idle-page tracking
> -                * because they will miss recent referenced history.
> -                */
> -               folio_clear_referenced(folio);
> -               folio_test_clear_young(folio);
> -               if (folio_test_active(folio))
> -                       folio_set_workingset(folio);
> +               madvise_cold_prep_folio(folio);
>                 if (pageout) {
>                         if (folio_isolate_lru(folio)) {
> +                               madvise_pageout_prep_folio(folio);
>                                 if (folio_test_unevictable(folio))
>                                         folio_putback_lru(folio);
>                                 else
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

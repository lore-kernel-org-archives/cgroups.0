Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D9546C826
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787589081; cv=pass; b=TRCPopnmQ3rKx9+AKH2ndcg5RxQt2d4Ej/NPPxonIIVAmDwp7oXkz2aQ0pDf9LCivdWNUmfG0i7A15N1wpOm5cpGZosDIRnOEUVgEugNkhJu0p7pYk0JNZ7GUP90QLnCF5SgVeQ54pufR5s0TyBiBN/YN49pDwzxX3kVVXUqtQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787589081; c=relaxed/simple;
	bh=m0KvC1xwLQQwlzKKy20Dkrhkm17zfHVvHAlyYqFx5ag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qyy932F6/MxCn9q0dkcPlimZK9rg4zpHqW2vGETYCNZoz5xSU0pDAlAWcT8ff79mpygCrUnhVPaf6TsJlpRzDOjs8Y7c8W6fGuugJKexvP4vPUyW618hZ+TUDqkw9H0PMUd0zj+dtHnK20bteN2RNscnF6kCBC1UHrTDTy1LjOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sntkPcM0; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sntkPcM0"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1677c91969so449714566b.1
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 09:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787589078; cv=none;
        d=google.com; s=arc-20260327;
        b=eDn0YlYQTqSWSn0t7/T8RNF+yaT29zaY7qxdsR5L9F+53xruRhU7iuZfTeWjP7A4i4
         c9a8anQLcQMDxMTGHMC/9NcBGXj4C6xr08IpB4b+G5gxuUdvaSXJqhkYUj7gg+1KmDm6
         dlqILDYm7KRiTJuypFzxExSL6d83HGTqAV7Bp/uk8tvvRGFMux2Pgon494Cxa8It/GOS
         WUQ9/o19SwDC6yJToKUYsu/niqETYaNW4RDCCbHb/8wyjvjwPdv0KIUFVystcJocHO2q
         QuWNNEU6h8uvVs4/KlP5JwiYBkl3Ck3I3MiLlTnUH0+7dH939WgWjNkb4YqsaUAeJ/4v
         f+hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
        fh=/mCTmXAW/NS1dEQo2oz02RZFhQinj/iwrIZUebctlm8=;
        b=TJVM239kbS8wJ/GvkKDQDzJYHrjGQUniqj1zck5V51ZoPT5iMwzix//6QQaOumfPV/
         tpndgUB/K4RV+M5ch1MkOe3pamdYOy+Mc9eW4/W+/UOzNvwvvGLg6mj22yPDNJ/wGiv/
         XCNHcy0dL7chg6aX7dLDkX5+rXSlR1BQX0f2RVR4suA3YZxdCSVNBE/MCrG++PPOsGDh
         3yYz5/gBclGVU3BspzT7547P7s6rVsUlkap5R6RNOQFq4R+o6VRptJCeTP0EOtOEeTF+
         hdrysS5kFBUyqiwHg+1mjVPa3xY+nkkiEvrRUOgA63Ei2LV708BtfGOJLYGkjvb8uTSV
         wKIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787589078; x=1788193878; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
        b=sntkPcM0gvGZJhU16O8r1Zo05JmCCm5cUnW6hYr9kzxQc6did4hvjjY68HDaVusjDS
         dWXFPp7ya1R1isMKDagvlDusleHdU69RVjxF9SJ22Jr8shMiFr68458mOo7Z+xuRiT40
         /fpIF6lTGC/AvRKTtEzJYLWyU2XKvEqbCFoUQTiRAHHclMu/qSIlqwjsYH+pCYpc7c3c
         n75W5fRyd+SwT2vUZvLIvm26EH8ahJWPSN6EPHFyX1ebImweK5N14AtPIvnIGB4BGpog
         D5dCQWdJ+Zqhil4vsA9fxC5Z5blouVXpNyrPHALFwM6BWSaVqxXImXdS/UyizWpagWbF
         ZnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589078; x=1788193878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jKDnyhtd0eENDwLDsf23GJYh56L3iJu19fRA635QnCc=;
        b=jGVy8AkRVizs/esXwmQJGgPZTw0dPWyn0zi1N/SGCtJIsbyx4crCXvTkLSNI8bRGgb
         DTSTEeP3kaSRT5uwR4RBXOaUJZ95qJr5IkzsBWjR2RklykkNMFEXqt5M2uoWGeC4CTSD
         7yS8dm7OImhtt9GWXHqvJoRCKijrSET56INumm5Mu/5CxfGDT1PsKYPJ6QiqSwbq7vFl
         tCJObdf2gxocKApjMXK84hsUAzDuhkK+qXk1ySkQe9JV6B7F1WyDrBA1OT/xnIlfBinx
         aajccWSdcGghkJdozZXhPqftD+mZoHNC4G2Q/S4ysUNr2p1BZr/7dfFKl4HX20HG2gEg
         oZAw==
X-Forwarded-Encrypted: i=1; AHgh+Rr/JAHeNwAjjHotD1LVhC7g860pvoQGA1J2w9Mkj3Bpel125PULMSnXBdVhq3PEVNejrU2eaUNI@vger.kernel.org
X-Gm-Message-State: AFuF++nnA5K5ay4PdC9JGlx4SVle3qgeAFQM2wgs+rLdZBxhRCgyl6Kp
	ekSkZzB4QuwfSyQ8pDRPr4KQ9VU4RYBdC4qL0V4UTDhQW6zs9ynPSWCCjqhbODhgdnaKqPM0mLa
	Uwh2EE5oJKcTtRIwLXjubi6kOEb59YE0=
X-Gm-Gg: AR+sD12oRlIQkMyXeriCtqd+Q8JtK0RmJBKaZ0XKH4AfBSfwp2TGCIWONOhMaj6z+yO
	fcqrM/mTSDrQa/J14jVoalPvHAJJu9o0uczvjB9qTjnEgSZ4rclegPdUaW2qJN6DVSlpQ4DlZaY
	l9lqx6XMgMrrtX3DgA8aQGY1pMD91XX/8C62xGPEnp4sDA27oGYoNALvG1KZlqxWZqfZiyqbJ2G
	v/jRGaR7Pbba1clAPlwqpJxYLAV6Oy8iQVVLxwn9YsuKJmarCyp/ah09t/TBUIkWpy14L1/Ni9J
	q17BtQdUCTkZ46tP0BzXvQ5XtowtxMXEatma1cw1pRSe0zyPO56xoc/zR47NTQQZ6ZJtQhXXPKu
	Zgh8ISPZi0f0c
X-Received: by 2002:a17:906:209c:b0:c24:cc3c:db11 with SMTP id
 a640c23a62f3a-c24cc3cdcf3mr595871666b.21.1787589078066; Mon, 24 Aug 2026
 09:31:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com> <20260824-mglru-flags-cleanup-v2-2-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-2-0104132114ae@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Aug 2026 00:30:41 +0800
X-Gm-Features: AcwNN1VH8-bOniuA8E6yY3_HjFay55kxzw2lY4Eo1sZSYSutQu4Ycnu52ZLcbp8
Message-ID: <CAMgjq7BYze16AVf7O4qBzYiNBOuTo_ayza3AjWFEQ=LG4pwuxg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Got this from sashiko (I consider it false negative since that is
extremely unlikely to be an issue):

--- Patch [2]: [PATCH v2 2/6] mm/mglru: introduce helpers for
manipulating gen and refs flags ---
commit f0369e7dfac3789b1433352b10e442443527f4cc
Author: Kairui Song <kasong@tencent.com>

mm/mglru: introduce helpers for manipulating gen and refs flags

This commit introduces helpers for adjusting a folio's refs and generation
info. It replaces bit operations on folio->flags.f, splitting some combined
operations under the assumption that the resulting transient states are
harmless.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d6..080132997d876 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>   if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>   /* Activate file-backed executable folios after first usage. */
>   if (is_exec_file_folio(folio, vma_flags)) {
> - set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> + folio_set_lru_refs(folio, 0);
> + folio_set_workingset(folio);

The commit message mentions that splitting these atomic operations only
creates harmless transient states, but could this specific split break
lockless MGLRU protection?

Because lru_gen_set_refs() can be called locklessly (e.g., from
lru_gen_look_around() holding only the page table lock), this creates a
transient window where the folio has both its LRU references cleared
(refs = 0) and the PG_workingset flag not yet set.

Concurrently, evict_folios() runs under the LRU lock and evaluates folios
for eviction using sort_folio():

mm/vmscan.c:sort_folio() {
    int refs = folio_lru_refs(folio);
    bool workingset = folio_test_workingset(folio);
    int tier = lru_tier_from_refs(refs, workingset);
    ...
    if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
    ...
}

If sort_folio() reads the folio's flags during this transient window,
it will see refs = 0 and workingset = false, causing tier to evaluate to 0.

Will this cause the MGLRU protection check (tier > tier_idx) to fail and
incorrectly isolate actively used executable file folios for eviction?

>   return true;
>   }
>
> - set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> + folio_set_lru_refs(folio, 1);
>   return false;
>   }
>
>   /* Promote on second access */
> - if (folio_lru_refs(folio) > 1)
> - set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> - else
> + if (folio_lru_refs(folio) > 1) {
> + folio_set_lru_refs(folio, 0);
> + folio_set_workingset(folio);

Does this have the same transient state race with sort_folio() as the split
above, potentially causing actively used folios to be wrongly evicted on
their second access?

> + } else {
>   folio_mark_accessed(folio);
> + }
>   return true;
>  }

===

In theory, yes. In practise, it's very unlikely to occur, and even if
it did, we are totally fine.

And I have often observed that folios stuck in highest tier due to
PG_workingset is actually causing worse reclaim. But if we are very
paranoid here we can do folio_set_workingset and then
folio_set_lru_refs. (This may cause a in theory, still very very
unlikely, aggressive protection. And in fact I think we are definitely
fine either way). I might update this if there is a v3.

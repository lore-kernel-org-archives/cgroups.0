Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636CD30E85D
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682063; cv=pass; b=RDdcxzsAwDwnHGIOTHr1bunybKAV1tQ3nNsMOUNToYdpjR9XNXTRBsLCLEN9UlQ8EsrUzFEjDrDKW2ny10YGs6ieS/Se3WR+XPTG9up7MMr0z7tTv1+bsw88OB4CvRq6F6YH2GpnXNnrn7P/ycCTFrXVUuaGPch88F5BxfF8Up0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682063; c=relaxed/simple;
	bh=hqhrXVg8CxH/GguegGLV3hzS3LCLILXiCZ3vQaTJdNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3jT94I270pJl32PlbQyp5/ZzF+CyOeS49XOVfsI7CYYrGpC/aYLYQwfxHQQv17H6wblLT/zOonhamir3IxkJPI9MUDDu+TgGfpVmlAFt/FtRLdNYOqE07/6UmkSoNZJwqePUMF928o5tAeDb0iLfHB2YruWIQg0Jpo01zq5Ilg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPEPHZ36; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPEPHZ36"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1671ec8692so731255266b.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 11:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787682060; cv=none;
        d=google.com; s=arc-20260327;
        b=bwo57BaaAiLvhJ/ZQoTLWKVTDUxMTxHKA+eQdfgqPXtKaL+UdDJ+nE51wYgOD0nyeK
         tJOp0NLTzVgRL8uNIzWYmt6kold7gafh1Aa0b7eQ1XYag/oII9/LMQlbbpn53aUyyN5Z
         Crc2x+gpic3GnjoPsHICDQ3ARRIr1S5P7acteAK1e51t05Lkx+hfyo7bcN+PkH0l68wS
         4x8NOoaIdYkBzA8RUlOgFcC6EvXeSq5rW6NVYOP5kx9dLtVzs2A3I7G4Q1ShuPaKR2cL
         TyvDaO2mVsEqh/BjL8akjv/C+an2E5fB2pWAuZv0wyJihsKLVefL2SVzW3l3/pbGBXYw
         5zOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
        fh=NvVk3+SEhWRGaACbXLb3nsjYMJYLK/trluGYxLvWwwQ=;
        b=OsdJd400LVi2SN9mW5GjojXRDc3ul2a1buIlaJIOZFMU6TFCOKweBnWVGc9G+rf+8P
         9/HPyhB3dpRniCymsstOyCQnOI2asyOWEP0Qsvu2bJ7A42/griIjH1c+DErx37BRivmz
         oNjFtAgldjgiWoptGEjUrayoGbE9IisXoHaQm+cgavXQn1Z4iGRJng5uwTUsZ8R5jqHR
         j69g+xt+yFgRH6CX0jJEJZONajYsnoNE3HFXbHMFyod13dBIkMsMAK59/q5WbsEmSzPy
         pyLgK6cfgnF7cuMyK2lsyLH2tuutJhrVhqjqxppMc807ZB2r+yRUq77+Jer8r++vJpsX
         J7Qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787682060; x=1788286860; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
        b=WPEPHZ365CUd7p3tXNNZSL1V/++6DE7Teh6IjSwzyi6ckQph+naN3EeH89ogEh3mF+
         rXTcmhvsG8xdJNZAfqIaJBAp2NHVCcuifLeEdOxW7ZfwjF05/DFhr9FpuqVloReukF/b
         JBKl6aaFScScom3X8uUpPJmeNZQYODp94t0LmLIosy4eD0dQonJzYTbD35pqG7cWNORv
         RgNOwuQ2QCUsD4ATDc7jQepcM3NRhmGMV10paObjNn59k8As7FXIAQfCCj4oavwIXPv9
         nxoNTXqG2+x+y+glXt5lN6HyOzS34MEN6+IBY18uJUpj2ChnBUPt9Y8+hUCVFHNYGFtm
         OHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682060; x=1788286860;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
        b=rsEiDA5r0HhgxwKQsIBfRK4avV/OE1oUdII0Pd1vD/O5g6ECNKD508viL0kXMWhY7Y
         7Hhl8I4sTiT2q+gu5uFHfkV+u6vCpSz/b5X6uFZoe/tFZxiPAg1SMvkayPIXoWQrnXyf
         4plakJfo9Y+cljbCxi0EEbrYluSPaqve97iqcjJ9Asue/aOf4Akxfp5BBt+S8zP+gqLt
         xna3yjdYePPSyjEhc8NzmfigUlQrRVnmDmbRS1SVFWxvP54HzIygXlS83YahPpKpPm9v
         yBL6+jnWsgcpicCK0WZC1xSTaM7H77tgCq4dTdj1jh9H1AW75a8hWJ//Z2kl1l1auD3n
         LJ1w==
X-Forwarded-Encrypted: i=1; AHgh+Rq2GdAhQDZkwAoH8cH4gtZmsehDZUd2+c5tP6dCct0cGHE7+cDC389RdgvcUzPQrKffyLs4mP65@vger.kernel.org
X-Gm-Message-State: AFuF++lwa4GE+2n6s8vsgrjqWmyjJ1P9p9uh+qzj7JAh0HHT2csl7H5H
	TnMSVr/01pyFD48dMNyPmo1DFPoQrXC4AT7VBBxyAx+RaBVmIeZB/i6XE1N+PtkUxDL0e7YYM5U
	dO7OFbANIxVRhL3TlZ527m2KXmZBinZA=
X-Gm-Gg: AR+sD10jcRPLGVeH58fm60lfjZi1j6Lc4eHkF/yyAiIdJOn5IJ3y+JaYxO23KJLRun5
	+PLII8UCS+xEU/tvLzE+Bhp4zeKBYbFd8g1GAVcE9MaPFmlQWpdKt1BKww2Hcsz2pCQh25CQvVS
	L6tOXt7zd3zYm9hHtiZZPjuSLQwPa7zf0irMMG4NuUAfRK13RZDa+kCB47LeHnLT7mJllm3/XJE
	yau85reSvhCyh2lfm+J+g4AzngUAN6aXqYvyPhx9INCBjk5ndyeRq6rnwyKEeFQLtAvtMKJ8wdK
	1U2MCpXhsSeMIyJ2/35G9cpB8aNnziPzYvMTZwChlfA6FVVRV9/KNRcpv5g5coCQBzlKyo4CaDm
	gDMWVcpj1Kf8H
X-Received: by 2002:a17:906:6315:b0:c1c:4e36:eec6 with SMTP id
 a640c23a62f3a-c250c608d86mr52189466b.18.1787682059979; Tue, 25 Aug 2026
 11:20:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 26 Aug 2026 02:20:22 +0800
X-Gm-Features: AcwNN1U_5z30Xb0y454YfAJGi9xba_Kr9vW4b5gdWTy2Z2qEjtPAhDL3tECEXfo
Message-ID: <CAMgjq7BheDgQZa0=KiRnxVwky9by5LA=iaexfPfT0WftgfL=qQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
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

Sashiko reports (TLDR: false positive, please ignore)

commit 381ba2d1b94989f14f9427e1427b761444230107
Author: Kairui Song <kasong@tencent.com>

mm/mglru: introduce helpers for manipulating gen and refs flags

This commit introduces helpers for adjusting a folio's refs and generation
info, replacing direct bit operations on folio->flags.f. No functional
changes are intended, splitting some combined atomic operations into two.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7e..edfaf26618120 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h

[ ... ]

> @@ -270,7 +331,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   gen = lru_gen_from_seq(seq);
>   flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   /* see the comment on MIN_NR_GENS about PG_active */
> - set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> + set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);

This is a pre-existing issue, but since this line is being modified, does
it miss clearing the tier bits (LRU_REFS_FLAGS) when updating the MGLRU
generation?

When a folio moves to a new generation, its tier bits should be cleared so
tracking starts fresh. Failing to clear them can leave stale access counts
that inflate the folio's tier, which might distort eviction logic and cause
thrashing under memory pressure.

Since this path is executed by memory pressure or page faults triggering
MGLRU page additions, should LRU_REFS_FLAGS be included in the cleared
mask here?

===

Not really, MGLRU somehow currently keep PG_workingset once set, also
PG_referenced is a bit special. In fact, the usage isn't very clearly
defined, which I think we can sanitize with MGLRU-FG later, but not
now.

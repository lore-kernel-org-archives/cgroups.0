Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBCF374A13
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 21:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787174694; cv=none; b=NDfuHlB+oVQcdySfclAdUzpJCX8Gjh0w7JyD3NmPssGImqLODwRIv5Gk+POIqb1V3p4jSac+tvT86a643X4YuKed6IyeJIPDkfqiU7RZH2i2Ua5LGKoL55pEddofDB52l0FR562UCGuOCEmPNJJ62Tbqs700Z8gZ7V/TZeatgDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787174694; c=relaxed/simple;
	bh=nRWXUpoK1riuDr09d1SLNDyGfy5p32SSzQg+dsb0d/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rkvASlgJXa4JYVTchGPXk+G+pz+Kxp8UcE3vFb6Ir+4KQ3ERiZ1nNZZHXQyVJSU6Pr/2uFaCUadm4HXZ6WEsGo6wpzHg91hIRamy+BcCPKYT49S6GaPIRhLK/JazypRXGm+DV3k60oySHlctTk/nPFPDapNQ4H/KNW5zWpv402E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUI3IiA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUI3IiA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5802B1F00A3F
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787174693;
	bh=zNqmDH6Jq1rIZyagW0x3hDwfycUXlIykI4fUBBHVlfw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SUI3IiA/1vevgZp9vqFX8HwwBHOS2iwj0lvrt/dLO/QHDWVPR7WoxRa3vauhhymbt
	 FmZlir2JsgFBd0JtVWMWcrPR2o3EI35HCIZWJJrOHitsWT2xnLydWu3POjklIYSRLP
	 LREGAlvahABDbjFU6PZqVPco+hD6HQhu7ULgtECMbNE0sCwYLk8rsKXuICPGQ+GJHS
	 S4E1KE2b3mSUCEgFoIAqrZcOPogRMgtlqVL0uhpabsbDRsvd2bbjGPFT0WKAD8QlyC
	 pzXq7siuDG91CfPYh1ttNNgq687VMtRHU5JOBg5ULNtaoUCHVHjRZcDXpT12E+wRkk
	 ZHREQEj6jG6AQ==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e512a9a6bso87346785a.2
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 14:24:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RovpsaPSIcOCwrXHx1LvQJSC2OLDeDxaRavjFOnLi4EXOuUn2Y3hmTHV1B//i+TQG6rCA9Yek2I@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5SfcNK8gQk9KVbjqfaWhl9SxAoUHdAcjkwdZVU9Ej0yIzIooR
	tiYR0vssM3A3FTOsF/fZrk+sR5O9k1+hfHCDOQVPbGEPhUqp7uqeIgNwXgcoR1SCyYu0MhxUey+
	7eG3rvtcSwogMA4woo45MNmtXslVEY3Y=
X-Received: by 2002:a05:620a:1a02:b0:936:eb7f:d2c7 with SMTP id
 af79cd13be357-9371e309725mr741046285a.27.1787174692543; Wed, 19 Aug 2026
 14:24:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com> <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 05:24:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zC7-8OgMEep58TEt0gfcShUSsKeYBGUW5BGEk8U+m8Jw@mail.gmail.com>
X-Gm-Features: AcwNN1UbkL73D6-D0dw7N0OHp_q_gWFKVpfZWkoMrTN9W6bJic7KHpRg9Xi_EFw
Message-ID: <CAGsJ_4zC7-8OgMEep58TEt0gfcShUSsKeYBGUW5BGEk8U+m8Jw@mail.gmail.com>
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 1:38=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end. This is hard to follow, maintain, or extend. Tier values
> 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS selects the
> full range.
>
> Replace it with explicit (tier_min, tier_max) parameters using a
> closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
> LRU_TIER_MAX for the tier bounds. The call sites now become
> self-documenting:
>
>   - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
>                     (tier, tier) for each subsequent tier
>   - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

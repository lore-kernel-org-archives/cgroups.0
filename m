Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E6E3E5EF0
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 06:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788417033; cv=none; b=YtqswBYwCKWxwI7UYy4HAbQOzFO9DyO7IBLprgWsVhf6uKpiTtQlxMF0sCAUi/DluOqp0qfGbgeKZmChvALLBU1lUZra++FiaL7Ilm0AsUVZFN047D13K/eN3i6pLRXK3u4VGpw9GlUfLwWwue0zFTF64TGVk7J3/JRW6NJHwQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788417033; c=relaxed/simple;
	bh=R2/gjhxWyyUZ0jBNMDGGTiujSGfQ32xuIupRnERfeRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fibsBz83c1f4BTJHgnJUzlnYAuWrc4v8PT6B1yrUPhNxw35PAyLP7bLoY+3aV1efTaJ+bUf+iVttY/37+UR2r74XpWVo7pqnCYzQUiK53lQhzVhPZwV4jLVr0PzeNxGsuREbZvKGTMXfICb9zAufRoVhMggr3foNwawTg7B+8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy0QzPY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy0QzPY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0941F00A3E
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 06:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788417028;
	bh=z36InkbgZ5czLNoME51lvPgrfTTVurywTjIuByWup8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jy0QzPY1cF3r4gtDO8D7gaNVhpDUne0Zd7MF/2w23/uxKNOfaz3zb0ii2oEJ/dgfS
	 G/IV17hLAm1ub8nV8fpXa8/tUUSFA2GU/BzlcNTXXEmQhUOnNIH0a9dHRoEQDOYpaQ
	 EHlp5jEt42Pcp8Jz/BBqCuaroA4FBqnQtxCQTjaQlvRBgyTpkY3l4JCf8O/iiRa6v2
	 tG/AgelKTumF/oALVfCXbkyDD+OwwhWqyzymcD3KDFv2pdK/SZUKKgiLKy3fWgzZuv
	 O6EiFd+5s1ENSaRghAJt2sfTdvbZOreov8+SpGTluTTjalO2z1c0eQf1KXGhyXrKMt
	 euhJ8j9/BV5Aw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9390a2c8909so165572285a.0
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 23:30:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy5Z7Wu/WYBu56pu/f6bCj7iNXpZJLV2MbZqfQiP8+/r75EQBxyAK/uC6Ey23v7+ngtlHQ5I2/J@vger.kernel.org
X-Gm-Message-State: AFuF++kz66x/dJb+qHsnZOFWi9nlSA7zluJKIW6pX8yY3uABsfmkyBC3
	HQftSY16K1+GbO6dfnaJ32B4EuxEhCdE8U1+B1tyQBzcVdhS83rso+yoLxTH0fnFMZmWy4rmQiD
	s0tGyhD6nyqGzhtRVT1P5N3aap6g1Siw=
X-Received: by 2002:a05:620a:f13:b0:937:2ac8:bbda with SMTP id
 af79cd13be357-93960f52da3mr1075847085a.35.1788417022888; Wed, 02 Sep 2026
 23:30:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903031952.1120321-1-ridong.chen@linux.dev> <20260903031952.1120321-3-ridong.chen@linux.dev>
In-Reply-To: <20260903031952.1120321-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 14:30:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
X-Gm-Features: AcwNN1Xa9LjF9LvOPJz6jmGmZsvCdU3Ed2O2AMgXfYG7RHIlGiW-5e7M8Zr3wao
Message-ID: <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 11:20=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> For MGLRU, memory.min/low is not honored during global proactive reclaim
> (writing to the root memory.reclaim) and global direct reclaim, because
> these paths shrink memcgs using stale or effective protection (emin/elow)=
.

Are you sure it should be =E2=80=9Cstale or effective=E2=80=9D?
My gut feeling is that we don't need the =E2=80=9Cor=E2=80=9D here.

[...]
>
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

With a few nits:

Reviewed-by: Barry Song <baohua@kernel.org>

[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b4c9b8f3dfe9..500cc2051d13 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struc=
t scan_control *sc)
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
> -       /* lru_gen_age_node() called mem_cgroup_calculate_protection() */
> +       /*
> +        * For kswapd, lru_gen_age_node() has already called
> +        * mem_cgroup_calculate_protection()
> +        */

Could be clearer:

/*
 * For kswapd, mem_cgroup_calculate_protection() has already
 * been called during the top-down cgroup traversal.
 */

> +       if (!current_is_kswapd())
> +               mem_cgroup_calculate_protection_path(NULL, memcg);

Best Regards
Barry

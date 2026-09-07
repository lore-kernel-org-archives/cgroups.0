Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EE64908DB
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 11:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788780824; cv=none; b=R64jEYGFWDhqIqLCmTOdMZXajnmm+Qo35x0aWYOqWOdE0ekd1Oo22Yw2IlD/xpaNfy5clWT6pE1QGRt+IKgtjY8yBuKnWKYfFG2MjjQW5/n+FbBGq3vIfTnPeHu0KKR8wjn2/0MDhh504ONF1SauYQZ+mm73hTIjAyGYiBZRZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788780824; c=relaxed/simple;
	bh=/DtAETE+eaCo1bse3KJZheg7FEF5nUPfjyGxmwqdMaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s9NvN+g+1cK/Ojs6njMr1PQDMrHutJsBOvOJU0atYH44b+KdbAesTlhrV5SWcdH6FvgEmPdOdDTR9Ntt5MMul+d7zWSdTfJi+5HIWDxODvtTxgpbjFDlJvFJUWWGkjk4jHvC6xu8mstbSHrK6rdbH7cyKm+4neiLEEkQhI+txIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sw8YClOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sw8YClOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD421F00ADF
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780823;
	bh=irZ0fuPGmEXIuvkRoDmmm/9mv1DPowEwpNdMgIfCvy0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Sw8YClOhAIpUfUT7tgl1G+Z07bWN4b+Vv+g8xfZzDSf4EqeGKWViZG2mMh8vLwMZq
	 ZJm4nLMgKnTvhgGHj5WvTIi7OonrMu0//98YYlhyjx9FJFy9gIrCu9BgLOISUWsxJj
	 fcU6lZjWMwk8HpoB0OvCRlzPwU4etKssDPgSAg3gDxfIwMrCgrdWxjrFrsMafu/R3W
	 YlWXp/ocHjCDhTZEBX6l2JYNXVbO5sxvVSciFDccHvpFNMLnSC5v1Lg8J9kbzrDA94
	 oEL/OsJ98Q2mUbcr72ximflqHlW1SvcrM/3kAeGGhzpPZfbQumGFvMxc/nSQDjdf38
	 +9M4PSr9kJZWA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c247f6687dcso539307266b.2
        for <cgroups@vger.kernel.org>; Mon, 07 Sep 2026 04:33:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByrXncf9pG8+ixrKArq9wIxc5pVa/k8329zL5s4V3SY4ZA3OsyP3LEVa6NWhLJa1GaiLrEr4i2r@vger.kernel.org
X-Gm-Message-State: AFuF++m4TbqKtGsBSRLBrKz/G4xLArDnbFw3OyKsPi2owPogHDDXSZVJ
	eB2rmq+JBMBDdRlqV+QqQeWXTS3rIBEZQHXHaecz+8eZofUghJZ/GpN47Ndva5lj/3hxX6XYwFw
	mDTVmyCG2FSybkGi8MPkV3iCKJl5w43A=
X-Received: by 2002:a17:907:b04c:10b0:c26:1648:a074 with SMTP id
 a640c23a62f3a-c261648b742mr472935666b.47.1788780821956; Mon, 07 Sep 2026
 04:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com> <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
In-Reply-To: <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 7 Sep 2026 04:33:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtGdbaYe4cQJjaPkj5spD6gY2G33BBFrh3CURb6p2R1g@mail.gmail.com>
X-Gm-Features: AcwNN1WUxkV0t1H79v8s5n6xxY8uRxvyRY1wjk5P6CDIF6YhixLFaZDpcmnoz4Y
Message-ID: <CAO9r8zOtGdbaYe4cQJjaPkj5spD6gY2G33BBFrh3CURb6p2R1g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 4:01=E2=80=AFAM Qinyun Tan <qinyuntan@linux.alibaba.=
com> wrote:
>
> With kmem accounting disabled (cgroup.memory=3Dnokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
>
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=3Dnokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
>
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
>
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
>
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@lin=
ux.alibaba.com/
>
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index f3ae3c81e48ea..032136942c172 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1252,8 +1252,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
>  {
>         struct shrinker *shrinker;
>
> -       shrinker =3D
> -               shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE=
, "mm-zswap");
> +       shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_=
AWARE |
> +                                 SHRINKER_NONSLAB, "mm-zswap");
>         if (!shrinker)
>                 return NULL;
>
> --
> 2.43.7
>
>

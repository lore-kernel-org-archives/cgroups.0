Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5776C43901B
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 08:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620866; cv=none; b=oU6KVVJiOqfUGTsLo3SEZ94kj98dEbl9hNs6S/g3GoZhk56QOfVk0ntOcx9Uj8utZA5DEM3D+u87OzaGazNG3DsEAfSDKnLRnnzUojm075AdeIckXSxLwoZmoe8cHU3mLEXYrmzQaBNwqIv5qI1ZEvBdjMyxD/gvV3fXkJm6SAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620866; c=relaxed/simple;
	bh=EoPLQUWdq4h5toiAHK/3+kodI9riRuAyz47JghYYo6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZE1JquHl/PVPaWZh8NdESYwmjwNTf4Vub2jByRNcII+rtS4ScH8TGatDh5b2Z6ks2XzK1zJAYahFo2mKfrFlB/D1ok4yPduQPOyevuZyverkonYN1f6kSr2LuYXFWsYaOFWVKFWi9c+5ksDOEaa9UbD3wU1G4yXphje7m2OpEaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSDQqTuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSDQqTuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0473F1F00A3A
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784620865;
	bh=6GenzPzcYbFf+w6RJ/NVkKF8Dt0CNm/M4SQ446MxELY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oSDQqTuhskefxln0WsyjLF/koPtYsau0RQvIzKsmAFs7XLCPvs5Fi0XTWC46Y2Zos
	 b6fRsfyZBVDc1nEO+ZUBJzQa8Qp52bRJADyZeo4wLsCzdcoybBhpJ8qQ6et5rtUeZo
	 sWyVA3usbberbyHijsBWrMThw6OBBaeSXAUNWEdSPuGNhyvJXK28SNQi/lhcVs/WY8
	 jGUn2t2Z+t8WP01I4r6HewhkXFan9Lx96Bk79vEsMnEXakvZguqP/Bys9zG1BYIYVF
	 XWDRZlfC1RudSUqJ4nqSOYCmbGUAg2lgJ6ETB6OztIrqQXNqDKtyzdC9aEZDUThUXd
	 UkxX12Xjp93Dg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e6a434cabso576054585a.1
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 01:01:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrBOtF8M7S870u0DTC12q+7NR/LACpl/iErDDBnYkBY5lNv4SWmY1gLsvjL9ORPNvopErhYIkwe@vger.kernel.org
X-Gm-Message-State: AOJu0Yz43YW6J7GJdveSH3OtIPVFxXhfRuyWyoLLXToWLvsTUP4Rcr2V
	kISG/1U/xbzxGB/+zfY8FF4aibkAXVdQXRNOdWvL24D+T+qX0oSRmaj3HnRFhCi+BG7RmSanwXC
	dfqt/f3FuW96NYezzXF1rWXdDGMGRlsE=
X-Received: by 2002:a05:620a:1a1b:b0:92e:cd21:447c with SMTP id
 af79cd13be357-930b3f3e243mr1658877285a.38.1784620864331; Tue, 21 Jul 2026
 01:01:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com> <20260717122514.51514-4-xueyuan.chen21@gmail.com>
In-Reply-To: <20260717122514.51514-4-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 16:00:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yj3dYah2exFWLMwFhUysOz2U9ANyoESgdGKvRL0E_0zw@mail.gmail.com>
X-Gm-Features: AUfX_mzV7chpGdNffqXbImgVBBAcu9kSDaNJlsxvxuv1ZaQiruWokGqb-8_Rtmw
Message-ID: <CAGsJ_4yj3dYah2exFWLMwFhUysOz2U9ANyoESgdGKvRL0E_0zw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 8:25=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
>
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
>
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of th=
e
> folio.
>
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..40340a88f78e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>                  */
>                 if (folio_test_anon(folio) && folio_test_swapbacked(folio=
) &&
>                                 !folio_test_swapcache(folio)) {
> +                       int ret;
> +
>                         if (!(sc->gfp_mask & __GFP_IO))
>                                 goto keep_locked;
>                         if (folio_maybe_dma_pinned(folio))
> @@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
>                                     split_folio_to_list(folio, folio_list=
))
>                                         goto activate_locked;
>                         }
> -                       if (folio_alloc_swap(folio)) {
> +                       ret =3D folio_alloc_swap(folio);
> +                       if (ret) {
>                                 int __maybe_unused order =3D folio_order(=
folio);
>
> -                               if (!folio_test_large(folio))
> +                               if (!folio_test_large(folio) || ret !=3D =
-E2BIG)

I'd rather split it into two checks:

if (!folio_test_large(folio))
         goto activate_locked_split;

if (ret !=3D -E2BIG)
         goto activate_locked_split;

This makes it clear that ret !=3D -E2BIG is only relevant for the large
folio case.


>                                         goto activate_locked_split;
>                                 /* Fallback to swap normal pages */
>                                 if (split_folio_to_list(folio, folio_list=
))
> --
> 2.47.3
>

Best Regards
Barry

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2B35F8C5
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 21:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782163433; cv=none; b=s/YMFP6Q+tz6Ej14en4zyndAmdTatNz89wn1JGFTL9lk7RQmufUJ2lLqW4krHcFc/+uqM20dC703I/g/ltOahUm8QpMVdycsjjHoUmYcDIZChSwFfGbHa+zN/3tNszztee0IANkofkfXS5lee9fSosMQTCyR/NtQHrtaXgZl8YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782163433; c=relaxed/simple;
	bh=NUaegnBrKRGVVaM1xO9cxDzvZYBaviT08w3ag1Vc8TU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YfmkWOEKMAM8wknlGBsxn6KrsEMbsRqoqveetPjiU1hoPLSr+J2+RAgxmdSvdA7noUGKhMxfzjeN55LFYZN7U+5cKMAIMjDJlEO6Pq8z9LHIiO1LufBuj2SJq60ie8yXbT5+TSpUFd8ur1MfRttYWYFMopkidjZcEh79VlyJJik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRnatCR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRnatCR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C1F1F00A3F
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 21:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782163432;
	bh=nBwt9+knVk0gxEW6tWKS6tT3TGyu7KUQndTvmvb0IRk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XRnatCR7g5cHdjsDdRYyhckULl9uxrOillWQcSI3Kzne+LlWnEhLA5hUIlrvPGi/j
	 qNorXog60LQZrrDm5c7bLsxFUk5Ozz20GC1V2gZagx9/rZ+fUFOu9NKcY7fDfaU1hX
	 fM3UDDLfNi1tfbLdIFq8FU/ecvcW4cKLCHZT2G69SH/TtCqsSgMztC5jH8n0z0yHlR
	 6pFBWST+vBugWpRlOEauFXF1V9YitftUu37xKXAGiCwIrHaGjD9DpANC/n7MBLy8BN
	 Znt5OS1QdD/79bCGD3KJ4EIARRRBoevjx0A951BR/UEiQ+dbswIDe8muksIB1HIZja
	 m3CEAObSrXbhg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bec423a5265so860650666b.1
        for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 14:23:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/MmtWTlCd6yrs7hOCv2e0ONLEuxAz2J4zsBugmIiTvVAbQ3pgC9dohr3wWFYMXpG0ziE4gdMHB@vger.kernel.org
X-Gm-Message-State: AOJu0YxWxqqC9FwUZc9IH4Yzu0Cj2zfVElO+5T2u3cLKzI4rQ9n7F2z5
	8wpUG1SHAJndBksaHWjVEonpdPFwhEYvBi4arIjvHvfrCtEGS+EiuZzdJ+BskppCCBfIGbfBImu
	u8+DfhfqpQb50LWzs0a17FMzxa6EwgkI=
X-Received: by 2002:a17:906:ee89:b0:be2:cd33:2142 with SMTP id
 a640c23a62f3a-c097af68d12mr851744566b.15.1782163431536; Mon, 22 Jun 2026
 14:23:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260620181635.299364-1-youngjun.park@lge.com>
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 22 Jun 2026 14:23:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
X-Gm-Features: AVVi8Cc8noq3J4ynSRL6iWoOzgSvAT7nf-W2GfIbJXmFcMZ6lpr21cn4bL6kHZA
Message-ID: <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com, 
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 20, 2026 at 11:16=E2=80=AFAM Youngjun Park <her0gyugyu@gmail.co=
m> wrote:
>
> This is the v9 series of the swap tier patchset.
>
> The main change in this version is the addition of selftests for the tier
> interfaces, requested by Nhat; see the changelog below for the other chan=
ges.
> I designed the test cases and wrote the selftests with some AI assistance=
.
>
> For context, the bulk of the series is unchanged since v8, with great tha=
nks
> to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped=
 it.
> The main change in v8 was the interface change to use memory.swap.tiers.m=
ax
> with '0' (disable) and 'max' (enable) values. This mechanism was suggeste=
d
> by Shakeel and Yosry.
>
> This change allows for future extensions to control swap between tiers an=
d
> aligns better with existing memcg interfaces. It is confined to patch #3'=
s
> user-facing interface; internally, patch #3 still uses the existing mask
> processing method, which is implementation-efficient.
>
> We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for =
their
> valuable feedback.
>
> Here is a brief summary of our tentative conclusions. Please correct me
> if anything is misrepresented (details in references):
>
> * Zswap tiering [2]:
>   Tiering applies only to the vswap + zswap combo. Zswap itself will
>   not be tiered, as the current architecture requires a physical device
>   for zswap allocation.

I thought we agreed that zswap should be a tier, so that proactive
zswap writeback can be implemented as proactive swap demotion?

The only restriction we talked about is that zswap cannot be the only
allowed tier as long as vswap isn't supported. We can lift the
restriction when vswap support is added.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB2547CC70
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631074; cv=none; b=r0W6KCus2fr0t8d9y/uaK87q6FMVw/Y1trrQsq/OWdOdSlYyquIGcnLvLWUHEBMYOBOGh5gyAlWMwre+b7AFUQ03EX4ry51YeAlyJr8XQRSNbLnXy2yCg5FE1ojFooPoBkNG2m36N0CabaJlSw3S1paBLdBeaxskuMikgwCCzMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631074; c=relaxed/simple;
	bh=mt02T4z9f7+XK5ajTyVeoT4jFvKdSNSRb9us67dAKwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a7jM+XOh1T2HaFN1lbKtdqpTjuypQSFdKeDKW/r3oYLmVXLV2JtmOfDb6Fki/Sw/6wSvwf+eXJISSzntCWz2ndSxy2BNxl8kmyQPHBRMEU3A7L6ujPju+jvWdNa1QvVwzZfe5QEGAd29raYOpOxvZZ+FyvAEt09XG0x1utZq+bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3w7nHsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3w7nHsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D752B1F00ACF
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781631072;
	bh=WVV5qnuazsXM93UQJWpV+Y+mNZmy8LyDox+BmjJrU+s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X3w7nHsydopsmdHj7nw/UjEnhvA8C3Ys92eDGlhDu56KnfPGiKAbcDzMVjXVqenRa
	 M9+Dykl9JYHalHKhzgcSs1DxvUNs1jHlLudUM7yfd4kBJCM5cQmibGJ1aevI3nefOc
	 BK4CDHfvJt2hSsRez+hKODMSxteaZU4AxKTqdf/Wg2km31eyZLwFjHLITy76tfQGKc
	 VAy6cnS+V4QHSQnQjxghRjHvXhiDwbl+kEhNjGg9Jzi1OgttdCPhQsBXGyggxXMoBh
	 NuhYd+woC/Pgbzax5ckIZxKRnqNnIQz30GP9HzzX6B/x4RR5RBo/cwwRjwZIk3ZCbS
	 jyZ05mURd8GmQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bebac79fff8so604303166b.0
        for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 10:31:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/UvgowyPnjRe/HKQpFAX9oP+buXhVj1H1RFu9A64BsMS+2BwgCFXFKPedGKpmQ6ewdWca5vomH@vger.kernel.org
X-Gm-Message-State: AOJu0YyCx975rBLNZyrmuZYrtjDN8CGfq1ZAUIO/EhhzviPy6l6X9UfN
	WA6ZJ5/THX3iWfT06qs1BxpdrFPVkqU8K4Lf15I+2Neuzuv9cEurw2COergHPaS08xdVK0G/R+W
	AKQ9B2cTiQYvJi0YNw1qzj2VVFtIyIS4=
X-Received: by 2002:a17:907:c1a:b0:beb:b53d:4839 with SMTP id
 a640c23a62f3a-c05a6bd7018mr44427666b.33.1781631071598; Tue, 16 Jun 2026
 10:31:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
In-Reply-To: <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 10:30:59 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
X-Gm-Features: AVVi8CfvlTpa8wwRc_d-snmqbqbbbY8sLFpgryNiKy5mHm820TJFiip5SD6Te9E
Message-ID: <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: YoungJun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, kasong@tencent.com, 
	baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 8:08=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> ...
> > - "zswap tier only": Only zswap is allowed. Fallback to other swap is
> >   blocked.
> > - "zswap writeback disabled": zswap is allowed, but if zswap_store()
> >   fails, pages can still fall back to other swap devices.
>
> Upon double-checking the code, my previous clarification was wrong.
> You are right. Sorry for the confusion. "zswap tier only" is indeed
> equivalent to "zswap writeback disabled".
> (I'm not sure why I read the code that way...)
>
> As I initially thought, it might be possible to replace the zswap writeba=
ck
> control with the tiering mechanism.
>
> If we need to keep the existing interface, we can integrate or share the
> underlying logic (though the specific details need more thought anyway).
>
> It can be summarized as follows:
>
> - "zswap tier only" + "zswap writeback disable" -> meaningless (noop)
> - "zswap tier only" + "zswap writeback enable" -> meaningless (no writabc=
k backend exist)
> - "zswap tier with other tiers" + "zswap writeback disable" -> uses only =
zswap
>   (can be replaced by "zswap tier only". This code could be intergrated, =
modified or something.)
> - "zswap tier with other tiers" + "zswap writeback enable" -> works as is

Hmm we might want to somehow disable memory.zswap.writeback if tiering
is enabled, to avoid having to deal with this. But I am not sure how
possible this is.

If swap tiering is behind a config option, maybe we can disable
memory.zswap.writeback under that config option? But then if distros
start enabling the config option it might break some users. Not sure
what's the right way to do this, but having both interfaces active at
the same time is annoying.

>
> As mentioned in the previous email, the zswap tier on/off control comes a=
s a
> bonus (though, as you pointed out, we may need to discuss if it's actuall=
y
> needed).
>
> BR,
> Youngjun

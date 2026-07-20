Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57C44BCB8
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784572091; cv=none; b=Pv/fYljk0k46GnPBgqJMZWwhj0HDNYLZQE7GET6c3fdaEAQRK1lhkUAhG8A7LYntHQSec1X06mmQDVxxbAVF3v79HlSalvgAKag5j3Oo5L6J5pHpNaKQ3HgIVx7xLKY3U+yZ6n7N9sq4eQ02+C2/H4eXO/Z0GKYR8PGeYaQXTxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784572091; c=relaxed/simple;
	bh=xrg5IY/utMBtwCtXIS8XrjG3bE2+/RanH/XEc1wcY74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RO+GoH8J38q0XzkCGCLeQPeXRNLODkRwK70mJuye3hV1MYvLGpmpvrh9Vi96/G//QpnNJTTKcaYQ+VEOzJYHTLLkELGpdxDPx5o8JEAjFFo+VxGkHWqDvPK+jZADUz07Wc+lgwZ+uH6HRzjZHzl6KoByHuGz7hdadxFAatxWJ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXU+1bw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXU+1bw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BF01F00A3A
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784572089;
	bh=mUeBkszSLZpLeY1vHXaZpZdp8DfNcwXz6wfLvsS0W58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bXU+1bw26GpVEQj8Red5SgxnSsTT441TVJj+/EQu9yxUKDrfqoW+6P6ayEDf//y86
	 G89Zxf7JmdLA1isnRI8S7nnCi2WPrBVDSPrdeyv7kn8JsdTxHWssY6O0Es0nXoM7xP
	 ZuxzeUptUJwEYK32I6SNA87KTKVawMZp+A0qChBecfvs8QxiH4OU54bSixg+BfcDxj
	 a91aSMEIqmK5gnybeWLLZah128WDJGccZopRbZ87XhEBKrsHFNebqSq7ALSuEILllY
	 85y+wtzew0S8ieNTqhp3/YggzY407OisbKAkUCgrAlvgZgvQdZrmwaDu7UnaXRvv34
	 NDqsigfYGg8ZQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-698beff7178so9413300a12.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 11:28:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpYOIxirz4WbA2gEpRnamYt0ZmNdUlCl15D/x7ANMBQ+/oSzVmdIUI7QhzHNWWTM0pnJ81ku2Us@vger.kernel.org
X-Gm-Message-State: AOJu0YyHhf+IjDyTMha94IltL0YsupQnXZDI/8UI5KHKtZ7nyHhm9uQk
	P04kIrLcqVfi5MF5Gxkz8hXyg4KzOo0elcKoiZFgmerJeJUdXxv1W+EfooPjQ2OqGhBhHou/5Pm
	eDzxtX5LdixzqVv08UL4koqHgAMPZGfg=
X-Received: by 2002:a17:907:1c9d:b0:c16:a9e0:d5eb with SMTP id
 a640c23a62f3a-c16b4869776mr668320166b.56.1784572088428; Mon, 20 Jul 2026
 11:28:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com> <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
In-Reply-To: <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 20 Jul 2026 11:27:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
X-Gm-Features: AUfX_mw9GHQtD5pj7EfdilJONa1y4rj2U6Pri3MtJr_pXGOknXtYE_h7WWAL0-Q
Message-ID: <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"

> Hello Yosry, Shakeel,
>
> I have been working through this in detail at the implementation level.
> For now I am adding on/off control of zswap through the tier interface.
>
> > From zswap's perspective, we just need to skip zswap is zswap as a
> > tier is disallowed. Could just be a check in zswap_store() similar to
> > the check if zswap is enabled. I am assuming that if a swap tier is
> > disabled, nothing happens to the existing swapped out pages in this
> > tier, but new pages do not get swapped out to it. This is the same
> > behavior that happens if zswap is disabled at runtime.
>
> This part works as you described, with no real issues.
>
> > From the tiering perspective, we need to accept "zswap" as a possible
> > tier, or maybe creating it as a tier by default if zswap is configured
> > would be better to avoid handling the case where the user doesn't
> > create a tier for zswap. We also need to disallow zswap being the only
> > tier as that combination cannot work without vswap.
>
> I tried to forbid this at the implementation level as you suggested
> , and that is where I ran into trouble.
> A few code paths can end up with zswap as the only
> tier, and they are awkward to handle.  Below is each case and what
> handling it would take:
>
> 1) A write turns off the last device tier while zswap stays on.
>    -> rejected with -EINVAL.  The write does not take effect.
>
> 2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
>    -> the file goes empty, so zswap is not shown either.
>
> 3) A cgroup has zswap and one device tier on, and that tier is removed.
>    -> the cgroup's zswap entry is reset to 0, which the user never
>       asked for.
>
> 4) A cgroup has zswap and device tiers on, and swapoff empties them.
>    -> the cgroup's zswap entry is reset to 0.
>
> So the problem is that in (3) and (4), memory.swap.tiers.max has to
> change on its own independently of what the user wrote
> and it is not like just error handling situation as (1).
>
> There is also a consistency point.  memory.swap.tiers.max already
> accepts a child enabling a tier that its parent has disabled: the write
> succeeds, no error is returned, and the difference is resolved
> internally.  The user's setting is kept as written, and only the
> effective behavior is constrained.  By that logic, accepting a
> zswap-only setting and guaranteeing only that it cannot do anything
> would fit how the interface already behaves.
>
> Having thought it over, I think one of these two directions would be
> better than enforcing the rule as above.
>
> 1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
>    work without vswap, so today the setting does nothing and there is
>    nothing to prevent.  Once vswap/xswap lands it becomes meaningful on its
>    own, with no interface change needed.
>
> 2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
>    track the user-set and the effective-set separately.  Exposing
>    the effective one would show that a zswap-only setting is not in
>    effect, giving the user visibility instead of rewriting what they
>    wrote.  It would also help the parent-off/child-on case, where the
>    child could see from the effective value that the tier is off.
>
> What do you think? or any other ideas?

Hmm yes, seems like enforcing this rule comes with a lot of complexity
for little gain. It's possible today to enable zswap without adding
any swap devices, which would render zswap useless anyway. I suppose
in the same way, we can just do (1) and allow users to disallow all
tiers except zswap for a cgroup, which would effectively disable zswap
in the same way (albeit a bit less clear). We can document this
clearly in the memcg docs.

Shakeel, any objections to this?

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92114611E5
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136642; cv=none; b=kOuGLZ0wJ1rp9F1WLZB2j9DkjqsfulzafuyMovBWgADhQRhZd1Pb8RJccRJrjjhwVq5u3A3Sr0S9qSWlZbWVw7yfb0rDzf5D+hJXS6PSbs2SpESWoyc+OxAsSWFImrGpfRHgzpMru/C+G7AOk9azbP2ShEBMhAqMXYKixMIoPu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136642; c=relaxed/simple;
	bh=AaDK0YcKsOX8dmK42gislw1t6ZfV6eThD1LeGUn+aoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDAZXm76Gn01FTdhpu85pvjBfgh02/gJd3CbQEI+sZO7jZI/msGOUIZXr9hKdcwgFYKixyqnGthfnGYG8dncx3a3INMW1EWE9dgHU6qw4040KVlqvP7IkS6hnmxvVDpjjzrOhaF7XKAVOTkfaFSCaxd2nyLEsjlA3pHUvoyrHSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTz2mQX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTz2mQX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23871F0155E
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136639;
	bh=AaDK0YcKsOX8dmK42gislw1t6ZfV6eThD1LeGUn+aoE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iTz2mQX9mo9FOF+YeHLrJJRscOP/PN+7w5mxSx/7TISdXov6SnSOp+9az6nNI0x+K
	 D4eur/XVcaSPWc82j7hclEbYL5W2MZa+hL9910CaUEgDeybChSxGuNL3iaBdR9SIQn
	 AT0wDOtNrMl+NzkUxWsL0oLPbeKo5LUO+vCj91e24V6c3PWlpRsBXPhUbtN0rAe9UY
	 dghDB3YdKy0Z0rHwNcAf/J3GLaWPq78u9TdeXEidLxbHFl9xaTzvXhnRILOuxYkS3+
	 j7wlKadOHlNDlItqAoN2NlkCx05pRljDZVw4wMdalS7eMLwUNid23HZYROJl6Alova
	 8WPP8ObCH4UUQ==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-809b19a7f25so78269497b3.3
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 10:30:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqe5PI/AbdYI8X23w+ypwTHbDVLsoDwCskpGCM1xwhn/L0Lq/KelxLBuway8nxbV6J5FA6e32sS@vger.kernel.org
X-Gm-Message-State: AOJu0YzD6y3IwfSHUeitF44NFIIEuKYsq7Fx5uNGTz8MCWNLbDKUNc15
	aqH+/E+yNcVOn2yYTC81UISEBE9eNXgW1x2QydujXvy7R4AJzlf+MyRp3Hm6h5h70VGk+3ew9nC
	ksKN5BMguGGQnkS7QrFN7VP5elTaa9MNZsXzqVCJ/EQ==
X-Received: by 2002:a05:690c:61c6:b0:814:608a:acb4 with SMTP id
 00721157ae682-81ecf8769e3mr27004517b3.27.1784136638214; Wed, 15 Jul 2026
 10:30:38 -0700 (PDT)
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
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev> <alchYX43oV9KybWx@yjaykim-PowerEdge-T330> <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
In-Reply-To: <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 10:30:26 -0700
X-Gmail-Original-Message-ID: <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
X-Gm-Features: AUfX_mwNi5Y1pwimKjBk_MgYVZ1E3p7vG6fWGe6nDpPFl9wzmA0F3NoEIhyTWok
Message-ID: <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com, 
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 9:27=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jul 14, 2026 at 10:58=E2=80=AFPM Youngjun Park <youngjun.park@lge=
.com> wrote:
> >
> > On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > [...]
> > > > >
> > > > > Yosry, what is needed to enable zswap as a swap tier? What will b=
e the minimum
> > > > > requirements for that?
> > > >
> > > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > > tier is disallowed. Could just be a check in zswap_store() similar =
to
> > > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > > disabled, nothing happens to the existing swapped out pages in this
> > > > tier, but new pages do not get swapped out to it. This is the same
> > > > behavior that happens if zswap is disabled at runtime.
> > > >
> > > > From the tiering perspective, we need to accept "zswap" as a possib=
le
> > > > tier, or maybe creating it as a tier by default if zswap is configu=
red
> > > > would be better to avoid handling the case where the user doesn't
> > > > create a tier for zswap.
> > >
> > > Default tier if zswap is configured makes sense. Should zswap be trea=
ted as
> > > having 32767 (or maybe 32768) as priority as it sits infront of all s=
wap
> > > devices today? Also whichever swap tier has priority range containing=
 32767,
> > > will have zswap in it.
> >
> > Maybe we can handle zswap as an internally reserved tier which is alway=
s
> > preferred over swap devices.
> >
> > I do not think there is a strong use case for grouping zswap together w=
ith a
> > swap device that happens to use the highest priority. Also, using a vis=
ible
> > priority value for zswap may have a small side effect that one priority=
 value
> > effectively becomes unavailable to users.
> >
> > That said, if zswap is represented as a tier, I agree that it should be=
 the
> > top tier. The exact priority value or whether it is internally reserved=
 should
> > be adjustable when we implement it.
>
> Agreed.
>
> [..]
> > I agree this is reasonable. I can treat the demotion/writeback interact=
ion as
> > future work and follow up separately.
> >
> > > Youngjun, what do you think? Is this reasonable amount of additional =
work or do
> > > you envision some complexity here?
> >
> > I sent a note with some thoughts about making zswap a tier. Since Chris=
 also
> > raised concerns around this area, I think it would be better to discuss=
 it a
> > bit more and evaluate the details carefully.
> >
> > At this point, there does not seem to be an immediate use case that req=
uires
> > zswap tiering in this series. So my preference is to keep this as futur=
e work
> > for now, and follow up with an RFC after verifying that introducing zsw=
ap as a
> > tier on top of this patchset does not cause problems.
>
> My main concern is locking ourselves into an implementation without
> zswap as a tier. One of the appeals of swap tiering to me, from the
> zswap side, is eventually unifying zswap writeback as part of a more
> general swap demotion, and unifying zswap controls with more general
> swap tier controls.

There is nothing locked. The major complexity will come when
zswap/vswap/Xswap/ghostswap become independent swap devices for swap
tiers. We are not there yet. But if you want a bool for zswap in swap
tiers world, we can make it happen trivially.

Chris

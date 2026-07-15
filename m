Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B45472796
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136180; cv=none; b=UExUGTjiCH6nKG7VZuMZs+/f6Gvl0HiWsRBgJEciJ4OjN4QO87r219EGg8cSV43RVlqkfFjwT1mS7IBYUjT+XYZMy4nbNBlwKKR9Yq7qs8hRR2ZMjcSiAsxfSHIiLxM6aD9mRgc0wRV7wEvIzXQLaroNRw7GLGZPjYFbSjcJAF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136180; c=relaxed/simple;
	bh=fPNZtKv0G0JaCpItLnUH7W8J8CLF9ZlgP6GTiszUw9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdoln+pLgpeJIfz+RRKfO1kxLvyT8GWCLtqbi50zt8Xkj8xovlDKoATeBiXzdR+1Xm10VaDGMCmnjSaktuPID2o9fyWQ+YOQOMtgOkUj3rn7D6Ie7XY3wASAGkOaSztgpXKMWd/SzD7xaUUKduqtppABclAXYuCDBXAjFBpJJCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ot9RYmcs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ot9RYmcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0660B1F0155A
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136177;
	bh=fPNZtKv0G0JaCpItLnUH7W8J8CLF9ZlgP6GTiszUw9w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ot9RYmcsnJVfcokq70vx3LI+FqPReouqdjlNIuPOx8QNLly7EkVYtgdpSnHaGj6JQ
	 +JHllEveg51HxStlfj48qmer+VeNlRLCgdiT5c1OA7hL1nBS0oQ+eFXseyLgnz4LMh
	 UEIllmBIKfr+e/f1zsFVupSwyVn4Wi9u/sz3gEpy57SKQAteNklt1E5ASQFP2D5IU9
	 n72AbeTErjzbq04llYjVSGQA1KbCPlv9U/qt67bh/g8uUNjIKcgrFSjE+lJk60aPWa
	 a8iNGzc8CDKMkodlz2YYea6j5vrssNn7nASv74YP47EWj2NqJZLzrBu0Iz9oqex1UF
	 SvB5oa+LY27iA==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-81e851aebeeso64978997b3.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 10:22:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpEeu12taOQ30iA2xMlIf83NKXOliY1uYYnGAZOJFEkyw17mn3Kx/yngzwoORqJG7PvrkNvuZDx@vger.kernel.org
X-Gm-Message-State: AOJu0YxisSX9qXppYFC3tBHj4OVC1f1NYesbazF7z6dC3gMYQmWuwRd4
	1g8z/phF0jPYMGZCiAwCB/OVCKu9mfT4Gfh061bH/NLgyZyGMEWF1nONNdyfC7niL7aXU9se7Rm
	/OQ8OeSh6nVxDjSGOzmW9DU4u1wphlSIa6eaQTp4K4w==
X-Received: by 2002:a05:690c:c91:b0:81e:8985:4046 with SMTP id
 00721157ae682-81ebb299076mr70998317b3.53.1784136176139; Wed, 15 Jul 2026
 10:22:56 -0700 (PDT)
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
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com> <alawYov0c7a0Q6_l@linux.dev>
In-Reply-To: <alawYov0c7a0Q6_l@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 10:22:44 -0700
X-Gmail-Original-Message-ID: <CACePvbW6FKB8z3K=i7OjxvMT+SV8Dnpmd_8-pzB6tH0GBQv7pA@mail.gmail.com>
X-Gm-Features: AUfX_mzEFEZ8gnhhoTyYsBdUcS0O3teHPgTkExn2p-PbqOit0XXG1fqEfQT6aWI
Message-ID: <CACePvbW6FKB8z3K=i7OjxvMT+SV8Dnpmd_8-pzB6tH0GBQv7pA@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 3:26=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> [...]
> > >
> > > Yosry, what is needed to enable zswap as a swap tier? What will be th=
e minimum
> > > requirements for that?
> >
> > From zswap's perspective, we just need to skip zswap is zswap as a
> > tier is disallowed. Could just be a check in zswap_store() similar to
> > the check if zswap is enabled. I am assuming that if a swap tier is
> > disabled, nothing happens to the existing swapped out pages in this
> > tier, but new pages do not get swapped out to it. This is the same
> > behavior that happens if zswap is disabled at runtime.
> >
> > From the tiering perspective, we need to accept "zswap" as a possible
> > tier, or maybe creating it as a tier by default if zswap is configured
> > would be better to avoid handling the case where the user doesn't
> > create a tier for zswap.
>
> Default tier if zswap is configured makes sense. Should zswap be treated =
as
> having 32767 (or maybe 32768) as priority as it sits infront of all swap
> devices today? Also whichever swap tier has priority range containing 327=
67,
> will have zswap in it.

You shouldn't need to hard code that priority for zswap. Zswap, if you
make it a tier, it is a special case. It is different than other swap
tier devices because when you search for a swap slot, you don't need
to search zswap as a swap device now. So the priority of the swap
device does not even come into play. Internally, zswap is already
hardcoded to perform before the underlying swap device. It is not an
order you can change in any way.

So we don't need that priority number. Just reserve a special name for zswa=
p.

> > We also need to disallow zswap being the only
> > tier as that combination cannot work without vswap.
>
> Do we need to do anything explicitly for this? I am assuming in a kernel =
with
> swap tier support, there always exist a swap tier if there is even a sing=
le swap
> device configured i.e. a tier with the full priority range.

There is no need to do anything special now. The current zswap is bind
to the underlying swap device. That is unless we use vswap/Xswap/ghost
swapfile.

> >
> > I think this should be enough to support "zswap" as a tier and allow
> > disabling/enabling zswap per-memcg (or globally?) through tiering.
> >
> > In the future, if/when swap demotion is added, we need to figure out
> > how that would work with zswap. For example, if pages should go to
> > swap device A then swap device B, then an entry in zswap using a swap
> > slot in device B should not skip device A and be written back directly
> > to B. vswap would naturally give us a solution for this problem.
>
> This seems reasonable to me. Punting demotion/writeback to future.

Agree as well

Chris

>
> Youngjun, what do you think? Is this reasonable amount of additional work=
 or do
> you envision some complexity here?
>
> >
> > > If that is not too much, we can make that part of this series.
> >
> > Yeah I think it's better if we agree on the design and zswap support
> > before landing partial support.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4F73B2FDC
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132871; cv=none; b=cXyJ0ZesgwolMC10kyLAWt+EfozMHYHPK0niWHOOB5/hEZNqeq1Dx3LTQMvbj+MTgyIlQBniD2wWF3suKOP2w8Ic6wK7cSzdYl/I7wA7dXuh2FiuQrFrUMKp8+8LY1rt2TCoAnKUk4xdA4wgYCR4Zw8pXmp7V8UX1zTfuQq9Db4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132871; c=relaxed/simple;
	bh=zFUfoJezdtNwPtX6kuJH95c7aAgswIHEc286AIoPtL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NzRzZe2Nwe0IkJuXOVvtb0S9zlol/L7E9JKo2h/AO4TxZDfeewAjvGJbYHX4uxNK2ayxl+ustyI07giFnUJgGpl68xbVkBYORmcXx+fI+ZG4oEgB+3D5z0Gj6xhHk9hCXQKIAzI73kQ+P/DJbAyG4M0bx7jkBwpgraOwi62WVL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PV5F5zAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PV5F5zAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E9C1F00A3E
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132868;
	bh=zFUfoJezdtNwPtX6kuJH95c7aAgswIHEc286AIoPtL8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PV5F5zAkMbfj7CrAhY1pV9ZxdSs3SU/COCOBAg2Euoi0/+pdi6ZVJyoJPIJABogP4
	 qfEuxWE6pm4OLze2eoyz9OsFIKQ8/gwrqQV0xiWOet5ntwa8gDaYVKKJnzjL/Ym4F1
	 6HH4P9DMJTgGW7XhMfIfK8vDH0ZmLb1bYbwO3MB+rijKyqjpJK44spxhNgElR/JEYO
	 QmDafhG482djMUoskSh39UubmS5LNlvY66b3tSvIZhwuuhYv+dwZoiqmke3cnFN3AN
	 TGiS7Ce0AcWB6f52Nnrl8uBvhwR4+MRbWQqjo4a7FChxk6CSot0Up7S2Vp//PJ3fN6
	 N2Hi+17jHWShQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1600d040e4so352937866b.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 09:27:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpa5ujVpDXpCZA7EuqiEfwC4Pbx3f6k3Qrgetitn4sjiKPjEDjuf2oC1eJzDWE6SEUuGAHbd2Lu@vger.kernel.org
X-Gm-Message-State: AOJu0YxMo3m+F07skYcz3kjejAZs/DMZOJcHx5/aPTZEgj1bg5x/9XHk
	yle07IuM6cVBHGtxMrV7ORhdTfqRcx32NsxTk3Z/ehMkL9bFVNQ39fLQv8gqnKctTpS5dTEjpFq
	8Fzs6WfHBPt1L7/JM9vZWddkXH46hxA0=
X-Received: by 2002:a17:907:9413:b0:c16:242a:4744 with SMTP id
 a640c23a62f3a-c168bb2d668mr8563166b.17.1784132867098; Wed, 15 Jul 2026
 09:27:47 -0700 (PDT)
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
 <alawYov0c7a0Q6_l@linux.dev> <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
In-Reply-To: <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 15 Jul 2026 09:27:34 -0700
X-Gmail-Original-Message-ID: <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
X-Gm-Features: AUfX_mxgWwDmBkwb7rbCNPjuREquEJEs-N8I1JSatubo_uBU_AyX9gUGrWc6_KU
Message-ID: <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 10:58=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > [...]
> > > >
> > > > Yosry, what is needed to enable zswap as a swap tier? What will be =
the minimum
> > > > requirements for that?
> > >
> > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > disabled, nothing happens to the existing swapped out pages in this
> > > tier, but new pages do not get swapped out to it. This is the same
> > > behavior that happens if zswap is disabled at runtime.
> > >
> > > From the tiering perspective, we need to accept "zswap" as a possible
> > > tier, or maybe creating it as a tier by default if zswap is configure=
d
> > > would be better to avoid handling the case where the user doesn't
> > > create a tier for zswap.
> >
> > Default tier if zswap is configured makes sense. Should zswap be treate=
d as
> > having 32767 (or maybe 32768) as priority as it sits infront of all swa=
p
> > devices today? Also whichever swap tier has priority range containing 3=
2767,
> > will have zswap in it.
>
> Maybe we can handle zswap as an internally reserved tier which is always
> preferred over swap devices.
>
> I do not think there is a strong use case for grouping zswap together wit=
h a
> swap device that happens to use the highest priority. Also, using a visib=
le
> priority value for zswap may have a small side effect that one priority v=
alue
> effectively becomes unavailable to users.
>
> That said, if zswap is represented as a tier, I agree that it should be t=
he
> top tier. The exact priority value or whether it is internally reserved s=
hould
> be adjustable when we implement it.

Agreed.

[..]
> I agree this is reasonable. I can treat the demotion/writeback interactio=
n as
> future work and follow up separately.
>
> > Youngjun, what do you think? Is this reasonable amount of additional wo=
rk or do
> > you envision some complexity here?
>
> I sent a note with some thoughts about making zswap a tier. Since Chris a=
lso
> raised concerns around this area, I think it would be better to discuss i=
t a
> bit more and evaluate the details carefully.
>
> At this point, there does not seem to be an immediate use case that requi=
res
> zswap tiering in this series. So my preference is to keep this as future =
work
> for now, and follow up with an RFC after verifying that introducing zswap=
 as a
> tier on top of this patchset does not cause problems.

My main concern is locking ourselves into an implementation without
zswap as a tier. One of the appeals of swap tiering to me, from the
zswap side, is eventually unifying zswap writeback as part of a more
general swap demotion, and unifying zswap controls with more general
swap tier controls.

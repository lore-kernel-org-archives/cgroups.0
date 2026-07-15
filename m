Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844174963A6
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136473; cv=none; b=JUIM5a4boIUrGTlJ41dJaBACR7LLXm7qk3Y46+Fy+g2j8eqj7TTUNJan1ZqfHZZ+1+ETj/tmIdMdEnSujU1OT9AWOWfNwof2SEJQKcd/KB6uW8baPI7TpJcccK2UeKFce9CKDvKMqJMa2mr2JxTvYTdbt6QHuXYxnfzREp901nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136473; c=relaxed/simple;
	bh=NR8w0dFy7e0Mw1zCteSq/0BgsGyG302q7jjwjUv8Bqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gKta1XswHI2HoVkR8aeZLGediGILtZIM14Yty1WcIDEpbGwFtlXY2shWJX5vHEt59XbTpUWihrKs/wcNEDFUTiofch16VNWo2lENRBH1OXdnDiq/wOYA+/U2buiRT2XavnxfCf3pwATVUxMUuo5PCxAG1vvxtLdI+EERO1dDrY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbSBg3xA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbSBg3xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD791F00ACA
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136469;
	bh=NR8w0dFy7e0Mw1zCteSq/0BgsGyG302q7jjwjUv8Bqc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JbSBg3xAuVHEwGYnVFJpZ6OwQ9JeOeZz3MNNxr/dTaDouD3+PI1rvYHLiLMpAARZm
	 lEh8/c/K/zukxxMq6tZGmhbLxEq23t7GhJk2114rXki0CvYNy45Yw4fWYnr9xZv1J7
	 IZknqzImbcMicrHmFXuK1ueB5qlN5PgaNeFASnZLmg7xbBUpfCdN/ROyXeSNJdgZw8
	 3+WaSzbzLAN+nwOGMIc32D7v+wluOIuhqhKHfDPUgb3KI+NE2ZJVm1uE0B6097wEpI
	 npIf0IG786qwfzBpAWsSP60PG9aDh9bdHk4JRefniMbEQluKC3Vub+Gke/Ernepp5z
	 W/yHYqAhliIcg==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81ed27fe974so8264897b3.2
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 10:27:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqUKC37vWBSPdd29R5+R+4A8oolGG+ir/b+NClYJWEfoNekQciH3xeH4q/1Ciai5phY/6qu6ulJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxYgSqV8Kc9mj/nLoRHu1sgFc81IgdJ9ea/GJLr6P0E+qMX3OXf
	Rh23TuFeoyOImg05x/MUwisSi2zPcNGknQEcQyuAArwS4qFhuHXlgJORFhOQAwhoUQuVUuNLpDw
	lPjsJRmjB8x98GyzvJmymmpd4Voz9KFaYxr7KWqZE7w==
X-Received: by 2002:a05:690c:7347:b0:81c:bd45:478a with SMTP id
 00721157ae682-81e90139bb3mr142898527b3.41.1784136468624; Wed, 15 Jul 2026
 10:27:48 -0700 (PDT)
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
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 10:27:37 -0700
X-Gmail-Original-Message-ID: <CACePvbXiWzrDeLMKLoTO7T9wzi6si3i8afgMTg4ER654+A+o0g@mail.gmail.com>
X-Gm-Features: AUfX_mzxPNZ5biQu3ZF_BuRC46X4fkCz7J6L2acTm1IDYuzpm6tY8gmpKlppCqU
Message-ID: <CACePvbXiWzrDeLMKLoTO7T9wzi6si3i8afgMTg4ER654+A+o0g@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, 
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

See my other email. Zswap shouldn't even be in the list of swap tiers
to search for swap slots, so this priority is builtin we don't need to
specify it.

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

Just leave it alone and the order will happen naturally.

> > > We also need to disallow zswap being the only
> > > tier as that combination cannot work without vswap.
> >
> > Do we need to do anything explicitly for this? I am assuming in a kerne=
l with
> > swap tier support, there always exist a swap tier if there is even a si=
ngle swap
> > device configured i.e. a tier with the full priority range.
> >
> > >
> > > I think this should be enough to support "zswap" as a tier and allow
> > > disabling/enabling zswap per-memcg (or globally?) through tiering.
> > >
> > > In the future, if/when swap demotion is added, we need to figure out
> > > how that would work with zswap. For example, if pages should go to
> > > swap device A then swap device B, then an entry in zswap using a swap
> > > slot in device B should not skip device A and be written back directl=
y
> > > to B. vswap would naturally give us a solution for this problem.
> >
> > This seems reasonable to me. Punting demotion/writeback to future.
>
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

The minimal change is just giving zswap a bool to enable it in a swap
tier or not. Personally I don't think it is needed. But if others want
it we can add it as one off thing.

Chris

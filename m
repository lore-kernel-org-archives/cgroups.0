Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC483CAE95
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784150460; cv=none; b=TC9sKYK8lRR/HodhonQC1W+s39IBPBN6zmeIZLFvQmiBnB7jKzyB4l5YwY7kWIMOV9zWKqJRsI+Lu1CwxSF0eeAlqbIL8k892GJROobRnUrBzlE/5ZwRM1Uvunp5RGK0JfF56Cvaci9y2HjJxL7eMlIAqUoaipLpvPhsI73Kmkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784150460; c=relaxed/simple;
	bh=a06EiZVCuuEEPhPjPgGm4ZSMVajfJqfBjlz4+hR5yRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lyAEXxgkfw5CDSeylQ53WQbuh7XmZuKlAEZhkabmjVSpxW00sLWyaxDEU1J6FK5q1yMGelKv2djNu66Ug0Q6qSs75pw7tWfb4705SgXRvZkpkxeN7LFLQhjiuKIwBsfkp8cS8KWIdyqy6G96c+rjRDqpwiRbG+9NPqQNAUV25zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdQNywBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdQNywBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3925E1F00A3D
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784150458;
	bh=8HeGlrD8Ps0r+6IpCT3XTVXqJwpSuRwh0o0cHslUZZM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KdQNywBlJnNiarHdP8TjljFYW589E2ba9rqb6R6rkzQC+Wm69feEMnyQ5KBUFDwLw
	 L2fZZxBCJ1W4Up34HL9N00RUjJk3BN2nYAtH6czeAuNDIpyeGSFefvtpRGnytw2pan
	 SdEyzu4Irdc5iFejraoa4pYcy+sSb4iwDs+NuSTmJGyFMtBGgQGMMWz2wG/kU2mo8T
	 MD7W+CBLD5XWGPjjd9tevk2C3/+g9eg0hURj/bZblOPMYS5SLuYV9JH2H+G91jm+QP
	 lrh/AsvRhsFwYZzNMC8FAAkdg4rkvHAs0W1vjwjMy989iuVJ+Efu3vqsE8dDDgVqRB
	 HhPH/cRy3a29w==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-80dc4a68e4aso48974247b3.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 14:20:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rog3/TRFzuHQGWSjMKs3jXKM0uqipHZJMzn5Rw0JL8I9AUIdNGVhi9fFWHxWsUfMAHuxwvZESS2@vger.kernel.org
X-Gm-Message-State: AOJu0YzuZMJexq7jrHX9Z+ODoa83JscgTwIyynsTx70RWd45/mHSx/P2
	afIOaU0Jv1jnikgm7pVC5FN61sx65X0HgP29oceRiqGFTykoPkqa7vuq1EsF7jjSqHvxe/HH8DA
	UMzFphD1jvXmKr2Svlo4MjGhfzd1DWjIK2snpD4/1Wg==
X-Received: by 2002:a05:690c:610e:b0:80c:16ad:2f10 with SMTP id
 00721157ae682-81ecfa39be6mr37441897b3.33.1784150457537; Wed, 15 Jul 2026
 14:20:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev> <alcebHobUCUyO70k@yjaykim-PowerEdge-T330>
In-Reply-To: <alcebHobUCUyO70k@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 14:20:46 -0700
X-Gmail-Original-Message-ID: <CACePvbVuS9xnKSxN_8X+kdyoU-b+bJGUsMK_38HJ=KtGhsoDDw@mail.gmail.com>
X-Gm-Features: AUfX_mxrwC-Njpb1o31UwMZjEDCbBt-qNnFIqtzYDXg3SfZvK6I_kRISd80m4_Q
Message-ID: <CACePvbVuS9xnKSxN_8X+kdyoU-b+bJGUsMK_38HJ=KtGhsoDDw@mail.gmail.com>
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

On Tue, Jul 14, 2026 at 10:45=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Tue, Jul 14, 2026 at 01:44:28PM -0700, Shakeel Butt wrote:
> > Hi Youngjun,
> >
> > Thanks for keep pushing this effort.
>
> Hi Shakeel
> Huge thanks again for suggestion.
>
> > > Right, that's the plan.
> > >
> > > > but I would check all
> > > > user-visible behaviors related to zswap (e.g. interaction with othe=
r
> > > > zswap interfaces) to make sure nothing breaks or changes in a
> > > > meaningful way when zswap is introduced as a tier later.
>
> At now, the answer is there are nothing breaks or changes as a first revi=
ew.
> I think it'll be better to introduce zswap tier after this patch.

I am fine with that.

> (Details are going on the below)
>
> > > Fair point. Let me review this more and get back to you!
> >
> > Please do report back what you find.
> >
> > Yosry, what is needed to enable zswap as a swap tier? What will be the =
minimum
> > requirements for that? If that is not too much, we can make that part o=
f this
> > series.
> >
> > Shakeel
>
> I tried to verify what changes once the zswap tier is introduced.
> Please correct me if I'm wrong!
>
> First observation: before the zswap tier is introduced, some of this
> is already possible today:
>
>   - a "zswap-only" tier equivalent on cgroup: memory.zswap.writeback =3D =
0
>   - disabling zswap entirely on cgroup: memory.zswap.max =3D 0
>   - disabling swap (and zswap) entirely on cgroup: memory.swap.max =3D 0
>
> Given that, my take is that introducing the tier concept itself
> doesn't change any user-visible zswap behavior, since on/off control
> for the zswap tier is basically already possible today through other
> knobs. So this isn't really a user-facing problem; it's more
> something we need to think through carefully in the patch that
> introduces the tier concept itself. That's what the points below are
> about.
>
> The cgroup interface knobs and the zswap-global knobs need a
> different kind of review, so let's start with the global ones. The
> zswap-global knobs (compressor, max_pool_percent,
> accept_threshold_percent, shrinker_enabled) look fine with tiers.
> They're zswap-internal tuning, orthogonal to the tier concept, so
> tiers shouldn't change their behavior. The remaining one, "enabled",
> does overlap in spirit with the tier on/off knob: enabled =3D false is
> basically the same as disabling zswap for every cgroup. But like the
> other overlaps below, this doesn't look like a real problem.
>
> The part that needs more thought is the overlap between
> memory.zswap.max / memory.zswap.writeback, memory.swap.max, and the
> new tier on/off knob. Since all of the above is already possible
> today, adding a tier on top means we should make sure it doesn't
> create confusing overlap.
>
> 1) memory.swap.max vs. tier on/off
>
>    memory.swap.max =3D 0 disables swap (and zswap) entirely, and
>    memory.swap.max =3D max leaves everything enabled, so one knob can
>    make the other a no-op. I don't think this is confusing in
>    practice; they're just two independent ways to reach the same end
>    state.
>
>    Conceptually, the tier knob controls on/off/auto-scale, while
>    memory.swap.max controls pure quantity, so they cover different
>    concerns and can coexist. Even if the tier knob later takes a
>    numeric value, that number would apply per tier, while swap.max is
>    a total budget that doesn't care how the tiers split it up, so
>    they still shouldn't step on each other.

Ack.

> 2) memory.zswap.max vs. zswap tier on/off
>
>    memory.zswap.max =3D 0 looks semantically equivalent to turning the
>    zswap tier off. Could memory.zswap.max simply be folded into
>    memory.<zswap_tier_name>.max?
>
>    Yosry pointed out:
>
>    > > memory.zswap.max integrates naturally (it's
>    > > memory.<tier_name>.max).
>    > Not really. memory.zswap.max is in terms of memory usage
>    > (compressed size), not swap usage (uncompressed size).
>
>    I'm not sure where the tier limit would actually apply here: is it
>    checked in zswap_store() against the pre-compression size, while
>    memory.zswap.max keeps tracking the compressed size? If so, once
>    you give the tier limit a number, wouldn't its usage end up
>    meaning basically the same thing as memory.zswap.max? For limit =3D
>    0 the two already look identical to me (both just block zswap
>    usage). I'd like to understand what benefit a non-zero tier limit
>    (uncompressed) gives us over the existing memory.zswap.max
>    (compressed), once tiers exist. Let me know if I'm missing
>    something here.
>
>    Also note the mixed states this creates:
>
>      - memory.zswap.max has room, but the tier is off, so zswap can't
>        be used.
>      - memory.zswap.max =3D 0, but the tier is on, so zswap still can't
>        be used.

I this is more of the zswap interal behavior, I don't have a strong
preference.  I will let the zswap experts comment  on that.
>
>    Both knobs can independently block zswap usage, which seems worth
>    flagging even if it's not harmful by itself.
>
>    On top of that, the tier knob is likely to stay on/off/auto-scale
>    without a numeric limit, while memory.zswap.max only handles the
>    numeric side, so the two should coexist as is. If the tier ever
>    gains its own numeric limit, we'd need to revisit unifying it with
>    memory.zswap.max.

Ack.

>
> 3) memory.zswap.writeback vs. a "zswap-only" tier
>
>    memory.zswap.writeback =3D 0 can act like a zswap-only tier today,
>    because zswap still borrows a slot from the real swap device to
>    store data; writeback =3D 0 just skips writing that data out to the
>    device . A tier restriction works differently: it applies at
>    allocation time, so a zswap-only tier would block allocating any
>    slot from another device. Since zswap currently depends on that
>    very slot to store anything, this would break zswap instead of
>    giving us a working zswap-only mode, so the tier restriction can't
>    substitute for memory.zswap.writeback here.

zswap.writeback =3D 0 will disable the other swap device after that.
That is the incompatible part of the interface with swap tiers. I
think if you want to use swap tiers other than zswap, you will have to
leave the writeback =3D true.

>    With vswap, this changes: tier off and writeback =3D 0 converge to
>    the same effect(right now the pure zswap only tier),
>    since zswap no longer needs to borrow a slot from
>    another device. Even so, memory.zswap.writeback still needs to
>    stay, since vswap itself can be disabled at compile time or
>    runtime, and we'd still need a way to express zswap-only behavior
>    without it. I'd like to unify the two eventually, but for now they
>    have to stay separate. I'll keep thinking about it.
>
> How do you think?

I think with vswap/Xswap/ghostswapfile it is a totally different
world. It would better to create conceptually separate entities rather
than cling to the current zswap. They can share code, but the mental
concept is different. The zswap behavior of borrowing a swap slot from
the other swap device will likely need to change there. It is another
can of worms I don't want to open right now. We should defer that to
later.

Chris

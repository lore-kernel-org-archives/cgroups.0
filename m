Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A54E3932FF
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782245185; cv=none; b=MeYk1ABP2c03zsNbU1ErQvX+2oim93Qbm4f6q5xuW0PWLavycdbXZFa9HJMo+FOykmt4QxHrR7bcJoqk1bWdv+Wg2rpyothPeXZq+tzyRxKoBPqnn37YRIZIJ1Jgww+nvsLZG8lb/BYyDBLpZ0w6L0FnBgJHvuqhTuVlikC+6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782245185; c=relaxed/simple;
	bh=s0c+c0GezDF20x3hAeTTFLEap852z6Me2B2PImW6++o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EF0QitfVB7xYqBHRW2XW9kUMVDwDnIUOXrZZDwvXlwJmhzSBeTfGGpb45eWIE5stSYc4WzGKUkwO3byPFsMs31Ct/4lf/KTJBMkb8lwgIMCYxXbwyiz/piqJvxW1/UBUdhj460gkEgT112X3RcJ27cUzFbkyTk7XJH9n+iXYvHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=At2K8OkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="At2K8OkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305431F01560
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 20:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245184;
	bh=s0c+c0GezDF20x3hAeTTFLEap852z6Me2B2PImW6++o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=At2K8OkTQB8kqxiHpfXww+8Y7Us/giY/uxflP3MKqQzAFolSur8E4EdLzGA1M7byj
	 3GOtZ7wYAdWJU/BzvTkJ2fh+6hH8RqdzJEnUtk3pePkRjA1nCLUn8Adu4ChfyUe7xE
	 5Gw0WeVa0rjZXsPfYtQrK0dMMZTyQuBd3SpEOJmVvDQ9HPPxVxh8HRrwqNNa5BEqTA
	 8qmgxNARZ6CYwJdmFq3UxEBWZ1y+Y0JzpWr48B/w+4fV+uKZkZJuq6asz2Czi3CW/K
	 Kq6XbxGrnMhvvuacNPFJU4Y9s55IhZ7+SA1YLelkbX8wuEXnYmaZRLoKBDzODr/dOS
	 goEvZIq0+aK0g==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c0840dc2859so27669066b.1
        for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 13:06:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+SI1JiMpZKoMvfAhxQa8VBElcl1pJM6AQpfg/nHM4BrLeTSjCRobamCCjZoV/ViQqouJDoo8Lr@vger.kernel.org
X-Gm-Message-State: AOJu0YyDjpMa7Mk7kJjqyuFx7ir7NMd3jP+8bMdfSp9Wn2GYByJYAhQ7
	1bXNNxjKFf3rI8WISLJoC38xpuFhcAtmDZIhk3Fc39Rg95mfnIvHUnSACFDErN9NJBSbdHZJxU/
	BAlZ7uHsTzrfwhPR0o7fDVaEu3Z2iqnc=
X-Received: by 2002:a17:907:94c7:b0:bd5:2859:ed0a with SMTP id
 a640c23a62f3a-c119fa32082mr3741666b.42.1782245183053; Tue, 23 Jun 2026
 13:06:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9r8zOQQwDxmHGsRw_9k2eu6r=HU_HiXxbB4cbpwhc1GGgHOw@mail.gmail.com>
 <20260623185618.1488231-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260623185618.1488231-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 23 Jun 2026 13:06:10 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPwHYj284gyyjqnH6Z-NNLLbftKqzoOKycaMzm3+ifSdA@mail.gmail.com>
X-Gm-Features: AVVi8CfBRCr8pOqLd32ZXICvdYS2E-O7_kRR6ISoNTbshVt_za8XIuRuAYI0wRM
Message-ID: <CAO9r8zPwHYj284gyyjqnH6Z-NNLLbftKqzoOKycaMzm3+ifSdA@mail.gmail.com>
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 11:56=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> On Tue, 23 Jun 2026 11:10:32 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > To get back to the question of how the auto-tuning should work, the
> > > main question is to which ratio we scale the swap limits to.
> > > Do we set the swap limits proportional to how much swap is present
> > > in the system, or how much swap is available to the cgroup?
> > >
> > > So if we have 3 swap tiers A, B, C, with 50G, 30G, and 20G capacity
> > > respectively, how much should a cgroup with swap.max =3D 10G have if
> > > it is limited to tiers A and B?
> > >
> > > This is what I was getting at earlier when I said we have to calculat=
e
> > > different ratios for different cgroups, based on what tiers they have
> > > access to.
> >
> > That's a good question. I think the case that is particularly
> > interesting is whether or not the limits of other tiers should change
> > when another tier is disabled/enabled.
> >
> > So basically in your example, assuming everything starts as "max",
> > when swap.max is set to 10G, the autoscaled limits would be: (tier A,
> > 5G), (tier B, 3G), (tier C, 2G). Now the question becomes, if
> > userspace sets the limit of tier C to 0, should the limits for tiers A
> > and B change?
> >
> > On one hand, it's simpler to just keep the autoscaled limits unchanged
> > in this case. However, this means that the effective swap limit is now
> > 8G, which is not great :/
> >
> > The alternative is to recalculate all the limits when one of them
> > changes, in which case the limits of A and B would change to 6.25G and
> > 3.75G. But I don't know if this will work well if we allow custom
> > limits. What happens if the limit of tier C is written as 1 (or 4096)
> > instead of 0? It's effectively the same scenario, but the tier is
> > technically allowed.
>
> I think the one problem with this is that it becomes quite easy to
> accidentally overcommit. As a toy example, if you have 10 workloads and
> 100G swap (as in the example I gave above), intuitively setting
> swap.max =3D 10G for all 10 workloads shouldn't ever cause any contention
> on capacity. But if you start excluding some tiers from some workloads,
> you actually get overcommitting on the tiers that can service the
> most workloads.
>
> I am not sure how concerning swap overcommit was, but at least in the
> memory tiering scenario accidental overcommitting of toptier memory
> seemed bad enough that I wanted to avoid the problem entirely.
>
> > The more I think about it, the more I realize it may be best to drop
> > the autoscaling thing. I imagine memory tiering might run into similar
> > issues too :/
>
> And that's why I didn't include opt-in/opt-out for any of the tiers;
> if you have system-wide ratios, there's no need to change the ratios
> at all, and as long as the sum of your memory.limit for each workload
> is under the total capacity, all tiers will also not be overcommitted.

I think eventually there may be use cases to opt some memcgs out for
some memory tiers. For example, limit sensitive workloads to the top
tier (or vice versa).

>
> Now, all of these complications aside, I think we might be overthinking
> a bit here : -) The auto-scaling should just provide some sort of
> "reasonable" default, the users can always override the per-tier
> limits if they are unhappy with the autoscaled values.

I agree, but it seems like both options are not ideal here. I think it
might make more sense to not present a default value at all, have
"max" be the default for all the tiers, even if memory.max or swap.max
isn't. Userspace can set the limits if they need to. Autoscaling the
limits in userspace should be easy.

>
> In fact, maybe it even makes sense to have sum of swap tier limits >
> swap.max.
>
> (I actually recall having a really similar discussion when I was working
> on weighted interleave auto-tuning a year ago, on how weights should be
> set when switching between manually-set limits and relying on
> auto-scaled defaults [1]. I don't think there's a need to follow this
> convention, but we should think about what the expected behavior should
> be if a user manually sets a limit, but later wants to go back to
> auto-scaling limits).
>
> Anyways, I think these are important questions. Youngjun, Nhat, Shakeel,
> any thoughts from you all? : -)
>
> [1] https://lore.kernel.org/all/8734hbiq7j.fsf@DESKTOP-5N7EMDA/

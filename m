Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C917D46D2D9
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659076; cv=none; b=mmaTfDZzEhoqVY1M++hmZtdRw483sipi0CnRX4FmCQ+dW0J4Ee30dHRrH5i2VVRR+ZI4zU4JM0Y5A2s0opvTRPWlnzpzkqEw0hNjuFq/MtfvH2vzo4ojsOLBtRgo8K5UuyzvMnAE06zK7qD0QPJmQR0rw1r0N64/nirY2+8Ue+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659076; c=relaxed/simple;
	bh=nobEXjEcT6afNEz0cGzi6KLep7xSnO8lTeBmCcWO99g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4QDnaGSuB3nqGkqro6s4VSSSkENyWO3ww1tiBwNcxYawPu0ENljurpO5KGEOSTUA/X1yknQ7yC7u3CokP9Khl6ZfiLrervvHmfPwSAuRdHDRaQpmwX5edDKhfA0WbeyWt1OzkdI7pBN8uYm08WhIt5iTRsnCLb3k+TFkJUUTCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neRUdQxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="neRUdQxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06491F00A3E
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659072;
	bh=8gCO/l330njD+stDZZDZMLF87f8BoqEZxyb0CUTX/00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=neRUdQxBKLqQrRIQNz70wA2fddtdidhc9DCyd5fwMHfjrATKdfDGCWSzXMBQv6q7a
	 Q0YHJz7VFDl91+kuoMq56voRfAJcoUifjQVtM92W2JR0NWrrlOYNNUoH8HeVgSb9/Z
	 SEsqlyTy4THzgAU6Q0siiX6JtXI8UpzbW6YWpdmlQlYhwHbdJHQlobB13mvqfpyZ+L
	 ymElO0NFDOP5+fz8g+DIRCXox+3fi3jbh5jlqbp8rGxWlVy2wqZOt2RCcLw/Vsz5ms
	 o9o+wjt8oplkcUs8C7D2vU45y+DmduDw9sDCNuhY4IE8CEt0XOSF+vaVox4AljNqRh
	 vOpYk91SANE6A==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-80814edb536so87133837b3.2
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 11:37:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrU1ZNM61lEUGLpyas/0h5Azb/e91jeAlYc2Mlxz2m8aq49VEVdIJLA7xx+uUxHQR42x7MOzEKo@vger.kernel.org
X-Gm-Message-State: AOJu0YxY/X3qwDmGAv5n3g9sErH1kqo50vagDqFG8kv8a8aSWlMdwqgS
	Fyqb4pHEKVO/aVTxKAu7VVs988gsswQv52n8Pvhbxlb7relvoBOoV1W2+OjRTvQq778ebx8Xjh/
	IMJWZDJWc9qIKgF9NdEcSiBz4RKoQwnYOoLWqV1k7bw==
X-Received: by 2002:a05:690c:c4c3:b0:81e:9826:942c with SMTP id
 00721157ae682-81ef2174c78mr60414247b3.0.1784659072225; Tue, 21 Jul 2026
 11:37:52 -0700 (PDT)
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
From: Chris Li <chrisl@kernel.org>
Date: Tue, 21 Jul 2026 11:37:40 -0700
X-Gmail-Original-Message-ID: <CACePvbXZ44Bc0=cDTw=Cufr7Mv5794OLza+62P92f2Bt0tfUFQ@mail.gmail.com>
X-Gm-Features: AUfX_myhvEmXsVXoszuyQLbanbBrOMNsp1yYWYSSVM3a0AG2ZrP7P8oBaaZl42c
Message-ID: <CACePvbXZ44Bc0=cDTw=Cufr7Mv5794OLza+62P92f2Bt0tfUFQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 18, 2026 at 8:11=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
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

This kind of complexity is exactly the reason I object to having zswap
as a tier in the first place. There is very little gain in having such
control for zswap in the swap tier world and it introduces a lot of
corner-case complexity.

In my mind, we should introduce a separate swap tier native memory
tier. e.g. xswap. which has a clean conceptual break from zswap
(though code can be shared). The xswap will behave like zram in terms
of tiering, but be more integrated with MM like zswap.

I think the simplest answer is just to allow zswap as a special tier,
meaning it only has an on/off control on the side. Allowing zswap as
the only tier means the cgroup won't be able to use zswap because
there are no real devices.

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
>    nothing to prevent.  Once vswap/xswap lands it becomes meaningful on i=
ts
>    own, with no interface change needed.

Allow it on paper and accept that zswap is not a real tier. It is just
a cache in front of other swap devices.
That is what I think as well.

>
> 2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
>    track the user-set and the effective-set separately.  Exposing
>    the effective one would show that a zswap-only setting is not in
>    effect, giving the user visibility instead of rewriting what they
>    wrote.  It would also help the parent-off/child-on case, where the
>    child could see from the effective value that the tier is off.

Seems more complex than it is worth.

Chris

>
> What do you think? or any other ideas?
>
> Thanks,
> Youngjun
>

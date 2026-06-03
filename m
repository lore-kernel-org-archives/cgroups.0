Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E043E9CE
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780512886; cv=none; b=u+3ggdDR3SC6Y9SElT/cPTibu1iXro2/BEDhL1F1hOB3Xa1oy6bc3wKN7XIzJ+wB840JRzeLIgr41Snm/MZqFEdM36icTZDczIT2vGRFuMbYFKSDG6cGu+YTwRMRyFB93XjW2a+fExJVpsYtBycrmaeJGq85zBYsXDUu2fCOPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780512886; c=relaxed/simple;
	bh=8x0yf4XZC38ntZDLpAhHG+tDFV6Lcp3kBHWEJyViNVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFtcrHzPSlQRinCJj5deWn6CCrxRgD5z5mrathrVHHPGODx4EFX7FBfU9mxz7xMQvLzMv2w54mteIzSvxD63ukBabcXNcr03KT2srx2UJJAgOM2V74VzteVY+gzoGkiSZ61WJXu7fLGzxZZA0x/S4l33ltyheC4KecMf49GEbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE2ejJpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE2ejJpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B571F008A2
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780512885;
	bh=ZFQ4Bd12+v7JeyJgIXsYlF/gFBeRBKKRjCH/poAPJdk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jE2ejJpZq++jtEtDSruv760lUQrefF2Z/UKZAkSHeQttl9hDEmCIXXUlakRX8Bfvp
	 COMQj+dCumWiiTMy1sKrQUTc2OuS9cxWvCN7GJC1i6Dp5MdoZObOUv7MZkAYxxbQpO
	 igfC4iBnnt3+42ycHPjlsUVskJIEcx30umf71Z4ORH+DE6C+TNtvOpzeRokA0axedo
	 Z6Zs3qJO5ta7tNsPZvnvy7vTfRPeGzFUK0hMeKvCirNGhLAuebDYQfhQ6/pyzqLYvO
	 MnAGq1zykStkfQnFcVUee5L0/1zTkXIbMdDImNp64lgv+2EN2ssk5k09sWvrBNfJ5D
	 HQq1o8TgDIt+Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bec449d0af2so522862866b.2
        for <cgroups@vger.kernel.org>; Wed, 03 Jun 2026 11:54:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/0ssI0d7qmFGolqjkL39vt+WrWMmFXuXUzZzNcBfQX0ewhL2/DD61TQcOS7c/c72DCj//YRFR5@vger.kernel.org
X-Gm-Message-State: AOJu0YyOMQ4F2ioz+IhEZD8JgIfwjZ/hPDg0QarsSfIgLVZCKNG5K/8f
	4jWITwZjVVAEJnXxToeroxnCgDEq2hyVN/rGgCC0P49HpMezS+tSiZABqJ3qexxBVgbzgbHnSyf
	Wfn/25sTvK9cdkh5fI6popgR/+f2re/o=
X-Received: by 2002:a17:907:3f07:b0:bd3:32ce:8902 with SMTP id
 a640c23a62f3a-bf0af2039b9mr289938366b.39.1780512884672; Wed, 03 Jun 2026
 11:54:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
 <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
 <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com>
 <CAO9r8zO0GjTeY2+j_AjfTQ8qYOmHezZAV44f=aPgrjJcdtO9rQ@mail.gmail.com> <CAKEwX=OeFsFPdazWFf0tsKTOi3DneX3fCcreEkzwb=BOR_37hA@mail.gmail.com>
In-Reply-To: <CAKEwX=OeFsFPdazWFf0tsKTOi3DneX3fCcreEkzwb=BOR_37hA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 11:54:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNMMa6-z3dxX8uktFA2Hb2EXTxCkeSFG=uosyVS6Vnbtg@mail.gmail.com>
X-Gm-Features: AVHnY4JNisz5_3nlmLGBOhejCJYEaBo7BSD-V-P6mrBpcDy2zK6Jtf82sPe44Ug
Message-ID: <CAO9r8zNMMa6-z3dxX8uktFA2Hb2EXTxCkeSFG=uosyVS6Vnbtg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"

> > > I suspect not a lot of people invokes the shrink_memcg() synchronous
> > > path in zswap store though. Setting zswap.max is hard (as it involves
> > > guessing compression ratio ahead of time) and induces quite a bit of
> > > overhead (obj_cgroup_may_zswap() does a force flush for every store if
> > > you set zswap.max to a value other than 0 and max).
> >
> > Yeah I agree, but I just wanna make sure we don't completely kill
> > performance in case anyone is actually doing that.
> >
> > Regarding the force flush, it's unfortunate that we need to rely on a
> > stat for internal limit checking. It might make sense to use page
> > counters here, which already support hierarchical charging and
> > whatnot. We'll need something similar to the objcg approach to charge
> > sub-pages (or maybe just reuse that somehow?).
>
> Conceptually, I've moved towards not capping zswap.max, and using it
> only as a binary knob for enablement/disablement  :)
>
> It's consuming the same resources it saves, so if we cap memory.max
> (and swap.max until we have vswap), then we already have isolation.
> The split between uncompressed/compressed should then be dynamically
> determined by workload characteristics (working set size, access
> pattern, compressibility) and service's SLO, and reclaimers
> (preferably proactive reclaimers) will drive us towards the optimal
> split/equilibrium.

Yeah I guess we can wait until someone actually has a use case for a
non-binary zswap.max and complains about performance.

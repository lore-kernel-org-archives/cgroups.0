Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F631A6809
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 01:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790299079; cv=none; b=fhGIzlWjCFsD0DweHP85m3GUnU9GxRisQhmi3ERVN0iLEMa4FO7scdWmF6NSYZckjZPUlwxU1LXEeqxfAmX49AIt8KqrTpX8hXa28nXLiY4vYmGtU8czut7/K+wp6m3l8ifPSxQ6+A1bBmM1GQzut4zS6FXU0Kn9T1rq3YE0kA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790299079; c=relaxed/simple;
	bh=7pgp1lvJmujteHrKaVQ44fhUQtN3vF82M9vu1o2x/M8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fp9dQYOOKRbpDIPc3OU8x0L3QTphxZs12VRwUJFekcmbPe5nN37Px69kPGJYMa8ncuoLJUoM+7vpZXtlgdOdwICFMc3dIGBgMbg+stKYF2Fa+lBzSaYs9NmgH6wc7DNtwRBWf8dzmcjTCRmSRB73CrHgKtCcjz6b8z/gGvLAvRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InC5clUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InC5clUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E761F00922
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 01:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790299076;
	bh=Qzl2iBr4Tj15bSdJUmjfa1MoXknfSugmmEugQM9ke00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=InC5clUn7OGfPux7wuIu5zfCWb0FPfhELihWg9rLnTJruPYkE4SewjY/4Ep5ZpsVl
	 JJcbf6Ii/vC771FdXhntsG82Zgfdz0mp3BbEmNTBlWPSaQ/1lYKnJmU5odnG+K9nS/
	 uHHPWQH9uk6brE3Mex7jhw+rGLNHPelRogD+pW+ze/5hEoIqJf+HccFkaEZBg9gsb1
	 CjkEttImXmU5C34dyCVKEUgZvM5FQJJzOiENh2iy5XTA5CFOtD4QpildU/wp4iahCm
	 PCyo6/vLXf5prijbOrCCyHGf9vRVX9K8AaUXiiHvVyy6bWjhEEmH1/ncr6HT4tDS1e
	 /70ZoeD/sWMDg==
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-673ba589d0dso556413d50.1
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:17:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwi5AxBUF+YaPLwGMPyEJ2HYghrE/cJ684MM6Q0ApM7mdkO1nLXWyCbAqBY3QWKiXVBkS9E/uhd@vger.kernel.org
X-Gm-Message-State: AFuF++lQYIF34V1gXj3AxGols7RI3UE/exyNsChAL9BKikqq5uH4LlJz
	LFoktDd6im4MfaRyzHe/CCG6SRgr2AUOsLxQT2NZXqCmko9MYRCrjs52leny4/U1HyEBBeNJIs+
	rqWAXYLdAbJtmGfir8sHF/g1MqnuhpoeeoSzbB2LpUg==
X-Received: by 2002:a05:690e:1207:b0:672:a068:8e43 with SMTP id
 956f58d0204a3-672ed9cdf42mr2261456d50.100.1790299075721; Thu, 24 Sep 2026
 18:17:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com> <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
In-Reply-To: <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 15:17:44 -1000
X-Gmail-Original-Message-ID: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
X-Gm-Features: AclHuK8BpPAFHsVgO1T4L8qwA8U0X0PC1mEcUr8J1TqFhwVtyy2ssRkAaIFOQOI
Message-ID: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 23:18 -1000, Chris Li wrote:
> > On Fri, Sep 18, 2026 at 1:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > >
> > > @@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx *ctx,
> > > struct folio *folio)
> > >         if (zswap_load(folio) !=3D -ENOENT)
> > >                 goto finish;
> > >
> > > +       if (unlikely(swap_is_vswap(sis))) {
> >
> > There are too many swap_is_vswap() in this series. It fragments the
> > code path, making things harder to reason about. Esepcially around
> > locks. I count 22 in this patch alone.
> >
> > I consider this the biggest drawback of this series. This
> > fragmentation of the code path.
>
> Could we avoid that by simply always having everything
> go through the vswap abstraction layer?

Yes, but it will pay the price for going through the unnecessary
redirection layer always. It incurs performance and meta data
overhead. That was one of my previous objections to the earlier vswap
version. Sorry I enjoy micro optimization too much, that is both my
strength and weakness.

>
> When everything in vswap, we don't need to test for it.
>
I've been there and done that, the result was pretty bad in those
earlier series.

> Handling the details of what's behind the vswap would
> be handled one layer down.
>
> Chris, do you think that would be cleaner?

If it can wrap below the swap_ops, it is just priviate inernal dedail
of implementing its own indirections. That would be much cleaner. That
is what I am trying to pitch to Nhat in prevoius email but does not
have following actions.

Chris

>
> What am I missing?
>
> --
> All Rights Reversed.

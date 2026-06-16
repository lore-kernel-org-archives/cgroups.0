Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471FD384238
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 20:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781640645; cv=none; b=YymRIQ4SiKzbAippDOFF8ciJfTv7JvzK9ImfxkSz3F7yrAIhR6AYOmQhkKwjleR0ZSRVoy7WE2lurhXPT7bKuSc6pXGDqq02rThdcWPOGvGLW4H1gz68PZWIu6zcbAI16uoONGx01sLm/NUa+s+00cRQzahZ2IlcXR1mzwZ5TZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781640645; c=relaxed/simple;
	bh=0uOtT8/BsfLxeL0Oxfo+dYM0SBRmE8TcCl0uwOZ9IvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D5zhU9q2goqpCCcvqAsaMTJ5J5yTURTZA4OvqKcpGMx/Y6AXt0E6LHa+NraNHAddqsS+CmxSbIILGfZUl4qnamz76Xb+a6uOcAxN086D3HQ50HvtQjpZgs/jbVo8J/88Al7QimvSJ/zKNlFYqD9N0o3MzLvir7Ul77A0ga4GO/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdpaMAzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdpaMAzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8A01F00A3E
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 20:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781640643;
	bh=0uOtT8/BsfLxeL0Oxfo+dYM0SBRmE8TcCl0uwOZ9IvQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HdpaMAzbdXv+tcQaaH/P3IZUNYftwYZtjZU5eS+rlXYbfJpg3re8v+qZjrfqodXcT
	 BZIciI6/ddDAzuTZcRJPe7LV7ZpNr4hqOaBaHpA1AGaxMILIP899PmPVXroeIwBxt7
	 uOTmQ3QHXXGprl5DaXfS1M7wO/Lhmt+VBrfgWUbyMG+mUV9oG02f9uJc2XiZwWVAH6
	 amkOKGt3oZaDb41BxPIZ84nShBcABl37t4wb8yS/2fgCkW5zgZYRCrncimOX9YbZkd
	 YjfRlZxhjyuIhzGwO0USB8WMBEez2QCRmAivONkUOKpHg02zc6CcH+8p4wswZZcbzV
	 xFL0EhgtVWHBw==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bf0170c80f7so849550266b.3
        for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 13:10:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9wGo99QsrFCxPbBwH6a1j74TFHw0e+1BITX/dqGthbnXYiZfiF3xvUh6O/dEkmkmKgVO45Hium@vger.kernel.org
X-Gm-Message-State: AOJu0YyHl5SoYiV9uX/kId3m7DAhVvMaLaZvjKVbDSaatLaeymSVJvMM
	VymMcUVmwqW8KWIOznBXuU6IHfH+RbiHnKO2Uw4x+acRNV/DZznIswyh4Ep+4nkU7qKpQJCPKYC
	iJKFnwA1XfQxbKTLJogDkgb/e6wfFPWo=
X-Received: by 2002:a17:907:75d7:b0:bee:776f:4ed3 with SMTP id
 a640c23a62f3a-c05a6ae1d83mr47433366b.33.1781640642868; Tue, 16 Jun 2026
 13:10:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
 <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com> <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
In-Reply-To: <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 13:10:31 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
X-Gm-Features: AVVi8CfaFdE_HVpQiLAzPF_cAqyI2J719pmKZCzdgUbBAcxL4DEQvvkOPtjV2Hw
Message-ID: <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2026 at 1:09=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jun 16, 2026 at 3:54=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> > > TBH, without vswap, we should not allow setting zswap as its own tier=
.
> > > It's meaningless. Maybe makes it a no-op, and warn users what they're
> > > setting is gibberish?
> >
> > Why? vswap is transparent to the user. Why can't zswap be its own tier?
>
> Without vswap, if you set zswap as its own tier, which phys swap
> device should we allocate from for the backing slot? :)

Today we just allocate a swap slot in a swapfile during reclaim,
before swapout, and zswap will just writeback to that one. I assume
the same will work with swap tiering, except that maybe the way that
swap slot will respect the allowed swap tiers?

>
> With vswap then it makes sense (and would probably be the "default"
> for zswap setup until we enable zswap writeback).

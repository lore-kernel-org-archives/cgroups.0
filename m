Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ABD3793A9
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781639681; cv=none; b=dkG5ANnSM1bXM+ST7UdXo2dEJjcZ8k7RUItHWyKpYe35XaUi5gmH0IV9fg/9BDELahHfdumeZO55b6IRLtQwkH3SNVIy07SqTP2xbag7mRm77Yk+FNl+/C+4THP/4f/v/U+kGUw80vpMueCDeiRfHuNKQ7wCNBtQZBFeWXU9VBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781639681; c=relaxed/simple;
	bh=NTXBHsYNWAEPAB3WHur1qy0Nd9bML5BpGZ6ySkjPb0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jiq1aP/KEvM4zAweTKZT5/pXSu3mP6PZsUg9lvtcnlTZSopMMZc/GuUkTbhbmFWzXGxeiRWB1Dsl6g8tqLFo8NDi3MF2Zleqisb7BvQLPtDkPfHfdetZVdNKDcSSR1LRwOa9tOv0SnHLUz3zxh3bTCEpX8tkgo8p+oZIHx6Wj4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JS1CEPM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JS1CEPM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C131F00AC4
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781639680;
	bh=WsFleb3h7HVa9Owq6c5tqmzQO4Gd0VwPEzAt0GlErL0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JS1CEPM5WPbmbrvCbVO5+FZn/GYSIreqCzVUD61BQ6ULMLDq1uOCnsnNHvCwNbL0R
	 8dV0ZVasaoT7gugCdF1tw0zurWWRsETsRHwGwdjrFKPk7DSZcoxJi7LS20SgULbVik
	 7jbxw5ep1Ap4UxdmkWdtS56G9hsJpc/wrb1hD0xycdYWapO8MKLGQ9N0GyqXf7Bi+4
	 qLhn9Rj9Szbz21kxW9yuxGAGoYyVaNtKnBtQgcV9nTktt82iO56uOH/XMZiX7zUY5p
	 Cobl3nDdM5kWsVtLNgtPtuAxi816UclkD4TBuZklId4kPpMggu4DWQgMkIxJkmlWqV
	 xmwuiXEcnLmSA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so36344066b.1
        for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 12:54:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8d4jyVfRuYYg/sNGITDejopSk9AMLILHTelImun07a5wb+lvWQ6T8W1/c8tJ5UR+Nu+MfZ03Ub@vger.kernel.org
X-Gm-Message-State: AOJu0YxlLqMBnxJkLjvhX5ExPWSRUMFyLmlKYr7hEZSkos/HgA5Pl0U+
	AxLEvj1+oKOUuonf6rLDyIhTHEZB6yHE6xUwT0TUBb/o4AvkjEc7bHDC3Sr8LQeGwpPw0qV3JYf
	7lFsKzuKogTdplsZmsPUkcRfRQq75bZc=
X-Received: by 2002:a17:907:704:b0:bec:1632:ece8 with SMTP id
 a640c23a62f3a-c05d75c4721mr7784266b.15.1781639679768; Tue, 16 Jun 2026
 12:54:39 -0700 (PDT)
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
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com> <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
In-Reply-To: <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 12:54:28 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
X-Gm-Features: AVVi8Cd9nHylszomRw_rh9bJO82Db4NrHN8B87fA6yRA9MBwH5p_UAEEXHvDHNw
Message-ID: <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
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

On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Jun 16, 2026 at 1:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Mon, Jun 15, 2026 at 8:08=E2=80=AFPM YoungJun Park <youngjun.park@lg=
e.com> wrote:
> > >
> > > ...
> > > > - "zswap tier only": Only zswap is allowed. Fallback to other swap =
is
> > > >   blocked.
> > > > - "zswap writeback disabled": zswap is allowed, but if zswap_store(=
)
> > > >   fails, pages can still fall back to other swap devices.
> > >
> > > Upon double-checking the code, my previous clarification was wrong.
> > > You are right. Sorry for the confusion. "zswap tier only" is indeed
> > > equivalent to "zswap writeback disabled".
> > > (I'm not sure why I read the code that way...)
> > >
> > > As I initially thought, it might be possible to replace the zswap wri=
teback
> > > control with the tiering mechanism.
> > >
> > > If we need to keep the existing interface, we can integrate or share =
the
> > > underlying logic (though the specific details need more thought anywa=
y).
> > >
> > > It can be summarized as follows:
> > >
> > > - "zswap tier only" + "zswap writeback disable" -> meaningless (noop)
> > > - "zswap tier only" + "zswap writeback enable" -> meaningless (no wri=
tabck backend exist)
> > > - "zswap tier with other tiers" + "zswap writeback disable" -> uses o=
nly zswap
> > >   (can be replaced by "zswap tier only". This code could be intergrat=
ed, modified or something.)
> > > - "zswap tier with other tiers" + "zswap writeback enable" -> works a=
s is
>
> TBH, without vswap, we should not allow setting zswap as its own tier.
> It's meaningless. Maybe makes it a no-op, and warn users what they're
> setting is gibberish?

Why? vswap is transparent to the user. Why can't zswap be its own tier?

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498112C237E
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789952013; cv=none; b=jmPJ7so2/X6lAf83QvyvyN9gtonBtyk4FUMWJhBTicV6WGlcySTcgTkDmr5z87FRFiImrft3OWv28f+COYZRIdglhPOwBBdz0YNt7uCEMSl9aIfI8TU66uxhfelmis0SNKfkdTdcuM9u93YqW4Xg+VcVLHRSt5XRE5wBhsPYOaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789952013; c=relaxed/simple;
	bh=uT3QSlJyDb/QyaIb6RQq4e3wjco3xR5/xUinc0PHAM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BgTDqBBfOsYHxt24NXl5G/XZYd5G+vQ03Rnow4Kbm6Rj/j5/q2EeWY264UNd8/FXoLUAh4JaZFovAmwNFztpznew9sDOF91puYlqGFeQip9Vzr/CHdGGmzzKv/8RZWL9ICZ9VLHJ+ylNFfiSSm390WncJh1SP/BJq7W9iny/zvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNf4VhZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNf4VhZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E001D1F0089D
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789952011;
	bh=uT3QSlJyDb/QyaIb6RQq4e3wjco3xR5/xUinc0PHAM8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kNf4VhZuDIvhoHhBEgS5FaNAtmLQtbFJJFaWFUSiDrsrgInPvblGDRq9u0mULquuN
	 tZyzw3ixN9O4u1QAB64hMMVZMg3hmMC+zByEs1PgUohC64XLZKy4hmToq5yzrIuJTm
	 LPcqA7i8AdE/fTV3LufjoZRYPKfbFuUG+exErfNeRLQR8mmbLQuKAkSX6JBSXpETAe
	 Xyg69lEkgO/zPs3I8NKTSURat+Pp1HH17/p+GNEU4e+F+ruHhryYc8XHiAK0a9Uh7R
	 tuyjb0EZiTtyI+dA7tTm/rYnTtfiULxcMFx3Y/1JUTui5eCDWkDCun6bvABQi34ss2
	 QI4Y59T2L/oNw==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66f943b286fso2041333d50.2
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 17:53:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByHEaF3d8AwwYCE8hMef4YUjHGFWCB+hbrTWsKd8z/bkjO47twNFJ34hShniCtwMmMCB4vHNpll@vger.kernel.org
X-Gm-Message-State: AFuF++mLoyOOKmWkEtyUwwpaN7J6n4KAcpx42YooPcze3Kfddpaouegm
	0ZQpvn6PlO2G//dUlDWo+wQZnq6gFUJx1/i4BxBm3u9U8oqBytD9jhTwWCpPnOGJt/VlNXNLTc0
	Hzm/bFZiqW0Odq6ZVo1TnZEjA69+CvLos35TOupe0tg==
X-Received: by 2002:a05:690e:813:10b0:671:2228:1137 with SMTP id
 956f58d0204a3-6717fcd026amr1947180d50.44.1789952010724; Sun, 20 Sep 2026
 17:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
 <aqU81l1oqGItb-0C@cmpxchg.org> <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
 <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
 <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com> <da13e0e48568da3ccccc304aeb449ababf085e14.camel@surriel.com>
In-Reply-To: <da13e0e48568da3ccccc304aeb449ababf085e14.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 14:53:18 -1000
X-Gmail-Original-Message-ID: <CACePvbWg3be1KippqraPp6xV0xkrtw0ZAW74tFj8so83+t55dw@mail.gmail.com>
X-Gm-Features: AcwNN1UZiIocWVlz0qgZ7OJFByEl-O8xTB4E1qJAixnrA0sBJyczejwjOKx08OA
Message-ID: <CACePvbWg3be1KippqraPp6xV0xkrtw0ZAW74tFj8so83+t55dw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 2:36=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sun, 2026-09-20 at 14:18 -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 3:07=E2=80=AFPM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > >
> > > > For our deployment, we only compress about 7-10% of the system
> > > > memory
> > > > before performance starts to suffer. The feedback loop will scale
> > > > it
> > > > back. I am very curious do you have actual work load to swap out
> > > > 100%
> > > > of the RAM.
> > >
> > > One common workload is a web browser with idle tabs.
> > >
> > > Those often compress pretty well, a ratio of 4:1 is
> > > not unheard of, which makes it easy to fill up
> > > 1/3 of memory with 133% of memory's worth of compressed
> > > memory.
> >
> > You did not answer my question. You are talking about user-space
> > processes (browsers). Do you run your browser in the data center, or
> > is that a laptop workload?
>
> The browser runs on the desktop, but the same
> kernel runs on both.

Interesting. The desktop is having a GUI or headless?

> The things we build here cannot be optimized for
> just one single workload. They have to work
> everywhere.

Sure, but on your desktop or laptop, what is the max amount of zswap
swapout compared to system RAM? It is obviously bounded somehow. What
is the actual number across all your deployments? You don't have to
give me an exact number; something with one digit of accuracy for the
maximum is good enough.

I am wondering why you keep dodging the question? It is just a number.
Do you not know the actual number, or do you not want to share it for
some unknown reason? I shared that our deployment commonly uses 7-10%
for zswap.

Chris

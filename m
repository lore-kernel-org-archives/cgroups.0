Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6672D315D58
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789802647; cv=none; b=c6xu5xf5KqCKGxXL0oNJi1QsPhXritjTq9v8Prb7kgUbnnZUn6HEDo36D7lIBZ52xaTde6/yXC8KkV1xCzLYwkf6NGVM3RwPHbOB1MWc/3/nb5v2FA7sfFvlDWyWuDW0O4SyVXWKRh35p5XbSAAqkCEWl1I8qIclGb/EwSJESaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789802647; c=relaxed/simple;
	bh=CcwKFo/x3d7KIrwrdSc6FIvo/aUmSvp1opSXGURZ5hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eb6Q/ODxmqJf1l2u40Q6IzwTycCal1MowfeGyaB7VH4ATl9kGOH63sEuEw6iX2wcOnisCTabgxIEaHSG7C6tsLmhGhKskdVPOEDwbqllRvaR6X+hmcsJ8q6/ZFVN0LvLFw2hxtjEDXD+FrY1eCNcLmJr/hZThT/xl2W5GmN7HaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UL7fUD1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UL7fUD1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8F31F00901
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 07:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789802646;
	bh=CcwKFo/x3d7KIrwrdSc6FIvo/aUmSvp1opSXGURZ5hk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UL7fUD1R+LFfRdNyW3BYbQT13vuIzvV9VwxPU0lGVypZMMtFBwv8hMGA3f6+g2jXc
	 FSMv7385C4wyeX31P82/p8Vlsqz0rbOTA/FwhmYef7KLB2CqBkic40zrVshI6+7iKb
	 /8PLo5AiSkgoXdsC+XuO5IC92XdJaQVs1ffGGXfl55qM53lVC47M9hlEsTtFwxmj4j
	 /No8o+O4Bb4IJ9QUh3IZsORNIlcw62NrjY0wS1Vz0LPicbigMk1SWE9LG9DB6tfDEH
	 KAd6OZYR2KzufTieJL2FIDnOKJxNuBN+7dIryv3mm8+96VrfroaeZ4II1SPsJ1TkAa
	 6E4CmL3ENNGrg==
Received: by mail-yx2-f39.google.com with SMTP id 956f58d0204a3-66f7a9afe43so1263247d50.1
        for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 00:24:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByua1x7Lb4Bi1g4+kcxA+DYfYTCFIybT7pQcu43BH9reCv0W8CMDgcuhrWbIUFQ6KfFptgE/GQJ@vger.kernel.org
X-Gm-Message-State: AFuF++lRgL6wH29urmR51s/vs7seKOGL9TmjMEfHBpSJoArS8QQivXns
	Z4ADfg4MUNzWvGAvoGao8Uaf5fM/ec6kpXwqT/OmW5q2qHI/uBn0csEALb46oY+cIAoxAy+j5Zw
	DALEwJl1VwMlKgzyXLdNHgFrwXK/nQk8XA/uU4hCnAA==
X-Received: by 2002:a05:690e:4504:10b0:66b:14e5:d226 with SMTP id
 956f58d0204a3-6717fcca387mr1086959d50.34.1789802645443; Sat, 19 Sep 2026
 00:24:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com> <aqU81l1oqGItb-0C@cmpxchg.org>
In-Reply-To: <aqU81l1oqGItb-0C@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 02:23:53 -0500
X-Gmail-Original-Message-ID: <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
X-Gm-Features: AcwNN1Ugv2uKjDvI3UlN6yWV2c11EGmbN_5p9iXtBCp6zavSXduB5hlfoQJWQ5A
Message-ID: <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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

On Sat, Sep 12, 2026 at 6:52=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> >
> > Is the limit, the heuristic exists only to make "a seriously wild
> > allocation fail" (as documented). But on a vswap-only machine,
> > reasonable allocations fail. Common swap devices, zram, or xswap don't
> > have this problem. One could argue that the size there is just an
> > optimistic guess, the compression ratio is not controllable. But that
> > heuristic is a guess by design, and a plausible number serves it fine.
> > "Unlimited" seems break that.
>
> That cuts both ways, though. If the configured compression space is
> large and compression ratio is poor, it lets through allocations that
> can be considered "seriously wild" for this machine.
>
> It's a filter. I wouldn't say that letting things through is evidence
> that it's working.
>
> Since compression space is backed by memory, it still makes sense to
> me to reference this heuristic to RAM. Cut it off at 2xRAM or 3xRAM
> tops if compression space is available.

What is this "compression space"? Isn't it just a swap entry allocated
by vswap or xswap?

For our deployment, we only compress about 7-10% of the system memory
before performance starts to suffer. The feedback loop will scale it
back. I am very curious do you have actual work load to swap out 100%
of the RAM. I find that very hard to imagine on servers with huge
amounts of memory. I would love to learn more about your swap fault
latency history in those cases.

8PB discussed in other threads seems way too excessive.

> That all being said, I've laid out implications and concerns around
> limiting compression space in this thread, too. Collecting pros and
> cons is fine, but if you bring up cons for the unlimited case, it's
> fair to ask that you engage with cons brought up on the limited case,
> too, so that we can weigh the tradeoffs.

I think having a kernel config with a default that works for most
cases is good enough; maybe add a commandline to override it.. e.g.
200% RAM. If you worry about overflow, you can set yours to MAX which
is ridiculously big. I don't understand why you force others aren't
allowed to set a reasonable default. I do want to have a reasonable
default config. It should be configurable.

Chris

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E972576E
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789949614; cv=none; b=O0qMfV64SnavLCI0RE8q5URU/EWNKqoln0BElRwyolDa7ZSK289JxZUOLp8XsgCiZoqnRXO/dK7R+GOwT88yefnF4KvWBNma8teCm0PPZsi7/m7VkEkL6n4sdbeLyLpLUmIQr3xdQnz/NkEGSWtTUQy3j32wB3X9acwcFeVVMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789949614; c=relaxed/simple;
	bh=HLIBdJTyhNKEU8IfU998eafr8kKCVMQcTkJyIlWnSvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m3vBZgkPBInn6RYGvGqEajCzC1iiuoBhm7Z0weCnoS6Z/dbgcf+rmCZKNtGmUQsoxK4zzXt6Zw8ac1bug7oT7EDsQnw44V4NISLj8jmOz/utsJJhcaEkVb5Ch8r2o9lL54slJjiy0H6eL//nbgiZHwKamlaDs+EcLHuXuBeNaOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdVIkqhM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdVIkqhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FB91F008A3
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789949612;
	bh=HLIBdJTyhNKEU8IfU998eafr8kKCVMQcTkJyIlWnSvY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bdVIkqhMFVkB7TVrZddIKlNhMId7CVLPNFOIYhTBvMfZlq/+ND7W699t8IzRKRpgy
	 Ycn5OZdY4+dgSygoENccSUhU327aIO3bl4msczwgTQNWIz/t2VoI+FRR+ZjqspGr2I
	 aqguGuBXvR0MA8+3C9cFp1UWTpqxWWYVjEdFQ4Z+huLiaX5wFo1njy1A4BQ1IgdOPH
	 bOdU0oA+12EaDez8p+g8+VcuyepChvAoZRLc+uexGe0BYlD+wbIecJ1SzaWgfQYkLJ
	 sM16SDKdXJxCdXHHi0whETmv75bqS3r7Oyz3yUCEXyjs+ZvvGLHeLZ9SKOU6SYTZnD
	 94E/Xy7BxNenA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d881so2282620d50.1
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 17:13:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwU2w8Y/V4YQQu0LZRmRhhHcGA6nu4T6w97/BDnNsBSCsc3Yror59aqXBMCUQ261AmqZh7cU8mv@vger.kernel.org
X-Gm-Message-State: AFuF++mWwkHmGjOn722hHVVeEr94S2Mw3YUXb4AviW4/1pshmwzMnSIA
	aEUU06kTKWVf1qZg7nRr6dUsm7bkfqHQek6aS0qqLSmwSM6kJrdbDmmtdflKm0vtMYv+MN5qDtA
	xfShC3f4I+sVndbxrignsEoTO6gVthmB6XUJ8uR9Few==
X-Received: by 2002:a05:690e:4183:b0:671:27a:df14 with SMTP id
 956f58d0204a3-6717fc74349mr2563663d50.20.1789949611648; Sun, 20 Sep 2026
 17:13:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com> <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
In-Reply-To: <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 14:13:19 -1000
X-Gmail-Original-Message-ID: <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
X-Gm-Features: AcwNN1V4--hMjboOC0TrbzcbPbb8njndB64L4hTOvsdZJ08v_ItIqBCQ_Dg6snk
Message-ID: <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 12:50=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Sat, 2026-09-19 at 11:21 -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 6:16=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> >
> > > However, I believe we do need to take care that
> > > whatever design we go with is actually able to
> > > support the end user functionality we want.
> >
> > Agree. I want to add that we should support new functionality without
> > sacrificing existing user functionality.
> >
> That means things need to work both for users
> who want to configure a zswap size, and for
> those who do not.

Sure, I don't think it needs a syscall like UAPI. But I do want a
kernel config for the power user who knows exactly what swap VMA limit
e.g., the % ratio to RAM or the ceiling=E2=80=94they need to use. The rest =
can
use MAX. VMA is a resource, I don't want unnecessary waste large
amount of VMA address. Other use cases legitimately require a large
VMA. So, power users should be able to set the limit if they know
exactly what they want.

> The cgroup memory.swap.max is an existing
> interface that does that on a per cgroup
> basis for swap, though in practice the
> limit mostly seems to be set to 0 (no swap),
> or to max (no limit).

Ack.

>
> memory.zswap.max does the same on the zswap
> side, again mostly 0 or max are used.

Ack

> Are you saying you rely on having something
> like that at the system level, too?

That is not what I have in mind. The example I have in mind is that
zswap is charged to swap counters. Changing that behavior will break
our current deployment and that of many other. Kairui give some
example as well. That behavior should not change.

Chris

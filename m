Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBA651DDF1
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083979; cv=none; b=Twvwr8xhpoRtnuO8lsghENHI0OadVA2r2s7dP4J9JmyV+jPfBWg2SZLB4lIQqWbu8zyq/ao3o1kwfB5yPsYqCDtqLW4G/d9qEGgBycHYq5q1HIG/x3wAZFvZYGkkAXyoRI7VMwdKcXPfph3AgxOodFkWCDmraC6aCFNELtUgYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083979; c=relaxed/simple;
	bh=XBoYOklnPu88vK9RRRj6IwCCmmnuin6PxsANDQvC58Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qe8AhYsEfU+kBQuPsh4dDTiGFQFXXOxXHm4O9wf5z+JssK7TkpN0jdpkfR7usH3Y/8qIjnasW0Uyiypv7X/3YNTiMZGn1k0efUyFkxgoxS/nvKbiUl0Ux0ZqhC0coFzrGl4+dg1nvsZub0ym0weZynbxRee8+4s0Ri6bLUkfcNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIySCgan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIySCgan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B9C1F0089B
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083977;
	bh=dkPNz2P0GmPt8JTDqC/+9M8S8tUg25zEaPhZ23h9wAU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kIySCganHfrL8Ma4xTfrOF82/qptn10xWsuBIt6ZZhJb8xJ3/VkzIJCiOzHo55yoc
	 fWP9psMeOmpm8P7P9u3JViO5LKizOrhQ3IeZl0Djf0s8l70QqjGgluyaYei/nLZkWz
	 m0zznH5vyqC23KeXnvXevVILFJ2uP+w4TDqPDIf/rlMyZ4y1+6+ngNOznRYK1p2/rM
	 Ke951l2Fu2bBLIRSVDA/V2AVP1AZN0AvjUTA9Gk0M/9+z53Y+bRPhNilUYlaj2R0Xj
	 kFscESc4vV4d2weiL2EjYupqM/Usz+BdhEQ1+LfHaLHBnn1TLv7WfrzRcVntzEKs02
	 bRPJTCoTDU+WA==
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-67109935888so4102525d50.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 06:32:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzztUGpLdCagw/OcqFp/e/IO7PmN9Dwq7Z9DuaSfnWAbIGdiHkjkQWZfcuLMvqcSk2WX5StqsR1@vger.kernel.org
X-Gm-Message-State: AFuF++mKck3iZG33Zc4zK4CvfHRPK9RsneUEhV294KoFiP1HxFerN2X8
	lbJQbrEzfdYhHNOBQvoRppwAd0Ns3dXa0w8RyC6eiYnIZX2nGq6pNKi5PHNm8lcNo7MNM76pnrU
	KRcbwNxEOCApPZA5AGdB7MavuCO92A0uiZ9HM6X2fiw==
X-Received: by 2002:a05:690e:1286:b0:672:9d86:1f74 with SMTP id
 956f58d0204a3-6729d862a68mr4177975d50.86.1790083977249; Tue, 22 Sep 2026
 06:32:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com> <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
In-Reply-To: <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 03:32:44 -1000
X-Gmail-Original-Message-ID: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
X-Gm-Features: AcwNN1WGUeHiJik3SyidgEFV10ZwS6Bq5wQ8ITt0Pl7xiFx154xhR_QV0CV8YP0
Message-ID: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 8:53=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Mon, 2026-09-21 at 08:10 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> > > >
> > > > Give me some real-world examples of people hitting this kind of
> > > > limit.
> > > > e.g. MAX(%)  > 100% and still have a usesable system. I suspect
> > > > that
> > > > with 100% zswap usage, the system becomes unusable. Please show
> > > > me a
> > > > real world case that proves me wrong.
> > > >
> > >
> > > Here's my desktop system right now. The amount
> > > of Zswapped is more than twice AnonPages, and
> > > the system stays perfectly usable.
> > >
> > > $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> > > SwapCached:       252340 kB
> > > SwapTotal:      41523604 kB
> > > SwapFree:        9802088 kB
> > > Zswap:           8812236 kB
> > > Zswapped:       24927876 kB
> > > AnonPages:      11615760 kB
> > > AnonHugePages:   1402880 kB
> > > GPUActive:      13112428 kB
> > > GPUReclaim:        95980 kB
> > >
> > > This is also an example where I cannot really
> > > predict how much zswap space I need, because
> > > that depends on what AI model is loaded,
> > > which drives the GPUActive number, as well
> > > as the number of browser tabs.
> > >
> > > The system is perfectly responsive.
> >
> > Great, that is getting somewhere. We are talking about actual usage.
> > I
> > really appreciate that.
> >
> > May I ask what the total amount of memory (RAM) in your system is?
> >
> > I am not asking zswap compare to ANA memory. I want to get the % of
> > the total RAM.
> > I assume your desktop has more than 8G of RAM, right?
>
> Right now it has 64GB of memory.

That is exactly my point. You are running 1/8 =3D 12.5% system ram.

> However, if I were running with 48GB, I would
> need MORE zswap space, while if I were running
> with 96GB, I would need less zswap space.

My claim is that, if you run 64GB zswap out, with 64GB RAM, your
application will have >=3D50% swap out. It is unusable. The swapped-out
application will likely slow to snail or crash way before that.

>
> How can people be expected to figure out how
> much zswap space their system will need,

My point is that, I haven't seen a case where the application is still
usable with a reasonable SLO when 100% of RAM is zswapped out. The
example you just provided also correlates with my observation. In a
real workload, nobody in their right mind would want to zswap 100% of
RAM out and expect a reasonable SLO. You are running at 12%.

> when the amount needed to fit a workload
> does not have a positive correlation with
> the amount of system memory?

It absolutely has a positive correlation with % of the system memory
based on my experience. The % of memory swap out has a very positive
correlation with the thrashing on the application. You have not shown
any data point for a system with 100% RAM swap out. I am not aware of
anybody using 100% zswap out. So please educate me with the real data
points. I am curious how the system and application behave at that
point. I have done many swap stress tests in the past while develping
the swap stack. At 100% you will run into all kinds of OOM thrashing
issues.

Chris

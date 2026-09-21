Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0604BD78B
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790008390; cv=none; b=Hxx7Nubs1fsuGXT376TT8gfCuQSszG5xxO7ZgK/sOZ57Pi0hP4qMAbJhe8R+C4+5Pmqjn4V5sP4VCXCq/SF2FYCwnjPkmmKFMOycZb1xPJAFJwUxtPcXgB4/ULtLpk4NL6FMmK8FgJkS9afjA19z+SBq1A9LforBT64szgteZLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790008390; c=relaxed/simple;
	bh=ljhEfVGH978SI5rwzv0nViVgdoCQOccmTWn2y7iEEKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lbEbKr4aTUolDXg/2VWnkYgymfz3D3DLY2r/yuh5n5zgMuMHc57rHxfO0zo64mTm5cP3Dea5eNZb+QAOp2eNJ+YFwmLVhVK9+kDWMnz0UXFxNJhOrcWvnYAiwiwxdrYz9J1md2ir+zbBRz/U8xCOt7P3aGuzi0GhxxdItm2nzL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSWszFqe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSWszFqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD81E1F00922
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790008388;
	bh=mSsGiUnjBfIVH4aIMRBngHnw0miI+1j+1kMwtWAY0nk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZSWszFqeIM3oVci5qOaLvTHaRQQQPkw47ACjVetKpvbozZKK9k6Rg/o3N8qwPbV1E
	 0p+J0WkQfdJ7V58nHfKMqCyqtdK0hGUVP90qkpYqocQmlZdSfKHAQBSoRcFCBPRu63
	 PZKBNX0Jj5WXR694WZe8S9+UTk4fW3In1lwiA5oQXrEeXkW8MXkHsjRpHnTe7jkmLn
	 x3/j4WaxdpFKqDceTl7gLz+qnkqgkftKYTvKHfistiCSP9BbmYRZcGm+eFuLEzTMN7
	 Ht5fXeeCgfdYH0EZBJrahhyqhOjE5DdezwFkwu4qqjDgW5Tu+diwd2J0h+skpfx/Q0
	 jCkgDsKTQ/lAA==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc9b6e3so36951166d6.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:33:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwcd7hW8vfp/xNNxAEPil6+fY/h/SC6t9LEnGToPL64pC0mR5IYuackb/UX6swkUjzJ3OjuEpG/@vger.kernel.org
X-Gm-Message-State: AFuF++mtXFG9B669HL+vWGCCls6WyT+FUJywS4aJz+X+23lC6A2yR3rz
	CCnMP9vajmAUWOLsmZ109xWv4mwPw4Pa4XJihJlR/JNP6KisIfRmGEmKxV3VS8pe0p8um+KXJTE
	stCWdSUyW6wfAziEZeAZ88Esc5StRCloDipWpdbgl0A==
X-Received: by 2002:a05:6214:3189:b0:8ef:4ed2:316 with SMTP id
 6a1803df08f44-913fc89c6b1mr13626766d6.1.1790008388078; Mon, 21 Sep 2026
 09:33:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com> <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
In-Reply-To: <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:32:56 -1000
X-Gmail-Original-Message-ID: <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
X-Gm-Features: AcwNN1Wls7uTlMdzUx2NaKrVB2a8frk5ExiBQUGh6oMRZW91iPxl9mt8PiW6wP8
Message-ID: <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 3:27=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Mon, Sep 21, 2026 at 12:01:18PM +0200, Kairui Song wrote:
> > > First of all, the traditional swap counter has a very well-defined
> > > meaning. It is the size of the memory that, when accessed, requires a
> > > page fault. A page fault adds significant latency to memory access
> >
> > Yeah I agree on this. Swap just about makes resources not directly
> > accessible by the CPU act as RAM, whether that is storage on disk,
> > compressed memory, or a network resource, all accessed through a page
> > fault. I hope we won't make this fuzzy in the future by introducing
> > too many magics.
>
> Hm.  The counters are already fuzzy - the accounting is already doing
> two different jobs.
>
> Suppose we want to allow 24GB of logically swapped memory, backed by up
> to 8GB of compressed RAM at a 3:1 ratio, but permit only 4GB of physical
> swap.
>
> Today we have:
>   memory.swap.max  =3D ?     /* logical memory requiring a fault */
>   memory.zswap.max =3D 8 GB  /* RAM consumed by compressed data */
>
> If memory.swap.max is 4 GB, zswap stops after 4 GB of logical pages,
> despite consuming only 1.33GB of RAM.
>
> If memory.swap.max is 24 GB, zswap may reach 8GB of memory consumption,
> but the cgroup may also consume up to 24GB of physical swap instead of
> the desired 4GB limit.
>
> memory.swap.max is simply overloaded - there is no way for us to express
> both limits.
>
> Could we preserve the existing swap semantics and add a physical swap
> counter instead?
>
>   memory.swap.max  =3D 24GB  /* logical swapped memory */
>   memory.zswap.max =3D  8GB  /* compressed RAM limit */
>   memory.pswap.max =3D  4GB  /* physical storage limit */
>
> These limits would be independent and compose naturally.
>
> For a zswap-only workload where we care about RAM consumption but cannot
> predict the compression ratio:
>
>   memory.swap.max  =3D max
>   memory.zswap.max =3D 8GB
>   memory.pswap.max =3D 0
>
> For a workload that performs poorly after more than 7GB of its logical
> memory requires swap faults:
>
>   memory.swap.max  =3D 7GB   /* workload-specific latency/SLO limit */
>   memory.zswap.max =3D 8GB   /* uniform compressed-RAM allowance */
>   memory.pswap.max =3D 0     /* zswap only */
>
> In short:
>
>   memory.swap   =3D logical swap       - workload/SLO limit
>   memory.pswap  =3D physical swap      - storage limit
>   memory.zswap  =3D compressed memory  - RAM limit
>
> This would preserve the existing memory.swap semantics while allowing
> both backing resources to be constrained independently.

It sounds like you want memory.tiers have limit enforced.

I suppose it is possible. Again I want to see how people would
actually use this feature.

Chris

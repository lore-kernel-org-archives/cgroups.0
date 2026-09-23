Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0943B6C9
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149491; cv=none; b=KKbG1BoYh8PGWqXFrtlpF4mNqW25nphOSZv9XxsgqwbaTZqpvuef3baCGc45NeWpelNetLb/ch51T8SVBNuMbvORUgo76GM6+grNlBu2NJ4tVq0zOJWCLKDmx1ZG148wgDle7+m5OrNFKi3S4fwqV7WFwwuRMVMrCBnvl53mS00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149491; c=relaxed/simple;
	bh=NYrLhfZTuLWO9786X74rj8Oc2nWE4LCd9wsqz+3EZTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EAmJwVABImjWwpR0NyhIX0m3oYZA3qN62BZdqsfWGXXAgHKyw7InJe/Eh6/OoDT2NYtx0Lox0e1qbSjQ41SQczBZ7q96qnSjUC5fu85jA4Fn9EoXTVwYD2T8OQz0Gg4Du5f3fGdbLHjgUnaGiN5U1kzTjDh81tsyQOqKy406RfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpkRIhER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpkRIhER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3A91F00902
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790149490;
	bh=NYrLhfZTuLWO9786X74rj8Oc2nWE4LCd9wsqz+3EZTE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XpkRIhERG5CHFtcKDo0+j+mrpOsQ5yfCxODXBVvkHiTrWmVDnzG3N+KWJIak3vsOA
	 YA88ByUfUJovQXCLTrb8+cdfVg8nOxprF/lMcYKz7YCSfkOyesbhpDv8G7nWIyo5Gy
	 Go+WlNr81vlTZoxWABvrIvNFB8Y1gjfhamsvQoYaOv84fcqK/c2M1v4Ed/PgwIQTwT
	 YakGmc9iKYpP9EOMcRjYOop9Isez541rkojict/k7QBYL4dZReyYiLefH2koBeeKkB
	 g4QHlY90xLOGLgLyVXAv+9CzUuwD82OPAqV7gcu+FROdUt8z6gBQYnOqn4A4CjXUzr
	 qCwAQX+H3T+zA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab201f9so545830d50.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 00:44:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy1nKVtwvBfpWpzitPJxzgoIcVKm+w7CJtovff+cfcpNl8Eev2MC+WZT4Pbr7m+oGonC3gBy6Ap@vger.kernel.org
X-Gm-Message-State: AFuF++kmx/T1bjY1JkwH4OSFPEIFD4OxEjoop38ksxKkbrPFhuELkBLr
	+kVrK+A8UzQEKYQKSvBXLKBXZoBBz7Hl1/zQ4wB4SESRabyCOukuDWXgQ+1U36jitoMxcfbBHdk
	xUud8M5BhBfiiok+n7NMUGfFioVq4ti6+B/tsbM/3Bg==
X-Received: by 2002:a05:690e:450d:20b0:672:99e1:11f4 with SMTP id
 956f58d0204a3-672d59729dcmr476582d50.145.1790149489550; Wed, 23 Sep 2026
 00:44:49 -0700 (PDT)
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
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com> <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
In-Reply-To: <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:44:37 -1000
X-Gmail-Original-Message-ID: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
X-Gm-Features: AcwNN1WZdLmRO50k_DT1C2XXWd6awldXtQl_BApHlgNKLP6uIu8v4FQYJXq3Og4
Message-ID: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
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

On Tue, Sep 22, 2026 at 7:54=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Sun, Sep 20, 2026 at 5:13=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > That is not what I have in mind. The example I have in mind is that
> > zswap is charged to swap counters. Changing that behavior will break
> > our current deployment and that of many other. Kairui give some
> > example as well. That behavior should not change.
>
> We already have a knob to select vswap. Users can turn it off
> initially, and/or update their software to handle the transition
> based on this knob.
>
> Otherwise, you'd never be able to introduce any behavior into the
> kernel. Hugetlb accounting/charging is a new behavior, and there were
> softwares written before that assumed hugetlb usage is not charged. If
> it's not a good argument to block the implementation of hugetlb
> accounting then, it's not a good argument now.

My original intent is that 200% of RAM for zswap is too much.

It seems you are talking about a different topic: the vswap charging issue.
There is a golden rule that we should follow: don't break existing
users. At least with the same persistence, this rule should apply
universally.
In the swap tiers discussion, the UAPI was such a big deal that we
couldn't implement new UAPI. On the other hand here we argue for
liberally changing user-space visible behavior.

BTW, I already shared that changing swap counter charging will break
our and others' existing deployments.

Chris

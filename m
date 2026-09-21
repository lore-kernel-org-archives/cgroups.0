Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7964CDDE1
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790008279; cv=none; b=LysY9pfy8RxGPEOIGa5hSzooDR4BHVOCDR/ajN9IzLGNUgLY07v2mu4L4C9hXNJeHgeWce5EI44CcjRX28VVg6gUo4Yn9yldcXg9JyNAaZXOvcF/9bqqONNRvjzEo5Il2ub449OoiWZKCypeRbRieavgHZu4KsdXpbvQ7wdmxNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790008279; c=relaxed/simple;
	bh=pB46b/5McjpRlcWhtExKDHwAUls0jhdUiv9fcow8q9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UL58Th5xCVemplmvHdszPrlo3Ji1HLCrOFOrKMvMWcLiE8jAVQWBRu7RahPDBDtVlmBF8MpeTuJ6A/m+FgkPXFKT3075Irq2E2RpPkokyWfe2uKfCuzB7YIxfhYHETX9ng3rBN09xdEm0p5WaX5FfrzKMa7dg4BuapkiSRYWk+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+S0GYnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+S0GYnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9C01F008A4
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790008277;
	bh=3xr1vny0sOsGLPZymUSVuBvQ2lAD5e8F1Q1dBisDoZY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C+S0GYnDnxQf572qmFuv4S780mk/IXbOQ680vfrSXXVWznzFaC+vc/mENCtzeAoaO
	 TR96FPZfvE1ohsT9EC5mnhZJyTzjNSzDF3VD8CNFuHjmIFRacTTJDgLQR8McwmNbTT
	 gqoEobtoWSrsep5EpRHK4TSGnXKoI/RR1/rgyZf+gg+QpGmlqsiSPNzRzJph9tRPM2
	 rinJHGjVi/SfW3/UWawDlvoRecw/QjVrNAlXlnBwewf6IkOnu1nxl1uBrrIuQLxuZY
	 pXCJKrkmiOdcKBtEyfNJ5G1jxV3kzg6YwnVM/e08v2OCfRj2dzXt//6AQ7JLREu3XL
	 cWldJb3yySW7w==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9104649a5dcso28915506d6.3
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:31:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzo9hb8t2Amm9dkgliyw8CFQx08NyrkzpHMv4UPZFnOQbnd5HNVQccbSEcS0hUGj5+941bypv9R@vger.kernel.org
X-Gm-Message-State: AFuF++mH0eMGVla0BjnuCxqPc+a1zOIum5Nhm1++4UuBD+n2rmKKMIe3
	tg9Jl0IjRpKhOOguT/62iu7yOG03CivlVG+4MoGfswYV5eqfz78lEYzqo+R1QMu2ckSRNH4HfQH
	XDlJhsXTmTwY4UMYmFVGWPTRl+wx7iloh59lwFZduyQ==
X-Received: by 2002:a05:6214:8009:b0:912:5a5c:780d with SMTP id
 6a1803df08f44-913fc89d07fmr11633656d6.5.1790008276295; Mon, 21 Sep 2026
 09:31:16 -0700 (PDT)
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
In-Reply-To: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:31:03 -1000
X-Gmail-Original-Message-ID: <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
X-Gm-Features: AcwNN1WuDTsc28AMiNXH2l4X1GQXl6mvqO7A2s7z-INvZm2ismrDAvJON8rwpw8
Message-ID: <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
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

On Mon, Sep 21, 2026 at 5:16=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
> >
> > I am sorry, that is not actual user usage. You need to start from an
> > actual usage case: I have a workload X, only want to give limit Y for
> > the cgroup jobs but with Z SLO requirement. That kind of actual usage
> > requirement.
>
> Limiting how much anonymous memory can be zswapped
> does not guarantee an SLO, though.

Nothing can guarantee an SLO. It is a safeguard we used. Those are
existing use cases.

> We have seen plenty of examples in practice of
> workloads that have swap DISABLED, and are still
> thrashing, because part of the working set of
> that program is in the page cache, and that still
> gets evicted.

I can only imagine adding more zswap will make the workload worse, not bett=
er.

>
> The way you can guarantee the workload is not
> thrashing is to limit the total (anon + file
> cache) address space of the program to within
> some size.
>
> Anything else is not a guarantee.
>
> What is it you are actually asking for?

Give me some real-world examples of people hitting this kind of limit.
e.g. MAX(%)  > 100% and still have a usesable system. I suspect that
with 100% zswap usage, the system becomes unusable. Please show me a
real world case that proves me wrong.

All your use cases are hypothetical, or someone in a corner of the
world is going to have a problem. Give me one usage case I can repeat
and test validate.
You can't even do that, the burden is on you.

In the kernel, we don't break user space behavior for no good reason.

Chris

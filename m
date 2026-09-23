Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1435C1B2
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148032; cv=none; b=bMv6Ln95IWz6BckQle7v42ykJQeizi5Dp8FJ6T8QyMrGzWi1hSK/a5ZGR6+PHcT6Z+7XAg8UXdZBFcBh+hnvmbMPOBkb9YvVsWhFtuvLFlFe7aXBLKf3ANsD9ky3xiij6tfKFlPs96nbZjxn7ZCKFKxtyWiKmY3hJRwZ8Wk+MF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148032; c=relaxed/simple;
	bh=nLS1n8qV6eC9W4rvdxBSwAmsHoTxZonjQLzxFgw28Wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NbkGZdukWkMwKqylkxTXFULfO/FMRF05qdfnBLJhZI+/qId1V1KNebNoSqhEX/JVt3Mt3X+lHj8kan+yL6otblztAVIgTXlb9uR/KLlVOUQ7hz6MUPi0P1jE9gCuauapufF0YqxiwOoh+ko84tI6LU2L8qEHiy9jtkl42cdNdhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UguBxu4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UguBxu4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B1C1F008A0
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790148030;
	bh=nLS1n8qV6eC9W4rvdxBSwAmsHoTxZonjQLzxFgw28Wo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UguBxu4mwJWYSrWKx4bzSAfl6n/EYHutzXXLv6onceqt9w1Km/iiVb/srT0FUSS3N
	 ZlBe8al3MoCZHCXXUmLZRGHqOkWcH4YF986CCdhw7DHmWj+AVGuu0Bm8MTO4I8W+Xs
	 LVaglygw6aT21BY7iqKZ3TB+Blqn5Tf9HXWiYeKHcDjvXA7hfU5PuPfIX2/IraV4Kg
	 a8eesWwn9H+7T7iIsfawE9eRlxnNpiDIHo8uiQcgHMW7CYGtgkZGHVwMkAoVPZlpTr
	 Y1Gm8i8UJwngCs0OXbxok+thnuNz7iI3uoRywcP+T4XXWwH1lmTbRws5mX9yfdUDiM
	 9v134bJUlxv0g==
Received: by mail-yx2-f16.google.com with SMTP id 956f58d0204a3-66e56a1fe83so559267d50.2
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 00:20:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzywrYAdGu/J2B4CzdRZPaoH4z435MQ+RYIPeyFjlJoren25xOJ3Rl3wRw+elzRFrxDebT587mr@vger.kernel.org
X-Gm-Message-State: AFuF++mZmMBbEluUKsJBW19ltnzaCd8BrCgPm/pgROpYCe5sh/u8GInP
	sxDXJOI5MypNMV/bgTDT623aoDyZeFWnP6WSdjNwHLgD+/tNbKNXZ3ZDqwS8VrxNYZ3yNTAjzrY
	DHwqLMYcWC+n6Qqxza8yaWHjmfphuIUYvod7sZwX3tQ==
X-Received: by 2002:a05:690e:bc8:b0:672:9f72:7c04 with SMTP id
 956f58d0204a3-672d5a1405bmr755720d50.102.1790148029577; Wed, 23 Sep 2026
 00:20:29 -0700 (PDT)
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
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F> <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com> <CAKEwX=NKC=N-YaiwZK7HPM4MfX-7JG_KeHukS0+vjHqMZTV4dA@mail.gmail.com>
In-Reply-To: <CAKEwX=NKC=N-YaiwZK7HPM4MfX-7JG_KeHukS0+vjHqMZTV4dA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:20:16 -1000
X-Gmail-Original-Message-ID: <CACePvbUijn+9poYGFL0kiA+ADAxLULcmuVpfx3=9UbbRemyjRw@mail.gmail.com>
X-Gm-Features: AcwNN1XNF8jCOBxQkoAP5mypVrfmU5thuNYjjY3TJ8Y1KZCkSFtYtgfK_yupyfs
Message-ID: <CACePvbUijn+9poYGFL0kiA+ADAxLULcmuVpfx3=9UbbRemyjRw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
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

On Tue, Sep 22, 2026 at 7:21=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Sep 22, 2026 at 10:15=E2=80=AFAM Rik van Riel <riel@surriel.com> =
wrote:
> >
> > On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.=
net>
> > > wrote:
> > >
> > > >
> > > > You can't know the compressibility of memory until after you
> > > > compress
> > > > it, and requiring a user to predict the future by forcing them to
> > > > limit
> > > > the total amount of workload compressibility does not scale with
> > > > the
> > > > number of workloads of variable compressibility of data.
> > >
> > > You likely just need to pull a SQL query on your fleet to get that
> > > number.
> >
> > This feature is not being developed for just one
> > user. It has to work for everybody.
> >
> > >
> > > > That should tell you that your model of reasoning about this issue
> > > > is
> > > > ill-suited to address the problem.
> > >
> > > That is what I'm suspecting. Nobody in a sane mind would want to
> > > zswap
> > > 100% of the RAM and maintain reasonable SLO.
> > >
> > It could make a lot of sense to have some default
> > limit upstream, that says the zswap pool is not
> > allowed to take more than half of memory, because
> > at that point the compressed content will be
> > crowding other things out of memory.
>
> I actually am skeptical of gating zswap usage (both pre- and

Isn't there a zswap limit some thing like that? In our deployment we
have limits for memory + swap as well as page fault latency to detect
SLO issues. There is a feedback loop.

> post-compression), but I would like to note that for post-compression
> size, we already have that knob for zswap, default to 20% of physical
> RAM.

I think swapping too much to zswap does not make sense. e.g. 100% of
system RAM. That is my point. It is not a value you cannot determine.
We can find an universal answer with a safe margin if we want. That is
my point: it's not a value you can't determine. We can find the answer
with a safe margin if we choose to. If you don't want to, then that is
a different story.

Chris

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38555443AB4
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148752; cv=none; b=f1ffVpRnEBGcYuB5EyPgaruHtfREafZNlolwJeibNWhe5nL/HySLFzIqjDGjU6sCk6+0v+djN0ZDdRBBtBohze9sdRK9MPWtkqa+kxQwxeDBGKuKwVDY/rQwn9gzd0ZgnPRqYRhIzQu52VLo14T9Z/KlUIr3jbVbO5IlvGxGvXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148752; c=relaxed/simple;
	bh=nj4ZzwUvAOkZMBrzgklCswTw3PmjVyBwhU+8VdYjpJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=obPgyMFwnO14cxJh5RgZhKrTK7lmonhdFoRFh+Y1otK6v99K2cHku3N4trD5uLUDXp38rytGyHq2pSoxs4MeV6l0ZKChYrZenbCt6Ijizf/gE+8yNqiXTymhiLBgcWWedMFCeMJr0w/FGTdSg1jo0MPli7y2SdDjjCXxv47LGbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otszdD8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otszdD8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05BC1F00893
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790148750;
	bh=nj4ZzwUvAOkZMBrzgklCswTw3PmjVyBwhU+8VdYjpJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=otszdD8Os0bzZ8eXh2j6csvFV0p8ptu8cTdhSBMGgfBuWsr1n3mD+qbDtKphb/SRV
	 PM5RBJZDZw3IWPVHD5bYyFVRJysL/qYhR3qpFd10j/UyZaCPY5XJDbz657KZBu7BsZ
	 WHxDF0dLpP5qVYJQWwPNamOQnNe2je/E4DjQZliA8AhR1H9ss9JBjBK8sMyZSpw4lZ
	 FkKTma1zeCkI+0gg81spvDl9lhESMQCeL71oabrM2FnGlud8KIG36R2f3J2Ha0FLap
	 3kNORyNYExctlvOryvhm0KLGYOkBU6FIv31qBW4HEhE/P8qOWpa294w2nKOJsIVQdz
	 cVpCXtEZ1eaeg==
Received: by mail-yx2-f16.google.com with SMTP id 956f58d0204a3-66e56a1fe83so565710d50.2
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 00:32:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz3jpGZ4UO9+gMpJli2PR/B2CKTNdDLeS4a5+uBdjeZRU4CxuMPetWqZXzRUiLH1a01ja+MPIeG@vger.kernel.org
X-Gm-Message-State: AFuF++nmFZ3z3S9k3k5rvtT+iO9ruEqVQwOt1O3uhY30b85mFTydRCHV
	jmWiHOGjhf+F3LUYtn+mm0l48WkBB2JOkb4syUCLpkq2ZfL4F+2Dw9H0FsManHUSFMWWDrr+NjC
	N0dvM8q1fzqYACs3Iz9kAJ25nOgUxElk+gZh+FFjZZA==
X-Received: by 2002:a05:690e:1247:b0:66d:2e0e:ef59 with SMTP id
 956f58d0204a3-672d5827acemr761335d50.25.1790148750115; Wed, 23 Sep 2026
 00:32:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F> <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com> <arK7gLYD0GJwzKFq@cmpxchg.org>
In-Reply-To: <arK7gLYD0GJwzKFq@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:32:17 -1000
X-Gmail-Original-Message-ID: <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
X-Gm-Features: AcwNN1XZ0IsprA-C8dqObJkA-pxjPDodoFJH1SBPupUOnBC57SVyi9s-WU2Mdio
Message-ID: <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
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

On Tue, Sep 22, 2026 at 7:31=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Sep 22, 2026 at 01:14:31PM -0400, Rik van Riel wrote:
> > On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.=
net>
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
> >
> > That seems like the kind of limit that is large
> > enough that very few people will run into it,
> > while also being small enough to prevent actual
> > corner case trouble.
>
> Just to be sure we're all on the same page:
>
> Zswap *backing memory*, the space needed for compressed data, is not
> the problem. It actually has a limit that defaults to 20% of
> memory. And there is memory.zswap.max for users to define everybody's
> fair share of that limited backing storage.

Just curious, how is the 20% determined? May I apply the same argument
used in this thread: since you haven't surveyed all users in the world
so you can't determine that 20% is a good value. Let's make that 200%
for safety.

Clarify, I am not actually challenging the 20% value. I am trying to
see if I can use the same method you used to decide on 20% to convince
you that there can be a similar upper bound for the amount of swap
space.

> The point of conflict is the pre-compressed side. How many swap
> entries can vswap hand out. Hard limiting this is the point of
> conflict. Any given swap entry can refer to several things: a page
> full of zeroes that has no backing space; a compressed page in zswap
> that consumes some amount of backing space; a page that was written
> back from zswap and now consumes physical swapfile space.
>
> All mapped by the same address space.
>
> I don't see why you would limit this at all. I don't see how you would
> pick a sane default. And if you limit it and workloads run into it,
> there are no cgroup controls to manage fair access.

I am not using a limit to enforce the workload. I am just using the
limit with a safe margin to set the vmalloc max size for xswap. This
is similar to the 20% for the compressed pool. I do believe the app
will suffer if too much of its memory is swapped out. e.g. 100% of
system RAM.

> (Despite what has been said in this thread, memory.swap.max is for
> those entries that compete over physical swapfile space. It must not
> and can not control vswap space used for all sorts of backends.)

Doesn't memory.swap.max limit existing zswap? Then that is a
user-visible behavior change to make zswap don't go through the swap
counter. That is a change we need to avoid.

Chris

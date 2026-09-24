Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C935C1B2
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 11:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247790; cv=none; b=s2YZZoUsHk82Lm0MhYkd+MurJL2zL+aeQBF+wPZONWi8IODVhuwhAvPcvMMTEUL+wGtLQS1hdu5F6HQxC+9UOTKXM2AdkA2aDDNOsc1NilFRy2QXbW89ic7j22a5ZfyRRk5vElyxSqV7TPXtW3rusLKIIFE0bfYEjXJOBJBR23A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247790; c=relaxed/simple;
	bh=QHzsWZeESkFprgTXj2DHa5TPoY9T+JiNfra5izuial8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQKVqegYgiJX3bLy64iuOAAlovRq8SzE2G34TdLwg2R/JMLbs7shFxmnKUb8DuwrFJCpWHJxo+qeZzJyuyGMyx85ciqQPAu7Uzq1NcrXSSEDOmns0YuvrUaJoA+0HEuZEVcYHsTT0C6hqLFH4321CHkxUhoJbOnS0I5AmY3voJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaruF16c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaruF16c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E381F00899
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 11:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790247788;
	bh=qb5cHE2dgUrO0e26v2XgbM47NF6xvjd6olYZGEGtg3M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iaruF16c2G/cqjPSVprB5bCJNcjbvA/mX1AvmBrCN8B07E6qtOfbqcjiRFAG9sTAQ
	 3V5fGKtIn4/uIpfE0ORNmjAKzsBpDoDXAgqdeHtToWTNEDOrCkpwjfCoBhDY9/LTyS
	 MPDF33u00byP9ILEiJ6ebFfyGIagy5wEbc4Fn7tkYCo1nSGnxA95nHQbEkydNB3hsa
	 ktFNOrWV0+Gdf/dfOeLJJ7f6HTDrTuuro6R/r+xy69a+YMWDEu6QxpCH0ENUiemFrF
	 4DYyr6YdFUJK7WFIuhILlgD5C/vSP1ij7M4hWS3BVBQx+Y129btYPHTr9Uw18yntWV
	 nz6IP5RigS+XQ==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aa8d882so1979897d50.0
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 04:03:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw1gssMI8NJt3hroHMaGdVMeyZLINB3HLs0+b5zod15iYJa1YlgUJtLVUa6Pua0Om4I4fihiXxR@vger.kernel.org
X-Gm-Message-State: AFuF++kJRtxIer90C+18Qk0r8X+/fBvob/0cwRo1HT8pM8le0XFHodn6
	YlWqIFSAT5rXy9JsB3cKNXihn+tPmhTf7wmySNrvYYPw30szHejo+SMtJ3VTeIPCLDxfFHpO24e
	VBWAHhRix0PdiPQSlb0+sTMeEN5/mVPOLpfMco02FBg==
X-Received: by 2002:a05:690e:43c3:b0:671:1256:56f3 with SMTP id
 956f58d0204a3-672ed2624cdmr748540d50.21.1790247787078; Thu, 24 Sep 2026
 04:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F> <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F> <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
In-Reply-To: <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 01:02:54 -1000
X-Gmail-Original-Message-ID: <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
X-Gm-Features: AclHuK8VFQcjyBqPb4h6LbJpz-yiYCZ7Fqjey1egs43oMEG0gsapG1F4wdinNfg
Message-ID: <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Gregory Price <gourry@gourry.net>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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

On Tue, Sep 22, 2026 at 11:39=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 09/21/26 at 01:02pm, Gregory Price wrote:
> > On Mon, Sep 21, 2026 at 06:32:56AM -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 3:27=E2=80=AFAM Gregory Price <gourry@gourry.=
net> wrote:
> > > >
> > > > This would preserve the existing memory.swap semantics while allowi=
ng
> > > > both backing resources to be constrained independently.
> > >
> > > It sounds like you want memory.tiers have limit enforced.
> > >
> > > I suppose it is possible. Again I want to see how people would
> > > actually use this feature.
> > >
> >
> > Possible, but arguably not needed. the swap and zswap counters already
> > work for this existing interaction.
> >
> > As I pointed to in my response to Rik, in every reasonable use of
> > pswap+zswap the global swap counter is pointless.
> >
> > So then pswap=3Dswap and we're left with zswap and swap.
> >
> > And I'm not convinced your reading of the swap counter as a limit on th=
e
> > *logical* memory allowed to be swapped out is actually accurate.
> >
> >   memory.swap.current
> >         The total amount of swap currently being used by the cgroup
> >         and its descendants.
> >
> >   memory.swap.max
> >         Swap usage hard limit.  If a cgroup's swap usage reaches this
> >         limit, anonymous memory of the cgroup will not be swapped out.
> >
> > There is no documentation I can find that has ever documented these
> > counters as "the amount of memory requiring a fault".  If you put a
> > compression system in front of physical swap - the counters as-describe=
d
> > would still be accurate, while your reading would be broken.
> >
> > "swap" here is highly implied to mean "storage" as opposed to memory,
> > which is why "zswap" defines its limits in terms of memory.
> >
> >   memory.zswap.current
> >         The total amount of memory consumed by the zswap compression
> >         backend.
> >
> >   memory.zswap.max
> >         Zswap usage hard limit. If a cgroup's zswap pool reaches this
> >         limit, it will refuse to take any more stores before existing
> >         entries fault back in or are written out to disk.
> >
> > If you're presently using swap.max to mean the "logical amount of memor=
y
> > allowed to be swapped" - then your usage does not meet the definition o=
f
> > the knob.  You need to justify that your use case cannot be expressed
> > via memory.min/low controls:
> >
> >   memory.min
> >         Hard memory protection.  If the memory usage of a cgroup
> >         is within its effective min boundary, the cgroup's memory
> >         won't be reclaimed under any conditions. If there is no
> >         unprotected reclaimable memory available, OOM killer
> >         is invoked. Above the effective min boundary (or
> >         effective low boundary if it is higher), pages are reclaimed
> >         proportionally to the overage, reducing reclaim pressure for
> >         smaller overages.
> >
> > That's an SLO interface.  memory.swap is a provisioning interface.
> >
> > As it stands, I'm left viewing zswap's counter inclusion in swap as mor=
e
> > of a bug than a feature - they account for different things (memory vs
> > storage usage).
>
> It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
> cgroup2") introduced memory.swap.*, it was clearly defined as charging
> "the actual number of swap entries used by a cgroup". Please see the
> commit log. With that, zswap still reserved a swap slot even when the
> data never reached disk. And not to mention zram, it's backend is RAM,
> but not physical disk.

Right, that definition matches what I have in mind. The actual number
of swap entries regardless of the backing type.

Changing the meaning of that breaks existing users.

> Now some deployments do use memory.swap.* as an SLO signal, and that is
> real use cases as Chris and Kairui told. So I don't think this is about
> who is right and who is wrong.
>
> To keep the existing deployment working and at the same time give the
> physical slot its own knob, I think the solution is to add a memory.pswap=
.*
> counter as you suggested. And that is not something we think of from a
> brain storm, it comes from real deployments which already depend on the
> current memory.swap.* behavior.

I think it is important not to break the existing usage of
memory.swap.* behavior. I am fine with adding another counter.

Chris

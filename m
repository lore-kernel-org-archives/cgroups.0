Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ADB36923F
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 07:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789801689; cv=none; b=Vs8Ruvs7wgvZByz+xAMMC5x7rt8BGbCD83UWeaaMRBnaTNiQL3b6R063YVMdFum+AuAUlBqyFhX/FqJFdiI6ngoLhoek5VAvDjkXm595KlLXAjQk+WPliif5akmE7Et1nmN+wHsVrL8eiGJMCMw8ERHN0Uzb3n2bmhKOdm4NPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789801689; c=relaxed/simple;
	bh=rrsp1i5LIXFwyVvVNp3h1o8lIsm5uPBaJpVC8/T6XK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1qpk9687swjVNdkKa6v5l2TZTXHGOCjz0yvypiQh73pNOyQE12E1L3pN8kY0Bj+dkgamNyMs37dagJQ27tpQcRxFclMtLi9vXKoxN3ykoDoTCpQDCPV1WSK6MkocPGBR9E4FRKyehYqL52daS2R8wzlUlnysqs5SPtENv5+oIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZS6+QU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZS6+QU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C5E1F008BF
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 07:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789801687;
	bh=gE+paBGkzkQFjuoRRz7bb7MKq5Y27OcpesK3wuYSa7w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nZS6+QU2FaK7JEHO2/S2dt3qa+Hi3bOONBdvlpRuSaE2yM1DodwkSJ8OS5OT8dmOb
	 Qq2TI7DCEgw52pfjYZQLhHoypYwaiMiP/Lw4E+cTiL5ZZm6MG1KGVuiUDCjht2ODYd
	 u3ucCeh8M0UlhTjpXymQkwhHx1FZRus31fuJNfzCSfhfAG9ma9R8/siVyuqyTgPd+d
	 Jr6w8ym0RPu+yPowWicpZTRbtTxzRgtou4+Z8sZfEQi/Bode4gqK04V6ez8uqUcV6u
	 PrjA8fOb9FiU61dampiMRE+TcZnoTEfV8M9OY1MrmbVst7bqhTBdDV60/e6H0aBdC+
	 rMF33t/t/NSJQ==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729c4030f0so247314d50.2
        for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 00:08:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxK56sg6k8bSd8EmbFDYwIKJG2dGUp50RmqKAwZOnjSz0yO8/HV0oRtONRiJlt7L7W/iXDxNvqQ@vger.kernel.org
X-Gm-Message-State: AFuF++nIamUixwd0dXzl+NmJr1ZH6qAayUWPxI76cT8TUpJfmAaiDdRK
	7ZN4WjBj+YJ6ZF8Pvp5lELVMQkuBvpykP2oEtcjpsKD+rx6gtotw57nsPl4kPhIAzGsA2gAfzwM
	zkSnWo23D6EupGtKcqlWzw0qEADahtOG19rmDXZwKFg==
X-Received: by 2002:a53:d5c8:0:b0:671:33ba:b4dd with SMTP id
 956f58d0204a3-6717fe4c8a9mr1153659d50.93.1789801686606; Sat, 19 Sep 2026
 00:08:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora>
In-Reply-To: <aqjcFb6MFNiA6n4V@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 02:07:55 -0500
X-Gmail-Original-Message-ID: <CACePvbWxnr27ZczLdBco4X53aKcgq16VqZouO2qXQPrSv9Koww@mail.gmail.com>
X-Gm-Features: AcwNN1WBLwbT5ruT7e5y0cS0b9GaV16VkekND9NewldgAksHMI-xQQPGAeCaO3Q
Message-ID: <CACePvbWxnr27ZczLdBco4X53aKcgq16VqZouO2qXQPrSv9Koww@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 12:48=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 09/11/26 at 09:45am, Shakeel Butt wrote:
> > On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > > Hi Nhat,
> > > > >
> > > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > > .....snip...
> > > >
> > > > [...]
> > > >
> > > > > With VM_SPARSE, xswap's cluster access is exactly the plain-array=
 line the
> > > > > rest of swap already uses:
> > > > >
> > > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > >
> > > > > no branch, no RCU discipline, no tear-down state machine, and no =
NULL
> > > > > return. So VM_SPARSE doesn't add complexity to close a gap; it le=
ts the
> > > > > cluster layer stay as simple as it already is, which is precisely=
 the
> > > > > part later work (writeback, rmap lookup, memcg charging, THP) has=
 to sit
> > > > > on.
> > > > >
> > > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are=
 all
> > > > > within ~2-3% of each other, effectively identical.
> > > >
> > > > So the claim is VM_SPARSE is simpler than xarray based approach. I =
feel like
> > > > we are discussing implementation details before deciding the design=
 and
> > > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and=
 decide the
> > > > need for dynamic growth. Why we want dynamic growth upfront or can =
it be added
> > > > later? Once we decide that then it will be very easy to pick an imp=
lementation
> > > > that would take us there.
> > >
> > > Hi Shakeel,
> > >
> > > Thank you for joining the discussion and for taking the time to comme=
nt.
> >
> > Hi Baoquan,
> >
> > I am mainly trying to facilitate the discussion but your use of LLM is =
causing
> > more confusion. LLM use is fine but please at least re-read before send=
ing that
> > the sentences flow and makes sense.
>
> Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
> myself. I wrote most of them by myself. While at it ath the moment, my
> logic could be unclear.
>
> As said, how swap_cluster_info[] is built is the foundation. Whatever
> you do, you have to make swap_cluster_info[] ready, then you can do
> writeback, rmap lookup, thp support, etc, on top of it.
> swap_cluster_info[] is the basement, then you continue building 2nd
> floor, 3rd floor, till a high building is done with things added. Nobody
> wants to claim he just need the high building, while no basement.
>
> Now, the foundation has been built with the lazy vmalloc, it can grow on
> demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
> a basic array semantics. And since we our target is to support a very
> large swap device with an extendable logical space, grow on demand and
> shrink becomes important. Now it is there.
>
> That's my understanding, not sure if there's anything I can't get so
> that writeback need be made first.
>
> [I type each of above by hand.]

LLMs are just tools, like spell checkers are tools. They all make
mistakes. Even people make mistakes. Don't beat yourself up for it.

Our community should be more inclusive of non-English native speaking
developers.

Chris


> >
> > >
> > > Agreed on requirement first - but this one was already decided, and n=
ot by me. In
> > > the July ghost swapfile thread Nhat rejected exactly the shape of "gr=
ow only, can
> > > be added later":
> > >
> > >     "Except for my virtual swap design, which does support dynamic gr=
owth AND
> > >      shrinking of capacity on demand ;) If it cannot grow (and furthe=
rmore, if it
> > >      requires userspace operation to trigger swapfile growth), why do=
 we need this
> > >      at all? Might as well create a new swapfile with swapon?"
> > >
> > > To me what it converged on was "dynamic growth and shrink, no writeba=
ck yet".
> >
> > I am not getting how out of context above paragraph shows the conclusio=
n about
> > dynamic growth/shrink and *no writeback*.
> >
> > > So automatic growth *and* shrink is the requirement, and the simpler =
alternative
> > > was already on the table.
> > >
> > > And I keep mentioning it in the cover-letter of each version of my po=
sting. I
> > > only did the foundtation via lazy vmalloc. And Nhat will do the core
> > > part including writabck, rmap lookup, memcg accounting, zero page fil=
l,
> > > etc.
> >
> > I don't see any evidense of this decision. Actually this whole email th=
read
> > shows that there is no such decision.
> >
> > >
> > > What is still genuinely open, and I would like us to settle, is how l=
arge the
> > > device's address space should be, because the metadata scales with it=
:
> >
> > With dynamic growth/shrink, is this really a blocker?
> >
> > Anyways, I will let Nhat and others discuss the technical details (unle=
ss I am
> > asked for it). My main reason to join the conversation is to converge t=
he
> > discussion to a decision and resolution.

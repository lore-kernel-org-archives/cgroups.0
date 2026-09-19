Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CFD3515DC
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 06:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789800947; cv=none; b=YmxK5RdqYPZc3B8iYrkChN3/vEW0tjSB64LFbGgcz1W/5vIZdNz3MRDQWI15PipdnqYSzlJCnql4wmATyX+TP2CGdcMspvfbjgofDsPbfbwHIPheWlqGj4fmotfOR9ev51+ImKVJDfdkWBOgrw9TcPhZPXQcmduPnV2Fy8bSPnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789800947; c=relaxed/simple;
	bh=JCRtkvR0ZVdEsJ7SXEo96yok9Ui7ppZFXlwe6X+o9fg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P5ofAMVwaz7WzGWh0BXLWHxNunTMGVFwUprbX/vYPAjJDKAfqX4GTa+bxbLdrDKBGKG0J1m2wWfH4r+e9OY5tfc28pF2PZ+5lXpjPkVgJWaK9YMSQgRoG5MSC0qoxvhidYOsvxqbNUHGXWXai0tB9u0Gm+cI0fL+EuXn5qr24Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+AEKnKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+AEKnKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5611F00922
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 06:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789800945;
	bh=lBPJxnWCG6gJlIc6Oea03Hf0PVIwKD0gi2pxmpWV7wg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J+AEKnKSs40RtUxFHrdfcp3zT5jxcthRo7FB00CisvBl7fEzlqFqKpcNy2v/Vy4yG
	 durzYf7lnVwsUJPJmtbX7pD1dwuBem1vFNh8WNoUsw55tcJoME5g+xWrSORan6WcJo
	 TBlIFozGzJoXeSW+JLipA+IA8JFaGt+hgLoN5WZ0n93RxrIm/Bive5HJ6dLRFkITwb
	 OVdjmBvSX0xHpCLQOtK17yCz8VHSJtsZf6HdhSTi+H+8eCY5JgzX5IHiF2Jtbh9Ozo
	 yIcYjDdND+wyMApxwUgCN/PkTKvgMG2qFqmLqmSa9SXFeNORbPO4lpTPiE6UNGDC5o
	 Iq3628FTA4ItA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-670fee39d73so1525422d50.3
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 23:55:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByIWsfPjkrNEkydD/cACvdWIn1G3r2pb/wTTK1TOnjYaPV/ch95tAGhIFqpXf4oUvcFP/v0mx8f@vger.kernel.org
X-Gm-Message-State: AFuF++lmZWioPICEJoS8jGhJDpg4oCZX4jR4iWDx75Bsyw99ZQHAC+qX
	W3bL+9+4H0uhav1c0YTSJPoEENsiUIgFBzBGP8I6bjsuM8YcwDrR5wvppXW6H4kKk5u7hxCyHiK
	+AaXsyBXrXkIBGhqWmPVu5xjIGlsX18p90PAD6ElqBQ==
X-Received: by 2002:a05:690e:e82:b0:66c:c644:3938 with SMTP id
 956f58d0204a3-6717fc73116mr1567140d50.7.1789800945084; Fri, 18 Sep 2026
 23:55:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
In-Reply-To: <aqjpYHbZ14A8xRtK@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 01:55:33 -0500
X-Gmail-Original-Message-ID: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
X-Gm-Features: AcwNN1Vd2tjplOjh6PB67R-OyLCbkYjVi_cZf-a78V7vf9J1xJzsesI2sggm-dI
Message-ID: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
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

On Tue, Sep 15, 2026 at 1:45=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 09/15/26 at 01:48pm, Baoquan He wrote:
> > On 09/11/26 at 09:45am, Shakeel Butt wrote:
> > > On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > > > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > > > Hi Nhat,
> > > > > >
> > > > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > > > .....snip...
> > > > >
> > > > > [...]
> > > > >
> > > > > > With VM_SPARSE, xswap's cluster access is exactly the plain-arr=
ay line the
> > > > > > rest of swap already uses:
> > > > > >
> > > > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > > >
> > > > > > no branch, no RCU discipline, no tear-down state machine, and n=
o NULL
> > > > > > return. So VM_SPARSE doesn't add complexity to close a gap; it =
lets the
> > > > > > cluster layer stay as simple as it already is, which is precise=
ly the
> > > > > > part later work (writeback, rmap lookup, memcg charging, THP) h=
as to sit
> > > > > > on.
> > > > > >
> > > > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap a=
re all
> > > > > > within ~2-3% of each other, effectively identical.
> > > > >
> > > > > So the claim is VM_SPARSE is simpler than xarray based approach. =
I feel like
> > > > > we are discussing implementation details before deciding the desi=
gn and
> > > > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss a=
nd decide the
> > > > > need for dynamic growth. Why we want dynamic growth upfront or ca=
n it be added
> > > > > later? Once we decide that then it will be very easy to pick an i=
mplementation
> > > > > that would take us there.
> > > >
> > > > Hi Shakeel,
> > > >
> > > > Thank you for joining the discussion and for taking the time to com=
ment.
> > >
> > > Hi Baoquan,
> > >
> > > I am mainly trying to facilitate the discussion but your use of LLM i=
s causing
> > > more confusion. LLM use is fine but please at least re-read before se=
nding that
> > > the sentences flow and makes sense.
> >
> > Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
> > myself. I wrote most of them by myself. While at it ath the moment, my
> > logic could be unclear.
> >
> > As said, how swap_cluster_info[] is built is the foundation. Whatever
> > you do, you have to make swap_cluster_info[] ready, then you can do
> > writeback, rmap lookup, thp support, etc, on top of it.
> > swap_cluster_info[] is the basement, then you continue building 2nd
> > floor, 3rd floor, till a high building is done with things added. Nobod=
y
> > wants to claim he just need the high building, while no basement.
> >
> > Now, the foundation has been built with the lazy vmalloc, it can grow o=
n
> > demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
> > a basic array semantics. And since we our target is to support a very
> > large swap device with an extendable logical space, grow on demand and
> > shrink becomes important. Now it is there.
>
> By the way, with my understanding, only grow is enough for xswap. You
> can reserve a huge space for it, while in fact you could only really use
> it within a small space. Then it's fine, grow the swap_cluster_info[] to

Yes. We should use incremental baby steps to make the merge easier to
digest. I think grow only is fine.

> the place it ever used, and it mostly will be used again. E.g on a small
> system with 10G RAM, we set si->max as 2x10=3D20G. In fact it could only
> reach 2G swap space. That's fine. 2G is the place we need, keep it. The
> left 18G is untouched and surely no swap_cluster_info[] built for it.

Agree.

> Anyway, Nhat strongly suggested shrink is necessary. I am wondering if
> there's really use case.

We can always add follow up patches if shrink proves useful; I really doubt=
 it.
We don't have to address all issues in one series. I actually advise
against lump too many patches into one series.

Chris

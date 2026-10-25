Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792902139;
	b=ohnR9Qr24+v7ctrasdlNRhBnSxU5Z9sb1Qkf71vu+T9PJFBHb60onbGDUCGpdBDer0GM
	 dZrIkoh3Lc8mmFbm65kox5RHRozXfjVoE6e4I1XJHu0HPSpK241xuRmx9M92u0oos1etH
	 hp4Z57G3dAJhaMbT2o/aMJuBrFY8U9qDYhfEmpoaBbU8Ok1DoAKHbc+XE9DNDqF7nxBGs
	 uPXlguc2bJ52fT3ctS7nnLUShuubXvkye6A/5TOGZbzCB86azqpHxKDgUER/Xko88id0C
	 8PqauJHNs6G9UYPsV/ZIYVSZaIXHzKyCqNgVxY6lDjVTRwuHg/ShZ7VIVk7imABFqvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792902139;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
	b=oyJ58623sdXU3JyMcQbtIRwwk8ihRvCbrOZGAeCxRL7fBpcJ7Pgp6ubGwnWhhhf2jcM4
	 0dvs7jOD3HmUXdfJbXT3LJbLzA1MfHHdjBiYVtedAxblyyanmAv658fsn/BE+abUl8AZh
	 EzyzL7VqvUnyxHum/SIoIo9fORmHvuaNdo2Bx+d08bCobwSiRlXqG/8q7ea0Vy5z1Cv4R
	 Rc9JMinRqPIK47k8Syc75KKxlBYPoEQ0BFZCZf5lydYj5PaxAEiuza2ATnNgTWO4DzY+0
	 YtnlfFTxJiuhGpqhT6G6Eizjq/vBIj3h4SPfZCWXf/RS5wLYJgtn0jbAExO3ca4Uccw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iasWHbsi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9EF606A31A
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 04:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B9EF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iasWHbsi
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so285736466b.3
        for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 21:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792902138; cv=none;
        d=google.com; s=arc-20260327;
        b=Py8W/lNQKQKUyhx3wvR9uZXRvvmY3aowLpH+MdYR5vrw7cBbfINLppnkdBnDQywAv7
         JY9rySyMmNWGY4RiPTUGQg3aeKPtELVTse+2ivw2PjJgpTuS1ag2T/Kn1IBo6gklp+/c
         Hoh5XB1tQaDZmehD4hE92S38oRf2NerlyPzmsKNPd29gnzukyvL2y4yNoLYJr7Bgpt8c
         vwCcx6nT/0BxHl4DIiIdfM6qSboqi4ENrToDHDXUpEYvWdxL7LFxp4tradFMzti7iVEE
         Dzugm4pe7F1oVgSG+4c6OUkcOgb55Pl1Ejd6agSQujlhFDBtordoqqMmKlR717oo4H5G
         khBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
        fh=aU9HUpOJ2Ls6yYWrcfntBqUPfEWTCrrlGVteZ63XISU=;
        b=s2+7swanJuodTVoyr9ePbM9yo0UQjr9+xHTHuS9HwaB0kOZYTT+WHr2dEIHSqXLVwY
         TPHbw4awq+8bF+s2TxUvNGy4ukQr0H5Fxc9zUjrakpsBCN9oY5qq1sYwxrTf0KlIv/n6
         UfC/FBUl3CY5U9Mbe8I6id/BotuBsoSq0v6vjvFkm04YKJfuk1JlnotAoX11d1xi9j1x
         Ammx7bzgid4W6Pvwp9dptpyqZlNArx+a+lO1VKEoDYFH95YnmSHciD0G1eScrl3dtQ75
         8bZGeODHCtBdD90GA8dmX+LkT9L8PoyTKoT8C3JwuRUTckUPWubgKtWteIhyGwUstZxU
         o9mw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792902138; x=1793506938; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
        b=iasWHbsijiuq2xwVwgSfhcJ3IY1intlKQNNQD+S8DlfTqSh7nkiKvV7naDnJWjylSJ
         KLna6Yn9u7lGBZ5EaaoWywoZgNJ+LzQbtxGQOsBBRTyxbmGuvdXs2mJLfHU0SCQEMJX2
         U3qbc7UQJ6wLBFjDfCqPddRIrRSYqtKJBIXzYtZwrvjssyyeqURsd2EgGcP9o9UGF1+B
         1QL/k8LPgp3uvnmKRaHNXpz525mjHrVjnHYZtuR2Dnl1Up1IbKhfx/VwZzJt81KLjr0V
         Z/NHjeXRarSvdL6xgpCvLKeJYStQdG+MyhNDZgRbuCYrb3LeQfYbfrSle1TERmcaN11j
         CyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792902138; x=1793506938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1mCdSVSMJNKyuKTGD9/YocEfXnPBH17bBoNZvqCmSw=;
        b=mZq9ECwQAf1N5c4xI1BQIzamaouerNzCalNxpM92eTZyJgNoveg20U44cgIJsGfL5d
         7/gaqFInZsA1UScAkfRrMSvXk3ePmPdcI+9+/VzJfEbtKKUHQPW/kzpw5AWHRe0w2fRn
         xKXIwP8Vb+R+iVePCCywOw1swzNATs0mVNP6NtRv0+kSbRH2Tj3bXrgKOErz9vuDgaX5
         Y2wqjaIxaOnLTi2+oYbhkcXpy8+Aklr1YTSvRGZvkRDwbdfhTBUGvprV90blqTMcPYMF
         ou/vyqt4LkkdcrDGAy/j+usK72GEWPkByf7qQV5UpCqV6cmNT1JXXXavnBBioYZNdRUY
         xsZQ==
X-Forwarded-Encrypted: i=1; AKwUvByv0l02vQPsbm9hyanWx5FO5XLynUI+kudu0J3J61oDklIUhCGozdqrK246D9tsc1QTnib65RTd@vger.kernel.org
X-Gm-Message-State: AFq9FYIUTpFIvLngmwBveSdsFvyS/rih0o8vViQIT1I4CQrOSQmXhadb
	fhTlxxNI326S9zvb5kagGbUqC/fsqv+GiJIGjeIh2S91fTIaTiu9P56dRSUle+AFbu/94MFVQGD
	KdBrtBpZhilyP6bISiiBEFq+ptSiw7pE=
X-Gm-Gg: AYBFou089+Oo7CKaT1q1BI5IUgDQ1gQijaCDZ1NRYio/P4j8KU/i7hX+zJJt7VBj9IK
	PHdpS/6dRAGsssfUf4oMpruYBv4rWMI12+a1sluTtIHFvlUnRRSIhNHiErJ242fihG6ye/zssAu
	0hCKmreLacKWB0rmrfnrXvcLTLHkeZWKXDoH85zfYSS7kzhjzTOhQO8COObcuhr6iOHhCziucX9
	SYvYvxU0Uua6Rc6hnBmdM/JgV2zvw51x1krIaSUL4L6UteM9kjyUkoF5bI91FLJXLXnZG80SuYi
	EWL0XJ9KQO8T+4hUBUW5K3gwLaU8TZxMm8XlvbqSU9/TQYT5h9rP1HqH7j+L5zGvMvpey+UD5jy
	jZ/341j00Ilz8BHPben7Sn5rrowzODXesH9st+T8OhyXmTsvcELg7Ow4DdQGMU028eHoRi3ULgy
	fANWqxavlRJv33vco=
X-Received: by 2002:a17:907:a0c9:b0:c3f:153a:8649 with SMTP id
 a640c23a62f3a-c46bdacd060mr422491666b.7.1792902137803; Sat, 24 Oct 2026
 21:22:17 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com> <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
In-Reply-To: <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 25 Oct 2026 12:21:41 +0800
X-Gm-Features: AclHuK9AJB_Ij_SjIfwwNYU3XIUY4vB1BJ41W2msTZ1ne8yK1FWjUOt9jpj91Ss
Message-ID: <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=97=
=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> > > >
> > > > * Swapoff: this was brought up as a request, but we ran out of
> > > > time
> > > > before we could discuss the motivations and use cases behind
> > > > them.
> > > > Folks interested, could you explain as a follow-up?
> > >
> > > This is one that I really don't understand.
> > >
> > > In my mind, we have vswap sitting as kind
> > > of a swap VFS between the rest of the system
> > > and the swap devices:
> > >
> > > +-------+     +------------+
> > > > vswap |-----| swap cache |
> > > +---+---+     +------------+
> > >     |
> > >     +----------+-----------+
> > >     |          |           |
> > > +---+---+  +---+---+   +---+---+
> > > > swap  |  | zswap |   | zram  |
> > > > file  |  |       |   |       |
> > > +-------+  +-------+   +-------+
> > >
> > > When a page is unmapped from userspace by the
> > > reclaim code, it goes into the swap cache.
> > >
> > > The vswap layer then decides where to store it
> > > at eviction time. This is configurable by userspace.
> > >
> > > If the zswap pool is shrunk, the vswap layer knows
> > > where to put the data next. There is no need to
> > > change page table entries to indicate that the
> > > data was moved from zswap to a swap file.
> > >
> > > If we decide to disable one of the backing swap
> > > devices, the vswap layer can just move the data
> > > into the swap cache, and the page reclaim code
> > > can evict it into a different backing store, if
> > > needed.
> >
> > And in this case we want to disable vswap itself.
>
> OK, so you are looking for a way to totally depopulate
> the swap cache, in addition to swap files, zswap, etc?
>
> I think we can accomplish that by simply keeping the
> current swapoff code around, which scans through the
> virtual memory of all processes and brings the memory
> out of swap.

Yeah, that's the right starting point. The scan itself can also be
optimized to be cheaper or better later on, but that's orthogonal.

> > I also hope there is a way to release swap metadata completely too.
> > e.g. for fs, you at least have umount, and can rmmod the fs itself
> > afterwards. We also have many ways to bypass the page cache. In cases
> > where a virtual layer is just a burden, we want raw physical swap,
> > and
> > the ability to swap off that too.
>
> The VM cannot operate without the swap cache, though.
>
> That is very much built into core parts of the VM.

I never meant to strip swap cache out of VM... The opposite, actually
:), most of my work over the last couple of years has been about
removing the paths that bypass the swap cache (e.g. the
SWP_SYNCHRONOUS_IO fast path), to get a simpler model and better
performance.

What I'd like is for swapoff of the last swap device to return the
system to its pre-swapon state: no leftover swap metadata, no leftover
per-slot or per-cgroup data or statistic, and ideally no residual cost
in the fast paths (e.g. minor fault).

> However, having swapoff remove all data from the swap
> cache, after mapping the memory back into userspace
> page tables, seems like it would be fairly easy to do.
>
> Does that meet the needs of your use case?

Right, it's nothing hard, as long as we don't add mandatory new
layers. For very high bandwidth swap devices, a mandatory indirection
layer is pure overhead. I posted a per-CPU queue based allocator for
that case (https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-resen=
d-0-68d3d925578c@gmail.com/).

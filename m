Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793173124;
	b=VB89tmDjAdcHL5tGZY0nniNH1q9yMGr1mQmZE17Ob/76hQhMfA/GHbNbATCxE81wNEe3
	 RUFoENjrUhRulwYfxGE3hak2Mth/7AB6DKWMzh1Xz152z0KQjpTQ0TgF6jequjgpwmL4P
	 0JBcP9HmGwsTJWR/V7iQnDNRJ4j4b1uJK+wRp62NcPiX4e+3W4Cq4ZAbLWiBBc7oB2gxM
	 EhGyCbYkZHhO36GqfTFWohAegzlJvadBapJidizAFCVEIe4hIrR7L6+gkj8JteaeV/Qc+
	 tFbketCyg5yncFx0/Chm86mLavnuyOj2wbgqm/qMCw3U8epNY2Q5StW4NorVEbO4GHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793173124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
	b=TqgA/dpa7r/u24i6diEYR1i8gL1OpxuuKrrzq84NAu+LAezAXb8sy5+wnw5bjG45WqUe
	 uyIpApA7HdvMoHCDropsbMRUUI/k6H/pymiLALD644Abd0tRRPHNkfg+bJrJtM0xwj2WH
	 sfUJzZEI7rFn8lCRrW99Lj268/gknOyJQwzeVjHCMTPL/KiR3u0s207KAuI5cJwKZzJ7I
	 nz2hENWtYxERazTegjBL5dmueW3hXm4605umeSLHSbjT4O84holD7rC+pXSYRwdoAE/hc
	 T3D+1usMxQHlOV5VsYS7aUx1X5+ptRC5LG0rw1JYFT8wvYk1GKzSx0wXoViggd+W5Tg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zklaNDR5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851D6606A31D
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 07:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 851D6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zklaNDR5
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so1118276a12.1
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 00:38:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793173123; cv=none;
        d=google.com; s=arc-20260327;
        b=Fc4oTGvULW6LwkRIcRmhWs8oOkRr6omv/EOwZrx8Y33OirMsjYlBGxAr9XM0J8HjfY
         5Zz0YP6LVaavSI8Q1BWJqP5ch0ZzLGv4EMHVvzzo1xsMm7nvkwfvNWFvtpDwH2maz6e8
         TIkA4JAiZwgXtfn3dBjt5cNZbGD4H2/ca9SReAxfUJsjc3J5HdXaRNK3ud+A1ZKXVS02
         258OajbV6CUMQTSIzmjdRj/+w/uNry34S3lGZWZ2kJrlI80TrImiyC0PN10MyqaJNCAJ
         BYwl8sSrXlrIThDEuwtEWrAHg7kf5FBwwmU0NvZfQ95lIz9kDwc7el2C4pIA9c1SaOFw
         dL8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
        fh=GkVYZ7tLTrm+fe0j7AKkD0eZs5S/tlUyHYrXqxG5JfQ=;
        b=FkS+tUwJDN2dLbqcN6A/WuEVf0hhlcnoLWTa0Lsepqb9/S2oMmuF2157NEo4redJGn
         wQu3yKaOle/IAoExsNXam946/ivwvhwSvB7OOTaQcq2SGLHhnyeF1hQ8wzAYw5qa23SC
         2LTjPe3O1e0vslzvVsJUFz7bbzqSvg4u0yKCeDduHxnGzLmXwkONjrdMjSDedak5NqNA
         H6YmepZ8EZK5TZrhcJ5Dr+oDRdZjLjfP3e4zEdaEvck6TQq1lH9b/2gS9EgAuKNrlbzO
         EEM+Ljz8pE1JjMWfIvjza/wHcH2FefdI/a8KuK+ZuGxWRnKHl41XrT5YRM6FD1z0MxoY
         TnDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793173123; x=1793777923; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
        b=zklaNDR5CX5KpN3HuGoYhIyGZYuSEuP05buHr5SZEdsCFMrjreIo9qb3BmjVgwO8CZ
         gD9l+cpnqzVJrP1ItqA1uQKdDP6DA+IO5K1u6bZHclNbZGPKdbCI3UJSXFaxe96fJTBr
         55pEopCUZHL4egHDIXBn16EMalOL78//B96Ut3lxfUgAUtQaCjNyFdJtRUp9eNbtzfDF
         9LOv25/WL4hEqcUaZwQGNEdLSjt0AhgUO5v3lbFjej7Xb7GY9DrYkNToLes0HDW+Wu5d
         iy7EyUuqS5JgOaZ5YUfbUr4no4xKW6q/BVbiVWc2cKSzAk47ZS9KKtf91Hiap3/x2WVH
         8oMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793173123; x=1793777923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
        b=O19VSxDC+i06UxbYY34E7d7dSyXcZIhLPVSEL1rfQA3vCuR+vioCK6tvFAY5+YnsTC
         opAekp06oKA9C4KSgSMf2xcSCyA1E+QCYQfeFSRfmGbWmcri9O2XF/f5TluwKPXjyNwq
         zhz1FZ81ElH0mIAUV4YrC9gv2r3tNRXa+QYlywIKvngYunw7Mctk4TYhKbu18ED3OrvH
         9nHPkmRnTNFgMj1/rDoGw48TA22yVz7IQ1XR50bY38iZ6EnYlhSW66oHSlm/12zbUQHz
         WvdXszVpLJ0RaUyl+Ax7KwrD2qnIXxt4adQqPkCCt6huuLdIcpJE9sp3naxcKEeS7CwH
         j+hA==
X-Forwarded-Encrypted: i=1; AKwUvBysLVl+N+DKyLPmskRqtt9FrIocg7j68lKsC+Wj0AwyFj1hIIDz6+FXe9JgXiVVd3qBs90pu0k0@vger.kernel.org
X-Gm-Message-State: AFq9FYLMYA6uS95lvt8IwArHgcUpiBa04IV98Flr7MvqTf2Vaonq9G2H
	mSHqMHMOuwtV5SVvMXnin7Cux3fBZ4x+yK6khPFfOZRu41rQV99bbRJU5Co0mugkZjGUwvdllkm
	7o4kB5Kvu9dIMhlfIvoUGitv0LnHMXRA=
X-Gm-Gg: AYBFou1lrMgdVJVLvRUEDFkRjY6/02++5tcl3oIl+1RLtny7jiwGxBcMqksFwzrlVOI
	gEvhhprlGFaEiH25TAZifDzGvWwge2esMIlOq0I5xdiElplYWFW9uJupm4s59Jjscp8oIdKXN99
	z75myjW9sJ6KdVwxuZ3inSXzK5+4E46WJR84qDp9y5wFqEJgswowWfjIomE8kLxZ1pWy8zkMIkI
	iFOUZH1h9sVUYibOhMrKfSFvtRJHt6Hvc+vnRprwif0AuScpJNdrpL3qo39ZTK9X6nnp3wCGV1b
	XGVKWP7O9buJ2smZtl+WjhFqB/jyK8bKFNJJniucbdffZXEPU8XVxIbipPaZEKVpK0UIO56jNZ3
	L+RX+z19YRqf1Ls7d5CWDiHVfrgf61VGDsqzZOX+9lb1KEF73n5uSnzagx5/Ft8LoS9gmXpDuL2
	HSi1GEorHgHApV/Oo=
X-Received: by 2002:a17:907:d90:b0:c40:aa04:18d0 with SMTP id
 a640c23a62f3a-c49bdf0b830mr127577966b.17.1793173122715; Wed, 28 Oct 2026
 00:38:42 -0700 (PDT)
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
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
 <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com> <340025b7e3bdc6d905da2cd052ccbbda63a58ac0.camel@surriel.com>
In-Reply-To: <340025b7e3bdc6d905da2cd052ccbbda63a58ac0.camel@surriel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Oct 2026 15:38:06 +0800
X-Gm-Features: AclHuK-mX8ixSikBppmP8XVxk2jjNDTFYKjV7_1Dyl2RLvPqe5fDdGLjEWtahao
Message-ID: <CAMgjq7BQ-K-ZDmP_ZW-2+t+OQWWKEZP4ynoNk5C7NaWq+PP3Eg@mail.gmail.com>
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

On Mon, Oct 26, 2026 at 11:59=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Sun, 2026-10-25 at 12:21 +0800, Kairui Song wrote:
> > Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.=
com>
> > > > wrote:
> > > > >
> > > > > In my mind, we have vswap sitting as kind
> > > > > of a swap VFS between the rest of the system
> > > > > and the swap devices:
> > > > >
> > > > > +-------+     +------------+
> > > > > > vswap |-----| swap cache |
> > > > > +---+---+     +------------+
> > > > >     |
> > > > >     +----------+-----------+
> > > > >     |          |           |
> > > > > +---+---+  +---+---+   +---+---+
> > > > > > swap  |  | zswap |   | zram  |
> > > > > > file  |  |       |   |       |
> > > > > +-------+  +-------+   +-------+
> > > > >
> >
> > > However, having swapoff remove all data from the swap
> > > cache, after mapping the memory back into userspace
> > > page tables, seems like it would be fairly easy to do.
> > >
> > > Does that meet the needs of your use case?
> >
> > Right, it's nothing hard, as long as we don't add mandatory new
> > layers. For very high bandwidth swap devices, a mandatory indirection
> > layer is pure overhead.
>
> Don't we need a swap cache lookup regardless, to
> make sure the data we want to swap into the
> process is not already present in memory?
>
> At that point, it shouldn't matter whether we
> get the backing swap location from the swap
> cache lookup data structure, or from the
> page tables?
>
> We have the page table lookup, and the swap
> cache lookup. That is two lookups, regardless
> of whether there is indirection, or not.
>
> Am I missing something?

It involves more than just the swap cache. It includes book keeping in
cgroup accounting, statistics, allocation, device info reading, etc..
And swap cache is blazing fast nowadays so that isn't the problem
here.

We used to need to bypass the swap cache for similar reason, but we no
longer do that since the swap cache is flatten now:
https://lore.kernel.org/linux-mm/20251125-swap-table-p2-v3-7-33f54f707a5c@t=
encent.com/

Other parts I mentioned do not have zero overhead so keeping the layer
thin seems like the best approach.

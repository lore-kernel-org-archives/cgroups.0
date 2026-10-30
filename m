Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793387018;
	b=g4ppCwiCn1bV+5pFqlbK/Yrhqyyspk2/+yuwrsI5gzIgj/2rWS1iJD1Ro9qkiUhsPPYx
	 lZQPqZ3tPkynIMGz+y/fW0vMDABAxkt+/ZAItg/atPnvho0+FTrGqyDT2cntweQ/KHwkA
	 aY/HH5hTvfnKVUcBxEpZ46fTcByFunsBCj2a1Rx6gGL8tDNtIUHEXMze8Arm5ijvlQwtX
	 dS0IjezNaOXyssVeryUWkOZ8jyuEZEo9uA6xm0oYh7DX54ueEV8tUyzEjjumXnhUO6T2h
	 5/savq6gnBxl3cP+SyxHZErJ9p91arF8K2O5h9KOcE+7NtXoqZE8TiilyBcJ47tVIRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387018;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=G1TbzJA7tvuemQF7QxmCHwR5V4XpxTBrHnE5qnrFYIo=;
	b=fwHuNIU3GGK2dyMGR4n6W6HgbV0Z3KLHhShdqqToP8mTvgVRbrEoxiFDy4HGx2pMT5OM
	 Ix6gsMBYGhox1aJ+U2Vyd5D8ImG3JYY8iVIQMY5ijVZ+Kv6m2XXGVipUrq4c1G38jhbZr
	 8aGFzhkgiS82JgvXWw0Xevn5xq5PH41QEIDYLQTFSCozykjD4y+ZuslQfinG2qjbt6+DR
	 RH3MWS6B24kMMU0krAwJMc3Y42HF14udn4Q2xlM7nntEwbNSyngGCKtG/4iC8Tf1CS/Lq
	 6DFcS8ep34hvM5LMLR5+MeAahhccq82IVQ6P7p5VF0XNaP3/B6GsFYD5vvrHS6WmdNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwErtu2m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3B606A31D
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwErtu2m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B0B1F00A1C
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793387018;
	bh=G1TbzJA7tvuemQF7QxmCHwR5V4XpxTBrHnE5qnrFYIo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WwErtu2mJUucXoHRgjbVcPpda3enOg9yPnS9Q7fNDhjVMRQ3JJ6ByioycsnzZErGw
	 UnV/aw5HdEduCnvv+aqc5YoboEczNs/jPnfOKzfPtnY+o3pDLC/PoWkPctjdLSJP67
	 +87DEgAicYRY8duhif6+kAHDf4jLVE8ls/p8OpJISj1ks0qtzglyJ6fz+vCVTI8Tx4
	 Hh8YbfY/b20SWBQsp9iK3dXCwxd5EWV57CzL3TQIZCnK3hOHfcB72k4W6dTW6CN1yq
	 XZLJ5h2+Wv2C0XJWbej8vf7bj/KL0EbY5eFvoJG6zg7+NNTUpODa+AQRzeVK9Vp7el
	 80sia/ZnEFoxA==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9441591aa5cso201770985a.1
        for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 12:03:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwpaDbk4eV+ENHsYJ77JvOZPxKGqVA5160o1nNQjCzXIdy42P9mGQdJaOwpwEotLc2BvfQHq8Av@vger.kernel.org
X-Gm-Message-State: AFq9FYJkOxcx4KfWZ8pujrNfn9HJCieobdGmSYipnJp8p2TF35hDgn5D
	p2M35Wn/ndGueXrMBgO914BVWoPdnKDVR/aQWfdmDGWL5ITfUmoQcd4iIrg/xkAbp3QKHcQkiAS
	+5RFpAD2W37yPsgpTqKFdYnP4ZlUcFJ4=
X-Received: by 2002:a05:620a:2628:b0:93e:6e6a:b686 with SMTP id
 af79cd13be357-944133b3558mr986791985a.29.1793387017785; Fri, 30 Oct 2026
 12:03:37 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
 <20261030095223.325309-3-jiayuan.chen@linux.dev> <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
In-Reply-To: <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 31 Oct 2026 03:03:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
X-Gm-Features: AclHuK8xBzWeuCruc8JzhVT3vMx1OiWohzDoQWKMU_5xr1KFbFUn9P3jTc2FqrQ
Message-ID: <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 1:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Oct 30, 2026 at 2:53=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.=
dev> wrote:
> >
> > A memcg with memory.zswap.writeback=3D0 can only swap into zswap. Once
> > zswap stops taking its pages, because the pool is at its limit or the
> > memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
> > dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
> >
> > shrink_folio_list() only learns that at the very end. Every folio it
> > picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
> > back to the active list, to be aged and tried again. Each round costs
> > a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
> > frees nothing. The folio also stays in the swap cache holding its slot.
> >
> > The obvious place for a zswap check is can_reclaim_anon_pages(), but
> > it cannot go there. Zero-filled folios never reach zswap:
> > swap_writeout() marks them in the swap table and returns before
> > zswap_store() is called. They need no pool space, they are common, and
> > a memcg-wide "no anon" decision would keep them in memory for as long
> > as zswap is full. With zswap full they must still be reclaimable.
>
> I really wonder if we should revisit not swapping zero-filled pages at
> all, and instead mapping them to the zero page read-only (and whatever
> the equivalent for shmem could be), because yes, the right place is
> can_reclaim_anon_pages(). I don't remember what happened to that
> proposal, Usama do you remember?

Hi Yosry,

FYI, I recalled that we discussed something similar in this
thread too:
https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/

It would be nice to see an implementation that maps
zero-filled pages to the shared zero page.

Best,
Barry

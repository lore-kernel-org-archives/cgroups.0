Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793399538;
	b=Lyfzf9dPVAJrv0g4Ub/NBzdV8HOtq0kpZQncwRQ+ANwNPHaJ0AcwvwACKp1y4v3nEua1
	 yQXWriyBwDqUHtvrHOC2MviCve88djfHzScxrZ/D6T9T8y/0Y/g2jgJ1MJc0kmFqVv4Z0
	 xhlmwhTn52wN6BoWJPzx3LLmw+PIK4l30imjBivPfoHqvuF3jcke0HkZupiocvWzgRSDS
	 OKrBYy0KAyGh5gNYzG/4ZJeP8tc6W00anux/Vrv747rw2QGBvE4fYH1+UCmT8oVkCkpvV
	 c+28OWQlzZnSGWnbDF/vkPdIVStoCE80+tcZ3a2pKQtfiIOKRQt4Ui9BHdL84F21A4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793399538;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=EMD12ToJn0xQB7xf6U5d1DnCbzAwSTm27dnDbxjC75U=;
	b=gRyQ6tG0KO+X32Cd/IOAg3F5nAUj57R6eoLNFXXrMeR+2ZgCpFf+rgpM/oCBNoRGnYMd
	 +gYif6fS22eq87bpTbIPW97pKw+o5ff6MTRvv1JdS2f+jrecOzMu2KfEyG+/6A/+8nhky
	 Sf1l4eba9vFohk4PH3DaIYJj6nn0DOcXtV/Lv5XHRxkwkZ6q7wBbhsf67cauX+JD34JIy
	 1LvD2PCHnB0/u5qJB36d8lNypEfSeDw4tr6OqZFZP7wjpBAQu7kevoro2LohX1pO5uNhF
	 6AyZMQkAFFcbbBytV1bI4uGSv2mmwDwhgdgrvVR5LDyCt6Z5OMGjf4F+c6CqSKu7rJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mf0H8n6l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0E606A31A;
	Fri, 30 Oct 2026 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mf0H8n6l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1E91F000C1;
	Fri, 30 Oct 2026 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793399537;
	bh=EMD12ToJn0xQB7xf6U5d1DnCbzAwSTm27dnDbxjC75U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mf0H8n6lDxMhaiGf9PwQ7zbyb01Yn05om7wGAds4CS3+MqKH5s1FEk5dJk3GW1wi5
	 WNX65VuIQ7KuWO0J8SSqxK5Yw/xsQvLe2CgpLeOB7ViCBRmiipuvudcMkwEhe/4FjR
	 Km/uK3MjJZ9pp+sni01ojDZVxWlze5nIkLUNl1hg8UilPWNP4L40YnA79WaQwLK67d
	 yuaSIXfOcXWy/cQC5Ym+7+o3xd8RP+8oasaUPt12k2uF27JYxcyTiG5B8+WOnCrnaL
	 REmulvJTA0NJ7hD7vJlcPkSjdKprjovBk5S9XenyVRElQ1N8sD71wKwXiPVrMQEZDQ
	 FO+hK1bDxu94A==
Date: Fri, 30 Oct 2026 22:32:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
Message-ID: <auUZPZfxNNBCH5uf@google.com>
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
 <20261030095223.325309-3-jiayuan.chen@linux.dev>
 <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
 <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>

On Sat, Oct 31, 2026 at 03:03:26AM +0800, Barry Song wrote:
> On Sat, Oct 31, 2026 at 1:52 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Oct 30, 2026 at 2:53 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > >
> > > A memcg with memory.zswap.writeback=0 can only swap into zswap. Once
> > > zswap stops taking its pages, because the pool is at its limit or the
> > > memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
> > > dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
> > >
> > > shrink_folio_list() only learns that at the very end. Every folio it
> > > picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
> > > back to the active list, to be aged and tried again. Each round costs
> > > a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
> > > frees nothing. The folio also stays in the swap cache holding its slot.
> > >
> > > The obvious place for a zswap check is can_reclaim_anon_pages(), but
> > > it cannot go there. Zero-filled folios never reach zswap:
> > > swap_writeout() marks them in the swap table and returns before
> > > zswap_store() is called. They need no pool space, they are common, and
> > > a memcg-wide "no anon" decision would keep them in memory for as long
> > > as zswap is full. With zswap full they must still be reclaimable.
> >
> > I really wonder if we should revisit not swapping zero-filled pages at
> > all, and instead mapping them to the zero page read-only (and whatever
> > the equivalent for shmem could be), because yes, the right place is
> > can_reclaim_anon_pages(). I don't remember what happened to that
> > proposal, Usama do you remember?
> 
> Hi Yosry,
> 
> FYI, I recalled that we discussed something similar in this
> thread too:
> https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/
> 
> It would be nice to see an implementation that maps
> zero-filled pages to the shared zero page.

Yeah I also found Usama's attempt and the complication that were found,
unfortunately it's not simple:

https://lore.kernel.org/linux-mm/20240604105950.1134192-1-usamaarif642@gmail.com/.

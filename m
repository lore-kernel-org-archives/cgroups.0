Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A4D4A7C80;
	Mon, 19 Oct 2026 13:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417598; cv=none; b=CDVShst1nX8Yi6Fy1g4lU/UShuORIZSOm9fdwOfWTq4STCyPCOGP1TT6VtCT8SlBQiTG9SREQIsZRm+JLag3jXNpomrIJrQrFLVLT2QkU+EKIYGqg/lziMBllzBno2zEknhQAb3pWOkVLgdsCA5SVPJmxV5R+1ODXVwsbRS9X54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417598; c=relaxed/simple;
	bh=EUaZ2aL17eb+fa7GBS+u3V8Z4Uq6mBw88Y9azF0jnQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IELetIc04BNSxs1btdDz5rnFYMKjWotLPUfx9y4wdw0FiYUtRUr18ZjWJke8dPSi4o6D2KR94Dao/lCKV387RUSAAnnQqCZ4sM58RvP7JMQ/njbH1AODDQSh/vZFlNoHziOtYv8IXjaeAjsBus6LHLvCTPhEomUMpwzc39DODss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqyE52BJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqyE52BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BEE1F000C4;
	Mon, 19 Oct 2026 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417596;
	bh=GIOgXb/mnhZxFdGRsi0Jf0fYXTZWOZ0EseekTxOkjig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BqyE52BJIudzcsDq5arU4VxZYP8jdANRgfaSAsySsr/SfWhoTbCY0S6zvW1kK3HPu
	 GdDoQFIsAyEtKwjLr56Fj0KpDOKI9rkD/SKwuzSNgU5Y5RbnbQoqiq/b1nV4kIt1/i
	 CoJECe7g8iRVAee7GK7AM/spZv5PaVNwfj6Tyib7OJf9/7/y1DiU25X7W/UNXEILvq
	 CvQZbD9MU8dYkV9Z6DTgQB7up5xZhD8iLmj/TnFJ0u8I1yEHyLMKGaUJfmj6/BY40e
	 gQ58Uq/U8gyY9kyUD0Je0VFboIlM8CtwDnxlyYvjtTuvpQsyp1WgQKqlx/LnYSTRsw
	 wmInQsE/GIaMg==
Date: Mon, 19 Oct 2026 14:46:34 +0100
From: Harry Yoo <harry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <atYdi3O77m6XzaKu@thinkstation>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
 <atEkfmRFgXJCbJuK@thinkstation>
 <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>

On Fri, Oct 16, 2026 at 02:15:59PM +0800, Kairui Song wrote:
> On Fri, Oct 16, 2026 at 3:11 AM Harry Yoo <harry@kernel.org> wrote:
> >
> > On Fri, Oct 16, 2026 at 02:15:52AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Add a helper that resolves a stable lruvec for a folio under RCU
> > > without taking the lruvec lock.  It takes a folio directly so the
> > > lruvec lookup happens inside the RCU read-side critical section,
> > > which a lruvec-based interface cannot guarantee.
> > >
> > > No functional change.
> > >
> > > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> >
> > This new helper is doing the the same thing as what
> > get_non_dying_memcg_start/end() do.
> >
> 
> Hi Harry, thanks for letting me know, I wasn't aware this helper
> exists, this series started before the re-planting work, so I missed
> it.

No worries!

> But it's a bit different though, get_non_dying_memcg_start assumes the
> caller holds a reference to memcg, while folio_lruvec_live_get only
> assumes the caller holds an reference to the folio.

Not sure I follow. I think get_non_dying_memcg_start() has the same
assumption (a reference to the folio). A folio no longer pins the memcg,
which was a key requirement for the reparenting work.

In the function, RCU is the only mechanism that prevents release of
the memcg and guarantees correct reparenting of local memcg stats
(state_local) as it's reparented in an RCU work.

> I'll check if I can deduplicate it though.

Thanks!

-- 
Cheers,
Harry / Hyeonggon

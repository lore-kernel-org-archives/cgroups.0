Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E24C4FECE0;
	Wed, 16 Sep 2026 13:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789565669; cv=none; b=qvOnBhwiFIhMpYgnPvXWsNBVaGepr8lR+de66lGovqWaca4Ngdqo/goye4DVDNKgxLBBb9JXw96XLQBky/ecbw+cVGPpmWjxBg7BZ/huLkXlALlsPSVFmX/+85vWoObpQ6Lijep4p4JE4V5y6m6OOaSnoMVM/z02hduqPyqJ9E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789565669; c=relaxed/simple;
	bh=fLoaW2b0XzoIjRglXsq3OJ3Glg24SoQ3XvJvf0iXsZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVpZL9sk8wqWe6LJKvIhpx1J+VhXC7uH6Ir8JuMr8fe0wplanJXerW8iXZl77/kJNnArQgsM3+rkce2tT+RDdlNtL4cUj+ohUCPy+zKnMq41t/MEjxetoxvmE8C44NYiAhu9jpxVNvwMPw5C7zwBUWAd0gZN/YeJ614BYXYwvx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCYZZfUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCYZZfUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6A61F000FF;
	Wed, 16 Sep 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565663;
	bh=2Z0tDRbfIu14gBiwBTHTnXsfRNC4/vvPKIDDl1Wr1Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZCYZZfUe2VXwIRg14QoroYNTZXywKr3OsnaMGA0X6vHMZkznCnqFoTZ7cASnmjWSx
	 e+fqG574aLUN7JUyYqpTQcX4mxopFrxfwvp/lSs0HEx6Cl8HhU6nVuCpee7pYtW0zy
	 WrITWsGDQIO2/fiYGSDqdPVzl2VKbP8HFYpChZfuVx71SH7zcS/nRl9IN65Dm1/bvs
	 sGV4hYi1OybacI5MHgLfD74wysS1nA81WUQR6cyV9MzUa0Ykeca2a3BNRLnIUjIird
	 qxy6NMoMyF95YrJHvhXzfsA3w/yhOS5VY0BwwuEVZv7gt0xHYJwQXrrLsWW03ABtVS
	 4bsRK7es+cY4Q==
Date: Wed, 16 Sep 2026 14:34:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-ID: <aqqaaDqTDahlZ7bR@gremlin>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>

On Tue, Sep 08, 2026 at 11:57:36AM -0400, Tal Zussman wrote:
> The memcg accessors, lruvec helpers, and stat readers only read from
> the memcg, folio, or lruvec they are given, but take non-const
> pointers. Constify them, along with a couple other helper functions in
> mm/page_counter.c along the way.
>
> This started as a follow-up to [1] that quickly grew in proportions :)
>
> [1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

:)

I looked through it, all looks sensible, and it compiles locally and
const-ifies things so it's all good AFAIC! So:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

For the whole series :)

>
> ---
> Changes in v2:
> - Patch 3: Constify the folio argument of folio_lruvec_relock_irq() and
>   folio_lruvec_relock_irqsave() as well, per Sashiko
> - Patch 3: Note that mem_cgroup_lruvec() updates lruvec->pgdat in the
>   per-node structure, not the memcg, per Sashiko
> - Patches 3 and 8: Use container_of_const() in lruvec_memcg() and the
>   lruvec_page_state() family, per Sashiko
> - Link to v1: https://patch.msgid.link/20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu
>
> ---
> Tal Zussman (11):
>       mm: memcontrol: take a const folio in folio_memcg() and friends
>       mm: memcontrol: constify obj_cgroup_memcg() and friends
>       mm: memcontrol: constify the lruvec helpers
>       mm/page_io: take a const folio in bio_associate_blkg_from_folio()
>       mm: memcontrol: constify the mem_cgroup accessors
>       mm: page_counter: constify page_counter_read() and page_counter_margin()
>       mm: memcontrol: constify the reclaim protection helpers
>       mm: memcontrol: constify the memcg and lruvec stat readers
>       mm: memcontrol: constify the swap accounting helpers
>       mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
>       mm: memcontrol: constify the zswap and socket pressure helpers
>
>  include/linux/memcontrol.h   | 204 ++++++++++++++++++++++---------------------
>  include/linux/mmzone.h       |   2 +-
>  include/linux/page_counter.h |   4 +-
>  include/linux/swap.h         |  12 +--
>  mm/memcontrol.c              |  49 ++++++-----
>  mm/page_counter.c            |   2 +-
>  mm/page_io.c                 |  14 +--
>  mm/swap.h                    |   2 +-
>  8 files changed, 148 insertions(+), 141 deletions(-)
> ---
> base-commit: 9d3243fc689fef444f87e0a703b4c99653137e1b
> change-id: 20260807-folio_memcg-const-4a67e40d485b
>
> Best regards,
> --
> Tal Zussman <tz2294@columbia.edu>
>

--
Cheers, Lorenzo

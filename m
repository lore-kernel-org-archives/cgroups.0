Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA434D6C22;
	Wed, 16 Sep 2026 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579729; cv=none; b=aN2blgwcON7hcztQ3w7jb8SmYbAVTLVRenivlyOcLULL96BBBeI/8+jftiMczNH9V6Ur5bW0DPZ5DBc9QXr7veZYeZ6lNNP1USMS007/nlNQXzSY5kpB4FW51tpK00TqPQ/0GI4VYajSYBWw706UA5WYBe9XS7Hx+0TwtJzZiMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579729; c=relaxed/simple;
	bh=8NtqovApGf8dvKnjUST6br5s7d5zKceLLw06RUJrpIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tr6gfIc/zhN8lWlJwvJ8z8MR13KyWVOCcnzBnv0N20O4IeuSxNDagLeVMqEBjz1VGcHqu7+NNojOKf/REnPDTQkkkHpPgcGXYyyrtHyf0PqjobINVxGQo17eILHpzesJ88D8ZQllEf1aorpJsq4pRZ64k94WY+EcTX+P5qt6qEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnA3Mnwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnA3Mnwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD261F000FF;
	Wed, 16 Sep 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789579726;
	bh=8NtqovApGf8dvKnjUST6br5s7d5zKceLLw06RUJrpIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cnA3MnwcbVLsJ11I+8hYtmzPV27C3NRL5NVBmMMsbRrnYusv1fuUyeDaEcrEylZ4Q
	 TPDczkYw3kZbarkCsiptbpLP2ywaNSrq6VJL0PtRbMwBnbC53v0hDsYqujLYQL+YIh
	 itAiwVGFDPnTEmWE6Fe2qmgdBc6Zqi7Sd98tgG0rMD8CE0BccS9nbJf4SAY37iQU/M
	 5XbvEAV2bqAZf2L+E2GrKEaR2M58wnZUBUIOzdw/Lg63m1e0IYJVjq3WPaqKaxO+wP
	 zMpQyU3Acqw6M8uuLPRGlXbJPV+B2zZbWYlphDkAFDyYkbFa9BzLOeZBiGJ5r+gN1N
	 EVY6U32ALGvBw==
Date: Wed, 16 Sep 2026 18:28:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-ID: <aqrRewVuKfPk7y1U@lucifer>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260916035222.GA19557@shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916035222.GA19557@shakeel.butt@linux.dev>

On Tue, Sep 15, 2026 at 08:53:10PM -0700, Shakeel Butt wrote:
> On Tue, Sep 15, 2026 at 07:20:04PM -0400, Tal Zussman wrote:
> > The memcg accessors, lruvec helpers, and stat readers only read from
> > the memcg, folio, or lruvec they are given, but take non-const
> > pointers. Constify them, along with the page_counter readers and the
> > swap I/O blkg helpers along the way.
> >
> > This started as a follow-up to [1] that quickly grew in proportions :)
> >
> > [1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/
>
> For the whole series:
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Oops, I replied on the v2 with the same:

https://lore.kernel.org/linux-mm/aqqaaDqTDahlZ7bR@gremlin/

but obviously, equally so for v3 :) thanks for doing this!

For whole series:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

Received: from mta0.migadu.com (out-110.mta0.migadu.com [91.218.175.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA5F5CDF1
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 00:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787187450; cv=none; b=UiA/og6NOr/mOe+clUP7wM6JnELtJovncX6szbJwNw2PJTlpPXr/GuaSYxiHJ+9V1k/uFChIdwvzkwQhzLJOba288G+Zgv7NcXDquMMvj7+MhKGtL05BiSdom3zE0b9RPPeZKpOF57FAFNdErmxBaoeUlRZ5zNNrpdfiKc8HHvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787187450; c=relaxed/simple;
	bh=W5bMEGa3K0yKxwJJ056tu4gCbLooVX1YsofUpz0vBZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zp/nmIJM0Ec8Py+1Jxkoy22o9ct9IJPvKZ8XLzaCKszq1+JVVp4oSZUOgG66DUzqnK2i/ONbWUcZqkj1TrQdsuHPwzDMXNCAdje0BO/86AXCP40OGrBI0wSSI9X6RTT45+eybAnQLB6DO8sMGdPF4jdzORDEaPmPMlpgUlgt8+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pe7zO9zO; arc=none smtp.client-ip=91.218.175.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pe7zO9zO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=W5bMEGa3K0yKxwJJ056tu4gCbLooVX1YsofUpz0vBZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787187445; v=1; x=1787792245;
 b=Pe7zO9zOQTqAq5uNnVZid5txuhBeo716DGjKXmN8B6Uw4crSGltQ2UUbZdv7AGUrcTxijvye
 LvIAkWGDWuHDRIMPd7BanrhJ/QqPJHH956vHq33W+gaEJDvtj+on7cvw7Z6BDzv1+8NNw7YweFb
 FosP9D0qnAFFrQyPp7E0npKg=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id de9ebbe7155f0653;
	Thu, 20 Aug 2026 00:57:25 +0000
X-Mizu-Trace-ID: de9ebbe7155f0653
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 08:57:18 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
Message-ID: <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>

On 08/20/26 at 08:53am, Baoquan He wrote:
> On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > The helper should never be called for an off-list folio, and it always
> > expects the folio to be in the oldest generation before doing any
> > cmpxchg. Add a sanity check for the off-list case: if it is ever
> > violated, bail out and keep the folio flags untouched to minimize the
> > damage, instead of silently treating the folio as if it were in the
> > oldest generation and promoting it updating the flags to an unexpected
> > status.
> > 
> > Also rename the variables to clearly distinguish the folio's current
> > gen from the oldest gen.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7169cac60869..7e3ae0c6cba3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> >  {
> >  	int type = folio_is_file_lru(folio);
> >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> >  	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> >  
> >  	do {
> > -		new_gen = lru_gen_from_flags(old_flags);
> > +		old_gen = lru_gen_from_flags(old_flags);
> > +		/* This helper should never be called for off-list folios */
> > +		VM_WARN_ON_ONCE(old_gen < 0);
> > +		if (old_gen < 0)
> > +			return min_gen;
> 
> As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
> could only happen inc_min_seq() call it. While inc_min_seq() call it
> because inc_max_seq() need increase max_gen to max_gen + 1 and found
> get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
                                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
  ~~~~~~~~~~~~~~~~
Here, I mean it has to move folios from the oldest gen (min_gen) to the 2nd
oldest gen (min_gen + 1). The empty min_gen will become the new max_gen.

> be put in the lastest max_gen. It may not be expected.
> 
> >  
> >  		/* folio_update_gen() has promoted this page? */
> > -		if (new_gen >= 0 && new_gen != old_gen)
> > -			return new_gen;
> > +		if (old_gen != min_gen)
> > +			return old_gen;
> >  
> >  		new_flags = old_flags;
> > -		new_gen = (old_gen + 1) % MAX_NR_GENS;
> > +		new_gen = (min_gen + 1) % MAX_NR_GENS;
> >  		lru_gen_set_flags(&new_flags, new_gen);
> >  		lru_refs_set_flags(&new_flags, 0);
> >  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > 
> > -- 
> > 2.55.0
> > 
> > 

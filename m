Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293E331F998
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 02:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787192851; cv=none; b=koGgvVlTp+RuH+wVBFhcYL3m9C4lF3itjI5JqTgAbSVLDTuU+jAmnKGFAASjmzrvSfJkM+TfVCOrF8/4RHz0YE/S0/nE1ym7/aSgZOtk86BMLq8Gi6MJvCfffN7sC22x/4rUHrY41Yv8o4aeAi8quMnC0ra7e7bv9aJK3m8ATw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787192851; c=relaxed/simple;
	bh=YsLQYCJr8WPj7R2aBamgjE8gGQQJpFvoi1/lm8X5IB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+QCbbGMSeIz3OHNyv8/yeqzVVP6TD6Uw84BpYocj9janVJ16REu3+1fjXpZqt7qQAaQs+q4xduB0dPSG+uvFmZzwni1+2fTPzVivezPLz6yTkbjQSFCre5GEt6tRIEeDuT5Jms3by/oERjmItg4Ia9RNOZZSB/pPLIbwi6h8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HOf6XJKz; arc=none smtp.client-ip=95.215.58.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HOf6XJKz"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YsLQYCJr8WPj7R2aBamgjE8gGQQJpFvoi1/lm8X5IB4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787192846; v=1; x=1787797646;
 b=HOf6XJKzTVKXrRUgzNQNf/wWhwJbXpHvCzQgikLhTssWrA/2WOGs4j/6iJwM71EmY1DAQDd0
 D5Mdj4UC5oM7ndyX12a0mNOteBFkvAp/D6V0cI9rLbgzSfF03FRURUAHwFufJtppND2xegtGO4Z
 cyuAiqG1UG4NcjHta6zod+OQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (223.70.159.239)
	by mta12.migadu.com with ESMTPS id 541c12e0acfb2d92;
	Thu, 20 Aug 2026 02:27:26 +0000
X-Mizu-Trace-ID: 541c12e0acfb2d92
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 10:27:17 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
Message-ID: <aoZmBUKokVVwGzUr@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>
 <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
 <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>

On 08/20/26 at 09:02am, Baolin Wang wrote:
> 
> 
> On 8/20/26 8:57 AM, Baoquan He wrote:
> > On 08/20/26 at 08:53am, Baoquan He wrote:
> > > On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > > 
> > > > The helper should never be called for an off-list folio, and it always
> > > > expects the folio to be in the oldest generation before doing any
> > > > cmpxchg. Add a sanity check for the off-list case: if it is ever
> > > > violated, bail out and keep the folio flags untouched to minimize the
> > > > damage, instead of silently treating the folio as if it were in the
> > > > oldest generation and promoting it updating the flags to an unexpected
> > > > status.
> > > > 
> > > > Also rename the variables to clearly distinguish the folio's current
> > > > gen from the oldest gen.
> > > > 
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >   mm/vmscan.c | 14 +++++++++-----
> > > >   1 file changed, 9 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 7169cac60869..7e3ae0c6cba3 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> > > >   {
> > > >   	int type = folio_is_file_lru(folio);
> > > >   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > > > -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > > > +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > > >   	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > > >   	do {
> > > > -		new_gen = lru_gen_from_flags(old_flags);
> > > > +		old_gen = lru_gen_from_flags(old_flags);
> > > > +		/* This helper should never be called for off-list folios */
> > > > +		VM_WARN_ON_ONCE(old_gen < 0);
> > > > +		if (old_gen < 0)
> > > > +			return min_gen;
> > > 
> > > As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
> > > could only happen inc_min_seq() call it. While inc_min_seq() call it
> > > because inc_max_seq() need increase max_gen to max_gen + 1 and found
> > > get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
> >                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
> >    ~~~~~~~~~~~~~~~~
> > Here, I mean it has to move folios from the oldest gen (min_gen) to the 2nd
> > oldest gen (min_gen + 1). The empty min_gen will become the new max_gen.
> > 
> > > be put in the lastest max_gen. It may not be expected.
> 
> But how does old_gen < 0 actually happen? folio_inc_gen() is called under
> the lru lock, so how can a folio listed in MGLRU have a gen counter < 0? If
> this can happen in any case, we should fix this bug first.

That's a good question, and I agree with you that folio_inc_gen() is
called under lru lock, and lru_gen_del_folio() which clears the gen
and take folio off lru is also called under lru lock. So old_gen < 0
here is a "should never happen" defensive branch (plus the
WARN_ON_ONCE), and if it really occurs there is a real bug to fix.
Wondering how Barry trigger his printk debugging and observed it.

However, the defensive branch itself is incorrect. Not only folio of
old_gen < 0 are put in the new max_gen, but what is worse, it doesn't
clear the old_gen <0 in folio->flags even though it's put back in the
min_gen list, next time aging comes to next round of min_gen and sort_folio()
will get a lrugen->folios[-1] out of bound accessing

static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
                       int tier_idx)
{
	...
        /* promoted */
        if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
                list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
                return true;
        }
	...
}

So I think we should keep the old code unchanged, fix any warning report 
triggered by VM_WARN_ON_ONCE(old_gen < 0).


Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034B67E0E4
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 04:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787113072; cv=none; b=u5d6iZ6VsemxZL4FsYB4S+Sk+oy3uqgCnh0QZorU4HXzMFraU7Dkb7kscuIkH5cnCbSa2HZ1e2HUXf5627Sog7Nzk9TsoMHE0rc41PjmFKJSegGT8C4YOy9Z7X/XeoUS4zhHt8GmUibx83OCjIRN/htrYD/3Au7D8nyASs/EIKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787113072; c=relaxed/simple;
	bh=Q+PLboonZfwRxCT+BhYUeKFrPbFMM0JQG6QWMalmcG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TShXzt8bwJHQFK/fwoVyH3xddlcdJsVcNXojwovIO8C0cMzMolIH219XYP/NZhqWq8ong/NGX/EL8ESu9NGK1BG2GhMGnm1edbcn+xkhAZpu5pMJ9DN8eNU+r85NHLr7+F+hV3Lv0kowj3JH8SvJtyg1RQJig5yOyjH7VkNQN4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VuFJz85W; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuFJz85W"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7f3fd905828so438911a34.1
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 21:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787113070; x=1787717870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FIurJflnvFF91DRPSkKVXaQAGarfbqju+vgf+4SCSCM=;
        b=VuFJz85WWA4WTFqqaikQvq5DYUmO51HK9Y+OJ8e9kWWquFFeV6In0DKd9MF3hoGDHD
         /x1JpWvzgd90XWZ0o4i1TAzoV30kdMlnpHP/J60ejrapALyPVmTepZcXbVoB/54jkty3
         R9cBWWKYRukFvx9BOQzTdB26fRUrGiV5pY89rApYGg9SVOIC0CtcRuqgSTvQXKbjODGh
         AQ8SNnzmbCNh3FDrI1qfcj7MAWEraeHYhabyavyuZvugbztle9ZDH2yxvWdQl3rCrPsg
         feXPlTLaZFGdk5uVwjEjPSUAA72njN8R3IKOFhUx3AoAxmL3tZJOnyQfLIU7T1EHRsh3
         L5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787113070; x=1787717870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FIurJflnvFF91DRPSkKVXaQAGarfbqju+vgf+4SCSCM=;
        b=H5jFD57uNretiYCoBcldgjRdlb/jqHZVFEfKR/13r2mBWtLWBJK/7uNIAKMAYDLKdH
         BwLUl7I6xoinDeK5P4l1+bl2Fsk+cwlGpHelt9/s+EGt+O2bTy0+SJqOhhiJ5ilZAZLk
         o82lN4jQUYKXwkHmvSrmr7yAqzpSvT7xWFaVWr0LUL89W9wHJnLXjFXsLD8FUZ8fLqHA
         r5D1r3Mfz+6ECFx0nqBzy8VTXC/2OQoZ8SMaR5G81tMxSBErFO3VBPwHxPYsx5PRJNN+
         CmQ7haFsA1I/9uimQyKTDBHMMPIsDlJpcHCHQvqpDv9nVzHAE0ciCprPWHZNaRvawj+y
         UoaA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Jn+LprXhjEOvhqZ3L925UCWYcHU34pgQRPQEjV6PuJy5z6mXu9ySsUX3wo7V2k07q9OH5ONG@vger.kernel.org
X-Gm-Message-State: AOJu0YwkFZkFtQfTYaD2ifrvfYlFyJMlJ3EpsKnQi9mMmY0Q6DnLHatv
	1CWK0inl/jPllmedOV48vosTmeWaCy+G8yPg2l9x7BNh4DyFmJbwgkSa4EE/FQ==
X-Gm-Gg: AR+sD11GicBhnmHt2LxaXm7Ctzs98LznhvblRkvTGQdixQj6j2A2LAEaqZbb36X+5bX
	DILfpTDicaq8JKCO2LA+PZCSBN5a9dnJxnBaB654xVhLaVFx2BtFEB6dR9QhrG5DsbRmad2D2ZK
	OcFTdHQ6fCF3KpaU6qh3Z/Jz+mGHL5BA/NGZXw483BnQg3EOdFkz4usY/OWRjn/Fnm/1zvjnHEO
	cJWAdgw39p7VjB+uGVHcUVDxBhQlFViSbcvFYtoRwB8PVSNS9bvXLJ6luiqSFNbrPIMeMxsuM65
	eEoGPQcWMmocJQ9fK2MfB2M7WNjxTBGQkzXTs1WDR5jV1gTvMSx7Ca/Qn1qyfkEXXr6akGbJV13
	zH68XpDDbA758XfXxcMvCEWrnErm1nXjFtPmYaewJ/mnyY9R9kdU1kHMAewXVlWLBOXyLaiMmfR
	x/GLQd50rj+4cClQJUwfKIayUguKbe9eR/wEaPj+KibKfP1v3hA6LnXmY5mkDnJ2NFyZV2qVdPl
	0UyT6DWku1qskpUkA==
X-Received: by 2002:a05:6830:83b9:b0:7f4:922:ee8 with SMTP id 46e09a7af769-7f43fae4861mr1800325a34.10.1787113069803;
        Tue, 18 Aug 2026 21:17:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f440022fdasm708924a34.13.2026.08.18.21.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 21:17:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining it
Date: Tue, 18 Aug 2026 21:17:46 -0700
Message-ID: <20260819041747.1111965-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoQt2zKsQT-rvjd6@tiehlicka>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 18 Aug 2026 12:03:07 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 17-08-26 16:46:51, Shakeel Butt wrote:
> > Joy reported that an application generating a request/response traffic
> > pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> > for a range of message sizes, against 0.27% to 0.71% outside that range.
> > Running from the root memcg, where socket memory accounting is skipped,
> > recovers the performance.
> > 
> > Tracing the charge path showed that the application generates a pattern
> > where the write syscall charges one page and the read syscall uncharges
> > two pages on the same CPU. This hits a corner case in the memcg percpu
> > stock code that thrashes the stock continuously.
> > 
> > In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> > watermark and the emptying target, i.e. on a request to charge one page
> > the kernel charges MEMCG_CHARGE_BATCH pages and caches
> > (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> > uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> > and refill_stock() then empties the cache completely. With such a
> > pattern the percpu stock becomes completely ineffective.

To be honest I never really understood why returning the stock and
making the nr_pages go over the batch size completely drained the stock.
One theory that I had was that if one uncharging is indicative that there
will be more future uncharges coming and we want to make room for those
uncharges to deposit their stocks, but now that I'm looking through the
code I'm pretty sure that sequential stock uncharges are not that
common, since we use uncharge_gather to batch up the LRU batch uncharging
area.

> > Instead of a single boundary point for charges, use the technique the
> > page allocator uses for its own percpu caches, which keeps the watermark
> > and the emptying target apart: nr_pcp_free() frees between batch and
> > high - batch pages, leaving at least pcp->batch on the list. Add a high
> > watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> > return only the pages above MEMCG_STOCK_LOW. The watermarks are
> > MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> > batch. Peak cached pages per memcg grows from 64 to 96, the same
> > high-versus-batch tradeoff the page allocator makes.

> The idea is sound. I would just not increase the overall stock size in
> the same patch. Fine tuning can be done independently and ideally with
> some numbers.
> Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
> and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
> the maximum stock size while preventing all or nothing behavior which is
> indeed suboptimal and pushing charging path to a slower path way too
> aggressively.

I like this idea and I think you meant { MEMCG_CHARGE_LOW :=
MEMCG_CHARGE_BATCH / 2 } right? That way the only new change we
reintroduce is to always drain to a level when we return too many
pages to the stock.

Have a great day, Michal and Shakeel!
Joshua

> WDYT?
> 
> > Reported-by: Joy Chaoyue Xiong <joyxiong@yahoo.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/memcontrol.c | 31 +++++++++++++++++++++++++------
> >  1 file changed, 25 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17da1f43b7d3..ff7fbcd27422 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2048,6 +2048,21 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
> >   * nr_pages in a single cacheline. This may change in future.
> >   */
> >  #define NR_MEMCG_STOCK 7
> > +
> > +/*
> > + * Watermarks for a charge stock slot, in the spirit of pcp->high and
> > + * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
> > + * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
> > + *
> > + * Using MEMCG_CHARGE_BATCH as both high watermark and emptying target
> > + * thrashes: charging one page stocks 63, an uncharge of 2 takes the count
> > + * to 65 and empties the slot, and the next charge misses. The watermarks
> > + * are MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a
> > + * full batch.
> > + */
> > +#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
> > +#define MEMCG_STOCK_HIGH	(MEMCG_STOCK_LOW + MEMCG_CHARGE_BATCH)
> > +
> >  #define FLUSHING_CACHED_CHARGE	0
> >  struct memcg_stock_pcp {
> >  	local_trylock_t lock;
> > @@ -2223,17 +2238,18 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  {
> >  	struct memcg_stock_pcp *stock;
> >  	struct mem_cgroup *cached;
> > -	uint8_t stock_pages;
> > +	unsigned int stock_pages;
> >  	bool success = false;
> >  	int empty_slot = -1;
> >  	int i;
> >  
> >  	/*
> > -	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
> > -	 * decide to increase it more than 127 then we will need more careful
> > -	 * handling of nr_pages[] in struct memcg_stock_pcp.
> > +	 * nr_pages[] is a uint8_t and a slot's count is capped at
> > +	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
> > +	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
> >  	 */
> >  	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
> > +	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
> >  
> >  	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
> >  
> > @@ -2254,9 +2270,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  			empty_slot = i;
> >  		if (memcg == READ_ONCE(stock->cached[i])) {
> >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > +				memcg_uncharge(memcg,
> > +					       stock_pages - MEMCG_STOCK_LOW);
> > +				stock_pages = MEMCG_STOCK_LOW;
> > +			}
> >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > -			if (stock_pages > MEMCG_CHARGE_BATCH)
> > -				drain_stock(stock, i);
> >  			success = true;
> >  			break;
> >  		}
> > -- 
> > 2.53.0-Meta
> 
> -- 
> Michal Hocko
> SUSE Labs

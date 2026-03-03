Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F8521D3E2
	for <cgroups@vger.kernel.org>; Tue,  3 Mar 2026 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772545525; cv=none; b=gNPua8txnjoseAM0JRu7qNAAcr2dnTqevTJ9lTHIqM+pFJTRx+5NO24+0J7Wc3pHvyL74F0rHprmrsGfFyYM9/oUtNruuRs6Ce8F/2vOfUxXdlh4xatE+/l+FgmrC+pYOPWUTPYGsGBginb+77/wG6yHFiKGj2bldy0yAVNg3uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772545525; c=relaxed/simple;
	bh=fxEj+cNMnlgyX8cFm7qvlHS20lcaCbwAkSbGB26gcKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uf87qLfJkWFHlez6OTvDSE/1dMVuasCyyE990/Z7nn+DAPmkY+6LpGDzvFwBofPwI9oYDnMwql92CSjLAzOxCkdyPx5jsb/AY1x4Wq3kMBKzg8isj1hh9aGdEE9sqQQWyI92C/y4FarcoxH2l1niLW4citXh2N9/X6O6AQVGd3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NO7o3ebi; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NO7o3ebi"
Date: Tue, 3 Mar 2026 05:45:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772545522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W3cDdicZmTJGsrJ93Z00IaY7+tBeVssbAV0nwfydT7Q=;
	b=NO7o3ebiu/lXOgRIsnDdillpTCZEhFFuus4HkPuivwr/d8AFliAgO9uFRLKy/Ax6XnLqPo
	neebTbcVkrH3sFYTZL2TQ1fIsGMAS9rXI6UTgXRyqv9mCSJ3A2G/mW8yONl0k+mCsbLbXQ
	EbM4iRry+BsD7AD634uk0eZrCy3aEAg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <aablae2eFl9ne5fW@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
 <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
 <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 03, 2026 at 11:42:31AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/3/26 09:54, Hao Li wrote:
> > On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> >> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> >> charge cache. However, the intertwined code to manage those dependent
> >> caches right now is quite difficult to follow.
> >> 
> >> Specifically, cached slab stat updates occur in consume() if there was
> >> enough charge cache to satisfy the new object. If that fails, whole
> >> pages are reserved, and slab stats are updated when the remainder of
> >> those pages, after subtracting the size of the new slab object, are
> >> put into the charge cache. This already juggles a delicate mix of the
> >> object size, the page charge size, and the remainder to put into the
> >> byte cache. Doing slab accounting in this path as well is fragile, and
> >> has recently caused a bug where the input parameters between the two
> >> caches were mixed up.
> >> 
> >> Refactor the consume() and refill() paths into unlocked and locked
> >> variants that only do charge caching. Then let the slab path manage
> >> its own lock section and open-code charging and accounting.
> >> 
> >> This makes the slab stat cache subordinate to the charge cache:
> >> __refill_obj_stock() is called first to prepare it;
> >> __account_obj_stock() follows to hitch a ride.
> >> 
> >> This results in a minor behavioral change: previously, a mismatching
> >> percpu stock would always be drained for the purpose of setting up
> >> slab account caching, even if there was no byte remainder to put into
> >> the charge cache. Now, the stock is left alone, and slab accounting
> >> takes the uncached path if there is a mismatch. This is exceedingly
> >> rare, and it was probably never worth draining the whole stock just to
> >> cache the slab stat update.
> >> 
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >> ---
> >>  mm/memcontrol.c | 100 +++++++++++++++++++++++++++++-------------------
> >>  1 file changed, 61 insertions(+), 39 deletions(-)
> >> 
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 4f12b75743d4..9c6f9849b717 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -3218,16 +3218,18 @@ static struct obj_stock_pcp *trylock_stock(void)
> >>  
> > 
> > [...]
> > 
> >> @@ -3376,17 +3383,14 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
> >>  	return flush;
> >>  }
> >>  
> >> -static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> >> -		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
> >> -		enum node_stat_item idx)
> >> +static void __refill_obj_stock(struct obj_cgroup *objcg,
> >> +			       struct obj_stock_pcp *stock,
> >> +			       unsigned int nr_bytes,
> >> +			       bool allow_uncharge)
> >>  {
> >> -	struct obj_stock_pcp *stock;
> >>  	unsigned int nr_pages = 0;
> >>  
> >> -	stock = trylock_stock();
> >>  	if (!stock) {
> >> -		if (pgdat)
> >> -			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
> >>  		nr_pages = nr_bytes >> PAGE_SHIFT;
> >>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
> >>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
> >> @@ -3404,20 +3408,25 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> >>  	}
> >>  	stock->nr_bytes += nr_bytes;
> >>  
> >> -	if (pgdat)
> >> -		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
> >> -
> >>  	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
> >>  		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> >>  		stock->nr_bytes &= (PAGE_SIZE - 1);
> >>  	}
> >>  
> >> -	unlock_stock(stock);
> >>  out:
> >>  	if (nr_pages)
> >>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
> >>  }
> >>  
> >> +static void refill_obj_stock(struct obj_cgroup *objcg,
> >> +			     unsigned int nr_bytes,
> >> +			     bool allow_uncharge)
> >> +{
> >> +	struct obj_stock_pcp *stock = trylock_stock();
> >> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
> >> +	unlock_stock(stock);
> > 
> > Hi Johannes,
> > 
> > I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
> > the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
> > refill_stock(), which seems non-trivial, this might increase the lock hold time.
> > In particular, could that lead to more failed trylocks for IRQ handlers on
> > non-RT kernel (or for tasks that preempt others on RT kernel)?
> 
> Yes, it also seems a bit self-defeating? (at least in theory)
> 
> refill_obj_stock()
>   trylock_stock()
>   __refill_obj_stock()
>     obj_cgroup_uncharge_pages()
>       refill_stock()
>         local_trylock() -> nested, will fail

Not really as the local_locks are different i.e. memcg_stock.lock in
refill_stock() and obj_stock.lock in refill_obj_stock(). However Hao's concern
is valid and I think it can be easily fixed by moving obj_cgroup_uncharge_pages()
out of obj_stock.lock.

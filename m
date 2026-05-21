Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DAF30567F
	for <cgroups@vger.kernel.org>; Thu, 21 May 2026 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779394813; cv=none; b=kGcY+ypLhaJH5aW6q8GQri/NCcjjcWIrQPl4+RmqU4ys8M0jKMZlSf0Gg5VYTDidePO8QGAnRfBG3tlcumeqUl91b8DFjxdjM/P58gGEbziskMcFKIRMb4B4T5b5k66e31Ac8zpaSquYZYVrJS38Wuh3LN9htmog7VTPw/u4plw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779394813; c=relaxed/simple;
	bh=Bw6jalKlC9w1cSYk++Qdhdu9pNxmCau8U7ev91orHDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyC0OVrQkXtsSrwKMnEmunN4aY6UAhwq0iJ+AB41DRJXFyK0gnjOPWiIEhhDl5RYRUr315wJ0rWAbbo7tp6cSH1sK5BuYVN3cUROITP4FffEPBTQnXwoZCONrmremgrfDV+aWDxUPcx9Iy6bIheuu/vwMTC3aU/+JmrK2lZVp3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nEQtuv0x; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nEQtuv0x"
Date: Thu, 21 May 2026 13:19:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779394799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1aLZ0HlXtKFWVVwkKR6v6sdQWwQbXSZNyJVtm2fhj0=;
	b=nEQtuv0xHCBw+Ve3KoqfOdRpzaPEB9fSyUJqAB7jJ9CWE3kg2sh51MdKK42+XH6TAXbx6P
	3DDdGQc/EL1VQltNQ7aksGMgEby3Ci8DmqXBqwBgl46nUnjgKj1wNkbAdbalLyY6m9HPXM
	9g0jDjIY3sbF6wtd/Uxvz1v5PosvjDg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 4/4] memcg: multi objcg charge support
Message-ID: <ag9hFJv_LOJh7IVE@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-5-shakeel.butt@linux.dev>
 <4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org>
 <ag5Z9uIMoXpr3rLP@linux.dev>
 <5b09f618-3b84-4163-84f9-f3adc0f1cc97@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b09f618-3b84-4163-84f9-f3adc0f1cc97@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 21, 2026 at 10:43:11AM +0900, Harry Yoo wrote:
> 
> 
> On 5/21/26 10:05 AM, Shakeel Butt wrote:
> > On Wed, May 20, 2026 at 06:35:30PM +0900, Harry Yoo wrote:
> > > > @@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > > >    		goto out;
> > > >    	}
> > > > -	stock_nr_bytes = stock->nr_bytes;
> > > > -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> > > > -		drain_obj_stock(stock);
> > > > +	for (i = 0; i < NR_OBJ_STOCK; ++i) {
> > > > +		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
> > > > +
> > > > +		if (!cached) {
> > > > +			if (empty_slot == -1)
> > > > +				empty_slot = i;
> > > > +			continue;
> > > > +		}
> > > > +		if (cached == objcg) {
> > > > +			slot = i;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	if (slot == -1) {
> > > > +		slot = empty_slot;
> > > > +		if (slot == -1) {
> > > > +			slot = get_random_u32_below(NR_OBJ_STOCK);
> > > 
> > > It would break kmalloc_nolock() because _get_random_bytes() uses a spinlock.
> > > perhaps prandom_u32_state() should be sufficient in this case.
> 
> s/spinlock/local_lock/

I do see spinlock in crng_make_state() for some code paths.

> 
> > > Is there a reason why it uses random eviction, unlike multi-memcg percpu
> > > charge cache?
> > 
> > Oh I didn't know and actually we are already using get_random_u32_below() in
> > refill_stock(). So, it need fixing as well. That would be a separate patch.
> 
> Ouch, I see.
> > I will explore prandom_u32_state().
> 
> Thanks!
> 
> FYI, SLUB had a similar issue that was recently fixed:
> commit a1e244a9f1778 ("mm/slab: use prandom if !allow_spin").
> 
> It uses prandom if spinning is not allowed when shuffling slab freelist.

The drain does not really need a random number. Fixing an index like 0 makes it
much simpler but it might expose some corner cases. Round robin might be enough
for this though. I will see what would be the easiest way forward.

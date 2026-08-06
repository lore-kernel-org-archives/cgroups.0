Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E424B36403D
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786034303; cv=none; b=oezQTyD+Q+mlfLtny2VH/ctCM5rcypKIAaVkwpSLcux45nggH0SN8xI+A4M52RaU/e29QUZQgQNhg8xfDrPABnJDRI1x/zqkd9KGNQZ6eYw7eYFlMJalSfBH5ZjYV1XiE13wMeUNQJEXZH56XBLUWji+r5UBdP8iZUAgtwvaeqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786034303; c=relaxed/simple;
	bh=Pe5/q4XlKH2YMxprPzmypd6HB2HW0LbqYSh/X4sLGJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V83Pu2HxgPkXjRkEkcJWMpuzbxyGqC1oOmioZyBPrQfkX9tJXkJfbfNYlYTu9QtHDjyBquFfeboRPdBPYDQb/fZSX2guiqBy+whzNrlDuQKm239UEPkOXfGqcFkts5k1CdeVrpnwxoc5RsXSL/UfCLNaPv/ml9HGceQmI+IRR6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hkvBpT7D; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hkvBpT7D"
Date: Thu, 6 Aug 2026 09:37:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786034299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ER4hDuyk/AXCOt6BhnNPQBwbY3PdYFFZY89XoDcPBsE=;
	b=hkvBpT7DRwR5rOmIF5NXXOYMXQWhVRFIw2Ix1e9jw2tCcuiotXDs6/JljnVjb5Sy8TuYBn
	v1DzI2/aLXzx91MTnb65qkoO3DuWYys3VLx9AGtNe72/4q51a/s9SnGGgWPdn3Le8ilDUt
	ck8dR4+GXlYxdaJKD6P0ifR9Ex7Pfjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Karl Erik Hofseth <karl.e.hofseth@opoint.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] memcg: keep folio's objcg same as its node
Message-ID: <anS1HHyoIAPfyk7z@linux.dev>
References: <20260806061830.3294679-1-shakeel.butt@linux.dev>
 <anSsqaD3QAlvQ8cd@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSsqaD3QAlvQ8cd@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 06, 2026 at 11:47:53AM -0400, Johannes Weiner wrote:
> On Wed, Aug 05, 2026 at 11:18:30PM -0700, Shakeel Butt wrote:
> > memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
> > is the objcg of the folio's node.  Folio migration across nodes breaks
> > that assumption: the new folio simply inherits the old folio's objcg
> > while living on a different node.
> > 
> > Once the assumption is broken, the reparenting of the folio's objcg and
> > the reparenting of the folio's LRU list are no longer atomic.
> > memcg_reparent_objcgs() handles one node per iteration and drops all the
> > locks in between, so the objcg gets reparented in the iteration for the
> > objcg's node while the LRU list gets spliced in the iteration for the
> > folio's node.  Any LRU operation on that folio in between resolves its
> > lruvec through the objcg, and thus takes the lru_lock of the wrong
> > memcg, not the lru_lock of the list the folio is actually on.
> > 
> > Fix this by selecting the objcg by folio_nid() at charge time, and by
> > re-deriving it for the destination node in mem_cgroup_migrate() and
> > mem_cgroup_replace_folio().
> 
> Nice sleuthing.

Thanks and it was actually due to very good reproducer provided by Karl.

> 
> > Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> > Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> > Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/memcontrol.c | 33 +++++++++++++++++++++++++--------
> >  1 file changed, 25 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 3057396dda53..2e98788dc8bd 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2966,10 +2966,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
> >  	return folio_memcg_check(virt_to_folio(p));
> >  }
> >  
> > -static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > +static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> > +						      int nid)
> >  {
> > -	int nid = numa_node_id();
> > -
> >  	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> >  		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
> >  
> > @@ -2980,12 +2979,13 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> >  	return NULL;
> >  }
> >  
> > -static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > +static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> > +							   int nid)
> >  {
> >  	struct obj_cgroup *objcg;
> >  
> >  	rcu_read_lock();
> > -	objcg = __get_obj_cgroup_from_memcg(memcg);
> > +	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
> >  	rcu_read_unlock();
> >  
> >  	return objcg;
> > @@ -3029,7 +3029,7 @@ static struct obj_cgroup *current_objcg_update(void)
> >  
> >  		rcu_read_lock();
> >  		memcg = mem_cgroup_from_task(current);
> > -		objcg = __get_obj_cgroup_from_memcg(memcg);
> > +		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
> >  		rcu_read_unlock();
> >  
> >  		/*
> > @@ -5197,7 +5197,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
> >  	int ret = 0;
> >  	struct obj_cgroup *objcg;
> >  
> > -	objcg = get_obj_cgroup_from_memcg(memcg);
> > +	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
> >  	/* Do not account at the root objcg level. */
> >  	if (!obj_cgroup_is_root(objcg))
> >  		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
> > @@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
> >  
> >  	rcu_read_lock();
> >  	memcg = obj_cgroup_memcg(objcg);
> > +
> >  	/* Force-charge the new page. The old one will be freed soon */
> >  	if (!obj_cgroup_is_root(objcg)) {
> >  		page_counter_charge(&memcg->memory, nr_pages);
> > @@ -5438,7 +5439,12 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
> >  			page_counter_charge(&memcg->memsw, nr_pages);
> >  	}
> >  
> > -	obj_cgroup_get(objcg);
> > +	/* If replacing folio of different node, get objcg of that node. */
> > +	if (folio_nid(old) != folio_nid(new))
> > +		objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
> > +	else
> > +		obj_cgroup_get(objcg);
> > +
> >  	commit_charge(new, objcg);
> >  	memcg1_commit_charge(new, memcg);
> >  	rcu_read_unlock();
> > @@ -5478,6 +5484,17 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
> >  	if (!objcg)
> >  		return;
> >  
> > +	/* If migrating to different node, get objcg of that node. */
> > +	if (folio_nid(old) != folio_nid(new)) {
> > +		struct obj_cgroup *old_objcg = objcg;
> > +
> > +		rcu_read_lock();
> > +		objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
> > +						    folio_nid(new));
> > +		rcu_read_unlock();
> > +		obj_cgroup_put(old_objcg);
> > +	}
> > +
> >  	/* Transfer the charge and the objcg ref */
> >  	commit_charge(new, objcg);
> 
> Just noticed Sashiko pointed this out too, but you put old_objcg while
> old->memcg_data still references it. I don't see how that could lead
> to a UAF but it's fragile.

Yeah it is complaining about folio_unqueue_deferred_split(old) accessing
old->memcg_data internally. I will do the put at the end.

> 
> Man, this is hairy. I missed the implications when I suggested to make
> the objcg per node for simplifcation elsewhere. Now locality actually
> matters -_-

Yeah it has become complicated. The other concern Sashiko raised is the case
where the destination node's objcg has reached/reparented to root and the source
node's objcg is still not root. Since we skip root page counters for LRU pages,
this can unbalance them. It's one more check to add.

> 
> A comment describing the race with reparenting would be very helpful.

Will do.

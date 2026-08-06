Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4714486B80
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040135; cv=none; b=bePfAPKiiKU1odP1bVTjW0mQvOedDpXjhrW7494p+wSEgC4Rz+duFo9GnetcPQlumfnAIx3jlSERIly/RyIJDtkIBHzf0XWE+MoM8IHV6KDtapir+FFWqOOACMR9AKR7SZBrVSD1R/UqCIF7m6WEGwfhMqO+8YnIGyH8ddL90i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040135; c=relaxed/simple;
	bh=Gxw0g0RRGV2WWXZn24VepuWr1o3Em88MOlPRHCcqBKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiDrlMgnH2Lq7dVTZJ8Rl5qk8Q0t/gEKE5rzh0adZSnp4rGTc4zhGN+c6RTsNFy+tClVy7fWHBNMzcOTj6Vp2WC25nMmzY4cuVH504dtSnNMZtOiEnJKiAVNgOz/PAD0Wn7Txv77rH3iP6zrxcrYMpHrJu3N7wwJ56cKSLjIiWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=pI/LcN2C; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="pI/LcN2C"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51bfe810293so13254001cf.1
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786040130; x=1786644930; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k5UoSi/kRUvJ5D9A+qAnQzZgG/DBYzn7/rZxUaSi0lw=;
        b=pI/LcN2ChUPnhQc0qPXQLPv2eYAKoB+VKWN1uVaWkAmwaJMUVoljWQJeIBoWBsQ+bO
         ljrXDLi2/m+uIAeqUqJb5/rOb/rvGhBjg9yItEq9j8QubKviMOt1tH8h4fRep2r2eGJb
         UlL7gBxuqjJCBMVnm/gEijOGG/QgrZThiccYtE/fU+mFb1ERywGvaPSbInnyP0kp4q3O
         nK5zCxylnWWhR39EQdLLmhBM/Fipjm5Kooae9iy9isDlYEpt084nONbe4GMOxfSXXKmP
         Bax/sGHGxpAef+92bzEjLY9RRyIMvUN/oISA/lE5OqCUTSSP19Xz9fXEwJ2eKZtnS2IC
         q2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786040130; x=1786644930;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k5UoSi/kRUvJ5D9A+qAnQzZgG/DBYzn7/rZxUaSi0lw=;
        b=I1j3zfSY7WMeCSPFDg3T3/ftRB9ijdtkSY1wfHZZIyBYiwhZC7l02qqmqqTuV4DPpB
         8pleg3VdE8uQA0u/ZzjoMaHROegLIWvpoIbPlHjvYNzncfVYzIawVmONN+fya/ET+qy0
         gl6RWoBHSygaDEjNyCwCRfmnZUFdov4voNsfKOFl9Pqvxwe1167Q0oOOWyHNGnrjOQum
         CoPYHpJeyFlIgJYM7gMNNW7lnZoJu98G6bEGDCDuRuzYh5v/1NDNV0H3f979OHkEHvzZ
         rtWroAYnBuaE64BlFILjt8pd3rLHnEX4NKPA+W472jxzkxxXo00d1dh6FXhbM88sb4am
         4bqQ==
X-Forwarded-Encrypted: i=1; AHgh+RoMVNSgZkNObDYtz30MT4jCNYBEpz7KTR5TcCQJhCSK/wiXhHn89xB7EbTH6YuwGh5XzqgPF79I@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo9g08+xHbVPa/U0hGfvEHhQFoAXdgrYpFpBx69DTj+upR8o/j
	s1VG4zAkfHU2ZQsZUv/pxD5DOg0NEzzfF5UwT8+/a+T0Vod8fQlfhFs/VXPKrtkKOwkxjyNHvpY
	q+esG
X-Gm-Gg: AR+sD130I3ClQ8qOWw15uhISICIVBIs+i5PvNzrLYayFXlY4BN8rMybFmC//2TIXRza
	ZHLBBu8G8FHE4iasldILmeC7SAjq1Ddh5ZovQYnlnA+PuWZpAC/BRpypxYXIKCTNKMupAhSd00x
	LVQn9I4LZ75l2l98ykwJn3lmvsOzWDw6/oHwdBRdiZHUxayuhvI+zXZtG+Nt8nOQrPRkbY9Cxbu
	YtUj8HQ9kAPZEjPDIS8cYJByfoaAMDNn4TTtMKoMgmwRhdwHlUwOHp/GyYTXlwazbx3CTKM8m6Y
	TgFDPMOGKWvuze/xkZpc/nh3yCHMmLDFN8yQMHklyDofcHnp8RqC+BP1nkP5TI6skvE23SMBZhU
	I6mEVOEofU+0ArJOmNgnNywBETb7S/Qp1jPYzY1G1X6IIRyh66EX70V1ZQgmjUMMkktXKKOuE4E
	uG9pc/ni43jQ2XFAlKI7aI0HZCwPBP51NZkPk4Gx7siC3uhngLHB8QLgLb5fw=
X-Received: by 2002:ac8:5d16:0:b0:51c:92a0:b2ca with SMTP id d75a77b69052e-52ce617f426mr167955401cf.34.1786040130400;
        Thu, 06 Aug 2026 11:15:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800cb14csm57278926d6.48.2026.08.06.11.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:15:29 -0700 (PDT)
Date: Thu, 6 Aug 2026 14:15:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] memcg: keep folio's objcg same as its node
Message-ID: <anTPPr5hVV4aQLRD@cmpxchg.org>
References: <20260806165813.2526415-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806165813.2526415-1-shakeel.butt@linux.dev>

On Thu, Aug 06, 2026 at 09:58:13AM -0700, Shakeel Butt wrote:
> memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
> is the objcg of the folio's node.  Folio migration across nodes breaks
> that assumption: the new folio simply inherits the old folio's objcg
> while living on a different node.
> 
> Once the assumption is broken, the reparenting of the folio's objcg and
> the reparenting of the folio's LRU list are no longer atomic.
> memcg_reparent_objcgs() handles one node per iteration and drops all the
> locks in between, so the objcg gets reparented in the iteration for the
> objcg's node while the LRU list gets spliced in the iteration for the
> folio's node.  Any LRU operation on that folio in between resolves its
> lruvec through the objcg, and thus takes the lru_lock of the wrong
> memcg, not the lru_lock of the list the folio is actually on.
> 
> Fix this by selecting the objcg by folio_nid() at charge time, and by
> re-deriving it for the destination node in mem_cgroup_migrate() and
> mem_cgroup_replace_folio().
> 
> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> 
> Changes since v1: http://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev
> 
> - In mem_cgroup_migrate, do obj_cgroup_put at the end (Sashiko)
> - Handle scenario where destination node has been reparented to the root but the
>   source node's objcg has not yet (Sashiko)
> - Add comment explaining the race between migration and reparenting (Johannes)
> 
>  mm/memcontrol.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3057396dda53..02c108cdd0f5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2966,10 +2966,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
>  	return folio_memcg_check(virt_to_folio(p));
>  }
>  
> -static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> +						      int nid)
>  {
> -	int nid = numa_node_id();
> -
>  	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>  		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
>  
> @@ -2980,12 +2979,13 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>  	return NULL;
>  }
>  
> -static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> +							   int nid)
>  {
>  	struct obj_cgroup *objcg;
>  
>  	rcu_read_lock();
> -	objcg = __get_obj_cgroup_from_memcg(memcg);
> +	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
>  	rcu_read_unlock();
>  
>  	return objcg;
> @@ -3029,7 +3029,7 @@ static struct obj_cgroup *current_objcg_update(void)
>  
>  		rcu_read_lock();
>  		memcg = mem_cgroup_from_task(current);
> -		objcg = __get_obj_cgroup_from_memcg(memcg);
> +		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
>  		rcu_read_unlock();
>  
>  		/*
> @@ -5197,7 +5197,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>  	int ret = 0;
>  	struct obj_cgroup *objcg;
>  
> -	objcg = get_obj_cgroup_from_memcg(memcg);
> +	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
>  	/* Do not account at the root objcg level. */
>  	if (!obj_cgroup_is_root(objcg))
>  		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
> @@ -5408,8 +5408,8 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
>   */
>  void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  {
> +	struct obj_cgroup *objcg, *new_objcg = NULL;
>  	struct mem_cgroup *memcg;
> -	struct obj_cgroup *objcg;
>  	long nr_pages = folio_nr_pages(new);
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
> @@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(objcg);
> +
>  	/* Force-charge the new page. The old one will be freed soon */
>  	if (!obj_cgroup_is_root(objcg)) {
>  		page_counter_charge(&memcg->memory, nr_pages);
> @@ -5438,7 +5439,31 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  			page_counter_charge(&memcg->memsw, nr_pages);
>  	}
>  
> -	obj_cgroup_get(objcg);
> +	/*
> +	 * memcg_reparent_objcgs() reparents a node's objcgs and its LRU lists
> +	 * together, under that node's lru_locks. If a folio's objcg is on a
> +	 * different node, the two happen in separate iterations with the locks
> +	 * dropped in between, and an LRU operation in that window takes the
> +	 * lru_lock of the wrong memcg. Keep the objcg on the folio's node.
> +	 */
> +	if (folio_nid(old) != folio_nid(new))
> +		new_objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
> +
> +	/*
> +	 * LRU folios are not accounted at the root level: swapping a non-root
> +	 * objcg for the root one would skip the uncharge and leak the charge.
> +	 * Keep the old one, the root memcg never reparents. No put needed,
> +	 * tryget takes no reference on the root objcg.
> +	 */
> +	if (new_objcg && obj_cgroup_is_root(new_objcg) &&
> +	    !obj_cgroup_is_root(objcg))
> +		new_objcg = NULL;

The two versions have quite some overlap. The refcounting is
different, but IMO that part is also hard to square.

How about a helper that always returns a referenced objcg?

static struct obj_cgroup *get_migration_objcg(struct folio *old, struct folio *new)
{
	struct obj_cgroup *old_objcg, *new_objcg;
	int new_nid = folio_nid(new);
	struct mem_cgroup *memcg;

	old_objcg = get_obj_cgroup_from_folio(old);

	if (folio_nid(old) == new_nid)
		return old_objcg;

	memcg = obj_cgroup_memcg(old_objcg);
	new_objcg = __get_obj_cgroup_from_memcg(memcg, new_nid);

	if (new_objcg && obj_cgroup_is_root(new_objcg) &&
	    !obj_cgroup_is_root(old_objcg))
		return old_objcg;

	obj_cgroup_put(old_objcg);

	return new_objcg;
}

In mem_cgroup_replace_folio(), this becomes:

	rcu_read_lock();

	... page counter update ...

	objcg = get_migration_objcg(old, new);
	commit_charge(new, objcg);
	memcg1_commit_charge(new, memcg);

	rcu_read_unlock();

> +
> +	if (new_objcg)
> +		objcg = new_objcg;
> +	else
> +		obj_cgroup_get(objcg);
> +
>  	commit_charge(new, objcg);
>  	memcg1_commit_charge(new, memcg);
>  	rcu_read_unlock();
> @@ -5457,7 +5482,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>   */
>  void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  {
> -	struct obj_cgroup *objcg;
> +	struct obj_cgroup *objcg, *new_objcg = NULL;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
>  	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
> @@ -5478,12 +5503,29 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  	if (!objcg)
>  		return;
>  
> -	/* Transfer the charge and the objcg ref */
> -	commit_charge(new, objcg);
> +	/* Keep the objcg on the folio's node, see mem_cgroup_replace_folio() */
> +	if (folio_nid(old) != folio_nid(new)) {
> +		rcu_read_lock();
> +		new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(objcg),
> +							folio_nid(new));
> +		rcu_read_unlock();
> +
> +		/* No root swap, see mem_cgroup_replace_folio(). */
> +		if (new_objcg && obj_cgroup_is_root(new_objcg) &&
> +		    !obj_cgroup_is_root(objcg))
> +			new_objcg = NULL;
> +	}
> +
> +	/* Transfer the charge and, unless it was swapped, the objcg ref */
> +	commit_charge(new, new_objcg ? : objcg);
>  
>  	/* Warning should never happen, so don't worry about refcount non-0 */
>  	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
>  	old->memcg_data = 0;
> +
> +	/* @new took its own reference, drop @old's. */
> +	if (new_objcg)
> +		obj_cgroup_put(objcg);

And here it becomes:

	rcu_read_lock();
	objcg = get_migration_objcg(old, new);
	rcu_read_unlock();
	commit_charge(new, objcg);

	objcg = folio_objcg(old);
	old->memcg_data = 0;
	obj_cgroup_put(objcg);

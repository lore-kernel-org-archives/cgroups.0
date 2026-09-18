Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164E044AB6B
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 20:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789763048; cv=none; b=C+abbOteJkftryrgEts6lAVnQp11S27c4UE365rTUft4CYX7ymbWO9ubWg9vDyHR1M9U8d/M5zS2K5GVmt2/2cRObuCj7he52VJosULylZdsk6bSJvPrqRvqQLNadvaW7F1JndPB+3eHPFakyzJ1gkomecEjzU7XAcHCze8BNZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789763048; c=relaxed/simple;
	bh=eT66H6iANzWDoxgeBfogAllHhpEDQptXi80Z7mxNldQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dx6xQQXw5LZTGFIjhNAAskCfI7IFBgnpqVLstA8nmTz+zVeIOQU8KYy/0C83Kry8DpnZqIni3EfAQNZaKTB8tMPHfMai7r9m7LkDmTI05Q8z57exNcpX0nwx66o68t5i20cX1NSFV7sUEF6Ux1XzL0YLtVYDK5j1sJKCn7nmjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LKxEZyKC; arc=none smtp.client-ip=91.218.175.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LKxEZyKC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eT66H6iANzWDoxgeBfogAllHhpEDQptXi80Z7mxNldQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789763044; v=1; x=1790367844;
 b=LKxEZyKCj+P+NQJ3YggNKSwHcQ4kkGKVl0EHrOOnZow5edCGHpAfIXqAVI0s3Y7zD4OC+qbj
 7zEk7CEe0Rh6cFauNgTgXtdJuf5Lt08oib7ms4cTox6MrFv2X96OwcCuWUF9bab/WPgzcH+fvgY
 +Ts9YSSRsRoiTja/6Zg3GKps=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5e90c63acb495c08;
	Fri, 18 Sep 2026 20:24:03 +0000
X-Mizu-Trace-ID: 5e90c63acb495c08
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 13:24:01 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bingfang Guo <bfguo@icloud.com>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Message-ID: <aq2dkhBuFktQYvTB@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
 <aq1_Qhid7-62pHcW@linux.dev>
 <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>

On Sat, Sep 19, 2026 at 02:46:52AM +0800, Bingfang Guo wrote:
> On Fri, Sep 18, 2026 at 11:14:03AM +0800, Shakeel Butt wrote:
> > On Fri, Sep 18, 2026 at 05:18:42PM +0800, Bingfang Guo via B4 Relay wrote:
> > > From: Bingfang Guo <bingfangguo@tencent.com>
> > > 
> > > This is a preparatory work for moving memcgid from memcg to objcg.
> > > 
> > > Swap entries retain a private ID rather than a memcg pointer. Once
> > > private ID references are moved to objcgs, the ID can also outlive the
> > > memcg to which it was originally assigned.  So it's better to make the
> > > get and put functions accept the ID itself instead of the memcg.
> > > 
> > > Rename mem_cgroup_private_id_get_online() to
> > > mem_cgroup_private_id_get(), and make it return the ID only.  If the
> > > memcg is already dying, the dying memcg will still be used for charging
> > > and stats accounting in v2 swap charging path. But they are hierarchical
> > > and will be reparented after offlining so it doesn't matter.
> > > 
> > > Make mem_cgroup_private_id_put() take the ID and resolve the reference
> > > holder internally. Convert swap uncharge and charge rollback to release
> > > the reference using that ID.  This introduces an extra xarray lookup for
> > > now, which will be removed in the final patch.
> > > 
> > > Separate the online-state reference release into
> > > mem_cgroup_private_id_kill(). The offline path already has the memcg
> > > pointer and can call the underlying put helper directly.
> > > 
> > > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > > ---
> > >  mm/memcontrol-v1.c |  7 +++----
> > >  mm/memcontrol-v1.h |  3 +--
> > >  mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
> > >  3 files changed, 27 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > > index ed015fdd95123..b7f2868885071 100644
> > > --- a/mm/memcontrol-v1.c
> > > +++ b/mm/memcontrol-v1.c
> > > @@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
> > >   */
> > >  void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> > >  {
> > > -	struct mem_cgroup *memcg, *swap_memcg;
> > > +	struct mem_cgroup *memcg;
> > >  	struct obj_cgroup *objcg;
> > >  	unsigned int nr_entries;
> > >  	unsigned short private_id;
> > > @@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> > >  	 * if the ID refers to the root memcg.
> > >  	 */
> > >  	nr_entries = folio_nr_pages(folio);
> > > -	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
> > > -	private_id = mem_cgroup_private_id(swap_memcg);
> > > -	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> > > +	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
> > > +	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
> > >  
> > >  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
> > >  
> > > diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> > > index 23be2512702dc..281425273ea97 100644
> > > --- a/mm/memcontrol-v1.h
> > > +++ b/mm/memcontrol-v1.h
> > > @@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
> > >  	return id == mem_cgroup_private_id(root_mem_cgroup);
> > >  }
> > >  
> > > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> > > -						    unsigned int n);
> > > +unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
> > >  
> > >  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > >  				       struct mem_cgroup *parent, int idx);
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index bfe53e4392f09..ed44b3e7ac938 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> > >  	}
> > >  }
> > >  
> > > -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > > +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > >  {
> > >  	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
> > >  		mem_cgroup_private_id_remove(memcg);
> > > @@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
> > >  	}
> > >  }
> > >  
> > > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> > > +static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > > +{
> > > +	struct mem_cgroup *memcg;
> > > +
> > > +	rcu_read_lock();
> > 
> > Use lockdep_assert_in_rcu_read_lock() here instead of taking rcu as both callers
> > already taking rcu read lock.
> > 
> 
> Thanks for pointing out this.
> 
> Agreed.  Both two callers are already holding the rcu lock so
> taking the lock here is unnecessary. So I will drop the
> rcu_read_lock() and use that in the next version!
> 
> My concern is that: mem_cgroup_private_id_put() looks like a
> universal put function, requiring rcu held (which is true today)
> is not that obvious to the users.  So I think adding a short kdoc
> comment to make it clear later might be a good idea.

This function is internal to memcg code, so whoever is going to call it better
know to call it with rcu held because of lockdep assert. No need to have a
comment.

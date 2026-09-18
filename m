Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593743CE4D
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755254; cv=none; b=Wy51YQOppVCFqu2FzUxl9oX3fAhSqCvXQk5+1IwqFfDDJnea48BpPmNZNfeeFIt3pj/RTnFDSYrJsrZqgicjfaFHfjcvLc3+shoeGPgk99alIOJv0m8Av8wceUJyaKm6XnUzL8LAViUsYKeA57zd08JMsw570l+/PtoQ+G62jTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755254; c=relaxed/simple;
	bh=FqlRlZbpY0aC0R6VarAfbvRXZpO3mHZ5xrmMHvOClk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZvWqD+NssHdS4rGXv+6iYb02w7cPt0iodMg9doSIlFFSaRKLBD1b4qCxepcZYE+aby/9f+EeOamyfSnw//am047EPwVzQeF16xRKp7Efvp+XoR3l+Ji+Vk0RfHPfbVf1XqCJO1X1hr2MTlEwup5WpE3T64JdhvKJ1erJxiFXq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lyPhmtDX; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lyPhmtDX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FqlRlZbpY0aC0R6VarAfbvRXZpO3mHZ5xrmMHvOClk0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789755249; v=1; x=1790360049;
 b=lyPhmtDXHCj/isT64daxeJUXm+dxFtgqafQb8prfx+GRY6jEmgO2xyIF5X2QFgtMzhN6ggAc
 +BbuT5ZosduM3OLC2FfyNvBbPzzELOyIJooEYtChJPz07w886CpBkYRMrwXz7HCujRHmpt+b+6+
 Dze6BDBK6PHvSvvRA6GT00FM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 49d6f23acb7f0677;
	Fri, 18 Sep 2026 18:14:08 +0000
X-Mizu-Trace-ID: 49d6f23acb7f0677
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 11:14:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Bingfang Guo <bfguo@icloud.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Message-ID: <aq1_Qhid7-62pHcW@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>

On Fri, Sep 18, 2026 at 05:18:42PM +0800, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> This is a preparatory work for moving memcgid from memcg to objcg.
> 
> Swap entries retain a private ID rather than a memcg pointer. Once
> private ID references are moved to objcgs, the ID can also outlive the
> memcg to which it was originally assigned.  So it's better to make the
> get and put functions accept the ID itself instead of the memcg.
> 
> Rename mem_cgroup_private_id_get_online() to
> mem_cgroup_private_id_get(), and make it return the ID only.  If the
> memcg is already dying, the dying memcg will still be used for charging
> and stats accounting in v2 swap charging path. But they are hierarchical
> and will be reparented after offlining so it doesn't matter.
> 
> Make mem_cgroup_private_id_put() take the ID and resolve the reference
> holder internally. Convert swap uncharge and charge rollback to release
> the reference using that ID.  This introduces an extra xarray lookup for
> now, which will be removed in the final patch.
> 
> Separate the online-state reference release into
> mem_cgroup_private_id_kill(). The offline path already has the memcg
> pointer and can call the underlying put helper directly.
> 
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>  mm/memcontrol-v1.c |  7 +++----
>  mm/memcontrol-v1.h |  3 +--
>  mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
>  3 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index ed015fdd95123..b7f2868885071 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>   */
>  void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>  {
> -	struct mem_cgroup *memcg, *swap_memcg;
> +	struct mem_cgroup *memcg;
>  	struct obj_cgroup *objcg;
>  	unsigned int nr_entries;
>  	unsigned short private_id;
> @@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>  	 * if the ID refers to the root memcg.
>  	 */
>  	nr_entries = folio_nr_pages(folio);
> -	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
> -	private_id = mem_cgroup_private_id(swap_memcg);
> -	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> +	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
> +	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
>  
>  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
>  
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 23be2512702dc..281425273ea97 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
>  	return id == mem_cgroup_private_id(root_mem_cgroup);
>  }
>  
> -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> -						    unsigned int n);
> +unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
>  
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  				       struct mem_cgroup *parent, int idx);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bfe53e4392f09..ed44b3e7ac938 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
>  {
>  	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
>  		mem_cgroup_private_id_remove(memcg);
> @@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
>  	}
>  }
>  
> -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> +static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();

Use lockdep_assert_in_rcu_read_lock() here instead of taking rcu as both callers
already taking rcu read lock.


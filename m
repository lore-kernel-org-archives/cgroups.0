Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199514A6CE4
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788457929; cv=none; b=MJjuj29RbQKDKPlQVwhLtt/A2kJvKUvAllXx3E0J5JGv4Tdw/db0d46+e8cT3G7XIW/u9IkY16CYNaBKhdgvBQPATHytW0yWk6GrfuhzKju3VKsjNowkrWmknYqbEIhNbTf3sfP1FdRWGPD6cDWEAgT7NrcId/gAdRTuzxTaXJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788457929; c=relaxed/simple;
	bh=nUSFGBKyQqAg2kJryhet0KktU3EGqcgJC/1t2sxjDPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttygl5A2qBjmObwfxUmwk66/469QmhRoh00sLVoHshlEa+MBVKiwJLYbvHs57OuyUuW1eszakqEvmPE26W/hI1WvZ29iKpj5a+lcZe2dTTEnk3KYN+aDz2MQVnKvUmb0W+0cXQ78m5emyZnV5xjUQt8ZhCE4BCjV7jl5DgKraJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JrPiCao8; arc=none smtp.client-ip=91.218.175.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JrPiCao8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nUSFGBKyQqAg2kJryhet0KktU3EGqcgJC/1t2sxjDPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788457924; v=1; x=1789062724;
 b=JrPiCao8yAfZM1HEVWuYw7+bqX9ray300lRKNPA4ODlCk1SclmxNTEpJB/hhTaXwPgy6S5TO
 FA6T2Lji0yC4tAa+X0q7pFZs9aQT4WGE3HERTLEP07j9WdKCWew6zheIOm5OhjX8k65gJNJdC8t
 NghsvqBZEROzZ+LIkfehq0iw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 06323b0187315531;
	Thu, 03 Sep 2026 17:52:04 +0000
X-Mizu-Trace-ID: 06323b0187315531
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:52:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 2/3] mm: memcg: redirect stats updates of dying memcgs
 for all hierarchies
Message-ID: <apmzo9CNCZ-OGfFw@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>

On Mon, Aug 31, 2026 at 05:46:10PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
> its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
> stats keep being accounted to the dying memcg itself.
> 
> The previous patch restored lruvec_page_state_local() in
> count_shadow_nodes(), which reads those state_locals on cgroup v2 too, so
> apply the redirection to all hierarchies.  Offlining is rare, so the added
> cost on the stat update fast path is limited to an rcu_read_lock() and a
> css_is_dying() check; the upward walk happens only while a memcg is dying.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

If we want to backport the first patch to stable trees then we need to backport
this one too.

> ---
>  mm/memcontrol.c | 30 +++++-------------------------
>  1 file changed, 5 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23..b3d1ac3fe0aa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -805,20 +805,14 @@ static long memcg_state_val_in_pages(int idx, long val)
>  	return val < 0 ? -res : res;
>  }
>  
> -#ifdef CONFIG_MEMCG_V1
>  /*
> - * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
> - * reparenting of non-hierarchical state_locals.
> + * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race
> + * with reparenting of non-hierarchical state_locals.  Offlining a
> + * memcg is rare, so do the redirection for all cgroup hierarchies.
>   */
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
> -							   bool *rcu_locked)
> +static inline struct mem_cgroup *
> +get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
>  {
> -	/* Rebinding can cause this value to be changed at runtime */
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> -		*rcu_locked = false;
> -		return memcg;
> -	}
> -
>  	rcu_read_lock();
>  	*rcu_locked = true;
>  
> @@ -830,22 +824,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
>  
>  static inline void get_non_dying_memcg_end(bool rcu_locked)
>  {
> -	if (!rcu_locked)
> -		return;
> -
>  	rcu_read_unlock();
>  }
> -#else
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
> -							   bool *rcu_locked)
> -{
> -	return memcg;
> -}
> -
> -static inline void get_non_dying_memcg_end(bool rcu_locked)
> -{
> -}
> -#endif
>  
>  static void __mod_memcg_state(struct mem_cgroup *memcg,
>  			      enum memcg_stat_item idx, long val)
> -- 
> 2.53.0
> 

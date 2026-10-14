Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89B8565108
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792000538; cv=none; b=WZPyKX0SHA0twcb6wWFiINDbLX1P9Vwos/u2Wl36g+igYZLufXmMHZcNlKnM0FmCYib7YAD2WVIJXuue0KkVldmV8iAvcyqS5ibcWZ6dnvAeEPUrgTu8xzOcPzLRwrRcgguYOgLWdLHX5a2rjN3QWj2LYrY3YUffo4cdxBN3WHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792000538; c=relaxed/simple;
	bh=eaVf8DiKWy+Ej0oOi27k8+cbzyMwGdVNwHvpr7Pf3+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AnB6RxH5KLaHw5k2G/czTK9ZkfWxpTTty0KGoiXHZKxVxXZiy521GAT/BdnNnOQEwgnZWhMOqy7puJ9MA2MU6o3W0hRsvGcI53nHMM51UXKx5cR2yeT3AW/kDmWqfvUhxw9BlfZE+pFBstg7JnCvj7NgLfSkyFSui76OlLauSns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AKkjKY88; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AKkjKY88"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eaVf8DiKWy+Ej0oOi27k8+cbzyMwGdVNwHvpr7Pf3+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792000533; v=1; x=1792605333;
 b=AKkjKY88BP8jUI9Gc3I6okeGZb/a7o378A/ApJqOdDcQwYE1gt3N6LVXPayoYOin3sCXrvgc
 yHk/PJxd0LmP6YamEGIRT4XbBOPd+FXgX0uuXN6rsL33qy8pDar8nkRL0+4eb9eUWQrqEKX2qzb
 ElHPuSg8MiFF4EZ6mo3As3wI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 071c26393a68de4d;
	Wed, 14 Oct 2026 17:55:23 +0000
X-Mizu-Trace-ID: 071c26393a68de4d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 10:55:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as_AxtUlV8K2fkNu@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
 <as-08j9_1C2F_N8s@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-08j9_1C2F_N8s@tiehlicka>

On Wed, Oct 14, 2026 at 06:59:30PM +0200, Michal Hocko wrote:
> On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> > On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > > Kernel threads and remote chargers use high_work when memory.high is
> > > > exceeded. Their allocations during reclaim can also charge memory,
> > > > for example when zswap stores a page.
> > > > 
> > > > Without a check, the high_work worker can queue itself from its own
> > > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > > can queue another run.
> > > 
> > > What does that mean really? Does this delays the actual run?
> > 
> > It will not delay the actual charge request. This mainly means that we keep
> > enqueing the high reclaim work even from high reclaim context and can
> > potentially keep wasting CPU if high reclaim is not very successful.
> 
> Hmm, so is there any practical problem if we do that? What exactly do you
> mean by "keep wasting CPU"?

More specifically if high_work kworker keeps enqueing high_work, most probably
the memcg does not have reclaimable memory and keep retrying it wastes CPU.

>  
> > > > Skip memory.high enforcement for charges from task context with
> > > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > > threads and remote charges. The memory is still charged. Interrupt
> > > > charges keep their current path.
> > > > 
> > > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > > without this check.
> > > > 
> > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > 
> > > The patch itself looks OK. I am wondering whether we can unify the check
> > > with the existing one which forces the allocation through in main
> > > charging path.
> > 
> > The force charge (and ENOMEM) paths bypass the memory.high enforcement
> > altogether.
> 
> Exactly. Isn't that exactl what we want to achieve here as well?
> 
> > Only successful charges (done_restock label) goes through
> > memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> > will still be a separate check before calling high enforcement function. I think
> > this check is very high_work specific and better to be in the high enforcement
> > function.
> 
> I meant something like the following

Oh ok this makes sense. Do you want to send a patch or should I add this in this
series replacing the 4th patch?

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586c..832b40ee5b6f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,7 +2653,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool passed_oom = false;
>  	unsigned int reclaim_options;
>  	bool drained = false;
> -	bool raised_max_event = false;
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
> @@ -2661,6 +2660,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
>  
> +	/*
> +	 * Prevent unbounded recursion when reclaim operations need to
> +	 * allocate memory. This might exceed the limits temporarily,
> +	 * but we prefer facilitating memory reclaim and getting back
> +	 * under the limit over triggering OOM kills in these cases.
> +	 */
> +	if (unlikely(current->flags & PF_MEMALLOC))
> +		goto force;
> +
>  	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
>  		batch = nr_pages;
> @@ -2683,15 +2691,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> -	/*
> -	 * Prevent unbounded recursion when reclaim operations need to
> -	 * allocate memory. This might exceed the limits temporarily,
> -	 * but we prefer facilitating memory reclaim and getting back
> -	 * under the limit over triggering OOM kills in these cases.
> -	 */
> -	if (unlikely(current->flags & PF_MEMALLOC))
> -		goto force;
> -
>  	if (unlikely(task_in_memcg_oom(current)))
>  		goto nomem;
>  
> @@ -2712,7 +2711,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto nomem;
>  
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> @@ -2773,13 +2771,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>  		return -ENOMEM;
>  force:
> -	/*
> -	 * If the allocation has to be enforced, don't forget to raise
> -	 * a MEMCG_MAX event.
> -	 */
> -	if (!raised_max_event)
> -		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
>  	 * being freed very soon.  Allow memory usage go over the limit
> @@ -2789,6 +2780,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (do_memsw_account())
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  
> +	if (mem_cgroup_margin(memcg))
> +		__memcg_memory_event(memcg, MEMCG_MAX, allow_spinning);
>  	return 0;
>  
>  done_restock:
> 
> -- 
> Michal Hocko
> SUSE Labs

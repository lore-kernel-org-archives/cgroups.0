Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2C1FB1
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787849886; cv=none; b=rMTyllFJT/8OHG1j8e52lCyHTBoYWYAC3Z8fm2WNzU2lPX1lVSTOp8PVM7TcUH+ekoCxUVQJQGtSFbQl3SBQB0zLnJd3G6uWONb64sFVmtwlxDUc4g5Eq5D/mniva0S+hXzX5Njjw4cvLOm1/4OwjRhkitRg+WURXQ+VNQdPjcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787849886; c=relaxed/simple;
	bh=/QFykKqY4DddYYy1JGcan4kcCBGwtGcv3+RRD0IyIGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDwcIzo44qz2kPiOlTLOUzBMhj1Bq1UTD07DKkM+rm18/nG/cj/FYvA0ot/EXxoMoqrWeBQa3eGv/8gK6ZSItL9svq2n9JohqvG0hIQFOIdqAoG1GkHgVZVt8mfQDJu/BcM1Y/+uRqbvj9TNKqY7rbchoEbfb7tFHcvP+1pg3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ivqhg7pH; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ivqhg7pH"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/QFykKqY4DddYYy1JGcan4kcCBGwtGcv3+RRD0IyIGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787849879; v=1; x=1788454679;
 b=Ivqhg7pHLNsyndpaARYlFqDnmbpn1BaiBSqdHDcYc9yhz/pIdu9VmkV5j55SLDNmXNtPJZaE
 0Cl/Y9gc7tdKLsmud+OSnZkVge2QVvg3J0MR5gK6zz1fqKDFmtUFJimwlAa2EPUAXtYxmz3vToK
 vR7Mlb767U8AJY2CwUqm/o74=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1ee3e873e45b78e8;
	Thu, 27 Aug 2026 16:57:59 +0000
X-Mizu-Trace-ID: 1ee3e873e45b78e8
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 09:57:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <apBsMXzLXltN9MTd@linux.dev>
References: <20260827124211.3b94b103@fangorn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>

On Thu, Aug 27, 2026 at 12:42:11PM -0400, Rik van Riel wrote:
> drain_all_stock() queues drain work on remote CPUs via
> schedule_drain_work() -> queue_work_on(memcg_wq) and returns
> immediately without waiting. The worker, drain_local_memcg_stock()
> / drain_local_obj_stock(), dereferences per-CPU stock caches with
> READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().
> 
> mem_cgroup_css_offline() calls drain_all_stock(memcg) to
> optimize reclamation latency, but never flushes memcg_wq. If
> that races with cgroup removal, free can happen while workers
> are still pending, causing UAF. The drain work could also have
> been queued by somebody else before offline started (e.g. high
> throttling), not just by the offline path itself.
> 
> Timeline illustrating the race:
> 
>   CPU0 (rmdir + offline)                CPU1 (charge cache holder)
>   -------------------------             ----------------------------
>   cgroup_rmdir()
>     cgroup_destroy_locked()
>       kill_css_sync()
>       ...
> 
>                                       refill_stock(victim)
>                                         css_get(victim)
>                                         WRITE_ONCE(cached[i]=victim)
> 
>   percpu_ref kill confirmed, css_killed_ref_fn() called
> 
>   css_killed_work_fn() [offline_wq]
>     mem_cgroup_css_offline(victim)
>       drain_all_stock(victim)
>         is_memcg_drain_needed()
>           READ_ONCE(cached) -> victim
>         queue_work_on(CPU1, memcg_wq, work)
>         // no flush!
>       mem_cgroup_private_id_put()
>     css_put() -> refcnt may hit 0

Why would refcnt hit 0? CPU1 stock has a reference.

> 
>   [RCU GP]
>   css_free_rwork_fn()
>     mem_cgroup_free(victim)
>     // victim struct freed
> 
>                                         // worker delayed by scheduler/
>                                         // WQ concurrency
>                                         drain_local_memcg_stock()
>                                           old = READ_ONCE(cached[i])
>                                           // UAF: old == freed victim
>                                           memcg_uncharge(old)
>                                           css_put(&old->css)
> 
> Fix by having the offline path wait for the workqueue to be
> done with the memcg, before freeing the memcg.
> 
> Found through a code audit with kres.
> 
> Fixes: 591edfb10a94 ("mm: drain memcg stocks on css offlining")
> Cc: stable@vger.kernel.org
> Assisted-by: Hermes:muse-spark-1.2 kres
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/memcontrol.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..c95a1f6ec799 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2273,12 +2273,18 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>   * Drains all per-CPU charge caches for given root_memcg resp. subtree
>   * of the hierarchy under it.
>   */
> -void drain_all_stock(struct mem_cgroup *root_memcg)
> +static void __drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
>  {
>  	int cpu, curcpu;
>  
> -	/* If someone's already draining, avoid adding running more workers. */
> -	if (!mutex_trylock(&percpu_charge_mutex))
> +	/*
> +	 *  If someone's already draining, avoid starting more workers.
> +	 *  Synchronous callers need to guarantee all the last things
> +	 *  are flushed, e.g. before a memcg is removed.
> +	 */
> +	if (sync)
> +		mutex_lock(&percpu_charge_mutex);
> +	else if (!mutex_trylock(&percpu_charge_mutex))
>  		return;
>  	/*
>  	 * Notify other cpus that system-wide "drain" is running
> @@ -2316,6 +2322,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  	mutex_unlock(&percpu_charge_mutex);
>  }
>  
> +void drain_all_stock(struct mem_cgroup *root_memcg)
> +{
> +	__drain_all_stock(root_memcg, false);
> +}
> +
> +void drain_all_stock_sync(struct mem_cgroup *root_memcg)
> +{
> +	/*
> +	 * Make sure the workqueue is done with this memcg
> +	 * before freeing it.
> +	 */
> +	__drain_all_stock(root_memcg, true);
> +	flush_workqueue(memcg_wq);
> +}
> +
>  static int memcg_hotplug_cpu_dead(unsigned int cpu)
>  {
>  	/* no need for the local lock */
> @@ -4305,7 +4326,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	wb_memcg_offline(memcg);
>  	lru_gen_offline_memcg(memcg);
>  
> -	drain_all_stock(memcg);
> +	drain_all_stock_sync(memcg);
>  
>  	mem_cgroup_private_id_put(memcg, 1);
>  }
> -- 
> 2.55.0
> 
> 

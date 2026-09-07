Received: from mta1.migadu.com (out-158.mta1.migadu.com [95.215.58.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DA026AF4
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 22:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788819960; cv=none; b=n6WIhJoFQ5che1vG7JtsN+Va5nAQVxEOs+c9sWXRxhKY4z0BsEYYulNTwveYdWsDoeeFOV7YQNlKjxUpV5A5uqA5cuDh2AxlnfeKedMisFRZzO9vW8btE4D5eOuVlHL3cE8E0TbPwET+yxF0jDFeuPIHCYe7AC5nccZtbd8k91E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788819960; c=relaxed/simple;
	bh=n3D7ZA7tkZ34E7YU+SP+fSBY+j1Hn81BCAIxM2KVTtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xwh1zzShPA3IuYmdlj/mcYQY3XADB3GAQzATHvX4BLVbIkJ1lJjUCKDt4+/sLei8DZWEc+7iiWUbhbOUNLoEcbeoiocO7CQGy7znShVWcULIEocmoCW2K6KNl35+peErQtZd6gnTbUMCGJ3vGB/6MLZIwJqLf3WjrWJrH3IXN90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MYP1q22d; arc=none smtp.client-ip=95.215.58.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MYP1q22d"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=n3D7ZA7tkZ34E7YU+SP+fSBY+j1Hn81BCAIxM2KVTtg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788819956; v=1; x=1789424756;
 b=MYP1q22dmHvz+W/L6GoPt2UYY3uk3Z5efRWfjBV2BWIMepSl6mB9LNM3IxuQVoGpJboUDV15
 n1OqkAh0JIhIdC2y5PalXWGfsymrRCQO2HN9eTCLrTBk/w9HjtGPJa+ziSyxsrwgtAljipzMKUt
 WWDhD8YVg2ftI8BBqQwhX1Y4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ed8fd13ac114cfd0;
	Mon, 07 Sep 2026 22:25:45 +0000
X-Mizu-Trace-ID: ed8fd13ac114cfd0
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 15:25:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 3/7] mm/page_counter: introduce per-page_counter stock
Message-ID: <ap845AEpX0ceqCjr@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-4-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-4-joshua.hahnjy@gmail.com>

On Mon, Aug 31, 2026 at 09:37:47AM -0700, Joshua Hahn wrote:
> In order to avoid expensive hierarchy walks on every memcg charge and
> limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
> pre-charged pages and introduce a fast path to try_charge_memcg.
> 
> However, there are a few quirks with the current implementation that
> can be improved upon.
> 
> First, each memcg_stock_pcp can only cache the charges of 7 memcgs
> (NR_MEMCG_STOCK). When an 8th memcg wants to cache its charge on a CPU,
> a victim memcg is chosen among the 7 cached memcgs and is evicted,
> losing all cached charges.
> 
> Second, stock draining is per-CPU rather than per-memcg. That is,
> when a memcg is under pressure and must retrieve all cached charges,
> it iterates through every CPU and drains the stock charges of all
> present memcgs. This means that one under-pressure memcg evicts the
> caches of all co-cpu-resident memcg stock caches.
> 
> Finally, stock is tightly coupled with memcg, so adding new
> page_counters to memcg is an unscalable operation where only one counter
> gets to use the fastpath.
> 
> We can address all of these concerns by pushing stock caches down to the
> page_counter level, and making each counter responsible for its own
> charge.
> 
> Introduce struct page_counter_stock along with its allocation, free, and
> per-CPU drain helpers.
> 
> No functional change intended.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/page_counter.h | 16 +++++++
>  mm/page_counter.c            | 90 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 89a083f16fbf7..c1fe331f34e7e 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -5,8 +5,11 @@
>  #include <linux/atomic.h>
>  #include <linux/cache.h>
>  #include <linux/limits.h>
> +#include <linux/workqueue_types.h>
>  #include <asm/page.h>
>  
> +struct page_counter_stock;
> +
>  struct page_counter {
>  	/*
>  	 * Make sure 'usage' does not share cacheline with any other field in
> @@ -41,6 +44,13 @@ struct page_counter {
>  	unsigned long high;
>  	unsigned long max;
>  	struct page_counter *parent;
> +	struct page_counter_stock __percpu *stock;
> +	unsigned long batch;
> +
> +	/* make sure the work_struct is separate from the read most fields */
> +	CACHELINE_PADDING(_pad3_);
> +
> +	struct work_struct drain_work;

Introduce this field where you are going to use it.

>  } ____cacheline_internodealigned_in_smp;
>  
>  #if BITS_PER_LONG == 32
> @@ -61,6 +71,8 @@ static inline void page_counter_init(struct page_counter *counter,
>  	counter->parent = parent;
>  	counter->protection_support = protection_support;
>  	counter->track_failcnt = false;
> +	counter->stock = NULL;
> +	counter->batch = 0;
>  }
>  
>  static inline unsigned long page_counter_read(struct page_counter *counter)
> @@ -99,6 +111,10 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
>  	counter->watermark = usage;
>  }
>  
> +void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu);
> +void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch);
> +void page_counter_free_stock(struct page_counter *counter);
> +
>  #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
>  void page_counter_calculate_protection(struct page_counter *root,
>  				       struct page_counter *counter,
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index a934619cc7bf7..3f61eba695518 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -8,11 +8,18 @@
>  #include <linux/page_counter.h>
>  #include <linux/atomic.h>
>  #include <linux/kernel.h>
> +#include <linux/percpu.h>
>  #include <linux/string.h>
>  #include <linux/sched.h>
> +#include <linux/spinlock.h>
>  #include <linux/bug.h>
>  #include <asm/page.h>
>  
> +struct page_counter_stock {
> +	raw_spinlock_t lock;

Please explain why you need raw_spinlock_t?

> +	unsigned long nr_pages;
> +};
> +
>  static bool track_protection(struct page_counter *c)
>  {
>  	return c->protection_support;
> @@ -295,6 +302,89 @@ int page_counter_memparse(const char *buf, const char *max,
>  	return 0;
>  }
>  
> +/**
> + * page_counter_drain_cpu_stock - release @cpu's cached charges
> + * @counter: counter whose stock to drain
> + * @cpu: CPU whose stock is drained
> + */
> +void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
> +{
> +	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
> +	struct page_counter_stock *pcp_stock;
> +	unsigned long nr_pages;
> +	unsigned long flags;
> +
> +	if (!stock)
> +		return;
> +
> +	pcp_stock = per_cpu_ptr(stock, cpu);
> +	raw_spin_lock_irqsave(&pcp_stock->lock, flags);
> +	nr_pages = pcp_stock->nr_pages;
> +	pcp_stock->nr_pages = 0;
> +	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
> +
> +	if (nr_pages)
> +		page_counter_uncharge(counter, nr_pages);
> +}
> +
> +/**
> + * page_counter_alloc_stock - allocate the percpu stock for a page_counter
> + * @counter: counter to allocate percpu stock for
> + * @batch: maximum number of pages a CPU may cache
> + *
> + * Failure to allocate is not fatal; @counter falls back to hierarchy charges.
> + * The caller must not (un)charge @counter concurrently with this call, and this
> + * must not be called twice on the same counter. A concurrent drain is fine
> + * since the stock is published with a release store the drain paths pair with.
> + *
> + * Context: Process context. May sleep, the percpu alloc uses GFP_KERNEL.
> + */
> +void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
> +{
> +	struct page_counter_stock __percpu *stock;
> +	int cpu;
> +
> +	if (WARN_ON_ONCE(counter->stock))
> +		return;
> +
> +	stock = alloc_percpu_gfp(struct page_counter_stock, GFP_KERNEL_ACCOUNT);

Let's add gfp param to the function and use that here. Also if you want to use
__GFP_ACCOUNT then you should use set_active_memcg() at the caller, so you don't
charge the one creating the memcg but the parent similar to what
mem_cgroup_css_alloc() does.


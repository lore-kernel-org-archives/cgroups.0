From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Mon, 14 Feb 2022 11:23:11 -0500
Message-ID: <YgqB77SaViGRAtgt@cmpxchg.org>
References: <20220211223537.2175879-1-bigeasy@linutronix.de>
 <20220211223537.2175879-5-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0I6QCfcZvTXg/UIVMtXAqnAJEFMpz4YPEOXp860qAcQ=;
        b=ZbOs/VFsA0tNTT51uy23Gy4Eibq2IbTAzBHaLm6ub5lmEKlZFXUqvU9JTDKzk3L9n1
         SlkGGq23eWcOqQ7MnmhcwrgKHTmAT43k7rB0+fYs5wpr3tOjyh4rdLr27J02Z6h1UZTP
         EECDCgTpw1IXTfBNYqppgkzaJlPWtSit/JTfYIBX8GKN+tkXTSTKWm3UDU0nY7C2mt5I
         kKUbWxdIkn+2V+bt0cMnt9AcqmXYeihyeliG8h1ktTcbuswQpfMy4LLsnIjngQUaUVsZ
         xeSIHig17I34sKfSPZOGQjcoBJubENZb4SVPQHcuCT7PeouC82fdMHwPnvaRAteeHG2L
         ykXg==
Content-Disposition: inline
In-Reply-To: <20220211223537.2175879-5-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Sebastian,

On Fri, Feb 11, 2022 at 11:35:37PM +0100, Sebastian Andrzej Siewior wrote:
> +static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
>  {
>  	struct obj_cgroup *old = stock->cached_objcg;
>  
>  	if (!old)
> -		return;
> +		return NULL;
>  
>  	if (stock->nr_bytes) {
>  		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
>  		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
>  
>  		if (nr_pages)
> -			obj_cgroup_uncharge_pages(old, nr_pages);
> +			obj_cgroup_uncharge_pages_locked(old, nr_pages);

This is a bit dubious in terms of layering. It's an objcg operation,
but what's "locked" isn't the objcg, it's the underlying stock. That
function then looks it up again, even though we have it right there.

You can open-code it and factor out the stock operation instead, and
it makes things much simpler and clearer.

I.e. something like this (untested!):

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1b3550f09335..eed6e0ff84d7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2215,6 +2215,20 @@ static void drain_local_stock(struct work_struct *dummy)
 	local_irq_restore(flags);
 }
 
+static void __refill_stock(struct memcg_stock_pcp *stock,
+			   struct mem_cgroup *memcg,
+			   unsigned int nr_pages)
+{
+	if (stock->cached != memcg) {
+		drain_stock(stock);
+		css_get(&memcg->css);
+		stock->cached = memcg;
+	}
+	stock->nr_pages += nr_pages;
+	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
+		drain_stock(stock);
+}
+
 /*
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
@@ -2225,18 +2239,8 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	unsigned long flags;
 
 	local_irq_save(flags);
-
 	stock = this_cpu_ptr(&memcg_stock);
-	if (stock->cached != memcg) { /* reset if necessary */
-		drain_stock(stock);
-		css_get(&memcg->css);
-		stock->cached = memcg;
-	}
-	stock->nr_pages += nr_pages;
-
-	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
-		drain_stock(stock);
-
+	__refill_stock(stock, memcg, nr_pages);
 	local_irq_restore(flags);
 }
 
@@ -3213,8 +3217,15 @@ static void drain_obj_stock(struct obj_stock *stock)
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
-		if (nr_pages)
-			obj_cgroup_uncharge_pages(old, nr_pages);
+		/* Flush complete pages back to the page stock */
+		if (nr_pages) {
+			struct mem_cgroup *memcg;
+
+			memcg = get_mem_cgroup_from_objcg(objcg);
+			mem_cgroup_kmem_record(memcg, -nr_pages);
+			__refill_stock(stock, memcg, nr_pages);
+			css_put(&memcg->css);
+		}
 
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.

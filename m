From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/5] mm/memcontrol: Change stock_lock type from local_lock_t to spinlock_t
Date: Wed, 25 Jan 2023 04:34:59 -0300
Message-ID: <20230125073502.743446-3-leobras@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+Ul5sQzoaw3CKL+Rr3WW09PeQYvbUe0nkd8DHiRlc0=;
        b=dekaFMgEkNAX/BhHGbGph44K2HgSP8qDPl9IQHon3PZ4NJ0NNk9XlhxpUcfftryKp2Ej7Q
        DqZ/j7/wVZG7yOIuOIKWuryuA7cQvNR9GtQxtwMptvBE3KXLN4z/Vvbi8tXouihaYgcMLN
        +knAf4QuTh5iE7oq7bsUPxxEC1u0eck=
In-Reply-To: <20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In this context, since it's using per-cpu variables, changing from
local_lock to spinlock should not deal much impact in performance and can
allow operations such as stock draining to happen in remote cpus.

Why performance would probably not get impacted:
1 - Since the lock is in the same cache line as the information that is
    written next, there is no much extra memory access cost for using the
    lock.
2 - Since it's a percpu struct, there should be rare for other cpu to share
    this cacheline, so there should be rare to need cacheline invalidation,
    and writing  to the lock should be cheap since there is always a
    write to next struct members.
3 - Even the write in (2) could be pipelined and batched with following
    writes to the cacheline (such as nr_pages member), further decreasing
    the impact of this change.

Suggested-by: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f8e86b88b3c7a..1d5c108413c83 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2172,7 +2172,7 @@ void unlock_page_memcg(struct page *page)
 }
 
 struct memcg_stock_pcp {
-	local_lock_t stock_lock;
+	spinlock_t stock_lock; /* Protects the percpu struct */
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 
@@ -2190,7 +2190,7 @@ struct memcg_stock_pcp {
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.stock_lock = INIT_LOCAL_LOCK(stock_lock),
+	.stock_lock = __SPIN_LOCK_UNLOCKED(stock_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
 
@@ -2235,15 +2235,15 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	if (nr_pages > MEMCG_CHARGE_BATCH)
 		return ret;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-
 	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
+
 	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
 		stock->nr_pages -= nr_pages;
 		ret = true;
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 
 	return ret;
 }
@@ -2280,14 +2280,14 @@ static void drain_local_stock(struct work_struct *dummy)
 	 * drain_stock races is that we always operate on local CPU stock
 	 * here with IRQ disabled
 	 */
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-
 	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
+
 	old = drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 	if (old)
 		obj_cgroup_put(old);
 }
@@ -2315,10 +2315,12 @@ static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	unsigned long flags;
+	struct memcg_stock_pcp *stock;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
 	__refill_stock(memcg, nr_pages);
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 }
 
 /*
@@ -3165,8 +3167,8 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	unsigned long flags;
 	int *bytes;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
 
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
@@ -3218,7 +3220,7 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 	if (old)
 		obj_cgroup_put(old);
 }
@@ -3229,15 +3231,15 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 	unsigned long flags;
 	bool ret = false;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-
 	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
+
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 
 	return ret;
 }
@@ -3327,9 +3329,9 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 	unsigned long flags;
 	unsigned int nr_pages = 0;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-
 	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
+
 	if (stock->cached_objcg != objcg) { /* reset if necessary */
 		old = drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3345,7 +3347,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 	if (old)
 		obj_cgroup_put(old);
 
-- 
2.39.1


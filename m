From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/3] mm/memcontrol: Change stock_lock type from local_lock_t to spinlock_t
Date: Tue,  1 Nov 2022 23:02:42 -0300
Message-ID: <20221102020243.522358-3-leobras@redhat.com>
References: <20221102020243.522358-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667354631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9awyJRy6zbIYnxU2Cyp8GDi5vivjY8I9wO3N/Lj5YCI=;
        b=FRgrnSxEw6MrXo8g7bVS2LwGLrnJ/DyTJ6aDxu52eO3jWNDdp75fa+yu8ZL3P+m1w9CZpy
        dbE8JoyWEcsN+OeM6DQjn6rAMJT7f9obDeka0Zm4eHx4UzWMSXwXq7uMJeI14JgVSBhrXZ
        OUGRv4w3Ih4I9vbH7D0ob5E4t7BHnuY=
In-Reply-To: <20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mt>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

In this context, since it's using per-cpu variables, changing from
local_lock to spinlock should not deal much impact in performance and can
allow operations such as stock draining to happen in remote cpus.

Why performance would probably not get impacted:
1 - Since the lock is in the same cache line as the information that is
    used next, there is no extra memory access for caching the lock.
2 - Since it's a percpu struct, there should be no other cpu sharing this
    cacheline, so there is no need for cacheline invalidation, and writing
    to the lock should be as fast as the next struct members.
3 - Even the write in (2) could be pipelined and batched with following
    writes to the cacheline (such as nr_pages member), further decreasing
    the impact of this change.

Suggested-by: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d8549ae1b300..add46da2e6df1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2167,7 +2167,7 @@ void unlock_page_memcg(struct page *page)
 }
 
 struct memcg_stock_pcp {
-	local_lock_t stock_lock;
+	spinlock_t stock_lock; /* Protects the percpu struct */
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 
@@ -2184,7 +2184,7 @@ struct memcg_stock_pcp {
 #define FLUSHING_CACHED_CHARGE	0
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
-	.stock_lock = INIT_LOCAL_LOCK(stock_lock),
+	.stock_lock = __SPIN_LOCK_UNLOCKED(stock_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
 
@@ -2229,15 +2229,15 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -2274,14 +2274,14 @@ static void drain_local_stock(struct work_struct *dummy)
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
@@ -2309,10 +2309,12 @@ static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -3157,8 +3159,8 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	unsigned long flags;
 	int *bytes;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	stock = this_cpu_ptr(&memcg_stock);
+	spin_lock_irqsave(&stock->stock_lock, flags);
 
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
@@ -3210,7 +3212,7 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 	if (old)
 		obj_cgroup_put(old);
 }
@@ -3221,15 +3223,15 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
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
@@ -3319,9 +3321,9 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
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
@@ -3337,7 +3339,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	spin_unlock_irqrestore(&stock->stock_lock, flags);
 	if (old)
 		obj_cgroup_put(old);
 
-- 
2.38.1


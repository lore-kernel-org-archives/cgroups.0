From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Wed, 9 Feb 2022 10:17:05 +0100
Message-ID: <YgOGkXXCrD/1k+p4@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de>
 <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
 <Yfkjjamj09lZn4sA@linutronix.de>
 <YflR3/RuGjYuQZPH@dhcp22.suse.cz>
 <YfumP3u1VCjKHE3b@linutronix.de>
 <Yfup9THPcSIPDSoH@dhcp22.suse.cz>
 <CALvZod7yovQ5OTWr=k_eiEBVb1LTRvPkbsY8joAtyigQnvBUww@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644398227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pmon6FgrGvsAhmcg43waurTBmH1BrAJhbpfYSbOQXkE=;
        b=tyw8D6SPRZihbPwDpVtgQ693G6c6qOVo4pOYLDre+zk8SW6Ug3do5PCIHlhFBmz3TquKmN
        C4JSHmAymp82FDrhlR9KSQjWofOvl7m7CQAgH7xTewSRh/vVEuQWjBR1jlCr/HhgB+/cb/
        x2VYEHY52/eEnlkVAPMrmAAdnZLoHOE=
Content-Disposition: inline
In-Reply-To: <CALvZod7yovQ5OTWr=k_eiEBVb1LTRvPkbsY8joAtyigQnvBUww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 08-02-22 09:58:27, Shakeel Butt wrote:
[...]
> commit 559271146efc0 is a part of patch series "mm/memcg: Reduce
> kmemcache memory accounting overhead". For perf numbers you can see
> the cover letter in the commit fdbcb2a6d677 ("mm/memcg: move
> mod_objcg_state() to memcontrol.c").

Thanks for the pointer! This helped because I couldn't follow the
original series[1].

I definitely do not want to dispute the whole series. It is this
particular patch which makes further changes much more complex AFAICS
and the cost/benefit should be re-evaluated IMHO. Microbenchmarks are a
nice indecation but in this case we should be more re-evaluate. The
complexity has increased even more for RT requirements.

[1] It would be great if those patch specific benchmarks were in the
    specific patch next time. This would make it much more easier to track.

Just as an exercise I have tried to revert 559271146efc0. It needs some
tweaking (on top of Linus tree) and I hope I got everything right.
Sebastian does this help for the RT case?
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 09d342c7cbd0..4b1572ae990d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2085,23 +2085,17 @@ void unlock_page_memcg(struct page *page)
 	folio_memcg_unlock(page_folio(page));
 }
 
-struct obj_stock {
+struct memcg_stock_pcp {
+	struct mem_cgroup *cached; /* this never be root cgroup */
+	unsigned int nr_pages;
+
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
 	unsigned int nr_bytes;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
-#else
-	int dummy[0];
 #endif
-};
-
-struct memcg_stock_pcp {
-	struct mem_cgroup *cached; /* this never be root cgroup */
-	unsigned int nr_pages;
-	struct obj_stock task_obj;
-	struct obj_stock irq_obj;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -2111,12 +2105,12 @@ static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
 static DEFINE_MUTEX(percpu_charge_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
-static void drain_obj_stock(struct obj_stock *stock);
+static void drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
 #else
-static inline void drain_obj_stock(struct obj_stock *stock)
+static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 }
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -2193,9 +2187,7 @@ static void drain_local_stock(struct work_struct *dummy)
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(&stock->irq_obj);
-	if (in_task())
-		drain_obj_stock(&stock->task_obj);
+	drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -2770,41 +2762,6 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
  */
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
 
-/*
- * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
- * sequence used in this case to access content from object stock is slow.
- * To optimize for user context access, there are now two object stocks for
- * task context and interrupt context access respectively.
- *
- * The task context object stock can be accessed by disabling preemption only
- * which is cheap in non-preempt kernel. The interrupt context object stock
- * can only be accessed after disabling interrupt. User context code can
- * access interrupt object stock, but not vice versa.
- */
-static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
-{
-	struct memcg_stock_pcp *stock;
-
-	if (likely(in_task())) {
-		*pflags = 0UL;
-		preempt_disable();
-		stock = this_cpu_ptr(&memcg_stock);
-		return &stock->task_obj;
-	}
-
-	local_irq_save(*pflags);
-	stock = this_cpu_ptr(&memcg_stock);
-	return &stock->irq_obj;
-}
-
-static inline void put_obj_stock(unsigned long flags)
-{
-	if (likely(in_task()))
-		preempt_enable();
-	else
-		local_irq_restore(flags);
-}
-
 /*
  * mod_objcg_mlstate() may be called with irq enabled, so
  * mod_memcg_lruvec_state() should be used.
@@ -3075,10 +3032,13 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
+	struct memcg_stock_pcp *stock;
 	unsigned long flags;
-	struct obj_stock *stock = get_obj_stock(&flags);
 	int *bytes;
 
+	local_irq_save(flags);
+	stock = this_cpu_ptr(&memcg_stock);
+
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat or idx
@@ -3129,26 +3089,29 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	put_obj_stock(flags);
+	local_irq_restore(flags);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
+	struct memcg_stock_pcp *stock;
 	unsigned long flags;
-	struct obj_stock *stock = get_obj_stock(&flags);
 	bool ret = false;
 
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
 	}
 
-	put_obj_stock(flags);
+	local_irq_restore(flags);
 
 	return ret;
 }
 
-static void drain_obj_stock(struct obj_stock *stock)
+static void drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 	struct obj_cgroup *old = stock->cached_objcg;
 
@@ -3204,13 +3167,8 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 {
 	struct mem_cgroup *memcg;
 
-	if (in_task() && stock->task_obj.cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
-		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
-			return true;
-	}
-	if (stock->irq_obj.cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->irq_obj.cached_objcg);
+	if (stock->cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
 	}
@@ -3221,10 +3179,13 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 			     bool allow_uncharge)
 {
+	struct memcg_stock_pcp *stock;
 	unsigned long flags;
-	struct obj_stock *stock = get_obj_stock(&flags);
 	unsigned int nr_pages = 0;
 
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached_objcg != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3240,7 +3201,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	put_obj_stock(flags);
+	local_irq_restore(flags);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
@@ -6821,7 +6782,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 	long nr_pages;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
-	bool use_objcg = folio_memcg_kmem(folio);
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
@@ -6830,7 +6790,7 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 	 * folio memcg or objcg at this point, we have fully
 	 * exclusive access to the folio.
 	 */
-	if (use_objcg) {
+	if (folio_memcg_kmem(folio)) {
 		objcg = __folio_objcg(folio);
 		/*
 		 * This get matches the put at the end of the function and
@@ -6858,7 +6818,7 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 
 	nr_pages = folio_nr_pages(folio);
 
-	if (use_objcg) {
+	if (folio_memcg_kmem(folio)) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
 
-- 
Michal Hocko
SUSE Labs

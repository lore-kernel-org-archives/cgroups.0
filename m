From: Leonardo Bras <leobras@redhat.com>
Subject: [PATCH v2 4/5] mm/memcontrol: Perform all stock drain in current CPU
Date: Wed, 25 Jan 2023 04:35:01 -0300
Message-ID: <20230125073502.743446-5-leobras@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cta4F9u/56j6UuYJx1HDD/ltBRbZgzhdAn9u+4PdIyQ=;
        b=PX8YfOcUQ9+4SqkymxPco8kbg9Q5hvtS/sv54cDrH/YEloZa3Wf9aLDfRKHh0LQ5t0htcf
        TML3pLGjtZkvua6rFoZUytr6W3EmSl3Yh9U+W+5dfAC8IgkQZBAdYZljKi3Hru0WQkwK61
        JCQwKwmbUNomzoIEoLRW+syeqiDDZ98=
In-Reply-To: <20230125073502.743446-1-leobras@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras@redhat.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

When drain_all_stock() is called, some CPUs will be required to have their
per-CPU caches drained. This currently happens by scheduling a call to
drain_local_stock() to run in each affected CPU.

This, as a consequence, may end up scheduling work to CPUs that are
isolated, and therefore should have as little interruption as possible.

In order to avoid this, run all CPUs stock drain directly from the
current CPU. This should be fine as long as drain_all_stock() runs fast
enough so it don't often cause contention on consume_stock(),
refill_stock(), mod_objcg_state(), consume_obj_stock() or 
refill_obj_stock(). 

Also, since drain_all_stock() will be able to run on a remote CPU, protect
memcg_hotplug_cpu_dead() with stock_lock.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 mm/memcontrol.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 373fa78c4d881..5b7f7c2e0232f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2184,7 +2184,6 @@ struct memcg_stock_pcp {
 	int nr_slab_unreclaimable_b;
 #endif
 
-	struct work_struct work;
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
@@ -2269,18 +2268,15 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 	stock->cached = NULL;
 }
 
-static void drain_local_stock(struct work_struct *dummy)
+static void drain_stock_from(struct memcg_stock_pcp *stock)
 {
-	struct memcg_stock_pcp *stock;
 	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 
 	/*
-	 * The only protection from cpu hotplug (memcg_hotplug_cpu_dead) vs.
-	 * drain_stock races is that we always operate on local CPU stock
-	 * here with IRQ disabled
+	 * The protection from cpu hotplug (memcg_hotplug_cpu_dead) vs.
+	 * drain_stock races is stock_lock, a percpu spinlock.
 	 */
-	stock = this_cpu_ptr(&memcg_stock);
 	spin_lock_irqsave(&stock->stock_lock, flags);
 
 	old = drain_obj_stock(stock);
@@ -2329,7 +2325,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_all_stock(struct mem_cgroup *root_memcg)
 {
-	int cpu, curcpu;
+	int cpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
 	if (!mutex_trylock(&percpu_charge_mutex))
@@ -2341,7 +2337,6 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
 	 */
 	migrate_disable();
-	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2357,12 +2352,8 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 		rcu_read_unlock();
 
 		if (flush &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
-			if (cpu == curcpu)
-				drain_local_stock(&stock->work);
-			else
-				schedule_work_on(cpu, &stock->work);
-		}
+		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+			drain_stock_from(stock);
 	}
 	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);
@@ -2373,7 +2364,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	struct memcg_stock_pcp *stock;
 
 	stock = &per_cpu(memcg_stock, cpu);
+	spin_lock(&stock->stock_lock);
 	drain_stock(stock);
+	spin_unlock(&stock->stock_lock);
 
 	return 0;
 }
@@ -7328,7 +7321,7 @@ __setup("cgroup.memory=", cgroup_memory);
  */
 static int __init mem_cgroup_init(void)
 {
-	int cpu, node;
+	int node;
 
 	/*
 	 * Currently s32 type (can refer to struct batched_lruvec_stat) is
@@ -7341,10 +7334,6 @@ static int __init mem_cgroup_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
-	for_each_possible_cpu(cpu)
-		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_stock);
-
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
 
-- 
2.39.1


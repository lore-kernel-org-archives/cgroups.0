From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/3] mm/memcontrol: Add drain_remote_stock(), avoid drain_stock on isolated cpus
Date: Tue,  1 Nov 2022 23:02:43 -0300
Message-ID: <20221102020243.522358-4-leobras@redhat.com>
References: <20221102020243.522358-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667354635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2RYvVpIxnZB4mRhcfM8kpuAulQpsyxXS11J9gDFkxg=;
        b=PJz5y06htQ+9ZnL83LcO2c1qFPfYKBYxYY1kNtmpYXGl/tcoX5NBHunq/eiH9/MdYJnhqS
        OjD053+LPiR/1Qwu9i9biOuHJeXMzjnzVjKIjLvK/bfrcjkoBQ64UW8XPZgp1HnaN2o2Zb
        ZCsreJ1kokpkScPHqZReywGyFzyzV/k=
In-Reply-To: <20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mt>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

When drain_all_stock() is called, some CPUs will be required to have their
per-CPU caches drained. This currently happens by scheduling a call to
drain_local_stock() to run in each affected CPU.

This, as a consequence, may end up scheduling work to CPUs that are
isolated, and therefore should have as little interruption as possible.

In order to avoid this, make drain_all_stock() able to detect isolated CPUs
and schedule draining the perCPU stock to happen in another non-isolated
CPU.

But since the current implementation only allows the drain to happen in
local CPU, implement a function to drain stock on a remote CPU:
drain_remote_stock().

Given both drain_local_stock() and drain_remote_stock() do almost the same
work, implement a inline drain_stock_helper() that is called by both.

Also, since drain_stock() will be able to run on a remote CPU, protect
memcg_hotplug_cpu_dead() with stock_lock.

Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 47 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index add46da2e6df1..7ad6e4f4b79ef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -30,6 +30,7 @@
 #include <linux/cgroup.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/isolation.h>
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
@@ -2263,7 +2264,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 	stock->cached = NULL;
 }
 
-static void drain_local_stock(struct work_struct *dummy)
+static inline void drain_stock_helper(int cpu)
 {
 	struct memcg_stock_pcp *stock;
 	struct obj_cgroup *old = NULL;
@@ -2271,10 +2272,9 @@ static void drain_local_stock(struct work_struct *dummy)
 
 	/*
 	 * The only protection from cpu hotplug (memcg_hotplug_cpu_dead) vs.
-	 * drain_stock races is that we always operate on local CPU stock
-	 * here with IRQ disabled
+	 * drain_stock races is stock_lock, a percpu spinlock.
 	 */
-	stock = this_cpu_ptr(&memcg_stock);
+	stock = per_cpu_ptr(&memcg_stock, cpu);
 	spin_lock_irqsave(&stock->stock_lock, flags);
 
 	old = drain_obj_stock(stock);
@@ -2286,6 +2286,16 @@ static void drain_local_stock(struct work_struct *dummy)
 		obj_cgroup_put(old);
 }
 
+static void drain_remote_stock(struct work_struct *work)
+{
+	drain_stock_helper(atomic_long_read(&work->data));
+}
+
+static void drain_local_stock(struct work_struct *dummy)
+{
+	drain_stock_helper(smp_processor_id());
+}
+
 /*
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
@@ -2352,10 +2362,16 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 
 		if (flush &&
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
-			if (cpu == curcpu)
+			if (cpu == curcpu) {
 				drain_local_stock(&stock->work);
-			else
+			} else if (housekeeping_cpu(cpu, HK_TYPE_WQ)) {
 				schedule_work_on(cpu, &stock->work);
+			} else {
+				int hkcpu = housekeeping_any_cpu_from(HK_TYPE_WQ, cpu);
+
+				atomic_long_set(&stock->work.data, cpu);
+				schedule_work_on(hkcpu, &stock->work);
+			}
 		}
 	}
 	migrate_enable();
@@ -2367,7 +2383,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	struct memcg_stock_pcp *stock;
 
 	stock = &per_cpu(memcg_stock, cpu);
+	spin_lock(&stock->stock_lock);
 	drain_stock(stock);
+	spin_unlock(&stock->stock_lock);
 
 	return 0;
 }
@@ -7272,9 +7290,20 @@ static int __init mem_cgroup_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
-	for_each_possible_cpu(cpu)
-		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_stock);
+	/*
+	 * CPUs that are isolated should not spend cpu time for stock draining,
+	 * so allow them to export this task to the nearest housekeeping enabled
+	 * cpu available.
+	 */
+	for_each_possible_cpu(cpu) {
+		if (housekeeping_cpu(cpu, HK_TYPE_WQ)) {
+			INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
+				  drain_local_stock);
+		} else {
+			INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
+				  drain_remote_stock);
+		}
+	}
 
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
-- 
2.38.1


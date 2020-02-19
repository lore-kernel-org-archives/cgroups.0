From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 13:12:19 -0500
Message-ID: <20200219181219.54356-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nyHLiC8XkwcyLqR3rLu/BwGv+w1mXfzRj/lTpFIDBKk=;
        b=GkTPctej1MwDF6qrQTa6Bd5b3GEMii0/4ZyyoxUUxSVK4yrAFiTPNUkV9khKirjNjO
         lFDwLo4wsvoC6/B1DDUizFlvfN1+WWtaqgWi/dqZJ9Z8CZveyMpxwBLgytas4Yn+2Uc3
         Zuurs21A/VIiEmkLD9OohUUj/FiGGL+hG1hnIdL9AoWmoc/gil5ltV68GjMX+g1fnDq+
         i/8uY7ZU3xANLsmzcJI/zwX+vq8svSYZikeiMmC/vdmpTR2gYM5p/7jvug5Ciks+H39r
         O1M7vDcsrpHuOqOaZuNZINoAIhGcM6fltA2fDVsAeeAxuAIvKOxGrtQ4FgMm+OFKpFWL
         P3Pw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

We have received regression reports from users whose workloads moved
into containers and subsequently encountered new latencies. For some
users these were a nuisance, but for some it meant missing their SLA
response times. We tracked those delays down to cgroup limits, which
inject direct reclaim stalls into the workload where previously all
reclaim was handled my kswapd.

This patch adds asynchronous reclaim to the memory.high cgroup limit
while keeping direct reclaim as a fallback. In our testing, this
eliminated all direct reclaim from the affected workload.

memory.high has a grace buffer of about 4% between when it becomes
exceeded and when allocating threads get throttled. We can use the
same buffer for the async reclaimer to operate in. If the worker
cannot keep up and the grace buffer is exceeded, allocating threads
will fall back to direct reclaim before getting throttled.

For irq-context, there's already async memory.high enforcement. Re-use
that work item for all allocating contexts, but switch it to the
unbound workqueue so reclaim work doesn't compete with the workload.
The work item is per cgroup, which means the workqueue infrastructure
will create at maximum one worker thread per reclaiming cgroup.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 60 +++++++++++++++++++++++++++++++++++++------------
 mm/vmscan.c     | 10 +++++++--
 2 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cf02e3ef3ed9..bad838d9c2bb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1446,6 +1446,10 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	seq_buf_printf(&s, "pgsteal %lu\n",
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
 		       memcg_events(memcg, PGSTEAL_DIRECT));
+	seq_buf_printf(&s, "pgscan_direct %lu\n",
+		       memcg_events(memcg, PGSCAN_DIRECT));
+	seq_buf_printf(&s, "pgsteal_direct %lu\n",
+		       memcg_events(memcg, PGSTEAL_DIRECT));
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGACTIVATE),
 		       memcg_events(memcg, PGACTIVATE));
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGDEACTIVATE),
@@ -2235,10 +2239,19 @@ static void reclaim_high(struct mem_cgroup *memcg,
 
 static void high_work_func(struct work_struct *work)
 {
+	unsigned long high, usage;
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
-	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+
+	high = READ_ONCE(memcg->high);
+	usage = page_counter_read(&memcg->memory);
+
+	if (usage <= high)
+		return;
+
+	set_worker_desc("cswapd/%llx", cgroup_id(memcg->css.cgroup));
+	reclaim_high(memcg, usage - high, GFP_KERNEL);
 }
 
 /*
@@ -2304,15 +2317,22 @@ void mem_cgroup_handle_over_high(void)
 	unsigned long pflags;
 	unsigned long penalty_jiffies, overage;
 	unsigned int nr_pages = current->memcg_nr_pages_over_high;
+	bool tried_direct_reclaim = false;
 	struct mem_cgroup *memcg;
 
 	if (likely(!nr_pages))
 		return;
 
-	memcg = get_mem_cgroup_from_mm(current->mm);
-	reclaim_high(memcg, nr_pages, GFP_KERNEL);
 	current->memcg_nr_pages_over_high = 0;
 
+	memcg = get_mem_cgroup_from_mm(current->mm);
+	high = READ_ONCE(memcg->high);
+recheck:
+	usage = page_counter_read(&memcg->memory);
+
+	if (usage <= high)
+		goto out;
+
 	/*
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
@@ -2325,12 +2345,6 @@ void mem_cgroup_handle_over_high(void)
 	 * overage amount.
 	 */
 
-	usage = page_counter_read(&memcg->memory);
-	high = READ_ONCE(memcg->high);
-
-	if (usage <= high)
-		goto out;
-
 	/*
 	 * Prevent division by 0 in overage calculation by acting as if it was a
 	 * threshold of 1 page
@@ -2369,6 +2383,16 @@ void mem_cgroup_handle_over_high(void)
 	if (penalty_jiffies <= HZ / 100)
 		goto out;
 
+	/*
+	 * It's possible async reclaim just isn't able to keep
+	 * up. Before we go to sleep, try direct reclaim.
+	 */
+	if (!tried_direct_reclaim) {
+		reclaim_high(memcg, nr_pages, GFP_KERNEL);
+		tried_direct_reclaim = true;
+		goto recheck;
+	}
+
 	/*
 	 * If we exit early, we're guaranteed to die (since
 	 * schedule_timeout_killable sets TASK_KILLABLE). This means we don't
@@ -2544,13 +2568,21 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 */
 	do {
 		if (page_counter_read(&memcg->memory) > memcg->high) {
+			/*
+			 * Kick off the async reclaimer, which should
+			 * be doing most of the work to avoid latency
+			 * in the workload. But also check in on its
+			 * progress before resuming to userspace, in
+			 * case we need to do direct reclaim, or even
+			 * throttle the allocating thread if reclaim
+			 * cannot keep up with allocation demand.
+			 */
+			queue_work(system_unbound_wq, &memcg->high_work);
 			/* Don't bother a random interrupted task */
-			if (in_interrupt()) {
-				schedule_work(&memcg->high_work);
-				break;
+			if (!in_interrupt()) {
+				current->memcg_nr_pages_over_high += batch;
+				set_notify_resume(current);
 			}
-			current->memcg_nr_pages_over_high += batch;
-			set_notify_resume(current);
 			break;
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 74e8edce83ca..d6085115c7f2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1947,7 +1947,10 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
-	item = current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
+	if (current_is_kswapd() || (cgroup_reclaim(sc) && current_work()))
+		item = PGSCAN_KSWAPD;
+	else
+		item = PGSCAN_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
@@ -1961,7 +1964,10 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	spin_lock_irq(&pgdat->lru_lock);
 
-	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
+	if (current_is_kswapd() || (cgroup_reclaim(sc) && current_work()))
+		item = PGSTEAL_KSWAPD;
+	else
+		item = PGSTEAL_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-- 
2.24.1


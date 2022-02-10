From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] memcg: synchronously enforce memory.high
Date: Thu, 10 Feb 2022 00:14:37 -0800
Message-ID: <20220210081437.1884008-5-shakeelb@google.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0q8eaD2o+1BiQuwmTsW0+szf3blwzzBLhBN3MbGm/Z4=;
        b=jyKlPCDkTnjAVJRYaFvJfM0UrXF8oPSNP+C9pRbjAFL/2kYmZym/QI9V7bMI4CCfqM
         raQnGFMt5g12hmn2xl5bXPKm5iaY1T1yYxOO4aN+Qq3GfWTrvtO0TsG3hIPy98ECusbG
         f/Q5XzELsMUr/WWsjDh11Ve7lVAg+83rLxiKXZWhc3ssbCKLAOgHKTqI1F/M7IZmq1ag
         8wo3/fj1rPCuAO4mOHsujBMF56nJjl6LT08SnzfcS8qJtgGjlcjamO0m/wXUlTbPRjxQ
         pOZYt7iJheAFqmgQbabWmhfv8dK4je3ejK2v+scJR/f33hH/RKwQOQIvUSBdwhwziGnJ
         PZfw==
In-Reply-To: <20220210081437.1884008-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The high limit is used to throttle the workload without invoking the
oom-killer. Recently we tried to use the high limit to right size our
internal workloads. More specifically dynamically adjusting the limits
of the workload without letting the workload get oom-killed. However due
to the limitation of the implementation of high limit enforcement, we
observed the mechanism fails for some real workloads.

The high limit is enforced on return-to-userspace i.e. the kernel let
the usage goes over the limit and when the execution returns to
userspace, the high reclaim is triggered and the process can get
throttled as well. However this mechanism fails for workloads which do
large allocations in a single kernel entry e.g. applications that
mlock() a large chunk of memory in a single syscall. Such applications
bypass the high limit and can trigger the oom-killer.

To make high limit enforcement more robust, this patch make the limit
enforcement synchronous. However there are couple of open questions to
enforce high limit synchronously. What should be the behavior of
__GFP_NORETRY allocaion on hitting high limit? Similar question arise
for allocations which do not allow blocking. This patch took the
approach to keep the previous behavior i.e. let such allocations not
throttle synchronously but rely on the return-to-userspace mechanism to
throttle processes triggering such allocations.

This patch does not remove the return-to-userspace high limit
enforcement due to the reason mentioned in the previous para. Also the
allocations where the memory usage is below high limit but the swap
usage is above swap's high limit, such allocators are throttled in the
return-to-userspace.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/page_counter.h |  10 +++
 mm/memcontrol.c              | 124 ++++++++++++++++++++++-------------
 mm/page_counter.c            |  59 +++++++++++++----
 3 files changed, 132 insertions(+), 61 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 679591301994..08413a5c73f9 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -60,6 +60,16 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+
+enum charge_status {
+	CHG_SUCCESS,
+	CHG_FAILED_HIGH,
+	CHG_FAILED_MAX
+};
+enum charge_status page_counter_try_charge_high(struct page_counter *counter,
+						unsigned long nr_pages,
+						struct page_counter **fail);
+
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae73a40818b0..97833cade59e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1290,18 +1290,20 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 /**
  * mem_cgroup_margin - calculate chargeable space of a memory cgroup
  * @memcg: the memory cgroup
+ * @high: check high limit instead of max
  *
  * Returns the maximum amount of memory @mem can be charged with, in
  * pages.
  */
-static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
+static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg, bool high)
 {
 	unsigned long margin = 0;
 	unsigned long count;
 	unsigned long limit;
 
 	count = page_counter_read(&memcg->memory);
-	limit = READ_ONCE(memcg->memory.max);
+	limit = high ? READ_ONCE(memcg->memory.high) :
+			READ_ONCE(memcg->memory.max);
 	if (count < limit)
 		margin = limit - count;
 
@@ -1607,7 +1609,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mutex_lock_killable(&oom_lock))
 		return true;
 
-	if (mem_cgroup_margin(memcg) >= (1 << order))
+	if (mem_cgroup_margin(memcg, false) >= (1 << order))
 		goto unlock;
 
 	/*
@@ -2443,6 +2445,39 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
 	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
 }
 
+static unsigned long calculate_penalty_jiffies(struct mem_cgroup *memcg,
+					       unsigned long nr_pages)
+{
+	unsigned long penalty_jiffies;
+
+	/*
+	 * memory.high is breached and reclaim is unable to keep up. Throttle
+	 * allocators proactively to slow down excessive growth.
+	 */
+	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
+					       mem_find_max_overage(memcg));
+
+	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+						swap_find_max_overage(memcg));
+
+	/*
+	 * Clamp the max delay per usermode return so as to still keep the
+	 * application moving forwards and also permit diagnostics, albeit
+	 * extremely slowly.
+	 */
+	penalty_jiffies = min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+
+	/*
+	 * Don't sleep if the amount of jiffies this memcg owes us is so low
+	 * that it's not even worth doing, in an attempt to be nice to those who
+	 * go only a small amount over their memory.high value and maybe haven't
+	 * been aggressively reclaimed enough yet.
+	 */
+	if (penalty_jiffies <= HZ / 100)
+		return 0;
+	return penalty_jiffies;
+}
+
 /*
  * Scheduled by try_charge() to be executed from the userland return path
  * and reclaims memory over the high limit.
@@ -2477,30 +2512,8 @@ void mem_cgroup_handle_over_high(void)
 				    in_retry ? SWAP_CLUSTER_MAX : nr_pages,
 				    GFP_KERNEL);
 
-	/*
-	 * memory.high is breached and reclaim is unable to keep up. Throttle
-	 * allocators proactively to slow down excessive growth.
-	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
-					       mem_find_max_overage(memcg));
-
-	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
-						swap_find_max_overage(memcg));
-
-	/*
-	 * Clamp the max delay per usermode return so as to still keep the
-	 * application moving forwards and also permit diagnostics, albeit
-	 * extremely slowly.
-	 */
-	penalty_jiffies = min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
-
-	/*
-	 * Don't sleep if the amount of jiffies this memcg owes us is so low
-	 * that it's not even worth doing, in an attempt to be nice to those who
-	 * go only a small amount over their memory.high value and maybe haven't
-	 * been aggressively reclaimed enough yet.
-	 */
-	if (penalty_jiffies <= HZ / 100)
+	penalty_jiffies = calculate_penalty_jiffies(memcg, nr_pages);
+	if (!penalty_jiffies)
 		goto out;
 
 	/*
@@ -2534,6 +2547,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
+	enum charge_status status;
 	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
@@ -2545,7 +2559,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		status = page_counter_try_charge_high(&memcg->memory, batch,
+						      &counter);
+		if (status == CHG_SUCCESS)
 			goto done_restock;
 		if (do_memsw_account())
 			page_counter_uncharge(&memcg->memsw, batch);
@@ -2553,6 +2569,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	} else {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		may_swap = false;
+		status = CHG_FAILED_MAX;
 	}
 
 	if (batch > nr_pages) {
@@ -2575,14 +2592,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	memcg_memory_event(mem_over_limit,
+			   status == CHG_FAILED_MAX ? MEMCG_MAX : MEMCG_HIGH);
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
 	psi_memstall_leave(&pflags);
 
-	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
+	if (mem_cgroup_margin(mem_over_limit, status == CHG_FAILED_HIGH) >= nr_pages)
 		goto retry;
 
 	if (!drained) {
@@ -2614,23 +2632,34 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (nr_retries--)
 		goto retry;
 
-	if (gfp_mask & __GFP_RETRY_MAYFAIL)
-		goto nomem;
+	if (status == CHG_FAILED_MAX) {
+		if (gfp_mask & __GFP_RETRY_MAYFAIL)
+			goto nomem;
 
-	/* Avoid endless loop for tasks bypassed by the oom killer */
-	if (passed_oom && task_is_dying())
-		goto nomem;
+		/* Avoid endless loop for tasks bypassed by the oom killer */
+		if (passed_oom && task_is_dying())
+			goto nomem;
 
-	/*
-	 * keep retrying as long as the memcg oom killer is able to make
-	 * a forward progress or bypass the charge if the oom killer
-	 * couldn't make any progress.
-	 */
-	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
-			   get_order(nr_pages * PAGE_SIZE))) {
-		passed_oom = true;
-		nr_retries = MAX_RECLAIM_RETRIES;
-		goto retry;
+		/*
+		 * keep retrying as long as the memcg oom killer is able to make
+		 * a forward progress or bypass the charge if the oom killer
+		 * couldn't make any progress.
+		 */
+		if (mem_cgroup_oom(mem_over_limit, gfp_mask,
+				   get_order(nr_pages * PAGE_SIZE))) {
+			passed_oom = true;
+			nr_retries = MAX_RECLAIM_RETRIES;
+			goto retry;
+		}
+	} else {
+		unsigned long penalty_jiffies = calculate_penalty_jiffies(memcg,
+								nr_pages);
+
+		if (penalty_jiffies) {
+			psi_memstall_enter(&pflags);
+			schedule_timeout_killable(penalty_jiffies);
+			psi_memstall_leave(&pflags);
+		}
 	}
 nomem:
 	/*
@@ -2639,7 +2668,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)) && status != CHG_FAILED_HIGH)
 		return -ENOMEM;
 force:
 	/*
@@ -2651,7 +2680,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+	if (status != CHG_FAILED_HIGH)
+		return 0;
 
 done_restock:
 	if (batch > nr_pages)
diff --git a/mm/page_counter.c b/mm/page_counter.c
index eb156ff5d603..35c9360af334 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -86,19 +86,11 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
-/**
- * page_counter_try_charge - try to hierarchically charge pages
- * @counter: counter
- * @nr_pages: number of pages to charge
- * @fail: points first counter to hit its limit, if any
- *
- * Returns %true on success, or %false and @fail if the counter or one
- * of its ancestors has hit its configured limit.
- */
-bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail)
+static enum charge_status __page_counter_try_charge(
+			struct page_counter *counter, unsigned long nr_pages,
+			struct page_counter **fail, bool check_high)
 {
+	enum charge_status status = CHG_SUCCESS;
 	struct page_counter *c;
 
 	for (c = counter; c; c = c->parent) {
@@ -127,6 +119,12 @@ bool page_counter_try_charge(struct page_counter *counter,
 			 */
 			data_race(c->failcnt++);
 			*fail = c;
+			status = CHG_FAILED_MAX;
+			goto failed;
+		} else if (check_high && new > c->high) {
+			atomic_long_sub(nr_pages, &c->usage);
+			*fail = c;
+			status = CHG_FAILED_HIGH;
 			goto failed;
 		}
 		propagate_protected_usage(c, new);
@@ -137,13 +135,46 @@ bool page_counter_try_charge(struct page_counter *counter,
 		if (new > READ_ONCE(c->watermark))
 			WRITE_ONCE(c->watermark, new);
 	}
-	return true;
+	return status;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
 		page_counter_cancel(c, nr_pages);
 
-	return false;
+	return status;
+}
+
+/**
+ * page_counter_try_charge - try to hierarchically charge pages
+ * @counter: counter
+ * @nr_pages: number of pages to charge
+ * @fail: points first counter to hit its limit, if any
+ *
+ * Returns %true on success, or %false and @fail if the counter or one
+ * of its ancestors has hit its configured limit.
+ */
+bool page_counter_try_charge(struct page_counter *counter,
+			     unsigned long nr_pages,
+			     struct page_counter **fail)
+{
+	return __page_counter_try_charge(counter, nr_pages, fail, false) ==
+		CHG_SUCCESS;
+}
+
+/**
+ * page_counter_try_charge_high - try to hierarchically charge pages
+ * @counter: counter
+ * @nr_pages: number of pages to charge
+ * @fail: points first counter to hit its limit, if any
+ *
+ * Returns CHG_SUCESS on success, and if the counter or one of its ancestors
+ * has hit its configured max or high limit, return corresponding failure.
+ */
+enum charge_status page_counter_try_charge_high(struct page_counter *counter,
+			     unsigned long nr_pages,
+			     struct page_counter **fail)
+{
+	return __page_counter_try_charge(counter, nr_pages, fail, true);
 }
 
 /**
-- 
2.35.1.265.g69c8d7142f-goog


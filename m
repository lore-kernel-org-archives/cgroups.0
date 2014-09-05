From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcontrol: revert use of root_mem_cgroup res_counter
Date: Fri,  5 Sep 2014 08:43:57 -0400
Message-ID: <1409921037-21405-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=QvmGy//+wnpf5qUu0AancsRY1v7XFWC8zkVfyd3tpng=;
	b=VZMgUqmo0xnINjLo+40DwRL5D+yoL057zz74Ha42YBzVPIjp8oNB03VJ5L4vXe+4ufdTKx8W57S66De8UF54kj/jAcS/gpHlBmQ31GNyrSE1Ddzm+MMIksL1nSbUFT7Hhfn2Bk2ogJAfHoh5f0v4JHl2dlZEbDKNQeViyi3jzl8=;
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dave Hansen reports a massive scalability regression in an uncontained
page fault benchmark with more than 30 concurrent threads, which he
bisected down to 05b843012335 ("mm: memcontrol: use root_mem_cgroup
res_counter") and pin-pointed on res_counter spinlock contention.

That change relied on the per-cpu charge caches to mostly swallow the
res_counter costs, but it's apparent that the caches don't scale yet.

Revert memcg back to bypassing res_counters on the root level in order
to restore performance for uncontained workloads.

Reported-by: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Tested-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 103 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec4dcf1b9562..085dc6d2f876 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2534,6 +2534,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long long size;
 	int ret = 0;
 
+	if (mem_cgroup_is_root(memcg))
+		goto done;
 retry:
 	if (consume_stock(memcg, nr_pages))
 		goto done;
@@ -2611,9 +2613,7 @@ nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
 bypass:
-	memcg = root_mem_cgroup;
-	ret = -EINTR;
-	goto retry;
+	return -EINTR;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2626,6 +2626,9 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	res_counter_uncharge(&memcg->res, bytes);
 	if (do_swap_account)
 		res_counter_uncharge(&memcg->memsw, bytes);
@@ -2640,6 +2643,9 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
 	if (do_swap_account)
 		res_counter_uncharge_until(&memcg->memsw,
@@ -4093,6 +4099,46 @@ out:
 	return retval;
 }
 
+static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *memcg,
+					       enum mem_cgroup_stat_index idx)
+{
+	struct mem_cgroup *iter;
+	long val = 0;
+
+	/* Per-cpu values can be negative, use a signed accumulator */
+	for_each_mem_cgroup_tree(iter, memcg)
+		val += mem_cgroup_read_stat(iter, idx);
+
+	if (val < 0) /* race ? */
+		val = 0;
+	return val;
+}
+
+static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	u64 val;
+
+	if (!mem_cgroup_is_root(memcg)) {
+		if (!swap)
+			return res_counter_read_u64(&memcg->res, RES_USAGE);
+		else
+			return res_counter_read_u64(&memcg->memsw, RES_USAGE);
+	}
+
+	/*
+	 * Transparent hugepages are still accounted for in MEM_CGROUP_STAT_RSS
+	 * as well as in MEM_CGROUP_STAT_RSS_HUGE.
+	 */
+	val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
+	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
+
+	if (swap)
+		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
+
+	return val << PAGE_SHIFT;
+}
+
+
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
@@ -4102,8 +4148,12 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 
 	switch (type) {
 	case _MEM:
+		if (name == RES_USAGE)
+			return mem_cgroup_usage(memcg, false);
 		return res_counter_read_u64(&memcg->res, name);
 	case _MEMSWAP:
+		if (name == RES_USAGE)
+			return mem_cgroup_usage(memcg, true);
 		return res_counter_read_u64(&memcg->memsw, name);
 	case _KMEM:
 		return res_counter_read_u64(&memcg->kmem, name);
@@ -4572,10 +4622,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 	if (!t)
 		goto unlock;
 
-	if (!swap)
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
-	else
-		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+	usage = mem_cgroup_usage(memcg, swap);
 
 	/*
 	 * current_threshold points to threshold just below or equal to usage.
@@ -4673,10 +4720,10 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 
 	if (type == _MEM) {
 		thresholds = &memcg->thresholds;
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, false);
 	} else if (type == _MEMSWAP) {
 		thresholds = &memcg->memsw_thresholds;
-		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, true);
 	} else
 		BUG();
 
@@ -4762,10 +4809,10 @@ static void __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
 
 	if (type == _MEM) {
 		thresholds = &memcg->thresholds;
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, false);
 	} else if (type == _MEMSWAP) {
 		thresholds = &memcg->memsw_thresholds;
-		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, true);
 	} else
 		BUG();
 
@@ -5525,9 +5572,9 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		 * core guarantees its existence.
 		 */
 	} else {
-		res_counter_init(&memcg->res, &root_mem_cgroup->res);
-		res_counter_init(&memcg->memsw, &root_mem_cgroup->memsw);
-		res_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
+		res_counter_init(&memcg->res, NULL);
+		res_counter_init(&memcg->memsw, NULL);
+		res_counter_init(&memcg->kmem, NULL);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -5969,8 +6016,9 @@ static void __mem_cgroup_clear_mc(void)
 	/* we must fixup refcnts and charges */
 	if (mc.moved_swap) {
 		/* uncharge swap account from the old cgroup */
-		res_counter_uncharge(&mc.from->memsw,
-				     PAGE_SIZE * mc.moved_swap);
+		if (!mem_cgroup_is_root(mc.from))
+			res_counter_uncharge(&mc.from->memsw,
+					     PAGE_SIZE * mc.moved_swap);
 
 		for (i = 0; i < mc.moved_swap; i++)
 			css_put(&mc.from->css);
@@ -5979,8 +6027,9 @@ static void __mem_cgroup_clear_mc(void)
 		 * we charged both to->res and to->memsw, so we should
 		 * uncharge to->res.
 		 */
-		res_counter_uncharge(&mc.to->res,
-				     PAGE_SIZE * mc.moved_swap);
+		if (!mem_cgroup_is_root(mc.to))
+			res_counter_uncharge(&mc.to->res,
+					     PAGE_SIZE * mc.moved_swap);
 		/* we've already done css_get(mc.to) */
 		mc.moved_swap = 0;
 	}
@@ -6345,7 +6394,8 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry)
 	rcu_read_lock();
 	memcg = mem_cgroup_lookup(id);
 	if (memcg) {
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		if (!mem_cgroup_is_root(memcg))
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(memcg, false);
 		css_put(&memcg->css);
 	}
@@ -6509,12 +6559,15 @@ static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 {
 	unsigned long flags;
 
-	if (nr_mem)
-		res_counter_uncharge(&memcg->res, nr_mem * PAGE_SIZE);
-	if (nr_memsw)
-		res_counter_uncharge(&memcg->memsw, nr_memsw * PAGE_SIZE);
-
-	memcg_oom_recover(memcg);
+	if (!mem_cgroup_is_root(memcg)) {
+		if (nr_mem)
+			res_counter_uncharge(&memcg->res,
+					     nr_mem * PAGE_SIZE);
+		if (nr_memsw)
+			res_counter_uncharge(&memcg->memsw,
+					     nr_memsw * PAGE_SIZE);
+		memcg_oom_recover(memcg);
+	}
 
 	local_irq_save(flags);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS], nr_anon);
-- 
2.0.4

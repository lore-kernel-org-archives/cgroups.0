Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC643D3306
	for <cgroups@vger.kernel.org>; Sun, 17 May 2026 19:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779047005; cv=none; b=cCfgV2PVyjnMxeXigF9d+q7xZaEll6Kof30KFGrscp0ul1zjgyryn2DHMWTPgKqGjFKPj5fww00pYJ9Dc7RqXpinuo4mC44M9DarXk+yKzLPtyQkLAVeqlZ174Xyw6WwxyH0ExQ8aoRh9B9YaCk6vshAMVo2iqpV7O6ZN2aDqL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779047005; c=relaxed/simple;
	bh=KznaCiF5c6LBgkkGNfuVxha2b8yOzd2QqseiC2M76nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dCFrmvsF0mzBko7McJAm6yEFooRa+GBD38kcakbh5u6eypXLbanw2f2l8XTDAnlnwhrYOZv7/Z3Jcms3LB1TByeGbtGL7eEnzzGRpRQbjmGO2fBDLOibDf6BM0VwR09Alq5cHU8tjnBbV7jjoQ8c/bPhkzGmGqh0csDFQozwbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G5XDDwmK; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G5XDDwmK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779047001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dVdq1jCkPqSPhxPa9j3o3rCe8JoThsgPaLrsDuG7ZL0=;
	b=G5XDDwmKqGDrgio9xNyEW3gXjYRXJRVye2jJNq1tfICzAcvzmveTcRuNA7j0+dNrmQXq1N
	TL9CJp5z/XU/AB1YAilct63QAnncN4XLaNBg8B9pUvG4NH39l7F74XhUjJJKagXU8sBvXV
	WobS8+JwZE5bH1VoMrALbkYsolkNe6s=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2] memcg: cache obj_stock by memcg, not by objcg pointer
Date: Sun, 17 May 2026 12:43:08 -0700
Message-ID: <20260517194308.952655-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node, but the per-CPU obj_stock_pcp still keys cached_objcg by
pointer. Cross-NUMA workloads now see a drain on every refill and a
miss on every consume that targets a sibling per-node objcg of the
same memcg, producing the 67.7% stress-ng switch-mq regression
reported by LKP.

stock->nr_bytes are fungible across per-node objcgs of one memcg.
Treat the cache as keyed by memcg in __consume_obj_stock() and
__refill_obj_stock() so siblings share the reserve. Compare via
READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
the rcu_read_lock contract on obj_cgroup_memcg() does not apply.

In the same-memcg refill path also fold the incoming objcg's
nr_charged_bytes into the stock; otherwise sub-page residue
accumulates on whichever sibling was cached at drain time and
obj_cgroup_release() silently drops it, leaking up to nr_node_ids *
(PAGE_SIZE - 1) bytes per memcg lifecycle from the page_counter.
This issue was reported by Sashiko.

Update the now-stale invariant comment on __account_obj_stock().

Qi Zheng built a specialized reproducer [1] for the corner case and
confirmed the fix.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Debugged-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Qi Zheng <qi.zheng@linux.dev>
---

Changes since v1:
- Fix the rcu warning (Sashiko).
- Fix the page counter possible underflow warning (Sashiko).

 mm/memcontrol.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..e22ffa3b3319 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3152,7 +3152,12 @@ static void unlock_stock(struct obj_stock_pcp *stock)
 		local_unlock(&obj_stock.lock);
 }
 
-/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
+/*
+ * Call after __consume_obj_stock() / __refill_obj_stock(). The stock may be
+ * cached for a sibling per-node objcg of the same memcg; in that case the
+ * vmstat batching slot does not match objcg and we fall through to the
+ * direct path.
+ */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -3210,7 +3215,11 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
+	struct obj_cgroup *cached = READ_ONCE(stock->cached_objcg);
+
+	/* Sibling per-node objcgs share the reserve. */
+	if ((cached == objcg ||
+	     (cached && READ_ONCE(cached->memcg) == READ_ONCE(objcg->memcg))) &&
 	    stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		return true;
@@ -3318,6 +3327,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3337,11 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	if (cached == objcg)
+		goto add_bytes;
+	/* Direct READ_ONCE due to just pointer comparison. */
+	if (!cached || READ_ONCE(cached->memcg) != READ_ONCE(objcg->memcg)) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
@@ -3335,7 +3349,12 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
+	} else if (atomic_read(&objcg->nr_charged_bytes)) {
+		/* Fold sibling's stranded ncb into stock; else release leaks it. */
+		stock->nr_bytes += atomic_xchg(&objcg->nr_charged_bytes, 0);
+		allow_uncharge = true;
 	}
+add_bytes:
 	stock->nr_bytes += nr_bytes;
 
 	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
-- 
2.53.0-Meta


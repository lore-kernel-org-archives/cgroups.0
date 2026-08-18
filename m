Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B37A3A9D8D;
	Tue, 18 Aug 2026 02:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020490; cv=none; b=jyMTYubnToBQF4cIu8po+h0I9RQjIP9sQX5/9vqdV0beZ8fxMgLeAsPYDqidyfXDzMGXM1c28qIRW6bH9mTYb44yFxJX8Ir9blZr/r0tJaRQ6lf+/ZeGwUe1ADWJawiSLUONppgla2bjjLTy+dQPE7Tm2mRj2QGANkWU6zatc7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020490; c=relaxed/simple;
	bh=QERRDNzNRqRwWPZcxMd1thiJH+npbcNNlO1RNqoLW7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S1JnXGoFE/f0ylgVSgVvJakykFYqVWeEKgWrZgyTILebWiQiXjJ5Ktq4b/IDc7Un9priY4diCYSHNJnI3Mf+rx0wnuRHr975qyr3svsAQVKCkr4dTVFX0L1slHqP+Heh0ZoTiolywOQPGYgMCJjAHO5yiADv5p9Uk9yI4ks0FeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5bfa4da89aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:398ded98-3f9f-434b-8daf-d36197170dc8,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.19,REQID:398ded98-3f9f-434b-8daf-d36197170dc8,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:7db8b62,CLOUDID:c1d20639a0047f184a3fcca8f63363f7,BulkI
	D:260818103442SQQ5724R,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|136|85
	0|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5bfa4da89aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2082245598; Tue, 18 Aug 2026 10:34:38 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 4/8] mm/memcontrol: add per-tier charge and uncharge
Date: Tue, 18 Aug 2026 10:31:17 +0800
Message-Id: <20260818023121.100613-5-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiqi Liu <liuqiqi@kylinos.cn>

Extend the memcg charging infrastructure to support per-tier accounting.
After a successful global charge (try_charge_memcg), charge_memcg()
attempts per-tier charging. If the tier charge fails, the global charge
is rolled back via refill_stock() to maintain a consistent state.

Per-tier limits are enforced via dedicated page_counter objects with
both a hard limit (max) and a soft limit (high):

  - Hard limit: Charging beyond the tier's max triggers reclaim scoped
    to that tier's NUMA nodes and retries the charge. If reclaim fails,
    OOM is invoked, mirroring memory.max behavior. PF_MEMALLOC
    allocations force-charge past the tier max without reclaim (recursion
    guard); __GFP_NOFAIL/__GFP_HIGH allocations are force-charged past
    the tier max only after reclaim and OOM both fail.

  - Soft limit: The charge always succeeds, but if a tier exceeds its
    high watermark, the charge path schedules tier_high_work to perform
    asynchronous reclaim.

The folio lifecycle is updated accordingly:

  - Charging: Attempt per-tier charging after global success; roll back
    the global charge on tier failure.
  - Uncharging: Directly uncharge the tier counter.
  - Replacement: Force-charge the new folio to its tier; the old folio
    is uncharged upon freeing.
  - Migration: Keep the global usage unchanged; uncharge the old tier
    and charge the new tier to reflect the folio's new location.

This patch implements per-tier accounting for LRU folios (anon and file).

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/memcontrol.h |   1 +
 mm/memcontrol.c            | 198 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 197 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c0f5929a87bf..fa944e4bc5ad 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -330,6 +330,7 @@ struct mem_cgroup {
 
 	spinlock_t tier_lock;
 	struct list_head tier_counters;
+	struct work_struct tier_high_work;
 
 	struct mem_cgroup_per_node *nodeinfo[];
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70efe01bc36f..30f24604010c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2433,6 +2433,46 @@ static int memcg_tier_counter_create(struct mem_cgroup *memcg,
 	return 0;
 }
 
+static void memcg_charge_tier_id(struct mem_cgroup *memcg, int tier_id,
+				 unsigned long nr_pages)
+{
+	struct memcg_tier_counter *tc;
+
+	if (tier_id < 0)
+		return;
+	rcu_read_lock();
+	tc = memcg_tier_counter_find(memcg, tier_id);
+	if (tc)
+		page_counter_charge(&tc->counter, nr_pages);
+	rcu_read_unlock();
+}
+
+static void memcg_uncharge_tier_id(struct mem_cgroup *memcg, int tier_id,
+				   unsigned long nr_pages)
+{
+	struct memcg_tier_counter *tc;
+
+	if (tier_id < 0)
+		return;
+	rcu_read_lock();
+	tc = memcg_tier_counter_find(memcg, tier_id);
+	if (tc)
+		page_counter_uncharge(&tc->counter, nr_pages);
+	rcu_read_unlock();
+}
+
+static void memcg_charge_tier(struct mem_cgroup *memcg, struct folio *folio,
+			     unsigned long nr_pages)
+{
+	memcg_charge_tier_id(memcg, node_to_tier_id(folio_nid(folio)), nr_pages);
+}
+
+static void memcg_uncharge_tier(struct mem_cgroup *memcg, struct folio *folio,
+			       unsigned long nr_pages)
+{
+	memcg_uncharge_tier_id(memcg, node_to_tier_id(folio_nid(folio)), nr_pages);
+}
+
 static void memcg_free_tier_counters(struct mem_cgroup *memcg)
 {
 	struct memcg_tier_counter *tc, *tmp;
@@ -2445,6 +2485,49 @@ static void memcg_free_tier_counters(struct mem_cgroup *memcg)
 	spin_unlock(&memcg->tier_lock);
 }
 
+static unsigned long
+reclaim_tier(struct mem_cgroup *memcg, unsigned int nr_pages, gfp_t gfp_mask,
+	     nodemask_t *nmp)
+{
+	unsigned long nr_reclaimed, pflags;
+
+	psi_memstall_enter(&pflags);
+	nr_reclaimed = try_to_free_mem_cgroup_pages_nodemask(memcg, nr_pages, gfp_mask,
+							    MEMCG_RECLAIM_MAY_SWAP, NULL, nmp);
+	psi_memstall_leave(&pflags);
+	return nr_reclaimed;
+}
+
+static void tier_high_work_func(struct work_struct *work)
+{
+	struct mem_cgroup *memcg;
+	struct memcg_tier_counter *tc;
+	/* Few tiers in practice (2-4); cap is generous. */
+	int over_ids[16];
+	int nr_over = 0;
+	int i;
+
+	memcg = container_of(work, struct mem_cgroup, tier_high_work);
+
+	spin_lock(&memcg->tier_lock);
+	list_for_each_entry(tc, &memcg->tier_counters, list) {
+		if (page_counter_read(&tc->counter) > READ_ONCE(tc->counter.high)) {
+			if (nr_over < ARRAY_SIZE(over_ids))
+				over_ids[nr_over++] = tc->tier_id;
+		}
+	}
+	spin_unlock(&memcg->tier_lock);
+
+	for (i = 0; i < nr_over; i++) {
+		nodemask_t nodes;
+
+		if (tier_id_to_nodemask(over_ids[i], &nodes) ||
+		    nodes_empty(nodes))
+			continue;
+		reclaim_tier(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL, &nodes);
+	}
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2873,6 +2956,90 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 }
 
+static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
+	unsigned int nr_pages, int tier_id)
+{
+	struct memcg_tier_counter *tc;
+	struct page_counter *counter;
+	int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned long nr_reclaimed = 0;
+	bool passed_oom = false;
+	nodemask_t nodes, *nmp = NULL;
+
+	if (tier_id < 0)
+		return 0;
+
+	rcu_read_lock();
+	tc = memcg_tier_counter_find(memcg, tier_id);
+	rcu_read_unlock();
+	if (!tc)
+		return 0;
+
+retry:
+	if (page_counter_try_charge(&tc->counter, nr_pages, &counter))
+		goto success;
+
+	/* Over max -> reclaim. */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+	if (unlikely(task_in_memcg_oom(current)))
+		goto nomem;
+	if (!gfpflags_allow_blocking(gfp_mask))
+		goto nomem;
+
+	if (!tier_id_to_nodemask(tier_id, &nodes) && !nodes_empty(nodes))
+		nmp = &nodes;
+
+	nr_reclaimed = reclaim_tier(memcg, nr_pages, gfp_mask, nmp);
+
+	if (page_counter_read(&tc->counter) + nr_pages <= READ_ONCE(tc->counter.max))
+		goto retry;
+	if (gfp_mask & __GFP_NORETRY)
+		goto nomem;
+	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
+		goto retry;
+	if (nr_retries--)
+		goto retry;
+	if (gfp_mask & __GFP_RETRY_MAYFAIL)
+		goto nomem;
+	if (passed_oom && task_is_dying())
+		goto nomem;
+	if (mem_cgroup_oom(memcg, gfp_mask, get_order(nr_pages * PAGE_SIZE))) {
+		passed_oom = true;	/* tier max is a hard limit: OOM, like memory.max */
+		nr_retries = MAX_RECLAIM_RETRIES;
+		goto retry;
+	}
+	goto nomem;
+success:
+	do {
+		struct memcg_tier_counter *tc_this;
+
+		rcu_read_lock();
+		tc_this = memcg_tier_counter_find(memcg, tier_id);
+		if (tc_this &&
+		    page_counter_read(&tc_this->counter) > READ_ONCE(tc_this->counter.high) &&
+		    !work_pending(&memcg->tier_high_work)) {
+			schedule_work(&memcg->tier_high_work);
+			rcu_read_unlock();
+			break;
+		}
+		rcu_read_unlock();
+	} while ((memcg = parent_mem_cgroup(memcg)));
+	return 0;
+nomem:
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
+		return -ENOMEM;
+
+force:
+	/*
+	 * Force-charge past the tier max for reclaim/privileged allocations
+	 * (PF_MEMALLOC, or __GFP_NOFAIL/__GFP_HIGH that fell through from
+	 * nomem) -- not skip -- so the page is in tier.current too.
+	 */
+	page_counter_charge(&tc->counter, nr_pages);
+	return 0;
+}
+
 static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			     unsigned int nr_pages)
 {
@@ -4216,6 +4383,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_WORK(&memcg->high_work, high_work_func);
 	spin_lock_init(&memcg->tier_lock);
 	INIT_LIST_HEAD(&memcg->tier_counters);
+	INIT_WORK(&memcg->tier_high_work, tier_high_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4439,6 +4607,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
+	cancel_work_sync(&memcg->tier_high_work);
 	memcg_free_tier_counters(memcg);
 	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
@@ -5224,8 +5393,17 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 
 	objcg = get_obj_cgroup_from_memcg(memcg);
 	/* Do not account at the root objcg level. */
-	if (!obj_cgroup_is_root(objcg))
+	if (!obj_cgroup_is_root(objcg)) {
 		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
+		if (!ret) {
+			int tid = node_to_tier_id(folio_nid(folio));
+
+			ret = try_charge_memcg_tier(memcg, gfp, folio_nr_pages(folio), tid);
+			/* tier over max / OOM: undo the memory charge */
+			if (ret)
+				refill_stock(memcg, folio_nr_pages(folio));
+		}
+	}
 	if (ret) {
 		obj_cgroup_put(objcg);
 		return ret;
@@ -5385,8 +5563,11 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 		ug->nr_kmem += nr_pages;
 	} else {
 		/* LRU pages aren't accounted at the root level */
-		if (!obj_cgroup_is_root(objcg))
+		if (!obj_cgroup_is_root(objcg)) {
 			ug->nr_memory += nr_pages;
+			memcg_uncharge_tier(obj_cgroup_memcg(objcg), folio,
+				nr_pages);
+		}
 		ug->pgpgout++;
 
 		WARN_ON_ONCE(folio_unqueue_deferred_split(folio));
@@ -5461,6 +5642,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
+		memcg_charge_tier(memcg, new, nr_pages);
 	}
 
 	obj_cgroup_get(objcg);
@@ -5503,6 +5685,18 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
+	/* Re-account the per-tier breakdown if the folio moved across tiers. */
+	if (!obj_cgroup_is_root(objcg)) {
+		struct mem_cgroup *memcg = obj_cgroup_memcg(objcg);
+		int old_tier = node_to_tier_id(folio_nid(old));
+		int new_tier = node_to_tier_id(folio_nid(new));
+
+		if (old_tier != new_tier) {
+			memcg_uncharge_tier_id(memcg, old_tier, folio_nr_pages(old));
+			memcg_charge_tier_id(memcg, new_tier, folio_nr_pages(new));
+		}
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
-- 
2.43.0


Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2EE3AAF70;
	Tue, 18 Aug 2026 02:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020492; cv=none; b=iSB9yAmzBd62PABYxwPi6b6q1qmIQ1w90ttijqZVskyiRSdTcgxBvR9VL0G13o7kYtZE+8fRQAgnMBeBKsTN9MHL+TnKlfSFg9r6nO1/oGPd4J3h1pyg1WijDDzN/k1qoclRlFh/dF93bV5qiJxFpx3n3POQ/AuUpstHBUBbuZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020492; c=relaxed/simple;
	bh=X8cZPxMPr0f7eFctT2hs6HxX+lMTU2RFD1BsXs1yPW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=snxKzXF0G8M0dYFFBesfVmU4BtEvIn/VMyjo3Q9GxrDR9UdhIYaYfiYyXpaWbdFF2XfP4ZuJ7IpIJXfqYqoDeoi4blqepC1RP6b8tvptv11J+pO93T5kST4E1EQjfrKX/tMLVT3Mawmo0FtEs74J2odC0WEMlxApIzdkUmTL+ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5ccbdfee9aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b5121859-d5dc-4b7d-9c51-7ca2be675f6d,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:45
X-CID-INFO: VERSION:1.3.19,REQID:b5121859-d5dc-4b7d-9c51-7ca2be675f6d,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:45
X-CID-META: VersionHash:7db8b62,CLOUDID:5b044b72777c071c1e68888d5785b45b,BulkI
	D:2608181034420ALZMMQF,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|136|85
	0|865|898,TC:nil,Content:0|15|50,EDM:5|-100,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5ccbdfee9aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 148148293; Tue, 18 Aug 2026 10:34:40 +0800
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
Subject: [RFC PATCH 5/8] mm/memcontrol: add per-cpu stock for tier charge/uncharge
Date: Tue, 18 Aug 2026 10:31:18 +0800
Message-Id: <20260818023121.100613-6-liuqiqi@kylinos.cn>
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

Add tier_stock_pcp, a per-cpu cache with NR_TIER_STOCK slots, to cache
charge surplus for specific (memcg, tier_id) pairs.

The fast path, consume_tier_stock(), attempts to satisfy charges from
this cache. On a miss, try_charge_memcg_tier() charges in units of
max(MEMCG_CHARGE_BATCH, nr_pages), falling back to an exact nr_pages
charge when the batch does not fit, and refill_tier_stock() restocks
the surplus. Uncharging is handled by the same helper: refill_tier_stock()
drains a mismatched slot and caches the new pair.

Cached stock is drained via drain_all_tier_stock() during css_offline,
and from the charge path when a tier charge retries under limit pressure.

This is purely an optimization; the semantics remain identical to
per-page charging.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/memcontrol.c | 211 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 203 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 30f24604010c..3aa55c287248 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2318,11 +2318,33 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	mutex_unlock(&percpu_charge_mutex);
 }
 
+/*
+ * Per-CPU tier charge/uncharge stock: caches up to NR_TIER_STOCK (memcg,
+ * tier_id) pairs so small charges/uncharges avoid atomics.
+ */
+#define NR_TIER_STOCK 7
+struct tier_stock_pcp {
+	local_lock_t lock;
+	uint8_t nr_pages[NR_TIER_STOCK];
+	struct mem_cgroup *cached[NR_TIER_STOCK];
+	int tier_id[NR_TIER_STOCK];
+	struct work_struct work;
+	unsigned long flags;
+	uint8_t drain_idx;
+};
+static DEFINE_PER_CPU(struct tier_stock_pcp, tier_stock);
+
+static void __drain_tier_stock(struct tier_stock_pcp *stock, int i);
+
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	/* no need for the local lock */
+	int i;
+
 	drain_obj_stock(&per_cpu(obj_stock, cpu));
 	drain_stock_fully(&per_cpu(memcg_stock, cpu));
+	for (i = 0; i < NR_TIER_STOCK; i++)
+		__drain_tier_stock(&per_cpu(tier_stock, cpu), i);
 
 	return 0;
 }
@@ -2467,12 +2489,6 @@ static void memcg_charge_tier(struct mem_cgroup *memcg, struct folio *folio,
 	memcg_charge_tier_id(memcg, node_to_tier_id(folio_nid(folio)), nr_pages);
 }
 
-static void memcg_uncharge_tier(struct mem_cgroup *memcg, struct folio *folio,
-			       unsigned long nr_pages)
-{
-	memcg_uncharge_tier_id(memcg, node_to_tier_id(folio_nid(folio)), nr_pages);
-}
-
 static void memcg_free_tier_counters(struct mem_cgroup *memcg)
 {
 	struct memcg_tier_counter *tc, *tmp;
@@ -2956,14 +2972,173 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 }
 
+/* Drain cached tier charge from a per-CPU stock slot.
+ * The drained count is returned to the tier's page_counter,
+ * and the memcg css reference is put.
+ */
+static void __drain_tier_stock(struct tier_stock_pcp *stock, int i)
+{
+	struct memcg_tier_counter *tc;
+	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
+	uint8_t stock_pages;
+
+	if (!old)
+		return;
+	stock_pages = READ_ONCE(stock->nr_pages[i]);
+	if (stock_pages) {
+		rcu_read_lock();
+		tc = memcg_tier_counter_find(old, READ_ONCE(stock->tier_id[i]));
+		if (tc)
+			page_counter_uncharge(&tc->counter, stock_pages);
+		rcu_read_unlock();
+		WRITE_ONCE(stock->nr_pages[i], 0);
+	}
+	css_put(&old->css);
+	WRITE_ONCE(stock->cached[i], NULL);
+	WRITE_ONCE(stock->tier_id[i], -1);
+}
+
+static void drain_local_tier_stock(struct work_struct *dummy)
+{
+	struct tier_stock_pcp *stock;
+	int i;
+
+	if (WARN_ON_ONCE(!in_task()))
+		return;
+	local_lock(&tier_stock.lock);
+	stock = this_cpu_ptr(&tier_stock);
+	for (i = 0; i < NR_TIER_STOCK; i++)
+		__drain_tier_stock(stock, i);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+	local_unlock(&tier_stock.lock);
+}
+
+/* Drain per-CPU tier stock entries matching @memcg on all CPUs. */
+static void drain_all_tier_stock(struct mem_cgroup *memcg)
+{
+	int cpu, curcpu, i;
+
+	if (!mutex_trylock(&percpu_charge_mutex))
+		return;
+	migrate_disable();
+	curcpu = smp_processor_id();
+	for_each_online_cpu(cpu) {
+		struct tier_stock_pcp *stock = &per_cpu(tier_stock, cpu);
+
+		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+			continue;
+		for (i = 0; i < NR_TIER_STOCK; i++) {
+			if (READ_ONCE(stock->cached[i]) != memcg)
+				continue;
+			if (!test_and_set_bit(FLUSHING_CACHED_CHARGE,
+				      &stock->flags)) {
+				if (cpu == curcpu)
+					drain_local_tier_stock(&stock->work);
+				else
+					schedule_drain_work(cpu, &stock->work);
+			}
+			break;
+		}
+	}
+	migrate_enable();
+	mutex_unlock(&percpu_charge_mutex);
+}
+
+/* Consume @nr_pages from the per-CPU tier stock if a matching slot has enough surplus */
+static bool consume_tier_stock(struct mem_cgroup *memcg, int tier_id,
+				      unsigned int nr_pages)
+{
+	struct tier_stock_pcp *stock;
+	bool ret = false;
+	int i;
+	uint8_t pages;
+
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
+
+	if (nr_pages > MEMCG_CHARGE_BATCH)
+		return false;
+
+	local_lock(&tier_stock.lock);
+	stock = this_cpu_ptr(&tier_stock);
+
+	for (i = 0; i < NR_TIER_STOCK; i++) {
+		if (READ_ONCE(stock->cached[i]) == memcg &&
+		    READ_ONCE(stock->tier_id[i]) == tier_id) {
+			pages = READ_ONCE(stock->nr_pages[i]);
+			if (pages >= nr_pages) {
+				WRITE_ONCE(stock->nr_pages[i], pages - nr_pages);
+				ret = true;
+			}
+			break;
+		}
+	}
+
+	local_unlock(&tier_stock.lock);
+	return ret;
+}
+
+/* Refund @nr_pages to the per-CPU tier stock. */
+static void refill_tier_stock(struct mem_cgroup *memcg, int tier_id,
+				      unsigned int nr_pages)
+{
+	struct memcg_tier_counter *tc;
+	struct tier_stock_pcp *stock;
+	int empty_slot = -1;
+	uint8_t pages;
+	int i;
+
+	/* Too big to cache: direct uncharge, leave the stock untouched. */
+	if (nr_pages > MEMCG_CHARGE_BATCH) {
+		rcu_read_lock();
+		tc = memcg_tier_counter_find(memcg, tier_id);
+		if (tc)
+			page_counter_uncharge(&tc->counter, nr_pages);
+		rcu_read_unlock();
+		return;
+	}
+
+	local_lock(&tier_stock.lock);
+	stock = this_cpu_ptr(&tier_stock);
+
+	for (i = 0; i < NR_TIER_STOCK; i++) {
+		if (!READ_ONCE(stock->cached[i]) && empty_slot == -1)
+			empty_slot = i;
+		if (READ_ONCE(stock->cached[i]) == memcg &&
+		    READ_ONCE(stock->tier_id[i]) == tier_id) {
+			pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+			WRITE_ONCE(stock->nr_pages[i], pages);
+			if (pages > MEMCG_CHARGE_BATCH)
+				__drain_tier_stock(stock, i);
+			goto out;
+		}
+	}
+
+	/* Mismatch: pick a slot (empty or evict), drain, cache new. */
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_TIER_STOCK)
+			stock->drain_idx = 0;
+	}
+	__drain_tier_stock(stock, i);
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->tier_id[i], tier_id);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+out:
+	local_unlock(&tier_stock.lock);
+}
+
 static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned int nr_pages, int tier_id)
 {
 	struct memcg_tier_counter *tc;
 	struct page_counter *counter;
+	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_reclaimed = 0;
 	bool passed_oom = false;
+	bool drained = false;
 	nodemask_t nodes, *nmp = NULL;
 
 	if (tier_id < 0)
@@ -2976,9 +3151,16 @@ static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		return 0;
 
 retry:
-	if (page_counter_try_charge(&tc->counter, nr_pages, &counter))
+	if (consume_tier_stock(memcg, tier_id, nr_pages))
+		return 0;
+	if (page_counter_try_charge(&tc->counter, batch, &counter))
 		goto success;
 
+	if (batch > nr_pages) {
+		batch = nr_pages;
+		goto retry;
+	}
+
 	/* Over max -> reclaim. */
 	if (unlikely(current->flags & PF_MEMALLOC))
 		goto force;
@@ -2994,6 +3176,13 @@ static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	if (page_counter_read(&tc->counter) + nr_pages <= READ_ONCE(tc->counter.max))
 		goto retry;
+
+	if (!drained) {
+		drain_all_tier_stock(memcg);
+		drained = true;
+		goto retry;
+	}
+
 	if (gfp_mask & __GFP_NORETRY)
 		goto nomem;
 	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
@@ -3011,6 +3200,8 @@ static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	}
 	goto nomem;
 success:
+	if (batch > nr_pages)
+		refill_tier_stock(memcg, tier_id, batch - nr_pages);
 	do {
 		struct memcg_tier_counter *tc_this;
 
@@ -4575,6 +4766,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
+	drain_all_tier_stock(memcg);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
@@ -5565,7 +5757,8 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 		/* LRU pages aren't accounted at the root level */
 		if (!obj_cgroup_is_root(objcg)) {
 			ug->nr_memory += nr_pages;
-			memcg_uncharge_tier(obj_cgroup_memcg(objcg), folio,
+			refill_tier_stock(obj_cgroup_memcg(objcg),
+				node_to_tier_id(folio_nid(folio)),
 				nr_pages);
 		}
 		ug->pgpgout++;
@@ -5893,6 +6086,8 @@ int __init mem_cgroup_init(void)
 			  drain_local_memcg_stock);
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
+		INIT_WORK(&per_cpu(tier_stock, cpu).work,
+			  drain_local_tier_stock);
 	}
 
 	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids);
-- 
2.43.0


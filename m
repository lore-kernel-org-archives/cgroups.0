Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA98344A71D
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134078; cv=none; b=oP/8VLVgIHSyZCQQOPCkvzkcmoMEJMk73Zn32BUKL0z2QPdYEDCbFwLB26rVSI2AqzEjuMgvoLo/by1S/KZWKeYUoq+6LRStGF2VTbk1+uLeCYZmnJljcEqgBfr1OAnNPsJbwzdqZr3dRHTMOAxHZRFDc2jum/pyhgJ0QjvlgVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134078; c=relaxed/simple;
	bh=WtW+xUg5a0joD1Hd5vyHXE9LR+eLMwzjl5LF9juBCBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFiqI+Bul/wLv203+pec8h8DyxwaE5ML09SkzT6PAVCAoZ4kqIlbKbKg+zYTx1rtEG3qMJRE/P+9IBuByzcd0q4Ttv4fYehZ4pDgxzrIcWI4Xg+o4Jq0OnhLWrEeAsAMLEzPRZmE+llLYVaae3+aKPO8owa3gYTUVZELq138XYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sJdBQJ02; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sJdBQJ02"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6acc15016f1so2315823eaf.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134076; x=1786738876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UreOU1bs1UnYmmJ7pTF9AE47T3l1T/OGD/BO7qMZ90c=;
        b=sJdBQJ02FjELftf2PnRoZy3Gak1O7QnghngDYWblm1KT4ebWqv1U24Zf9qiW6A2+jB
         0BD4fp1Rzr/UhHN/jNbc4Yy1BqYsZmOXQ6Jw61PmyFUqfDBaZ8Yu5rDqYGB6NFzy8P98
         EwO2s295AERRPL8OK2VI1ocjoZ7l7GD/LksAMT+w2iZAhRoN9uwYlPMiSC+ClX/OjkpE
         oi7ZXfG4Gwn9+uQsF0q4a9Z9xrcCsc3l0qnvwwCAg4VK+j/biv62AAC0F1LbTqqryuZD
         YSRbqdDQXFXczAqt8WkdeDAajhJHcnxqk/MLY/66fhZVWaggbb5kWmCHLgLpsdDKXLmk
         ja3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134076; x=1786738876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UreOU1bs1UnYmmJ7pTF9AE47T3l1T/OGD/BO7qMZ90c=;
        b=OCNWGZ/WD9KcPE6JDr9R7on5bXZigM+pGaemyv9etG/wiqV3sab8FSADvGCf+66jZA
         MWUkHeXn6Wfqr2q6WgSoD2SCzwcozwL+tpe1297vjhoS/27F+ZeP66ZDU44CbxAFYel0
         Jr6aCbJ5Qb7oq6ejb/iDpdPkwxbyBpBu/ZGE06XbiwpknNqWdhpTKqatRHCqS/ZXZNla
         OTreCsmMZdesIM2B4X/HYos+HAKEC7hz1P4AK+BszFhSLMtmL0/1Gskro5MSH4038ZaY
         nQX1+7D0Z+/2tG8jCm6fAbsleDjwkTVHLoTPw3ZlrrOHVwZd+yhIuZVBKmvnOBUe0HFq
         TQgQ==
X-Forwarded-Encrypted: i=1; AHgh+RoiPgHPd6g4vKWYgNNLX6zHtz02Th7WHBGEFjVTBy2tAhp3WZU4DO9K0as5p/zPfI5EgOtwuRoX@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjs3LG4fVUhqHmYksV7IlgXi78whyYsMkpMw1ZQ73Zm3ZnU24r
	lZykoIqwawFLlgMKEUOd6/bWbxWmfWeacadY/s7LvI79nsvdleUmCAJd
X-Gm-Gg: AR+sD108bRhoGL3E6Y6z/4TPcVn4rbIKHBjp81QGnTAKRePARPSJoMvL7tPleBYiwRp
	dGcu4O5BecGJwfr35QAwgx8Vfo1Hz+Y///Zth92jYIvqlSWdNdedwoC8Mudk8N3utZfyuRMr6c5
	OzTD/rRLLJsgT1KLmGpr0nQvIPgQCuj5dJ2ZItYpzIjCaSlnFo9xzzwSa5Ekc+HPS397Wu51+hC
	pbKX3rw//cuOHkk8HFSW7tQOM97eLLPLqi8kYiwK4iEe4HNKyplO7rUDotMW525QbMO3Ks7Z70b
	OBtDSqrIQ+k/q8UFPK7jv6vZ87CPVGSJld8YdnL6Qx6UXT7MvtCJ8/d7SBvdW63z7itIQ+6KZNH
	JcWkiNi1xW+QHPRz5pRrhlFA5UWTj2Jphgrxr4QDuLlra83Lxn1MQUErJI7FoqVwX3EQXvndz3d
	JFDL3MqJUhE311iiWkJfdedlSkZKLuGRSQHoDhET53JNLhs6KmvQkz6nZEovRxSv2X4smTzyqlK
	1as4Lrbj0LGRIqdD/g=
X-Received: by 2002:a05:6820:4dfc:b0:6a1:7790:258e with SMTP id 006d021491bc7-6ae96ec782bmr14629606eaf.18.1786134075612;
        Fri, 07 Aug 2026 13:21:15 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be8ede0sm3225544eaf.12.2026.08.07.13.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 10/14] mm/memcontrol: Make memory.max tier-aware
Date: Fri,  7 Aug 2026 13:20:53 -0700
Message-ID: <20260807202059.2620949-11-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of tiered memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not
where that memory resides.

Extend the existing memory.max limit to be tier-aware. A folio charge
is now attempted against the page_counter of the tier the folio was
allocated on, in addition to memory and memsw. When the tier counter
is over its limit, reclaim is targeted at that tier's nodes only.

Tier counters are parent-linked index-for-index with the memcg
hierarchy, so the counter reported by page_counter_try_charge() belongs
to an ancestor of the charging memcg.  memcg->tier is a separate
allocation, so container_of() cannot recover the owner;
tier_counter_mem_cgroup() walks the chain instead. This is only done
on the charge failure path.

mem_cgroup_margin() takes the tier slot so that the retry check and the
OOM re-check under oom_lock consider the tier that actually failed.
Taking the minimum across all tiers would report no headroom whenever
any tier is full, which would disable the pile-on guard in
mem_cgroup_out_of_memory() for plain memory.max breaches as well.

Note that stock is currently a per-memcg resource and does not
distinguish between tiers. There is ongoing work to change this,
however. Until then, tiered usage may transiently breach the max limit.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 112 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 84 insertions(+), 28 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 44ea465b2005d..de6762520f475 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1570,14 +1570,32 @@ static struct page_counter *mem_cgroup_tier_counter(struct mem_cgroup *memcg,
 	return &memcg->tier[slot];
 }
 
+static struct mem_cgroup *tier_counter_mem_cgroup(struct mem_cgroup *memcg,
+						  struct page_counter *counter,
+						  int slot)
+{
+	struct mem_cgroup *iter;
+
+	for (iter = memcg; iter; iter = parent_mem_cgroup(iter)) {
+		if (&iter->tier[slot] == counter)
+			return iter;
+	}
+
+	/* the failing counter is always an ancestor of the given memcg */
+	VM_WARN_ON_ONCE(1);
+	return memcg;
+}
+
 /**
  * mem_cgroup_margin - calculate chargeable space of a memory cgroup
  * @memcg: the memory cgroup
+ * @slot: the memory tier slot
  *
- * Returns the maximum amount of memory @mem can be charged with, in
- * pages.
+ * Returns the maximum amount of memory @mem can be charged with, in pages.
+ * If the system has tiered memcg limits, then it returns the minimum of the
+ * tiered margin and the memcg margin.
  */
-static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
+static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg, int slot)
 {
 	unsigned long margin = 0;
 	unsigned long count;
@@ -1597,6 +1615,21 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
 			margin = 0;
 	}
 
+	if (mem_cgroup_tiered_limits()) {
+		struct page_counter *tier_counter;
+
+		tier_counter = mem_cgroup_tier_counter(memcg, slot);
+		if (!tier_counter)
+			return margin;
+
+		count = page_counter_read(tier_counter);
+		limit = READ_ONCE(tier_counter->max);
+		if (count < limit)
+			margin = min(margin, limit - count);
+		else
+			margin = 0;
+	}
+
 	return margin;
 }
 
@@ -1945,7 +1978,7 @@ void __memcg_memory_event(struct mem_cgroup *memcg,
 EXPORT_SYMBOL_GPL(__memcg_memory_event);
 
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order)
+				     int order, int slot)
 {
 	struct oom_control oc = {
 		.zonelist = NULL,
@@ -1959,7 +1992,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mutex_lock_killable(&oom_lock))
 		return true;
 
-	if (mem_cgroup_margin(memcg) >= (1 << order))
+	if (mem_cgroup_margin(memcg, slot) >= (1 << order))
 		goto unlock;
 
 	/*
@@ -1977,7 +2010,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
  * Returns true if successfully killed one or more processes. Though in some
  * corner cases it can return true even without killing any process.
  */
-static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
+static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order,
+			   int slot)
 {
 	bool locked, ret;
 
@@ -1989,7 +2023,7 @@ static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 	if (!memcg1_oom_prepare(memcg, &locked))
 		return false;
 
-	ret = mem_cgroup_out_of_memory(memcg, mask, order);
+	ret = mem_cgroup_out_of_memory(memcg, mask, order, slot);
 
 	memcg1_oom_finish(memcg, locked);
 
@@ -2388,13 +2422,15 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 }
 
 static bool memcg_tier_over_limit(struct mem_cgroup *memcg,
-				  unsigned long *overage, int *breached_slot)
+				  unsigned long *overage, int *breached_slot,
+				  bool high)
 {
 	int nr_tier_slots = mt_nr_tier_slots();
 
 	for (int slot = 0; slot < nr_tier_slots; slot++) {
 		unsigned long usage = page_counter_read(&memcg->tier[slot]);
-		unsigned long limit = READ_ONCE(memcg->tier[slot].high);
+		unsigned long limit = high ? READ_ONCE(memcg->tier[slot].high) :
+					     READ_ONCE(memcg->tier[slot].max);
 
 		if (usage <= limit)
 			continue;
@@ -2425,7 +2461,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 
 			if (!mem_cgroup_tiered_limits())
 				continue;
-			if (!memcg_tier_over_limit(memcg, NULL, &slot))
+			if (!memcg_tier_over_limit(memcg, NULL, &slot, true))
 				continue;
 
 			reclaim_nodes = mt_tier_nodes(slot);
@@ -2719,6 +2755,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 	int slot = -1;
+	const nodemask_t *reclaim_nodes;
 
 	if (mem_cgroup_tiered_limits()) {
 		slot = nid_tier_slot(nid);
@@ -2737,6 +2774,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	reclaim_nodes = NULL;
 
 	if (do_memsw_account() &&
 	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
@@ -2745,15 +2783,23 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter)) {
+	if (tier_counter &&
+	    !page_counter_try_charge(tier_counter, nr_pages, &counter)) {
+		mem_over_limit = tier_counter_mem_cgroup(memcg, counter, slot);
+		reclaim_nodes = mt_tier_nodes(slot);
+		goto reclaim;
+	}
+
+	if (!page_counter_try_charge(&memcg->memory, batch, &counter)) {
+		mem_over_limit = mem_cgroup_from_counter(counter, memory);
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, batch);
 		if (tier_counter)
-			page_counter_charge(tier_counter, nr_pages);
-		goto done_restock;
+			page_counter_uncharge(tier_counter, nr_pages);
+		goto reclaim;
 	}
 
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, batch);
-	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+	goto done_restock;
 
 reclaim:
 	if (batch > nr_pages) {
@@ -2782,13 +2828,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, reclaim_options,
-						    NULL, NULL);
+						    NULL, reclaim_nodes);
 	psi_memstall_leave(&pflags);
 
-	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
+	if (mem_cgroup_margin(mem_over_limit, slot) >= nr_pages)
 		goto retry;
 
-	if (!drained) {
+	if (!drained && !reclaim_nodes) {
 		drain_all_stock(mem_over_limit);
 		drained = true;
 		goto retry;
@@ -2824,7 +2870,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * couldn't make any progress.
 	 */
 	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
-			   get_order(nr_pages * PAGE_SIZE))) {
+			   get_order(nr_pages * PAGE_SIZE), slot)) {
 		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
@@ -2880,7 +2926,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 		tier_high = mem_cgroup_tiered_limits() &&
-			memcg_tier_over_limit(memcg, NULL, NULL);
+			memcg_tier_over_limit(memcg, NULL, NULL, true);
 
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
@@ -5011,7 +5057,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 			if (!mem_cgroup_tiered_limits())
 				break;
-			if (!memcg_tier_over_limit(memcg, &charge, &slot))
+			if (!memcg_tier_over_limit(memcg, &charge, &slot, true))
 				break;
 
 			reclaim_nodes = mt_tier_nodes(slot);
@@ -5073,12 +5119,22 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
+		unsigned long charge;
+		const nodemask_t *reclaim_nodes = NULL;
+		int slot = -1;
 
 		if (max != READ_ONCE(memcg->memory.max))
 			break;
 
-		if (nr_pages <= max)
-			break;
+		if (nr_pages <= max) {
+			if (!mem_cgroup_tiered_limits())
+				break;
+			if (!memcg_tier_over_limit(memcg, &charge, &slot, false))
+				break;
+			reclaim_nodes = mt_tier_nodes(slot);
+		} else {
+			charge = nr_pages - max;
+		}
 
 		if (signal_pending(current))
 			break;
@@ -5087,22 +5143,22 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		if (memcg_is_dying(memcg))
 			break;
 
-		if (!drained) {
+		if (!drained && !reclaim_nodes) {
 			drain_all_stock(memcg);
 			drained = true;
 			continue;
 		}
 
 		if (nr_reclaims) {
-			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
+			if (!try_to_free_mem_cgroup_pages(memcg, charge,
 					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL, NULL))
+					NULL, reclaim_nodes))
 				nr_reclaims--;
 			continue;
 		}
 
 		memcg_memory_event(memcg, MEMCG_OOM);
-		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
+		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0, slot))
 			break;
 		cond_resched();
 	}
-- 
2.53.0-Meta


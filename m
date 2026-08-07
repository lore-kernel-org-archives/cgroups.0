Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDEF445AFE
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134074; cv=none; b=OnDJRAf7TR7fiz+l9fKqjk7hw2DHwJggHUCKI1ME5PPemMeAI9vb+iLc2Mrhw3pLlxT5x/g6JDQpL2JlqSGRdz7TZHFJBsf/oX15X3oO3WSmP5pSFQ7CqkFeF66DVyOfJVd9sOqDhr9IIn03WpAEYkRWM8+mi0dNe3LK3B6zRQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134074; c=relaxed/simple;
	bh=+IzWGgaNbj6Y02X6WE/c6I/buYlv0yEEBkp/xShOgGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/Rg6EMLVrwXVW8pHSuRpjsBSJ0snvRWWENCKYNmE6PiMNRPppxcq4mT8tphtFhAkmVHEefaIBz0sr62RSv5eweU/txTCEyuCPmKi/td7pbkeKvPaiuoFduh1PUBgXfJWmxT2cuImpwfNrZN/eRbk+yrBSkxl2oR+njQZbIzQc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sc4SzZ0h; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sc4SzZ0h"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-45691990234so2410980fac.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134072; x=1786738872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lxxJcfOvuS2DiwqIjrqP14riK8k/np3VBj64PdkOyLA=;
        b=sc4SzZ0hWlHxRydlGqtK6Iwsz0JMmjpThjdRZ//Bw7660Vd9ueHOacG4d984f4V1Fy
         /xx1LRTgLX0y1k5+OhZ7NAmRdAGPrwIKKdhA80gNiur6xeXH937tSeZDwgqUy1Ijn4hE
         DQjncRVO64HYESqynNfoIB3PoXsp96zl5vgwP/uGWUlZRR77WWYh0ttoKG2tb3xwIqr2
         kECE8zjQC7S8U3Dm/AgOeJQKklfPc/GzH1lGD84+/oPfF59iBVRnsyKu9lBTRYGMC7ih
         TV0T2hJgmH5J6Qe6dVX0Yltkxp+3/Ld2LN0Q9shKqDZHc4g0ySfoSIuadpaf6tLvUxlu
         gzVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134072; x=1786738872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lxxJcfOvuS2DiwqIjrqP14riK8k/np3VBj64PdkOyLA=;
        b=q0/Zc/KLMN4Z2Jzc+WHvvfe4czscM9H+tishyscgMw8X1fk2cTTDNTYhMa+N3aYFZx
         q2hijawLPYnU+Fm/EI8OQ/AzHgN1tJGq0MbaM7rzHbjMnJQ7Kl4jf1JsOQPihjmN9L4M
         h+Yb4zac7UQa6qDi82hw6coVDmrXSs/YMMUcZB4kXv2mXZumz5sGpCE/0+4AaOe/TBRr
         zEtLaOEQJFIKMZQmTnZCODeE1oKVanNQNQ1ZNKIeOiCqvC2bpkcDT+tnkMZSeoSHtTeq
         1tnPgmnK/Dvf7BqpV4rsHZvxZsiGINcAAA3XZuAcbLOP1KRi8pBaEKHvepN/Yl4sA9Ry
         oozw==
X-Forwarded-Encrypted: i=1; AHgh+RrTwHlbXpj3rWkHiLZjZySEB3z33WXHo9v5PKLfvUTJ+L/YNGDZWBenGCnernE1GbolTtqMUqUA@vger.kernel.org
X-Gm-Message-State: AOJu0YzAgANUXmKDzu48Ycufk8JtlU8Qns0ocWzZ1sDPB9uqa/mfS1+7
	C21SR5wUMbY4KihJHMbfjyNAABkfJ1/DUqFdgv+xHEOOFKAiGCyYeI4+
X-Gm-Gg: AR+sD12IPfAMgELpbFQT5lkYYUx/83bG2UMv8SAPjQoTyOnaNiJT0b8yB3MSUTwgP67
	G1X6/enkVV/PpEQmhRJQMAtTzV+eRSZp5WMtYJ4qzu2A5kRoY2yTCvhCVzqZcuIQZvEiGdZBb4f
	Z8eVTdVVn2pQ8CHimypiaPehF/I2zB7PexvVD0i4hhdn2nJW7D8OAT4UbM4rvzJ/CXioYAIBUSd
	TzB/YPEtGZZmF+1m1uGvynLCflP/1p+yFzP4d4QgygPsXz0tlaycexOf+CU5d1jiCFP8/cazMXg
	WQzAtyWvuIU1JdPLzU0yI5k22FHbvwVqOEygPp7WmQ8LcusauR8F0WYe+2cENLwtfaWQFNosUMm
	IlSsRcUbW1Du4ZsM1ULdRFojG2ah28sx6zJs/RATCqqdMbC7YwP7JcutoDioxgjzAjSq5292aV2
	FN0ZQ0fhQE4w9/gvXI23qIBsDAz7QwWHdzdgPRlqvZFdi8dSaY1/UvoEYdUszqPrjE0Q7KPbRQy
	mGOgVhHZnArNgij/O8vyeO5qtldIA==
X-Received: by 2002:a05:6808:1a0b:b0:490:af61:8830 with SMTP id 5614622812f47-4afadf217ccmr13020013b6e.3.1786134070676;
        Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b1af63b441sm422380b6e.14.2026.08.07.13.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
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
Subject: [RFC PATCH v3 07/14] mm/memcontrol: Charge/uncharge tiered memory to mem_cgroup
Date: Fri,  7 Aug 2026 13:20:50 -0700
Message-ID: <20260807202059.2620949-8-joshua.hahnjy@gmail.com>
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

Memory cgroup limits isolate memory as a resource, but treat all
memory as equally valuable regardless of which memory tier it
resides in.

Account tiered memory usage in parallel with existing memory
accounting. Add an nid parameter to try_charge_memcg(); callers
resolve it to a tier slot with nid_tier_slot() and charge
memcg->tier[slot] alongside memcg->memory.

Uncharging reuses uncharge_gather to batch. Because the high-volume
free path reclaims per-node, a batch is normally single-tier; if a
folio in a different tier appears mid-batch, flush the accumulated
uncharge and start accumulating for the new tier. Folios on
different nodes within the same tier do not force a flush.

Also, mem_cgroup_migrate() and mem_cgroup_replace_folio() now move the
tier charge when the folio changes tier.

Currently this only tracks LRU folios (try_charge_memcg() callers
from charge_memcg()). The other two sites, obj_cgroup_charge_pages()
and mem_cgroup_sk_charge(), will be handled by a future series that
transitions enum memcg_stat_item to a per-lruvec counter
(enum node_stat_item).

The per-tier limits computed in the previous patch are not consulted
yet, this patch only acounts the memory. Enforcement will come in the
following patches.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 116 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 108 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c67d9d2c9ac7..f3714dfd85aa0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1561,6 +1561,15 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		*lru_size += nr_pages;
 }
 
+static struct page_counter *mem_cgroup_tier_counter(struct mem_cgroup *memcg,
+						    int slot)
+{
+	if (slot < 0)
+		return NULL;
+
+	return &memcg->tier[slot];
+}
+
 /**
  * mem_cgroup_margin - calculate chargeable space of a memory cgroup
  * @memcg: the memory cgroup
@@ -2645,13 +2654,32 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+static void mem_cgroup_uncharge_tier(struct mem_cgroup *memcg,
+				     int slot, unsigned int nr_pages)
+{
+	struct page_counter *tier_counter = mem_cgroup_tier_counter(memcg, slot);
+
+	if (tier_counter)
+		page_counter_uncharge(tier_counter, nr_pages);
+}
+
+static void mem_cgroup_charge_tier(struct mem_cgroup *memcg,
+				   int slot, unsigned int nr_pages)
+{
+	struct page_counter *tier_counter = mem_cgroup_tier_counter(memcg, slot);
+
+	if (tier_counter)
+		page_counter_charge(tier_counter, nr_pages);
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			    unsigned int nr_pages)
+			    unsigned int nr_pages, int nid)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
+	struct page_counter *tier_counter = NULL;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	unsigned int reclaim_options;
@@ -2659,10 +2687,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	int slot = -1;
+
+	if (mem_cgroup_tiered_limits()) {
+		slot = nid_tier_slot(nid);
+		tier_counter = mem_cgroup_tier_counter(memcg, slot);
+	}
 
 retry:
-	if (consume_stock(memcg, nr_pages))
+	if (consume_stock(memcg, nr_pages)) {
+		if (tier_counter)
+			page_counter_charge(tier_counter, nr_pages);
 		return 0;
+	}
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2677,8 +2714,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter)) {
+		if (tier_counter)
+			page_counter_charge(tier_counter, nr_pages);
 		goto done_restock;
+	}
 
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, batch);
@@ -2781,6 +2821,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * temporarily by force charging it.
 	 */
 	page_counter_charge(&memcg->memory, nr_pages);
+	if (tier_counter)
+		page_counter_charge(tier_counter, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
@@ -2852,7 +2894,7 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mem_cgroup_is_root(memcg))
 		return 0;
 
-	return try_charge_memcg(memcg, gfp_mask, nr_pages);
+	return try_charge_memcg(memcg, gfp_mask, nr_pages, NUMA_NO_NODE);
 }
 
 static void commit_charge(struct folio *folio, struct obj_cgroup *objcg)
@@ -3152,7 +3194,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge_memcg(memcg, gfp, nr_pages, NUMA_NO_NODE);
 	if (ret)
 		goto out;
 
@@ -5280,7 +5322,8 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	objcg = get_obj_cgroup_from_memcg(memcg);
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
-		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
+		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio),
+				       folio_nid(folio));
 	if (ret) {
 		obj_cgroup_put(objcg);
 		return ret;
@@ -5376,6 +5419,8 @@ struct uncharge_gather {
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
 	int nid;
+	int tier_slot;
+	unsigned long tier_nr;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5383,6 +5428,34 @@ static inline void uncharge_gather_clear(struct uncharge_gather *ug)
 	memset(ug, 0, sizeof(*ug));
 }
 
+static void flush_tier_charge(struct mem_cgroup *memcg,
+			      const struct uncharge_gather *ug)
+{
+	struct page_counter *tier_counter;
+
+	tier_counter = &memcg->tier[ug->tier_slot];
+	page_counter_uncharge(tier_counter, ug->tier_nr);
+}
+
+static void gather_tier_charge(struct uncharge_gather *ug, struct folio *folio,
+			       unsigned long nr_pages)
+{
+	int slot = nid_tier_slot(folio_nid(folio));
+
+	if (slot < 0)
+		return;
+
+	if (ug->tier_nr && slot != ug->tier_slot) {
+		rcu_read_lock();
+		flush_tier_charge(obj_cgroup_memcg(ug->objcg), ug);
+		rcu_read_unlock();
+		ug->tier_nr = 0;
+	}
+
+	ug->tier_slot = slot;
+	ug->tier_nr += nr_pages;
+}
+
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
 	struct mem_cgroup *memcg;
@@ -5395,6 +5468,8 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 			mod_memcg_state(memcg, MEMCG_KMEM, -ug->nr_kmem);
 			memcg1_account_kmem(memcg, -ug->nr_kmem);
 		}
+		if (ug->tier_nr)
+			flush_tier_charge(memcg, ug);
 		memcg1_oom_recover(memcg);
 	}
 
@@ -5440,8 +5515,11 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 		ug->nr_kmem += nr_pages;
 	} else {
 		/* LRU pages aren't accounted at the root level */
-		if (!obj_cgroup_is_root(objcg))
+		if (!obj_cgroup_is_root(objcg)) {
 			ug->nr_memory += nr_pages;
+			if (mem_cgroup_tiered_limits())
+				gather_tier_charge(ug, folio, nr_pages);
+		}
 		ug->pgpgout++;
 
 		WARN_ON_ONCE(folio_unqueue_deferred_split(folio));
@@ -5514,6 +5592,11 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	/* Force-charge the new page. The old one will be freed soon */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
+		if (mem_cgroup_tiered_limits()) {
+			int slot = nid_tier_slot(folio_nid(new));
+
+			mem_cgroup_charge_tier(memcg, slot, nr_pages);
+		}
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
@@ -5558,6 +5641,23 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
+	if (!obj_cgroup_is_root(objcg) && mem_cgroup_tiered_limits()) {
+		struct mem_cgroup *memcg;
+		unsigned long nr_pages = folio_nr_pages(old);
+		int old_slot, new_slot;
+
+		rcu_read_lock();
+		memcg = obj_cgroup_memcg(objcg);
+		old_slot = nid_tier_slot(folio_nid(old));
+		new_slot = nid_tier_slot(folio_nid(new));
+
+		if (old_slot != new_slot) {
+			mem_cgroup_uncharge_tier(memcg, old_slot, nr_pages);
+			mem_cgroup_charge_tier(memcg, new_slot, nr_pages);
+		}
+		rcu_read_unlock();
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
@@ -5633,7 +5733,7 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
-	if (try_charge_memcg(memcg, gfp_mask, nr_pages) == 0) {
+	if (try_charge_memcg(memcg, gfp_mask, nr_pages, NUMA_NO_NODE) == 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
 	}
-- 
2.53.0-Meta


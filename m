Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792526865;
	b=cxBENBr3v8YtJUw2rQAFOQl9ITvp9U+qHZ/A1ile/4psaHjBUCgwpG7uyo2gkczVGFtH
	 G4oLZF0ydjOJGpXuDBqZ+1IV6dgra/fwC70MhJOtPGksXbUgpKjOl4YkJnjOZn99UfvR9
	 pOASedH5xNtaii1x0SlNCEULqix3Let8zYxy+UrjZapqd+9uJV/BrHooVS9lG1vpcN3qm
	 BwvDrXXSbEjmkhtPx13gyQfW4GEQaoY4eghsc+4KVPiwl5UMau2n1UN40ZTdIcrMmYvrQ
	 +/fZ5Hqczjmu3ENhiLIjupPw7tcPuNXym00AY0ZiHo+iI2mOgtpKRnlIDRUPF9UWNZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792526865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QqajU5KZ2n/0LEgBFjxAuZSd6t0rfl3ggGAXjMiRHVc=;
	b=mr9+6PpZY0Jfh2NYys4SGW+vYAM80J6+7SQMOgjqDZ2pMWm/SMU+PFT9i0yO2k4/Appk
	 xsaWHRJDkQAOiOV1VWotoZFPjFIn5dNTWT9huTi53Xz7/x0E0yS9GLWjsaIZWYuERwucK
	 jToQMfkSJxYJCKIeUpQ/FkK7zjO/gDpy6LoOGxCLDfKq1xoKOtCh3xPX4l5h9UjXYU+FC
	 Qad/WKIEgKzMD4aMQZe2+Pd+cXQZ5uPcWWwzQmvMx9Ru6oKK5nkY+2rdi2TzUZkyStAhu
	 8/e0TVju4GNOMSxsqnEnOp4rvbsoQMJ+StLZHb7SVS3FZvBtDkySvEpQhJcP6Fp/8Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZgbfZ2rp;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B890D606A31A
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 20:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B890D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZgbfZ2rp
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5366ae57896so623471cf.3
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 13:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792526863; x=1793131663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QqajU5KZ2n/0LEgBFjxAuZSd6t0rfl3ggGAXjMiRHVc=;
        b=ZgbfZ2rpLjGCaY/mRXedc+15yT/UUwUQ1NiNdIumJso6TAESV2rYx52nWxMm1R95Wv
         S+5uEwawUC7PhuHFx+IpW9DMosRwUyQa4qFe+6wclYdu5Vwfx+F5OnNxhpi3e4cHWJ6r
         zwvhgAEk/qU6WaRDvTBNncQHv1at7gto++W3xBVtkz9SA4ILhTNVb0DzSN1/QJfCrIFP
         Jdaqil5OVR1EjDORMeLa36i/8sbK0F0Vdx/ZZRDxzGOFrMB8laE0TbC2M0cbjoS4nCSR
         Cn4cwzptvNvezDcLgcWfCdd88oF7anqeBVfuoksidN9kI9BIHo/PTrYcSkjp4puYz2On
         Humw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792526863; x=1793131663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QqajU5KZ2n/0LEgBFjxAuZSd6t0rfl3ggGAXjMiRHVc=;
        b=InagAc7WqFWxn+m+3rhNUcg7NGmW88WtFJgpdaik+prkoStXsxFNmZ0Pu9thaLBAE0
         MD5eBmBc1rxdPJ1/rI1Fbn/QnesL8/UOwB+TWE2cXNSlS3+R/Gg+vj6S4wzqo23Q9jX6
         Trzz8HVbrJMz+qNlsRXXOaHeXOw3cYtwBBpkfE1jblS3soVxc0DiDqhENTzF9Lapgn22
         pKD3xLEIGYjvPFBnEm0cLVwo3nn+0QD2pYXAm+RaMlcHUJTiOW2w97TA3GAocP8JByxi
         uNhC/ic2EBXhFpIsvn0h5qXaWjgvj7bkP6pFlO8sr4kZ522hfohu3HuOXU4DgDHgYvG9
         DDcQ==
X-Forwarded-Encrypted: i=1; AKwUvBydSMbTANVooCHky0xad5h/o25L9fVdyyprxJ5QTzMU2DZZ/I3fwM/51zkXff5kP+yrT78XBFg9@vger.kernel.org
X-Gm-Message-State: AFq9FYL8ziCr8kJ3wZyio2Sprtu7vSOFpoTx69zTe5BxYkbNuv9xtMNZ
	JtnNgXV1z7OPoW9+w8tK8yL4U8O9G0ntaJv1DyxHf0LUAMb3460H9Ca5tytmJg==
X-Gm-Gg: AYBFou0Wxa/5gQ0B5Gw8ZDuCHCdvkKxPiPv5uGWElq5Ubok29vaCY440NDr/VkfYDY3
	RwZAV6X3//KMgu5IyB2PcoCNJO0U6i73hIL6LqRuHCLHWiOFLedBDzlUOFO9FtVIO2Fe3btYqTZ
	u0zsMOKJTDWu947lvL0QkRsL062OSKst87ioR4S1TQ5TveKNC3yAGC5yDGTXaCuUiEZp/38ewIJ
	xkxVOkBDgyV21roiNGN+0RdH+9VWrvGWTh5gBTgEOu8Gr2+fGPuPSjyI1AtdHToi6QETKwK58Ip
	nNqjnZ8hu3iDP+FWPZnrCOad2S1dApl87O1jdg6VE5Qd/VxDLbU5zh+i+AYMJaABgX0YTtuAeFv
	DnhFhlBymHNU6zNAD+K1vCTJM0hNHv58E3ps9DkOe8IfeoJVY4KbdoEdyx/ssSV7eH8a5qoKGkS
	sZEUUxXQ5xDvMSxsBOLA8Hf1T2Fh7n7tPlDiYvPJAXEC6WUxTtfYV/V+tIDyonPq0Jlt9u9FSjZ
	3fYugcKVCgadHPnuR0mfbaU9yVuQKocOGuqHiERr/BJlwNH3oO0wahAoc9Dsw==
X-Received: by 2002:a05:622a:4c89:b0:536:66d7:8ccb with SMTP id d75a77b69052e-53666d79274mr119565871cf.51.1792526863594;
        Tue, 20 Oct 2026 13:07:43 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c27135sm6510396d6.34.2026.10.20.13.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:07:43 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1] memcg: fix cacheline contention between lruvec stat updates and LRU lists
Date: Tue, 20 Oct 2026 13:07:30 -0700
Message-ID: <20261020200730.250189-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
(such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These updates
are extremely frequent (eg these updates happen several times for every
page that's faulted in, freed, dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but on CPUs that do spatial
prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines are
fetched in 128-byte aligned pairs. Depending on where struct
mem_cgroup_per_node lands in its slab, that cacheline can be paired with
the cacheline holding the LRU list heads, and the lruvec->pgdat
cacheline with the one holding lru_lock.

When this happens, every stat update also pulls in a copy of the LRU
list heads and lru_lock cachelines, which are written to constantly by
other CPUs under the lru_lock. The stat update has to fetch them from
another CPU, which is unnecessary overhead since the stat update doesn't
use the LRU list heads or lru_lock at all. But even worse, the lru_lock
holder then has to invalidate those copies and wait for the
acknowledgements to come back before it can do its next write, which
makes the lru_lock critical section longer for everyone waiting on the
lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by not touching struct mem_cgroup_per_node on the main stat
update paths and instead going through the memcg. The memcg keeps an
array of pointers to the per-cpu lruvec stats of each node, pointed to
from the same cacheline as vmstats_percpu, which the update path already
reads. lruvec_stat_mod_folio() and mod_lruvec_kmem_state() pass the
memcg and node they already know instead of going through the lruvec and
fetching mem_cgroup_per_node->memcg and lruvec->pgdat. Both the memcg and
lruvec_stats_percpu reads need to go, since either one alone still pulls
in the cacheline.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.68M   (+20%)
  shmem, 80 threads  7.94M     8.81M   (+11%)
  anon,  20 threads  3.04M     3.13M   (+3%)
  anon,  80 threads  3.23M     3.30M   (+2%)

perf c2c showed HITMs on the read-mostly line from the stat update paths
dropped from ~2350 to ~10.

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
(bottom of page 62/800)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
An alternative would be to turn memcg->nodeinfo[] into an array of
{mem_cgroup_per_node, stats} pointer pairs, which saves one load, but
this would require quite a bit of churn (would need to modify every
nodeinfo call site). Happy to switch to this for v2 if this is
preferred.

 include/linux/memcontrol.h |  8 +++-
 mm/memcontrol.c            | 88 +++++++++++++++++---------------------
 2 files changed, 47 insertions(+), 49 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..dd054c9076d7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -88,7 +88,6 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 
-	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 	struct obj_cgroup __rcu		*objcg;
@@ -314,6 +313,13 @@ struct mem_cgroup {
 	__cacheline_group_begin_aligned(memcg_read_mostly);
 	/* Read on every stat update */
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+	/*
+	 * Per-CPU lruvec stats of each node, indexed by node id. Points to an
+	 * array after nodeinfo[] in the same allocation. Kept here instead of
+	 * in mem_cgroup_per_node, to avoid sharing a cacheline pair with the
+	 * very frequently written LRU lists.
+	 */
+	struct lruvec_stats_percpu __percpu **lruvec_stats_percpu;
 
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..203cae528e08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return x;
 }
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
@@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
-		struct mem_cgroup_per_node *child_pn, *parent_pn;
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(lruvec, idx);
 
-		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		__mod_memcg_lruvec_state(child_pn, idx, -value);
-		__mod_memcg_lruvec_state(parent_pn, idx, value);
+		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
+		__mod_memcg_lruvec_state(parent, nid, idx, value);
 	}
 }
 
@@ -990,10 +985,9 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 }
 #endif
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val)
 {
-	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
@@ -1006,7 +1000,7 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	this_cpu_add(memcg->vmstats_percpu->state[i], val);
 
 	/* Update lruvec */
-	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
+	this_cpu_add(memcg->lruvec_stats_percpu[nid]->state[i], val);
 
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val, cpu);
@@ -1015,21 +1009,23 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
+static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
+				 enum node_stat_item idx, int val)
+{
+	bool rcu_locked = false;
+
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
+	__mod_memcg_lruvec_state(memcg, nid, idx, val);
+	get_non_dying_memcg_end(rcu_locked);
+}
+
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val)
 {
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
-	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
-	pn = memcg->nodeinfo[pgdat->node_id];
-
-	__mod_memcg_lruvec_state(pn, idx, val);
-
-	get_non_dying_memcg_end(rcu_locked);
+	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
 }
 
 /**
@@ -1058,19 +1054,14 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
 
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
@@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_virt(p);
 
 	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
+	 * If we reparent the slab objects to the root memcg,
 	 * when we free the slab object, we need to update the per-memcg
 	 * vmstats to keep it correct for the root memcg.
 	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 
@@ -4192,7 +4179,6 @@ static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 	if (!pn)
 		return;
 
-	free_percpu(pn->lruvec_stats_percpu);
 	kfree(pn->lruvec_stats);
 	kfree(pn);
 }
@@ -4211,9 +4197,9 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	if (!pn->lruvec_stats)
 		goto fail;
 
-	pn->lruvec_stats_percpu = alloc_percpu_gfp(struct lruvec_stats_percpu,
-						   GFP_KERNEL_ACCOUNT);
-	if (!pn->lruvec_stats_percpu)
+	memcg->lruvec_stats_percpu[node] =
+		alloc_percpu_gfp(struct lruvec_stats_percpu, GFP_KERNEL_ACCOUNT);
+	if (!memcg->lruvec_stats_percpu[node])
 		goto fail;
 
 	INIT_LIST_HEAD(&pn->objcg_list);
@@ -4234,6 +4220,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+
+		free_percpu(memcg->lruvec_stats_percpu[node]);
 		if (!pn)
 			continue;
 
@@ -4265,6 +4253,8 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
+	/* see mem_cgroup_init() */
+	memcg->lruvec_stats_percpu = (void *)&memcg->nodeinfo[nr_node_ids];
 
 	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
@@ -4709,7 +4699,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		if (parent)
 			plstats = parent->nodeinfo[nid]->lruvec_stats;
 
-		lstatc = per_cpu_ptr(pn->lruvec_stats_percpu, cpu);
+		lstatc = per_cpu_ptr(memcg->lruvec_stats_percpu[nid], cpu);
 
 		ac = (struct aggregate_control) {
 			.aggregate = lstats->state,
@@ -5901,6 +5891,8 @@ static void __init memcg_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      vmstats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      lruvec_stats_percpu);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      vmstats);
 #ifdef CONFIG_ZSWAP
@@ -5920,8 +5912,6 @@ static void __init memcg_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, memcg);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
-				      memcg_pn_read_mostly, lruvec_stats_percpu);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, lruvec_stats);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
@@ -5977,7 +5967,9 @@ int __init mem_cgroup_init(void)
 			  drain_local_obj_stock);
 	}
 
-	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids);
+	/* nodeinfo[] followed by the array of per-node lruvec_stats_percpu */
+	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids) +
+		     nr_node_ids * sizeof(struct lruvec_stats_percpu __percpu *);
 	memcg_cachep = kmem_cache_create("mem_cgroup", memcg_size, 0,
 					 SLAB_PANIC | SLAB_HWCACHE_ALIGN, NULL);
 
-- 
2.52.0


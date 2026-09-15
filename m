Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCA036829D;
	Tue, 15 Sep 2026 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446357; cv=none; b=YpX16wH4+xvCKbSC974eXpjZ0YymTw1UmlcGfi9NFR5LdBX7+35vv6UfD9nBWGlrSEk3ZeVHflMpp/hDnFsxenFKLQ/SEg7XQpFU089lpscXjvFbmCVqG+QoMBomgba1m70jJh9VAlLuNDGkHYbghbw72USnLvsCtwBf1DkIffA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446357; c=relaxed/simple;
	bh=/Trq8QHy2PF98oukvQr1TF/haOYHolHC835pmqluVm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgVmomdAk2DNVyjcFewZVicWxzDEh4RLF/kz2q85k+6Wr0tdqbugxGuVCbS0+Lsyb9+9984y8k3dB6rI07rEAxCcsfPAsSjJ+KZIe+VP2RdqG6cZD/TIkrJM83DR/PdMxNYdnqbI6b9tEzeUTBB2Qux+g4jBlQ83Wy6nboraDik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AKVVrd5G; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AKVVrd5G"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789446352; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qRccphNs3O5ad7NrqVtsKfZvxe0bhOXzZTVZa7T6UFc=;
	b=AKVVrd5GbgfcX9mKgqP58gY/a+OrD9E6HHoBSW+VRxp04iq9dxl0YZy9542j7RCfqJua+JJ2eip9+7/6QTlFkJzENKS5ReDyxbOS9YygKVszjwwpKnCohCBQGGa1Vxl0MmSCvwYHa+JwaGmEWaAsrxWQtHFL7PhhMBIsrr2Y2Xk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XB027CR_1789446349;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XB027CR_1789446349 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 12:25:50 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	xlpang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	chris@chrisdown.name,
	kasong@tencent.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2 1/1] mm: memcg: don't hand out large folios above memory.high
Date: Tue, 15 Sep 2026 12:25:46 +0800
Message-ID: <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memory.high is enforced on return to userspace, and synchronously in
try_charge_memcg() for large overcharges, but only when the charge gfp
allows blocking.  A populate loop - mlock(), MADV_POPULATE_*, any
GUP-driven population - never returns to userspace, and large folios are
charged with the THP allocation gfp, which does not allow blocking under
the default defrag=madvise without MADV_HUGEPAGE, nor under defrag=defer.
So neither runs: usage grows from memory.high straight up to memory.max
with no reclaim and no penalty sleep.

mlock(200M) in a cgroup with memory.high=30M and memory.max=140M.  Of the
110M between high and max, the burst consumed:

  4K pages                       3M in 5s, then still throttled
  THP, defrag=always             6M in 5s, then still throttled
  THP, defrag=madvise          110M in 13ms, then OOM killed at 16ms
  THP, defrag=madvise, patched   3M in 5s, then still throttled

The defrag=madvise run raised no memory.high event at all - the throttling
machinery never ran once - and nothing in userspace, oomd or a Kubernetes
eviction manager, reacts inside 16ms.  The gfp it was charged with is not a
statement about sleeping either: it describes allocation policy, a THP is
not worth direct compaction, while the order-0 fallback of the very same
fault charges with GFP_KERNEL and sleeps just fine.  memory.high should not
stop working because of the order of the folios a workload happens to fault
in.

Fix this where the order is chosen: above memory.high, refuse a large folio
whose charge cannot be throttled - in the anon THP fault paths and for
large folio swapin - and let the fault fall back to order-0.  That charge
blocks, so try_charge_memcg() reclaims and throttles it as before, and the
refusal happens before the allocation, so the fault path only gets shorter.
mlock() above is the worst case since the pages are unevictable; where
reclaim can keep up, usage simply stays at memory.high.

A charge that may block is already throttled, so the check is gated on
gfpflags_allow_blocking(): defrag=always and MADV_HUGEPAGE VMAs are
unaffected.  Other VMAs get large folios again once usage is back below
memory.high, which is the intent - above it the cgroup is meant to be under
reclaim pressure.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h | 33 ++++++++++++++++++++++
 mm/huge_memory.c           | 12 ++++++++
 mm/memcontrol.c            | 56 ++++++++++++++++++++++++++++++++++++++
 mm/memory.c                |  7 +++++
 mm/swap_state.c            | 16 ++++++++++-
 5 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..defef0d3d710 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -941,6 +941,33 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
+bool __mem_cgroup_large_folio_over_high(struct mm_struct *mm, gfp_t gfp);
+
+/**
+ * mem_cgroup_large_folio_over_high - would a large folio escape memory.high?
+ * @mm: mm the folio would be charged against, may be NULL
+ * @gfp: gfp mask the folio would be allocated and charged with
+ *
+ * See __mem_cgroup_large_folio_over_high().
+ *
+ * The task's over-high debt is more than a fast path here, it also scopes
+ * the check to the case that is broken.  The debt is settled and cleared on
+ * every return to userspace, so a task faulting large folios from a
+ * userspace loop always finds it zero and keeps getting them - memory.high
+ * is enforced for it on the way out.  Only a loop that stays in the kernel,
+ * where nothing throttles at all, accrues debt and reaches the counters.
+ *
+ * Return: %true if the caller should fall back to a smaller order.
+ */
+static inline bool mem_cgroup_large_folio_over_high(struct mm_struct *mm,
+						    gfp_t gfp)
+{
+	if (likely(!current->memcg_nr_pages_over_high))
+		return false;
+
+	return __mem_cgroup_large_folio_over_high(mm, gfp);
+}
+
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
@@ -1390,6 +1417,12 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 }
 
+static inline bool mem_cgroup_large_folio_over_high(struct mm_struct *mm,
+						    gfp_t gfp)
+{
+	return false;
+}
+
 static inline struct mem_cgroup *mem_cgroup_get_oom_group(
 	struct task_struct *victim, struct mem_cgroup *oom_domain)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 30b7c63b0e35..9247c36da64a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1355,6 +1355,18 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
+	/*
+	 * A THP charged with a gfp that cannot block escapes the memory.high
+	 * throttling in try_charge_memcg().  Don't hand out one while the
+	 * cgroup is already above memory.high: the order-0 fallback is charged
+	 * with a blocking gfp and throttles as documented.
+	 */
+	if (mem_cgroup_large_folio_over_high(vma->vm_mm, gfp)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		return NULL;
+	}
+
 	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
 
 	if (unlikely(!folio)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..dd7a62c3dacb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2587,6 +2587,62 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
 }
 
+/**
+ * __mem_cgroup_large_folio_over_high - would a large folio escape memory.high?
+ * @mm: mm the folio would be charged against, may be NULL
+ * @gfp: gfp mask the folio would be allocated and charged with
+ *
+ * memory.high is enforced on return to userspace, or synchronously in
+ * try_charge_memcg() - but the synchronous path is gated on the charge gfp
+ * allowing blocking.  Large folios are charged with the THP allocation gfp,
+ * which does not allow blocking unless the allocation policy asks for direct
+ * compaction, so those charges escape throttling entirely: a fault loop that
+ * does not return to userspace inbetween - the populate loop of mlock() or
+ * MADV_POPULATE_*, any GUP-driven population - can grow usage from
+ * memory.high all the way up to memory.max with no reclaim and no delay.
+ *
+ * Above memory.high the cgroup is supposed to be under reclaim pressure, so
+ * refuse the large folio instead.  Callers fall back to order-0, which is
+ * charged with a blocking gfp and throttled as documented.
+ *
+ * This is a lockless snapshot of the counters; a stale result only costs one
+ * large folio either way.
+ *
+ * Callers should use mem_cgroup_large_folio_over_high(), which keeps the
+ * counter lookup off the fault path unless the task has actually charged
+ * above memory.high before.
+ *
+ * Return: %true if the caller should fall back to a smaller order.
+ */
+bool __mem_cgroup_large_folio_over_high(struct mm_struct *mm, gfp_t gfp)
+{
+	struct mem_cgroup *memcg, *iter;
+	bool over_high = false;
+
+	/*
+	 * A charge that can block is throttled by try_charge_memcg() itself,
+	 * there is no reason to give up the large folio for it.
+	 */
+	if (gfpflags_allow_blocking(gfp))
+		return false;
+
+	memcg = get_mem_cgroup_from_mm(mm);
+	if (!memcg)
+		return false;
+
+	for (iter = memcg; iter; iter = parent_mem_cgroup(iter)) {
+		if (page_counter_read(&iter->memory) >
+		    READ_ONCE(iter->memory.high)) {
+			over_high = true;
+			break;
+		}
+	}
+
+	mem_cgroup_put(memcg);
+
+	return over_high;
+}
+
 /*
  * Reclaims memory over the high limit. Called directly from
  * try_charge() (context permitting), as well as from the userland
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..b28fccc86216 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5321,6 +5321,13 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
+
+	/* Same reasoning as in vma_alloc_anon_folio_pmd(). */
+	if (mem_cgroup_large_folio_over_high(vma->vm_mm, gfp)) {
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		goto fallback;
+	}
+
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 625c185a1ca4..a235c9aecaf1 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -440,9 +440,23 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	 * Limit THP gfp. The limitation is a no-op for typical
 	 * GFP_HIGHUSER_MOVABLE but matters for shmem.
 	 */
-	if (order)
+	if (order) {
 		gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 
+		/*
+		 * This gfp may not allow blocking, in which case the charge
+		 * below escapes the memory.high throttling in
+		 * try_charge_memcg().  Above memory.high, have the caller
+		 * retry with a smaller order, down to order-0, which is
+		 * charged with the caller's blocking gfp and throttled as
+		 * documented.  Only fault context is throttled here; the
+		 * readahead and zswap writeback callers have no @vmf and are
+		 * not the ones to hold back.
+		 */
+		if (vmf && mem_cgroup_large_folio_over_high(vma->vm_mm, gfp))
+			return ERR_PTR(-ENOMEM);
+	}
+
 	if (mpol || !vmf) {
 		folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
 	} else {
-- 
2.43.7


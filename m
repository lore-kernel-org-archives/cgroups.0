Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234A9428828
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783960498; cv=none; b=mtZFBT9lnJzjXWWVoVthTqCeBdLBxPZ/6tbUhUVxpaWqSBGEPCXtYYKFA0hxoZoV45PJcYley6ZxR9qxxT2aCgMw8ijBRdylZ83vvA+B7yLFc9ARvL5lLimXGkV6qHbMlLC6u1Px45VbBMLTv0UYyeTDHLVLBxZ41iPaplbh0zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783960498; c=relaxed/simple;
	bh=a8amKKZQdk3rvlf/uNFBsaL6p3EYVk36JgH0/POR24A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC/IH6MdQJjbCeJniorIL4q4qmdqK43RtvivtGe52GpHp/bJ0EqWl1ZtwC3H2UgUy6f6yrENTuMcZQtKBw/bjb4LlWm3NeNkNgeSp4GAEL6G0NYHrNn/evrwb32aTbB4jAtSJjGDTsHvEln0z2snloXs0fgKERb9Di5Nl/CxNlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GZZhPMMG; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GZZhPMMG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783960494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQqWDk7T6a/RKrLzEIPkgohpPGLwCcrs/s+nPh+3mLg=;
	b=GZZhPMMG+PoZWuQyTJm1Ciu9Wp1K7Yf1opm9huRmJYIAv9HpvrJmcAkhxcmAjRVWmwIr68
	CayjRenm0iCU2tW5cfpXtQkz+v1Eg/tuU1QDCYv1eqlqrCDDhp9CAV4K9KbnCkIEy3qoej
	gEt+6pC583S0cEvnjNUnSJCfrA2f6O4=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
Date: Mon, 13 Jul 2026 09:34:16 -0700
Message-ID: <20260713163443.3562378-2-usama.arif@linux.dev>
In-Reply-To: <20260713163443.3562378-1-usama.arif@linux.dev>
References: <20260713163443.3562378-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

lruvec_page_state(), node_page_state(), and global_node_page_state()
all clamp negative reads to zero on CONFIG_SMP so that a transient
per-CPU delta skew presents as zero pages rather than
as a garbage unsigned value. This is the right behaviour for
non-monotonic page-count readers.

It is however incorrect for callers that snapshot a monotonically-
incremented event counter and compute a delta from two samples.
Once the underlying signed long wraps past LONG_MAX, the clamped read
drops to zero while the previously-recorded snapshot still holds the
pre-wrap value; the unsigned subtraction then underflows into a
~2^31 spurious delta for 32-bit architecture and corrupts the
caller's accumulator.

Add non-clamping siblings that return the underlying state value
cast to unsigned long:

  global_node_page_state_monotonic()
  node_page_state_monotonic()
  lruvec_page_state_monotonic()

With both samples read via the _monotonic variant, unsigned modular
subtraction stays correct across a signed-long wraparound as long
as the true growth between two samples fits in unsigned long
(< 2^32 on 32-bit, < 2^64 on 64-bit); the 32-bit bound is the
practically-reachable one that motivates this helper.

The variants are only safe for monotonically-incremented counters.
Non-monotonic page-count readers must keep using the existing
clamped helpers so transient negative reads still present as zero.

This is a prerequisite for the following patch which
replaces the producer-side anon_cost/file_cost accumulators with a
read-side accumulator in prepare_scan_control() that samples
monotonic per-LRU vmstat counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*,
WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
the unsigned modular delta into a per-lruvec cost_accum[].

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/memcontrol.h |  8 ++++++++
 include/linux/vmstat.h     | 16 ++++++++++++++++
 mm/memcontrol.c            | 36 ++++++++++++++++++++++++++++++++++++
 mm/vmstat.c                | 11 +++++++++++
 4 files changed, 71 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..b40bc4f6fe4a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -931,6 +931,8 @@ unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
+unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+					  enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
@@ -1378,6 +1380,12 @@ static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+							enum node_stat_item idx)
+{
+	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+}
+
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 						    enum node_stat_item idx)
 {
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..fb8c76289e02 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -194,6 +194,19 @@ unsigned long global_node_page_state_pages(enum node_stat_item item)
 	return x;
 }
 
+/*
+ * Non-clamping variant of global_node_page_state() intended for callers that
+ * snapshot a monotonically-incremented counter and subtract two samples.
+ * Returns the raw wrapping value so that unsigned modular subtraction stays
+ * correct across a signed-long overflow (a real hazard on 32-bit) that the
+ * clamp in global_node_page_state() would otherwise turn into a huge spurious
+ * delta. Do NOT use for non-monotonic page-count reads.
+ */
+static inline unsigned long global_node_page_state_monotonic(enum node_stat_item item)
+{
+	return (unsigned long)atomic_long_read(&vm_node_stat[item]);
+}
+
 static inline unsigned long global_node_page_state(enum node_stat_item item)
 {
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
@@ -259,11 +272,14 @@ extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
 extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
 					   enum node_stat_item item);
+extern unsigned long node_page_state_monotonic(struct pglist_data *pgdat,
+					       enum node_stat_item item);
 extern void fold_vm_numa_events(void);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
 #define node_page_state_pages(node, item) global_node_page_state_pages(item)
+#define node_page_state_monotonic(node, item) global_node_page_state_monotonic(item)
 static inline void fold_vm_numa_events(void)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..b4a357c5f7e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -502,6 +502,42 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
 	return x;
 }
 
+/**
+ * lruvec_page_state_monotonic - non-clamping lruvec stat read for delta sampling
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * Returns the raw state[idx] value cast to unsigned long, skipping the
+ * clamp-negative-to-zero step in lruvec_page_state(). Intended for callers
+ * that snapshot a monotonically-incremented counter and subtract two
+ * samples: unsigned modular arithmetic then yields the correct delta across
+ * a signed-long wraparound (a real hazard on 32-bit) that the clamp would
+ * otherwise turn into a huge spurious delta.
+ *
+ * Do NOT use for non-monotonic page-count reads where a transient negative
+ * reading from per-CPU delta skew must present as zero.
+ *
+ * XXX: This helper (and its node/global peers) exists because we place
+ * monotonically-incremented event counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*)
+ * into enum node_stat_item.
+ */
+unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+					  enum node_stat_item idx)
+{
+	struct mem_cgroup_per_node *pn;
+	int i;
+
+	if (mem_cgroup_disabled())
+		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+
+	i = memcg_stats_index(idx);
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return 0;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
+}
+
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..c4364f0eb08a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1024,6 +1024,17 @@ unsigned long node_page_state(struct pglist_data *pgdat,
 
 	return node_page_state_pages(pgdat, item);
 }
+
+/*
+ * Non-clamping variant of node_page_state() intended for callers that
+ * snapshot a monotonically-incremented counter and subtract two samples.
+ * See global_node_page_state_monotonic() for the rationale.
+ */
+unsigned long node_page_state_monotonic(struct pglist_data *pgdat,
+					enum node_stat_item item)
+{
+	return (unsigned long)atomic_long_read(&pgdat->vm_stat[item]);
+}
 #endif
 
 /*
-- 
2.53.0-Meta


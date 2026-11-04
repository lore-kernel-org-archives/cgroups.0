Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797758;
	b=jNTLcRWcv2CEC4B7AoU7ELgddwExRB6SAjQ7bxvHbfo5lZXnJ4NsuyWcCXD5y9tBunDu
	 X+PQ0q1TYQXWE0EJBihTmV/6c0RhST+vLGFGn9UHbghJ1Gz+tqGyug7cYbbSY/reyWbob
	 o/feZHD0r+M1tT5XOLTOfj7sKIQhOZwtDnfWKnfjexkSIO8kg6o6X4ojZi4SnimDmcIzk
	 9KBgI/EhNGtkuocortEKzv+sJjCyWFS6e6KPjaQhEDA5cEHslfbaO97h/G0MxN34lmtnt
	 NoGVnyosz2KVFxcORQFpETk6fvntAWDHP7lW76WEPcV40/fZMArmmBltlUOFPtZ+3ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797758;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Zvfr2SUwypM35r5h1eYbTjTbvmwGPZokIKsFS6JGOKg=;
	b=RTecAVKm3BMYYiNWww+mZad8drG9vT348f+loXrTBB+jI2BcRpEADiL7QNiDlBWFPJe/
	 HIEAoIcPGGggz9NfQl84hAgnVruG0CbtCrjVtM4l1mglj4IUfqy6qhg6YQzgy2LisYoUY
	 fK7kuLf8hGjMnjQ2dx0zhIdINR6lRD7bfyOSBGp4csytnqVmm6Efqjch4nbHBAsL48Cq5
	 yoSCHG9n+pYqzcXLWRjXUUu/CpXtnJSiCd2rGTXzxRpWEzutalLKJSCiLv+lSOrw0rrku
	 ry2oRVowH3EkQj6DkJh3YgWn+3AdDiC2/OuTVIUZu4bgyoSxzAamw7TyoxUXuk34pFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DT7hAhra;
	arc=none smtp.remote-ip=91.218.175.153
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA6606A32E
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ADA6606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DT7hAhra
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LgDYTWwrf+1eTwVnRyGsWmj/PoANDpmtbGlSmOVMAl8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797755; v=1; x=1794402555;
 b=DT7hAhraYTsTXq8lVhjY88R9tFOjCDXTn78NheROyC5LC0mnBScZBwDhWDAh+1LvoNikPNRp
 aW6aGyRUw8EX40On+p818Hqn5T+SysheozMQzecc2+4JmDCQwTISh8sUzN27I8jLi8BXz+py2r+
 vWJGYFuCytyQIUPc8cP3XVDs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d450e0a6301e7072;
	Wed, 04 Nov 2026 13:09:15 +0000
X-Mizu-Trace-ID: d450e0a6301e7072
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 3/7] mm/vmscan: move struct scan_control to a dedicated header
Date: Wed,  4 Nov 2026 21:08:13 +0800
Message-Id: <20261104130817.849089-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

The definition of struct scan_control has lived inline at the top of
mm/vmscan.c. Move it out to a new mm/vmscan.h so the reclaim-internal
state can be referenced from other reclaim translation units without
duplicating the definition.

The header uses an ordinary include guard and pulls in only what the
struct needs (nodemask_t, gfp_t and struct reclaim_state).

mm/trace_vmscan.h includes the new header directly so that any
translation unit pulling in the trace events (mm/vmscan.c, mm/shrinker.c)
sees the full definition of struct scan_control regardless of include
order.

No functional change.

Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS       |   2 +
 mm/trace_vmscan.h |   2 +
 mm/vmscan.c       | 108 ------------------------------------------
 mm/vmscan.h       | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 108 deletions(-)
 create mode 100644 mm/vmscan.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 828e81ea671b..82823440247d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17643,6 +17643,7 @@ F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
@@ -17807,6 +17808,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index ad90f0e9bf2e..3917e1b62dfa 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -11,6 +11,8 @@
 #include <linux/memcontrol.h>
 #include <trace/events/mmflags.h>
 
+#include "vmscan.h"
+
 #define RECLAIM_WB_ANON		0x0001u
 #define RECLAIM_WB_FILE		0x0002u
 #define RECLAIM_WB_MIXED	0x0010u
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35d4e912660f..d9c3c5d020ed 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -73,114 +73,6 @@
 #define CREATE_TRACE_POINTS
 #include "trace_vmscan.h"
 
-struct scan_control {
-	/* How many pages shrink_list() should reclaim */
-	unsigned long nr_to_reclaim;
-
-	/*
-	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
-	 * are scanned.
-	 */
-	const nodemask_t *nodemask;
-
-	/*
-	 * The memory cgroup that hit its limit and as a result is the
-	 * primary target of this reclaim invocation.
-	 */
-	struct mem_cgroup *target_mem_cgroup;
-
-	/*
-	 * Scan pressure balancing between anon and file LRUs
-	 */
-	unsigned long	anon_cost;
-	unsigned long	file_cost;
-
-	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
-	int *proactive_swappiness;
-
-	/* Can active folios be deactivated as part of reclaim? */
-#define DEACTIVATE_ANON 1
-#define DEACTIVATE_FILE 2
-	unsigned int may_deactivate:2;
-	unsigned int force_deactivate:1;
-	unsigned int skipped_deactivate:1;
-
-	/* zone_reclaim_mode, boost reclaim */
-	unsigned int may_writepage:1;
-
-	/* zone_reclaim_mode */
-	unsigned int may_unmap:1;
-
-	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
-	unsigned int may_swap:1;
-
-	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
-	unsigned int no_cache_trim_mode:1;
-
-	/* Has cache_trim_mode failed at least once? */
-	unsigned int cache_trim_mode_failed:1;
-
-	/* Proactive reclaim invoked by userspace */
-	unsigned int proactive:1;
-
-	/*
-	 * Cgroup memory below memory.low is protected as long as we
-	 * don't threaten to OOM. If any cgroup is reclaimed at
-	 * reduced force or passed over entirely due to its memory.low
-	 * setting (memcg_low_skipped), and nothing is reclaimed as a
-	 * result, then go back for one more cycle that reclaims the protected
-	 * memory (memcg_low_reclaim) to avert OOM.
-	 */
-	unsigned int memcg_low_reclaim:1;
-	unsigned int memcg_low_skipped:1;
-
-	/* Shared cgroup tree walk failed, rescan the whole tree */
-	unsigned int memcg_full_walk:1;
-
-	unsigned int hibernation_mode:1;
-
-	/* One of the zones is ready for compaction */
-	unsigned int compaction_ready:1;
-
-	/* There is easily reclaimable cold cache in the current node */
-	unsigned int cache_trim_mode:1;
-
-	/* The file folios on the current node are dangerously low */
-	unsigned int file_is_tiny:1;
-
-	/* Always discard instead of demoting to lower tier memory */
-	unsigned int no_demotion:1;
-
-	/* Allocation order */
-	s8 order;
-
-	/* Scan (total_size >> priority) pages at once */
-	s8 priority;
-
-	/* The highest zone to isolate folios for reclaim from */
-	s8 reclaim_idx;
-
-	/* This context's GFP mask */
-	gfp_t gfp_mask;
-
-	/* Incremented by the number of inactive pages that were scanned */
-	unsigned long nr_scanned;
-
-	/* Number of pages freed so far during a call to shrink_zones() */
-	unsigned long nr_reclaimed;
-
-	struct {
-		unsigned int dirty;
-		unsigned int congested;
-		unsigned int writeback;
-		unsigned int immediate;
-		unsigned int taken;
-	} nr;
-
-	/* for recording the reclaimed slab by now */
-	struct reclaim_state reclaim_state;
-};
-
 #ifdef ARCH_HAS_PREFETCHW
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
diff --git a/mm/vmscan.h b/mm/vmscan.h
new file mode 100644
index 000000000000..adb22e80d760
--- /dev/null
+++ b/mm/vmscan.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_VMSCAN_H
+#define _MM_VMSCAN_H
+
+#include <linux/gfp_types.h>
+#include <linux/nodemask.h>
+#include <linux/swap.h>
+#include <linux/types.h>
+
+struct scan_control {
+	/* How many pages shrink_list() should reclaim */
+	unsigned long nr_to_reclaim;
+
+	/*
+	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
+	 * are scanned.
+	 */
+	const nodemask_t *nodemask;
+
+	/*
+	 * The memory cgroup that hit its limit and as a result is the
+	 * primary target of this reclaim invocation.
+	 */
+	struct mem_cgroup *target_mem_cgroup;
+
+	/*
+	 * Scan pressure balancing between anon and file LRUs
+	 */
+	unsigned long	anon_cost;
+	unsigned long	file_cost;
+
+	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
+	int *proactive_swappiness;
+
+	/* Can active folios be deactivated as part of reclaim? */
+#define DEACTIVATE_ANON 1
+#define DEACTIVATE_FILE 2
+	unsigned int may_deactivate:2;
+	unsigned int force_deactivate:1;
+	unsigned int skipped_deactivate:1;
+
+	/* zone_reclaim_mode, boost reclaim */
+	unsigned int may_writepage:1;
+
+	/* zone_reclaim_mode */
+	unsigned int may_unmap:1;
+
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
+	unsigned int may_swap:1;
+
+	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
+	unsigned int no_cache_trim_mode:1;
+
+	/* Has cache_trim_mode failed at least once? */
+	unsigned int cache_trim_mode_failed:1;
+
+	/* Proactive reclaim invoked by userspace */
+	unsigned int proactive:1;
+
+	/*
+	 * Cgroup memory below memory.low is protected as long as we
+	 * don't threaten to OOM. If any cgroup is reclaimed at
+	 * reduced force or passed over entirely due to its memory.low
+	 * setting (memcg_low_skipped), and nothing is reclaimed as a
+	 * result, then go back for one more cycle that reclaims the protected
+	 * memory (memcg_low_reclaim) to avert OOM.
+	 */
+	unsigned int memcg_low_reclaim:1;
+	unsigned int memcg_low_skipped:1;
+
+	/* Shared cgroup tree walk failed, rescan the whole tree */
+	unsigned int memcg_full_walk:1;
+
+	unsigned int hibernation_mode:1;
+
+	/* One of the zones is ready for compaction */
+	unsigned int compaction_ready:1;
+
+	/* There is easily reclaimable cold cache in the current node */
+	unsigned int cache_trim_mode:1;
+
+	/* The file folios on the current node are dangerously low */
+	unsigned int file_is_tiny:1;
+
+	/* Always discard instead of demoting to lower tier memory */
+	unsigned int no_demotion:1;
+
+	/* Allocation order */
+	s8 order;
+
+	/* Scan (total_size >> priority) pages at once */
+	s8 priority;
+
+	/* The highest zone to isolate folios for reclaim from */
+	s8 reclaim_idx;
+
+	/* This context's GFP mask */
+	gfp_t gfp_mask;
+
+	/* Incremented by the number of inactive pages that were scanned */
+	unsigned long nr_scanned;
+
+	/* Number of pages freed so far during a call to shrink_zones() */
+	unsigned long nr_reclaimed;
+
+	struct {
+		unsigned int dirty;
+		unsigned int congested;
+		unsigned int writeback;
+		unsigned int immediate;
+		unsigned int taken;
+	} nr;
+
+	/* for recording the reclaimed slab by now */
+	struct reclaim_state reclaim_state;
+};
+
+#endif /* _MM_VMSCAN_H */
-- 
2.34.1


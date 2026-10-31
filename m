Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.140
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793437293;
	b=CE9y21gnoYCWbixGHtHy94z44WyyX+ux37UKEaE3mtDUGwtjVrOxU1lkid2RNLWEQwG9
	 qyjJjmtGaE1TXSqCv+SYVt9XwvVl1j5EwdOsyVxk0eBAtAg/Q7JN4Lw5f8HWuijaXyxc7
	 Hmn5TODGoUSMwzzSNn040dAmBxJtZ8HW6Ipoau9UXcEtMAD1pVNmzdnU0kqvfccR3sfdh
	 StRGu0K3E6jwW+f/FvHab8pKu4cBjqoZxt/XeokakCj0k9HFvpKgxQkFWd8oDntwy1znY
	 Us+FqKzrjIKZQI4635+TLbBM2ZiBPPJfr/ZTqsruvZ44/6htRW7pkdqchQiLBap9njg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793437293;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fiiKrBCpHUYOHtqd9WqUWhp2nvmCUlooq/peEHqO4Go=;
	b=rbZPCfy6DZ3Q7FhZRUbGJGm3I7aVofsQSqjhkgIhUH3qwn5o6HSZMGzXYtTgwvdEKwY6
	 4/G9AeQ4YXsx0zc59Fe/eNjsIIdWVKvkKRhTxuGlCeQy7P3b+TaM4TexIAYIfFIGFOJtm
	 zX0UvwenULEBiQgMl7FO1xR2K/FDwkq4t7c+aDT9fxXWy5RyLqunM9oU8CwPnnhFPN+Ix
	 LnSGgkbVom5h3K1cwF159CQ5WrAeaoUgLlIOg6g9IVE5Qc6eEC1Xi+ZfmNUZUOyCambpU
	 mlsyr/ppSlNR8A2mOMQvsxy/mjolk89j1mVp39Po/bOlGVp0Jkl23WR/EkYR9qdOS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tozsAYZQ;
	arc=none smtp.remote-ip=91.218.175.140
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4362606A31C
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 09:01:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4362606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tozsAYZQ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ef7uDXCWASIprI+9tULZE2dA/Lb+54sHHrZJ8AHqF0o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437290; v=1; x=1794042090;
 b=tozsAYZQlWfc8MmPR1dbsAqTWJhTZ8NmRXZXD4xx7CZEfONDAItng6jipxhZBC6xc7OJpUyA
 ZF6A88vaAecXXnZtEV4UAmi7NNuw461Ul7c6Ymi2OFx0fF2127gBOlkwNQ/PvYO2kAW0YI9R6GJ
 CFnDhIeg20qynC3EinLYnfP0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d33284fd3119d6cd;
	Sat, 31 Oct 2026 09:01:29 +0000
X-Mizu-Trace-ID: d33284fd3119d6cd
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 3/6] mm/vmscan: move struct scan_control to a dedicated header
Date: Sat, 31 Oct 2026 17:00:38 +0800
Message-ID: <20261031090041.58574-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
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

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS       |   2 +
 mm/trace_vmscan.h |   2 +
 mm/vmscan.c       | 108 ------------------------------------------
 mm/vmscan.h       | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 108 deletions(-)
 create mode 100644 mm/vmscan.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ad01107fa05..724791bb779f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17655,6 +17655,7 @@ F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
@@ -17805,6 +17806,7 @@ L:	linux-mm@kvack.org
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
index 79d2d614afd0..49677464fc9a 100644
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
2.43.0


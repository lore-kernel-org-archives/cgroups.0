Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C65333939A
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 03:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405652; cv=none; b=FjDS96XW8J4K1tRXGhOdnWZv2fS1j6r011Qiimva/dASULYvnPCaMSdxXG7qQLvlUDdbU49twH6sR9P7jsMX8jKCNhvAiPIv/y2rzJhO63Wf/SySGoNJQ+9BDY7vcPFRKJNYcncZmD2BFWwLdOCwQzWAHDxOb0MRP75RJFxPv00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405652; c=relaxed/simple;
	bh=gV2iAlnyroIqHvYCikGMSiDdJzetMM/dbS3MYN3DzYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pRUhN1dw4UE+4Q5HrD8okX0dBmzd55qie6ZGD57KmQ/zjf94ZdJcPAp4pVPdPJsYTD5sYscA+y4xVvGtAAP4iNWqlfQxQR227+m6hmgAryzhtm5/XTNgHOGGPvMuJXx5R0aY3SpDEExf4SM2HGtylQI/VlL4aaoorUDyrZIbcXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j76dF2sJ; arc=none smtp.client-ip=95.215.58.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j76dF2sJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gV2iAlnyroIqHvYCikGMSiDdJzetMM/dbS3MYN3DzYc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788405648; v=1; x=1789010448;
 b=j76dF2sJAXKSqCq3t+oFQZwG7Vrk+zPxk+JPRNrYlblKR2bv4gZ4O223kIWkUAVr+wUNIu+9
 niu7mT+ZCGCAMhN3gtaD682/95Ms7OjFpdTAClFH2TZvz4aR7BQB0uuV9hWXDinGdHEvAiZAg3B
 Vg3aIyEn0a0S8pOBPU8bNRC0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0f653951e6c46c55;
	Thu, 03 Sep 2026 03:20:48 +0000
X-Mizu-Trace-ID: 0f653951e6c46c55
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Thu,  3 Sep 2026 11:19:52 +0800
Message-Id: <20260903031952.1120321-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260903031952.1120321-1-ridong.chen@linux.dev>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

For MGLRU, memory.min/low is not honored during global proactive reclaim
(writing to the root memory.reclaim) and global direct reclaim, because
these paths shrink memcgs using stale or effective protection (emin/elow).
It can be reproduced as follows:

  # echo 7 > /sys/kernel/mm/lru_gen/enabled
  # cd /sys/fs/cgroup
  # mkdir -p a/b
  # echo 100M > a/memory.min
  # echo +memory > a/cgroup.subtree_control
  # echo 100M > a/b/memory.min
  # echo $$ > a/b/cgroup.procs
  # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
  # cat a/b/memory.current
  222650368
  # echo 500M > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat a/b/memory.current
  6070272

memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
protection. The traditional LRU path is not affected because
shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
visits during a top-down tree walk.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
moved the protection computation into lru_gen_age_node(), which only
runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
lru_gen_shrink_node() -> shrink_many() without any protection
computation, so emin/elow are whatever a previous kswapd run left behind
- or zero if kswapd never ran on this node. Relying on a prior kswapd
pass is not correct either: a memcg's emin/elow are derived from its
ancestors' memory.min/low settings and from children_min_usage, both of
which change over time, so emin/elow go stale even after kswapd has run
and must be recomputed at the point of reclaim.

Introduce mem_cgroup_calculate_protection_path() which computes emin/elow
along the root-to-target path only, by iterating through the cgroup
ancestors array top-down. This avoids the full tree traversal that would
be needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg
about to be shrunk has correct protection values.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f227348a3f24..a65a516adc66 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1885,6 +1885,16 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 }
 #endif /* CONFIG_MEMCG */
 
+#if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg);
+#else
+static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+							struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 256b68ffca70..ae568fc68813 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5214,6 +5214,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+#ifdef CONFIG_LRU_GEN
+/**
+ * mem_cgroup_calculate_protection_path - compute protection along a path
+ * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
+ * @memcg: the target memory cgroup
+ *
+ * Walk the ancestor path from @root down to @memcg and compute the effective
+ * protection at each level.  This is safe for isolated queries because it
+ * ensures parents are computed before children.
+ */
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg)
+{
+	bool recursive_protection =
+		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+	struct cgroup *cg;
+	int root_level, i;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!root)
+		root = root_mem_cgroup;
+
+	if (memcg == root)
+		return;
+
+	root_level = root->css.cgroup->level;
+	cg = memcg->css.cgroup;
+
+	rcu_read_lock();
+	for (i = root_level + 1; i <= cg->level; i++) {
+		struct mem_cgroup *cur;
+
+		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
+						     &memory_cgrp_subsys));
+		if (cur)
+			page_counter_calculate_protection(&root->memory,
+							  &cur->memory,
+							  recursive_protection);
+	}
+	rcu_read_unlock();
+}
+#endif /* CONFIG_LRU_GEN */
+
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b4c9b8f3dfe9..500cc2051d13 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, lru_gen_age_node() has already called
+	 * mem_cgroup_calculate_protection()
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_calculate_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-- 
2.34.1


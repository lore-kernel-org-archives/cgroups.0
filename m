Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469B418342
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 11:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915405; cv=none; b=R/pji+cMBaiA4HSdbz1ha5KXTZI5Rf3vjEU+eAWUlhYojQ+A+ARIGyOXjRAFqYHlJozdRE6Bica+G2NHAqLC7G+ZKeyLp3gV8zY4PxJQrBe5SfmVtd+sejSUp7B+PrMpfwjN/xA/wmn/naZ8TOs/NbVNy/vFFzuggh6l9o13JJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915405; c=relaxed/simple;
	bh=eE7AKtJ5rHDjCHFP0sbjzrcKFX6z6p2ntCRRXg0JHB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kLFl2/6HxcCsDqzdzFkFINLCLtVAEdJinjxVs7O9Pkh+NPaUvqHtAlo0B7kMECBWU0y4lOdcONERn34WlQEYCNkZYHuZuxE+S0+pLQF1nQh2SpWJ2Qa+o11EXhUrcjeQnLIIWTjn/ul6uN53qGjJpUArx4iPYRDpZ4Qp4aPtVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s3AqYBR7; arc=none smtp.client-ip=91.218.175.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s3AqYBR7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eE7AKtJ5rHDjCHFP0sbjzrcKFX6z6p2ntCRRXg0JHB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787915399; v=1; x=1788520199;
 b=s3AqYBR7xq9lQCJZeMNj5AAuqsD0kfS4MXgdsvZddFFOpu51QVN5ntOKtjk9abTPFIikO1Q1
 1wABoFLL6nAwe13oy0Dis2s3dVLZA9RL65FsMa+Dg7M8/WBIk7iao6ZVo6prAeBvwQB8AhgTbOy
 1gG5UEZmbR/djDug+B6vMruM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 103cb01acecf7077;
	Fri, 28 Aug 2026 11:09:59 +0000
X-Mizu-Trace-ID: 103cb01acecf7077
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
Subject: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 19:09:19 +0800
Message-Id: <20260828110919.1324028-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828110919.1324028-1-ridong.chen@linux.dev>
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

memory.min/low is silently bypassed for MGLRU during global proactive
reclaim (writing to the root memory.reclaim) and global direct reclaim.
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
computation, so emin/elow remain stale or zero.

Introduce mem_cgroup_protection_path() which computes emin/elow along
the root-to-target path only by iterating through the cgroup ancestors
array top-down. This avoids the full tree traversal that would be
needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg
about to be shrunk has correct protection values.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h | 11 ++++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..8066b798a759 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -605,6 +605,10 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
+#ifdef CONFIG_LRU_GEN
+void mem_cgroup_protection_path(struct mem_cgroup *root,
+				struct mem_cgroup *memcg);
+#endif
 
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
@@ -1133,6 +1137,13 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
+#ifdef CONFIG_LRU_GEN
+static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
+					      struct mem_cgroup *memcg)
+{
+}
+#endif
+
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..095050d4296a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5198,6 +5198,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+#ifdef CONFIG_LRU_GEN
+/**
+ * mem_cgroup_protection_path - compute protection along root->memcg path
+ * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
+ * @memcg: the target memory cgroup
+ *
+ * Walk the ancestor path from @root down to @memcg and compute the effective
+ * protection at each level.  This is safe for isolated queries because it
+ * ensures parents are computed before children.
+ */
+void mem_cgroup_protection_path(struct mem_cgroup *root,
+				struct mem_cgroup *memcg)
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
index f11491ee9ed5..e0ba68ede745 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5102,7 +5102,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, lru_gen_age_node() has already called
+	 * mem_cgroup_calculate_protection()
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-- 
2.34.1


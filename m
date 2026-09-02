Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF3E4AD4DF
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 17:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371017; cv=none; b=Y4IdJ0TY6jitexKQ+tAJ0KKEbKp9TLQJPX/f7weOcT0eVhIGEuAXC+J8fTv6+kxmfQttl37wQT7i7sgRb9GvE9UA9AgYlsqznM2htPmEPrhCrQiVY0zIsGZhUwjOpz22Qp/+x3UdodC2v4EjWzt2A6kRiauJAULZnKHOwCt7hrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371017; c=relaxed/simple;
	bh=9AizrKxZG1A7ShaemAVD30+q00uib56tFKexFmDnGGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxtGfUQpsh0Z2WUVj5DC0h2W19iUFnhINB3WcuRoVj5a9W/Z98CjLplUVb0qk03xT6aFw3c7TecU0ZnAQD8vqXZVtHJncuuaLnODkKbyawB1oYlL9umz0XzCbGtOmMXxM7M2c0RUvS7Y3RaM3XuqKL8P5knqQunq0eRdOCOmpHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g6JYDRmf; arc=none smtp.client-ip=95.215.58.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g6JYDRmf"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9AizrKxZG1A7ShaemAVD30+q00uib56tFKexFmDnGGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371013; v=1; x=1788975813;
 b=g6JYDRmf5diyjSHH+ahaOOJ3ofT/5R6+grTxr2XOt9NtCdNPPKf9t/VIU1L6o3Fqc80fR6QJ
 HpRu1UhE3Pjwnh1Ztlq1LiIwAusVepuHgnCp9XVGDEU3GAmoewYGqPMxHK9mVDLhRWKzFITwKwX
 2RhLEm5tykCZgTCGq9ON25W4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d841d0e1b85067ee;
	Wed, 02 Sep 2026 17:43:32 +0000
X-Mizu-Trace-ID: d841d0e1b85067ee
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] memcg: remove lru_gen_soft_reclaim()
Date: Wed,  2 Sep 2026 10:43:08 -0700
Message-ID: <20260902174311.1772372-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The soft limit rbtree was the only caller. Dropping it leaves
MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
that op, so remove the op too and update the memcg LRU comment.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmzone.h | 30 +++++++++++-------------------
 mm/vmscan.c            | 16 ++--------------
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 67c84a8a7258..84e237f2c17d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -638,35 +638,32 @@ struct lru_gen_mm_walk {
  * For each node, memcgs are divided into two generations: the old and the
  * young. For each generation, memcgs are randomly sharded into multiple bins
  * to improve scalability. For each bin, the hlist_nulls is virtually divided
- * into three segments: the head, the tail and the default.
+ * into two segments: the tail and the default.
  *
  * An onlining memcg is added to the tail of a random bin in the old generation.
  * The eviction starts at the head of a random bin in the old generation. The
  * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
  * the old generation, is incremented when all its bins become empty.
  *
- * There are four operations:
- * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin in its
- *    current generation (old or young) and updates its "seg" to "head";
- * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
+ * There are three operations:
+ * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
  *    current generation (old or young) and updates its "seg" to "tail";
- * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
+ * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
  *    generation, updates its "gen" to "old" and resets its "seg" to "default";
- * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
+ * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
  *    young generation, updates its "gen" to "young" and resets its "seg" to
  *    "default".
  *
  * The events that trigger the above operations are:
- * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
- * 2. The first attempt to reclaim a memcg below low, which triggers
+ * 1. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
+ * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
  *    threshold, which triggers MEMCG_LRU_TAIL;
- * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
+ * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
  *    threshold, which triggers MEMCG_LRU_YOUNG;
- * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
- * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
- * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
+ * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
+ * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
+ * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
  *
  * Notes:
  * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
@@ -699,7 +696,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
 void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
@@ -740,10 +736,6 @@ static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
 {
 }
 
-static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
-{
-}
-
 static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
 {
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d66b5cd167d6..deb087c57007 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 /* see the comment on MEMCG_NR_GENS */
 enum {
 	MEMCG_LRU_NOP,
-	MEMCG_LRU_HEAD,
 	MEMCG_LRU_TAIL,
 	MEMCG_LRU_OLD,
 	MEMCG_LRU_YOUNG,
@@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	new = old = lruvec->lrugen.gen;
 
 	/* see the comment on MEMCG_NR_GENS */
-	if (op == MEMCG_LRU_HEAD)
-		seg = MEMCG_LRU_HEAD;
-	else if (op == MEMCG_LRU_TAIL)
+	if (op == MEMCG_LRU_TAIL)
 		seg = MEMCG_LRU_TAIL;
 	else if (op == MEMCG_LRU_OLD)
 		new = get_memcg_gen(pgdat->memcg_lru.seq);
@@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 
 	hlist_nulls_del_rcu(&lruvec->lrugen.list);
 
-	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
+	if (op == MEMCG_LRU_OLD)
 		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
 	else
 		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
@@ -4489,15 +4486,6 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 	}
 }
 
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
-{
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-	/* see the comment on MEMCG_NR_GENS */
-	if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_HEAD)
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
-}
-
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
 {
 	struct lruvec *lruvec = get_lruvec(memcg, nid);
-- 
2.53.0-Meta


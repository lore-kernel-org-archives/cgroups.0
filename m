Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE1240B10D
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786480376; cv=none; b=s8iONoTikz+3CSG+w7tCbgxZOnuzL1NNRNEN8WA06A0Fs4y8Me8kaBNPgCSqLuyRvZqVpJq9r6fMNVcQV+cXxb6HXNVkcf/tPcXQEtJHWB3h/07AwHF92rAZk2uPc70HssJf3wqvdda5XJMBot5621S6de25wtDQ49sYTEQ4T/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786480376; c=relaxed/simple;
	bh=sX2noSKb34ahg6g5tpkNnlYlb8jDcEdQTjM16JJvcKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7zwGEERAw7rl6VS1mAOYrohJbJvwehk7MEN+OVB13dBbyHl7jnVWucu1xxvUzMRngkbBA+br4OStHghVOOgZ5k3Nism4kSqFWtRoYJBw7RLdx+LQRBld3ezWp1r3Z2zkyX2FWzLn84zQJmdSooUqL03OkvfWHpzufn9iA9kDZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rqcdEhl9; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rqcdEhl9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RBoE71wnBwMOfVKAQwpkXO2zfBhsgRR5WTCUnnYK0XI=;
	b=rqcdEhl97KNlZGT6AQVoZldHYtPVXRxa52iXODLrzeenxnlhF05ds+4XLpENW7ZnPwYmcu
	bdVbTk10D1q5qehMWWCSl3vwMyvuL85qTD7qEebW4amHgeE0yZhA3S5VqgwC8gYWBHWkf4
	cDLA1UgoMGl3/SBAjSBG+MP6mV/ajA4=
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
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] memcg: remove lru_gen_soft_reclaim()
Date: Tue, 11 Aug 2026 13:32:00 -0700
Message-ID: <20260811203203.3456029-7-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The soft limit rbtree was the only caller. Dropping it leaves
MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
that op, so remove the op too and update the memcg LRU comment.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mmzone.h | 30 +++++++++++-------------------
 mm/vmscan.c            | 16 ++--------------
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..01fabd0ece0d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -635,35 +635,32 @@ struct lru_gen_mm_walk {
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
@@ -696,7 +693,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
 void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
@@ -737,10 +733,6 @@ static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
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
index 790b50c78a2e..71244cf33d59 100644
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


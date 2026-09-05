Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF3A26158B
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 03:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788577554; cv=none; b=pQaU0GMvdFavGdsKCeZcGvrJb2B3BXIkwKUz7bdS7UP3Ho1ov2ahthtQG+DnwI95WNNum83gPi1dCcKoWOO4DXgyZiShF8pV+BNBZai/epG6yNVDqVTypth2YTEZT/lj+bJiKTwBdJvWAo2VSiGsdei0fxNnBP9GmRazPdW62yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788577554; c=relaxed/simple;
	bh=F1dMlE3SNbCaduwN58Kn4je6GZ6Gq4FaW4vEejZffVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8f42/khY1fYYMyXiSyocbdWekoFOBiVFLVq4w1czaTlBtmzSZRhsXjkA6twWJFxQcsAGL8f7U0lXngh1tQpUasqAGbEGR80bWp83IzE40RTVB6wOMIi6wV0uK2SB3d2bWG77/nqvdhn5usLS8KSVMy5p6M9HAWUgUA733xJaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W4umrh0I; arc=none smtp.client-ip=95.215.58.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W4umrh0I"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=F1dMlE3SNbCaduwN58Kn4je6GZ6Gq4FaW4vEejZffVI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577548; v=1; x=1789182348;
 b=W4umrh0IBWw2xAtN6p/GkEoZsBz4q6SjKzBfB2DcwN7fRn7kt1mQY1OM5kwQiDY0aJv2Cslo
 Mha+oI7LfBQ/iYrxmRdjM1sX8svD2NsmLC8YtT/dLYK+JBD72iYOVv97jucH4b5YpUx0ZdYg5KN
 2Xykk6h1w08ilRUR5LxPhN4Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e1ea12b19bf4cab9;
	Sat, 05 Sep 2026 03:05:48 +0000
X-Mizu-Trace-ID: e1ea12b19bf4cab9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] memcg: group the fields of struct mem_cgroup_per_node
Date: Fri,  4 Sep 2026 20:05:22 -0700
Message-ID: <20260905030522.1887837-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the two ad-hoc CACHELINE_PADDING members with named cache line
groups:

  memcg_pn_read_mostly   memcg, lruvec_stats_percpu, lruvec_stats,
                         shrinker_info, objcg
  memcg_pn_lruvec        lruvec
  memcg_pn_write_hot     lru_zone_size, iter, nmi slab stats
  memcg_pn_cold          orig_objcg, objcg_list

The group markers give the same isolation the padding did, but they
are named and the build now checks them.

lruvec still gets its own lines. Commit f59adcf59332 ("mm: memcg: add
cacheline padding after lruvec in mem_cgroup_per_node") showed why
that matters: lru_zone_size[] is written under lru_lock but read
without it by lruvec_lru_size(), so it must not share a line with
lruvec.

Splitting the cold fields out costs one extra cache line per node per
memcg.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++++++++----------
 mm/memcontrol.c            | 30 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d0f3458f9250..e10a3eaae890 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -82,7 +82,8 @@ struct mem_cgroup_reclaim_iter {
  * per-node information in memory controller.
  */
 struct mem_cgroup_per_node {
-	/* Keep the read-only fields at the start */
+	/* Set when the memcg is created, then only read. */
+	__cacheline_group_begin_aligned(memcg_pn_read_mostly);
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 
@@ -91,14 +92,30 @@ struct mem_cgroup_per_node {
 	struct shrinker_info __rcu	*shrinker_info;
 	struct obj_cgroup __rcu		*objcg;
 
-	CACHELINE_PADDING(_pad1_);
+	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
-	/* Fields which get updated often at the end. */
+	/*
+	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
+	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
+	 * padding after lruvec in mem_cgroup_per_node").
+	 */
+	__cacheline_group_begin_aligned(memcg_pn_lruvec);
 	struct lruvec		lruvec;
-	CACHELINE_PADDING(_pad2_);
+	__cacheline_group_end_aligned(memcg_pn_lruvec);
+
+	/* Written on every LRU update and on every reclaim iteration. */
+	__cacheline_group_begin_aligned(memcg_pn_write_hot);
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* slab stats for nmi context */
+	atomic_t		slab_reclaimable;
+	atomic_t		slab_unreclaimable;
+#endif
+	__cacheline_group_end_aligned(memcg_pn_write_hot);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
 	/*
 	 * orig_objcg preserves a pointer (and a reference) to the original
 	 * objcg until the end of life of memcg.
@@ -106,12 +123,7 @@ struct mem_cgroup_per_node {
 	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
-
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* slab stats for nmi context */
-	atomic_t		slab_reclaimable;
-	atomic_t		slab_unreclaimable;
-#endif
+	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a5a30439a03..6976a60c911f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5796,6 +5796,36 @@ static void __init memcg_struct_check(void)
 				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, memcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, lruvec_stats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, lruvec_stats);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, shrinker_info);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, objcg);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_lruvec, lruvec);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, lru_zone_size);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, iter);
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, slab_reclaimable);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, slab_unreclaimable);
+#endif
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_cold, orig_objcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_cold, objcg_list);
 }
 
 int __init mem_cgroup_init(void)
-- 
2.53.0-Meta


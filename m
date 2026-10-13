Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045C472094;
	Tue, 13 Oct 2026 03:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791861157; cv=none; b=aN4HQbkCeFsg+g1w28iu6ye/69EaAQO4Ryn1Y/7Y2LVEr7yoitTLNCo1tCrOEaSGEpJPBXZYK6L0zBVGkyVlDguk9RjxgstygNmO7allvlNiR2buOjX+yVJ6ztfaF+nWImWmMWY9OUlnLmivqkeavFzomzSUr8V08B6jS/XvEXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791861157; c=relaxed/simple;
	bh=6ick7YbNm0weH+4VhwBbZ/k4EoYWMJDUV5+U9c7y9Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9AJbZvNJH5AMRFTqUr+g0rZ98BKNo5WSG6zzRc3/b/+cQ1BLK6Kyt8nos9jDRkrCP2tei17e6jfhIgsJ+8xtZcYTey/K1fZsvbiHYiDlCdne710qqxE476AeuC3PDXSqyzzp7yc5QpvkYjCAv25W2MjMvxISZMqsNZFZWZzU+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ixpPW12J; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ixpPW12J"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861147; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iLVAW+fTIOsvFqz8AUTyojT4okins1Fy/sb2HWay26A=;
	b=ixpPW12JVf3KeSMwMCy1XiMPjs/90JZkRn19YHL2unsp/kDVtILLV+fA9HVxvEajvemE6zY+yMumHYEQXU6/MYe3FlsHIbifYSNiuBL4l2knMXEXrjdmPi8FUkXqADvZ/WUAO/2qIsSGxR5vh2tNezkGfY2V+rl4gEAoHwJ9YYE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjcd_1791861144;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjcd_1791861144 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:25 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 1/5] mm: list_lru: pass the memcg index directly to the walker
Date: Tue, 13 Oct 2026 11:12:17 +0800
Message-ID: <20261013031221.1997194-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list_lru_walk_node() looks up the memcg for each xarray index, only to
have __list_lru_walk_one() translate that memcg back to an index to
find the sublist.  The walker has no other use for the memcg.

Pass the index directly and drop the reverse lookup and the temporary
CSS reference.  The sublist is still looked up under RCU, and the
lookup is repeated when a callback drops the lock.

Split the memcg-based locking helper into an index-based primitive and
a parent-traversing wrapper, replacing the skip_empty parameter.

This is a preparation step for switching the xarray keys from the
private memcg ID to the cgroup ID, which has no reverse lookup helper.
The unsigned long index type matches the xarray API and fits the u64
cgroup IDs; zero is reserved for the root per-node list.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 mm/list_lru.c | 98 +++++++++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 43 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc..61248b88441c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -37,6 +37,13 @@ static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
 		spin_unlock(&l->lock);
 }
 
+static inline unsigned long list_lru_memcg_idx(const struct mem_cgroup *memcg)
+{
+	int idx = memcg_kmem_id(memcg);
+
+	return idx < 0 ? 0 : idx;
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -72,9 +79,9 @@ static int lru_shrinker_id(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg_idx(struct list_lru *lru, int nid, unsigned long idx)
 {
-	if (list_lru_memcg_aware(lru) && idx >= 0) {
+	if (list_lru_memcg_aware(lru) && idx) {
 		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
 		return mlru ? &mlru->node[nid] : NULL;
@@ -83,15 +90,13 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq,
-		       unsigned long *irq_flags, bool skip_empty)
+lock_list_lru_of_memcg_idx(struct list_lru *lru, int nid, unsigned long idx,
+			   bool irq, unsigned long *irq_flags)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
-again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
+	l = list_lru_from_memcg_idx(lru, nid, idx);
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
@@ -100,17 +105,26 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 		}
 		unlock_list_lru(l, irq, irq_flags);
 	}
-	/*
-	 * Caller may simply bail out if raced with reparenting or
-	 * may iterate through the list_lru and expect empty slots.
-	 */
-	if (skip_empty) {
-		rcu_read_unlock();
-		return NULL;
+	rcu_read_unlock();
+	return NULL;
+}
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags)
+{
+	struct list_lru_one *l;
+
+	for (;;) {
+		l = lock_list_lru_of_memcg_idx(lru, nid,
+					       list_lru_memcg_idx(*memcg),
+					       irq, irq_flags);
+		if (likely(l))
+			return l;
+		VM_WARN_ON(!css_is_dying(&(*memcg)->css));
+		*memcg = parent_mem_cgroup(*memcg);
 	}
-	VM_WARN_ON(!css_is_dying(&(*memcg)->css));
-	*memcg = parent_mem_cgroup(*memcg);
-	goto again;
 }
 #else
 static void list_lru_register(struct list_lru *lru)
@@ -132,15 +146,14 @@ static inline bool list_lru_memcg_aware(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg_idx(struct list_lru *lru, int nid, unsigned long idx)
 {
 	return &lru->node[nid].lru;
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq,
-		       unsigned long *irq_flags, bool skip_empty)
+lock_list_lru_of_memcg_idx(struct list_lru *lru, int nid, unsigned long idx,
+			   bool irq, unsigned long *irq_flags)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
@@ -148,13 +161,21 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 
 	return l;
 }
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags)
+{
+	return lock_list_lru_of_memcg_idx(lru, nid, 0, irq, irq_flags);
+}
 #endif /* CONFIG_MEMCG */
 
 struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
 				   struct mem_cgroup **memcg)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
-				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+				      /*irq_flags=*/NULL);
 }
 
 void list_lru_unlock(struct list_lru_one *l)
@@ -166,7 +187,7 @@ struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
 				       struct mem_cgroup **memcg)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
-				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+				      /*irq_flags=*/NULL);
 }
 
 void list_lru_unlock_irq(struct list_lru_one *l)
@@ -179,7 +200,7 @@ struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
 					   unsigned long *flags)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
-				      /*irq_flags=*/flags, /*skip_empty=*/false);
+				      /*irq_flags=*/flags);
 }
 
 void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
@@ -313,7 +334,7 @@ unsigned long list_lru_count_one(struct list_lru *lru,
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, list_lru_memcg_idx(memcg));
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -334,7 +355,7 @@ unsigned long list_lru_count_node(struct list_lru *lru, int nid)
 EXPORT_SYMBOL_GPL(list_lru_count_node);
 
 static unsigned long
-__list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+__list_lru_walk_one(struct list_lru *lru, int nid, unsigned long idx,
 		    list_lru_walk_cb isolate, void *cb_arg,
 		    unsigned long *nr_to_walk, bool irq_off)
 {
@@ -344,8 +365,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, /*irq=*/irq_off,
-				   /*irq_flags=*/NULL, /*skip_empty=*/true);
+	l = lock_list_lru_of_memcg_idx(lru, nid, idx, /*irq=*/irq_off,
+				       /*irq_flags=*/NULL);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -396,8 +417,8 @@ list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		  list_lru_walk_cb isolate, void *cb_arg,
 		  unsigned long *nr_to_walk)
 {
-	return __list_lru_walk_one(lru, nid, memcg, isolate,
-				   cb_arg, nr_to_walk, false);
+	return __list_lru_walk_one(lru, nid, list_lru_memcg_idx(memcg),
+				   isolate, cb_arg, nr_to_walk, false);
 }
 EXPORT_SYMBOL_GPL(list_lru_walk_one);
 
@@ -406,8 +427,8 @@ list_lru_walk_one_irq(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		      list_lru_walk_cb isolate, void *cb_arg,
 		      unsigned long *nr_to_walk)
 {
-	return __list_lru_walk_one(lru, nid, memcg, isolate,
-				   cb_arg, nr_to_walk, true);
+	return __list_lru_walk_one(lru, nid, list_lru_memcg_idx(memcg),
+				   isolate, cb_arg, nr_to_walk, true);
 }
 
 unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
@@ -422,21 +443,12 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 #ifdef CONFIG_MEMCG
 	if (*nr_to_walk > 0 && list_lru_memcg_aware(lru)) {
 		struct list_lru_memcg *mlru;
-		struct mem_cgroup *memcg;
 		unsigned long index;
 
 		xa_for_each(&lru->xa, index, mlru) {
-			rcu_read_lock();
-			memcg = mem_cgroup_from_private_id(index);
-			if (!memcg || !mem_cgroup_tryget(memcg)) {
-				rcu_read_unlock();
-				continue;
-			}
-			rcu_read_unlock();
-			isolated += __list_lru_walk_one(lru, nid, memcg,
+			isolated += __list_lru_walk_one(lru, nid, index,
 							isolate, cb_arg,
 							nr_to_walk, false);
-			mem_cgroup_put(memcg);
 
 			if (*nr_to_walk <= 0)
 				break;
@@ -502,7 +514,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
+	unsigned long dst_idx = list_lru_memcg_idx(dst_memcg);
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
-- 
2.43.7


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870570;
	b=1QEJ6sM2VzHcM8S+YzBD+Va2CGSMoQ9oINagh1sZHBcy7SYP26LxnRElgWKk7Z99qX3p
	 VJUKLu6YJJ89e/TtMeiujXglm2xIUlFoywz+X1Cb4Urh7XRrbxKIkP2lGhd2ed+x3hFds
	 PDtCle8n2zmroInodKidgs8SV+ZGjWCP2czOp2UQgkXVqMNPSvONp9tOGHVDlRcc8WKhc
	 olDfe489cqKWcM+rRdVv0w5E2WkE/pf3nmnpDZn0KpnKiicOrA4MGb7t6jTNbhTjqnunO
	 FQJ2sqHawJCjfrU/R+kSKX1tOT2rKQ2iDR5u41fyulPmEc5KmMz/9AqfD2kBAT/fMKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870570;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iLVAW+fTIOsvFqz8AUTyojT4okins1Fy/sb2HWay26A=;
	b=GUr7NET92dGORcdcaGrr30rxqj4hgGDEP38hYj6PceacigY6r4g8+BjRwqxkqmYnm7H9
	 Ctp8DBsM5f8aagnf9Lda2XJAN0YrtTc2rWN8kflERNQEXfiMtKA1ZNw6YEDo4acoPdcTc
	 O1hkGcmtb2wYlY3ZYGfHUC6V7I1Cik3Ryes1uCZ6n1P7dZNpnm0dShNMaSLAwcC+Qkwfp
	 uth6dnUh+fT5XNClgcFI5TOy0wyPLz4IpWpKe9baCrTsQ1DlssxU6gk4Ifc650IR3W+uk
	 QFyBP8pIif2xVK41uL4lOD/i9bgr0zyfBp/uzCe7DQji9JaC9NYVDqgqgLv0xpERQjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZkXDKZi8;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07492606A330;
	Thu,  5 Nov 2026 09:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07492606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZkXDKZi8
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870559; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iLVAW+fTIOsvFqz8AUTyojT4okins1Fy/sb2HWay26A=;
	b=ZkXDKZi8TTb/npfBlA3WJ8WR1rc1MKor2X0Hx5XA93JjuFjGCxuxbjfEJSZApOMggmzeb83BfIFUWI4ltKDZFt0QwgozcqSRVbUqvoDS09klPQE8ywDcy2aa/rWtQ//x5GZeg4CzS7UNl63i96RabH9OgtsO6k7Ro2nNWoV+PjE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-0._1793870556;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-0._1793870556 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:37 +0800
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
Subject: [PATCH v4 RESEND 1/5] mm: list_lru: pass the memcg index directly to the walker
Date: Thu,  5 Nov 2026 17:22:29 +0800
Message-ID: <20261105092233.3558950-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
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


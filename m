Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8E6526AB9;
	Wed, 14 Oct 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791989694; cv=none; b=uXSutno3cWxNSS1Fn3zL0/4V5EymunNiF7jxqSZJhZdV88Cx7pExqJELXJXciqAWURh2KfEuDT5INOXsGHSpi6N3MioR1o7MVk1eCBvwoRDOFxU3rCKqFxvtfXh8oU/nhA2exjkm0SKSwM1Dqh8vVcQhIeLF9Jemm9jwpqYaMds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791989694; c=relaxed/simple;
	bh=CctMyJyXgGUrScQJ2ttaoMrI4QIsTUQ+CftqSQ6QaSc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XSw8Fd2nRqnL/4u6m+wh6A2fO9arqOcqRzXPfDqEhbbaeiFqOZJMuQkmAIPl1buOHpdo/PAMz8DlMJTXFOT2+gLqTfY2KLUqG7ozvP7PpleHX4jnpi9BaXNiuay6LKhRCPatUp5I+7/jkwTaxCHYlZosr+7wE0Ihrkrlml8bpwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=aV4IZiRu; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="aV4IZiRu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=fvF7hwilLN2+vfhbQKONyYtceq7A4867IVO6znq1Avo=; b=aV4IZiRufZhuAcMca36
	g75rUiVFuzdircVuFNbpI7L+QHXI/VBrm4U9Tzm/nk8NNTCi0gPKpA42FMFhSUmwV6+Jr4cFo4Weg
	jNhhAKV4UjrRncjNctrBcZuZ4Q/v8Fy4sMlKq4RAOcnoj0kccjpabdF7aNH1JO0+AGd2HtJCL5psk
	eNgnyKPPkzRRinV7FfHxCYqI0gFehVPZq8bhRRYpnIDGOBj/bIn0efQHYT8vPtjr3SQ4LCuX/um1j
	kyefYEtuDU6sI8tU7LHoW/P1DALsxgj00B+m/VvI9WeGqj3JYjyterokmxhHRH1OAyaFYbkYiTIm8
	vgrcLDeShGazjYQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH0Jy-005Oui-1Q;
	Wed, 14 Oct 2026 16:54:42 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 16:54:38 +0200
Subject: [PATCH v2 2/2] mm/shrinker: allocate the per-memcg shrinker units
 on demand
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-2-51af2aedbe6c@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12284;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=CctMyJyXgGUrScQJ2ttaoMrI4QIsTUQ+CftqSQ6QaSc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqz5exkNy+l3yrBmYm3Ab2TRJEDgU343TyIqpzv
 V1fpoS9qEeJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas+XsQAKCRBRlgpH+WFc
 KrcEEACo+xkOIJ0umLmP+qvznB4nOGZoEvd1aLzRI0gwW+AR9Ecox8GfU35bEdNuzjcl24VPLDD
 i/yL3DlZpyj5TG1FQ11Ca2OVfkUB9UtO/dzHBKyDv8D7OKTO1uNiat0/+d5PK7OYGjiMFT/4Cjh
 UN4qN/U61KH/MrZWNlNmcNwF0R4hcJaoVIqGtMUxbNg/ZpxUwFWCriv+xfA0BPEOnYtpwiLQ3f9
 A5zgxkLKdPNMuFG0m2x4hPBh0CDoXaMmxKcFOLQ37ul7NuRPkt/phgYhVLiZFZKY+Xz2+JPi1+5
 ZGrd85KB/rbSiacVgnsbvZo5Z7zzzS/3gLP83o5stnfJ4N3ngnaaHvG1yqebxxgMxt1R+GxT6xi
 +sEp6nGvne8fRkELpSfTRssMYhxS2LY6SKlExOP47L+riAihpjI4gHJZ5VYyBh2kwtVJFCFlFET
 U26s+jCACWicXU/vGYAVzBFKekyHqrHq7n290CWvsSyc6S+1nJybFWcVslx7hTHxWVQPBX2vMvN
 pdNx3eWrbv9LFmapgBNvmqGD52soxIUmciy141becnB0/YDMPt8TDGMvtJvmbl22Zt6hvKS/dCq
 9R2jvadbv9JxzlNE2OXH43NVlkvZ4Nob3U2G2cFJYod84vnqvP8R4pRG9wU+FeJewpvSTbX0w4Q
 RR5Y/ftEHQrd1BQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

A memory cgroup allocates a shrinker_info_unit for every
SHRINKER_UNIT_BITS ids up to shrinker_nr_max on every NUMA node when it
comes online, whether or not it will ever hold objects of those
shrinkers. Every superblock registers a memcg-aware shrinker, so on a
host with many mounts each new cgroup pays for all of them while its
tasks touch a few.

A map bit is only ever set on a memcg that holds a list_lru list of
that shrinker. So the point where a memcg gets such a list is the one
place a unit can be installed ahead of its first use, and that is where
it is installed.

The rule the code now relies on:

  A non-root memcg that has a list on a list_lru has the unit of that
  list's shrinker, on every node.

It holds because:

  - the unit is installed before the list is published;
  - a unit lives until the memcg is freed.

So set_shrinker_bit() always finds the unit. A reader that finds none
knows the memcg never held objects of that shrinker: there is nothing
to walk and no deferred work.

There is one case where a memcg has no list: with cgroup.memory=nokmem
a list_lru is never per-memcg, but a SHRINKER_MEMCG_AWARE shrinker that
also has SHRINKER_NONSLAB still gets an id. If such a shrinker keeps
lists of its own and sets map bits itself, it has to call
memcg_shrinker_unit_alloc() first. No shrinker in the tree does.

The install runs with the gfp of the list allocation, possibly atomic,
so it cannot take shrinker_mutex. A spinlock orders it against the info
replacement in expand_one_shrinker_info() instead, so a unit cannot be
installed into an info that is being copied out of.

The root memcg keeps all its units: global reclaim keeps the deferred
work of memcg-aware shrinkers there, and root has no list allocation to
install them from.

The units of a memcg now scale with the number of shrinkers it and its
descendants hold objects of, not with shrinker_nr_max.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |   2 +
 mm/list_lru.c              |   6 ++
 mm/shrinker.c              | 159 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 138 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a88..a14f43c3a1b01 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1676,6 +1676,8 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
 #endif
 
 int alloc_shrinker_info(struct mem_cgroup *memcg);
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..7247b7c081b4c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -597,6 +597,12 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			parent = parent_mem_cgroup(pos);
 		}
 
+		if (!css_is_dying(&pos->css) &&
+		    memcg_shrinker_unit_alloc(pos, lru_shrinker_id(lru), gfp)) {
+			kfree(mlru);
+			return -ENOMEM;
+		}
+
 		if (!mlru) {
 			mlru = memcg_init_list_lru_one(lru, gfp);
 			if (!mlru)
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 5e4a5ce231868..fbe20e105f293 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -13,6 +13,14 @@ DEFINE_MUTEX(shrinker_mutex);
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
 
+/*
+ * Orders installing a unit against the pointer copy in
+ * expand_one_shrinker_info(). Installs run from the list_lru allocation
+ * path with the caller's gfp and cannot wait for shrinker_mutex; they can
+ * nest in the i_pages lock, which is taken from interrupts.
+ */
+static DEFINE_SPINLOCK(shrinker_unit_lock);
+
 static inline int shrinker_unit_size(int nr_items)
 {
 	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct shrinker_info_unit *));
@@ -30,9 +38,6 @@ static inline void shrinker_unit_free(struct shrinker_info *info, int start)
 	nr = DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
 
 	for (i = start; i < nr; i++) {
-		if (!unit[i])
-			break;
-
 		kfree(unit[i]);
 		unit[i] = NULL;
 	}
@@ -98,7 +103,13 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 		if (!info)
 			goto err;
 		info->map_nr_max = shrinker_nr_max;
-		if (shrinker_unit_alloc(info, NULL, nid)) {
+		/*
+		 * Global reclaim keeps the deferred work of memcg-aware
+		 * shrinkers in the root's units, and root has no list_lru
+		 * allocation to install them from.
+		 */
+		if (mem_cgroup_is_root(memcg) &&
+		    shrinker_unit_alloc(info, NULL, nid)) {
 			kvfree(info);
 			goto err;
 		}
@@ -126,6 +137,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 {
 	struct shrinker_info *new, *old;
 	struct mem_cgroup_per_node *pn;
+	unsigned long flags;
 	int nid;
 
 	for_each_node(nid) {
@@ -145,13 +157,20 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 
 		new->map_nr_max = new_nr_max;
 
-		memcpy(new->unit, old->unit, old_size);
-		if (shrinker_unit_alloc(new, old, nid)) {
+		if (mem_cgroup_is_root(memcg) &&
+		    shrinker_unit_alloc(new, old, nid)) {
 			kvfree(new);
 			return -ENOMEM;
 		}
 
+		/*
+		 * A unit installed meanwhile lands in old before the copy or
+		 * in new after the publish.
+		 */
+		spin_lock_irqsave(&shrinker_unit_lock, flags);
+		memcpy(new->unit, old->unit, old_size);
 		rcu_assign_pointer(pn->shrinker_info, new);
+		spin_unlock_irqrestore(&shrinker_unit_lock, flags);
 		kvfree_rcu(old, rcu);
 	}
 
@@ -206,21 +225,26 @@ static inline int calc_shrinker_id(int index, int offset)
 
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
-	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
-		struct shrinker_info *info;
+	struct shrinker_info_unit *unit;
+	struct shrinker_info *info;
 
-		rcu_read_lock();
-		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
-			struct shrinker_info_unit *unit;
-
-			unit = info->unit[shrinker_id_to_index(shrinker_id)];
-			/* Pairs with smp mb in shrink_slab() */
-			smp_mb__before_atomic();
-			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
-		}
-		rcu_read_unlock();
-	}
+	if (shrinker_id < 0 || !memcg || mem_cgroup_is_root(memcg))
+		return;
+
+	rcu_read_lock();
+	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+	if (WARN_ON_ONCE(shrinker_id >= info->map_nr_max))
+		goto unlock;
+
+	unit = READ_ONCE(info->unit[shrinker_id_to_index(shrinker_id)]);
+	if (WARN_ON_ONCE(!unit))
+		goto unlock;
+
+	/* Pairs with smp mb in shrink_slab() */
+	smp_mb__before_atomic();
+	set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
+unlock:
+	rcu_read_unlock();
 }
 
 static DEFINE_IDR(shrinker_idr);
@@ -265,14 +289,16 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
 static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 				   struct mem_cgroup *memcg)
 {
+	int offset = shrinker_id_to_offset(shrinker->id);
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
 
 	rcu_read_lock();
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
+	unit = READ_ONCE(info->unit[shrinker_id_to_index(shrinker->id)]);
+	/* No unit: this memcg never held objects of this shrinker. */
+	nr_deferred = unit ? atomic_long_xchg(&unit->nr_deferred[offset], 0) : 0;
 	rcu_read_unlock();
 
 	return nr_deferred;
@@ -281,20 +307,83 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 				  struct mem_cgroup *memcg)
 {
+	int offset = shrinker_id_to_offset(shrinker->id);
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
 
 	rcu_read_lock();
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred =
-		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
+	unit = READ_ONCE(info->unit[shrinker_id_to_index(shrinker->id)]);
+	nr_deferred = unit ? atomic_long_add_return(nr, &unit->nr_deferred[offset]) : 0;
 	rcu_read_unlock();
 
 	return nr_deferred;
 }
 
+static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index,
+				 gfp_t gfp)
+{
+	struct shrinker_info_unit *unit;
+	struct shrinker_info *info;
+	unsigned long flags;
+
+	rcu_read_lock();
+	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+	/* Online memcgs have an info, and ids are expanded into it first. */
+	if (WARN_ON_ONCE(!info ||
+			 index >= shrinker_id_to_index(info->map_nr_max)) ||
+	    READ_ONCE(info->unit[index])) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+
+	unit = kzalloc_node(sizeof(*unit), gfp, nid);
+	if (!unit)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&shrinker_unit_lock, flags);
+	/* memcg is pinned: only expand replaces info, and it holds the lock */
+	info = rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
+					 lockdep_is_held(&shrinker_unit_lock));
+	if (!info->unit[index]) {
+		/* Walkers read the pointer locklessly: publish a zeroed unit. */
+		smp_store_release(&info->unit[index], unit);
+		unit = NULL;
+	}
+	spin_unlock_irqrestore(&shrinker_unit_lock, flags);
+
+	kfree(unit);
+	return 0;
+}
+
+/*
+ * Called before @memcg gets a list on a list_lru of shrinker @shrinker_id,
+ * from the path that allocates the list. A map bit is only ever set on a
+ * memcg that has the list, so set_shrinker_bit() always finds the unit.
+ * A shrinker that sets map bits without a list_lru, such as a NONSLAB
+ * one under cgroup.memory=nokmem, must call this first.
+ */
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp)
+{
+	int nid, ret;
+
+	if (shrinker_id < 0 || mem_cgroup_is_root(memcg))
+		return 0;
+
+	for_each_node(nid) {
+		ret = shrinker_unit_install(memcg, nid,
+					    shrinker_id_to_index(shrinker_id),
+					    gfp);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
 	int nid, index, offset;
@@ -309,8 +398,17 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
 		for (index = 0; index < shrinker_id_to_index(child_info->map_nr_max); index++) {
-			child_unit = child_info->unit[index];
-			parent_unit = parent_info->unit[index];
+			child_unit = READ_ONCE(child_info->unit[index]);
+			if (!child_unit)
+				continue;
+
+			if (!READ_ONCE(parent_info->unit[index]))
+				shrinker_unit_install(parent, nid, index, GFP_KERNEL);
+			parent_unit = READ_ONCE(parent_info->unit[index]);
+			/* Drop the debt rather than fail the cgroup teardown. */
+			if (!parent_unit)
+				continue;
+
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
 				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
@@ -531,10 +629,13 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	if (index < shrinker_id_to_index(info->map_nr_max)) {
 		struct shrinker_info_unit *unit;
 
-		unit = info->unit[index];
+		unit = READ_ONCE(info->unit[index]);
 
 		rcu_read_unlock();
 
+		if (!unit)
+			goto next;
+
 		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
@@ -589,7 +690,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			freed += ret;
 			shrinker_put(shrinker);
 		}
-
+next:
 		index++;
 		goto again;
 	}

-- 
2.43.0


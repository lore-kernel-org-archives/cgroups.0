Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792431573;
	b=23tCzhk+R1TUG1oKtm9qj7fk5mQjUvd537wwyGsqnEazGUvIceHrnH8sg0mbIcALixiU
	 HezjgTNnqKLF7OIJJS6ZEvrpZs0sh4TiLRJF64SVEfWK70iXlIlZl3OFLtMq+w0z3i4Ur
	 hYVC/y2zI2xv30LkjqFPfVNos0i9WtocrP25KTbir1LbJVnD8k4o+Z7ZqoQLXF8LNWk54
	 HNewY6VMlOfdwruOqBZENLNLUmMBsv3gIF0CLQw8HBQWYcZmj+i6z81kUXbgsK2jpw79G
	 OoqTU+/wnxKjJyyUfknhsNOF7tsED0fKZa0BkqxEw45G0IzUO5iq4BqOnzBTTHAG/1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792431573;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=zHnuirrNc367IjZFH3zZ8z3xoT1TDeKZt/utz/QfB6Y=;
	b=KRTkWSf1J82cjW8WLzKTvy24sjQwo1UIXbl+ytddXedovEmUwclRa4tQ+6ONreQkpC5I
	 aai5josWp+TYKuzPkUJGqhCKtvDVsQpgajZ+f5S85O6R5PObPXtqr1ZW+g6DX2uueTjZB
	 RbCQq/i4oiTks4L+iSGEWuiz3l2Jf2qRtVmRPhSRcco3cZlKN2904GSqgUXlziHWKILR7
	 rQxs+otBURr9n5bFirkgGFJL3eoVx5r+QHMX+yUx552cNp/a6hoYysDNB1Ohi54dv2rP/
	 DFTkeyEr92/IFFBdzDvfkUQHYT/Co9i25D+1tC7BWihqwsniAv1xnHcgn6njLi2sS5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=G3IVVpGF;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF64606A320;
	Mon, 19 Oct 2026 17:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEF64606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=G3IVVpGF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=zHnuirrNc367IjZFH3zZ8z3xoT1TDeKZt/utz/QfB6Y=; b=G3IVVpGFIRL3x16xiaC
	AJCmECQhdU3tyI3V6M+0Exi6vEYgWYnsIVu7d6cTqFw5WyBJNRegzOizoZ7s7ytdzHcxUjzm/3tOk
	VfXNBi0XNQaRBK81emY9uPYv6pV+cd/PhhWtaogoaz6CbS+QNfu6sp3RItVnbCYfJWV03vTfHSwWb
	9uaoQnOQ/9DG4D6cnwk6O9StcwAjpezPEhfWLzyRD9hAiPYBk9n4rYJOIqHnvs4VYaEXjLgeJiyZD
	cOHtl1EIlFuARXyrBwYhnfBjK9F0SyK3RosamrqOxLTRTfQtdFnP1dU4fHIZG7wnVS6LKgwTjJ1Cj
	YMmdNjbcgLf3f5w==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIrH1-007Chf-22;
	Mon, 19 Oct 2026 19:39:19 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 19 Oct 2026 19:39:23 +0200
Subject: [PATCH 1/2] mm/shrinker: keep the per-memcg shrinker units in an
 xarray
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-1-64ed1f7957c9@virtuozzo.com>
References: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
In-Reply-To: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16675;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=sVC4fMQqfY/qvO5GWprmSJ4HVz7x2/++1IMEmDe3khk=;
 b=owEBbAKT/ZANAwAKAVGWCkf5YVwqAcsmYgBq1lXOsD8QfSlcM8r4JnX/ukVApYPSKHrC4MzVs
 ZJzvXN4Y1KJAjIEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZVzgAKCRBRlgpH+WFc
 KphpD/dzinaPGl1PrmAjUuZDYRppu5Z+68vcdVDp00Fd80VuBT0vBTGMiiQJSjfj6QhpCVKCxEZ
 3IyfGE50GJff6+OxEXWZJ3/Hasn1jQW7327rOxjmWLvc1xMd9AY9csP/lwOhExEyrtMBBl9Txo1
 ETghvq75jCwF1LxJzjYW+i+4AtkFhPplKqtFShEYuRaS11lvEGsitO2mTgi8QLTadx8t5Ue60aK
 hOG1Ie/iJyMbE2kGBaSTmfZ5+e/IvAwBI+pIO/p30/jFtg5Np32h/+VIeEFD7ui3VJ+OVZAjUCq
 nsGBZCk8LOluqJJ5/tozeBsLWO0R5vADA7yzQ8bFo01NG5ukAhY+IMmCLUVSD7ec0lDFuxw73vu
 JvdiQeJZRafBwyoUxsZTu4ueNaxsGNVL6y7H+qnaDOez6RRuY60Hb54qzh6SslyQdVpsgKy5AI9
 HEvow81Xd4BOZfy1qOQyqOBkLWtCP2a/oEFU8ltvsYdt2rnwN5ifdvnsRqJTOfN5hCGJUQpsoBz
 cX7KF87H7iepz0RWJrMYkBSs/hSR+fbiPtYtbY+wNs/nB86lrikeBzQiYVHlFFkAjWeT1TYcyfG
 k1/WCyRaQZQrEdvXf+vOJ0HKCwrS8zyZVRPguPS8lePxor2y4PT5Dsn461g0xlx1dA949BYbim0
 KK3XcLaMe5L2U
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Every memory cgroup keeps, per NUMA node, an array of pointers to its
shrinker_info_units, sized for shrinker_nr_max ids. shrinker_nr_max is
the highest memcg-aware shrinker id ever handed out; every superblock
takes one, and it never comes down.

Keep the units in an xarray per memcg and node instead. Every memcg
then holds just the units it has, not an array sized for the host,
and growing shrinker_nr_max touches nothing that already exists.

The units are still allocated for every memcg up front.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |   3 +-
 include/linux/shrinker.h   |   6 -
 mm/memcontrol.c            |   1 +
 mm/shrinker.c              | 312 +++++++++++++++------------------------------
 4 files changed, 105 insertions(+), 217 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b5a89594c263c..52f3646e244ae 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/xarray.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -93,7 +94,7 @@ struct mem_cgroup_per_node {
 
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
-	struct shrinker_info __rcu	*shrinker_info;
+	struct xarray			shrinker_units;
 
 #ifdef CONFIG_MEMCG_V1
 	/*
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a9..2eae68a7ff6c5 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -18,12 +18,6 @@ struct shrinker_info_unit {
 	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
 };
 
-struct shrinker_info {
-	struct rcu_head rcu;
-	int map_nr_max;
-	struct shrinker_info_unit *unit[];
-};
-
 /*
  * This struct is used to pass information from page reclaim to the shrinkers.
  * We consolidate the values for easier extension later.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7a817181168ed..a13f3984f0e09 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4110,6 +4110,7 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	INIT_LIST_HEAD(&pn->objcg_list);
 
 	lruvec_init(&pn->lruvec);
+	xa_init(&pn->shrinker_units);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4fb424e721bca..74fc6f64459f0 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -19,48 +19,66 @@ void __init shrinker_unit_cache_init(void)
 	shrinker_unit_cachep = KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);
 }
 
-static inline int shrinker_unit_size(int nr_items)
+static inline int shrinker_id_to_index(int shrinker_id)
 {
-	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct shrinker_info_unit *));
+	return shrinker_id / SHRINKER_UNIT_BITS;
 }
 
-static inline void shrinker_unit_free(struct shrinker_info *info, int start)
+static inline int shrinker_id_to_offset(int shrinker_id)
 {
-	struct shrinker_info_unit **unit;
-	int nr, i;
+	return shrinker_id % SHRINKER_UNIT_BITS;
+}
 
-	if (!info)
-		return;
+static inline int calc_shrinker_id(int index, int offset)
+{
+	return index * SHRINKER_UNIT_BITS + offset;
+}
 
-	unit = info->unit;
-	nr = DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
+static struct shrinker_info_unit *shrinker_unit_get(struct mem_cgroup *memcg,
+						    int nid, int shrinker_id)
+{
+	return xa_load(&memcg->nodeinfo[nid]->shrinker_units,
+		       shrinker_id_to_index(shrinker_id));
+}
 
-	for (i = start; i < nr; i++) {
-		if (!unit[i])
-			break;
+/*
+ * A memcg is visible to expand_shrinker_info() before it goes online, so
+ * a unit may already be there from either side.
+ */
+static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index)
+{
+	struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
+	struct shrinker_info_unit *unit;
+	int ret;
 
-		kmem_cache_free(shrinker_unit_cachep, unit[i]);
-		unit[i] = NULL;
+	if (xa_load(units, index))
+		return 0;
+
+	unit = kmem_cache_alloc_node(shrinker_unit_cachep,
+				     GFP_KERNEL | __GFP_ZERO, nid);
+	if (!unit)
+		return -ENOMEM;
+
+	ret = xa_insert(units, index, unit, GFP_KERNEL);
+	if (ret) {
+		kmem_cache_free(shrinker_unit_cachep, unit);
+		if (ret == -EBUSY)
+			ret = 0;
 	}
+
+	return ret;
 }
 
-static inline int shrinker_unit_alloc(struct shrinker_info *new,
-				       struct shrinker_info *old, int nid)
+static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
 {
-	struct shrinker_info_unit *unit;
-	int nr = DIV_ROUND_UP(new->map_nr_max, SHRINKER_UNIT_BITS);
-	int start = old ? DIV_ROUND_UP(old->map_nr_max, SHRINKER_UNIT_BITS) : 0;
-	int i;
-
-	for (i = start; i < nr; i++) {
-		unit = kmem_cache_alloc_node(shrinker_unit_cachep,
-					     GFP_KERNEL | __GFP_ZERO, nid);
-		if (!unit) {
-			shrinker_unit_free(new, start);
-			return -ENOMEM;
-		}
+	int nid, index, ret;
 
-		new->unit[i] = unit;
+	for_each_node(nid) {
+		for (index = start; index < end; index++) {
+			ret = shrinker_unit_install(memcg, nid, index);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -68,18 +86,18 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
 
 static void __free_shrinker_info(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup_per_node *pn;
-	struct shrinker_info *info;
+	struct shrinker_info_unit *unit;
+	unsigned long index;
 	int nid;
 
 	lockdep_assert_held(&shrinker_mutex);
 
 	for_each_node(nid) {
-		pn = memcg->nodeinfo[nid];
-		info = rcu_dereference_protected(pn->shrinker_info, true);
-		shrinker_unit_free(info, 0);
-		kvfree(info);
-		rcu_assign_pointer(pn->shrinker_info, NULL);
+		struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
+
+		xa_for_each(units, index, unit)
+			kmem_cache_free(shrinker_unit_cachep, unit);
+		xa_destroy(units);
 	}
 }
 
@@ -92,82 +110,22 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
-	int nid, ret = 0;
-	int array_size = 0;
+	int ret;
 
 	mutex_lock(&shrinker_mutex);
-	array_size = shrinker_unit_size(shrinker_nr_max);
-	for_each_node(nid) {
-		struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
-							   GFP_KERNEL, nid);
-		if (!info)
-			goto err;
-		info->map_nr_max = shrinker_nr_max;
-		if (shrinker_unit_alloc(info, NULL, nid)) {
-			kvfree(info);
-			goto err;
-		}
-		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
-	}
+	ret = shrinker_units_install(memcg, 0,
+				     shrinker_id_to_index(shrinker_nr_max));
+	if (ret)
+		__free_shrinker_info(memcg);
 	mutex_unlock(&shrinker_mutex);
 
 	return ret;
-
-err:
-	__free_shrinker_info(memcg);
-	mutex_unlock(&shrinker_mutex);
-	return -ENOMEM;
-}
-
-static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
-						     int nid)
-{
-	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 lockdep_is_held(&shrinker_mutex));
-}
-
-static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
-				    int old_size, int new_nr_max)
-{
-	struct shrinker_info *new, *old;
-	struct mem_cgroup_per_node *pn;
-	int nid;
-
-	for_each_node(nid) {
-		pn = memcg->nodeinfo[nid];
-		old = shrinker_info_protected(memcg, nid);
-		/* Not yet online memcg */
-		if (!old)
-			return 0;
-
-		/* Already expanded this shrinker_info */
-		if (new_nr_max <= old->map_nr_max)
-			continue;
-
-		new = kvzalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
-		if (!new)
-			return -ENOMEM;
-
-		new->map_nr_max = new_nr_max;
-
-		memcpy(new->unit, old->unit, old_size);
-		if (shrinker_unit_alloc(new, old, nid)) {
-			kvfree(new);
-			return -ENOMEM;
-		}
-
-		rcu_assign_pointer(pn->shrinker_info, new);
-		kvfree_rcu(old, rcu);
-	}
-
-	return 0;
 }
 
 static int expand_shrinker_info(int new_id)
 {
 	int ret = 0;
 	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
-	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 
 	if (!root_mem_cgroup)
@@ -175,13 +133,11 @@ static int expand_shrinker_info(int new_id)
 
 	lockdep_assert_held(&shrinker_mutex);
 
-	new_size = shrinker_unit_size(new_nr_max);
-	old_size = shrinker_unit_size(shrinker_nr_max);
-
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		ret = expand_one_shrinker_info(memcg, new_size, old_size,
-					       new_nr_max);
+		ret = shrinker_units_install(memcg,
+					     shrinker_id_to_index(shrinker_nr_max),
+					     shrinker_id_to_index(new_nr_max));
 		if (ret) {
 			mem_cgroup_iter_break(NULL, memcg);
 			goto out;
@@ -194,38 +150,20 @@ static int expand_shrinker_info(int new_id)
 	return ret;
 }
 
-static inline int shrinker_id_to_index(int shrinker_id)
-{
-	return shrinker_id / SHRINKER_UNIT_BITS;
-}
-
-static inline int shrinker_id_to_offset(int shrinker_id)
+void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
-	return shrinker_id % SHRINKER_UNIT_BITS;
-}
+	struct shrinker_info_unit *unit;
 
-static inline int calc_shrinker_id(int index, int offset)
-{
-	return index * SHRINKER_UNIT_BITS + offset;
-}
+	if (shrinker_id < 0 || !memcg || mem_cgroup_is_root(memcg))
+		return;
 
-void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
-{
-	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
-		struct shrinker_info *info;
+	unit = shrinker_unit_get(memcg, nid, shrinker_id);
+	if (WARN_ON_ONCE(!unit))
+		return;
 
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
+	/* Pairs with smp mb in shrink_slab() */
+	smp_mb__before_atomic();
+	set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
 }
 
 static DEFINE_IDR(shrinker_idr);
@@ -270,52 +208,44 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
 static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 				   struct mem_cgroup *memcg)
 {
-	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
-	long nr_deferred;
 
-	rcu_read_lock();
-	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
-	rcu_read_unlock();
+	unit = shrinker_unit_get(memcg, nid, shrinker->id);
+	if (WARN_ON_ONCE(!unit))
+		return 0;
 
-	return nr_deferred;
+	return atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
 }
 
 static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 				  struct mem_cgroup *memcg)
 {
-	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
-	long nr_deferred;
 
-	rcu_read_lock();
-	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred =
-		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
-	rcu_read_unlock();
+	unit = shrinker_unit_get(memcg, nid, shrinker->id);
+	if (WARN_ON_ONCE(!unit))
+		return 0;
 
-	return nr_deferred;
+	return atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
 }
 
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
-	int nid, index, offset;
-	long nr;
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-	struct shrinker_info *child_info, *parent_info;
 	struct shrinker_info_unit *child_unit, *parent_unit;
+	unsigned long index;
+	int nid, offset;
+	long nr;
 
 	/* Prevent from concurrent shrinker_info expand */
 	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
-		child_info = shrinker_info_protected(memcg, nid);
-		parent_info = shrinker_info_protected(parent, nid);
-		for (index = 0; index < shrinker_id_to_index(child_info->map_nr_max); index++) {
-			child_unit = child_info->unit[index];
-			parent_unit = parent_info->unit[index];
+		struct xarray *parent_units = &parent->nodeinfo[nid]->shrinker_units;
+
+		xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, child_unit) {
+			parent_unit = xa_load(parent_units, index);
+			if (WARN_ON_ONCE(!parent_unit))
+				continue;
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
 				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
@@ -485,9 +415,9 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			struct mem_cgroup *memcg, int priority)
 {
-	struct shrinker_info *info;
-	unsigned long ret, freed = 0;
-	int offset, index = 0;
+	struct shrinker_info_unit *unit;
+	unsigned long index, ret, freed = 0;
+	int offset;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
@@ -495,51 +425,17 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	/*
 	 * lockless algorithm of memcg shrink.
 	 *
-	 * The shrinker_info may be freed asynchronously via RCU in the
-	 * expand_one_shrinker_info(), so the rcu_read_lock() needs to be used
-	 * to ensure the existence of the shrinker_info.
-	 *
-	 * The shrinker_info_unit is never freed unless its corresponding memcg
-	 * is destroyed. Here we already hold the refcount of memcg, so the
-	 * memcg will not be destroyed, and of course shrinker_info_unit will
-	 * not be freed.
+	 * A unit is only freed together with its memcg, and the caller holds
+	 * a reference to the memcg, so the units found by xa_for_each() stay
+	 * valid without the RCU lock and do_shrink_slab() may sleep.
 	 *
-	 * So in the memcg shrink:
-	 *  step 1: use rcu_read_lock() to guarantee existence of the
-	 *          shrinker_info.
-	 *  step 2: after getting shrinker_info_unit we can safely release the
-	 *          RCU lock.
-	 *  step 3: traverse the bitmap and calculate shrinker_id
-	 *  step 4: use rcu_read_lock() to guarantee existence of the shrinker.
-	 *  step 5: use shrinker_id to find the shrinker, then use
-	 *          shrinker_try_get() to guarantee existence of the shrinker,
-	 *          then we can release the RCU lock to do do_shrink_slab() that
-	 *          may sleep.
-	 *  step 6: do shrinker_put() paired with step 5 to put the refcount,
-	 *          if the refcount reaches 0, then wake up the waiter in
-	 *          shrinker_free() by calling complete().
-	 *          Note: here is different from the global shrink, we don't
-	 *                need to acquire the RCU lock to guarantee existence of
-	 *                the shrinker, because we don't need to use this
-	 *                shrinker to traverse the next shrinker in the bitmap.
-	 *  step 7: we have already exited the read-side of rcu critical section
-	 *          before calling do_shrink_slab(), the shrinker_info may be
-	 *          released in expand_one_shrinker_info(), so go back to step 1
-	 *          to reacquire the shrinker_info.
+	 * The shrinker is found by id under the RCU lock, and
+	 * shrinker_try_get() pins it before the lock is dropped;
+	 * shrinker_put() wakes up the waiter in shrinker_free() by calling
+	 * complete() when the last reference goes. The next shrinker comes
+	 * from the bitmap, not from this shrinker, so nothing else is needed.
 	 */
-again:
-	rcu_read_lock();
-	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	if (unlikely(!info))
-		goto unlock;
-
-	if (index < shrinker_id_to_index(info->map_nr_max)) {
-		struct shrinker_info_unit *unit;
-
-		unit = info->unit[index];
-
-		rcu_read_unlock();
-
+	xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, unit) {
 		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
@@ -594,12 +490,8 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			freed += ret;
 			shrinker_put(shrinker);
 		}
-
-		index++;
-		goto again;
 	}
-unlock:
-	rcu_read_unlock();
+
 	return freed;
 }
 #else /* !CONFIG_MEMCG */

-- 
2.43.0


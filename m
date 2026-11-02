Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793661225;
	b=aTAohUEj6CrjMXJK39SAhq52xO9IcDYz4NBWJbzgDTlOxLlEQzqQ4VQI0Diuy+isx4hC
	 /xkyqII/utTgmJch9r2mCqRlm3GuYZPL5QLnD31mh15EGe9f/abU1iQ3uSkJLLh9T2oNd
	 6NdLuga+9m5DoX8LHoLkXk06CK09d5ldaxIqftaoE1v1ujhgDXlFPxOx8ejKvdqatzAw2
	 MONddMYlWYujBMKkXQP6dfApER0bbHnf/Mdr9TyZzOOUfMc1tMrO6GSUV/NKa9E9uRFST
	 dz+jDR3D3EVSbvPuvH3N+xzqJixJ9pl5JzSkP8/msb9HJ6/8LGFLrgnqRBIWJOGbQnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793661225;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=1dQznKM/Ruj4XXLjd+8qynNdAfl/sX4R3BCcV9HK8vw=;
	b=DGXMPlCBl2Wlb1V2Xx1E5i8gPnaFTg58puqPLA26oITU2ATB+Qc1yxKPqkTdjwAM/IVm
	 Xf6GmP/w3Ia4nezu9Gki7PR//bsYjZsJmaDfkKEvWL6AgcsaGmfaD65jAaVM6G/JSVs33
	 K3T1FGIix+JonKCMshNH0/ZdPaAfiFz9MLklwzR+KBtMy7MB1z/T2qms5fexm0O/NiyVx
	 ngWfO0rCuai7WdVb+pHZ5o/ahDkrjf5GnaTtvB4m/+2Rd2qI+I+1fHT2jo+iefhOpEq4R
	 UvIv7945t5pDE04cnPYyqfSopErg8nI6emaT21wxbIb5weZ5ci4rCB1TbUluLDYUBkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=KAk8sj6U;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F93E606A329;
	Mon,  2 Nov 2026 23:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F93E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=KAk8sj6U
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=1dQznKM/Ruj4XXLjd+8qynNdAfl/sX4R3BCcV9HK8vw=; b=KAk8sj6UYf9cy8dxsR1
	8+DsB/oFp5b1f0VU0ZJc2SwCjRPWKZsRzzXEs40uscCFbY+zvR6t02FrIzZBI72vaKZUb2jwcsBtV
	z75bTSDFBkU838iJ2Mrj3i+uWNsggGkZPzq+HYhyXOmmEfCxiLf5qd1fGfWDqrk68802SDH41nH96
	uCLVV6ldb3j0u6R2MkxhQyO3ipC71m4jzT8gWA1rCe63C1V8XGhsNCoCPPSbbYIieNnIjIJ5XqI1A
	D8EUt2nS8gcszbD7dWGVMgGAM/5WNcCCz9GdbwSFbvPBlvWtitd7wb6OflVyVYFNtybAzE2R7JIdb
	6nBKKkdOuHkB6hg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xO19b-00Ael5-1M;
	Tue, 03 Nov 2026 00:13:20 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Tue, 03 Nov 2026 00:13:20 +0100
Subject: [PATCH v2 2/2] mm/shrinker: allocate the per-memcg shrinker units
 on demand
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
Message-Id: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-2-cf9b836859c5@virtuozzo.com>
References: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-0-cf9b836859c5@virtuozzo.com>
In-Reply-To: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-0-cf9b836859c5@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10911;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=jCwMxP20kRw1psZhpOwznpopT10gazD5dWXwFJ1gcrg=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq6RkX0tPj+axbFnPpbBL4goEUFpadn/XrPZupb
 1cQnDrPmoaJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCaukZFwAKCRBRlgpH+WFc
 KqabEAC21G3UBBvsIH7gnyMfVEtohLSBN9kV6MwBIlYJ+FbeFXf+fUOTotkeF0NRZUz/ieaI7ys
 JBErO92bzeDC52ZsB+Ituh0n1mTiatrXARZMpXb1OyL9S4S5JCUOnV5m7QvJBpvRqKVEMMcgbCb
 MYz5331P02d3OROpfdB5xlnSsuNsQ4Sf4oEVcLw59vBxm66RaaGmirzA+uVEHT1/0439bq0HG1M
 ART3IyEdAjIc4kuU4RTSeyOIA9KjoAhiJG/fbQhNRVLId6A0yI78PdTOK1+K3Kvp0Cjz4pHDTTh
 XEqxOq49xzahYBInrlYaWImD7IMdJo+jpb50GC/IYfkhfpdO0cBjEfBirUU44s8/atLYgVn/jtT
 LSx47T0oCne7+iKZmzlOVTQvWKVxDScyQQ45r9cLlwhxZHPPOBstsOMkxE/yyBv38+K55ltjkw1
 M4EHINSaNKhb1VWcoXaZ0jqM8ITiRtKDu3dM79PZLQpZWcMvntwxr1fYrepNJEKRR/poMNUB44b
 QQKZjqnKcQRQtxIvFtRltBJk10IvPY6vsLZR6ZNUNuD69reAtueejlK7dga3OhYEOo5sstUc438
 RGRhIUjkmYFSjYgNV0UuOX9sZNMlPRhfDOQ9dcK2uu78ydmLJJJ0LwJaPrX9/sojbZRd7l7TnYf
 HS5qcx6qmgb9fFg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Instead of a shrinker_info_unit for every SHRINKER_UNIT_BITS ids up to
shrinker_nr_max on every NUMA node, give a memory cgroup only the units
of the shrinkers it or one of its descendants holds a list_lru list of.

The rule the code relies on:

  A non-root memcg that has a list on a list_lru has the unit of that
  list's shrinker, on every node.

The unit is installed before the list is published and lives until the
memcg is freed, so set_shrinker_bit() always finds it. A reader that
finds none knows the memcg never held objects of that shrinker.

Two cases outside the rule:
- the root memcg, where global reclaim keeps the deferred work of
  memcg-aware shrinkers; it gets every unit up front and is the only
  memcg a shrinker registration still visits;
- under cgroup.memory=nokmem a list_lru is never per-memcg, so it gets
  no shrinker id either and no bit can be set.

The install runs with the gfp of the list allocation and can sit under
the i_pages lock, which is taken from interrupts, so the xarray lock is
irq-safe and a node it could not get under the lock is allocated
outside of it, as list_lru does for its own xarray.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |   2 +
 mm/list_lru.c              |  20 ++++++---
 mm/memcontrol.c            |   7 +--
 mm/shrinker.c              | 109 ++++++++++++++++++++++++++-------------------
 4 files changed, 80 insertions(+), 58 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 61dd6d06897d8..ea2c099005947 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1720,6 +1720,8 @@ static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 
 void shrinker_unit_cache_init(void);
 int alloc_shrinker_info(struct mem_cgroup *memcg);
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc7..4be22c5238f98 100644
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
@@ -666,18 +672,20 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	int i;
 
 #ifdef CONFIG_MEMCG
+	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+		memcg_aware = false;
+
 	/*
 	 * If the shrinker fell back to being non-memcg-aware (e.g. with
-	 * cgroup.memory=nokmem), its id was never assigned and holds a
-	 * stale 0. Don't let set_shrinker_bit() act on it.
+	 * cgroup.memory=nokmem), its id is not valid. Don't let
+	 * set_shrinker_bit() act on it, nor on a list that is not
+	 * per-memcg: such a list gets no shrinker units.
 	 */
-	if (shrinker && (shrinker->flags & SHRINKER_MEMCG_AWARE))
+	if (shrinker && memcg_aware &&
+	    (shrinker->flags & SHRINKER_MEMCG_AWARE))
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
-
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
-		memcg_aware = false;
 #endif
 
 	lru->node = kzalloc_objs(*lru->node, nr_node_ids);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1d4cab2e3f369..1a582be5a75bb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4219,7 +4219,7 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	INIT_LIST_HEAD(&pn->objcg_list);
 
 	lruvec_init(&pn->lruvec);
-	xa_init(&pn->shrinker_units);
+	xa_init_flags(&pn->shrinker_units, XA_FLAGS_LOCK_IRQ);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
@@ -4386,11 +4386,6 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	memcg_online_kmem(memcg);
 
-	/*
-	 * A memcg must be visible for expand_shrinker_info()
-	 * by the time the maps are allocated. So, we allocate maps
-	 * here, when mem_cgroup_iter() can't skip it.
-	 */
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 74fc6f64459f0..3d55a1ed1f986 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -42,31 +42,38 @@ static struct shrinker_info_unit *shrinker_unit_get(struct mem_cgroup *memcg,
 }
 
 /*
- * A memcg is visible to expand_shrinker_info() before it goes online, so
- * a unit may already be there from either side.
+ * Installs run with the caller's gfp, possibly under the i_pages lock, which
+ * is taken from interrupts: hence the irq-safe lock and xas_nomem().
  */
-static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index)
+static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index,
+				 gfp_t gfp)
 {
-	struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
+	XA_STATE(xas, &memcg->nodeinfo[nid]->shrinker_units, index);
 	struct shrinker_info_unit *unit;
-	int ret;
+	unsigned long flags;
 
-	if (xa_load(units, index))
+	if (xa_load(xas.xa, index))
 		return 0;
 
-	unit = kmem_cache_alloc_node(shrinker_unit_cachep,
-				     GFP_KERNEL | __GFP_ZERO, nid);
+	unit = kmem_cache_alloc_node(shrinker_unit_cachep, gfp | __GFP_ZERO,
+				     nid);
 	if (!unit)
 		return -ENOMEM;
 
-	ret = xa_insert(units, index, unit, GFP_KERNEL);
-	if (ret) {
+	do {
+		xas_lock_irqsave(&xas, flags);
+		if (!xas_load(&xas)) {
+			xas_store(&xas, unit);
+			if (!xas_error(&xas))
+				unit = NULL;
+		}
+		xas_unlock_irqrestore(&xas, flags);
+	} while (xas_nomem(&xas, gfp));
+
+	if (unit)
 		kmem_cache_free(shrinker_unit_cachep, unit);
-		if (ret == -EBUSY)
-			ret = 0;
-	}
 
-	return ret;
+	return xas_error(&xas);
 }
 
 static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
@@ -75,7 +82,8 @@ static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
 
 	for_each_node(nid) {
 		for (index = start; index < end; index++) {
-			ret = shrinker_unit_install(memcg, nid, index);
+			ret = shrinker_unit_install(memcg, nid, index,
+						    GFP_KERNEL);
 			if (ret)
 				return ret;
 		}
@@ -84,14 +92,12 @@ static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
 	return 0;
 }
 
-static void __free_shrinker_info(struct mem_cgroup *memcg)
+void free_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct shrinker_info_unit *unit;
 	unsigned long index;
 	int nid;
 
-	lockdep_assert_held(&shrinker_mutex);
-
 	for_each_node(nid) {
 		struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
 
@@ -101,22 +107,22 @@ static void __free_shrinker_info(struct mem_cgroup *memcg)
 	}
 }
 
-void free_shrinker_info(struct mem_cgroup *memcg)
-{
-	mutex_lock(&shrinker_mutex);
-	__free_shrinker_info(memcg);
-	mutex_unlock(&shrinker_mutex);
-}
-
+/*
+ * Global reclaim keeps the deferred work of memcg-aware shrinkers in the
+ * root's units, and root has no list_lru allocation to install them from.
+ */
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int ret;
 
+	if (!mem_cgroup_is_root(memcg))
+		return 0;
+
 	mutex_lock(&shrinker_mutex);
 	ret = shrinker_units_install(memcg, 0,
 				     shrinker_id_to_index(shrinker_nr_max));
 	if (ret)
-		__free_shrinker_info(memcg);
+		free_shrinker_info(memcg);
 	mutex_unlock(&shrinker_mutex);
 
 	return ret;
@@ -124,26 +130,15 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 
 static int expand_shrinker_info(int new_id)
 {
-	int ret = 0;
 	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
-	struct mem_cgroup *memcg;
-
-	if (!root_mem_cgroup)
-		goto out;
+	int ret = 0;
 
 	lockdep_assert_held(&shrinker_mutex);
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
-	do {
-		ret = shrinker_units_install(memcg,
+	if (root_mem_cgroup)
+		ret = shrinker_units_install(root_mem_cgroup,
 					     shrinker_id_to_index(shrinker_nr_max),
 					     shrinker_id_to_index(new_nr_max));
-		if (ret) {
-			mem_cgroup_iter_break(NULL, memcg);
-			goto out;
-		}
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-out:
 	if (!ret)
 		shrinker_nr_max = new_nr_max;
 
@@ -211,7 +206,8 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 	struct shrinker_info_unit *unit;
 
 	unit = shrinker_unit_get(memcg, nid, shrinker->id);
-	if (WARN_ON_ONCE(!unit))
+	/* No unit: this memcg never held objects of this shrinker. */
+	if (!unit)
 		return 0;
 
 	return atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
@@ -223,12 +219,35 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 	struct shrinker_info_unit *unit;
 
 	unit = shrinker_unit_get(memcg, nid, shrinker->id);
-	if (WARN_ON_ONCE(!unit))
+	if (!unit)
 		return 0;
 
 	return atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
 }
 
+/*
+ * Called before @memcg gets a list on a list_lru of shrinker @shrinker_id:
+ * a map bit is only ever set on a memcg that has such a list.
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
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
@@ -237,14 +256,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 	int nid, offset;
 	long nr;
 
-	/* Prevent from concurrent shrinker_info expand */
-	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
 		struct xarray *parent_units = &parent->nodeinfo[nid]->shrinker_units;
 
 		xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, child_unit) {
 			parent_unit = xa_load(parent_units, index);
-			if (WARN_ON_ONCE(!parent_unit))
+			/* Installed but never listed: nothing deferred in it. */
+			if (!parent_unit)
 				continue;
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
@@ -252,7 +270,6 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	mutex_unlock(&shrinker_mutex);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)

-- 
2.43.0


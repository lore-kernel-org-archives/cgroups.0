Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792431578;
	b=BCqhfBzKIvmcXbMtONp9DvHwh6+bEI/BG4kvRnZ6egHu5oVZYjDIkzk0kiXGKuoUsdkz
	 Nqo4Eg5sWG7mpHnlwGOXTTfSICWyQBuXqz4noKO9iUcZsLMCV5WRHYhEpa+nAHazCR/Yv
	 q0A/vDpU8WLQIq/RW3hv4c9t+Ck8L1p0Ug4IobtvH3gj+uJf4i5ILN+jEp4RbRBGFd+Yn
	 8CcVVTgWgwT59MsR2QlEI6ei/lY7/JtvrgVeK83ufNml7/5700gTxADHgoFg0Xe6RWW5J
	 EiNBxdiSUdVJr944gobv6Q/SvN+CO3DJbj7uE1KYdC998K4ByygVYrpsGb6c0fMg2ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792431578;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=L564zTSbyW7RsQ72MGvk0hgr14JcFjENwmP8MEdxbFQ=;
	b=rXQNs9s1DohClxtt8OuSBKTE9T9pJ1HyTFQfE5+yVFUvNhlxjsLNSOqzmyvYKwfFFqZ/
	 vKrUMvH4A4+ncMpAgJdS9BW1gAdoFiGzoLmJg9AZWOkY2E7yEYstvLM7Qr23ZIBVj13Yx
	 e45mGmUNF3MSZyzGkb8NuwoQrZteNYSQEWF8qc1rAF+3U2Lh3617spjWYFgzszDDxgk+0
	 cwqdBcVa7LIk99X+69sJnoNgIRBvzb310ix1Hrq7mYXQ1GDMpi1KQBxbSDhx4FvyZCxOk
	 AK9x2RCktvDmGWQ1+fnvFoUQCmDylomcRCHeFeD8L64qtt8H6a20rpERoYYnDhqkPaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=vmanoCTZ;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF07F606A322;
	Mon, 19 Oct 2026 17:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF07F606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=vmanoCTZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=L564zTSbyW7RsQ72MGvk0hgr14JcFjENwmP8MEdxbFQ=; b=vmanoCTZLSykPeQZOht
	UIzzTqhnlp9Dvheg7yDZHaUcJNRhXXUFedv6Pzil5NCweL918SkROF2iGIhpfH/VfePskLpBvCHbd
	1AhEkzUiPhVMgQOMjsaQfykeq2zE1xW+ZzAp8LejrA6wLCZDFY3Zqxlne7enIfkqZaJT2ZHfSlQpj
	zBoQJfniR3MPA4ZgaUb/MZ0o+X5t5g2RIsWyHDDHN4PJYlSWRpx9trrs8A3DwjvZoPH+oSKBnDcfq
	iSTiTOw+Xst0BD8ixRMj8Boq3+XN52iK+pH2IJnVf3FlwP1EwYJLTleO1v4UiJ3F++pkI+YkIqegU
	Wwr+GQgtkoWF9qQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIrH2-007Chf-0H;
	Mon, 19 Oct 2026 19:39:20 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 19 Oct 2026 19:39:24 +0200
Subject: [PATCH 2/2] mm/shrinker: allocate the per-memcg shrinker units on
 demand
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
Message-Id: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-2-64ed1f7957c9@virtuozzo.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9941;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=8uo6nmMfK1qRCkrTayzRsZZFLXg9ry/A/NIJpkUVam4=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq1lXPUfI/6sjDSwTkjjRqO/jqCNpkqD/v1yAaF
 wkBa66nkuuJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZVzwAKCRBRlgpH+WFc
 Khv8EACI13FKl26bLsJYggvCcjvmFoS/TptyzXRBL9LYsrzPtBtXsdLXs99WMwofIaQZgIOZmCC
 ALjUpX8BZebK5zCQbc7iaVLougI3YM5UmGy+VjHv01YUaU4BzdczUn2Oys62fXspLMRa5bNVzNJ
 GSPNghqASJ7ptVPGddeFTKAvbcaBkYCB8+bHd+7uglcf4ZK+pinhF4fZLtAy8vH+2QmsfuNd6oh
 Svtibcc3C2BMyrPMOyVnzaTv1MEOBjQhUbJZ0wrS/RTnDe+L98f5gkMDappAWW8diBLyMT9dqfd
 ywFgzU1+qiEmxflGkSsPz5Ptx9Y0ccEbcxRgyICZynDFEBNXSw8CCCRTMG9Yk4BRnIR91rLDnnv
 H0CxfyOUMIVyjqd4r6GkatGfTD09Ktv92tbyhZ5r6/oL0X1y7ti7Wso0bw8aLEvPqEj6p4Kn98h
 utEs2R3MoDzEPLkZmOX1BlZu1WVSIqemB+pbu7FWRPN/NNZvdf9ARKarGYhjo2Kyi0AWR+ryBz1
 6Go1aefBGKhaQu3BLgA9x5i2oOg4KFcs+s5SuiKXUTsrWRUtsDsRsoZrIQbmfhWvrfM5livqjzs
 O5t+DkPAgcDkmGuXGWe+FqbqY3ALVX5WvGD6PgkKdy0HFz1IkkBdw2q9xIW8dbqgnr+I0DmIFGe
 lGL+b3zu3il/PjQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Instead of a shrinker_info_unit for every SHRINKER_UNIT_BITS ids up to
shrinker_nr_max on every NUMA node, give a memory cgroup only the units
of the shrinkers it holds a list_lru list of.

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

The units of a memcg now scale with the shrinkers it and its
descendants hold objects of, not with shrinker_nr_max.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |  2 +
 mm/list_lru.c              | 15 +++++--
 mm/memcontrol.c            |  7 +---
 mm/shrinker.c              | 98 +++++++++++++++++++++++++++++-----------------
 4 files changed, 77 insertions(+), 45 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 52f3646e244ae..91641cf082a4a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1678,6 +1678,8 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
 
 void shrinker_unit_cache_init(void);
 int alloc_shrinker_info(struct mem_cgroup *memcg);
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..73480d8edf641 100644
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
@@ -666,13 +672,14 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	int i;
 
 #ifdef CONFIG_MEMCG
-	if (shrinker)
+	if (mem_cgroup_kmem_disabled())
+		memcg_aware = false;
+
+	/* A list that is not per-memcg sets no memcg's shrinker bit. */
+	if (shrinker && memcg_aware)
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
-
-	if (mem_cgroup_kmem_disabled())
-		memcg_aware = false;
 #endif
 
 	lru->node = kzalloc_objs(*lru->node, nr_node_ids);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a13f3984f0e09..07075bb220719 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4110,7 +4110,7 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	INIT_LIST_HEAD(&pn->objcg_list);
 
 	lruvec_init(&pn->lruvec);
-	xa_init(&pn->shrinker_units);
+	xa_init_flags(&pn->shrinker_units, XA_FLAGS_LOCK_IRQ);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
@@ -4277,11 +4277,6 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	memcg_online_kmem(memcg);
 
-	/*
-	 * A memcg must be visible for expand_shrinker_info()
-	 * by the time the maps are allocated. So, we allocate maps
-	 * here, when mem_cgroup_iter() can't skip it.
-	 */
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 74fc6f64459f0..cd9441f149363 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -42,31 +42,40 @@ static struct shrinker_info_unit *shrinker_unit_get(struct mem_cgroup *memcg,
 }
 
 /*
- * A memcg is visible to expand_shrinker_info() before it goes online, so
- * a unit may already be there from either side.
+ * Installs run from the list_lru allocation path with the caller's gfp,
+ * possibly under the i_pages lock, which is taken from interrupts: the
+ * xarray lock is irq-safe and a node it could not get under the lock is
+ * allocated outside of it.
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
@@ -75,7 +84,8 @@ static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
 
 	for_each_node(nid) {
 		for (index = start; index < end; index++) {
-			ret = shrinker_unit_install(memcg, nid, index);
+			ret = shrinker_unit_install(memcg, nid, index,
+						    GFP_KERNEL);
 			if (ret)
 				return ret;
 		}
@@ -108,10 +118,17 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 	mutex_unlock(&shrinker_mutex);
 }
 
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
@@ -124,26 +141,15 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 
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
 
@@ -211,7 +217,8 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 	struct shrinker_info_unit *unit;
 
 	unit = shrinker_unit_get(memcg, nid, shrinker->id);
-	if (WARN_ON_ONCE(!unit))
+	/* No unit: this memcg never held objects of this shrinker. */
+	if (!unit)
 		return 0;
 
 	return atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
@@ -223,12 +230,35 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
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
@@ -237,14 +267,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
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
@@ -252,7 +281,6 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	mutex_unlock(&shrinker_mutex);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)

-- 
2.43.0


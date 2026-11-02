Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793661225;
	b=AtT2QerktlXwe6ItVur6o8AYFMAu3U8MbFPkFy5cTNQTeKHeQAkmWNZWYO7xqLnTtVbt
	 Nzdax9GmIols+CZlsAAdoH6ORphGFr4YEXZOFAY6xYrJU8X4DkURCz/Bu6RtuHZ2ciBNB
	 Q7yQUrzXPIPLXEnBIjPopfwF+Jw2eFy/CrsEOODNOqVB5iglTb3xICVc/w5WHRr7gR9Or
	 yacsP9EBnbris7Pc91cqZfoTXy1xV7lS3hJocxOer9c2zywvIamUtC0R5Mf6bGxTQI6T8
	 S25mPzWwjTr0sY7lMWoYLyDD/NuYeBJ96xviMJmKFajILkBSPA65g/VAU4A7ScU3BCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793661225;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Lj7aGfdx9PDf82bctHONzhhanDhKc0G2d51SLeBZGW4=;
	b=a5asMIcQ1u9vy92vqABtJjB7EBbHKDJxQ+0o5CiTJ8/m6l8D8JVR4+DapeKkgFLduaqt
	 xPHBPPPP6ndf90FUhVp2MXHV0zVWTtwvAk1D8oIqjbYpZXsj98YgtO2lGeSWnq9/ygmmy
	 HOrgdnAXLGLF8Ak84FKDI1ede+tvr9Ujb4st709TMXTeTDyIgzrrPAL9iKNQ1EbFb9pAL
	 ozeYvQuvg0mIVd1G6ayFSN8oKCqsOpM/WTOaHkY5TvR56lcyq6tspXm1BWaqwPL2OFR2K
	 egFfgfaY0f3Bcnp3RhN1CB1zhAwyXbTJY9ItXJjXFG8KuSBl7CsNFQ2sE3WpndU1PkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=OpKQ1FQA;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F891606A327;
	Mon,  2 Nov 2026 23:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F891606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=OpKQ1FQA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=Lj7aGfdx9PDf82bctHONzhhanDhKc0G2d51SLeBZGW4=; b=OpKQ1FQAAtnQm4DcisH
	OxLkTvwm4bsXDiphSs7yYIEjUz6N9dryyyh578aC1rbhMx1oeRC3sjMBDcd+/+ie9DlRSnxD173HM
	7tw4yRDlvUh3uP3hNzhMljj2qi6RR9ALFBCwuHppJOK9Cuk8b/8rbD5WV3we5wkmYhgS4Iz6kCNka
	eijQbnZvTYDMIkp+w3lWtI1VpfNP/Jj/k6nloWcEvXHUuIl8MWvShu5J9fmWgh9tpZQu/C9gjjQWB
	2SYDuLUA7T/J2PoqxGMwjyBxWHXOYjLP+meWBVloX/ZkZReZPWxDr8TGHQ3/jBWX5LnSoZfn7FP1O
	GnC1ewHFaZlDQNw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xO19a-00Ael5-38;
	Tue, 03 Nov 2026 00:13:20 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Tue, 03 Nov 2026 00:13:19 +0100
Subject: [PATCH v2 1/2] mm/shrinker: keep the per-memcg shrinker units in
 an xarray
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
Message-Id: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-1-cf9b836859c5@virtuozzo.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=17526;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=ce93Ru5g8bcYpI8VGcVSC/ia92KZeXtJha+bnr7Xtd8=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq6RkXd3gzqUkgFY16Fsf6HBPCGM5S7b/vv6zMX
 mUlzj9fhkeJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCaukZFwAKCRBRlgpH+WFc
 KsdsD/9+1IEmWHZjhtazZC5wlxpRalOhQOS24F41AP2F4wYMdSjb9XH98276Ag0MZHh5B1SROM7
 Yjm9fKpyms3Rd1igA00YzVLYJQkVPvfyUEaGnkFrNun4O0RiB+mpDNUYln4WGU2UvA5ihZMPXuS
 P6v8hWasxky/PcHD8AaOoYWUC27qknuHLJ1r31ZELp1G8gZZQ80HB58uoOTUsVmLFiwySG+JsNW
 vd5q8tAQzkj9mZW/3UW1c1b/qBx9bAw19TDS28QY06INzEkIuHsW9Lcz5+/7BzlP+XIsWk/pP5e
 9h+70A4elESOetcpNIXPqUZQW1QpK5XPrKXLEz7Sy9dFQLxmfgX7Ez2k4nFrwVaGuobFRHN1G/E
 zRXpYK1LiUimCdoRlSuFPzZi+IR6jnrEgx3l9pC18SRuN4P5zd5r9LhLBV0+p0WIQMipUnx0UbW
 yKFDTmgbV7zu00bqBs8+QBiZYFMKnLYdiwpxzOec8cEPmoIClpE1MreiCkB2puAaKNC0yA26vNj
 0ECu/j7175kTBtIZHDim+ElkokhuG+fI59XmiOtzm/CRFos6qOhEEroWe4QD/TyqoUf0oc1NLK5
 I+fk/+EpsB0BEfrFyLxLc+J2Swsy60os36F4Vip9i4Hdqn15Wu+37eMNFX3pDgxMQPl33xbPJI/
 mki0jTc6CkLzJwg==
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

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |   5 +-
 include/linux/shrinker.h   |   6 -
 mm/memcontrol.c            |   3 +-
 mm/shrinker.c              | 312 +++++++++++++++------------------------------
 4 files changed, 107 insertions(+), 219 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c588..61dd6d06897d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -24,6 +24,7 @@
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
 #include <linux/irq_work_types.h>
+#include <linux/xarray.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -83,14 +84,14 @@ struct mem_cgroup_reclaim_iter {
  * per-node information in memory controller.
  */
 struct mem_cgroup_per_node {
-	/* Set when the memcg is created, then only read. */
+	/* Set when the memcg is created, then mostly read. */
 	__cacheline_group_begin_aligned(memcg_pn_read_mostly);
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
-	struct shrinker_info __rcu	*shrinker_info;
+	struct xarray			shrinker_units;
 	struct obj_cgroup __rcu		*objcg;
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
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
index a05d9a8baa1b6..1d4cab2e3f369 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4219,6 +4219,7 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	INIT_LIST_HEAD(&pn->objcg_list);
 
 	lruvec_init(&pn->lruvec);
+	xa_init(&pn->shrinker_units);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
@@ -5925,7 +5926,7 @@ static void __init memcg_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, lruvec_stats);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
-				      memcg_pn_read_mostly, shrinker_info);
+				      memcg_pn_read_mostly, shrinker_units);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, objcg);
 
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


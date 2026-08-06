Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8B536195F
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035556; cv=none; b=ZyFe8qOgQ6Vspi25ajoYaxka0tWg4GwRoAt2aeArSUi57HbxvOOSC0KMRIbnrP/9YVeuDMC619Hj4rWBGYFDoH6lwDDOBMW/wu9WMRSox6Z0emqfROV+dAtu3ZxMI7uDdL4pnUv2kaCIfapcdq5v/lyBR2ghR00e8CJZf84/+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035556; c=relaxed/simple;
	bh=LI7jXuDlS9I2l9Y3bcbJtvnFavQiyaOfDRTGs+++u3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UpquK+KfiOVsIPRyUSQV7NAwK/16i5MoYYxaOmA5fcimSy9BioS+otMy7TAaMeG103o9rFI93y04s/0pZKKMpT7uiCPwRlwdEtmm030ATyc3Z+kCufMQrliaLcq+sukb+qEmMol4/K1fSXyr5ZcN1SByRwnxbeRyGfo0tBu/3Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=br+Np0f+; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="br+Np0f+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786035542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZtOGW7nC7mx1grvKmtWDM3R0MQff7Um4ZczGlYey6rE=;
	b=br+Np0f+FL/MC8TKGp6CdTkZaPKFSEz2++ttU26O0ZmvkwbA1QvrRG/1/V2CL7NuCELe3l
	eviC41E71Z22E4O5jfGnvJ+amz1airMhKRYnhVmofdGWaEweVVRK/DI5VKCbU8jx2eIUVl
	EdC2vapu0DTc0Z6oBpBhbTgnIylKkA8=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] memcg: keep folio's objcg same as its node
Date: Thu,  6 Aug 2026 09:58:13 -0700
Message-ID: <20260806165813.2526415-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
is the objcg of the folio's node.  Folio migration across nodes breaks
that assumption: the new folio simply inherits the old folio's objcg
while living on a different node.

Once the assumption is broken, the reparenting of the folio's objcg and
the reparenting of the folio's LRU list are no longer atomic.
memcg_reparent_objcgs() handles one node per iteration and drops all the
locks in between, so the objcg gets reparented in the iteration for the
objcg's node while the LRU list gets spliced in the iteration for the
folio's node.  Any LRU operation on that folio in between resolves its
lruvec through the objcg, and thus takes the lru_lock of the wrong
memcg, not the lru_lock of the list the folio is actually on.

Fix this by selecting the objcg by folio_nid() at charge time, and by
re-deriving it for the destination node in mem_cgroup_migrate() and
mem_cgroup_replace_folio().

Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---

Changes since v1: http://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev

- In mem_cgroup_migrate, do obj_cgroup_put at the end (Sashiko)
- Handle scenario where destination node has been reparented to the root but the
  source node's objcg has not yet (Sashiko)
- Add comment explaining the race between migration and reparenting (Johannes)

 mm/memcontrol.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3057396dda53..02c108cdd0f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2966,10 +2966,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
 	return folio_memcg_check(virt_to_folio(p));
 }
 
-static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+						      int nid)
 {
-	int nid = numa_node_id();
-
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
 
@@ -2980,12 +2979,13 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 	return NULL;
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+							   int nid)
 {
 	struct obj_cgroup *objcg;
 
 	rcu_read_lock();
-	objcg = __get_obj_cgroup_from_memcg(memcg);
+	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
 	rcu_read_unlock();
 
 	return objcg;
@@ -3029,7 +3029,7 @@ static struct obj_cgroup *current_objcg_update(void)
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
-		objcg = __get_obj_cgroup_from_memcg(memcg);
+		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
 		rcu_read_unlock();
 
 		/*
@@ -5197,7 +5197,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	int ret = 0;
 	struct obj_cgroup *objcg;
 
-	objcg = get_obj_cgroup_from_memcg(memcg);
+	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
 		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
@@ -5408,8 +5408,8 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
  */
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 {
+	struct obj_cgroup *objcg, *new_objcg = NULL;
 	struct mem_cgroup *memcg;
-	struct obj_cgroup *objcg;
 	long nr_pages = folio_nr_pages(new);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
@@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
+
 	/* Force-charge the new page. The old one will be freed soon */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
@@ -5438,7 +5439,31 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
+	/*
+	 * memcg_reparent_objcgs() reparents a node's objcgs and its LRU lists
+	 * together, under that node's lru_locks. If a folio's objcg is on a
+	 * different node, the two happen in separate iterations with the locks
+	 * dropped in between, and an LRU operation in that window takes the
+	 * lru_lock of the wrong memcg. Keep the objcg on the folio's node.
+	 */
+	if (folio_nid(old) != folio_nid(new))
+		new_objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
+
+	/*
+	 * LRU folios are not accounted at the root level: swapping a non-root
+	 * objcg for the root one would skip the uncharge and leak the charge.
+	 * Keep the old one, the root memcg never reparents. No put needed,
+	 * tryget takes no reference on the root objcg.
+	 */
+	if (new_objcg && obj_cgroup_is_root(new_objcg) &&
+	    !obj_cgroup_is_root(objcg))
+		new_objcg = NULL;
+
+	if (new_objcg)
+		objcg = new_objcg;
+	else
+		obj_cgroup_get(objcg);
+
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5457,7 +5482,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *new_objcg = NULL;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5478,12 +5503,29 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
-	/* Transfer the charge and the objcg ref */
-	commit_charge(new, objcg);
+	/* Keep the objcg on the folio's node, see mem_cgroup_replace_folio() */
+	if (folio_nid(old) != folio_nid(new)) {
+		rcu_read_lock();
+		new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(objcg),
+							folio_nid(new));
+		rcu_read_unlock();
+
+		/* No root swap, see mem_cgroup_replace_folio(). */
+		if (new_objcg && obj_cgroup_is_root(new_objcg) &&
+		    !obj_cgroup_is_root(objcg))
+			new_objcg = NULL;
+	}
+
+	/* Transfer the charge and, unless it was swapped, the objcg ref */
+	commit_charge(new, new_objcg ? : objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
 	old->memcg_data = 0;
+
+	/* @new took its own reference, drop @old's. */
+	if (new_objcg)
+		obj_cgroup_put(objcg);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
-- 
2.53.0-Meta


Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F450314A73;
	Fri,  7 Aug 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112679; cv=none; b=bnP5Y+c14Lm1njSwSgxNeQn22cCsll3Ez+D2rjui7KcjBMAbDWGz122/FHYgmoGVZum2Bt3cMkOPXFmUt2E9k2lh3kuS4/EFpTDSfSOvEu9kxtYCuwdT6oA6ljS1PkgJ4ICspLlEOmCl3LPpUEalVnYnbp8z/9FB5KXlmsdbyrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112679; c=relaxed/simple;
	bh=hSbOOdxeh2c4aoqi8moa7i9RrmOM1aCgGf8VDLl4KeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pS4fvyOHKQFuGEgI99MaTW+5WJcuHtvUTewHrmB5e5HMjxAXrwV8QxEKh283Q2MbcDxnFcn5kd0nXnR3ECIFDgHukWvKh8GYNXvoh8pWcImmqGaOm1xJWE2fv032MR0l5VlUbBELx2DJc5/kqoedvYXRGXGmloepgY5+3jg+pXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r+npiZUa; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r+npiZUa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786112674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S04di+PU+lv41Su7yR6P9olfkoO2azm7hS2v5N1fSOs=;
	b=r+npiZUaeM6FZHODkg/p10zCEgVTxdiHOpcEv//SMiYw6+98pojPyGy0NSWiaZDZxjW4sz
	A/4jJf3I+QCQGVks/R1KycB4MquoAO1yAFAjErMJdFU52yEwOVnPP8YDdRef5kUGHCapfc
	0O/1nCbZLFqV5rSt5cX0ofHGtMS37aE=
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
Subject: [PATCH v3] memcg: keep folio's objcg same as its node
Date: Fri,  7 Aug 2026 07:24:05 -0700
Message-ID: <20260807142406.443516-1-shakeel.butt@linux.dev>
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
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---

Changes since v2:
http://lore.kernel.org/20260806165813.2526415-1-shakeel.butt@linux.dev

- Refactor common code between mem_cgroup_replace_folio and mem_cgroup_migrate
  (Johannes)
- Always commit the destination node's objcg. (Johannes)
- In mem_cgroup_replace_folio, force charge based on committed objcg (Johannes)
- In mem_cgroup_migrate, if destination node's objcg is root, uncharge the
  source node's objcg. (Johannes)


Changes since v1:
http://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev

- In mem_cgroup_migrate, do obj_cgroup_put at the end (Sashiko)
- Handle scenario where destination node has been reparented to the root but the
  source node's objcg has not yet (Sashiko)
- Add comment explaining the race between migration and reparenting (Johannes)

 mm/memcontrol.c | 100 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 83 insertions(+), 17 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3057396dda53..7248e7aa4069 100644
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
@@ -5396,6 +5396,46 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 		uncharge_batch(&ug);
 }
 
+/*
+ * An LRU folio must hold the objcg belonging to its own node.
+ *
+ * memcg_reparent_objcgs() reparents a dying cgroup one node at a time: the
+ * folios on that node's LRU lists move to the parent and that node's objcg is
+ * redirected to the parent, atomically under the node's lru_lock.
+ * folio_lruvec_lock() relies on this to provide a stable folio<->lruvec
+ * binding. If a folio holds another node's objcg, its list membership and its
+ * lruvec resolution change in separate lock sections, and an LRU operation in
+ * between can re-add the folio to, and strand it on, the LRU list of a dead
+ * memcg.
+ *
+ * So when migration transfers the memcg state to a folio on another node,
+ * re-derive the objcg for the destination node. If the memcg is dying and the
+ * destination node has already been reparented, the lookup walks up to the
+ * nearest live ancestor - which is also where that node's LRU lists went.
+ *
+ * Returns the objcg to commit to @new, with a reference for the caller.
+ */
+static struct obj_cgroup *get_migration_objcg(struct folio *old,
+					      struct folio *new)
+{
+	struct obj_cgroup *old_objcg, *new_objcg;
+	int new_nid = folio_nid(new);
+
+	old_objcg = get_obj_cgroup_from_folio(old);
+
+	if (folio_nid(old) == new_nid)
+		return old_objcg;
+
+	rcu_read_lock();
+	new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						new_nid);
+	rcu_read_unlock();
+
+	obj_cgroup_put(old_objcg);
+
+	return new_objcg;
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5424,21 +5464,28 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	if (folio_memcg_charged(new))
 		return;
 
-	objcg = folio_objcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!objcg, old);
-	if (!objcg)
+	VM_WARN_ON_ONCE_FOLIO(!folio_objcg(old), old);
+	if (!folio_objcg(old))
 		return;
 
+	objcg = get_migration_objcg(old, new);
+
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	/* Force-charge the new page. The old one will be freed soon */
+
+	/*
+	 * Force-charge the new page. The old one will be freed soon.
+	 *
+	 * The rootness of the committed objcg decides whether the final
+	 * uncharge of @new goes through the page counters (see
+	 * uncharge_folio()); charge them only if the uncharge will.
+	 */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5450,14 +5497,15 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
  * @new: Replacement folio.
  *
  * Transfer the memcg data from the old folio to the new folio for migration.
- * The old folio's data info will be cleared. Note that the memory counters
- * will remain unchanged throughout the process.
+ * The old folio's data info will be cleared. The memory counters remain
+ * unchanged, unless the charge moves out of a fully reparented ancestry
+ * and has to be settled (see below).
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *new_objcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5478,12 +5526,30 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
-	/* Transfer the charge and the objcg ref */
-	commit_charge(new, objcg);
+	new_objcg = get_migration_objcg(old, new);
+
+	/*
+	 * @old was charged through a non-root objcg, so its charge is in the
+	 * page counters. If the re-derivation walked up to the root objcg -
+	 * @old's entire ancestry is dying and already reparented - the final
+	 * uncharge of @new will skip the page counters (see uncharge_folio()).
+	 * Settle them now: this is @old's eventual uncharge, moved up to the
+	 * point where its charge record ends.
+	 */
+	if (obj_cgroup_is_root(new_objcg) && !obj_cgroup_is_root(objcg)) {
+		rcu_read_lock();
+		memcg_uncharge(obj_cgroup_memcg(objcg), folio_nr_pages(old));
+		rcu_read_unlock();
+	}
+
+	commit_charge(new, new_objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
 	old->memcg_data = 0;
+
+	/* @new holds its own reference now, drop @old's */
+	obj_cgroup_put(objcg);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
-- 
2.53.0-Meta


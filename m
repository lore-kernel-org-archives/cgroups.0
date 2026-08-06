Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C32F8EBE
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 06:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785997131; cv=none; b=Is4yje5BklP/MrZ0V6uYZ+z9Br4NxAukACmM8MkM1yD06hITBolQMcGVBQ7daojTDmQW1ggjRdgrRMl2rud7sNrhYUYqqoLvZdWTQIJrNfTy6RFN2EOn3OQdpRlq+cT1TXsM5E06fab2eh3mEFlwgOojIvy+uyjiqtzyATEJTzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785997131; c=relaxed/simple;
	bh=zNYfZWs6B9QwBnV/bQWtsRnzagfVUjTdWYjnto/dGXw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NCJrtf4wgSBOLYId0aG9LfDvai4Q+jeF9cYiqQJYqif85odLD07AXvuhMwFYI1go/lcIZoKb4K4XYBK9Vbfh9AOxAzIE6KkoyEaySgjcrZfqNxAECbkDZy83L7+Y8+T4ReA1mxc8ee8WSBhUfLKHLc2DHan3CURiAGgYdFrS2mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AQRwtam9; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AQRwtam9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785997122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P+ldPohuWQENIni4PGzfc5Oh7ThBEFWNMfFXg+P+C+o=;
	b=AQRwtam90kkDWgMb2odt6wcpqyfUKxMWoX9Vf7r6aS+bJeteNNI1oUoD9fT5pM8scVRXzb
	dldgiO58uE7+sjGs0S8NeJ+dkK+wCJRVMFGqqCg3FI0qWMk1UdGBitt+IvvJo9d4FQ5QHr
	m35uRuWc1EDZT1/STIfrFRsP5pBmYqk=
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
Subject: [PATCH] memcg: keep folio's objcg same as its node
Date: Wed,  5 Aug 2026 23:18:30 -0700
Message-ID: <20260806061830.3294679-1-shakeel.butt@linux.dev>
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
 mm/memcontrol.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3057396dda53..2e98788dc8bd 100644
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
@@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
+
 	/* Force-charge the new page. The old one will be freed soon */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
@@ -5438,7 +5439,12 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
+	/* If replacing folio of different node, get objcg of that node. */
+	if (folio_nid(old) != folio_nid(new))
+		objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
+	else
+		obj_cgroup_get(objcg);
+
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5478,6 +5484,17 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
+	/* If migrating to different node, get objcg of that node. */
+	if (folio_nid(old) != folio_nid(new)) {
+		struct obj_cgroup *old_objcg = objcg;
+
+		rcu_read_lock();
+		objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						    folio_nid(new));
+		rcu_read_unlock();
+		obj_cgroup_put(old_objcg);
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
-- 
2.53.0-Meta


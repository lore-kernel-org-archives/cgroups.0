From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2/7] mm: memcontrol: kill mem_cgroup_nodeinfo()
Date: Tue,  2 Feb 2021 13:47:41 -0500
Message-ID: <20210202184746.119084-3-hannes@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zZpcdqBIUeHuRA3ry6psqLVWAEi8jyTeTt09lQraF+c=;
        b=pFBlBbi+hJBi102ivz3tEHlSObS5vUVEGXyRbRzgummggVh/7m310IjtgC0c5SkxI4
         ZwBqqTyEwUsGjXo9z72N4yfm1lTy6QxlimLDLaKHCHpgbcd/5vWVSu0MD0EgclWQcusU
         sC8MZzqg/WGCEvGiILpsgFFvSVDcgpPyAfgoGtr6We7mC9PelfRoA4dkX3xwXXJURd+W
         C6dNlV3YKjirNjhViGWJiOmCS2m8poDXp150V4FPKtwVdXa8SLrGT/8oztQoZeZAhC0h
         spTzo+OGHgdYMWpheVyoIWntjh94cxkF2wMcEHJbfreYpDlVRxLvVDCtR3hlfhu19aer
         Munw==
In-Reply-To: <20210202184746.119084-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

No need to encapsulate a simple struct member access.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/memcontrol.h |  8 +-------
 mm/memcontrol.c            | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7a38a1517a05..c7f387a6233e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -602,12 +602,6 @@ void mem_cgroup_uncharge_list(struct list_head *page_list);
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
-static struct mem_cgroup_per_node *
-mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
-{
-	return memcg->nodeinfo[nid];
-}
-
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
  * @memcg: memcg of the wanted lruvec
@@ -631,7 +625,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+	mz = memcg->nodeinfo[pgdat->node_id];
 	lruvec = &mz->lruvec;
 out:
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8120d565dd79..7e05a4ebf80f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -414,13 +414,14 @@ static int memcg_expand_one_shrinker_map(struct mem_cgroup *memcg,
 					 int size, int old_size)
 {
 	struct memcg_shrinker_map *new, *old;
+	struct mem_cgroup_per_node *pn;
 	int nid;
 
 	lockdep_assert_held(&memcg_shrinker_map_mutex);
 
 	for_each_node(nid) {
-		old = rcu_dereference_protected(
-			mem_cgroup_nodeinfo(memcg, nid)->shrinker_map, true);
+		pn = memcg->nodeinfo[nid];
+		old = rcu_dereference_protected(pn->shrinker_map, true);
 		/* Not yet online memcg */
 		if (!old)
 			return 0;
@@ -433,7 +434,7 @@ static int memcg_expand_one_shrinker_map(struct mem_cgroup *memcg,
 		memset(new->map, (int)0xff, old_size);
 		memset((void *)new->map + old_size, 0, size - old_size);
 
-		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_map, new);
+		rcu_assign_pointer(pn->shrinker_map, new);
 		call_rcu(&old->rcu, memcg_free_shrinker_map_rcu);
 	}
 
@@ -450,7 +451,7 @@ static void memcg_free_shrinker_maps(struct mem_cgroup *memcg)
 		return;
 
 	for_each_node(nid) {
-		pn = mem_cgroup_nodeinfo(memcg, nid);
+		pn = memcg->nodeinfo[nid];
 		map = rcu_dereference_protected(pn->shrinker_map, true);
 		kvfree(map);
 		rcu_assign_pointer(pn->shrinker_map, NULL);
@@ -713,7 +714,7 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 	int nid;
 
 	for_each_node(nid) {
-		mz = mem_cgroup_nodeinfo(memcg, nid);
+		mz = memcg->nodeinfo[nid];
 		mctz = soft_limit_tree_node(nid);
 		if (mctz)
 			mem_cgroup_remove_exceeded(mz, mctz);
@@ -796,7 +797,7 @@ parent_nodeinfo(struct mem_cgroup_per_node *pn, int nid)
 	parent = parent_mem_cgroup(pn->memcg);
 	if (!parent)
 		return NULL;
-	return mem_cgroup_nodeinfo(parent, nid);
+	return parent->nodeinfo[nid];
 }
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
@@ -1163,7 +1164,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	if (reclaim) {
 		struct mem_cgroup_per_node *mz;
 
-		mz = mem_cgroup_nodeinfo(root, reclaim->pgdat->node_id);
+		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
 		if (prev && reclaim->generation != iter->generation)
@@ -1265,7 +1266,7 @@ static void __invalidate_reclaim_iterators(struct mem_cgroup *from,
 	int nid;
 
 	for_each_node(nid) {
-		mz = mem_cgroup_nodeinfo(from, nid);
+		mz = from->nodeinfo[nid];
 		iter = &mz->iter;
 		cmpxchg(&iter->position, dead_memcg, NULL);
 	}
@@ -2438,7 +2439,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 				struct mem_cgroup_per_node *pn;
 				long x;
 
-				pn = mem_cgroup_nodeinfo(memcg, nid);
+				pn = memcg->nodeinfo[nid];
 				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
 
 				x = lstatc->count[i];
@@ -4145,7 +4146,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		unsigned long file_cost = 0;
 
 		for_each_online_pgdat(pgdat) {
-			mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+			mz = memcg->nodeinfo[pgdat->node_id];
 
 			anon_cost += mz->lruvec.anon_cost;
 			file_cost += mz->lruvec.file_cost;
-- 
2.30.0


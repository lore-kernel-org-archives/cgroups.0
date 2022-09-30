From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm: memcontrol: use mem_cgroup_is_root() helper
Date: Fri, 30 Sep 2022 19:14:33 +0530
Message-ID: <20220930134433.338103-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=KONBAx9m0CqP1zC/8vneM0xJmvBinGNKQZ5dphHO1Ng=;
 b=tiMELkw4uG0n1ek9pdLiaOq3mS96MlpguT9i3pU7wzZUH4B1dqclTmcxYr77zvHQM6dv
 szOfozlTnRlpBtrg6Ik8ge1kFnJxkWp9P7kjHkukn1AQ88vako6wTFZamz7gINm9DFWR
 89xm9/kKSN+VSx/3imZzX+y2tZH0/9hkrFnuiy6rKtr0yB+zcVWKvtM+KEcEFeFjoPu6
 vZinKUM9QxDeAcHBSuOktEEDvwY8RKVIY6O3/F0GvjLLuEUZer9ljuzQDu+Qu3OLnMaO
 nUNUbbvW2zzmoWXw1VCH5Sjl+bX7xNjncpLpN3jC8g+L/tDS7NDv3LIb8wiM1mz1a3SD zA== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Replace the checks for memcg is root memcg, with mem_cgroup_is_root()
helper.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..99b3d0cbd426 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1148,7 +1148,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 	 * cgroup root (root_mem_cgroup). So we have to handle
 	 * dead_memcg from cgroup root separately.
 	 */
-	if (last != root_mem_cgroup)
+	if (!mem_cgroup_is_root(last))
 		__invalidate_reclaim_iterators(root_mem_cgroup,
 						dead_memcg);
 }
@@ -1172,7 +1172,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	struct mem_cgroup *iter;
 	int ret = 0;
 
-	BUG_ON(memcg == root_mem_cgroup);
+	BUG_ON(mem_cgroup_is_root(memcg));
 
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
@@ -1201,7 +1201,7 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
 	memcg = folio_memcg(folio);
 
 	if (!memcg)
-		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != root_mem_cgroup, folio);
+		VM_BUG_ON_FOLIO(!mem_cgroup_is_root(lruvec_memcg(lruvec)), folio);
 	else
 		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
 }
@@ -1982,7 +1982,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 	rcu_read_lock();
 
 	memcg = mem_cgroup_from_task(victim);
-	if (memcg == root_mem_cgroup)
+	if (mem_cgroup_is_root(memcg))
 		goto out;
 
 	/*
@@ -2940,7 +2940,7 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg = NULL;
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
@@ -7073,7 +7073,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
-	if (memcg == root_mem_cgroup)
+	if (mem_cgroup_is_root(memcg))
 		goto out;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
 		goto out;
@@ -7208,7 +7208,7 @@ static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
 		 */
-		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
+		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
 			VM_BUG_ON(1);
 			break;
 		}
@@ -7369,7 +7369,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 
 	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return nr_swap_pages;
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
 				      READ_ONCE(memcg->swap.max) -
 				      page_counter_read(&memcg->swap));
@@ -7391,7 +7391,7 @@ bool mem_cgroup_swap_full(struct page *page)
 	if (!memcg)
 		return false;
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
@@ -7556,7 +7556,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 		return true;
 
 	original_memcg = get_mem_cgroup_from_objcg(objcg);
-	for (memcg = original_memcg; memcg != root_mem_cgroup;
+	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
 	     memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
 		unsigned long pages;

base-commit: 987a926c1d8a40e4256953b04771fbdb63bc7938
-- 
2.34.3


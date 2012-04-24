From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcg: move pc lookup point to commit_charge()
Date: Tue, 24 Apr 2012 21:31:00 +0200
Message-ID: <1335295860-28919-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

None of the callsites actually need the page_cgroup descriptor
themselves, so just pass the page and do the look up in there.

We already had two bugs (6568d4a 'mm: memcg: update the correct soft
limit tree during migration' and 'memcg: fix Bad page state after
replace_page_cache') where the passed page and pc were not referring
to the same page frame.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 884e936..1a28dd8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2461,10 +2461,10 @@ struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 				       struct page *page,
 				       unsigned int nr_pages,
-				       struct page_cgroup *pc,
 				       enum charge_type ctype,
 				       bool lrucare)
 {
+	struct page_cgroup *pc = lookup_page_cgroup(page);
 	struct zone *uninitialized_var(zone);
 	bool was_on_lru = false;
 	bool anon;
@@ -2701,7 +2701,6 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
-	struct page_cgroup *pc;
 	bool oom = true;
 	int ret;
 
@@ -2715,11 +2714,10 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 		oom = false;
 	}
 
-	pc = lookup_page_cgroup(page);
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype, false);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages, ctype, false);
 	return 0;
 }
 
@@ -2816,16 +2814,13 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
-	struct page_cgroup *pc;
-
 	if (mem_cgroup_disabled())
 		return;
 	if (!memcg)
 		return;
 	cgroup_exclude_rmdir(&memcg->css);
 
-	pc = lookup_page_cgroup(page);
-	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype, true);
+	__mem_cgroup_commit_charge(memcg, page, 1, ctype, true);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -3254,14 +3249,13 @@ int mem_cgroup_prepare_migration(struct page *page,
 	 * page. In the case new page is migrated but not remapped, new page's
 	 * mapcount will be finally 0 and we call uncharge in end_migration().
 	 */
-	pc = lookup_page_cgroup(newpage);
 	if (PageAnon(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
 	else if (page_is_file_cache(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype, false);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, ctype, false);
 	return ret;
 }
 
@@ -3348,8 +3342,7 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	pc = lookup_page_cgroup(newpage);
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, type, true);
 }
 
 #ifdef CONFIG_DEBUG_VM
-- 
1.7.7.6

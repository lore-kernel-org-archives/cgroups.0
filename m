From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] rename MEM_CGROUP_CHARGE_TYPE_MAPPED as MEM_CGROUP_CHARGE_TYPE_ANON
Date: Fri, 01 Jun 2012 19:44:50 +0900
Message-ID: <4FC89D22.6020802@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Now, in memcg, 2 "MAPPED" enum/macro are found
 MEM_CGROUP_CHARGE_TYPE_MAPPED
 MEM_CGROUP_STAT_FILE_MAPPED

Their names looks similar to each other but the former is used for
accounting anonymous memory, the latter is mapped-file.
(I've received questions caused by this naming issue 3 times..)

This patch renames MEM_CGROUP_CHARGE_TYPE_MAPPED  as MEM_CGROUP_CHARGE_TYPE_ANON.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 76bc54c..f4534d7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -392,7 +392,7 @@ static bool move_file(void)
 
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
-	MEM_CGROUP_CHARGE_TYPE_MAPPED,
+	MEM_CGROUP_CHARGE_TYPE_ANON,
 	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
@@ -2538,7 +2538,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_ANON)
 		anon = true;
 	else
 		anon = false;
@@ -2747,7 +2747,7 @@ int mem_cgroup_newpage_charge(struct page *page,
 	VM_BUG_ON(page->mapping && !PageAnon(page));
 	VM_BUG_ON(!mm);
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_MAPPED);
+					MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
 static void
@@ -2861,7 +2861,7 @@ void mem_cgroup_commit_charge_swapin(struct page *page,
 				     struct mem_cgroup *memcg)
 {
 	__mem_cgroup_commit_charge_swapin(page, memcg,
-					  MEM_CGROUP_CHARGE_TYPE_MAPPED);
+					  MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
@@ -2969,7 +2969,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	anon = PageAnon(page);
 
 	switch (ctype) {
-	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+	case MEM_CGROUP_CHARGE_TYPE_ANON:
 		/*
 		 * Generally PageAnon tells if it's the anon statistics to be
 		 * updated; but sometimes e.g. mem_cgroup_uncharge_page() is
@@ -3029,7 +3029,7 @@ void mem_cgroup_uncharge_page(struct page *page)
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
-	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
 void mem_cgroup_uncharge_cache_page(struct page *page)
@@ -3454,7 +3454,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 	 * mapcount will be finally 0 and we call uncharge in end_migration().
 	 */
 	if (PageAnon(page))
-		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
+		ctype = MEM_CGROUP_CHARGE_TYPE_ANON;
 	else if (page_is_file_cache(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
@@ -3493,7 +3493,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 	unlock_page_cgroup(pc);
 	anon = PageAnon(used);
 	__mem_cgroup_uncharge_common(unused,
-		anon ? MEM_CGROUP_CHARGE_TYPE_MAPPED
+		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
 		     : MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/*
-- 
1.7.4.1


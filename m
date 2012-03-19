From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 3/3] memcg: atomic update of memcg pointer and other
 bits.
Date: Mon, 19 Mar 2012 17:03:42 +0900
Message-ID: <4F66E85E.6030000@jp.fujitsu.com>
References: <4F66E6A5.10804@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F66E6A5.10804-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Because a pointer to memcg and flags are in the same word,
it can be updated at the same time. Then, we can remove
memory barrier which was used for fixing races.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/page_cgroup.h |    4 ++--
 mm/memcontrol.c             |   22 ++++------------------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index bca5447..e05f157 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -97,9 +97,9 @@ static inline struct mem_cgroup* pc_to_mem_cgroup(struct page_cgroup *pc)
 }
 
 static inline void
-pc_set_mem_cgroup(struct page_cgroup *pc, struct mem_cgroup *memcg)
+pc_set_mem_cgroup(struct page_cgroup *pc,
+		struct mem_cgroup *memcg, unsigned long bits)
 {
-	unsigned long bits = pc->flags & PCG_FLAGS_MASK;
 	pc->flags = (unsigned long)memcg | bits;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 124fec9..603a476 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1060,7 +1060,7 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
 	 * of pc's mem_cgroup safe.
 	 */
 	if (!PageCgroupUsed(pc) && memcg != root_mem_cgroup) {
-		pc_set_mem_cgroup(pc, root_mem_cgroup);
+		pc_set_mem_cgroup(pc, root_mem_cgroup, 0);
 		memcg = root_mem_cgroup;
 	}
 
@@ -1237,8 +1237,6 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 	pc = lookup_page_cgroup(page);
 	if (!PageCgroupUsed(pc))
 		return NULL;
-	/* Ensure pc's mem_cgroup is visible after reading PCG_USED. */
-	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc_to_mem_cgroup(pc), page);
 	return &mz->reclaim_stat;
 }
@@ -2491,16 +2489,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 		}
 	}
 
-	pc_set_mem_cgroup(pc, memcg);
-	/*
-	 * We access a page_cgroup asynchronously without lock_page_cgroup().
-	 * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
-	 * is accessed after testing USED bit. To make pc's mem_cgroup visible
-	 * before USED bit, we need memory barrier here.
-	 * See mem_cgroup_add_lru_list(), etc.
- 	 */
-	smp_wmb();
-	SetPageCgroupUsed(pc);
+	pc_set_mem_cgroup(pc, memcg, BIT(PCG_USED) | BIT(PCG_LOCK));
 
 	if (lrucare) {
 		if (was_on_lru) {
@@ -2529,7 +2518,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2547,9 +2535,7 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 		return;
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
-		pc_set_mem_cgroup(pc, memcg);
-		smp_wmb();/* see __commit_charge() */
-		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
+		pc_set_mem_cgroup(pc, memcg, BIT(PCG_USED));
 	}
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -2616,7 +2602,7 @@ static int mem_cgroup_move_account(struct page *page,
 		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
-	pc_set_mem_cgroup(pc, to);
+	pc_set_mem_cgroup(pc, to, BIT(PCG_USED) | BIT(PCG_LOCK));
 	mem_cgroup_charge_statistics(to, anon, nr_pages);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
-- 
1.7.4.1


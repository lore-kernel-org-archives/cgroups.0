From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 4/4] memcg: new LRU rule
Date: Tue, 6 Dec 2011 19:17:46 +0900
Message-ID: <20111206191746.58f9f736.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
	<20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111206191211.3be32ccb.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Not measured performance yet, sorry.
==
From 3f2539d695084eb8b83ec08347587b1e1f2efa9a Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Tue, 6 Dec 2011 19:09:06 +0900
Subject: [PATCH 4/4] memcg: new LRU rule

Now, at LRU handling, memory cgroup needs to do complicated works
to see valid pc->mem_cgroup, which may be overwritten.

This patch is for relaxing the protocol. This patch guarantees
   - when pc->mem_cgroup is overwritten, page must not be on LRU.

By this, LRU routine can believe pc->mem_cgroup and don't need to
check bits on pc->flags. This new rule may adds small
overheads to swap-in but, in most case, lru handling gets faster
and reduce overheads.

After this patch, PCG_ACCT_LRU bit is obsolete and removed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/page_cgroup.h |    8 ----
 mm/memcontrol.c             |   81 +++++++++++-------------------------------
 2 files changed, 21 insertions(+), 68 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index aaa60da..2cddacf 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -10,8 +10,6 @@ enum {
 	/* flags for mem_cgroup and file and I/O status */
 	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
-	/* No lock in page_cgroup */
-	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 	__NR_PCG_FLAGS,
 };
 
@@ -75,12 +73,6 @@ TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
 
-SETPCGFLAG(AcctLRU, ACCT_LRU)
-CLEARPCGFLAG(AcctLRU, ACCT_LRU)
-TESTPCGFLAG(AcctLRU, ACCT_LRU)
-TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
-
-
 SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 TESTPCGFLAG(FileMapped, FILE_MAPPED)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8706d8..0814cda 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -974,30 +974,7 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
 		return &zone->lruvec;
 
 	pc = lookup_page_cgroup(page);
-	VM_BUG_ON(PageCgroupAcctLRU(pc));
-	/*
-	 * putback:				charge:
-	 * SetPageLRU				SetPageCgroupUsed
-	 * smp_mb				smp_mb
-	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
-	 *
-	 * Ensure that one of the two sides adds the page to the memcg
-	 * LRU during a race.
-	 */
-	smp_mb();
-	/*
-	 * If the page is uncharged, it may be freed soon, but it
-	 * could also be swap cache (readahead, swapoff) that needs to
-	 * be reclaimable in the future.  root_mem_cgroup will babysit
-	 * it for the time being.
-	 */
-	if (PageCgroupUsed(pc)) {
-		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
-		smp_rmb();
-		memcg = pc->mem_cgroup;
-		SetPageCgroupAcctLRU(pc);
-	} else
-		memcg = root_mem_cgroup;
+	memcg = pc->mem_cgroup;
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
@@ -1024,18 +1001,7 @@ void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
 		return;
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * root_mem_cgroup babysits uncharged LRU pages, but
-	 * PageCgroupUsed is cleared when the page is about to get
-	 * freed.  PageCgroupAcctLRU remembers whether the
-	 * LRU-accounting happened against pc->mem_cgroup or
-	 * root_mem_cgroup.
-	 */
-	if (TestClearPageCgroupAcctLRU(pc)) {
-		VM_BUG_ON(!pc->mem_cgroup);
-		memcg = pc->mem_cgroup;
-	} else
-		memcg = root_mem_cgroup;
+	memcg = pc->mem_cgroup;
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
@@ -2377,6 +2343,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 
 	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
 	unlock_page_cgroup(pc);
+	WARN_ON_ONCE(PageLRU(page));
 	/*
 	 * "charge_statistics" updated event counter. Then, check it.
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
@@ -2388,7 +2355,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
+			(1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2399,6 +2366,8 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
 	struct page_cgroup *pc;
+	struct mem_cgroup_per_zone *mz;
+	enum lru_list lru;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -2414,16 +2383,12 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
 
-	if (PageCgroupAcctLRU(head_pc)) {
-		enum lru_list lru;
-		struct mem_cgroup_per_zone *mz;
-		/*
-		 * We hold lru_lock, then, reduce counter directly.
-		 */
-		lru = page_lru(head);
-		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
-		MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
-	}
+	/*
+	 * We hold lru_lock, then, reduce counter directly.
+	 */
+	lru = page_lru(head);
+	mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
+	MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
 }
 #endif
 
@@ -2617,17 +2582,23 @@ __mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	struct zone *zone = page_zone(page);
 	unsigned long flags;
+	bool removed = false;
 	/*
 	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
 	 * is already on LRU. It means the page may on some other page_cgroup's
 	 * LRU. Take care of it.
 	 */
 	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(page))
+	if (PageLRU(page)) {
 		del_page_from_lru_list(zone, page, page_lru(page));
+		ClearPageLRU(page);
+		removed = true;
+	}
 	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
-	if (PageLRU(page))
+	if (removed) {
+		SetPageLRU(page);
 		add_page_to_lru_list(zone, page, page_lru(page));
+	}
 	spin_unlock_irqrestore(&zone->lru_lock, flags);
 	return;
 }
@@ -3243,9 +3214,7 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
-	struct zone *zone;
 	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
-	unsigned long flags;
 
 	pc = lookup_page_cgroup(oldpage);
 	/* fix accounting on old pages */
@@ -3258,20 +3227,12 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 	if (PageSwapBacked(oldpage))
 		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
-	zone = page_zone(newpage);
-	pc = lookup_page_cgroup(newpage);
 	/*
 	 * Even if newpage->mapping was NULL before starting replacement,
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(newpage))
-		del_page_from_lru_list(zone, newpage, page_lru(newpage));
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type);
-	if (PageLRU(newpage))
-		add_page_to_lru_list(zone, newpage, page_lru(newpage));
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+	__mem_cgroup_commit_charge_lrucare(newpage, memcg, type);
 }
 
 #ifdef CONFIG_DEBUG_VM
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

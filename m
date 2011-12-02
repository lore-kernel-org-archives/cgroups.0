From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH] memcg: remove PCG_ACCT_LRU.
Date: Fri, 2 Dec 2011 19:06:22 +0900
Message-ID: <20111202190622.8e0488d6.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I'm now testing this patch, removing PCG_ACCT_LRU, onto mmotm.
How do you think ?

Here is a performance score at running page fault test.
==
[Before]
    11.20%   malloc  [kernel.kallsyms]  [k] clear_page_c
    ....
     1.80%   malloc  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge
     0.94%   malloc  [kernel.kallsyms]  [k] mem_cgroup_lru_add_list
     0.87%   malloc  [kernel.kallsyms]  [k] mem_cgroup_lru_del_list

[After]
    11.66%   malloc  [kernel.kallsyms]  [k] clear_page_c
    2.17%   malloc  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge
    0.56%   malloc  [kernel.kallsyms]  [k] mem_cgroup_lru_add_list
    0.25%   malloc  [kernel.kallsyms]  [k] mem_cgroup_lru_del_list

==

seems attractive to me.

==
From 882fefc1681591af5a1a3ac697012cef7952a462 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Fri, 2 Dec 2011 19:11:33 +0900
Subject: [PATCH] memcg: remove PCG_LRU_Acct.

Now. memcg uses PCG_LRU_ACCT bit for checking the page is on LRU or not.
Now, page->lru is used for lru and it seems not to be necessary
to check PCG_ACCT_LRU flag, which adds atomic operations in
lru handling.

 - This patch removes it. And added a debug param.
 - This patch modifies the case where the page is on LRU before
   commit charge. This new logic does..

   zone->lru_lock
   if (PageLru(page))
          remove from LRU
   commit_charge()
   if (removed_from_lru)
          add page to LRU again.
   zone->lru_unlock

Then, swapin-and-map-page will be handled in the safe way without
any races.

But yes, need heavy test.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/page_cgroup.h |   10 +---
 mm/memcontrol.c             |  102 ++++++++++--------------------------------
 2 files changed, 28 insertions(+), 84 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index aaa60da..92ab60a 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -11,7 +11,6 @@ enum {
 	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	/* No lock in page_cgroup */
-	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 	__NR_PCG_FLAGS,
 };
 
@@ -31,6 +30,9 @@ enum {
 struct page_cgroup {
 	unsigned long flags;
 	struct mem_cgroup *mem_cgroup;
+#ifdef CONFIG_DEBUG_VM
+	struct mem_cgroup *mem_cgroup_lru;
+#endif
 };
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
@@ -75,12 +77,6 @@ TESTPCGFLAG(Used, USED)
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
index 8880a32..9b9b81c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -974,7 +974,6 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
 		return &zone->lruvec;
 
 	pc = lookup_page_cgroup(page);
-	VM_BUG_ON(PageCgroupAcctLRU(pc));
 	/*
 	 * putback:				charge:
 	 * SetPageLRU				SetPageCgroupUsed
@@ -995,9 +994,12 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
 		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 		smp_rmb();
 		memcg = pc->mem_cgroup;
-		SetPageCgroupAcctLRU(pc);
 	} else
 		memcg = root_mem_cgroup;
+#ifdef CONFIG_DEBUG_VM
+		pc->mem_cgroup_lru = memcg;
+#endif
+	
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
@@ -1024,18 +1026,8 @@ void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
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
+	memcg = pc->mem_cgroup ? pc->mem_cgroup : root_mem_cgroup;
+	VM_BUG_ON(memcg != pc->mem_cgroup_lru);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
@@ -1074,29 +1066,15 @@ struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
  * At handling SwapCache and other FUSE stuff, pc->mem_cgroup may be changed
  * while it's linked to lru because the page may be reused after it's fully
  * uncharged. To handle that, unlink page_cgroup from LRU when charge it again.
- * It's done under lock_page and expected that zone->lru_lock isnever held.
+ * It's done under lock_page. zone->lru_lock is held in the caller.
  */
-static void mem_cgroup_lru_del_before_commit(struct page *page)
+static bool mem_cgroup_lru_del_before_commit(struct page *page,
+			struct page_cgroup *pc)
 {
-	enum lru_list lru;
-	unsigned long flags;
 	struct zone *zone = page_zone(page);
-	struct page_cgroup *pc = lookup_page_cgroup(page);
+	bool removed =false;
 
 	/*
-	 * Doing this check without taking ->lru_lock seems wrong but this
-	 * is safe. Because if page_cgroup's USED bit is unset, the page
-	 * will not be added to any memcg's LRU. If page_cgroup's USED bit is
-	 * set, the commit after this will fail, anyway.
-	 * This all charge/uncharge is done under some mutual execustion.
-	 * So, we don't need to taking care of changes in USED bit.
-	 */
-	if (likely(!PageLRU(page)))
-		return;
-
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	lru = page_lru(page);
-	/*
 	 * The uncharged page could still be registered to the LRU of
 	 * the stale pc->mem_cgroup.
 	 *
@@ -1107,47 +1085,11 @@ static void mem_cgroup_lru_del_before_commit(struct page *page)
 	 * The PCG_USED bit is guarded by lock_page() as the page is
 	 * swapcache/pagecache.
 	 */
-	if (PageLRU(page) && PageCgroupAcctLRU(pc) && !PageCgroupUsed(pc)) {
-		del_page_from_lru_list(zone, page, lru);
-		add_page_to_lru_list(zone, page, lru);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-}
-
-static void mem_cgroup_lru_add_after_commit(struct page *page)
-{
-	enum lru_list lru;
-	unsigned long flags;
-	struct zone *zone = page_zone(page);
-	struct page_cgroup *pc = lookup_page_cgroup(page);
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
-	/* taking care of that the page is added to LRU while we commit it */
-	if (likely(!PageLRU(page)))
-		return;
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	lru = page_lru(page);
-	/*
-	 * If the page is not on the LRU, someone will soon put it
-	 * there.  If it is, and also already accounted for on the
-	 * memcg-side, it must be on the right lruvec as setting
-	 * pc->mem_cgroup and PageCgroupUsed is properly ordered.
-	 * Otherwise, root_mem_cgroup has been babysitting the page
-	 * during the charge.  Move it to the new memcg now.
-	 */
-	if (PageLRU(page) && !PageCgroupAcctLRU(pc)) {
-		del_page_from_lru_list(zone, page, lru);
-		add_page_to_lru_list(zone, page, lru);
+	if (PageLRU(page) && !PageCgroupUsed(pc)) {
+		del_page_from_lru_list(zone, page, page_lru(page));
+		removed = true;
 	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+	return removed;
 }
 
 /*
@@ -2468,7 +2410,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
+			(1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2493,8 +2435,8 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 		 */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
-
-	if (PageCgroupAcctLRU(head_pc)) {
+	/* we're under zone->lru_lock. page's LRU state never changes. */
+	if (PageLRU(head)) {
 		enum lru_list lru;
 		struct mem_cgroup_per_zone *mz;
 		/*
@@ -2695,14 +2637,20 @@ __mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
+	struct zone *zone = page_zone(page);
+	unsigned long flags;
+	bool removed;
 	/*
 	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
 	 * is already on LRU. It means the page may on some other page_cgroup's
 	 * LRU. Take care of it.
 	 */
-	mem_cgroup_lru_del_before_commit(page);
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	removed = mem_cgroup_lru_del_before_commit(page, pc);
 	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
-	mem_cgroup_lru_add_after_commit(page);
+	if (removed)
+		add_page_to_lru_list(page_zone(page), page, page_lru(page));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
 	return;
 }
 
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

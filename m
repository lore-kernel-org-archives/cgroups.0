From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Date: Thu, 17 Nov 2011 10:33:08 +0900
Message-ID: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


I'll send this again when mm is shipped.
I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
it's very slow. This fixes it. Any comments are welcome.

==
Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.

at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
handle page_cgroup modifcations. It takes move_lock_page_cgroup()
and modify page_cgroup and LRU accounting jobs and called
HPAGE_PMD_SIZE - 1 times.

But thinking again,
  - compound_lock() is held at move_accout...then, it's not necessary
    to take move_lock_page_cgroup().
  - LRU is locked and all tail pages will go into the same LRU as
    head is now on.
  - page_cgroup is contiguous in huge page range.

This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
hugepage and reduce costs for spliting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/memcontrol.h |    5 ++---
 mm/huge_memory.c           |    3 ++-
 mm/memcontrol.c            |   32 ++++++++++++++++----------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b87068a..0a22a19 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -154,7 +154,7 @@ u64 mem_cgroup_get_limit(struct mem_cgroup *memcg);
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
+void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
 #ifdef CONFIG_DEBUG_VM
@@ -357,8 +357,7 @@ u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head,
-						struct page *tail)
+static inline void mem_cgroup_split_huge_fixup(struct page *head)
 {
 }
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4298aba..aa6cdae 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1207,6 +1207,8 @@ static void __split_huge_page_refcount(struct page *page)
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
 	compound_lock(page);
+	/* complete memcg works before add pages to LRU */
+	mem_cgroup_split_huge_fixup(page);
 
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		struct page *page_tail = page + i;
@@ -1278,7 +1280,6 @@ static void __split_huge_page_refcount(struct page *page)
 		BUG_ON(!PageDirty(page_tail));
 		BUG_ON(!PageSwapBacked(page_tail));
 
-		mem_cgroup_split_huge_fixup(page, page_tail);
 
 		lru_add_page_tail(zone, page, page_tail);
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..99101f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2523,38 +2523,38 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compund_lock.
+ * charge/uncharge will be never happen and move_account() is done under
+ * compound_lock(), so we don't have to take care of races.
  */
-void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
+void mem_cgroup_split_huge_fixup(struct page *head)
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
-	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
-	unsigned long flags;
+	struct page_cgroup *pc;
+	int i;
 
 	if (mem_cgroup_disabled())
 		return;
-	/*
-	 * We have no races with charge/uncharge but will have races with
-	 * page state accounting.
-	 */
-	move_lock_page_cgroup(head_pc, &flags);
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
+		pc = head_pc + i;
+		pc->mem_cgroup = head_pc->mem_cgroup;
+		smp_wmb();/* see __commit_charge() */
+		/*
+		 * LRU flags cannot be copied because we need to add tail
+		 * page to LRU by generic call and our hooks will be called.
+		 */
+		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
+	}
 
-	tail_pc->mem_cgroup = head_pc->mem_cgroup;
-	smp_wmb(); /* see __commit_charge() */
 	if (PageCgroupAcctLRU(head_pc)) {
 		enum lru_list lru;
 		struct mem_cgroup_per_zone *mz;
-
 		/*
-		 * LRU flags cannot be copied because we need to add tail
-		 *.page to LRU by generic call and our hook will be called.
 		 * We hold lru_lock, then, reduce counter directly.
 		 */
 		lru = page_lru(head);
 		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
-		MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+		MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
 	}
-	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
-	move_unlock_page_cgroup(head_pc, &flags);
 }
 #endif
 
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

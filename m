From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 3/3] replace mem_cgroup_disabled
Date: Wed, 23 Nov 2011 17:34:21 +0900
Message-ID: <20111123173421.39c99643.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111123172840.acd53c41.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org" <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I'll rebase this onto mmotm this is based on mainline git tree.
==
From 2da35fd8eab3a8c2ca80d7aa5dfd4276a23ebf57 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Wed, 23 Nov 2011 16:42:59 +0900
Subject: [PATCH 3/3] replace mem_cgroup_disabled().

cgroup provires cgroup_xxxx_disabled() functions for checking
subsys is diabled by boot option or not. Make use of it instead
of using private function.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/memcontrol.h |   12 ------------
 kernel/cgroup.c            |    4 ++--
 mm/memcontrol.c            |   32 ++++++++++++++++----------------
 mm/page_cgroup.c           |    4 ++--
 4 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b87068a..fa5712e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -124,13 +124,6 @@ extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 extern int do_swap_account;
 #endif
 
-static inline bool mem_cgroup_disabled(void)
-{
-	if (mem_cgroup_subsys.disabled)
-		return true;
-	return false;
-}
-
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx,
 				 int val);
@@ -291,11 +284,6 @@ static inline void mem_cgroup_record_reclaim_priority(struct mem_cgroup *memcg,
 {
 }
 
-static inline bool mem_cgroup_disabled(void)
-{
-	return true;
-}
-
 static inline int
 mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 28d4430..e5c33f5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4778,7 +4778,7 @@ static void cgroup_release_agent(struct work_struct *work)
 }
 #ifdef CONFIG_JUMP_LABEL
 #define SUBSYS(_x)\
-	struct jump_label_key cgroup_ ## _x ## _disable_key;
+	struct jump_label_key cgroup_ ## _x ## _disabled_key;
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
@@ -4786,7 +4786,7 @@ static void cgroup_subsys_disable(void)
 {
 #define SUBSYS(_x)\
 	if ( _x ## _subsys.disabled)\
-		jump_label_inc(&cgroup_ ## _x ## _disable_key);
+		jump_label_inc(&cgroup_ ## _x ## _disabled_key);
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..594af98 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -916,7 +916,7 @@ void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	/* can happen while we handle swapcache. */
@@ -952,7 +952,7 @@ void mem_cgroup_rotate_reclaimable_page(struct page *page)
 	struct page_cgroup *pc;
 	enum lru_list lru = page_lru(page);
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 
 	pc = lookup_page_cgroup(page);
@@ -972,7 +972,7 @@ void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 
 	pc = lookup_page_cgroup(page);
@@ -992,7 +992,7 @@ void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	VM_BUG_ON(PageCgroupAcctLRU(pc));
@@ -1081,7 +1081,7 @@ static void mem_cgroup_lru_add_after_commit(struct page *page)
 void mem_cgroup_move_lists(struct page *page,
 			   enum lru_list from, enum lru_list to)
 {
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 	mem_cgroup_del_lru_list(page, from);
 	mem_cgroup_add_lru_list(page, to);
@@ -1180,7 +1180,7 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return NULL;
 
 	pc = lookup_page_cgroup(page);
@@ -2530,7 +2530,7 @@ void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
 	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
 	unsigned long flags;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 	/*
 	 * We have no races with charge/uncharge but will have races with
@@ -2730,7 +2730,7 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 int mem_cgroup_newpage_charge(struct page *page,
 			      struct mm_struct *mm, gfp_t gfp_mask)
 {
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return 0;
 	/*
 	 * If already mapped, we don't have to account.
@@ -2773,7 +2773,7 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 	struct mem_cgroup *memcg = NULL;
 	int ret;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
 		return 0;
@@ -2823,7 +2823,7 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 
 	*ptr = NULL;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return 0;
 
 	if (!do_swap_account)
@@ -2853,7 +2853,7 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
 					enum charge_type ctype)
 {
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 	if (!ptr)
 		return;
@@ -2903,7 +2903,7 @@ void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
 {
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 	if (!memcg)
 		return;
@@ -2974,7 +2974,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return NULL;
 
 	if (PageSwapCache(page))
@@ -3237,7 +3237,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 	*ptr = NULL;
 
 	VM_BUG_ON(PageTransHuge(page));
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return 0;
 
 	pc = lookup_page_cgroup(page);
@@ -3379,7 +3379,7 @@ static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
 
 bool mem_cgroup_bad_page_check(struct page *page)
 {
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return false;
 
 	return lookup_page_cgroup_used(page) != NULL;
@@ -4853,7 +4853,7 @@ static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static void __init enable_swap_cgroup(void)
 {
-	if (!mem_cgroup_disabled() && really_do_swap_account)
+	if (!cgroup_mem_cgroup_disabled() && really_do_swap_account)
 		do_swap_account = 1;
 }
 #else
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 2d123f9..a7bf01d 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -87,7 +87,7 @@ void __init page_cgroup_init_flatmem(void)
 
 	int nid, fail;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 
 	for_each_online_node(nid)  {
@@ -302,7 +302,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int nid;
 
-	if (mem_cgroup_disabled())
+	if (cgroup_mem_cgroup_disabled())
 		return;
 
 	for_each_node_state(nid, N_HIGH_MEMORY) {
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 15/19] mm: memcontrol: make swap tracking an integral part of memory control
Date: Fri,  8 May 2020 14:31:02 -0400
Message-ID: <20200508183105.225460-16-hannes@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pKOPyg5gtn9WNLK5mCdpfEBeBK6if5ILK7ToiE0vcCU=;
        b=bmFd9FmZa2yqWu7iSLZAIsztyPg65rOnQu7/u0h6g8a6lr5X5kMIz6Fd4olXXQZlmX
         Ps0A1svz62ezR6G4pTmdG4yLt9l39Qb0bEsumD6rwlww+IVjZ+OeM2LVIscGReetC+0V
         SOXhZHz5f0QztJTrqR1PqfHV10AlQpbgZSez9SA1el3Nt5PNBAG9ZvcD9dOMrIHfWKEz
         45CKliiOIWS0TU9V8OxGEmSFIoCvNsgLX5ML1s+2/iHViazx8eV0vSur6bfUutFIvr2u
         I5LjTliB1RZ421nLu0ENfcvrBw4jbPYbC/u5QzWDzJTOcrm5tCXu+3E4gmbA857RzdWK
         KZPw==
In-Reply-To: <20200508183105.225460-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Without swap page tracking, users that are otherwise memory controlled
can easily escape their containment and allocate significant amounts
of memory that they're not being charged for. That's because swap does
readahead, but without the cgroup records of who owned the page at
swapout, readahead pages don't get charged until somebody actually
faults them into their page table and we can identify an owner task.
This can be maliciously exploited with MADV_WILLNEED, which triggers
arbitrary readahead allocations without charging the pages.

Make swap swap page tracking an integral part of memcg and remove the
Kconfig options. In the first place, it was only made configurable to
allow users to save some memory. But the overhead of tracking cgroup
ownership per swap page is minimal - 2 byte per page, or 512k per 1G
of swap, or 0.04%. Saving that at the expense of broken containment
semantics is not something we should present as a coequal option.

The swapaccount=0 boot option will continue to exist, and it will
eliminate the page_counter overhead and hide the swap control files,
but it won't disable swap slot ownership tracking.

This patch makes sure we always have the cgroup records at swapin
time; the next patch will fix the actual bug by charging readahead
swap pages at swapin time rather than at fault time.

v2: fix double swap charge bug in cgroup1/cgroup2 code gating

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
---
 init/Kconfig     | 17 +----------------
 mm/memcontrol.c  | 47 ++++++++++++++++++-----------------------------
 mm/swap_cgroup.c |  6 ------
 3 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 492bb7000aa4..9a874b2201bd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -847,24 +847,9 @@ config MEMCG
 	  Provides control over the memory footprint of tasks in a cgroup.
 
 config MEMCG_SWAP
-	bool "Swap controller"
+	bool
 	depends on MEMCG && SWAP
-	help
-	  Provides control over the swap space consumed by tasks in a cgroup.
-
-config MEMCG_SWAP_ENABLED
-	bool "Swap controller enabled by default"
-	depends on MEMCG_SWAP
 	default y
-	help
-	  Memory Resource Controller Swap Extension comes with its price in
-	  a bigger memory consumption. General purpose distribution kernels
-	  which want to enable the feature but keep it disabled by default
-	  and let the user enable it by swapaccount=1 boot command line
-	  parameter should have this option unselected.
-	  For those who want to have the feature enabled by default should
-	  select this option (if, for some reason, they need to disable it
-	  then swapaccount=0 does the trick).
 
 config MEMCG_KMEM
 	bool
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bb5f02ab92fb..4a003531af07 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -83,14 +83,10 @@ static bool cgroup_memory_nokmem;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-#ifdef CONFIG_MEMCG_SWAP_ENABLED
 bool cgroup_memory_noswap __read_mostly;
 #else
-bool cgroup_memory_noswap __read_mostly = 1;
-#endif /* CONFIG_MEMCG_SWAP_ENABLED */
-#else
 #define cgroup_memory_noswap		1
-#endif /* CONFIG_MEMCG_SWAP */
+#endif
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
@@ -5294,8 +5290,7 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 	 * we call find_get_page() with swapper_space directly.
 	 */
 	page = find_get_page(swap_address_space(ent), swp_offset(ent));
-	if (do_memsw_account())
-		entry->val = ent.val;
+	entry->val = ent.val;
 
 	return page;
 }
@@ -5329,8 +5324,7 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 		page = find_get_entry(mapping, pgoff);
 		if (xa_is_value(page)) {
 			swp_entry_t swp = radix_to_swp_entry(page);
-			if (do_memsw_account())
-				*entry = swp;
+			*entry = swp;
 			page = find_get_page(swap_address_space(swp),
 					     swp_offset(swp));
 		}
@@ -6460,6 +6454,9 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
 		goto out;
 
 	if (PageSwapCache(page)) {
+		swp_entry_t ent = { .val = page_private(page), };
+		unsigned short id;
+
 		/*
 		 * Every swap fault against a single page tries to charge the
 		 * page, bail as early as possible.  shmem_unuse() encounters
@@ -6471,17 +6468,12 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
 		if (compound_head(page)->mem_cgroup)
 			goto out;
 
-		if (!cgroup_memory_noswap) {
-			swp_entry_t ent = { .val = page_private(page), };
-			unsigned short id;
-
-			id = lookup_swap_cgroup_id(ent);
-			rcu_read_lock();
-			memcg = mem_cgroup_from_id(id);
-			if (memcg && !css_tryget_online(&memcg->css))
-				memcg = NULL;
-			rcu_read_unlock();
-		}
+		id = lookup_swap_cgroup_id(ent);
+		rcu_read_lock();
+		memcg = mem_cgroup_from_id(id);
+		if (memcg && !css_tryget_online(&memcg->css))
+			memcg = NULL;
+		rcu_read_unlock();
 	}
 
 	if (!memcg)
@@ -6498,7 +6490,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (do_memsw_account() && PageSwapCache(page)) {
+	if (PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
@@ -6883,7 +6875,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
-	if (!do_memsw_account())
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
 	memcg = page->mem_cgroup;
@@ -6912,7 +6904,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
+	if (!cgroup_memory_noswap && memcg != swap_memcg) {
 		if (!mem_cgroup_is_root(swap_memcg))
 			page_counter_charge(&swap_memcg->memsw, nr_entries);
 		page_counter_uncharge(&memcg->memsw, nr_entries);
@@ -6948,7 +6940,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) || cgroup_memory_noswap)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
 	memcg = page->mem_cgroup;
@@ -6964,7 +6956,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 
 	memcg = mem_cgroup_id_get_online(memcg);
 
-	if (!mem_cgroup_is_root(memcg) &&
+	if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -6992,14 +6984,11 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (cgroup_memory_noswap)
-		return;
-
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
+		if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 				page_counter_uncharge(&memcg->swap, nr_pages);
 			else
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 7aa764f09079..7f34343c075a 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -171,9 +171,6 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
-	if (cgroup_memory_noswap)
-		return 0;
-
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
@@ -209,9 +206,6 @@ void swap_cgroup_swapoff(int type)
 	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
-	if (cgroup_memory_noswap)
-		return;
-
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl = &swap_cgroup_ctrl[type];
 	map = ctrl->map;
-- 
2.26.2


From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 09/18] mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters
Date: Mon, 20 Apr 2020 18:11:17 -0400
Message-ID: <20200420221126.341272-10-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WdvwGQE8XVBDAKrx6j4kDydd4kqIfKED4/4ex8jpkmk=;
        b=TRaLcGkdz3tLrGleyu2iGKHq7sNTzbvjAfOIoEWTYlFEOEu3uU/JvUF+2PdOmnPvjV
         c7u8SsMDafJLWkv8jn3Z2wClJhrb2HlkaNeCPHX6AXLN89cGspMTFg1GgsH5axfYLYbC
         Sqp3wORdG//v9xuLb+Zw7rtyyvaVmvJ/t/CAUCjpPmMDYJ4DJwzeYCbx1AAQxmg8hwGF
         BSDqlTA3eHYPnh5F03/a2hWJE5PgC9gsOxIK1nYNzR/mlVx0mo6rNGKtrh8ZenFNv60h
         gg0Wy13N0ub3oqlCvfA3zDrlxQ4w75PlCeXJQ15UkRHiaFjGhmoZWGH9oYTQ04zFsa7p
         hA0Q==
In-Reply-To: <20200420221126.341272-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Memcg maintains private MEMCG_CACHE and NR_SHMEM counters. This
divergence from the generic VM accounting means unnecessary code
overhead, and creates a dependency for memcg that page->mapping is set
up at the time of charging, so that page types can be told apart.

Convert the generic accounting sites to mod_lruvec_page_state and
friends to maintain the per-cgroup vmstat counters of NR_FILE_PAGES
and NR_SHMEM. The page is already locked in these places, so
page->mem_cgroup is stable; we only need minimal tweaks of two
mem_cgroup_migrate() calls to ensure it's set up in time.

Then replace MEMCG_CACHE with NR_FILE_PAGES and delete the private
NR_SHMEM accounting sites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h |  3 +--
 mm/filemap.c               | 17 +++++++++--------
 mm/khugepaged.c            | 16 +++++++++++-----
 mm/memcontrol.c            | 28 +++++++++++-----------------
 mm/migrate.c               | 15 +++++++++++----
 mm/shmem.c                 | 14 +++++++-------
 6 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5a1b5a7b7728..c44aa1ccf553 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -29,8 +29,7 @@ struct kmem_cache;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
-	MEMCG_CACHE = NR_VM_NODE_STAT_ITEMS,
-	MEMCG_RSS,
+	MEMCG_RSS = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_RSS_HUGE,
 	MEMCG_SWAP,
 	MEMCG_SOCK,
diff --git a/mm/filemap.c b/mm/filemap.c
index 5bdbda965177..f4592ff3ca8b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -199,9 +199,9 @@ static void unaccount_page_cache_page(struct address_space *mapping,
 
 	nr = hpage_nr_pages(page);
 
-	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	__mod_lruvec_page_state(page, NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page)) {
-		__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
+		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
 		if (PageTransHuge(page))
 			__dec_node_page_state(page, NR_SHMEM_THPS);
 	} else if (PageTransHuge(page)) {
@@ -802,21 +802,22 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 	new->mapping = mapping;
 	new->index = offset;
 
+	mem_cgroup_migrate(old, new);
+
 	xas_lock_irqsave(&xas, flags);
 	xas_store(&xas, new);
 
 	old->mapping = NULL;
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!PageHuge(old))
-		__dec_node_page_state(old, NR_FILE_PAGES);
+		__dec_lruvec_page_state(old, NR_FILE_PAGES);
 	if (!PageHuge(new))
-		__inc_node_page_state(new, NR_FILE_PAGES);
+		__inc_lruvec_page_state(new, NR_FILE_PAGES);
 	if (PageSwapBacked(old))
-		__dec_node_page_state(old, NR_SHMEM);
+		__dec_lruvec_page_state(old, NR_SHMEM);
 	if (PageSwapBacked(new))
-		__inc_node_page_state(new, NR_SHMEM);
+		__inc_lruvec_page_state(new, NR_SHMEM);
 	xas_unlock_irqrestore(&xas, flags);
-	mem_cgroup_migrate(old, new);
 	if (freepage)
 		freepage(old);
 	put_page(old);
@@ -867,7 +868,7 @@ static int __add_to_page_cache_locked(struct page *page,
 
 		/* hugetlb pages do not participate in page cache accounting */
 		if (!huge)
-			__inc_node_page_state(page, NR_FILE_PAGES);
+			__inc_lruvec_page_state(page, NR_FILE_PAGES);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp_mask & GFP_RECLAIM_MASK));
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 46f9b565e8d5..ee2ef4b8e828 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1740,12 +1740,18 @@ static void collapse_file(struct mm_struct *mm,
 	}
 
 	if (nr_none) {
-		struct zone *zone = page_zone(new_page);
-
-		__mod_node_page_state(zone->zone_pgdat, NR_FILE_PAGES, nr_none);
+		struct lruvec *lruvec;
+		/*
+		 * XXX: We have started try_charge and pinned the
+		 * memcg, but the page isn't committed yet so we
+		 * cannot use mod_lruvec_page_state(). This hackery
+		 * will be cleaned up when remove the page->mapping
+		 * dependency from memcg and fully charge above.
+		 */
+		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(new_page));
+		__mod_lruvec_state(lruvec, NR_FILE_PAGES, nr_none);
 		if (is_shmem)
-			__mod_node_page_state(zone->zone_pgdat,
-					      NR_SHMEM, nr_none);
+			__mod_lruvec_state(lruvec, NR_SHMEM, nr_none);
 	}
 
 xa_locked:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e9e22c86a118..7e77166cf10b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -842,11 +842,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	 */
 	if (PageAnon(page))
 		__mod_memcg_state(memcg, MEMCG_RSS, nr_pages);
-	else {
-		__mod_memcg_state(memcg, MEMCG_CACHE, nr_pages);
-		if (PageSwapBacked(page))
-			__mod_memcg_state(memcg, NR_SHMEM, nr_pages);
-	}
 
 	if (abs(nr_pages) > 1) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -1392,7 +1387,7 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 		       (u64)memcg_page_state(memcg, MEMCG_RSS) *
 		       PAGE_SIZE);
 	seq_buf_printf(&s, "file %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_CACHE) *
+		       (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
 		       PAGE_SIZE);
 	seq_buf_printf(&s, "kernel_stack %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) *
@@ -3302,7 +3297,7 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		val = memcg_page_state(memcg, MEMCG_CACHE) +
+		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, MEMCG_RSS);
 		if (swap)
 			val += memcg_page_state(memcg, MEMCG_SWAP);
@@ -3772,7 +3767,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 #endif /* CONFIG_NUMA */
 
 static const unsigned int memcg1_stats[] = {
-	MEMCG_CACHE,
+	NR_FILE_PAGES,
 	MEMCG_RSS,
 	MEMCG_RSS_HUGE,
 	NR_SHMEM,
@@ -5401,6 +5396,14 @@ static int mem_cgroup_move_account(struct page *page,
 	lock_page_memcg(page);
 
 	if (!PageAnon(page)) {
+		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_FILE_PAGES, nr_pages);
+
+		if (PageSwapBacked(page)) {
+			__mod_lruvec_state(from_vec, NR_SHMEM, -nr_pages);
+			__mod_lruvec_state(to_vec, NR_SHMEM, nr_pages);
+		}
+
 		if (page_mapped(page)) {
 			__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
@@ -6613,10 +6616,8 @@ struct uncharge_gather {
 	unsigned long nr_pages;
 	unsigned long pgpgout;
 	unsigned long nr_anon;
-	unsigned long nr_file;
 	unsigned long nr_kmem;
 	unsigned long nr_huge;
-	unsigned long nr_shmem;
 	struct page *dummy_page;
 };
 
@@ -6640,9 +6641,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 
 	local_irq_save(flags);
 	__mod_memcg_state(ug->memcg, MEMCG_RSS, -ug->nr_anon);
-	__mod_memcg_state(ug->memcg, MEMCG_CACHE, -ug->nr_file);
 	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
-	__mod_memcg_state(ug->memcg, NR_SHMEM, -ug->nr_shmem);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
@@ -6685,11 +6684,6 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 			ug->nr_huge += nr_pages;
 		if (PageAnon(page))
 			ug->nr_anon += nr_pages;
-		else {
-			ug->nr_file += nr_pages;
-			if (PageSwapBacked(page))
-				ug->nr_shmem += nr_pages;
-		}
 		ug->pgpgout++;
 	} else {
 		ug->nr_kmem += nr_pages;
diff --git a/mm/migrate.c b/mm/migrate.c
index 5dd50128568c..14a584c52782 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -490,11 +490,18 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 * are mapped to swap space.
 	 */
 	if (newzone != oldzone) {
-		__dec_node_state(oldzone->zone_pgdat, NR_FILE_PAGES);
-		__inc_node_state(newzone->zone_pgdat, NR_FILE_PAGES);
+		struct lruvec *old_lruvec, *new_lruvec;
+		struct mem_cgroup *memcg;
+
+		memcg = page_memcg(page);
+		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
+		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
+
+		__dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
+		__inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
 		if (PageSwapBacked(page) && !PageSwapCache(page)) {
-			__dec_node_state(oldzone->zone_pgdat, NR_SHMEM);
-			__inc_node_state(newzone->zone_pgdat, NR_SHMEM);
+			__dec_lruvec_state(old_lruvec, NR_SHMEM);
+			__inc_lruvec_state(new_lruvec, NR_SHMEM);
 		}
 		if (dirty && mapping_cap_account_dirty(mapping)) {
 			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
diff --git a/mm/shmem.c b/mm/shmem.c
index 2384f6c7ef71..363bd11eba85 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -653,8 +653,8 @@ static int shmem_add_to_page_cache(struct page *page,
 			__inc_node_page_state(page, NR_SHMEM_THPS);
 		}
 		mapping->nrpages += nr;
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
-		__mod_node_page_state(page_pgdat(page), NR_SHMEM, nr);
+		__mod_lruvec_page_state(page, NR_FILE_PAGES, nr);
+		__mod_lruvec_page_state(page, NR_SHMEM, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -685,8 +685,8 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 	error = shmem_replace_entry(mapping, page->index, page, radswap);
 	page->mapping = NULL;
 	mapping->nrpages--;
-	__dec_node_page_state(page, NR_FILE_PAGES);
-	__dec_node_page_state(page, NR_SHMEM);
+	__dec_lruvec_page_state(page, NR_FILE_PAGES);
+	__dec_lruvec_page_state(page, NR_SHMEM);
 	xa_unlock_irq(&mapping->i_pages);
 	put_page(page);
 	BUG_ON(error);
@@ -1593,8 +1593,9 @@ static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 	xa_lock_irq(&swap_mapping->i_pages);
 	error = shmem_replace_entry(swap_mapping, swap_index, oldpage, newpage);
 	if (!error) {
-		__inc_node_page_state(newpage, NR_FILE_PAGES);
-		__dec_node_page_state(oldpage, NR_FILE_PAGES);
+		mem_cgroup_migrate(oldpage, newpage);
+		__inc_lruvec_page_state(newpage, NR_FILE_PAGES);
+		__dec_lruvec_page_state(oldpage, NR_FILE_PAGES);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
@@ -1606,7 +1607,6 @@ static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 		 */
 		oldpage = newpage;
 	} else {
-		mem_cgroup_migrate(oldpage, newpage);
 		lru_cache_add_anon(newpage);
 		*pagep = newpage;
 	}
-- 
2.26.0


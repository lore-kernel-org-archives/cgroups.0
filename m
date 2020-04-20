From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 11/18] mm: memcontrol: switch to native NR_ANON_THPS counter
Date: Mon, 20 Apr 2020 18:11:19 -0400
Message-ID: <20200420221126.341272-12-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h4sszY9+iyxzegLwaFGW6mKXEYImb/Xgfmc+Qp7VzPA=;
        b=0hvnCh2sHCpHj/iDv6YbtiQbGPzCK1g7DZo3JZPtIv5PBUke5TV+OzkugiA0B6Ab2E
         iiEfLG/uLRttNpn4drUFBZJYg0zlN3U+4HX9Y7+cO2Kd1afetjuCulns45h3NPTHrOsw
         7bf0ro2xgbgLprmUYCRv7fiDrbEoSEEgePoF9Gg1vggDWyMHoSeBgpDzY8vqoFBVhBQX
         XvfTy6rEDQO8FvIE40ShDKvWJl/XG2BHybuXNya9cXiBuFcf8pd1L/ib8L8xHBMZ2SNh
         Enpy0DjL1m9rX/AzESUtzoZihJUPJZNf0J0xlWu3m2xW7GtUPzLJWO3mvaskuzfQrhqJ
         cdcg==
In-Reply-To: <20200420221126.341272-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

With rmap memcg locking already in place for NR_ANON_MAPPED, it's just
a small step to remove the MEMCG_RSS_HUGE wart and switch memcg to the
native NR_ANON_THPS accounting sites.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/memcontrol.h |  3 +--
 mm/huge_memory.c           |  4 +++-
 mm/memcontrol.c            | 39 ++++++++++++++++----------------------
 mm/rmap.c                  |  6 +++---
 4 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bfb1d961e346..9ac8122ec1cd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -29,8 +29,7 @@ struct kmem_cache;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
-	MEMCG_RSS_HUGE = NR_VM_NODE_STAT_ITEMS,
-	MEMCG_SWAP,
+	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	/* XXX: why are these zone and not node counters? */
 	MEMCG_KERNEL_STACK_KB,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e9355a463e74..da6c413a75a5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2359,15 +2359,17 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			atomic_inc(&page[i]._mapcount);
 	}
 
+	lock_page_memcg(page);
 	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
 		/* Last compound_mapcount is gone. */
-		__dec_node_page_state(page, NR_ANON_THPS);
+		__dec_lruvec_page_state(page, NR_ANON_THPS);
 		if (TestClearPageDoubleMap(page)) {
 			/* No need in mapcount reference anymore */
 			for (i = 0; i < HPAGE_PMD_NR; i++)
 				atomic_dec(&page[i]._mapcount);
 		}
 	}
+	unlock_page_memcg(page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c87178d6219f..7845a87b94d5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -836,11 +836,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 struct page *page,
 					 int nr_pages)
 {
-	if (abs(nr_pages) > 1) {
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		__mod_memcg_state(memcg, MEMCG_RSS_HUGE, nr_pages);
-	}
-
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
 		__count_memcg_events(memcg, PGPGIN, 1);
@@ -1406,15 +1401,9 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 		       (u64)memcg_page_state(memcg, NR_WRITEBACK) *
 		       PAGE_SIZE);
 
-	/*
-	 * TODO: We should eventually replace our own MEMCG_RSS_HUGE counter
-	 * with the NR_ANON_THP vm counter, but right now it's a pain in the
-	 * arse because it requires migrating the work out of rmap to a place
-	 * where the page->mem_cgroup is set up and stable.
-	 */
 	seq_buf_printf(&s, "anon_thp %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_RSS_HUGE) *
-		       PAGE_SIZE);
+		       (u64)memcg_page_state(memcg, NR_ANON_THPS) *
+		       HPAGE_PMD_NR * PAGE_SIZE);
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_buf_printf(&s, "%s %llu\n", lru_list_name(i),
@@ -3006,8 +2995,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 
 	for (i = 1; i < HPAGE_PMD_NR; i++)
 		head[i].mem_cgroup = head->mem_cgroup;
-
-	__mod_memcg_state(head->mem_cgroup, MEMCG_RSS_HUGE, -HPAGE_PMD_NR);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -3762,7 +3749,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 static const unsigned int memcg1_stats[] = {
 	NR_FILE_PAGES,
 	NR_ANON_MAPPED,
-	MEMCG_RSS_HUGE,
+	NR_ANON_THPS,
 	NR_SHMEM,
 	NR_FILE_MAPPED,
 	NR_FILE_DIRTY,
@@ -3799,11 +3786,14 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
+		unsigned long nr;
+
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
-		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
-			   memcg_page_state_local(memcg, memcg1_stats[i]) *
-			   PAGE_SIZE);
+		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
+		if (memcg1_stats[i] == NR_ANON_THPS)
+			nr *= HPAGE_PMD_NR;
+		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -5392,6 +5382,13 @@ static int mem_cgroup_move_account(struct page *page,
 		if (page_mapped(page)) {
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
+			if (PageTransHuge(page)) {
+				__mod_lruvec_state(from_vec, NR_ANON_THPS,
+						   -nr_pages);
+				__mod_lruvec_state(to_vec, NR_ANON_THPS,
+						   nr_pages);
+			}
+
 		}
 	} else {
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
@@ -6611,7 +6608,6 @@ struct uncharge_gather {
 	unsigned long nr_pages;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	unsigned long nr_huge;
 	struct page *dummy_page;
 };
 
@@ -6634,7 +6630,6 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	}
 
 	local_irq_save(flags);
-	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
@@ -6673,8 +6668,6 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 	ug->nr_pages += nr_pages;
 
 	if (!PageKmemcg(page)) {
-		if (PageTransHuge(page))
-			ug->nr_huge += nr_pages;
 		ug->pgpgout++;
 	} else {
 		ug->nr_kmem += nr_pages;
diff --git a/mm/rmap.c b/mm/rmap.c
index 150513d31efa..ad4a0fdcc94c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1138,7 +1138,7 @@ void do_page_add_anon_rmap(struct page *page,
 		 * disabled.
 		 */
 		if (compound)
-			__inc_node_page_state(page, NR_ANON_THPS);
+			__inc_lruvec_page_state(page, NR_ANON_THPS);
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	}
 
@@ -1180,7 +1180,7 @@ void page_add_new_anon_rmap(struct page *page,
 		if (hpage_pincount_available(page))
 			atomic_set(compound_pincount_ptr(page), 0);
 
-		__inc_node_page_state(page, NR_ANON_THPS);
+		__inc_lruvec_page_state(page, NR_ANON_THPS);
 	} else {
 		/* Anon THP always mapped first with PMD */
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -1286,7 +1286,7 @@ static void page_remove_anon_compound_rmap(struct page *page)
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return;
 
-	__dec_node_page_state(page, NR_ANON_THPS);
+	__dec_lruvec_page_state(page, NR_ANON_THPS);
 
 	if (TestClearPageDoubleMap(page)) {
 		/*
-- 
2.26.0


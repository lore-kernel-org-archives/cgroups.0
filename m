From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] mm: memcontrol: Expose THP events on a per-memcg basis
Date: Tue, 29 Jan 2019 15:58:52 -0500
Message-ID: <20190129205852.GA7310@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=+lCxnlIZUJU9pZqCTFE3c/UHyRafPDqnnoPq+cvx5Es=;
        b=atRWCQe0OXSmeZ8tI433nmuVXC9/nf3+BVa2GFc+cDVIopGZtz4CpjFyBmLV5vlmE6
         f5YbVCdzOSSXQtZpiK7XBBVdOuoKCkdmprZnxWY0zYoyQYZDgU40xLVWJfPGojBjisSe
         /K00diZPmknhspvWEuz7lQEQrLtL1JiUXq/nU=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Currently THP allocation events data is fairly opaque, since you can
only get it system-wide. This patch makes it easier to reason about
transparent hugepage behaviour on a per-memcg basis.

For anonymous THP-backed pages, we already have MEMCG_RSS_HUGE in v1,
which is used for v1's rss_huge [sic]. This is reused here as it's
fairly involved to untangle NR_ANON_THPS right now to make it
per-memcg, since right now some of this is delegated to rmap before we
have any memcg actually assigned to the page. It's a good idea to rework
that, but let's leave untangling THP allocation for a future patch.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst | 14 ++++++++++++++
 mm/huge_memory.c                        |  2 ++
 mm/khugepaged.c                         |  2 ++
 mm/memcontrol.c                         | 13 +++++++++++++
 4 files changed, 31 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7bf3f129c68b..b6989b39ed8e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1189,6 +1189,10 @@ PAGE_SIZE multiple when read back.
 		Amount of cached filesystem data that was modified and
 		is currently being written back to disk
 
+	  anon_thp
+		Amount of memory used in anonymous mappings backed by
+		transparent hugepages
+
 	  inactive_anon, active_anon, inactive_file, active_file, unevictable
 		Amount of memory, swap-backed and filesystem-backed,
 		on the internal memory management lists used by the
@@ -1248,6 +1252,16 @@ PAGE_SIZE multiple when read back.
 
 		Amount of reclaimed lazyfree pages
 
+	  thp_fault_alloc
+
+		Number of transparent hugepages which were allocated to satisfy
+		a page fault, including COW faults
+
+	  thp_collapse_alloc
+
+		Number of transparent hugepages which were allocated to
+		allow collapsing an existing range of pages
+
   memory.swap.current
 	A read-only single value file which exists on non-root
 	cgroups.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f5f1d4324fe2..6cb7a748aa33 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -617,6 +617,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
+		count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
 	}
 
 	return 0;
@@ -1339,6 +1340,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 	}
 
 	count_vm_event(THP_FAULT_ALLOC);
+	count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
 
 	if (!page)
 		clear_huge_page(new_page, vmf->address, HPAGE_PMD_NR);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ceb242ca6ef6..54f3d33f897a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1075,6 +1075,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address, true);
 	mem_cgroup_commit_charge(new_page, memcg, false, true);
+	count_memcg_events(memcg, THP_COLLAPSE_ALLOC, 1);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
@@ -1503,6 +1504,7 @@ static void collapse_shmem(struct mm_struct *mm,
 		page_ref_add(new_page, HPAGE_PMD_NR - 1);
 		set_page_dirty(new_page);
 		mem_cgroup_commit_charge(new_page, memcg, false, true);
+		count_memcg_events(memcg, THP_COLLAPSE_ALLOC, 1);
 		lru_cache_add_anon(new_page);
 
 		/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 18f4aefbe0bf..2f4fe2fb9046 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5603,6 +5603,15 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "file_writeback %llu\n",
 		   (u64)acc.stat[NR_WRITEBACK] * PAGE_SIZE);
 
+	/*
+	 * TODO: We should eventually replace our own MEMCG_RSS_HUGE counter
+	 * with the NR_ANON_THP vm counter, but right now it's a pain in the
+	 * arse because it requires migrating the work out of rmap to a place
+	 * where the page->mem_cgroup is set up and stable.
+	 */
+	seq_printf(m, "anon_thp %llu\n",
+		   (u64)acc.stat[MEMCG_RSS_HUGE] * PAGE_SIZE);
+
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "%s %llu\n", mem_cgroup_lru_names[i],
 			   (u64)acc.lru_pages[i] * PAGE_SIZE);
@@ -5634,6 +5643,10 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "pglazyfree %lu\n", acc.events[PGLAZYFREE]);
 	seq_printf(m, "pglazyfreed %lu\n", acc.events[PGLAZYFREED]);
 
+	seq_printf(m, "thp_fault_alloc %lu\n", acc.events[THP_FAULT_ALLOC]);
+	seq_printf(m, "thp_collapse_alloc %lu\n",
+		   acc.events[THP_COLLAPSE_ALLOC]);
+
 	return 0;
 }
 
-- 
2.20.1


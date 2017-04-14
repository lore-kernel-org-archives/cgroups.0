From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm -v8 1/3] mm, THP, swap: Delay splitting THP during
 swap out
Date: Fri, 14 Apr 2017 10:58:56 -0400
Message-ID: <20170414145856.GA9812@cmpxchg.org>
References: <20170406053515.4842-1-ying.huang@intel.com>
 <20170406053515.4842-2-ying.huang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=32QmEn0oj5i4nL46EvanV/KsELCCca/2cwCt49kqPrI=; b=oyvbVRef/MKBzQn1EWMqUCcGqc
	/WkTcvmU1Gkv5XqXykj47aKBbZk/4/jVd1RafmMge1R1mss4REWLKgGUNHv1OJxp0medkEj0AerS9
	tZqi0e5Gf39PVG3b3Aly+Nid8tvK99Y8DmprpDBZJ3BQrFe86UgldGbBzKx3/Be57E0M=;
Content-Disposition: inline
In-Reply-To: <20170406053515.4842-2-ying.huang@intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ebru Akagunduz <ebru.akagunduz@gmail.com>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>, Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>, cgroups@vger.kernel.org

Hi Huang,

I reviewed this patch based on the feedback I already provided, but
eventually gave up and rewrote it. Please take review feedback more
seriously in the future.

Attached below is the reworked patch. Most changes are to the layering
(page functions, cluster functions, range functions) so that we don't
make the lowest swap range code require a notion of huge pages, or
make the memcg page functions take size information that can be
gathered from the page itself. I turned the config symbol into a
generic THP_SWAP that can later be extended when we add 2MB IO. The
rest is function naming, #ifdef removal etc.

Please review whether this is an acceptable version for you.

Thanks

---

From b90e48baa752840ba9c52f03a7a792c9b0c5b656 Mon Sep 17 00:00:00 2001
From: Huang Ying <ying.huang@intel.com>
Date: Thu, 6 Apr 2017 13:35:13 +0800
Subject: [PATCH] mm, THP, swap: Delay splitting THP during swap out
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

In this patch, splitting huge page is delayed from almost the first
step of swapping out to after allocating the swap space for the
THP (Transparent Huge Page) and adding the THP into the swap cache.
This will batch the corresponding operation, thus improve THP swap out
throughput.

This is the first step for the THP swap optimization.  The plan is to
delay splitting the THP step by step and avoid splitting the THP
finally.

The advantages of the THP swap support include:

- Batch the swap operations for the THP and reduce lock
  acquiring/releasing, including allocating/freeing the swap space,
  adding/deleting to/from the swap cache, and writing/reading the swap
  space, etc.  This will help to improve the THP swap performance.

- The THP swap space read/write will be 2M sequential IO.  It is
  particularly helpful for the swap read, which usually are 4k random
  IO.  This will help to improve the THP swap performance.

- It will help the memory fragmentation, especially when the THP is
  heavily used by the applications.  The 2M continuous pages will be
  free up after the THP swapping out.

- It will improve the THP utilization on the system with the swap
  turned on.  Because the speed for khugepaged to collapse the normal
  pages into the THP is quite slow.  After the THP is split during the
  swapping out, it will take quite long time for the normal pages to
  collapse back into the THP after being swapped in.  The high THP
  utilization helps the efficiency of the page based memory management
  too.

There are some concerns regarding THP swap in, mainly because possible
enlarged read/write IO size (for swap in/out) may put more overhead on
the storage device.  To deal with that, the THP swap in should be
turned on only when necessary.  For example, it can be selected via
"always/never/madvise" logic, to be turned on globally, turned off
globally, or turned on only for VMA with MADV_HUGEPAGE, etc.

In this patch, one swap cluster is used to hold the contents of each
THP swapped out.  So, the size of the swap cluster is changed to that
of the THP (Transparent Huge Page) on x86_64 architecture (512).  For
other architectures which want such THP swap optimization,
ARCH_USES_THP_SWAP_CLUSTER needs to be selected in the Kconfig file
for the architecture.  In effect, this will enlarge swap cluster size
by 2 times on x86_64.  Which may make it harder to find a free cluster
when the swap space becomes fragmented.  So that, this may reduce the
continuous swap space allocation and sequential write in theory.  The
performance test in 0day shows no regressions caused by this.

In the future of THP swap optimization, some information of the
swapped out THP (such as compound map count) will be recorded in the
swap_cluster_info data structure.

The mem cgroup swap accounting functions are enhanced to support
charge or uncharge a swap cluster backing a THP as a whole.

The swap cluster allocate/free functions are added to allocate/free a
swap cluster for a THP.  A fair simple algorithm is used for swap
cluster allocation, that is, only the first swap device in priority
list will be tried to allocate the swap cluster.  The function will
fail if the trying is not successful, and the caller will fallback to
allocate a single swap slot instead.  This works good enough for
normal cases.  If the difference of the number of the free swap
clusters among multiple swap devices is significant, it is possible
that some THPs are split earlier than necessary.  For example, this
could be caused by big size difference among multiple swap devices.

The swap cache functions is enhanced to support add/delete THP to/from
the swap cache as a set of (HPAGE_PMD_NR) sub-pages.  This may be
enhanced in the future with multi-order radix tree.  But because we
will split the THP soon during swapping out, that optimization doesn't
make much sense for this first step.

The THP splitting functions are enhanced to support to split THP in
swap cache during swapping out.  The page lock will be held during
allocating the swap cluster, adding the THP into the swap cache and
splitting the THP.  So in the code path other than swapping out, if
the THP need to be split, the PageSwapCache(THP) will be always false.

With the patchset, the swap out throughput improves 14.9% (from about
3.77GB/s to about 4.34GB/s) in the vm-scalability swap-w-seq test case
with 8 processes.  The test is done on a Xeon E5 v3 system.  The swap
device used is a RAM simulated PMEM (persistent memory) device.  To
test the sequential swapping out, the test case creates 8 processes,
which sequentially allocate and write to the anonymous pages until the
RAM and part of the swap device is used up.

The detailed comparison result is as follow,

base             base+patchset
---------------- --------------------------
         %stddev     %change         %stddev
             \          |                \
   7043990 =B1  0%     +21.2%    8536807 =B1  0%  vm-scalability.throughput
    109.94 =B1  1%     -16.2%      92.09 =B1  0%  vm-scalability.time.elaps=
ed_time
   3957091 =B1  0%     +14.9%    4547173 =B1  0%  vmstat.swap.so
     31.46 =B1  1%     -38.3%      19.42 =B1  0%  perf-stat.cache-miss-rate%
      1.04 =B1  1%     +22.2%       1.27 =B1  0%  perf-stat.ipc
      9.33 =B1  2%     -60.7%       3.67 =B1  1%  perf-profile.calltrace.cy=
cles-pp.add_to_swap.shrink_page_list.shrink_inactive_list.shrink_node_memcg=
.shrink_node

The swap cluster is only available for SSD, so the THP swap
optimization in this patchset has no effect for HDD.

[hannes@cmpxchg.org: extensive cleanups and simplifications]
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: cgroups@vger.kernel.org
Suggested-by: Andrew Morton <akpm@linux-foundation.org> [for config option]
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com> [for changes=
 in huge_memory.c and huge_mm.h]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/Kconfig            |   1 +
 include/linux/page-flags.h  |   5 +-
 include/linux/swap.h        |  22 +++-
 include/linux/swap_cgroup.h |   6 +-
 mm/Kconfig                  |  12 +++
 mm/huge_memory.c            |  11 +-
 mm/memcontrol.c             |  49 ++++-----
 mm/shmem.c                  |   2 +-
 mm/swap_cgroup.c            |  40 +++++--
 mm/swap_slots.c             |  17 ++-
 mm/swap_state.c             | 114 ++++++++++++--------
 mm/swapfile.c               | 246 +++++++++++++++++++++++++++++++---------=
----
 12 files changed, 360 insertions(+), 165 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9a5af1e1cd61..247e7eed01b7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,6 +72,7 @@ config X86
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH if SMP
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
+	select ARCH_WANTS_THP_SWAP		if X86_64
 	select BUILDTIME_EXTABLE_SORT
 	select CLKEVT_I8253
 	select CLOCKSOURCE_VALIDATE_LAST_CYCLE
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6b5818d6de32..f4acd6c4f808 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -326,11 +326,12 @@ PAGEFLAG_FALSE(HighMem)
 #ifdef CONFIG_SWAP
 static __always_inline int PageSwapCache(struct page *page)
 {
+	page =3D compound_head(page);
 	return PageSwapBacked(page) && test_bit(PG_swapcache, &page->flags);
=20
 }
-SETPAGEFLAG(SwapCache, swapcache, PF_NO_COMPOUND)
-CLEARPAGEFLAG(SwapCache, swapcache, PF_NO_COMPOUND)
+SETPAGEFLAG(SwapCache, swapcache, PF_NO_TAIL)
+CLEARPAGEFLAG(SwapCache, swapcache, PF_NO_TAIL)
 #else
 PAGEFLAG_FALSE(SwapCache)
 #endif
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 486494e6b2fc..34adac6e9457 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -29,6 +29,12 @@ struct bio;
 				 SWAP_FLAG_DISCARD_PAGES)
 #define SWAP_BATCH 64
=20
+#ifdef CONFIG_THP_SWAP
+#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
+#else
+#define SWAPFILE_CLUSTER	256
+#endif
+
 static inline int current_is_kswapd(void)
 {
 	return current->flags & PF_KSWAPD;
@@ -386,15 +392,16 @@ static inline long get_nr_swap_pages(void)
 }
=20
 extern void si_swapinfo(struct sysinfo *);
-extern swp_entry_t get_swap_page(void);
+extern swp_entry_t get_swap_page(struct page *);
 extern swp_entry_t get_swap_page_of_type(int);
-extern int get_swap_pages(int n, swp_entry_t swp_entries[]);
+extern int get_swap_pages(int n, bool cluster, swp_entry_t swp_entries[]);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
 extern void swapcache_free(swp_entry_t);
+extern void swapcache_free_cluster(swp_entry_t);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
@@ -460,6 +467,10 @@ static inline void swapcache_free(swp_entry_t swp)
 {
 }
=20
+static inline void swapcache_free_cluster(swp_entry_t swp)
+{
+}
+
 static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mas=
k,
 			struct vm_area_struct *vma, unsigned long addr)
 {
@@ -518,7 +529,7 @@ static inline int try_to_free_swap(struct page *page)
 	return 0;
 }
=20
-static inline swp_entry_t get_swap_page(void)
+static inline swp_entry_t get_swap_page(struct page *page)
 {
 	swp_entry_t entry;
 	entry.val =3D 0;
@@ -551,7 +562,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgro=
up *mem)
 #ifdef CONFIG_MEMCG_SWAP
 extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
 extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry=
);
-extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
+extern void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pa=
ges);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct page *page);
 #else
@@ -565,7 +576,8 @@ static inline int mem_cgroup_try_charge_swap(struct pag=
e *page,
 	return 0;
 }
=20
-static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
+static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
+					    unsigned int nr_pages)
 {
 }
=20
diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
index 145306bdc92f..b2b8ec7bda3f 100644
--- a/include/linux/swap_cgroup.h
+++ b/include/linux/swap_cgroup.h
@@ -7,7 +7,8 @@
=20
 extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new);
-extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short i=
d);
+extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short i=
d,
+					 unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
 extern void swap_cgroup_swapoff(int type);
@@ -15,7 +16,8 @@ extern void swap_cgroup_swapoff(int type);
 #else
=20
 static inline
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
+				  unsigned int nr_ents)
 {
 	return 0;
 }
diff --git a/mm/Kconfig b/mm/Kconfig
index c89f472b658c..660fb765bf7d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -447,6 +447,18 @@ choice
 	  benefit.
 endchoice
=20
+config ARCH_WANTS_THP_SWAP
+       def_bool n
+
+config THP_SWAP
+	def_bool y
+	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP
+	help
+	  Swap transparent huge pages in one piece, without splitting.
+	  XXX: For now this only does clustered swap space allocation.
+
+	  For selection by architectures with reasonable THP sizes.
+
 config	TRANSPARENT_HUGE_PAGECACHE
 	def_bool y
 	depends on TRANSPARENT_HUGEPAGE
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d14dd961f626..4a5c1ca21894 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2185,7 +2185,7 @@ static void __split_huge_page_tail(struct page *head,=
 int tail,
 	 * atomic_set() here would be safe on all archs (and not only on x86),
 	 * it's safer to use atomic_inc()/atomic_add().
 	 */
-	if (PageAnon(head)) {
+	if (PageAnon(head) && !PageSwapCache(head)) {
 		page_ref_inc(page_tail);
 	} else {
 		/* Additional pin to radix tree */
@@ -2196,6 +2196,7 @@ static void __split_huge_page_tail(struct page *head,=
 int tail,
 	page_tail->flags |=3D (head->flags &
 			((1L << PG_referenced) |
 			 (1L << PG_swapbacked) |
+			 (1L << PG_swapcache) |
 			 (1L << PG_mlocked) |
 			 (1L << PG_uptodate) |
 			 (1L << PG_active) |
@@ -2258,7 +2259,11 @@ static void __split_huge_page(struct page *page, str=
uct list_head *list,
 	ClearPageCompound(head);
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
-		page_ref_inc(head);
+		/* Additional pin to radix tree of swap cache */
+		if (PageSwapCache(head))
+			page_ref_add(head, 2);
+		else
+			page_ref_inc(head);
 	} else {
 		/* Additional pin to radix tree */
 		page_ref_add(head, 2);
@@ -2414,7 +2419,7 @@ int split_huge_page_to_list(struct page *page, struct=
 list_head *list)
 			ret =3D -EBUSY;
 			goto out;
 		}
-		extra_pins =3D 0;
+		extra_pins =3D PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 		mapping =3D NULL;
 		anon_vma_lock_write(anon_vma);
 	} else {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ff73899af61a..609fd5e1895f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2376,10 +2376,9 @@ void mem_cgroup_split_huge_fixup(struct page *head)
=20
 #ifdef CONFIG_MEMCG_SWAP
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
-					 bool charge)
+				       int nr_entries)
 {
-	int val =3D (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEMCG_SWAP], val);
+	this_cpu_add(memcg->stat->count[MEMCG_SWAP], nr_entries);
 }
=20
 /**
@@ -2405,8 +2404,8 @@ static int mem_cgroup_move_swap_account(swp_entry_t e=
ntry,
 	new_id =3D mem_cgroup_id(to);
=20
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) =3D=3D old_id) {
-		mem_cgroup_swap_statistics(from, false);
-		mem_cgroup_swap_statistics(to, true);
+		mem_cgroup_swap_statistics(from, -1);
+		mem_cgroup_swap_statistics(to, 1);
 		return 0;
 	}
 	return -EINVAL;
@@ -5445,7 +5444,7 @@ void mem_cgroup_commit_charge(struct page *page, stru=
ct mem_cgroup *memcg,
 		 * let's not wait for it.  The page already received a
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
-		mem_cgroup_uncharge_swap(entry);
+		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
 }
=20
@@ -5873,9 +5872,9 @@ void mem_cgroup_swapout(struct page *page, swp_entry_=
t entry)
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
 	swap_memcg =3D mem_cgroup_id_get_online(memcg);
-	oldid =3D swap_cgroup_record(entry, mem_cgroup_id(swap_memcg));
+	oldid =3D swap_cgroup_record(entry, mem_cgroup_id(swap_memcg), 1);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(swap_memcg, true);
+	mem_cgroup_swap_statistics(swap_memcg, 1);
=20
 	page->mem_cgroup =3D NULL;
=20
@@ -5902,19 +5901,20 @@ void mem_cgroup_swapout(struct page *page, swp_entr=
y_t entry)
 		css_put(&memcg->css);
 }
=20
-/*
- * mem_cgroup_try_charge_swap - try charging a swap entry
+/**
+ * mem_cgroup_try_charge_swap - try charging swap space for a page
  * @page: page being added to swap
  * @entry: swap entry to charge
  *
- * Try to charge @entry to the memcg that @page belongs to.
+ * Try to charge @page's memcg for the swap space at @entry.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
 int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 {
-	struct mem_cgroup *memcg;
+	unsigned int nr_pages =3D hpage_nr_pages(page);
 	struct page_counter *counter;
+	struct mem_cgroup *memcg;
 	unsigned short oldid;
=20
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) || !do_swap_account)
@@ -5929,25 +5929,26 @@ int mem_cgroup_try_charge_swap(struct page *page, s=
wp_entry_t entry)
 	memcg =3D mem_cgroup_id_get_online(memcg);
=20
 	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, 1, &counter)) {
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
 	}
=20
-	oldid =3D swap_cgroup_record(entry, mem_cgroup_id(memcg));
+	if (nr_entries > 1)
+		mem_cgroup_id_get_many(memcg, nr_pages - 1);
+	oldid =3D swap_cgroup_record(entry, mem_cgroup_id(memcg), nr_pages);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(memcg, true);
+	mem_cgroup_swap_statistics(memcg, nr_pages);
=20
 	return 0;
 }
=20
 /**
- * mem_cgroup_uncharge_swap - uncharge a swap entry
+ * mem_cgroup_uncharge_swap - uncharge swap space
  * @entry: swap entry to uncharge
- *
- * Drop the swap charge associated with @entry.
+ * @nr_pages: the amount of swap space to uncharge
  */
-void mem_cgroup_uncharge_swap(swp_entry_t entry)
+void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
 	unsigned short id;
@@ -5955,18 +5956,18 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry)
 	if (!do_swap_account)
 		return;
=20
-	id =3D swap_cgroup_record(entry, 0);
+	id =3D swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg =3D mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-				page_counter_uncharge(&memcg->swap, 1);
+				page_counter_uncharge(&memcg->swap, nr_pages);
 			else
-				page_counter_uncharge(&memcg->memsw, 1);
+				page_counter_uncharge(&memcg->memsw, nr_pages);
 		}
-		mem_cgroup_swap_statistics(memcg, false);
-		mem_cgroup_id_put(memcg);
+		mem_cgroup_swap_statistics(memcg, -nr_pages);
+		mem_cgroup_id_put_many(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index e67d6ba4e98e..29948d7da172 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1290,7 +1290,7 @@ static int shmem_writepage(struct page *page, struct =
writeback_control *wbc)
 		SetPageUptodate(page);
 	}
=20
-	swap =3D get_swap_page();
+	swap =3D get_swap_page(page);
 	if (!swap.val)
 		goto redirty;
=20
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 310ac0b8f974..8cee2d125815 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -58,21 +58,27 @@ static int swap_cgroup_prepare(int type)
 	return -ENOMEM;
 }
=20
+static struct swap_cgroup *__lookup_swap_cgroup(struct swap_cgroup_ctrl *c=
trl,
+						pgoff_t offset)
+{
+	struct page *mappage;
+	struct swap_cgroup *sc;
+
+	mappage =3D ctrl->map[offset / SC_PER_PAGE];
+	sc =3D page_address(mappage);
+	return sc + offset % SC_PER_PAGE;
+}
+
 static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
 					struct swap_cgroup_ctrl **ctrlp)
 {
 	pgoff_t offset =3D swp_offset(ent);
 	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
-	struct swap_cgroup *sc;
=20
 	ctrl =3D &swap_cgroup_ctrl[swp_type(ent)];
 	if (ctrlp)
 		*ctrlp =3D ctrl;
-
-	mappage =3D ctrl->map[offset / SC_PER_PAGE];
-	sc =3D page_address(mappage);
-	return sc + offset % SC_PER_PAGE;
+	return __lookup_swap_cgroup(ctrl, offset);
 }
=20
 /**
@@ -105,25 +111,39 @@ unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 }
=20
 /**
- * swap_cgroup_record - record mem_cgroup for this swp_entry.
- * @ent: swap entry to be recorded into
+ * swap_cgroup_record - record mem_cgroup for a set of swap entries
+ * @ent: the first swap entry to be recorded into
  * @id: mem_cgroup to be recorded
+ * @nr_ents: number of swap entries to be recorded
  *
  * Returns old value at success, 0 at failure.
  * (Of course, old value can be 0.)
  */
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
+				  unsigned int nr_ents)
 {
 	struct swap_cgroup_ctrl *ctrl;
 	struct swap_cgroup *sc;
 	unsigned short old;
 	unsigned long flags;
+	pgoff_t offset =3D swp_offset(ent);
+	pgoff_t end =3D offset + nr_ents;
=20
 	sc =3D lookup_swap_cgroup(ent, &ctrl);
=20
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old =3D sc->id;
-	sc->id =3D id;
+	for (;;) {
+		VM_BUG_ON(sc->id !=3D old);
+		sc->id =3D id;
+		offset++;
+		if (offset =3D=3D end)
+			break;
+		if (offset % SC_PER_PAGE)
+			sc++;
+		else
+			sc =3D __lookup_swap_cgroup(ctrl, offset);
+	}
 	spin_unlock_irqrestore(&ctrl->lock, flags);
=20
 	return old;
diff --git a/mm/swap_slots.c b/mm/swap_slots.c
index aa1c415f4abd..e22e64712b1a 100644
--- a/mm/swap_slots.c
+++ b/mm/swap_slots.c
@@ -31,6 +31,7 @@
 #include <linux/cpumask.h>
 #include <linux/vmalloc.h>
 #include <linux/mutex.h>
+#include <linux/mm.h>
=20
 #ifdef CONFIG_SWAP
=20
@@ -260,7 +261,8 @@ static int refill_swap_slots_cache(struct swap_slots_ca=
che *cache)
=20
 	cache->cur =3D 0;
 	if (swap_slot_cache_active)
-		cache->nr =3D get_swap_pages(SWAP_SLOTS_CACHE_SIZE, cache->slots);
+		cache->nr =3D get_swap_pages(SWAP_SLOTS_CACHE_SIZE, false,
+					   cache->slots);
=20
 	return cache->nr;
 }
@@ -298,11 +300,19 @@ int free_swap_slot(swp_entry_t entry)
 	return 0;
 }
=20
-swp_entry_t get_swap_page(void)
+swp_entry_t get_swap_page(struct page *page)
 {
 	swp_entry_t entry, *pentry;
 	struct swap_slots_cache *cache;
=20
+	entry.val =3D 0;
+
+	if (PageTransHuge(page)) {
+		if (hpage_nr_pages(page) =3D=3D SWAPFILE_CLUSTER)
+			get_swap_pages(1, true, &entry);
+		return entry;
+	}
+
 	/*
 	 * Preemption is allowed here, because we may sleep
 	 * in refill_swap_slots_cache().  But it is safe, because
@@ -314,7 +324,6 @@ swp_entry_t get_swap_page(void)
 	 */
 	cache =3D raw_cpu_ptr(&swp_slots);
=20
-	entry.val =3D 0;
 	if (check_cache_active()) {
 		mutex_lock(&cache->alloc_lock);
 		if (cache->slots) {
@@ -334,7 +343,7 @@ swp_entry_t get_swap_page(void)
 			return entry;
 	}
=20
-	get_swap_pages(1, &entry);
+	get_swap_pages(1, false, &entry);
=20
 	return entry;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 7bfb9bd1ca21..747d0ed2e811 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -19,6 +19,7 @@
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
+#include <linux/huge_mm.h>
=20
 #include <asm/pgtable.h>
=20
@@ -38,6 +39,7 @@ struct address_space *swapper_spaces[MAX_SWAPFILES];
 static unsigned int nr_swapper_spaces[MAX_SWAPFILES];
=20
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
+#define ADD_CACHE_INFO(x, nr)	do { swap_cache_info.x +=3D (nr); } while (0)
=20
 static struct {
 	unsigned long add_total;
@@ -90,39 +92,46 @@ void show_swap_cache_info(void)
  */
 int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
-	int error;
+	int error, i, nr =3D hpage_nr_pages(page);
 	struct address_space *address_space;
+	pgoff_t idx =3D swp_offset(entry);
=20
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
=20
-	get_page(page);
+	page_ref_add(page, nr);
 	SetPageSwapCache(page);
-	set_page_private(page, entry.val);
=20
 	address_space =3D swap_address_space(entry);
 	spin_lock_irq(&address_space->tree_lock);
-	error =3D radix_tree_insert(&address_space->page_tree,
-				  swp_offset(entry), page);
-	if (likely(!error)) {
-		address_space->nrpages++;
-		__inc_node_page_state(page, NR_FILE_PAGES);
-		INC_CACHE_INFO(add_total);
+	for (i =3D 0; i < nr; i++) {
+		set_page_private(page + i, entry.val + i);
+		error =3D radix_tree_insert(&address_space->page_tree,
+					  idx + i, page + i);
+		if (unlikely(error))
+			break;
 	}
-	spin_unlock_irq(&address_space->tree_lock);
-
-	if (unlikely(error)) {
+	if (likely(!error)) {
+		address_space->nrpages +=3D nr;
+		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
+		ADD_CACHE_INFO(add_total, nr);
+	} else {
 		/*
 		 * Only the context which have set SWAP_HAS_CACHE flag
 		 * would call add_to_swap_cache().
 		 * So add_to_swap_cache() doesn't returns -EEXIST.
 		 */
 		VM_BUG_ON(error =3D=3D -EEXIST);
-		set_page_private(page, 0UL);
+		set_page_private(page + i, 0UL);
+		while (i--) {
+			radix_tree_delete(&address_space->page_tree, idx + i);
+			set_page_private(page + i, 0UL);
+		}
 		ClearPageSwapCache(page);
-		put_page(page);
+		page_ref_sub(page, nr);
 	}
+	spin_unlock_irq(&address_space->tree_lock);
=20
 	return error;
 }
@@ -132,7 +141,7 @@ int add_to_swap_cache(struct page *page, swp_entry_t en=
try, gfp_t gfp_mask)
 {
 	int error;
=20
-	error =3D radix_tree_maybe_preload(gfp_mask);
+	error =3D radix_tree_maybe_preload_order(gfp_mask, compound_order(page));
 	if (!error) {
 		error =3D __add_to_swap_cache(page, entry);
 		radix_tree_preload_end();
@@ -146,8 +155,10 @@ int add_to_swap_cache(struct page *page, swp_entry_t e=
ntry, gfp_t gfp_mask)
  */
 void __delete_from_swap_cache(struct page *page)
 {
-	swp_entry_t entry;
 	struct address_space *address_space;
+	int i, nr =3D hpage_nr_pages(page);
+	swp_entry_t entry;
+	pgoff_t idx;
=20
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
@@ -155,12 +166,15 @@ void __delete_from_swap_cache(struct page *page)
=20
 	entry.val =3D page_private(page);
 	address_space =3D swap_address_space(entry);
-	radix_tree_delete(&address_space->page_tree, swp_offset(entry));
-	set_page_private(page, 0);
+	idx =3D swp_offset(entry);
+	for (i =3D 0; i < nr; i++) {
+		radix_tree_delete(&address_space->page_tree, idx + i);
+		set_page_private(page + i, 0);
+	}
 	ClearPageSwapCache(page);
-	address_space->nrpages--;
-	__dec_node_page_state(page, NR_FILE_PAGES);
-	INC_CACHE_INFO(del_total);
+	address_space->nrpages -=3D nr;
+	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	ADD_CACHE_INFO(del_total, nr);
 }
=20
 /**
@@ -178,20 +192,12 @@ int add_to_swap(struct page *page, struct list_head *=
list)
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageUptodate(page), page);
=20
-	entry =3D get_swap_page();
+retry:
+	entry =3D get_swap_page(page);
 	if (!entry.val)
-		return 0;
-
-	if (mem_cgroup_try_charge_swap(page, entry)) {
-		swapcache_free(entry);
-		return 0;
-	}
-
-	if (unlikely(PageTransHuge(page)))
-		if (unlikely(split_huge_page_to_list(page, list))) {
-			swapcache_free(entry);
-			return 0;
-		}
+		goto fail;
+	if (mem_cgroup_try_charge_swap(page, entry))
+		goto fail_free;
=20
 	/*
 	 * Radix-tree node allocations from PF_MEMALLOC contexts could
@@ -206,17 +212,33 @@ int add_to_swap(struct page *page, struct list_head *=
list)
 	 */
 	err =3D add_to_swap_cache(page, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
-
-	if (!err) {
-		return 1;
-	} else {	/* -ENOMEM radix-tree allocation failure */
+	/* -ENOMEM radix-tree allocation failure */
+	if (err)
 		/*
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
 		 * clear SWAP_HAS_CACHE flag.
 		 */
-		swapcache_free(entry);
-		return 0;
+		goto fail_free;
+
+	if (unlikely(PageTransHuge(page))) {
+		err =3D split_huge_page_to_list(page, list);
+		if (err) {
+			delete_from_swap_cache(page);
+			return 0;
+		}
 	}
+
+	return 1;
+
+fail_free:
+	if (PageTransHuge(page))
+		swapcache_free_cluster(entry);
+	else
+		swapcache_free(entry);
+fail:
+	if (PageTransHuge(page) && !split_huge_page_to_list(page, list))
+		goto retry;
+	return 0;
 }
=20
 /*
@@ -237,8 +259,12 @@ void delete_from_swap_cache(struct page *page)
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&address_space->tree_lock);
=20
-	swapcache_free(entry);
-	put_page(page);
+	if (PageTransHuge(page))
+		swapcache_free_cluster(entry);
+	else
+		swapcache_free(entry);
+
+	page_ref_sub(page, hpage_nr_pages(page));
 }
=20
 /*=20
@@ -295,7 +321,7 @@ struct page * lookup_swap_cache(swp_entry_t entry)
=20
 	page =3D find_get_page(swap_address_space(entry), swp_offset(entry));
=20
-	if (page) {
+	if (page && likely(!PageTransCompound(page))) {
 		INC_CACHE_INFO(find_success);
 		if (TestClearPageReadahead(page))
 			atomic_inc(&swapin_readahead_hits);
@@ -506,7 +532,7 @@ struct page *swapin_readahead(swp_entry_t entry, gfp_t =
gfp_mask,
 						gfp_mask, vma, addr);
 		if (!page)
 			continue;
-		if (offset !=3D entry_offset)
+		if (offset !=3D entry_offset && likely(!PageTransCompound(page)))
 			SetPageReadahead(page);
 		put_page(page);
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53b5881ee0d6..f597cabcaab7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -199,7 +199,6 @@ static void discard_swap_cluster(struct swap_info_struc=
t *si,
 	}
 }
=20
-#define SWAPFILE_CLUSTER	256
 #define LATENCY_LIMIT		256
=20
 static inline void cluster_set_flag(struct swap_cluster_info *info,
@@ -374,6 +373,14 @@ static void swap_cluster_schedule_discard(struct swap_=
info_struct *si,
 	schedule_work(&si->discard_work);
 }
=20
+static void __free_cluster(struct swap_info_struct *si, unsigned long idx)
+{
+	struct swap_cluster_info *ci =3D si->cluster_info;
+
+	cluster_set_flag(ci + idx, CLUSTER_FLAG_FREE);
+	cluster_list_add_tail(&si->free_clusters, ci, idx);
+}
+
 /*
  * Doing discard actually. After a cluster discard is finished, the cluster
  * will be added to free cluster list. caller should hold si->lock.
@@ -394,10 +401,7 @@ static void swap_do_scheduled_discard(struct swap_info=
_struct *si)
=20
 		spin_lock(&si->lock);
 		ci =3D lock_cluster(si, idx * SWAPFILE_CLUSTER);
-		cluster_set_flag(ci, CLUSTER_FLAG_FREE);
-		unlock_cluster(ci);
-		cluster_list_add_tail(&si->free_clusters, info, idx);
-		ci =3D lock_cluster(si, idx * SWAPFILE_CLUSTER);
+		__free_cluster(si, idx);
 		memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 				0, SWAPFILE_CLUSTER);
 		unlock_cluster(ci);
@@ -415,6 +419,34 @@ static void swap_discard_work(struct work_struct *work)
 	spin_unlock(&si->lock);
 }
=20
+static void alloc_cluster(struct swap_info_struct *si, unsigned long idx)
+{
+	struct swap_cluster_info *ci =3D si->cluster_info;
+
+	VM_BUG_ON(cluster_list_first(&si->free_clusters) !=3D idx);
+	cluster_list_del_first(&si->free_clusters, ci);
+	cluster_set_count_flag(ci + idx, 0, 0);
+}
+
+static void free_cluster(struct swap_info_struct *si, unsigned long idx)
+{
+	struct swap_cluster_info *ci =3D si->cluster_info + idx;
+
+	VM_BUG_ON(cluster_count(ci) !=3D 0);
+	/*
+	 * If the swap is discardable, prepare discard the cluster
+	 * instead of free it immediately. The cluster will be freed
+	 * after discard.
+	 */
+	if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) =3D=3D
+	    (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
+		swap_cluster_schedule_discard(si, idx);
+		return;
+	}
+
+	__free_cluster(si, idx);
+}
+
 /*
  * The cluster corresponding to page_nr will be used. The cluster will be
  * removed from free cluster list and its usage counter will be increased.
@@ -426,11 +458,8 @@ static void inc_cluster_info_page(struct swap_info_str=
uct *p,
=20
 	if (!cluster_info)
 		return;
-	if (cluster_is_free(&cluster_info[idx])) {
-		VM_BUG_ON(cluster_list_first(&p->free_clusters) !=3D idx);
-		cluster_list_del_first(&p->free_clusters, cluster_info);
-		cluster_set_count_flag(&cluster_info[idx], 0, 0);
-	}
+	if (cluster_is_free(&cluster_info[idx]))
+		alloc_cluster(p, idx);
=20
 	VM_BUG_ON(cluster_count(&cluster_info[idx]) >=3D SWAPFILE_CLUSTER);
 	cluster_set_count(&cluster_info[idx],
@@ -454,21 +483,8 @@ static void dec_cluster_info_page(struct swap_info_str=
uct *p,
 	cluster_set_count(&cluster_info[idx],
 		cluster_count(&cluster_info[idx]) - 1);
=20
-	if (cluster_count(&cluster_info[idx]) =3D=3D 0) {
-		/*
-		 * If the swap is discardable, prepare discard the cluster
-		 * instead of free it immediately. The cluster will be freed
-		 * after discard.
-		 */
-		if ((p->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) =3D=3D
-				 (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
-			swap_cluster_schedule_discard(p, idx);
-			return;
-		}
-
-		cluster_set_flag(&cluster_info[idx], CLUSTER_FLAG_FREE);
-		cluster_list_add_tail(&p->free_clusters, cluster_info, idx);
-	}
+	if (cluster_count(&cluster_info[idx]) =3D=3D 0)
+		free_cluster(p, idx);
 }
=20
 /*
@@ -558,6 +574,60 @@ static bool scan_swap_map_try_ssd_cluster(struct swap_=
info_struct *si,
 	return found_free;
 }
=20
+static void swap_range_alloc(struct swap_info_struct *si, unsigned long of=
fset,
+			     unsigned int nr_entries)
+{
+	unsigned int end =3D offset + nr_entries - 1;
+
+	if (offset =3D=3D si->lowest_bit)
+		si->lowest_bit +=3D nr_entries;
+	if (end =3D=3D si->highest_bit)
+		si->highest_bit -=3D nr_entries;
+	si->inuse_pages +=3D nr_entries;
+	if (si->inuse_pages =3D=3D si->pages) {
+		si->lowest_bit =3D si->max;
+		si->highest_bit =3D 0;
+		spin_lock(&swap_avail_lock);
+		plist_del(&si->avail_list, &swap_avail_head);
+		spin_unlock(&swap_avail_lock);
+	}
+}
+
+static void swap_range_free(struct swap_info_struct *si, unsigned long off=
set,
+			    unsigned int nr_entries)
+{
+	unsigned long end =3D offset + nr_entries - 1;
+	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+
+	if (offset < si->lowest_bit)
+		si->lowest_bit =3D offset;
+	if (end > si->highest_bit) {
+		bool was_full =3D !si->highest_bit;
+
+		si->highest_bit =3D end;
+		if (was_full && (si->flags & SWP_WRITEOK)) {
+			spin_lock(&swap_avail_lock);
+			WARN_ON(!plist_node_empty(&si->avail_list));
+			if (plist_node_empty(&si->avail_list))
+				plist_add(&si->avail_list, &swap_avail_head);
+			spin_unlock(&swap_avail_lock);
+		}
+	}
+	atomic_long_add(nr_entries, &nr_swap_pages);
+	si->inuse_pages -=3D nr_entries;
+	if (si->flags & SWP_BLKDEV)
+		swap_slot_free_notify =3D
+			si->bdev->bd_disk->fops->swap_slot_free_notify;
+	else
+		swap_slot_free_notify =3D NULL;
+	while (offset <=3D end) {
+		frontswap_invalidate_page(si->type, offset);
+		if (swap_slot_free_notify)
+			swap_slot_free_notify(si->bdev, offset);
+		offset++;
+	}
+}
+
 static int scan_swap_map_slots(struct swap_info_struct *si,
 			       unsigned char usage, int nr,
 			       swp_entry_t slots[])
@@ -676,18 +746,7 @@ static int scan_swap_map_slots(struct swap_info_struct=
 *si,
 	inc_cluster_info_page(si, si->cluster_info, offset);
 	unlock_cluster(ci);
=20
-	if (offset =3D=3D si->lowest_bit)
-		si->lowest_bit++;
-	if (offset =3D=3D si->highest_bit)
-		si->highest_bit--;
-	si->inuse_pages++;
-	if (si->inuse_pages =3D=3D si->pages) {
-		si->lowest_bit =3D si->max;
-		si->highest_bit =3D 0;
-		spin_lock(&swap_avail_lock);
-		plist_del(&si->avail_list, &swap_avail_head);
-		spin_unlock(&swap_avail_lock);
-	}
+	swap_range_alloc(si, offset, 1);
 	si->cluster_next =3D offset + 1;
 	slots[n_ret++] =3D swp_entry(si->type, offset);
=20
@@ -766,6 +825,44 @@ static int scan_swap_map_slots(struct swap_info_struct=
 *si,
 	return n_ret;
 }
=20
+static int swap_alloc_cluster(struct swap_info_struct *si, swp_entry_t *sl=
ot)
+{
+	unsigned long idx;
+	struct swap_cluster_info *ci;
+	unsigned long offset, i;
+	unsigned char *map;
+
+	if (cluster_list_empty(&si->free_clusters))
+		return 0;
+
+	idx =3D cluster_list_first(&si->free_clusters);
+	offset =3D idx * SWAPFILE_CLUSTER;
+	ci =3D lock_cluster(si, offset);
+	alloc_cluster(si, idx);
+	cluster_set_count_flag(ci, SWAPFILE_CLUSTER, 0);
+
+	map =3D si->swap_map + offset;
+	for (i =3D 0; i < SWAPFILE_CLUSTER; i++)
+		map[i] =3D SWAP_HAS_CACHE;
+	unlock_cluster(ci);
+	swap_range_alloc(si, offset, SWAPFILE_CLUSTER);
+	*slot =3D swp_entry(si->type, offset);
+
+	return 1;
+}
+
+static void swap_free_cluster(struct swap_info_struct *si, unsigned long i=
dx)
+{
+	unsigned long offset =3D idx * SWAPFILE_CLUSTER;
+	struct swap_cluster_info *ci;
+
+	ci =3D lock_cluster(si, offset);
+	cluster_set_count_flag(ci, 0, 0);
+	free_cluster(si, idx);
+	unlock_cluster(ci);
+	swap_range_free(si, offset, SWAPFILE_CLUSTER);
+}
+
 static unsigned long scan_swap_map(struct swap_info_struct *si,
 				   unsigned char usage)
 {
@@ -781,13 +878,17 @@ static unsigned long scan_swap_map(struct swap_info_s=
truct *si,
=20
 }
=20
-int get_swap_pages(int n_goal, swp_entry_t swp_entries[])
+int get_swap_pages(int n_goal, bool cluster, swp_entry_t swp_entries[])
 {
+	unsigned long nr_pages =3D cluster ? SWAPFILE_CLUSTER : 1;
 	struct swap_info_struct *si, *next;
 	long avail_pgs;
 	int n_ret =3D 0;
=20
-	avail_pgs =3D atomic_long_read(&nr_swap_pages);
+	/* Only single cluster request supported */
+	WARN_ON_ONCE(n_goal > 1 && cluster);
+
+	avail_pgs =3D atomic_long_read(&nr_swap_pages) / nr_pages;
 	if (avail_pgs <=3D 0)
 		goto noswap;
=20
@@ -797,7 +898,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[=
])
 	if (n_goal > avail_pgs)
 		n_goal =3D avail_pgs;
=20
-	atomic_long_sub(n_goal, &nr_swap_pages);
+	atomic_long_sub(n_goal * nr_pages, &nr_swap_pages);
=20
 	spin_lock(&swap_avail_lock);
=20
@@ -823,10 +924,13 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entrie=
s[])
 			spin_unlock(&si->lock);
 			goto nextsi;
 		}
-		n_ret =3D scan_swap_map_slots(si, SWAP_HAS_CACHE,
-					    n_goal, swp_entries);
+		if (likely(cluster))
+			n_ret =3D swap_alloc_cluster(si, swp_entries);
+		else
+			n_ret =3D scan_swap_map_slots(si, SWAP_HAS_CACHE,
+						    n_goal, swp_entries);
 		spin_unlock(&si->lock);
-		if (n_ret)
+		if (n_ret || unlikely(cluster))
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
@@ -852,7 +956,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[=
])
=20
 check_out:
 	if (n_ret < n_goal)
-		atomic_long_add((long) (n_goal-n_ret), &nr_swap_pages);
+		atomic_long_add((long)(n_goal-n_ret) * nr_pages, &nr_swap_pages);
 noswap:
 	return n_ret;
 }
@@ -1008,32 +1112,8 @@ static void swap_entry_free(struct swap_info_struct =
*p, swp_entry_t entry)
 	dec_cluster_info_page(p, p->cluster_info, offset);
 	unlock_cluster(ci);
=20
-	mem_cgroup_uncharge_swap(entry);
-	if (offset < p->lowest_bit)
-		p->lowest_bit =3D offset;
-	if (offset > p->highest_bit) {
-		bool was_full =3D !p->highest_bit;
-
-		p->highest_bit =3D offset;
-		if (was_full && (p->flags & SWP_WRITEOK)) {
-			spin_lock(&swap_avail_lock);
-			WARN_ON(!plist_node_empty(&p->avail_list));
-			if (plist_node_empty(&p->avail_list))
-				plist_add(&p->avail_list,
-					  &swap_avail_head);
-			spin_unlock(&swap_avail_lock);
-		}
-	}
-	atomic_long_inc(&nr_swap_pages);
-	p->inuse_pages--;
-	frontswap_invalidate_page(p->type, offset);
-	if (p->flags & SWP_BLKDEV) {
-		struct gendisk *disk =3D p->bdev->bd_disk;
-
-		if (disk->fops->swap_slot_free_notify)
-			disk->fops->swap_slot_free_notify(p->bdev,
-							  offset);
-	}
+	mem_cgroup_uncharge_swap(entry, 1);
+	swap_range_free(p, offset, 1);
 }
=20
 /*
@@ -1065,6 +1145,32 @@ void swapcache_free(swp_entry_t entry)
 	}
 }
=20
+void swapcache_free_cluster(swp_entry_t entry)
+{
+	unsigned long offset =3D swp_offset(entry);
+	unsigned long idx =3D offset / SWAPFILE_CLUSTER;
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *si;
+	unsigned char *map;
+	unsigned int i;
+
+	si =3D _swap_info_get(entry);
+	if (!si)
+		return;
+
+	spin_lock(&si->lock);
+	ci =3D lock_cluster(si, offset);
+	map =3D si->swap_map + offset;
+	for (i =3D 0; i < SWAPFILE_CLUSTER; i++) {
+		VM_BUG_ON(map[i] !=3D SWAP_HAS_CACHE);
+		map[i] =3D 0;
+	}
+	unlock_cluster(ci);
+	mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
+	swap_free_cluster(si, idx);
+	spin_unlock(&si->lock);
+}
+
 void swapcache_free_entries(swp_entry_t *entries, int n)
 {
 	struct swap_info_struct *p, *prev;
--=20
2.12.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>

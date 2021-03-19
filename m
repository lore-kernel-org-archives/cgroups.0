From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2/2] mm: memcontrol: deprecate swapaccounting=0 mode
Date: Fri, 19 Mar 2021 01:49:44 -0400
Message-ID: <20210319054944.50048-2-hannes@cmpxchg.org>
References: <20210319054944.50048-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E7sBW4F64Yeve4G2OY61bXlD1TuI/N6BQ+ZyRs716mU=;
        b=Uw2Df0gIpwjHNj5AE/FM1E3j6A+McyZDaI9/AZSvt4/fBU8yA7/d+g65kqPA8DTIRW
         525xTirccAohk84UcAcpgfo5SDWcMkshV8Uyrti+6ruWraAZrwYMScMxV/zB243sjJXu
         zwEvOh46e6ByKkAUj0c1bI8BgU8cNi09Q78uzv3AZ9QcIWlf9Pwf6v8tsThRCby9a53e
         ejzazOL1i0VIMlHJW2bBIwGC9P9QoK2UJaQL5DcmJU4BlUNpjaRzJucseTscKoL21+ju
         YYWL7ycdaB4uYAYFUB6rUv5LzrRDzC2TvNWMPx+VV3zKHPX+P9MbV+7bjMaPSUpYET2q
         Isyw==
In-Reply-To: <20210319054944.50048-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The swapaccounting= commandline option already does very little
today. To close a trivial containment failure case, the swap ownership
tracking part of the swap controller has recently become mandatory
(see commit 2d1c498072de ("mm: memcontrol: make swap tracking an
integral part of memory control") for details), which makes up the
majority of the work during swapout, swapin, and the swap slot map.

The only thing left under this flag is the page_counter operations and
the visibility of the swap control files in the first place, which are
rather meager savings. There also aren't many scenarios, if any, where
controlling the memory of a cgroup while allowing it unlimited access
to a global swap space is a workable resource isolation stragegy.

On the other hand, there have been several bugs and confusion around
the many possible swap controller states (cgroup1 vs cgroup2 behavior,
memory accounting without swap accounting, memcg runtime disabled).

This puts the maintenance overhead of retaining the toggle above its
practical benefits. Deprecate it.

Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 .../admin-guide/kernel-parameters.txt         |  5 --
 include/linux/memcontrol.h                    |  4 --
 mm/memcontrol.c                               | 48 ++++++-------------
 3 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 942bbef8f128..986d45dd8c37 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5322,11 +5322,6 @@
 			This parameter controls use of the Protected
 			Execution Facility on pSeries.
 
-	swapaccount=[0|1]
-			[KNL] Enable accounting of swap in memory resource
-			controller if no parameter or 1 is given or disable
-			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
-
 	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
 			Format: { <int> | force | noforce }
 			<int> -- Number of I/O TLB slabs
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4064c9dda534..ef9613538d36 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -874,10 +874,6 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
-#ifdef CONFIG_MEMCG_SWAP
-extern bool cgroup_memory_noswap;
-#endif
-
 void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49bdcf603af1..b036c4fb0fa7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -85,13 +85,6 @@ static bool cgroup_memory_nosocket;
 /* Kernel memory accounting disabled? */
 static bool cgroup_memory_nokmem;
 
-/* Whether the swap controller is active */
-#ifdef CONFIG_MEMCG_SWAP
-bool cgroup_memory_noswap __read_mostly;
-#else
-#define cgroup_memory_noswap		1
-#endif
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
@@ -99,7 +92,11 @@ static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
+	/* cgroup2 doesn't do mem+swap accounting */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return false;
+
+	return true;
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
@@ -7019,7 +7016,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (!cgroup_memory_noswap && memcg != swap_memcg) {
+	if (memcg != swap_memcg) {
 		if (!mem_cgroup_is_root(swap_memcg))
 			page_counter_charge(&swap_memcg->memsw, nr_entries);
 		page_counter_uncharge(&memcg->memsw, nr_entries);
@@ -7073,7 +7070,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 
 	memcg = mem_cgroup_id_get_online(memcg);
 
-	if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg) &&
+	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -7108,7 +7105,7 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
-		if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg)) {
+		if (!mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 				page_counter_uncharge(&memcg->swap, nr_pages);
 			else
@@ -7124,7 +7121,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return nr_swap_pages;
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
@@ -7141,7 +7138,7 @@ bool mem_cgroup_swap_full(struct page *page)
 
 	if (vm_swap_full())
 		return true;
-	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
 	memcg = page_memcg(page);
@@ -7161,11 +7158,10 @@ bool mem_cgroup_swap_full(struct page *page)
 
 static int __init setup_swap_account(char *s)
 {
-	if (!strcmp(s, "1"))
-		cgroup_memory_noswap = false;
-	else if (!strcmp(s, "0"))
-		cgroup_memory_noswap = true;
-	return 1;
+	pr_warn_once("The swapaccount= commandline option is deprecated. "
+		     "Please report your usecase to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org if you "
+		     "depend on this functionality.\n");
+	return 0;
 }
 __setup("swapaccount=", setup_swap_account);
 
@@ -7291,27 +7287,13 @@ static struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
-/*
- * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
- * instead of a core_initcall(), this could mean cgroup_memory_noswap still
- * remains set to false even when memcg is disabled via "cgroup_disable=memory"
- * boot parameter. This may result in premature OOPS inside
- * mem_cgroup_get_nr_swap_pages() function in corner cases.
- */
 static int __init mem_cgroup_swap_init(void)
 {
-	/* No memory control -> no swap control */
-	if (mem_cgroup_disabled())
-		cgroup_memory_noswap = true;
-
-	if (cgroup_memory_noswap)
-		return 0;
-
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
 
 	return 0;
 }
-core_initcall(mem_cgroup_swap_init);
+subsys_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_MEMCG_SWAP */
-- 
2.30.1


From: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] mm: vmscan: reclaim anon pages if there are swapcache pages
Date: Tue, 22 Aug 2023 10:49:01 +0800
Message-ID: <20230822024901.2412520-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

When spaces of swap devices are exhausted, only file pages can be reclaimed.
But there are still some swapcache pages in anon lru list. This can lead
to a premature out-of-memory.

This problem can be fixed by checking number of swapcache pages in
can_reclaim_anon_pages(). For memcg v2, there are swapcache stat that can
be used directly. For memcg v1, use total_swapcache_pages() instead, which
may not accurate but can solve the problem.

Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/swap.h |  6 ++++++
 mm/memcontrol.c      |  8 ++++++++
 mm/vmscan.c          | 12 ++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 456546443f1f..0318e918bfa4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -669,6 +669,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
 }
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
@@ -691,6 +692,11 @@ static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return get_nr_swap_pages();
 }
 
+static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
+{
+	return total_swapcache_pages();
+}
+
 static inline bool mem_cgroup_swap_full(struct folio *folio)
 {
 	return vm_swap_full();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..3e578f41023e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return nr_swap_pages;
 }
 
+long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled() || do_memsw_account())
+		return total_swapcache_pages();
+
+	return memcg_page_state(memcg, NR_SWAPCACHE);
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7c33c5b653ef..bcb6279cbae7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -609,13 +609,17 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 	if (memcg == NULL) {
 		/*
 		 * For non-memcg reclaim, is there
-		 * space in any swap device?
+		 * space in any swap device or swapcache pages?
 		 */
-		if (get_nr_swap_pages() > 0)
+		if (get_nr_swap_pages() + total_swapcache_pages() > 0)
 			return true;
 	} else {
-		/* Is the memcg below its swap limit? */
-		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
+		/*
+		 * Is the memcg below its swap limit or is there swapcache
+		 * pages can be freed?
+		 */
+		if (mem_cgroup_get_nr_swap_pages(memcg) +
+		    mem_cgroup_get_nr_swapcache_pages(memcg) > 0)
 			return true;
 	}
 
-- 
2.25.1


From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 2/7] mm: memcontrol: convert NR_ANON_THPS account to pages
Date: Fri, 11 Dec 2020 12:19:49 +0800
Message-ID: <20201211041954.79543-3-songmuchun@bytedance.com>
References: <20201211041954.79543-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cU/HrVcwfM3LPFm4rjOQAH8JdzbfJ+ZpL7D7Ks2Uco0=;
        b=tih4ZHbKA0YgssVEixNJ0hUNRlQ83ass+bYW1yuu3v27Qw+hZwKiLO7xMEW7V9iGfo
         CL+A5/3YoVRnB1m1CfbOvvdxL6uiv1v8CvG7gKw4Lqm6dLgN8Ih0dD9pkJVjxa2DsOGp
         HjsANWSDU0LDkKJLCdqXKHlEN7jTGU+zJDrDwyUVrV9i4kCXKTXRf2tAU81mxiMaCZ3J
         wJj9xeB0NYehtyC1FQ1pBreTX1nJiWNTjK4sEq6AQHFSwQuLlbadTYekoPpxVHudgs4W
         Ko1GxshKle2QfTsP0MSzCxmnG8MEgEHist32cC9QtFWhohA01FbOh+c+Aayw1n7tTkbJ
         9gWQ==
In-Reply-To: <20201211041954.79543-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The unit of NR_ANON_THPS is HPAGE_PMD_NR. Convert the NR_ANON_THPS
account to pages.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 drivers/base/node.c    | 15 +++++++++------
 fs/proc/meminfo.c      |  2 +-
 include/linux/mmzone.h |  9 +++++++++
 mm/huge_memory.c       |  3 ++-
 mm/memcontrol.c        | 20 ++++++--------------
 mm/page_alloc.c        |  2 +-
 mm/rmap.c              |  7 ++++---
 mm/vmstat.c            | 11 +++++++++--
 8 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 04f71c7bc3f8..6da0c3508bc9 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -461,8 +461,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, K(sunreclaimable)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			     ,
-			     nid, K(node_page_state(pgdat, NR_ANON_THPS) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS) *
 				    HPAGE_PMD_NR),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
@@ -519,10 +518,14 @@ static ssize_t node_read_vmstat(struct device *dev,
 				     sum_zone_numa_state(nid, i));
 
 #endif
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-		len += sysfs_emit_at(buf, len, "%s %lu\n",
-				     node_stat_name(i),
-				     node_page_state_pages(pgdat, i));
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		unsigned long pages = node_page_state_pages(pgdat, i);
+
+		if (vmstat_item_print_in_thp(i))
+			pages /= HPAGE_PMD_NR;
+		len += sysfs_emit_at(buf, len, "%s %lu\n", node_stat_name(i),
+				     pages);
+	}
 
 	return len;
 }
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index d6fc74619625..a635c8a84ddf 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -129,7 +129,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	show_val_kb(m, "AnonHugePages:  ",
-		    global_node_page_state(NR_ANON_THPS) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_ANON_THPS));
 	show_val_kb(m, "ShmemHugePages: ",
 		    global_node_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR);
 	show_val_kb(m, "ShmemPmdMapped: ",
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b593316bff3d..4ac95448421c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -210,6 +210,15 @@ enum node_stat_item {
 };
 
 /*
+ * Returns true if the item should prints in THPs. The /proc/vmstat currently
+ * prints number of anon, file and shmem THPs. But the item is charged in pages.
+ */
+static __always_inline bool vmstat_item_print_in_thp(enum node_stat_item item)
+{
+	return item == NR_ANON_THPS;
+}
+
+/*
  * Returns true if the value is measured in bytes (most vmstat values are
  * measured in pages). This defines the API part, the internal representation
  * might be different.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 10dd3cae5f53..66ec454120de 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2178,7 +2178,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		lock_page_memcg(page);
 		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
 			/* Last compound_mapcount is gone. */
-			__dec_lruvec_page_state(page, NR_ANON_THPS);
+			__mod_lruvec_page_state(page, NR_ANON_THPS,
+						-HPAGE_PMD_NR);
 			if (TestClearPageDoubleMap(page)) {
 				/* No need in mapcount reference anymore */
 				for (i = 0; i < HPAGE_PMD_NR; i++)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8818bf64d6fe..b18e25a5cdf3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1532,7 +1532,7 @@ static struct memory_stat memory_stats[] = {
 	 * on some architectures, the macro of HPAGE_PMD_SIZE is not
 	 * constant(e.g. powerpc).
 	 */
-	{ "anon_thp", 0, NR_ANON_THPS },
+	{ "anon_thp", PAGE_SIZE, NR_ANON_THPS },
 	{ "file_thp", 0, NR_FILE_THPS },
 	{ "shmem_thp", 0, NR_SHMEM_THPS },
 #endif
@@ -1565,8 +1565,7 @@ static int __init memory_stats_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_ANON_THPS ||
-		    memory_stats[i].idx == NR_FILE_THPS ||
+		if (memory_stats[i].idx == NR_FILE_THPS ||
 		    memory_stats[i].idx == NR_SHMEM_THPS)
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
 #endif
@@ -4088,10 +4087,6 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memcg1_stats[i] == NR_ANON_THPS)
-			nr *= HPAGE_PMD_NR;
-#endif
 		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
 	}
 
@@ -4122,10 +4117,6 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memcg1_stats[i] == NR_ANON_THPS)
-			nr *= HPAGE_PMD_NR;
-#endif
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
 						(u64)nr * PAGE_SIZE);
 	}
@@ -5653,10 +5644,11 @@ static int mem_cgroup_move_account(struct page *page,
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
 			if (PageTransHuge(page)) {
-				__dec_lruvec_state(from_vec, NR_ANON_THPS);
-				__inc_lruvec_state(to_vec, NR_ANON_THPS);
+				__mod_lruvec_state(from_vec, NR_ANON_THPS,
+						   -nr_pages);
+				__mod_lruvec_state(to_vec, NR_ANON_THPS,
+						   nr_pages);
 			}
-
 		}
 	} else {
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 469e28f95ce7..1700f52b7869 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5580,7 +5580,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			K(node_page_state(pgdat, NR_SHMEM_THPS) * HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
 					* HPAGE_PMD_NR),
-			K(node_page_state(pgdat, NR_ANON_THPS) * HPAGE_PMD_NR),
+			K(node_page_state(pgdat, NR_ANON_THPS)),
 #endif
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			node_page_state(pgdat, NR_KERNEL_STACK_KB),
diff --git a/mm/rmap.c b/mm/rmap.c
index 08c56aaf72eb..f59e92e26b61 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1144,7 +1144,8 @@ void do_page_add_anon_rmap(struct page *page,
 		 * disabled.
 		 */
 		if (compound)
-			__inc_lruvec_page_state(page, NR_ANON_THPS);
+			__mod_lruvec_page_state(page, NR_ANON_THPS,
+						HPAGE_PMD_NR);
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	}
 
@@ -1186,7 +1187,7 @@ void page_add_new_anon_rmap(struct page *page,
 		if (hpage_pincount_available(page))
 			atomic_set(compound_pincount_ptr(page), 0);
 
-		__inc_lruvec_page_state(page, NR_ANON_THPS);
+		__mod_lruvec_page_state(page, NR_ANON_THPS, HPAGE_PMD_NR);
 	} else {
 		/* Anon THP always mapped first with PMD */
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -1292,7 +1293,7 @@ static void page_remove_anon_compound_rmap(struct page *page)
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return;
 
-	__dec_lruvec_page_state(page, NR_ANON_THPS);
+	__mod_lruvec_page_state(page, NR_ANON_THPS, -HPAGE_PMD_NR);
 
 	if (TestClearPageDoubleMap(page)) {
 		/*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 663f49ed1fd6..37c9e7b21e1e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1624,8 +1624,12 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 	if (is_zone_first_populated(pgdat, zone)) {
 		seq_printf(m, "\n  per-node stats");
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+			unsigned long pages = node_page_state_pages(pgdat, i);
+
+			if (vmstat_item_print_in_thp(i))
+				pages /= HPAGE_PMD_NR;
 			seq_printf(m, "\n      %-12s %lu", node_stat_name(i),
-				   node_page_state_pages(pgdat, i));
+				   pages);
 		}
 	}
 	seq_printf(m,
@@ -1745,8 +1749,11 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
 	v += NR_VM_NUMA_STAT_ITEMS;
 #endif
 
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 		v[i] = global_node_page_state_pages(i);
+		if (vmstat_item_print_in_thp(i))
+			v[i] /= HPAGE_PMD_NR;
+	}
 	v += NR_VM_NODE_STAT_ITEMS;
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
-- 
2.11.0


From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v5] mm: memcontrol: Add the missing numa_stat interface for cgroup v2
Date: Wed, 16 Sep 2020 01:18:01 +0800
Message-ID: <20200915171801.39761-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ebq9sJqx9UJfmyOfsvRZlBUi0Qw5FSlq2i9Oj0M7RmI=;
        b=JFmmJqAVabMeTcUBUWN6RX+HbyA9sYDZ9qn8tZT6RcHuObbQlE6QO9G3cMBvIkWhJX
         AlEGQMF7askN6OXy3BA/YK4qC6WsPdBYvMdgE+FMqy8KmZT99k6DaiboSw/YVWkNfEIH
         0FBUz3PRQj+gW/3hexhkEskZO1crML8glUQObahiAwGIaUzoroy2EheK0Iip4b+3bsMH
         OXDsTYshIE86YKl8SM1erM6EedDtTH7KRimm+rq7bhOpUHoA0IF/tjSmw6zrtlOiss0W
         YhW2/M7telw1H8Zu+H91wgKSdkH5Az4C1Lu7ictO2MyHYSm8JorAuoOG0jViRUNNWgC3
         dRJQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

In the cgroup v1, we have a numa_stat interface. This is useful for
providing visibility into the numa locality information within an
memcg since the pages are allowed to be allocated from any physical
node. One of the use cases is evaluating application performance by
combining this information with the application's CPU allocation.
But the cgroup v2 does not. So this patch adds the missing information.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 changelog in v5:
 1. Fix small nits pointed out by Shakeel Butt

 changelog in v4:
 1. Fix some document problems pointed out by Randy Dunlap.
 2. Remove memory_numa_stat_format() suggested by Shakeel Butt.

 changelog in v3:
 1. Fix compiler error on powerpc architecture reported by kernel test robot.
 2. Fix a typo from "anno" to "anon".

 changelog in v2:
 1. Add memory.numa_stat interface in cgroup v2.

 Documentation/admin-guide/cgroup-v2.rst | 72 +++++++++++++++++++++
 mm/memcontrol.c                         | 86 +++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6be43781ec7f..48bb12fc7622 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1368,6 +1368,78 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+  memory.numa_stat
+	A read-only flat-keyed file which exists on non-root cgroups.
+
+	This breaks down the cgroup's memory footprint into different
+	types of memory, type-specific details, and other information
+	per node on the state of the memory management system.
+
+	This is useful for providing visibility into the NUMA locality
+	information within an memcg since the pages are allowed to be
+	allocated from any physical node. One of the use case is evaluating
+	application performance by combining this information with the
+	application's CPU allocation.
+
+	All memory amounts are in bytes.
+
+	The output format of memory.numa_stat is::
+
+	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
+
+	The entries are ordered to be human readable, and new entries
+	can show up in the middle. Don't rely on items remaining in a
+	fixed position; use the keys to look up specific values!
+
+	  anon
+		Amount of memory per node used in anonymous mappings such
+		as brk(), sbrk(), and mmap(MAP_ANONYMOUS).
+
+	  file
+		Amount of memory per node used to cache filesystem data,
+		including tmpfs and shared memory.
+
+	  kernel_stack
+		Amount of memory per node allocated to kernel stacks.
+
+	  shmem
+		Amount of cached filesystem data per node that is swap-backed,
+		such as tmpfs, shm segments, shared anonymous mmap()s.
+
+	  file_mapped
+		Amount of cached filesystem data per node mapped with mmap().
+
+	  file_dirty
+		Amount of cached filesystem data per node that was modified but
+		not yet written back to disk.
+
+	  file_writeback
+		Amount of cached filesystem data per node that was modified and
+		is currently being written back to disk.
+
+	  anon_thp
+		Amount of memory per node used in anonymous mappings backed by
+		transparent hugepages.
+
+	  inactive_anon, active_anon, inactive_file, active_file, unevictable
+		Amount of memory, swap-backed and filesystem-backed,
+		per node on the internal memory management lists used
+		by the page reclaim algorithm.
+
+		As these represent internal list state (e.g. shmem pages are on
+		anon memory management lists), inactive_foo + active_foo may not
+		be equal to the value for the foo counter, since the foo counter
+		is type-based, not list-based.
+
+	  slab_reclaimable
+		Amount of memory per node used for storing in-kernel data
+		structures which might be reclaimed, such as dentries and
+		inodes.
+
+	  slab_unreclaimable
+		Amount of memory per node used for storing in-kernel data
+		structures which cannot be reclaimed on memory pressure.
+
   memory.swap.current
 	A read-only single value file which exists on non-root
 	cgroups.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75cd1a1e66c8..ff919ef3b57b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6425,6 +6425,86 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
+struct numa_stat {
+	const char *name;
+	unsigned int ratio;
+	enum node_stat_item idx;
+};
+
+static struct numa_stat numa_stats[] = {
+	{ "anon", PAGE_SIZE, NR_ANON_MAPPED },
+	{ "file", PAGE_SIZE, NR_FILE_PAGES },
+	{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
+	{ "shmem", PAGE_SIZE, NR_SHMEM },
+	{ "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
+	{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
+	{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * The ratio will be initialized in numa_stats_init(). Because
+	 * on some architectures, the macro of HPAGE_PMD_SIZE is not
+	 * constant(e.g. powerpc).
+	 */
+	{ "anon_thp", 0, NR_ANON_THPS },
+#endif
+	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
+	{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
+	{ "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
+	{ "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
+	{ "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
+	{ "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
+	{ "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
+};
+
+static int __init numa_stats_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (numa_stats[i].idx == NR_ANON_THPS)
+			numa_stats[i].ratio = HPAGE_PMD_SIZE;
+#endif
+	}
+
+	return 0;
+}
+pure_initcall(numa_stats_init);
+
+static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
+					   unsigned int nid,
+					   enum node_stat_item idx)
+{
+	VM_BUG_ON(nid >= nr_node_ids);
+	return lruvec_page_state(mem_cgroup_lruvec(memcg, NODE_DATA(nid)), idx);
+}
+
+static int memory_numa_stat_show(struct seq_file *m, void *v)
+{
+	int i;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
+		int nid;
+
+		seq_printf(m, "%s", numa_stats[i].name);
+		for_each_node_state(nid, N_MEMORY) {
+			u64 size;
+
+			size = memcg_node_page_state(memcg, nid,
+						     numa_stats[i].idx);
+			VM_WARN_ON_ONCE(!numa_stats[i].ratio);
+			size *= numa_stats[i].ratio;
+			seq_printf(m, " N%d=%llu", nid, size);
+		}
+		seq_putc(m, '\n');
+	}
+
+	return 0;
+}
+#endif
+
 static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
@@ -6502,6 +6582,12 @@ static struct cftype memory_files[] = {
 		.name = "stat",
 		.seq_show = memory_stat_show,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.name = "numa_stat",
+		.seq_show = memory_numa_stat_show,
+	},
+#endif
 	{
 		.name = "oom.group",
 		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
-- 
2.20.1


From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3] mm/memcg: support control THP behaviour in cgroup
Date: Sat,  7 May 2022 01:12:07 +0000
Message-ID: <20220507011206.637461-1-yang.yang29@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VV+aBZGjjjaPqFrLHpEfDbj0fKIcEx/MrRhGNEv3uHo=;
        b=Um9fCxn5HyuTYbxLzc4tVNAkhE/ZgSSyRcG/sjvc86AToXfN5q74NIEoOLmA1WrGh7
         3uoG1x48BokXNambAZSbgDbaIJ9FX/bJU/HrH5aF2kgsI82mL0A6zhwcDoquhpzSxmVg
         Lw9fHRwqUdWFnoz5bkZXWdaKJAulqfAF2PJR7uv/rUsfsv461eNb08ws2beHkn9/jif5
         7Zpu7OEF1JIG0CyNtO0ug5bHyG/zchIBs1swUfGDsq9v4Gdl2F3PhCiG/DKedG4qlp7O
         jg1x1/vGnjZvseDwLwcd1yquspX36f1XRHYfzHk1y11wznzV16XmA77VKgYrpxeUkycY
         AJxQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Using THP may promote the performance of memory, but increase memory
footprint. Applications may use madvise to decrease footprint, but
not all applications support using madvise, and it takes much costs
to re-code all the applications. And we notice container becomes more
and more popular to manage a set of tasks.

So add support for cgroup to control THP behaviour will provide much
convenience, administrator may only enable THP for important containers,
and disable it for other containers. Then we can enjoy the high performance
of THP while minimize memory footprint without re-coding any application.

Cgroupv1 is used for many distributions, so and this it.

Signed-off-by: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
v3:
- fix compile error when CONFIG_SHMEM is not set
v2:
- fix compile error when CONFIG_ARCH_ENABLE_THP_MIGRATION is not set
- let thp_flag controls by CONFIG_TRANSPARENT_HUGEPAGE
---
 include/linux/huge_mm.h    | 33 +--------------
 include/linux/khugepaged.h | 19 +++------
 include/linux/memcontrol.h | 57 +++++++++++++++++++++++++
 mm/huge_memory.c           | 33 +++++++++++++++
 mm/khugepaged.c            | 35 +++++++++++++++-
 mm/memcontrol.c            | 86 +++++++++++++++++++++++++++++++++++++-
 6 files changed, 216 insertions(+), 47 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index fbf36bb1be22..fa2cb3d06ecb 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -141,38 +141,6 @@ static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
 	return true;
 }
 
-/*
- * to be used on vmas which are known to support THP.
- * Use transparent_hugepage_active otherwise
- */
-static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
-{
-
-	/*
-	 * If the hardware/firmware marked hugepage support disabled.
-	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
-		return false;
-
-	if (!transhuge_vma_enabled(vma, vma->vm_flags))
-		return false;
-
-	if (vma_is_temporary_stack(vma))
-		return false;
-
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
-		return true;
-
-	if (vma_is_dax(vma))
-		return true;
-
-	if (transparent_hugepage_flags &
-				(1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
-		return !!(vma->vm_flags & VM_HUGEPAGE);
-
-	return false;
-}
-
 bool transparent_hugepage_active(struct vm_area_struct *vma);
 
 #define transparent_hugepage_use_zero_page()				\
@@ -302,6 +270,7 @@ static inline struct list_head *page_deferred_list(struct page *page)
 	 */
 	return &page[2].deferred_list;
 }
+inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index 2fcc01891b47..b77b065ebf16 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -26,16 +26,9 @@ static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
 }
 #endif
 
-#define khugepaged_enabled()					       \
-	(transparent_hugepage_flags &				       \
-	 ((1<<TRANSPARENT_HUGEPAGE_FLAG) |		       \
-	  (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)))
-#define khugepaged_always()				\
-	(transparent_hugepage_flags &			\
-	 (1<<TRANSPARENT_HUGEPAGE_FLAG))
-#define khugepaged_req_madv()					\
-	(transparent_hugepage_flags &				\
-	 (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
+extern inline int khugepaged_enabled(void);
+extern inline int khugepaged_always(struct vm_area_struct *vma);
+extern inline int khugepaged_req_madv(struct vm_area_struct *vma);
 #define khugepaged_defrag()					\
 	(transparent_hugepage_flags &				\
 	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
@@ -57,9 +50,9 @@ static inline int khugepaged_enter(struct vm_area_struct *vma,
 				   unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
-		if ((khugepaged_always() ||
-		     (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) ||
-		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
+		if ((khugepaged_always(vma) ||
+		    (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) ||
+		    (khugepaged_req_madv(vma) && (vm_flags & VM_HUGEPAGE))) &&
 		    !(vm_flags & VM_NOHUGEPAGE) &&
 		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 			if (__khugepaged_enter(vma->vm_mm))
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8ea4b541c31e..018f6d776037 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -28,6 +28,13 @@ struct page;
 struct mm_struct;
 struct kmem_cache;
 
+/*
+ * Increase when sub cgroup enable transparent hugepage, decrease when
+ * sub cgroup disable transparent hugepage. Help decide whether to run
+ * khugepaged.
+ */
+extern atomic_t sub_thp_count;
+
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
@@ -342,6 +349,7 @@ struct mem_cgroup {
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct deferred_split deferred_split_queue;
+	unsigned long thp_flag;
 #endif
 
 	struct mem_cgroup_per_node *nodeinfo[];
@@ -1127,6 +1135,34 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline unsigned long mem_cgroup_thp_flag(struct mem_cgroup *memcg)
+{
+	if (unlikely(memcg == NULL) || mem_cgroup_disabled() ||
+	    mem_cgroup_is_root(memcg))
+		return transparent_hugepage_flags;
+
+	return memcg->thp_flag;
+}
+
+static inline int memcg_sub_thp_enabled(void)
+{
+	return atomic_read(&sub_thp_count) != 0;
+}
+
+static inline void memcg_sub_thp_enable(struct mem_cgroup *memcg)
+{
+	if (!mem_cgroup_is_root(memcg))
+		atomic_inc(&sub_thp_count);
+}
+
+static inline void memcg_sub_thp_disable(struct mem_cgroup *memcg)
+{
+	if (!mem_cgroup_is_root(memcg))
+		atomic_dec(&sub_thp_count);
+}
+#endif
+
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
@@ -1524,6 +1560,27 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 {
 	return 0;
 }
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline unsigned long mem_cgroup_thp_flag(struct mem_cgroup *memcg)
+{
+	return transparent_hugepage_flags;
+}
+
+static inline int memcg_sub_thp_enabled(void)
+{
+	return 0;
+}
+
+static inline void memcg_sub_thp_enable(struct mem_cgroup *memcg)
+{
+}
+
+static inline void memcg_sub_thp_disable(struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #endif /* CONFIG_MEMCG */
 
 static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6bf0ec9ac4e4..47104567b0f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3174,3 +3174,36 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
+
+/*
+ * to be used on vmas which are known to support THP.
+ * Use transparent_hugepage_active otherwise
+ */
+inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+
+	/*
+	 * If the hardware/firmware marked hugepage support disabled.
+	 */
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
+		return false;
+
+	if (!transhuge_vma_enabled(vma, vma->vm_flags))
+		return false;
+
+	if (vma_is_temporary_stack(vma))
+		return false;
+
+	if (mem_cgroup_thp_flag(memcg) & (1 << TRANSPARENT_HUGEPAGE_FLAG))
+		return true;
+
+	if (vma_is_dax(vma))
+		return true;
+
+	if (mem_cgroup_thp_flag(memcg) &
+				(1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
+		return !!(vma->vm_flags & VM_HUGEPAGE);
+
+	return false;
+}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index eb444fd45568..f6ef2252a844 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -404,6 +404,39 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
+inline int khugepaged_enabled(void)
+{
+	if ((transparent_hugepage_flags &
+	    ((1<<TRANSPARENT_HUGEPAGE_FLAG) |
+	    (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))) ||
+	    memcg_sub_thp_enabled())
+		return 1;
+	else
+		return 0;
+}
+
+inline int khugepaged_req_madv(struct vm_area_struct *vma)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+
+	if (mem_cgroup_thp_flag(memcg) &
+	    (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
+		return 1;
+	else
+		return 0;
+}
+
+inline int khugepaged_always(struct vm_area_struct *vma)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+
+	if (mem_cgroup_thp_flag(memcg) &
+	    (1<<TRANSPARENT_HUGEPAGE_FLAG))
+		return 1;
+	else
+		return 0;
+}
+
 static inline struct mm_slot *alloc_mm_slot(void)
 {
 	if (!mm_slot_cache)	/* initialization failed */
@@ -454,7 +487,7 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
 		return shmem_huge_enabled(vma);
 
 	/* THP settings require madvise. */
-	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always(vma))
 		return false;
 
 	/* Only regular file is valid */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e1b5823ac060..dfbc84313745 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/khugepaged.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -99,6 +100,8 @@ static bool cgroup_memory_noswap __ro_after_init;
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
 
+atomic_t sub_thp_count __read_mostly = ATOMIC_INIT(0);
+
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
@@ -4823,6 +4826,71 @@ static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 }
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int mem_cgroup_thp_flag_show(struct seq_file *sf, void *v)
+{
+	const char *output;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
+	unsigned long flag = mem_cgroup_thp_flag(memcg);
+
+	if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, &flag))
+		output = "[always] madvise never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &flag))
+		output = "always [madvise] never";
+	else
+		output = "always madvise [never]";
+
+	seq_printf(sf, "%s\n", output);
+	return 0;
+}
+
+static ssize_t mem_cgroup_thp_flag_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	ssize_t ret = nbytes;
+	unsigned long *flag;
+
+	if (!mem_cgroup_is_root(memcg))
+		flag = &memcg->thp_flag;
+	else
+		flag = &transparent_hugepage_flags;
+
+	if (sysfs_streq(buf, "always")) {
+		if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG, flag)) {
+			set_bit(TRANSPARENT_HUGEPAGE_FLAG, flag);
+			/* change disable to enable */
+			if (!test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, flag))
+				memcg_sub_thp_enable(memcg);
+		}
+	} else if (sysfs_streq(buf, "madvise")) {
+		if (!test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, flag)) {
+			set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, flag);
+			/* change disable to enable */
+			if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG, flag))
+				memcg_sub_thp_enable(memcg);
+		}
+	} else if (sysfs_streq(buf, "never")) {
+		/* change enable to disable */
+		if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, flag) ||
+		    test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, flag)) {
+			clear_bit(TRANSPARENT_HUGEPAGE_FLAG, flag);
+			clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, flag);
+			memcg_sub_thp_disable(memcg);
+		}
+	} else
+		ret = -EINVAL;
+
+	if (ret > 0) {
+		int err = start_stop_khugepaged();
+
+		if (err)
+			ret = err;
+	}
+	return ret;
+}
+#endif
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -4948,6 +5016,13 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	{
+		.name = "transparent_hugepage.enabled",
+		.seq_show = mem_cgroup_thp_flag_show,
+		.write = mem_cgroup_thp_flag_write,
+	},
+#endif
 	{ },	/* terminate */
 };
 
@@ -5145,6 +5220,13 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		memcg->thp_flag = mem_cgroup_thp_flag(parent);
+		if (memcg->thp_flag &
+		    ((1<<TRANSPARENT_HUGEPAGE_FLAG) |
+		    (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)))
+			memcg_sub_thp_enable(memcg);
+#endif
 		memcg->oom_kill_disable = parent->oom_kill_disable;
 
 		page_counter_init(&memcg->memory, &parent->memory);
@@ -5220,7 +5302,9 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	memcg_offline_kmem(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
-
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	memcg_sub_thp_disable(memcg);
+#endif
 	drain_all_stock(memcg);
 
 	mem_cgroup_id_put(memcg);
-- 
2.25.1


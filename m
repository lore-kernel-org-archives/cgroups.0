From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Tue, 14 Nov 2017 17:24:29 +0000
Message-ID: <20171114172429.8916-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=I3GLreKo9y9fIboyX/32ScjNe1pfuH9NJN8d52uuoIQ=;
 b=MZv3woHVkhIRXl+IB2ZS4SeIE4lQ64WnD8mcvCUMGT2rLZULbeGv5Ll9E5m8k4Bt6bTG
 IAfZyXMeKY7UejdjFf+PyFjdhbRZjkhRsPClK3A0Tf6L/2W+DDdVylaMF/Lc2ISa6+K/
 Je1g1ALHFu8GovbETlGJ7PfvMv/InRs+/nQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=I3GLreKo9y9fIboyX/32ScjNe1pfuH9NJN8d52uuoIQ=;
 b=k2eyolzdCKy3vDaVDM0K1yoFCy0E9dCjbG4XAjEHXv1wmvTOYnp5KnIovoT4/kugzu0pV8x0Z+TmSSAtqxUoiYNOYy38CfFK+IX3gfYAeL5GuFLdMJwSIfQdAm4fXAQPtCWiPVX7D9d1FmKUdfyf9u2Oor9szk6RUPk/6NxbWno=
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

This patch implements basic accounting of memory consumption
by hugetlbfs pages for cgroup v2 memory controller.

Cgroup v2 memory controller lacks any visibility into the
hugetlbfs memory consumption. Cgroup v1 implemented a separate
hugetlbfs controller, which provided such stats, and also
provided some control abilities. Although porting of the
hugetlbfs controller to cgroup v2 is arguable a good idea and
is outside of scope of this patch, it's very useful to have
basic stats provided by memory.stat.

As hugetlbfs memory can easily represent a big portion of total
memory, it's important to understand who (which memcg/container)
is using it.

The number is represented in memory.stat as "hugetlb" in bytes and
is printed unconditionally. Accounting code doesn't depend on
cgroup v1 hugetlb controller.

Example:
  $ cat /sys/fs/cgroup/user.slice/user-0.slice/session-1.scope/memory.stat
  anon 1634304
  file 1163264
  kernel_stack 16384
  slab 737280
  sock 0
  shmem 0
  file_mapped 32768
  file_dirty 4096
  file_writeback 0
  inactive_anon 0
  active_anon 1634304
  inactive_file 65536
  active_file 1097728
  unevictable 0
  slab_reclaimable 282624
  slab_unreclaimable 454656
  hugetlb 1073741824
  pgfault 4580
  pgmajfault 13
  ...

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/memcontrol.h | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c               |  5 +++++
 mm/memcontrol.c            |  3 +++
 3 files changed, 56 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69966c461d1c..e0dfb64d2918 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -45,6 +45,7 @@ enum memcg_stat_item {
 	MEMCG_SOCK,
 	/* XXX: why are these zone and not node counters? */
 	MEMCG_KERNEL_STACK_KB,
+	MEMCG_HUGETLB,
 	MEMCG_NR_STAT,
 };
 
@@ -664,6 +665,39 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
+#ifdef CONFIG_HUGETLBFS
+static inline void mem_cgroup_add_hugetlb_page(struct page *page,
+					       unsigned int count)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	rcu_read_lock();
+	page->mem_cgroup = mem_cgroup_from_task(current);
+	css_get(&page->mem_cgroup->css);
+	rcu_read_unlock();
+
+	mod_memcg_page_state(page, MEMCG_HUGETLB, count);
+}
+
+static inline void mem_cgroup_remove_hugetlb_page(struct page *page,
+						  unsigned int count)
+{
+	if (mem_cgroup_disabled() || !page->mem_cgroup)
+		return;
+
+	mod_memcg_page_state(page, MEMCG_HUGETLB, -count);
+
+	css_put(&page->mem_cgroup->css);
+	page->mem_cgroup = NULL;
+}
+
+static inline void mem_cgroup_reset_hugetlb_page(struct page *page)
+{
+	page->mem_cgroup = NULL;
+}
+#endif
+
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
@@ -936,6 +970,20 @@ static inline
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+
+static inline void mem_cgroup_add_hugetlb_page(struct page *page,
+					       unsigned int count)
+{
+}
+
+static inline void mem_cgroup_remove_hugetlb_page(struct page *page,
+						  unsigned int count)
+{
+}
+
+static inline void mem_cgroup_reset_hugetlb_page(struct page *page)
+{
+}
 #endif /* CONFIG_MEMCG */
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b3bbd2980bb..d1a2a9fa549a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1279,6 +1279,8 @@ void free_huge_page(struct page *page)
 	clear_page_huge_active(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
+	mem_cgroup_remove_hugetlb_page(page, pages_per_huge_page(h));
+
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
@@ -1301,6 +1303,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, NULL);
+	mem_cgroup_reset_hugetlb_page(page);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
@@ -1584,6 +1587,7 @@ static struct page *__alloc_buddy_huge_page(struct hstate *h, gfp_t gfp_mask,
 		r_nid = page_to_nid(page);
 		set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 		set_hugetlb_cgroup(page, NULL);
+		mem_cgroup_reset_hugetlb_page(page);
 		/*
 		 * We incremented the global counters already
 		 */
@@ -2041,6 +2045,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		/* Fall through */
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
+	mem_cgroup_add_hugetlb_page(page, pages_per_huge_page(h));
 	spin_unlock(&hugetlb_lock);
 
 	set_page_private(page, (unsigned long)spool);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50e6906314f8..f2323a9405a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5338,6 +5338,9 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "slab_unreclaimable %llu\n",
 		   (u64)stat[NR_SLAB_UNRECLAIMABLE] * PAGE_SIZE);
 
+	seq_printf(m, "hugetlb %llu\n",
+		   (u64)stat[MEMCG_HUGETLB] * PAGE_SIZE);
+
 	/* Accumulated memory events */
 
 	seq_printf(m, "pgfault %lu\n", events[PGFAULT]);
-- 
2.13.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

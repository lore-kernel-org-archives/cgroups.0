From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
Date: Wed, 13 Jun 2012 15:57:30 +0530
Message-ID: <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339583254-895-1-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

This patchset add the charge and uncharge routines for hugetlb cgroup.
We do cgroup charging in page alloc and uncharge in compound page
destructor. Assigning page's hugetlb cgroup is protected by hugetlb_lock.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 include/linux/hugetlb_cgroup.h |   38 +++++++++++++++++++
 mm/hugetlb.c                   |   16 +++++++-
 mm/hugetlb_cgroup.c            |   80 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index be1a9f8..e05871c 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -53,6 +53,16 @@ static inline bool hugetlb_cgroup_disabled(void)
 	return false;
 }
 
+extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+					struct hugetlb_cgroup **ptr);
+extern void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+					 struct hugetlb_cgroup *h_cg,
+					 struct page *page);
+extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+					 struct page *page);
+extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+					   struct hugetlb_cgroup *h_cg);
+
 #else
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 {
@@ -70,5 +80,33 @@ static inline bool hugetlb_cgroup_disabled(void)
 	return true;
 }
 
+static inline int
+hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+			     struct hugetlb_cgroup **ptr)
+{
+	return 0;
+}
+
+static inline void
+hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+			     struct hugetlb_cgroup *h_cg,
+			     struct page *page)
+{
+	return;
+}
+
+static inline void
+hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages, struct page *page)
+{
+	return;
+}
+
+static inline void
+hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+			       struct hugetlb_cgroup *h_cg)
+{
+	return;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6a449c5..59720b1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -627,6 +627,8 @@ static void free_huge_page(struct page *page)
 	BUG_ON(page_mapcount(page));
 
 	spin_lock(&hugetlb_lock);
+	hugetlb_cgroup_uncharge_page(hstate_index(h),
+				     pages_per_huge_page(h), page);
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		/* remove the page from active list */
 		list_del(&page->lru);
@@ -1115,7 +1117,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	long chg;
+	int ret, idx;
+	struct hugetlb_cgroup *h_cg;
 
+	idx = hstate_index(h);
 	/*
 	 * Processes that did not create the mapping will have no
 	 * reserves and will not have accounted against subpool
@@ -1131,6 +1136,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		if (hugepage_subpool_get_pages(spool, chg))
 			return ERR_PTR(-ENOSPC);
 
+	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
+	if (ret) {
+		hugepage_subpool_put_pages(spool, chg);
+		return ERR_PTR(-ENOSPC);
+	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
 	spin_unlock(&hugetlb_lock);
@@ -1138,6 +1148,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
+			hugetlb_cgroup_uncharge_cgroup(idx,
+						       pages_per_huge_page(h),
+						       h_cg);
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
@@ -1146,7 +1159,8 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-
+	/* update page cgroup details */
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	return page;
 }
 
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 5a4e71c..0f2f6ac 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -113,6 +113,86 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 	   return -EBUSY;
 }
 
+int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+				 struct hugetlb_cgroup **ptr)
+{
+	int ret = 0;
+	struct res_counter *fail_res;
+	struct hugetlb_cgroup *h_cg = NULL;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled())
+		goto done;
+	/*
+	 * We don't charge any cgroup if the compound page have less
+	 * than 3 pages.
+	 */
+	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
+		goto done;
+again:
+	rcu_read_lock();
+	h_cg = hugetlb_cgroup_from_task(current);
+	if (!h_cg)
+		h_cg = root_h_cgroup;
+
+	if (!css_tryget(&h_cg->css)) {
+		rcu_read_unlock();
+		goto again;
+	}
+	rcu_read_unlock();
+
+	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
+	css_put(&h_cg->css);
+done:
+	*ptr = h_cg;
+	return ret;
+}
+
+void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+				  struct hugetlb_cgroup *h_cg,
+				  struct page *page)
+{
+	if (hugetlb_cgroup_disabled() || !h_cg)
+		return;
+
+	spin_lock(&hugetlb_lock);
+	set_hugetlb_cgroup(page, h_cg);
+	spin_unlock(&hugetlb_lock);
+	return;
+}
+
+/*
+ * Should be called with hugetlb_lock held
+ */
+void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+				  struct page *page)
+{
+	struct hugetlb_cgroup *h_cg;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled())
+		return;
+	VM_BUG_ON(!spin_is_locked(&hugetlb_lock));
+	h_cg = hugetlb_cgroup_from_page(page);
+	if (unlikely(!h_cg))
+		return;
+	set_hugetlb_cgroup(page, NULL);
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
+void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+				    struct hugetlb_cgroup *h_cg)
+{
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled() || !h_cg)
+		return;
+
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
-- 
1.7.10

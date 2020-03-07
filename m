From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] mm: Use fallthrough;
Date: Fri, 06 Mar 2020 23:58:33 -0800
Message-ID: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert the various /* fallthrough */ comments to the
pseudo-keyword fallthrough;

Done via script:
https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org/

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---

Might as well start with fallthrough conversions somewhere...

 mm/gup.c            | 2 +-
 mm/hugetlb_cgroup.c | 6 +++---
 mm/ksm.c            | 3 +--
 mm/list_lru.c       | 2 +-
 mm/memcontrol.c     | 2 +-
 mm/mempolicy.c      | 3 ---
 mm/mmap.c           | 5 ++---
 mm/shmem.c          | 2 +-
 mm/zsmalloc.c       | 2 +-
 9 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index f58929..4bfd753 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1072,7 +1072,7 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				goto retry;
 			case -EBUSY:
 				ret = 0;
-				/* FALLTHRU */
+				fallthrough;
 			case -EFAULT:
 			case -ENOMEM:
 			case -EHWPOISON:
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 790f63..7994eb8 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -468,14 +468,14 @@ static int hugetlb_cgroup_read_u64_max(struct seq_file *seq, void *v)
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_RSVD_USAGE:
 		counter = &h_cg->rsvd_hugepage[idx];
-		/* Fall through. */
+		fallthrough;
 	case RES_USAGE:
 		val = (u64)page_counter_read(counter);
 		seq_printf(seq, "%llu\n", val * PAGE_SIZE);
 		break;
 	case RES_RSVD_LIMIT:
 		counter = &h_cg->rsvd_hugepage[idx];
-		/* Fall through. */
+		fallthrough;
 	case RES_LIMIT:
 		val = (u64)counter->max;
 		if (val == limit)
@@ -515,7 +515,7 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_RSVD_LIMIT:
 		rsvd = true;
-		/* Fall through. */
+		fallthrough;
 	case RES_LIMIT:
 		mutex_lock(&hugetlb_limit_mutex);
 		ret = page_counter_set_max(
diff --git a/mm/ksm.c b/mm/ksm.c
index 363ec8..a558da9 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2813,8 +2813,7 @@ static int ksm_memory_callback(struct notifier_block *self,
 		 */
 		ksm_check_stable_tree(mn->start_pfn,
 				      mn->start_pfn + mn->nr_pages);
-		/* fallthrough */
-
+		fallthrough;
 	case MEM_CANCEL_OFFLINE:
 		mutex_lock(&ksm_thread_mutex);
 		ksm_run &= ~KSM_RUN_OFFLINE;
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 9e4a28..87b540f 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -223,7 +223,7 @@ __list_lru_walk_one(struct list_lru_node *nlru, int memcg_idx,
 		switch (ret) {
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
-			/* fall through */
+			fallthrough;
 		case LRU_REMOVED:
 			isolated++;
 			nlru->nr_items--;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e1260..dfe191 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5756,7 +5756,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 		switch (get_mctgt_type(vma, addr, ptent, &target)) {
 		case MC_TARGET_DEVICE:
 			device = true;
-			/* fall through */
+			fallthrough;
 		case MC_TARGET_PAGE:
 			page = target.page;
 			/*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6d30379..45eb0a5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -907,7 +907,6 @@ static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
 
 	switch (p->mode) {
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		*nodes = p->v.nodes;
 		break;
@@ -2092,7 +2091,6 @@ bool init_nodemask_of_mempolicy(nodemask_t *mask)
 		break;
 
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		*mask =  mempolicy->v.nodes;
 		break;
@@ -2359,7 +2357,6 @@ bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 
 	switch (a->mode) {
 	case MPOL_BIND:
-		/* Fall through */
 	case MPOL_INTERLEAVE:
 		return !!nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
diff --git a/mm/mmap.c b/mm/mmap.c
index f8ea04..60dc38 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1457,7 +1457,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			 * with MAP_SHARED to preserve backward compatibility.
 			 */
 			flags &= LEGACY_MAP_MASK;
-			/* fall through */
+			fallthrough;
 		case MAP_SHARED_VALIDATE:
 			if (flags & ~flags_mask)
 				return -EOPNOTSUPP;
@@ -1480,8 +1480,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
-
-			/* fall through */
+			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
 				return -EACCES;
diff --git a/mm/shmem.c b/mm/shmem.c
index d01d5b..1e9b377 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3992,7 +3992,7 @@ bool shmem_huge_enabled(struct vm_area_struct *vma)
 			if (i_size >= HPAGE_PMD_SIZE &&
 					i_size >> PAGE_SHIFT >= off)
 				return true;
-			/* fall through */
+			fallthrough;
 		case SHMEM_HUGE_ADVISE:
 			/* TODO: implement fadvise() hints */
 			return (vma->vm_flags & VM_HUGEPAGE);
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2aa2d5..2f836a2b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -424,7 +424,7 @@ static void *zs_zpool_map(void *pool, unsigned long handle,
 	case ZPOOL_MM_WO:
 		zs_mm = ZS_MM_WO;
 		break;
-	case ZPOOL_MM_RW: /* fall through */
+	case ZPOOL_MM_RW:
 	default:
 		zs_mm = ZS_MM_RW;
 		break;



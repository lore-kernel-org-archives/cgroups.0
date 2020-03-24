From: Hui Zhu <teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm, memcg: Add memory.transparent_hugepage_disabled
Date: Tue, 24 Mar 2020 18:31:56 +0800
Message-ID: <1585045916-27339-1-git-send-email-teawater@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, thellstrom-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Hui Zhu <teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hui Zhu <teawaterz-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

/sys/kernel/mm/transparent_hugepage/enabled is the only interface to
control if the application can use THP in system level.
Sometime, we would not want an application use THP even if
transparent_hugepage/enabled is set to "always" or "madvise" because
thp may need more cpu and memory resources in some cases.

This commit add a new interface memory.transparent_hugepage_disabled
in memcg.
When it set to 1, the application inside the cgroup cannot use THP
except dax.

Signed-off-by: Hui Zhu <teawaterz-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 include/linux/huge_mm.h    | 18 ++++++++++++++++--
 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 42 ++++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c                 |  4 ++++
 4 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 5aca3d1..fd81479 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -91,6 +91,16 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 extern unsigned long transparent_hugepage_flags;
 
+#ifdef CONFIG_MEMCG
+extern bool memcg_transparent_hugepage_disabled(struct vm_area_struct *vma);
+#else
+static inline bool
+memcg_transparent_hugepage_disabled(struct vm_area_struct *vma)
+{
+	return false;
+}
+#endif
+
 /*
  * to be used on vmas which are known to support THP.
  * Use transparent_hugepage_enabled otherwise
@@ -106,8 +116,6 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
-		return true;
 	/*
 	 * For dax vmas, try to always use hugepage mappings. If the kernel does
 	 * not support hugepages, fsdax mappings will fallback to PAGE_SIZE
@@ -117,6 +125,12 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 	if (vma_is_dax(vma))
 		return true;
 
+	if (memcg_transparent_hugepage_disabled(vma))
+		return false;
+
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
+		return true;
+
 	if (transparent_hugepage_flags &
 				(1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
 		return !!(vma->vm_flags & VM_HUGEPAGE);
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a7a0a1a5..abc3142 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -320,6 +320,8 @@ struct mem_cgroup {
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct deferred_split deferred_split_queue;
+
+	bool transparent_hugepage_disabled;
 #endif
 
 	struct mem_cgroup_per_node *nodeinfo[0];
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7a4bd8b..b6d91b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5011,6 +5011,14 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		memcg->transparent_hugepage_disabled
+			= parent->transparent_hugepage_disabled;
+#endif
+	} else {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		memcg->transparent_hugepage_disabled = false;
+#endif
 	}
 	if (parent && parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
@@ -6126,6 +6134,24 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static u64 transparent_hugepage_disabled_read(struct cgroup_subsys_state *css,
+					      struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return memcg->transparent_hugepage_disabled;
+}
+
+static int transparent_hugepage_disabled_write(struct cgroup_subsys_state *css,
+					       struct cftype *cft, u64 val)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	memcg->transparent_hugepage_disabled = !!val;
+
+	return 0;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6179,6 +6205,12 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+	{
+		.name = "transparent_hugepage_disabled",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = transparent_hugepage_disabled_read,
+		.write_u64 = transparent_hugepage_disabled_write,
+	},
 	{ }	/* terminate */
 };
 
@@ -6787,6 +6819,16 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	refill_stock(memcg, nr_pages);
 }
 
+bool memcg_transparent_hugepage_disabled(struct vm_area_struct *vma)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+
+	if (memcg && memcg->transparent_hugepage_disabled)
+		return true;
+
+	return false;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;
diff --git a/mm/shmem.c b/mm/shmem.c
index aad3ba7..253b63b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1810,6 +1810,10 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 		goto alloc_nohuge;
 	if (shmem_huge == SHMEM_HUGE_DENY || sgp_huge == SGP_NOHUGE)
 		goto alloc_nohuge;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (memcg_transparent_hugepage_disabled(vma))
+		goto alloc_nohuge;
+#endif
 	if (shmem_huge == SHMEM_HUGE_FORCE)
 		goto alloc_huge;
 	switch (sbinfo->huge) {
-- 
2.7.4


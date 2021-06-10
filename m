From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 10 Jun 2021 10:39:43 -0700
Message-ID: <20210610173944.1203706-3-schatzberg.dan@gmail.com>
References: <20210610173944.1203706-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lCRNE9exhy9WFifL3FriooCp94kazhT9QF+anNMPc+4=;
        b=dI1xhGmDysXuwpJBMly8vuj6ZM3geTPTQNJnlNbuNn1TvzYLVZIAlunDY8WjPNCQD0
         SHoNxvOLSL7p9GkdGgqn37dwEZ+LUV7qQUuI/uCl1LPgyZrPo//RN3ZqAwVDTugPnW7r
         CDx3JGc6pq8zDTyCYP76qQYlKn5lodwZUqJNFtsiyTTvQBYVU143jfaaf1/bV/jkpzsk
         AIO+v3rZMLkvxDe/ucUme7O1n5RT9S/eyFr1wILK09Hv+lwqlU2ztuUg/1BA05eJdkBP
         G3RHRZUrS73Ssw5Z+S9VQ8T7vYtRpxi0d7thnsFRl+4zJ6aSoo1RtUMsmr19OIpatJX2
         hdfQ==
In-Reply-To: <20210610173944.1203706-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP CGROUP" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

set_active_memcg() worked for kernel allocations but was silently
ignored for user pages.

This patch establishes a precedence order for who gets charged:

1. If there is a memcg associated with the page already, that memcg is
   charged. This happens during swapin.

2. If an explicit mm is passed, mm->memcg is charged. This happens
   during page faults, which can be triggered in remote VMs (eg gup).

3. Otherwise consult the current process context. If there is an
   active_memcg, use that. Otherwise, current->mm->memcg.

Previously, if a NULL mm was passed to mem_cgroup_charge (case 3) it
would always charge the root cgroup. Now it looks up the active_memcg
first (falling back to charging the root cgroup if not set).

Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Acked-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/filemap.c    |  2 +-
 mm/memcontrol.c | 41 +++++++++++++++++++++++++++--------------
 mm/shmem.c      |  4 ++--
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ba1068a1837f..bde9c167c056 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -872,7 +872,7 @@ noinline int __add_to_page_cache_locked(struct page *page,
 	page->index = offset;
 
 	if (!huge) {
-		error = mem_cgroup_charge(page, current->mm, gfp);
+		error = mem_cgroup_charge(page, NULL, gfp);
 		if (error)
 			goto error;
 		charged = true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e6c6658ca0d..919736ee656b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -902,13 +902,24 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 }
 EXPORT_SYMBOL(mem_cgroup_from_task);
 
+static __always_inline struct mem_cgroup *active_memcg(void)
+{
+	if (in_interrupt())
+		return this_cpu_read(int_active_memcg);
+	else
+		return current->active_memcg;
+}
+
 /**
  * get_mem_cgroup_from_mm: Obtain a reference on given mm_struct's memcg.
  * @mm: mm from which memcg should be extracted. It can be NULL.
  *
- * Obtain a reference on mm->memcg and returns it if successful. Otherwise
- * root_mem_cgroup is returned. However if mem_cgroup is disabled, NULL is
- * returned.
+ * Obtain a reference on mm->memcg and returns it if successful. If mm
+ * is NULL, then the memcg is chosen as follows:
+ * 1) The active memcg, if set.
+ * 2) current->mm->memcg, if available
+ * 3) root memcg
+ * If mem_cgroup is disabled, NULL is returned.
  */
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
@@ -926,8 +937,17 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 	 * counting is disabled on the root level in the
 	 * cgroup core. See CSS_NO_REF.
 	 */
-	if (unlikely(!mm))
-		return root_mem_cgroup;
+	if (unlikely(!mm)) {
+		memcg = active_memcg();
+		if (unlikely(memcg)) {
+			/* remote memcg must hold a ref */
+			css_get(&memcg->css);
+			return memcg;
+		}
+		mm = current->mm;
+		if (unlikely(!mm))
+			return root_mem_cgroup;
+	}
 
 	rcu_read_lock();
 	do {
@@ -940,14 +960,6 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
-static __always_inline struct mem_cgroup *active_memcg(void)
-{
-	if (in_interrupt())
-		return this_cpu_read(int_active_memcg);
-	else
-		return current->active_memcg;
-}
-
 static __always_inline bool memcg_kmem_bypass(void)
 {
 	/* Allow remote memcg charging from any context. */
@@ -6716,7 +6728,8 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
  * @gfp_mask: reclaim mode
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Do not use this for pages allocated for swapin.
  *
diff --git a/mm/shmem.c b/mm/shmem.c
index 34d84465ce3e..9af4b2173fe9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1695,7 +1695,7 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
 	struct swap_info_struct *si;
 	struct page *page = NULL;
 	swp_entry_t swap;
@@ -1828,7 +1828,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = pagecache_get_page(mapping, index,
 					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
-- 
2.30.2


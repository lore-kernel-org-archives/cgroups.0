From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Tue, 16 Mar 2021 08:36:51 -0700
Message-ID: <20210316153655.500806-3-schatzberg.dan@gmail.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Io4/SuSrOnO2lgbZBjKm6Sy30ngmcZaMUy5F+H9fpyg=;
        b=litRM2T0M677dAg8+HS9+0ucinGZ/dprpSboNx4ygkFJPc0HA7LeXLHFrv7Q9m7k79
         aUxF39PH+bvWZtQ0icKUCN/4ShHLXO2+bh72cKKbvhbVjEJDHIL0WCz61My8fhcto88B
         QvLWU0tlpdH7qaNFpUHjdjkJ7Asl4Hi0b3cRIqZ93FsHXczVR7keUqqqpiMBaIlsoJ5m
         HokRsWiOoqXWTO98zQWkfe4xQC3jTTfs0+bMx0aKRlA47CnKyFscvmsBxs3Z7jKLx+jd
         1HGoBPab+GGGBMBfNjofRaLQVJrgvBq2KfmpJBH1thj4ZTg7KHcg32MgwI4IJ2rSfJh/
         2noQ==
In-Reply-To: <20210316153655.500806-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, linux-

memalloc_use_memcg() worked for kernel allocations but was silently
ignored for user pages.

This patch establishes a precedence order for who gets charged:

1. If there is a memcg associated with the page already, that memcg is
   charged. This happens during swapin.

2. If an explicit mm is passed, mm->memcg is charged. This happens
   during page faults, which can be triggered in remote VMs (eg gup).

3. Otherwise consult the current process context. If it has configured
   a current->active_memcg, use that. Otherwise, current->mm->memcg.

Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
would always charge the root cgroup. Now it looks up the current
active_memcg first (falling back to charging the root cgroup if not
set).

Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
---
 mm/filemap.c    |  2 +-
 mm/memcontrol.c | 14 +++++++++++---
 mm/shmem.c      |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 43700480d897..5135f330f05c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -843,7 +843,7 @@ noinline int __add_to_page_cache_locked(struct page *page,
 	page->index = offset;
 
 	if (!huge) {
-		error = mem_cgroup_charge(page, current->mm, gfp);
+		error = mem_cgroup_charge(page, NULL, gfp);
 		if (error)
 			goto error;
 		charged = true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e064ac0d850a..9a1b23ed3412 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6690,7 +6690,8 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
  * @gfp_mask: reclaim mode
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
@@ -6726,8 +6727,15 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 		rcu_read_unlock();
 	}
 
-	if (!memcg)
-		memcg = get_mem_cgroup_from_mm(mm);
+	if (!memcg) {
+		if (!mm) {
+			memcg = get_mem_cgroup_from_current();
+			if (!memcg)
+				memcg = get_mem_cgroup_from_mm(current->mm);
+		} else {
+			memcg = get_mem_cgroup_from_mm(mm);
+		}
+	}
 
 	ret = try_charge(memcg, gfp_mask, nr_pages);
 	if (ret)
diff --git a/mm/shmem.c b/mm/shmem.c
index b2db4ed0fbc7..353b362c370e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1695,7 +1695,7 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
 	struct page *page;
 	swp_entry_t swap;
 	int error;
@@ -1816,7 +1816,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = pagecache_get_page(mapping, index,
 					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
-- 
2.30.2


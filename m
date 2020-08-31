From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Mon, 31 Aug 2020 11:36:59 -0400
Message-ID: <20200831153704.16848-3-schatzberg.dan@gmail.com>
References: <20200831153704.16848-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hFNO1srh3AW4C+hy+7CfuD56Hs7de0B4v+mt5P6Q+8c=;
        b=SjePWpDm/dcOfaWyG090sIQ82qRogNC8U9o/SXOsilJibfKn37U7NrP6cYs9z13ajn
         3ahnbXMI1dfgdzV1jsX4P8YPuyM1wY2QGXQiesxpHGGEg3Z23HYwzkk62guOns9HMJyO
         mv5bVZQTbHPtdEJ+eNlOenVGaVNmy48r50T0qx1KJrkByftLK+OzvzENGehdjQZ0EdVJ
         SbKPXAl9lN5Bz1sTMxYIYgFWi6dPAG2dwLhw1nXA9usckN3AXJXudsT9uUJdRuIs/Ntq
         5nv1yGY0UIXNQDK7x6fl3OY/BjqkvDLJzoM8kbzBSnvSW8Q8tEl7Yp4cPcUq9xxnCReP
         1UgQ==
In-Reply-To: <20200831153704.16848-1-schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Shakeel Butt <shakeelb@google.com>, Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Yang Shi <yang.shi@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm@kvack.org>

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
 mm/memcontrol.c | 11 ++++++++---
 mm/shmem.c      |  4 ++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e27ac6d79a32..877778b792da 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6676,7 +6676,8 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
  * @gfp_mask: reclaim mode
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
@@ -6712,8 +6713,12 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 		rcu_read_unlock();
 	}
 
-	if (!memcg)
-		memcg = get_mem_cgroup_from_mm(mm);
+	if (!memcg) {
+		if (!mm)
+			memcg = get_mem_cgroup_from_current();
+		else
+			memcg = get_mem_cgroup_from_mm(mm);
+	}
 
 	ret = try_charge(memcg, gfp_mask, nr_pages);
 	if (ret)
diff --git a/mm/shmem.c b/mm/shmem.c
index 271548ca20f3..1139f52ac4ee 100644
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
@@ -1809,7 +1809,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = find_lock_entry(mapping, index);
 	if (xa_is_value(page)) {
-- 
2.24.1


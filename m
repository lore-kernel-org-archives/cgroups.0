From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH 3/4] mm: Charge active memcg when no mm is set
Date: Mon, 24 Aug 2020 11:36:01 -0400
Message-ID: <20200824153607.6595-4-schatzberg.dan@gmail.com>
References: <20200824153607.6595-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yrl/C8FqKmoOKWHTpqylWzEmmhY9cYd3FuadfFi1qcU=;
        b=RItE8EEVLrQqxhHs3ZQx7Foq2ps0SM+5TqKNvM/s7lfy4kor2yBW+T08mxhNfvBWdd
         2RGDEzkzR8jhYgMV3q7iDQIFJ5N3+DPafuAHlDCJjomPLEEaQCEiUHaXB/fY9433YTsC
         z4u23zXtSA57ff5mbtLKaqvEvZLJ+9p0xfEpVwFss6stu2xMCbmkqgJvkbrdqwsittxM
         vxEsBpyiDThrdVRko7aOAFnRIcOS3OruLiTt18HlFoE4bY7VQ4/Se9LhQo94miRVqNqE
         zltvwW6JVmIcXiauJaAOAdvAv7LmqDFpUiL4nh1upk4yoUY62xPrZP3zlYv/LPKosakr
         rJZQ==
In-Reply-To: <20200824153607.6595-1-schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Shakeel Butt <shakeelb@google.com>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Yang Shi <yang.shi@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michel Lespinasse <walken@google.com>

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
 mm/shmem.c      |  5 +++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b2468c80085d..79c70eef3ec3 100644
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
index 271548ca20f3..77c908730be4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1695,7 +1695,8 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
+	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
 	int error;
@@ -1809,7 +1810,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = find_lock_entry(mapping, index);
 	if (xa_is_value(page)) {
-- 
2.24.1


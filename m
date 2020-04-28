From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH v5 3/4] mm: Charge active memcg when no mm is set
Date: Tue, 28 Apr 2020 12:13:49 -0400
Message-ID: <20200428161355.6377-4-schatzberg.dan@gmail.com>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xs7a52HdDCbAExnqSe5+2K/TyJ01Rp0raQ7acG2FHw=;
        b=E4MNL14QuXFKvfZICzfj5fNhzPIifsriRq/F4PIrWZFWcsdAhA7+/0YMPNgMymNaup
         Xg5cg+/uTHi/B1cn3qqVTK3lQc8Fex5a7ttpahrChGEv0NsDnZ4too1jWJHNnXLNQw+R
         +iIYvu469MXtSxA1M9cd1XTQJES2bzg+0+aYhm3AuODTvkB0BftZvOTYOUJ5I+moLZlK
         RX9FbMcKmqfsgmvdKYefTFWyw9fWZK5ZyZgo/276pUXQvXnStHGF+au3idehdV+SDLTb
         NR9+2WD3an1OkNxpAH9PFODMjWySx36OGCQynoDU89LYMeGLBeeZDUI1vcybRjj3gp7a
         6vYw==
In-Reply-To: <20200428161355.6377-1-schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Shakeel Butt <shakeelb@google.com>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Yang Shi <yang.shi@linux.alibaba.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andre

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
index 5beea03dd58a..af68d1d7b456 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6435,7 +6435,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
  * @compound: charge the page as compound or small page
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Returns 0 on success, with *@memcgp pointing to the charged memcg.
  * Otherwise, an error code is returned.
@@ -6479,8 +6480,12 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 		}
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
 
diff --git a/mm/shmem.c b/mm/shmem.c
index d722eb830317..8c8ffc35a957 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1618,7 +1618,7 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
 	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
@@ -1753,7 +1753,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = find_lock_entry(mapping, index);
 	if (xa_is_value(page)) {
-- 
2.24.1


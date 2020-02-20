From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 20 Feb 2020 11:51:52 -0500
Message-ID: <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8J4e+RKsO0vBs9ulW2qejTzM3UP4IUucx45iZgHGDk=;
        b=dNg0IiRn+Gk9q6KF+hcyLl60wq0erTW0EXJiWVJ6o7dlHxQ/E0J0TEw5dFNUcTKu6e
         becjiDbCVRRn2+wyS6bnxSDyuVvWnC9V6xOfbWHnYmoD4PKhjTlaDzO/qZIcvObgzOog
         3LlvWuPv6L0ZcZd3Gqc9Ta57OzRhgW+XI3KbpDT/uiekeqDgK1OLt8r6BHQsUfpW17Sb
         MOaGL2lrRUYXhWErY2Hdimj/tnrFkcz9B9QEqZrvjeSN0BiR/Yp3ZZ+akBkuZ7LmThrG
         uJuD9QxOo+NHbUOf5HWYe8qAAkmZnc4v84NIm4DSush/HbfARDvIR6r2yuqD8yFP7HX9
         oyMg==
In-Reply-To: <cover.1582216294.git.schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
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
---
 mm/memcontrol.c | 11 ++++++++---
 mm/shmem.c      |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6f6dc8712e39..b174aff4f069 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6317,7 +6317,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
  * @compound: charge the page as compound or small page
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. If @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Returns 0 on success, with *@memcgp pointing to the charged memcg.
  * Otherwise, an error code is returned.
@@ -6361,8 +6362,12 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
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
index c8f7540ef048..7c7f5acf89d6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1766,7 +1766,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = find_lock_entry(mapping, index);
 	if (xa_is_value(page)) {
-- 
2.17.1


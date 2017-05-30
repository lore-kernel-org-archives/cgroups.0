From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 4/6] mm: memcontrol: use generic mod_memcg_page_state for kmem pages
Date: Tue, 30 May 2017 14:17:22 -0400
Message-ID: <20170530181724.27197-5-hannes@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:
	Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kiwxi6tGH6q3eFCyrYgNksSMxoEynzZbmtr7GY4MzM4=; b=ZGoyT6DAwptXGduT+rN3d9VO47
	swM/K8D+CRUUjFKLc9QSlja1ODXyAyf14Lm1gLvRGxgF7b1o7MbFLUMwDY1J2/jTi5FtUDA80K5vv
	npPBGIm6PHWMfnbmTOcQF9CEGkMQQ8Gk5Ta68C5IWHqYDwrdmGJf4D3nfg7yADpt2rQg=;
In-Reply-To: <20170530181724.27197-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The kmem-specific functions do the same thing. Switch and drop.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 17 -----------------
 kernel/fork.c              |  8 ++++----
 mm/slab.h                  | 16 ++++++++--------
 3 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7b8f0f239fd6..62139aff6033 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -884,19 +884,6 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-/**
- * memcg_kmem_update_page_stat - update kmem page state statistics
- * @page: the page
- * @idx: page state item to account
- * @val: number of pages (positive or negative)
- */
-static inline void memcg_kmem_update_page_stat(struct page *page,
-				enum memcg_stat_item idx, int val)
-{
-	if (memcg_kmem_enabled() && page->mem_cgroup)
-		this_cpu_add(page->mem_cgroup->stat->count[idx], val);
-}
-
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -919,10 +906,6 @@ static inline void memcg_put_cache_ids(void)
 {
 }
 
-static inline void memcg_kmem_update_page_stat(struct page *page,
-				enum memcg_stat_item idx, int val)
-{
-}
 #endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index aa1076c5e4a9..b5f45fe81a43 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -326,8 +326,8 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		}
 
 		/* All stack pages belong to the same memcg. */
-		memcg_kmem_update_page_stat(vm->pages[0], MEMCG_KERNEL_STACK_KB,
-					    account * (THREAD_SIZE / 1024));
+		mod_memcg_page_state(vm->pages[0], MEMCG_KERNEL_STACK_KB,
+				     account * (THREAD_SIZE / 1024));
 	} else {
 		/*
 		 * All stack pages are in the same zone and belong to the
@@ -338,8 +338,8 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		memcg_kmem_update_page_stat(first_page, MEMCG_KERNEL_STACK_KB,
-					    account * (THREAD_SIZE / 1024));
+		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
+				     account * (THREAD_SIZE / 1024));
 	}
 }
 
diff --git a/mm/slab.h b/mm/slab.h
index 69f0579cb5aa..7b84e3839dfe 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -285,10 +285,10 @@ static __always_inline int memcg_charge_slab(struct page *page,
 	if (ret)
 		return ret;
 
-	memcg_kmem_update_page_stat(page,
-			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-			1 << order);
+	mod_memcg_page_state(page,
+			     (s->flags & SLAB_RECLAIM_ACCOUNT) ?
+			     NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+			     1 << order);
 	return 0;
 }
 
@@ -298,10 +298,10 @@ static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 	if (!memcg_kmem_enabled())
 		return;
 
-	memcg_kmem_update_page_stat(page,
-			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-			-(1 << order));
+	mod_memcg_page_state(page,
+			     (s->flags & SLAB_RECLAIM_ACCOUNT) ?
+			     NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+			     -(1 << order));
 	memcg_kmem_uncharge(page, order);
 }
 
-- 
2.12.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

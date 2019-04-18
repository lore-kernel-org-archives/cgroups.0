From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: refill_stock for kmem uncharging too
Date: Thu, 18 Apr 2019 14:42:24 -0700
Message-ID: <20190418214224.61900-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=605MB47TGZE7++nkg35APlvJ7LvXGdU0fZst7n36xg0=;
        b=oaWnOGJjefDF9ALhsI0TQQYT+yASuFR/0cQfdkTMFbKQL5kxt0lWvB0UfR/e/diMWA
         L5aPgj1ojrRz7lNhejHhqNQsMGPu/6Nzv3/CY8Qx7pKQUaD3AWxi3LJasbtot5BmbPyf
         daKcD6r5a3Sisc7gFSEVTCzEpZ7IY8yDAGe9uWnkIw6nBUdXrfbFSC7p+0YhkpPTQR0F
         kJmDsmSOyvV4y8m65E31wdOVUl2B7auUkm5c9a5Uif1GgOSo9YJSEgTZtwEjZfbBTqAo
         q3hfAfXohgmVx1vGKRM6jzTXjRjAGaBsl07x0Gnx7qDTyX6wRXxGFxin8gxl1bSzIwkl
         aY7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The commit 475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket
memory uncharging") added refill_stock() for skmem uncharging path to
optimize workloads having high network traffic. Do the same for the kmem
uncharging as well. However bypass the refill for offlined memcgs to not
cause zombie apocalypse.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2535e54e7989..7b8de091f572 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -178,6 +178,7 @@ struct mem_cgroup_event {
 
 static void mem_cgroup_threshold(struct mem_cgroup *memcg);
 static void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
+static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
 /* Stuffs for move charges at task migration. */
 /*
@@ -2097,10 +2098,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 	struct mem_cgroup *old = stock->cached;
 
 	if (stock->nr_pages) {
-		page_counter_uncharge(&old->memory, stock->nr_pages);
-		if (do_memsw_account())
-			page_counter_uncharge(&old->memsw, stock->nr_pages);
-		css_put_many(&old->css, stock->nr_pages);
+		cancel_charge(old, stock->nr_pages);
 		stock->nr_pages = 0;
 	}
 	stock->cached = NULL;
@@ -2133,6 +2131,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
 
+	if (unlikely(!mem_cgroup_online(memcg))) {
+		cancel_charge(memcg, nr_pages);
+		return;
+	}
+
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2768,17 +2771,13 @@ void __memcg_kmem_uncharge(struct page *page, int order)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		page_counter_uncharge(&memcg->kmem, nr_pages);
 
-	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, nr_pages);
-
 	page->mem_cgroup = NULL;
 
 	/* slab pages do not have PageKmemcg flag set */
 	if (PageKmemcg(page))
 		__ClearPageKmemcg(page);
 
-	css_put_many(&memcg->css, nr_pages);
+	refill_stock(memcg, nr_pages);
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
-- 
2.21.0.392.gf8f6787159e-goog


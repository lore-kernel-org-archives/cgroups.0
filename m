From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 05/18] mm/memcg: Convert memcg_check_events to take a node ID
Date: Wed, 30 Jun 2021 05:00:21 +0100
Message-ID: <20210630040034.1155892-6-willy@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MPvBRvoA+lVjGYcBT1v6tGu4QtgMR9ceT5UjEW39UbU=; b=uvP2jhH1pd1n+xqgse8zq2VjRM
        bI5UKTYOqu+MvrP1XastqesPZxl+wtn/9e8o/iO0gQ/vAzmnbUPczl2z/m4KsyR8+TG1F6qJIH5NZ
        hYFcs3vjznfGR8mo/UPM9bPvFwWuSPvgRMBJqhtL7QhQgaqW2iWQPTsJiqd1MJwTeWX0tY2m2d1X5
        ivfxnRstvAx5aLn64MT0K3LrFOi2d0gKV3Wiz06idtCwFVt1w3gpFSTWP+HKdbXB0giVoW+NesqV5
        03tZJ38K6dcd1RJSKw8di3c2EHha9PQF9ECMyt7mK+F0GTnK7lCapcQleyCrMIHqgjEhObnacPOQO
        4IMoHV/A==;
In-Reply-To: <20210630040034.1155892-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

memcg_check_events only uses the page's nid, so call page_to_nid in the
callers to make the folio conversion easier.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/memcontrol.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29fdb70dca42..5d143d46a8a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -846,7 +846,7 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
  * Check events in order.
  *
  */
-static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
+static void memcg_check_events(struct mem_cgroup *memcg, int nid)
 {
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
@@ -857,7 +857,7 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 						MEM_CGROUP_TARGET_SOFTLIMIT);
 		mem_cgroup_threshold(memcg);
 		if (unlikely(do_softlimit))
-			mem_cgroup_update_tree(memcg, page_to_nid(page));
+			mem_cgroup_update_tree(memcg, nid);
 	}
 }
 
@@ -5573,7 +5573,7 @@ static int mem_cgroup_move_account(struct page *page,
 	struct lruvec *from_vec, *to_vec;
 	struct pglist_data *pgdat;
 	unsigned int nr_pages = compound ? thp_nr_pages(page) : 1;
-	int ret;
+	int nid, ret;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5662,12 +5662,13 @@ static int mem_cgroup_move_account(struct page *page,
 	__unlock_page_memcg(from);
 
 	ret = 0;
+	nid = page_to_nid(page);
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(to, nr_pages);
-	memcg_check_events(to, page);
+	memcg_check_events(to, nid);
 	mem_cgroup_charge_statistics(from, -nr_pages);
-	memcg_check_events(from, page);
+	memcg_check_events(from, nid);
 	local_irq_enable();
 out_unlock:
 	unlock_page(page);
@@ -6688,7 +6689,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(memcg, nr_pages);
-	memcg_check_events(memcg, page);
+	memcg_check_events(memcg, page_to_nid(page));
 	local_irq_enable();
 out:
 	return ret;
@@ -6796,7 +6797,7 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	struct page *dummy_page;
+	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -6820,7 +6821,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	local_irq_save(flags);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_memory);
-	memcg_check_events(ug->memcg, ug->dummy_page);
+	memcg_check_events(ug->memcg, ug->nid);
 	local_irq_restore(flags);
 
 	/* drop reference from uncharge_page */
@@ -6861,7 +6862,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->memcg = memcg;
-		ug->dummy_page = page;
+		ug->nid = page_to_nid(page);
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&memcg->css);
@@ -6979,7 +6980,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 
 	local_irq_save(flags);
 	mem_cgroup_charge_statistics(memcg, nr_pages);
-	memcg_check_events(memcg, newpage);
+	memcg_check_events(memcg, page_to_nid(newpage));
 	local_irq_restore(flags);
 }
 
@@ -7209,7 +7210,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	 */
 	VM_BUG_ON(!irqs_disabled());
 	mem_cgroup_charge_statistics(memcg, -nr_entries);
-	memcg_check_events(memcg, page);
+	memcg_check_events(memcg, page_to_nid(page));
 
 	css_put(&memcg->css);
 }
-- 
2.30.2


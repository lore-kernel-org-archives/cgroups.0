From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] mm/memcg: remove useless check on page->mem_cgroup
Date: Fri, 31 Jul 2020 11:34:40 +0800
Message-ID: <1596166480-22814-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since readahead page will be charged on memcg too. We don't need to
check this exception now. Rmove them is safe as all user pages are
charged before use.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/memcontrol.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e84c2b5596f2..9e44ae22d591 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1322,12 +1322,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
 	}
 
 	memcg = page->mem_cgroup;
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
-	if (!memcg)
-		memcg = root_mem_cgroup;
+	VM_BUG_ON_PAGE(!memcg, page);
 
 	mz = mem_cgroup_page_nodeinfo(memcg, page);
 	lruvec = &mz->lruvec;
@@ -6897,10 +6892,8 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 	if (newpage->mem_cgroup)
 		return;
 
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = oldpage->mem_cgroup;
-	if (!memcg)
-		return;
+	VM_BUG_ON_PAGE(!memcg, oldpage);
 
 	/* Force-charge the new page. The old one will be freed soon */
 	nr_pages = thp_nr_pages(newpage);
@@ -7094,10 +7087,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 		return;
 
 	memcg = page->mem_cgroup;
-
-	/* Readahead page, never charged */
-	if (!memcg)
-		return;
+	VM_BUG_ON_PAGE(!memcg, page);
 
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
@@ -7158,10 +7148,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 		return 0;
 
 	memcg = page->mem_cgroup;
-
-	/* Readahead page, never charged */
-	if (!memcg)
-		return 0;
+	VM_BUG_ON_PAGE(!memcg, page);
 
 	if (!entry.val) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-- 
1.8.3.1


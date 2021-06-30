From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 09/18] mm/memcg: Convert uncharge_page() to uncharge_folio()
Date: Wed, 30 Jun 2021 05:00:25 +0100
Message-ID: <20210630040034.1155892-10-willy@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BjFTpfwTcvz8MB4hey3lD2XB4nBfnZtvn9hoGEU7psY=; b=LhcrdRX8xHPlCZzxWD5rgHNQLd
        7RTIJiPMacDiMun10jtFkRbyaEkpzow5sMxM6qGhikcFkuPAATjrwgrFRzbppUmCySfcvM+pXj23P
        2RlWftAPIjXeEFiuy0cIoqKeR2SdibjNjZB0eH3B+IcuQ42Pw2Y2za20GQnawP0fzwzL/z/VBvuAq
        uQhlXvycqBr9s9YEDhS98nFcK7Ii4sNPP1Ob6GgBBdYj6E4BnrqlCUtQLwQF2x522STDwMbycFcFt
        xqAe87EyGlgno5lX8pCoIqhk8zDhmyEOq050WAGeguJw1CmKMuzR4wFqQHXsT1yMzrNUGSlZMpHoG
        oayCqTSA==;
In-Reply-To: <20210630040034.1155892-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Use a folio rather than a page to ensure that we're only operating on
base or head pages, and not tail pages.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/memcontrol.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1dc02ecd3257..21b791935957 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6827,24 +6827,23 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	memcg_check_events(ug->memcg, ug->nid);
 	local_irq_restore(flags);
 
-	/* drop reference from uncharge_page */
+	/* drop reference from uncharge_folio */
 	css_put(&ug->memcg->css);
 }
 
-static void uncharge_page(struct page *page, struct uncharge_gather *ug)
+static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 {
-	struct folio *folio = page_folio(page);
 	unsigned long nr_pages;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
-	bool use_objcg = PageMemcgKmem(page);
+	bool use_objcg = folio_memcg_kmem(folio);
 
-	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_FOLIO(folio_lru(folio), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * page memcg or objcg at this point, we have fully
-	 * exclusive access to the page.
+	 * folio memcg or objcg at this point, we have fully
+	 * exclusive access to the folio.
 	 */
 	if (use_objcg) {
 		objcg = __folio_objcg(folio);
@@ -6866,19 +6865,19 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->memcg = memcg;
-		ug->nid = page_to_nid(page);
+		ug->nid = folio_nid(folio);
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&memcg->css);
 	}
 
-	nr_pages = compound_nr(page);
+	nr_pages = folio_nr_pages(folio);
 
 	if (use_objcg) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
 
-		page->memcg_data = 0;
+		folio->memcg_data = 0;
 		obj_cgroup_put(objcg);
 	} else {
 		/* LRU pages aren't accounted at the root level */
@@ -6886,7 +6885,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 			ug->nr_memory += nr_pages;
 		ug->pgpgout++;
 
-		page->memcg_data = 0;
+		folio->memcg_data = 0;
 	}
 
 	css_put(&memcg->css);
@@ -6910,7 +6909,7 @@ void mem_cgroup_uncharge(struct page *page)
 		return;
 
 	uncharge_gather_clear(&ug);
-	uncharge_page(page, &ug);
+	uncharge_folio(page_folio(page), &ug);
 	uncharge_batch(&ug);
 }
 
@@ -6924,14 +6923,14 @@ void mem_cgroup_uncharge(struct page *page)
 void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
 	struct uncharge_gather ug;
-	struct page *page;
+	struct folio *folio;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	uncharge_gather_clear(&ug);
-	list_for_each_entry(page, page_list, lru)
-		uncharge_page(page, &ug);
+	list_for_each_entry(folio, page_list, lru)
+		uncharge_folio(folio, &ug);
 	if (ug.memcg)
 		uncharge_batch(&ug);
 }
-- 
2.30.2


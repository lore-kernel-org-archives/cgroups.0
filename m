From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 18/18] mm/workingset: Convert workingset_activation to take a folio
Date: Wed, 30 Jun 2021 05:00:34 +0100
Message-ID: <20210630040034.1155892-19-willy@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=IUJn7fv6b1sKrSHn34p73lOPM2JMvc5qmpjo7WAOjUQ=; b=GDhSlS4SW0/M6iFfmbhYQKgnwA
        /7k/QjUaQF3EKvwpuYLYPBklvJytSFFa6SZ/eUuS50goObx4WKUqfgT1Qx81zc7+aa2mPBCNnsQYN
        efzKJ7mM9bu/k0RvCMYvjwSbOMxs/UF8qof8Xcd0cG/P/NI0q3X/RTvY0EICE9e0H9eoj5HfT/+Ou
        Pl/FEyyKAPcCa716TeYODolUUPRLzL4sJrJB2+g8LjDkSHp99/uYsO5lAXpLS9ULNzLjz20XbiQOF
        uu+GQvB6P/90lh7OLuaXumL5vq4xIEtKUM2uSspYswC46drHRdydKjTj2Zmof+b2iKL1UltqGlROx
        2pjLzc9Q==;
In-Reply-To: <20210630040034.1155892-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

This function already assumed it was being passed a head page.  No real
change here, except that thp_nr_pages() compiles away on kernels with
THP compiled out while folio_nr_pages() is always present.  Also convert
page_memcg_rcu() to folio_memcg_rcu().

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/memcontrol.h | 18 +++++++++---------
 include/linux/swap.h       |  2 +-
 mm/swap.c                  |  2 +-
 mm/workingset.c            | 10 +++++-----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e6b5e8fbf770..be131c28b3bc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -462,19 +462,19 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 }
 
 /*
- * page_memcg_rcu - locklessly get the memory cgroup associated with a page
- * @page: a pointer to the page struct
+ * folio_memcg_rcu - Locklessly get the memory cgroup associated with a folio.
+ * @folio: Pointer to the folio.
  *
- * Returns a pointer to the memory cgroup associated with the page,
- * or NULL. This function assumes that the page is known to have a
+ * Returns a pointer to the memory cgroup associated with the folio,
+ * or NULL. This function assumes that the folio is known to have a
  * proper memory cgroup pointer. It's not safe to call this function
- * against some type of pages, e.g. slab pages or ex-slab pages.
+ * against some type of folios, e.g. slab folios or ex-slab folios.
  */
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
 {
-	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
 
-	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_FOLIO(folio_slab(folio), folio);
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	if (memcg_data & MEMCG_DATA_KMEM) {
@@ -1125,7 +1125,7 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	return NULL;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 950dd96007ad..614bbef65777 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -325,7 +325,7 @@ static inline swp_entry_t folio_swap_entry(struct folio *folio)
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct page *page, struct mem_cgroup *target_memcg);
 void workingset_refault(struct page *page, void *shadow);
-void workingset_activation(struct page *page);
+void workingset_activation(struct folio *folio);
 
 /* Only track the nodes of mappings with shadow entries */
 void workingset_update_node(struct xa_node *node);
diff --git a/mm/swap.c b/mm/swap.c
index 8ba62a930370..3c817717af0c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -447,7 +447,7 @@ void mark_page_accessed(struct page *page)
 		else
 			__lru_cache_activate_page(page);
 		ClearPageReferenced(page);
-		workingset_activation(page);
+		workingset_activation(page_folio(page));
 	}
 	if (page_is_idle(page))
 		clear_page_idle(page);
diff --git a/mm/workingset.c b/mm/workingset.c
index 4f7a306ce75a..86e239ec0306 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -390,9 +390,9 @@ void workingset_refault(struct page *page, void *shadow)
 
 /**
  * workingset_activation - note a page activation
- * @page: page that is being activated
+ * @folio: Folio that is being activated.
  */
-void workingset_activation(struct page *page)
+void workingset_activation(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
@@ -405,11 +405,11 @@ void workingset_activation(struct page *page)
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	memcg = page_memcg_rcu(page);
+	memcg = folio_memcg_rcu(folio);
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec = mem_cgroup_page_lruvec(page);
-	workingset_age_nonresident(lruvec, thp_nr_pages(page));
+	lruvec = mem_cgroup_folio_lruvec(folio);
+	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 out:
 	rcu_read_unlock();
 }
-- 
2.30.2


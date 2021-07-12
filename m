From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v13 18/18] mm/workingset: Convert workingset_activation to take a folio
Date: Mon, 12 Jul 2021 20:45:51 +0100
Message-ID: <20210712194551.91920-19-willy@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=2vhZlOdcq3zLt9VVVyRnzOfxOMomDSCQmvA/+EiX9RM=; b=pu4bHcfKYW/p+k6tiF66YjhDlv
        A8qYhBxb35CW8IfbOXkRD637p2/zyosc9e7iR/ddFxYLG3Ng0h9ZGrlMRmuJzPz8BlESXoZNkyiXA
        DTVzKuv3jSCYPt/uV2cfIV/E/ytVJawbYELn3grtMSUlsiapP+rStYWWOhv3vDCcg74ZTLNSuEJxD
        puiSDKUuhrcFFNa2tnaaNnAirptVxn0uhfWIUupKJb9EUIlfqWCVkmQ01FuBsrhz9nrVYaamLPCBT
        R8pDqHM3H5wDFsy7zMbQszA6TKLkvfgJkZcSPksh3s1mD+iJNmWikLYUkSapAClHgqxqyRv5Zh445
        6S9Ww6Bw==;
In-Reply-To: <20210712194551.91920-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

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
 mm/workingset.c            | 11 ++++-------
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 469e5473bdfb..42fec3af745d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -461,19 +461,19 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
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
@@ -1129,7 +1129,7 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	return NULL;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8394716a002b..989d8f78c256 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -330,7 +330,7 @@ static inline swp_entry_t folio_swap_entry(struct folio *folio)
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct page *page, struct mem_cgroup *target_memcg);
 void workingset_refault(struct page *page, void *shadow);
-void workingset_activation(struct page *page);
+void workingset_activation(struct folio *folio);
 
 /* Only track the nodes of mappings with shadow entries */
 void workingset_update_node(struct xa_node *node);
diff --git a/mm/swap.c b/mm/swap.c
index 42222653e6ef..5c681c01e3fa 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -451,7 +451,7 @@ void mark_page_accessed(struct page *page)
 		else
 			__lru_cache_activate_page(page);
 		ClearPageReferenced(page);
-		workingset_activation(page);
+		workingset_activation(page_folio(page));
 	}
 	if (page_is_idle(page))
 		clear_page_idle(page);
diff --git a/mm/workingset.c b/mm/workingset.c
index e62c0f2084a2..39bb60d50217 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -392,13 +392,11 @@ void workingset_refault(struct page *page, void *shadow)
 
 /**
  * workingset_activation - note a page activation
- * @page: page that is being activated
+ * @folio: Folio that is being activated.
  */
-void workingset_activation(struct page *page)
+void workingset_activation(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
 	/*
@@ -408,11 +406,10 @@ void workingset_activation(struct page *page)
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	memcg = page_memcg_rcu(page);
+	memcg = folio_memcg_rcu(folio);
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec = folio_lruvec(folio);
-	workingset_age_nonresident(lruvec, thp_nr_pages(page));
+	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
 out:
 	rcu_read_unlock();
 }
-- 
2.30.2


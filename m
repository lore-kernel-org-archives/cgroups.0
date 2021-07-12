From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v13 13/18] mm/memcg: Add folio_memcg_lock() and folio_memcg_unlock()
Date: Mon, 12 Jul 2021 20:45:46 +0100
Message-ID: <20210712194551.91920-14-willy@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=51qNegk4MOFBypigxzEgiiawrPVxETdbEsPuFpcHYYQ=; b=j27kbRKnlcgBmvuTFs1WTGYPb/
        w9Wl5WLdwsvIHmDy6YxuZQXdJ3X12c8Rmn+jfnBQOirXwMs+In4R74fhQoTg+V3ASaMeCyJXE+qAC
        9o1+LtdR+cer0NixoVHWfgAioPGompQTPCQFW647cfuGcYOrLBsn8wzW0AfsPuWM1Zw1Ji58IucuA
        gme/cJ8eINUp7UsgQdzAxBPlrDGLHdQwsN+WR9wVjUbT3XkdHMnM07zEzRCou62YVXvwyekL3I7OU
        c/FBTTnjwY0HD6rQM/5kV41wu3LT5vC/OZavQYjWOWfsB+N02VBPva78CxhASirYwegiFtQ/UkmBr
        6cocSg4Q==;
In-Reply-To: <20210712194551.91920-1-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

These are the folio equivalents of lock_page_memcg() and
unlock_page_memcg().

lock_page_memcg() and unlock_page_memcg() have too many callers to be
easily replaced in a single patch, so reimplement them as wrappers for
now to be cleaned up later when enough callers have been converted to
use folios.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a82939df13dc..be8664e027d5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -950,6 +950,8 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 extern bool cgroup_memory_noswap;
 #endif
 
+void folio_memcg_lock(struct folio *folio);
+void folio_memcg_unlock(struct folio *folio);
 void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
@@ -1367,6 +1369,14 @@ static inline void unlock_page_memcg(struct page *page)
 {
 }
 
+static inline void folio_memcg_lock(struct folio *folio)
+{
+}
+
+static inline void folio_memcg_unlock(struct folio *folio)
+{
+}
+
 static inline void mem_cgroup_handle_over_high(void)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ffa9a9b2ad76..cff267c59f4d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1965,18 +1965,17 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 }
 
 /**
- * lock_page_memcg - lock a page and memcg binding
- * @page: the page
+ * folio_memcg_lock - Bind a folio to its memcg.
+ * @folio: The folio.
  *
- * This function protects unlocked LRU pages from being moved to
+ * This function prevents unlocked LRU folios from being moved to
  * another cgroup.
  *
- * It ensures lifetime of the locked memcg. Caller is responsible
- * for the lifetime of the page.
+ * It ensures lifetime of the bound memcg.  The caller is responsible
+ * for the lifetime of the folio.
  */
-void lock_page_memcg(struct page *page)
+void folio_memcg_lock(struct folio *folio)
 {
-	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
 	unsigned long flags;
 
@@ -1990,7 +1989,7 @@ void lock_page_memcg(struct page *page)
 	if (mem_cgroup_disabled())
 		return;
 again:
-	memcg = page_memcg(head);
+	memcg = folio_memcg(folio);
 	if (unlikely(!memcg))
 		return;
 
@@ -2004,7 +2003,7 @@ void lock_page_memcg(struct page *page)
 		return;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
-	if (memcg != page_memcg(head)) {
+	if (memcg != folio_memcg(folio)) {
 		spin_unlock_irqrestore(&memcg->move_lock, flags);
 		goto again;
 	}
@@ -2018,9 +2017,15 @@ void lock_page_memcg(struct page *page)
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 }
+EXPORT_SYMBOL(folio_memcg_lock);
+
+void lock_page_memcg(struct page *page)
+{
+	folio_memcg_lock(page_folio(page));
+}
 EXPORT_SYMBOL(lock_page_memcg);
 
-static void __unlock_page_memcg(struct mem_cgroup *memcg)
+static void __folio_memcg_unlock(struct mem_cgroup *memcg)
 {
 	if (memcg && memcg->move_lock_task == current) {
 		unsigned long flags = memcg->move_lock_flags;
@@ -2035,14 +2040,22 @@ static void __unlock_page_memcg(struct mem_cgroup *memcg)
 }
 
 /**
- * unlock_page_memcg - unlock a page and memcg binding
- * @page: the page
+ * folio_memcg_unlock - Release the binding between a folio and its memcg.
+ * @folio: The folio.
+ *
+ * This releases the binding created by folio_memcg_lock().  This does
+ * not change the accounting of this folio to its memcg, but it does
+ * permit others to change it.
  */
-void unlock_page_memcg(struct page *page)
+void folio_memcg_unlock(struct folio *folio)
 {
-	struct page *head = compound_head(page);
+	__folio_memcg_unlock(folio_memcg(folio));
+}
+EXPORT_SYMBOL(folio_memcg_unlock);
 
-	__unlock_page_memcg(page_memcg(head));
+void unlock_page_memcg(struct page *page)
+{
+	folio_memcg_unlock(page_folio(page));
 }
 EXPORT_SYMBOL(unlock_page_memcg);
 
@@ -5666,7 +5679,7 @@ static int mem_cgroup_move_account(struct page *page,
 
 	page->memcg_data = (unsigned long)to;
 
-	__unlock_page_memcg(from);
+	__folio_memcg_unlock(from);
 
 	ret = 0;
 	nid = page_to_nid(page);
-- 
2.30.2


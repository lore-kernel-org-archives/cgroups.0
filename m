From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC PATCH v2 6/8] mm: splice local lists onto the front of the LRU
Date: Mon, 10 Sep 2018 20:59:47 -0400
Message-ID: <20180911005949.5635-3-daniel.m.jordan@oracle.com>
References: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Unlfp95VRYdh0zaKiyB62CoToWdwSBQEhoPttxdHTH0=;
 b=u02JgrKpOKciZh4jINL64Aaced2qCB6CUVl7FrYZy0RUveF/au1rTGvHhRN2hYrSsqOX
 mXpPg69Smv9wvL83jQoBnTjZJj4hZz253cFDZPKyfZCOtuCRENLSBnkuT+xeN5YHz2vQ
 B/N0a4cFKrl2nldUy5awBHcgytQ4KygmvGdPSD0Jz06RAKEYki474Cy771pcDccz4iWH
 MSB6ULzQLLW9EDbpw+ifT2JW/lD/3JeMGOYUME4df8C9o2RMIWfmihKrs9kdMArxIAh6
 tcuiuuEPeSJOoNNvDbDwBSGKg8C8sQmtXFESclhP+bjKeedhWMGcts5RHE+aW6I8mV3p cA== 
In-Reply-To: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: aaron.lu@intel.com, ak@linux.intel.com, akpm@linux-foundation.org, dave.dice@oracle.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, levyossi@icloud.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, Pavel.Tatashin@microsoft.com, steven.sistare@oracle.com, tim.c.chen@intel.com, vdavydov.dev@gmail.com, ying.huang@intel.com

The add-to-front LRU path currently adds one page at a time to the front
of an LRU.  This is slow when using the concurrent algorithm described
in the next patch because the LRU head node will be locked for every
page that's added.

Instead, prepare local lists of pages, grouped by LRU, to be added to a
given LRU in a single splice operation.  The batching effect will reduce
the amount of time that the LRU head is locked per page added.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 mm/swap.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 4 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index b1030eb7f459..07b951727a11 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -865,8 +865,52 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
-				 void *arg)
+#define	MAX_LRU_SPLICES 4
+
+struct lru_splice {
+	struct list_head list;
+	struct list_head *lru;
+	struct pglist_data *pgdat;
+};
+
+/*
+ * Adds a page to a local list for splicing, or else to the singletons
+ * list for individual processing.
+ *
+ * Returns the new number of splices in the splices list.
+ */
+static size_t add_page_to_splice(struct page *page, struct pglist_data *pgdat,
+				 struct lru_splice *splices, size_t nr_splices,
+				 struct list_head *singletons,
+				 struct list_head *lru)
+{
+	int i;
+
+	for (i = 0; i < nr_splices; ++i) {
+		if (splices[i].lru == lru) {
+			list_add(&page->lru, &splices[i].list);
+			return nr_splices;
+		}
+	}
+
+	if (nr_splices < MAX_LRU_SPLICES) {
+		INIT_LIST_HEAD(&splices[nr_splices].list);
+		splices[nr_splices].lru = lru;
+		splices[nr_splices].pgdat = pgdat;
+		list_add(&page->lru, &splices[nr_splices].list);
+		++nr_splices;
+	} else {
+		list_add(&page->lru, singletons);
+	}
+
+	return nr_splices;
+}
+
+static size_t pagevec_lru_add_splice(struct page *page, struct lruvec *lruvec,
+				     struct pglist_data *pgdat,
+				     struct lru_splice *splices,
+				     size_t nr_splices,
+				     struct list_head *singletons)
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
@@ -916,8 +960,12 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 			count_vm_event(UNEVICTABLE_PGCULLED);
 	}
 
-	add_page_to_lru_list(page, lruvec, lru);
+	nr_splices = add_page_to_splice(page, pgdat, splices, nr_splices,
+					singletons, &lruvec->lists[lru]);
+	update_lru_size(lruvec, lru, page_zonenum(page), hpage_nr_pages(page));
 	trace_mm_lru_insertion(page, lru);
+
+	return nr_splices;
 }
 
 /*
@@ -926,7 +974,74 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, NULL);
+	int i;
+	struct pglist_data *pagepgdat, *pgdat = NULL;
+	unsigned long flags = 0;
+	struct lru_splice splices[MAX_LRU_SPLICES];
+	size_t nr_splices = 0;
+	LIST_HEAD(singletons);
+	struct page *page;
+	struct lruvec *lruvec;
+	enum lru_list lru;
+
+	/*
+	 * Sort the pages into local lists to splice onto the LRU.  In the
+	 * common case there should be few of these local lists.
+	 */
+	for (i = 0; i < pagevec_count(pvec); ++i) {
+		page = pvec->pages[i];
+		pagepgdat = page_pgdat(page);
+
+		/*
+		 * Take lru_lock now so that setting PageLRU and setting the
+		 * local list's links appear to happen atomically.
+		 */
+		if (pagepgdat != pgdat) {
+			if (pgdat)
+				write_unlock_irqrestore(&pgdat->lru_lock, flags);
+			pgdat = pagepgdat;
+			write_lock_irqsave(&pgdat->lru_lock, flags);
+		}
+
+		lruvec = mem_cgroup_page_lruvec(page, pagepgdat);
+
+		nr_splices = pagevec_lru_add_splice(page, lruvec, pagepgdat,
+						    splices, nr_splices,
+						    &singletons);
+	}
+
+	for (i = 0; i < nr_splices; ++i) {
+		struct lru_splice *splice = &splices[i];
+
+		if (splice->pgdat != pgdat) {
+			if (pgdat)
+				write_unlock_irqrestore(&pgdat->lru_lock, flags);
+			pgdat = splice->pgdat;
+			write_lock_irqsave(&pgdat->lru_lock, flags);
+		}
+		list_splice(&splice->list, splice->lru);
+	}
+
+	while (!list_empty(&singletons)) {
+		page = list_first_entry(&singletons, struct page, lru);
+		list_del(singletons.next);
+		pagepgdat = page_pgdat(page);
+
+		if (pagepgdat != pgdat) {
+			if (pgdat)
+				write_unlock_irqrestore(&pgdat->lru_lock, flags);
+			pgdat = pagepgdat;
+			write_lock_irqsave(&pgdat->lru_lock, flags);
+		}
+
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		lru = page_lru(page);
+		list_add(&page->lru, &lruvec->lists[lru]);
+	}
+	if (pgdat)
+		write_unlock_irqrestore(&pgdat->lru_lock, flags);
+	release_pages(pvec->pages, pvec->nr);
+	pagevec_reinit(pvec);
 }
 EXPORT_SYMBOL(__pagevec_lru_add);
 
-- 
2.18.0


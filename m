From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 18/18] mm: memcontrol: update page->mem_cgroup stability rules
Date: Mon, 20 Apr 2020 18:11:26 -0400
Message-ID: <20200420221126.341272-19-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mru2mqYssRMwFvfM60SVK8LHEOtTvwZ9sk9Ozs6ntCE=;
        b=jbzqhoEM5d7NDzw3vfdtgPSSoDlrWCej+05GdZmq+IawnWaqCKW0HH/bet3KzfXkzI
         X40GyZbo6g+QTskRmkxQ4BoKE1dowe9171ocp8SAujcL5g1va70+O2r6uieOwu60OKv8
         2iBVNUCDBAtCC17cBY5xLP4VqdlKXcG9yz2XzIA5GCVzfi2UTnZy+eQnY/ovTSS3Cfgi
         LSZ9xrD0VnTnru809Wm7EHvlmTJ7PAPtjZB29vsCjFkd2c0vuv7jfoYdDviMy/qWaLjt
         yW2FMnGLHwetNA39YeYWTBk6TaxRFtCzGlSWHqLRh9vgdXbHPv8ItR6ybXmvfQgCLRiO
         5F6w==
In-Reply-To: <20200420221126.341272-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The previous patches have simplified the access rules around
page->mem_cgroup somewhat:

1. We never change page->mem_cgroup while the page is isolated by
   somebody else. This was by far the biggest exception to our rules
   and it didn't stop at lock_page() or lock_page_memcg().

2. We charge pages before they get put into page tables now, so the
   somewhat fishy rule about "can be in page table as long as it's
   still locked" is now gone and boiled down to having an exclusive
   reference to the page.

Document the new rules. Any of the following will stabilize the
page->mem_cgroup association:

- the page lock
- LRU isolation
- lock_page_memcg()
- exclusive access to the page

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a8cce52b6b4d..7b63260c9b57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1201,9 +1201,8 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function is only safe when following the LRU page isolation
- * and putback protocol: the LRU lock must be held, and the page must
- * either be PageLRU() or the caller must have isolated/allocated it.
+ * This function relies on page->mem_cgroup being stable - see the
+ * access rules in commit_charge().
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
 {
@@ -2605,18 +2604,12 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 {
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 	/*
-	 * Nobody should be changing or seriously looking at
-	 * page->mem_cgroup at this point:
-	 *
-	 * - the page is uncharged
-	 *
-	 * - the page is off-LRU
-	 *
-	 * - an anonymous fault has exclusive page access, except for
-	 *   a locked page table
+	 * Any of the following ensures page->mem_cgroup stability:
 	 *
-	 * - a page cache insertion, a swapin fault, or a migration
-	 *   have the page locked
+	 * - the page lock
+	 * - LRU isolation
+	 * - lock_page_memcg()
+	 * - exclusive reference
 	 */
 	page->mem_cgroup = memcg;
 }
-- 
2.26.0


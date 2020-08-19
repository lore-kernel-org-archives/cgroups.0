From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 1/5] mm: Identify compound pages sooner in
 isolate_migratepages_block
Date: Tue, 18 Aug 2020 21:27:05 -0700
Message-ID: <20200819042705.23414.84098.stgit@localhost.localdomain>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=O0GPbeNx4pE5Cj/la6lYT0zllz6aGU2XNC8iLf9uFA4=;
        b=pO3zqnqL4c/mDAjAfh4ZWDwEb7d57VhBDoidBgKwr3U5coFnxDOXwnl2WrCcEy2ytc
         vPoW0tq9uKas+aNj5L2ZSate75S8hark40KC/B1fHTbUYPsjwNaa6uOzkoMyUQDpmlBL
         dOt7/SWEQPgLq23TAemQobbfIE2Jpi9Y99z4Ne9S+gMTKMvQKs3YapyvSlEmI2di09pJ
         dHjRXJ2gP38hCNvvOZk4UqKmcWaQRFnTLqeFlhyGet0x8XXRiPSc12oSao2IOrQonhDN
         0qNWU11jMey8c9BEr8FQP9SCHMrSyMK8EtIwBEOpavLMBYW6DnNK/t44D+cr7nXdgrJv
         7tUg==
In-Reply-To: <20200819041852.23414.95939.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi@linux.alibaba.com
Cc: yang.shi@linux.alibaba.com, lkp@intel.com, rong.a.chen@intel.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, hughd@google.com, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, daniel.m.jordan@oracle.com, linux-mm@kvack.org, shakeelb@google.com, willy@infradead.org, hannes@cmpxchg.org, tj@kernel.org, cgroups@vger.kernel.org, akpm@linux-foundation.org, richard.weiyang@gmail.com, mgorman@techsingularity.net, iamjoonsoo.kim@lge.com

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Since we are holding a reference to the page much sooner in
isolate_migratepages_block we can move the PageCompound check out of the
LRU locked section and instead just place it after get_page_unless_zero. By
doing this we can allow any of the items that might trigger a failure to
trigger a failure for the compound page rather than the order 0 page and as
a result we should be able to process the pageblock faster.

In addition by testing for PageCompound sooner we can avoid having the LRU
flag cleared and then reset in the exception case. As a result this should
prevent possible races where another thread might be attempting to pull the
LRU pages from the list.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/compaction.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index d3f87f759773..88c7b950f676 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -984,6 +984,24 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
+		/*
+		 * Page is compound. We know the order before we know if it is
+		 * on the LRU so we cannot assume it is THP. However since the
+		 * page will have the LRU validated shortly we can use the value
+		 * to skip over this page for now or validate the LRU is set and
+		 * then isolate the entire compound page if we are isolating to
+		 * generate a CMA page.
+		 */
+		if (PageCompound(page)) {
+			const unsigned int order = compound_order(page);
+
+			if (likely(order < MAX_ORDER))
+				low_pfn += (1UL << order) - 1;
+
+			if (!cc->alloc_contig)
+				goto isolate_fail_put;
+		}
+
 		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
 			goto isolate_fail_put;
 
@@ -1009,23 +1027,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 				if (test_and_set_skip(cc, page, low_pfn))
 					goto isolate_abort;
 			}
-
-			/*
-			 * Page become compound since the non-locked check,
-			 * and it's on LRU. It can only be a THP so the order
-			 * is safe to read and it's 0 for tail pages.
-			 */
-			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
-				low_pfn += compound_nr(page) - 1;
-				SetPageLRU(page);
-				goto isolate_fail_put;
-			}
 		}
 
-		/* The whole page is taken off the LRU; skip the tail pages. */
-		if (PageCompound(page))
-			low_pfn += compound_nr(page) - 1;
-
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		mod_node_page_state(page_pgdat(page),


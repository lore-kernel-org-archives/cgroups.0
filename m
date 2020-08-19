From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 2/5] mm: Drop use of test_and_set_skip in favor of
 just setting skip
Date: Tue, 18 Aug 2020 21:27:14 -0700
Message-ID: <20200819042713.23414.5084.stgit@localhost.localdomain>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nJQwZMk0HVg1Xi5MdVbpw2haA8xPFp0DOao/4ztkzvc=;
        b=o+etTA4y6IyxOSsiGgtDeP6nsslFfCsdsqI/ytWlD0PrEUbBiCogFNkpkPYaJS2uSV
         5Jrtw6H7e8g3+b0ajpM/n1TB1IoHygoMchrjdnR0ctTVyV0u7c9ejlKYhU6tpaFAg8lf
         cxEjRIH6aarpICQ3D40Jep09AZ1RKdcrXs8Hqoqzr4SdDacFmBkgE/O0LUZAi6SWO5TI
         6GtbeZRf+u/eU7YRn+F6n6QC9lvwgq7CpKoibwq4XfQwRL7JOtdwY79HY6VrXMs2V0Lm
         faOt3XiyhX3ezawcRskNnct6vHVkrJ6FnE5Eo4JnELvFe2nfcGZXW8LJgF6OIMBWdvfL
         d8wA==
In-Reply-To: <20200819041852.23414.95939.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

The only user of test_and_set_skip was isolate_migratepages_block and it
was using it after a call that was testing and clearing the LRU flag. As
such it really didn't need to be behind the LRU lock anymore as it wasn't
really fulfilling its purpose.

Since it is only possible to be able to test and set the skip flag if we
were able to obtain the LRU bit for the first page in the pageblock the
use of the test_and_set_skip becomes redundant as the LRU flag now becomes
the item that limits us to only one thread being able to perform the
operation and there being no need for a test_and_set operation.

With that being the case we can simply drop the bit and instead directly
just call the set_pageblock_skip function if the page we are working on is
the valid_page at the start of the pageblock. Then any other threads that
enter this pageblock should see the skip bit set on the first valid page in
the pageblock.

Since we have dropped the late abort case we can drop the code that was
clearing the LRU flag and calling page_put since the abort case will now
not be holding a reference to a page now.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/compaction.c |   53 +++++++++++++----------------------------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 88c7b950f676..f986c67e83cc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -399,29 +399,6 @@ void reset_isolation_suitable(pg_data_t *pgdat)
 	}
 }
 
-/*
- * Sets the pageblock skip bit if it was clear. Note that this is a hint as
- * locks are not required for read/writers. Returns true if it was already set.
- */
-static bool test_and_set_skip(struct compact_control *cc, struct page *page,
-							unsigned long pfn)
-{
-	bool skip;
-
-	/* Do no update if skip hint is being ignored */
-	if (cc->ignore_skip_hint)
-		return false;
-
-	if (!IS_ALIGNED(pfn, pageblock_nr_pages))
-		return false;
-
-	skip = get_pageblock_skip(page);
-	if (!skip && !cc->no_set_skip_hint)
-		set_pageblock_skip(page);
-
-	return skip;
-}
-
 static void update_cached_migrate(struct compact_control *cc, unsigned long pfn)
 {
 	struct zone *zone = cc->zone;
@@ -480,12 +457,6 @@ static inline void update_pageblock_skip(struct compact_control *cc,
 static void update_cached_migrate(struct compact_control *cc, unsigned long pfn)
 {
 }
-
-static bool test_and_set_skip(struct compact_control *cc, struct page *page,
-							unsigned long pfn)
-{
-	return false;
-}
 #endif /* CONFIG_COMPACTION */
 
 /*
@@ -895,7 +866,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
 			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
 				low_pfn = end_pfn;
-				page = NULL;
 				goto isolate_abort;
 			}
 			valid_page = page;
@@ -1021,11 +991,20 @@ static bool too_many_isolated(pg_data_t *pgdat)
 
 			lruvec_memcg_debug(lruvec, page);
 
-			/* Try get exclusive access under lock */
-			if (!skip_updated) {
+			/*
+			 * Indicate that we want exclusive access to the
+			 * rest of the pageblock.
+			 *
+			 * The LRU flag prevents simultaneous access to the
+			 * first PFN, and the LRU lock helps to prevent
+			 * simultaneous update of multiple pageblocks shared
+			 * in the same bitmap.
+			 */
+			if (page == valid_page) {
+				if (!cc->ignore_skip_hint &&
+				    !cc->no_set_skip_hint)
+					set_pageblock_skip(page);
 				skip_updated = true;
-				if (test_and_set_skip(cc, page, low_pfn))
-					goto isolate_abort;
 			}
 		}
 
@@ -1098,15 +1077,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	if (unlikely(low_pfn > end_pfn))
 		low_pfn = end_pfn;
 
-	page = NULL;
-
 isolate_abort:
 	if (lruvec)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
-	if (page) {
-		SetPageLRU(page);
-		put_page(page);
-	}
 
 	/*
 	 * Updated the cached scanner pfn once the pageblock has been scanned


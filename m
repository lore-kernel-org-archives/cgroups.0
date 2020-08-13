From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 2/3] mm: Drop use of test_and_set_skip in favor of just
 setting skip
Date: Wed, 12 Aug 2020 21:02:32 -0700
Message-ID: <20200813040232.13054.82417.stgit@localhost.localdomain>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=g1Efyw0jo1iBHDaFGnCxXDBpkzz2KS4HPptzP2dpWOE=;
        b=SASn4JQnilStqGrDLOtz2BFduofMDuiSagfrx9tnHZ71TnmRd67ZdWrSRGdfw9IAGq
         m9yIwMMEh0ZnxBlWWdbePMh6dEcgXTiWIPxC6fGrDTGYo7BGwbIWQwzY9Jhaq1h4RGIO
         0Arw+y0bGAEeM1aYyHrS3Z9BHtyk9Pr+2pPT2rEJCnIlPqpxaCX+EcEyt7FFs1Zxo3Xo
         fy/zMPyLB9PA4P+zHE4VNKdiRgum8g6zhIjBRU+lJwJ8BAiAlg75lMljBWqa4qUbT9l4
         1TyLlqB6Kq8Gfn4JyGDzb0CJ/iU7Cu1i1QISLdmN/pZIL9Mz33xB9MB15pN+tZnGiLAO
         RQNQ==
In-Reply-To: <20200813035100.13054.25671.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

With that being the case we can simply drop the bit and instead directly
just call the set_pageblock_skip function if the page we are working on is
the valid_page at the start of the pageblock. It shouldn't be possible for
us to encounter the bit being set since we obtained the LRU flag for the
first page in the pageblock which means we would have exclusive access to
setting the skip bit. As such we don't need to worry about the abort case
since no other thread will be able to call what used to be
test_and_set_skip.

Since we have dropped the late abort case we can drop the code that was
clearing the LRU flag and calling page_put since the abort case will now
not be holding a reference to a page.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/compaction.c |   50 +++++++-------------------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5021a18ef722..c1e9918f9dd4 100644
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
-		skip = !set_pageblock_skip(page);
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
@@ -991,6 +961,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
 
+		/* Indicate that we want exclusive access to this pageblock */
+		if (page == valid_page) {
+			skip_updated = true;
+			if (!cc->ignore_skip_hint)
+				set_pageblock_skip(page);
+		}
+
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!lruvec || !lruvec_holds_page_lru_lock(page, lruvec)) {
 			if (lruvec)
@@ -1002,13 +979,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
 
 			lruvec_memcg_debug(lruvec, page);
 
-			/* Try get exclusive access under lock */
-			if (!skip_updated) {
-				skip_updated = true;
-				if (test_and_set_skip(cc, page, low_pfn))
-					goto isolate_abort;
-			}
-
 			/*
 			 * Page become compound since the non-locked check,
 			 * and it's on LRU. It can only be a THP so the order
@@ -1094,15 +1064,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
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


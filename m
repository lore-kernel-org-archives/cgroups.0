From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 3/3] mm: Identify compound pages sooner in
 isolate_migratepages_block
Date: Wed, 12 Aug 2020 21:02:40 -0700
Message-ID: <20200813040240.13054.76770.stgit@localhost.localdomain>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=w5SvE1fHI6P73p4d/Ave7K8xWurioQmoju2x6tyh2NI=;
        b=c4tk2gd6nfdYlP84ldnqXqtP9SL2coSrqYEmasUe0gQZjJ9C0qFxsRqvyD5YIjTIIy
         xy++8GAuvZBRqgofWHFgrqTguHhoglS5fxYbhD3S3hvBiiusYCIulc73UJJpWoRXNx2H
         naAhGT9cveMS7FMK01PpSjGi/n3QaC/mEfygXXhEM5Ry8Cm/3wlooFXW+una3QuRDRkO
         mLIxbRvO8+xXgT5VxrkpJtiEL35TzuV2kQ8SfPbcM+nYBVtnVWPF1th3BoG4zc3dclcI
         OjI3eBp5/pnZOyMFt7I5xh0/XNv+Sgy2qAVnFDvmydFQk9kFsCcJFfQhriOYNWzDDbvG
         k18Q==
In-Reply-To: <20200813035100.13054.25671.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Since we are holding a reference to the page much sooner in
isolate_migratepages_block we could move the PageCompound check out of the
LRU locked section and instead just place it after get_page_unless_zero. By
doing this we can allow any of the items that might trigger a failure to
trigger a failure for the compound page rather than the order 0 page and as
a result we should be able to process the pageblock faster.

In addition by testing for PageCompound sooner we can avoid having the LRU
flag cleared and then reset in the exception case. As a result this should
prevent any possible races where another thread might be attempting to pull
the LRU pages from the list.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/compaction.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index c1e9918f9dd4..3803f129fd6a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -954,6 +954,24 @@ static bool too_many_isolated(pg_data_t *pgdat)
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
 
@@ -978,23 +996,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			rcu_read_unlock();
 
 			lruvec_memcg_debug(lruvec, page);
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


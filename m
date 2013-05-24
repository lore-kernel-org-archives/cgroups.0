From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v8 22/34] hugepage: convert huge zero page shrinker to new shrinker API
Date: Fri, 24 May 2013 15:59:16 +0530
Message-ID: <1369391368-31562-23-git-send-email-glommer@openvz.org>
References: <1369391368-31562-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369391368-31562-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It consists of:

* returning long instead of int
* separating count from scan
* returning the number of freed entities in scan

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/huge_memory.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5f2fa1..3a0eda8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -211,24 +211,29 @@ static void put_huge_zero_page(void)
 	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
-static int shrink_huge_zero_page(struct shrinker *shrink,
-		struct shrink_control *sc)
+static long shrink_huge_zero_page_count(struct shrinker *shrink,
+					struct shrink_control *sc)
 {
-	if (!sc->nr_to_scan)
-		/* we can free zero page only if last reference remains */
-		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+	/* we can free zero page only if last reference remains */
+	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+}
 
+static long shrink_huge_zero_page_scan(struct shrinker *shrink,
+				       struct shrink_control *sc)
+{
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
 		__free_page(zero_page);
+		return HPAGE_PMD_NR;
 	}
 
 	return 0;
 }
 
 static struct shrinker huge_zero_page_shrinker = {
-	.shrink = shrink_huge_zero_page,
+	.count_objects = shrink_huge_zero_page_count,
+	.scan_objects = shrink_huge_zero_page_scan,
 	.seeks = DEFAULT_SEEKS,
 };
 
-- 
1.8.1.4

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 08:16:07 -0700
Message-ID: <20211014151607.2171970-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8lwRp3uP8+IKYysxWAf8gbvxjj8gBa/nFz3RxTvcuPo=;
        b=oJGw/QMmi9y17ZRzapZ6AW2NqjA67q2aRYewaRrOpIgd5leninbEz/X70fFAv2Tkyr
         tK4schSZy5xEATUYHCSx4ertgr+8G6lysBxuYmHYCKm01igmwtPNBZL10n9vtUHVoceC
         O7oUkdYT3NMshazQZbMIaGQsREoQuo5eao+1Z3zZ0z6M7E7FFD2JSQobCOQqG6y+Un5y
         XTzKDHVN9DkIcxjf9l3ztuNBu5zq+mMErnq7BEW+9GDjPOdw2fBMz1p4RTBFrTeVi6u8
         Q0sR/ABZD6FSDzNrx4/Hw2+/7E/qpUZ+2z90EwCVBL3U9JP9G7tL22uJ7LCj3EiyYaFS
         VNPg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The commit 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in
__vmalloc_area_node()") switched to bulk page allocator for order 0
allocation backing vmalloc. However bulk page allocator does not support
__GFP_ACCOUNT allocations and there are several users of
kvmalloc(__GFP_ACCOUNT).

For now make __GFP_ACCOUNT allocations bypass bulk page allocator. In
future if there is workload that can be significantly improved with the
bulk page allocator with __GFP_ACCCOUNT support, we can revisit the
decision.

Fixes: 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()")
Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Changes since v1:
- do fallback allocation instead of failure, suggested by Michal Hocko.
- Added memcg_kmem_enabled() check, corrected by Vasily Averin

 mm/page_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 668edb16446a..9ca871dc8602 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5230,6 +5230,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	if (unlikely(page_array && nr_pages - nr_populated == 0))
 		goto out;
 
+	/* Bulk allocator does not support memcg accounting. */
+	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT))
+		goto failed;
+
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)
 		goto failed;
-- 
2.33.0.882.g93a45727a2-goog


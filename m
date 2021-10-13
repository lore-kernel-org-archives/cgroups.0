From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Wed, 13 Oct 2021 12:43:38 -0700
Message-ID: <20211013194338.1804247-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=183/Dmjt3t68g4lFUKc/z0kQhgqiT+FGVOpT95Nq0kM=;
        b=OdGvP6ktVCKze2jdgpC/LCWFtjsxfSQgs7UTA6ebaiBpzoW1WqKoiQuVcC1bpMOVCC
         i8KclRSPtGW5OeUbj5IuaiJMHVf+Aez8zx2pNI57ISq82CQEZoyEfTvyVn69C7OEgxcq
         gYafOMRueWW7YY9aES2dtBfRhYz2FKebug+0VXHFfQQmiSeBII857IcocA5kBECykSGf
         2GkjXZ6uaf8Cfr/+DRwDyeZ8LEcsNG7p5vjscSWG25J6V8xiOkH3N4tw4bBj2JybPT+T
         C0YERN2BSBkhnSnncR/BTcYXjo3x6SnZTPdlui6ZcHcyYMBORDh8TxIwvTdhaGjJnzNF
         J4Yw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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
 mm/page_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 668edb16446a..b3acad4615d3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5215,6 +5215,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
+	/* Bulk allocator does not support memcg accounting. */
+	if (unlikely(gfp & __GFP_ACCOUNT))
+		goto out;
+
 	/*
 	 * Skip populated array elements to determine if any pages need
 	 * to be allocated before disabling IRQs.
-- 
2.33.0.882.g93a45727a2-goog


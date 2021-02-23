From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: fix slub memory accounting
Date: Tue, 23 Feb 2021 17:24:23 +0800
Message-ID: <20210223092423.42420-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mu2c4DZ3wSvp2hWIYY8iGN/5x9vHcWAfw9ARv3kyqaM=;
        b=LO30HGhJEEoDclp09pG3Zhuhe4o587oo39dmuNomrLg61H6NzuMkL0xL1vBoOKFkuy
         s5wFOFudC2zzK0/9HCBgmyHk5dt3QNNyE0FvMB/0LHRZjtr3OfC/Jda4G713nBDXbkUw
         DsvahiAtdD1q5HImPQ1tnNyvxxDLAp8akFgugDk60PJQJGTk185uuHOcXRA4aZBl2gDS
         hMOS3C/AZ20hOPMt7eW25LMJz7bQNwRsbBIeLbNVU7Ct3lFZ1nK7RpS847vlMYKXsgTd
         8L0GHFjCVFxsl4ObqTHMsj1/xeCdD5wC1ADe1TFzPuwQvd5lHI3iYz0HRPZIOOWXpq5K
         i2rA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

SLUB currently account kmalloc() and kmalloc_node() allocations larger
than order-1 page per-node. But it forget to update the per-memcg
vmstats. So it can lead to inaccurate statistics of "slab_unreclaimable"
which is from memory.stat. Fix it by using mod_lruvec_page_state instead
of mod_node_page_state.

Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/slab_common.c | 4 ++--
 mm/slub.c        | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 821f657d38b5..20ffb2b37058 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -906,8 +906,8 @@ void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 	page = alloc_pages(flags, order);
 	if (likely(page)) {
 		ret = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    PAGE_SIZE << order);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      PAGE_SIZE << order);
 	}
 	ret = kasan_kmalloc_large(ret, size, flags);
 	/* As ret might get tagged, call kmemleak hook after KASAN. */
diff --git a/mm/slub.c b/mm/slub.c
index e564008c2329..f2f953de456e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4057,8 +4057,8 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 	page = alloc_pages_node(node, flags, order);
 	if (page) {
 		ptr = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    PAGE_SIZE << order);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      PAGE_SIZE << order);
 	}
 
 	return kmalloc_large_node_hook(ptr, size, flags);
@@ -4193,8 +4193,8 @@ void kfree(const void *x)
 
 		BUG_ON(!PageCompound(page));
 		kfree_hook(object);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    -(PAGE_SIZE << order));
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      -(PAGE_SIZE << order));
 		__free_pages(page, order);
 		return;
 	}
-- 
2.11.0


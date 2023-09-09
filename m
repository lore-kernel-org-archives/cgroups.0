From: Xin Hao <haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: memcg: add THP swap out info for anonymous reclaim
Date: Sat,  9 Sep 2023 23:52:41 +0800
Message-ID: <20230909155242.22767-1-vernhao@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694274771; x=1694879571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fgpa7ePPXDf81q5q2R0+qC0wZ59LoDUqcXyRaIm3KfE=;
        b=a2EtqDj0feMdhivyTEMi3UkoWCVwvdJux7/mjhCaknL0lZvZUR7SgSxz9VQMadR7AV
         dyzGa/PKGhPfrRGv0KhDFnEemyolJt0d7j7yJh4RYxz4QB0Yf2Mb8RTdcFHBBJs0JS/I
         jLR8ACm69RNRxSitOos/81qsDSFGe6Rljlc1LPgBllBB+UoEyTmbQcsuAo5LiRszVJNG
         0lVrxfMzVcdRRKgiQ66SusiMAm19GDVkBFbGKOw83zd9uZiqNeV5AXo3wjfGqR8kySFq
         /p7Ij9uKdrjq6JrRakUSg51dC17hSq/fNDjMdyeCYDzlM73tPiS55+u/eHWivdVKSwYV
         6NAw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

At present, we support per-memcg reclaim strategy, however we do not
know the number of transparent huge pages being reclaimed, as we know
the transparent huge pages need to be splited before reclaim them, and
they will bring some performance bottleneck effect. for example, when
two memcg (A & B) are doing reclaim for anonymous pages at same time,
and 'A' memcg is reclaiming a large number of transparent huge pages, we
can better analyze that the performance bottleneck will be caused by 'A'
memcg.  therefore, in order to better analyze such problems, there add
THP swap out info for per-memcg.

Signed-off-by: Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 mm/memcontrol.c | 6 ++++++
 mm/page_io.c    | 4 +++-
 mm/vmscan.c     | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ecc07b47e813..a644f601e2ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -752,6 +752,8 @@ static const unsigned int memcg_vm_event_stat[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
 	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
 #endif
 };
 
@@ -4131,6 +4133,10 @@ static const unsigned int memcg1_events[] = {
 	PGPGOUT,
 	PGFAULT,
 	PGMAJFAULT,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
+#endif
 };
 
 static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
diff --git a/mm/page_io.c b/mm/page_io.c
index fe4c21af23f2..008ada2e024a 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,8 +208,10 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio)))
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_events(folio_memcg(folio), THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
+	}
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ea57a43ebd6b..29a82b72345a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1928,6 +1928,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_events(folio_memcg(folio),
+							   THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
-- 
2.42.0


From: Vern Hao <haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] mm: memcg: add THP swap out info for anonymous reclaim
Date: Thu, 14 Sep 2023 00:49:37 +0800
Message-ID: <20230913164938.16918-1-vernhao@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694623787; x=1695228587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=08hV17UrGwqSsOU/Pj3BP46JQZzZQz8kR1HYrZEWtOg=;
        b=Uvk3EXHB4F1Wel64AQWHSstm1WwyAzHkxqerazJ3z69W5Dq2pRdsMzfrn//NACTGCQ
         f5PwdB2pb1IvxrAePz0VQEMwy51nhIqaRdqqfBQtFdJ8IviQFSLrbO6QwqSF2mz9q88V
         zzHixbz7igLOamF+/crLXQ9DP6HfhVTtrBiRmd0w0DGT+M/fZYORfDItVUP1gs3MhLVg
         lwrYqRbQCrP2Pggq51zTU8+wXU8g6a5KahY4WBr/mZkvy8MgtTJ/k/U2g6WR+whXqky/
         bVjZoBNv6CkrXf6nwm1phc98d/5kvlPqghJs9U4MifD93AhO1IajyDVlwYzsXtX3R7Ch
         gTNA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

At present, we support per-memcg reclaim strategy, however we do not
know the number of transparent huge pages being reclaimed, as we know
the transparent huge pages need to be splited before reclaim them, and
they will bring some performance bottleneck effect. for example, when
two memcg (A & B) are doing reclaim for anonymous pages at same time,
and 'A' memcg is reclaiming a large number of transparent huge pages, we
can better analyze that the performance bottleneck will be caused by 'A'
memcg.  therefore, in order to better analyze such problems, there add
THP swap out info for per-memcg.

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
v2 -> v3
	- Do little fix as Johannes Weiner suggestion.
	- add 'thp_swpout' and 'thp_swpout_fallback' to Documentation/admin-guide/cgroup-v2.rst
v1 -> v2
	- Do some fix as Johannes Weiner suggestion.
v2:
https://lore.kernel.org/linux-mm/20230912021727.61601-1-vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org/
v1: 
https://lore.kernel.org/linux-mm/20230911160824.GB103342-druUgvl0LCNAfugRpC6u6w@public.gmane.org/T/

 Documentation/admin-guide/cgroup-v2.rst | 9 +++++++++
 mm/memcontrol.c                         | 2 ++
 mm/page_io.c                            | 8 ++++----
 mm/vmscan.c                             | 1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b26b5274eaaf..622a7f28db1f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1532,6 +1532,15 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+	  thp_swpout (npn)
+		Number of transparent hugepages which are swapout in one piece
+		without splitting.
+
+	  thp_swpout_fallback (npn)
+		Number of transparent hugepages which were split before swapout.
+		Usually because failed to allocate some continuous swap space
+		for the huge page.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 811491b99e3e..9f84b3f7b469 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -704,6 +704,8 @@ static const unsigned int memcg_vm_event_stat[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
 	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
 #endif
 };
 
diff --git a/mm/page_io.c b/mm/page_io.c
index fe4c21af23f2..7cf358158cf1 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,8 +208,10 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio)))
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
+	}
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
@@ -278,9 +280,6 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else {
-		for (p = 0; p < sio->pages; p++)
-			count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	}
 
 	for (p = 0; p < sio->pages; p++)
@@ -296,6 +295,7 @@ static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);
 
+	count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 00b24c3b2b04..661615fa709b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1227,6 +1227,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
-- 
2.42.0


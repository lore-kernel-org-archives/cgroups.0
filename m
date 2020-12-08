From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v3 3/7] mm: memcontrol: convert NR_FILE_THPS account to pages
Date: Tue,  8 Dec 2020 12:18:43 +0800
Message-ID: <20201208041847.72122-4-songmuchun@bytedance.com>
References: <20201208041847.72122-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KuLT1Cn/hR9CSFlVwhhGNLVEez8vLOWizoZNvv9uxQ=;
        b=Vj4JJ+bRYX5Oj4q3X0L8Fh6Gls+2B/SXWUh4NrNW72Aqtu/BDQ3boPiqVkNwJDDs44
         IS3iz2hn5UDA/kWICAwIBPkt4krmzbzPFMuds4SgvUdlbQrGw5lcfKEIzVcwjOkdDpvf
         MB9rfJai8zIHC6WAzQqjJkCfaHNqZ+5uZENHhIpzcRNXNz/jr43WQzYkJ/SWQmdywRja
         BZ0ty40DqI2t0ZHO1DDDbT0H6eJOJ/rngA3c0K6mew7YyX6o+71G5ojMNfh7mY9TZaWW
         v6P3wbNlykFS+3tfjxMhGQCfsJBYhy4PDAg3pKBNPZXNazNDcahRsjjIQZeEZNzkfuht
         l2HQ==
In-Reply-To: <20201208041847.72122-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The unit of NR_FILE_THPS is HPAGE_PMD_NR. Converrt NR_FILE_THPS
account to pages.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 drivers/base/node.c | 3 +--
 fs/proc/meminfo.c   | 2 +-
 mm/filemap.c        | 2 +-
 mm/huge_memory.c    | 3 ++-
 mm/khugepaged.c     | 2 +-
 mm/memcontrol.c     | 5 ++---
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index ec35cb567940..0f752d0fce6f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -466,8 +466,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 				    HPAGE_PMD_NR),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
 				    HPAGE_PMD_NR),
-			     nid, K(node_page_state(pgdat, NR_FILE_THPS) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
 			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED) *
 				    HPAGE_PMD_NR)
 #endif
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index a635c8a84ddf..7ea4679880c8 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -135,7 +135,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "ShmemPmdMapped: ",
 		    global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR);
 	show_val_kb(m, "FileHugePages:  ",
-		    global_node_page_state(NR_FILE_THPS) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_FILE_THPS));
 	show_val_kb(m, "FilePmdMapped:  ",
 		    global_node_page_state(NR_FILE_PMDMAPPED) * HPAGE_PMD_NR);
 #endif
diff --git a/mm/filemap.c b/mm/filemap.c
index 78090ee08ac2..9cc8b3ac9eac 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -207,7 +207,7 @@ static void unaccount_page_cache_page(struct address_space *mapping,
 		if (PageTransHuge(page))
 			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
 	} else if (PageTransHuge(page)) {
-		__dec_lruvec_page_state(page, NR_FILE_THPS);
+		__mod_lruvec_page_state(page, NR_FILE_THPS, -HPAGE_PMD_NR);
 		filemap_nr_thps_dec(mapping);
 	}
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 66ec454120de..1e24165fa53a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2748,7 +2748,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 			if (PageSwapBacked(head))
 				__dec_lruvec_page_state(head, NR_SHMEM_THPS);
 			else
-				__dec_lruvec_page_state(head, NR_FILE_THPS);
+				__mod_lruvec_page_state(head, NR_FILE_THPS,
+							-HPAGE_PMD_NR);
 		}
 
 		__split_huge_page(page, list, end);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 494d3cb0b58a..76b3e064a72a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1869,7 +1869,7 @@ static void collapse_file(struct mm_struct *mm,
 	if (is_shmem)
 		__inc_lruvec_page_state(new_page, NR_SHMEM_THPS);
 	else {
-		__inc_lruvec_page_state(new_page, NR_FILE_THPS);
+		__mod_lruvec_page_state(new_page, NR_FILE_THPS, HPAGE_PMD_NR);
 		filemap_nr_thps_inc(mapping);
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b18e25a5cdf3..04985c8c6a0a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1533,7 +1533,7 @@ static struct memory_stat memory_stats[] = {
 	 * constant(e.g. powerpc).
 	 */
 	{ "anon_thp", PAGE_SIZE, NR_ANON_THPS },
-	{ "file_thp", 0, NR_FILE_THPS },
+	{ "file_thp", PAGE_SIZE, NR_FILE_THPS },
 	{ "shmem_thp", 0, NR_SHMEM_THPS },
 #endif
 	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
@@ -1565,8 +1565,7 @@ static int __init memory_stats_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_FILE_THPS ||
-		    memory_stats[i].idx == NR_SHMEM_THPS)
+		if (memory_stats[i].idx == NR_SHMEM_THPS)
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
 #endif
 		VM_BUG_ON(!memory_stats[i].ratio);
-- 
2.11.0


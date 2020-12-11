From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 5/7] mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
Date: Fri, 11 Dec 2020 12:19:52 +0800
Message-ID: <20201211041954.79543-6-songmuchun@bytedance.com>
References: <20201211041954.79543-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GQUFW73mdqeVNnWmOCUXrriPRd8OoQbYZkReps7lWmE=;
        b=IjskIXxMWCN/ytFBKw+DiAXxwBYCNKF8JYU6iVwQmlV4cOw6vNaY1P3GrQ1tyoaM9Y
         LGNX7hCXCHbchH5rP4RRe4V9p2J6KNK5d+n6pNqTcWLgaQl5e6zgcFFXn26pC5V98oKH
         ChD3XxNRpjpFKsRgxoWhrRl3CJzYll1nkGHxrs8VD5kbyoR5RDageIyV/Pdrr5APQ0Hm
         fD0x2O/ifiMYM1Ztriz5/eDvN9WjdQ6SYLXPN14x7R2j3v8AGb3gRuChTUYnqUWV0/pV
         KX51x3M9Zsv6f1MvSNxvn/1/c4Y4CM9Ne7pKYum2xNsYxOizOxI1ztLeDsH6gWgq/tEu
         EYfg==
In-Reply-To: <20201211041954.79543-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The unit of NR_SHMEM_PMDMAPPED is HPAGE_PMD_NR. Convert NR_SHMEM_PMDMAPPED
account to pages.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 drivers/base/node.c    | 3 +--
 fs/proc/meminfo.c      | 2 +-
 include/linux/mmzone.h | 3 ++-
 mm/page_alloc.c        | 3 +--
 mm/rmap.c              | 6 ++++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 6d5ac6ffb6e1..7a66aefe4e46 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -463,8 +463,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     ,
 			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS)),
-			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
 			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED) *
 				    HPAGE_PMD_NR)
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index cfb107eaa3e6..c61f440570f9 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -133,7 +133,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "ShmemHugePages: ",
 		    global_node_page_state(NR_SHMEM_THPS));
 	show_val_kb(m, "ShmemPmdMapped: ",
-		    global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_SHMEM_PMDMAPPED));
 	show_val_kb(m, "FileHugePages:  ",
 		    global_node_page_state(NR_FILE_THPS));
 	show_val_kb(m, "FilePmdMapped:  ",
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4f49af38dced..d6b13b9327be 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -217,7 +217,8 @@ static __always_inline bool vmstat_item_print_in_thp(enum node_stat_item item)
 {
 	return item == NR_ANON_THPS ||
 	       item == NR_FILE_THPS ||
-	       item == NR_SHMEM_THPS;
+	       item == NR_SHMEM_THPS ||
+	       item == NR_SHMEM_PMDMAPPED;
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 720fb5a220b6..575fbfeea4b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5578,8 +5578,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			K(node_page_state(pgdat, NR_SHMEM)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			K(node_page_state(pgdat, NR_SHMEM_THPS)),
-			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
-					* HPAGE_PMD_NR),
+			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			K(node_page_state(pgdat, NR_ANON_THPS)),
 #endif
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
diff --git a/mm/rmap.c b/mm/rmap.c
index f59e92e26b61..3089ad6bf468 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1219,7 +1219,8 @@ void page_add_file_rmap(struct page *page, bool compound)
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
 		if (PageSwapBacked(page))
-			__inc_node_page_state(page, NR_SHMEM_PMDMAPPED);
+			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
+						HPAGE_PMD_NR);
 		else
 			__inc_node_page_state(page, NR_FILE_PMDMAPPED);
 	} else {
@@ -1260,7 +1261,8 @@ static void page_remove_file_rmap(struct page *page, bool compound)
 		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
 			return;
 		if (PageSwapBacked(page))
-			__dec_node_page_state(page, NR_SHMEM_PMDMAPPED);
+			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
+						-HPAGE_PMD_NR);
 		else
 			__dec_node_page_state(page, NR_FILE_PMDMAPPED);
 	} else {
-- 
2.11.0


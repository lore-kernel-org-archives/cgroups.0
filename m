From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: memcontrol: provide shmem statistics
Date: Tue, 21 Feb 2017 11:43:43 -0500
Message-ID: <20170221164343.32252-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KfTk/h9m/fFazPEA/JqQLB3angMS+ZfJw1CUb0RwODo=; b=rr48EfJCUp8auzm59LYl1+BWcT
	lfcAh4KwqERwXCcpaBfovzwdY5ku+6OOGFvtRtfy2lOcRT5ZGRNvLG23/XgJmOK5lR92sZ6gtgy77
	ZQoLmYy90btaEj59r7WuDKeS5+Cf8dSVnsoRrhOZBemqSxlcwUfaevmUj9M3b6SDiqhs=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov.dev@gmail.com>, Chris Down <cdown@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Cgroups currently don't report how much shmem they use, which can be
useful data to have, in particular since shmem is included in the
cache/file item while being reclaimed like anonymous memory.

Add a counter to track shmem pages during charging and uncharging.

Reported-by: Chris Down <cdown@fb.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroup-v2.txt |  5 +++++
 include/linux/memcontrol.h  |  1 +
 mm/memcontrol.c             | 28 ++++++++++++++++++++--------
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 4cc07ce3b8dd..d99389ce7b01 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -867,6 +867,11 @@ PAGE_SIZE multiple when read back.
 
 		Amount of memory used in network transmission buffers
 
+	  shmem
+
+		Amount of cached filesystem data that is swap-backed,
+		such as tmpfs, shm segments, shared anonymous mmap()s
+
 	  file_mapped
 
 		Amount of cached filesystem data mapped with mmap()
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 61d20c17f3b7..47bdf727d1ad 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -46,6 +46,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_CACHE,		/* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,		/* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_RSS_HUGE,	/* # of pages charged as anon huge */
+	MEM_CGROUP_STAT_SHMEM,		/* # of pages charged as shmem */
 	MEM_CGROUP_STAT_FILE_MAPPED,	/* # of pages charged as file rss */
 	MEM_CGROUP_STAT_DIRTY,          /* # of dirty pages in page cache */
 	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9c9cde768d40..49409f5c0238 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -102,6 +102,7 @@ static const char * const mem_cgroup_stat_names[] = {
 	"cache",
 	"rss",
 	"rss_huge",
+	"shmem",
 	"mapped_file",
 	"dirty",
 	"writeback",
@@ -601,9 +602,13 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	if (PageAnon(page))
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
 				nr_pages);
-	else
+	else {
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
+		if (PageSwapBacked(page))
+			__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SHMEM],
+				       nr_pages);
+	}
 
 	if (compound) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -5200,6 +5205,8 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	seq_printf(m, "sock %llu\n",
 		   (u64)stat[MEMCG_SOCK] * PAGE_SIZE);
 
+	seq_printf(m, "shmem %llu\n",
+		   (u64)stat[MEM_CGROUP_STAT_SHMEM] * PAGE_SIZE);
 	seq_printf(m, "file_mapped %llu\n",
 		   (u64)stat[MEM_CGROUP_STAT_FILE_MAPPED] * PAGE_SIZE);
 	seq_printf(m, "file_dirty %llu\n",
@@ -5468,8 +5475,8 @@ void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg,
 
 static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_anon, unsigned long nr_file,
-			   unsigned long nr_huge, unsigned long nr_kmem,
-			   struct page *dummy_page)
+			   unsigned long nr_kmem, unsigned long nr_huge,
+			   unsigned long nr_shmem, struct page *dummy_page)
 {
 	unsigned long nr_pages = nr_anon + nr_file + nr_kmem;
 	unsigned long flags;
@@ -5487,6 +5494,7 @@ static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS], nr_anon);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_CACHE], nr_file);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE], nr_huge);
+	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_SHMEM], nr_shmem);
 	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT], pgpgout);
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
 	memcg_check_events(memcg, dummy_page);
@@ -5499,6 +5507,7 @@ static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 static void uncharge_list(struct list_head *page_list)
 {
 	struct mem_cgroup *memcg = NULL;
+	unsigned long nr_shmem = 0;
 	unsigned long nr_anon = 0;
 	unsigned long nr_file = 0;
 	unsigned long nr_huge = 0;
@@ -5531,9 +5540,9 @@ static void uncharge_list(struct list_head *page_list)
 		if (memcg != page->mem_cgroup) {
 			if (memcg) {
 				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-					       nr_huge, nr_kmem, page);
-				pgpgout = nr_anon = nr_file =
-					nr_huge = nr_kmem = 0;
+					       nr_kmem, nr_huge, nr_shmem, page);
+				pgpgout = nr_anon = nr_file = nr_kmem = 0;
+				nr_huge = nr_shmem = 0;
 			}
 			memcg = page->mem_cgroup;
 		}
@@ -5547,8 +5556,11 @@ static void uncharge_list(struct list_head *page_list)
 			}
 			if (PageAnon(page))
 				nr_anon += nr_pages;
-			else
+			else {
 				nr_file += nr_pages;
+				if (PageSwapBacked(page))
+					nr_shmem += nr_pages;
+			}
 			pgpgout++;
 		} else {
 			nr_kmem += 1 << compound_order(page);
@@ -5560,7 +5572,7 @@ static void uncharge_list(struct list_head *page_list)
 
 	if (memcg)
 		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-			       nr_huge, nr_kmem, page);
+			       nr_kmem, nr_huge, nr_shmem, page);
 }
 
 /**
-- 
2.11.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

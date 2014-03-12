From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 2/8] mm: memcg: remove mem_cgroup_move_account_page_stat()
Date: Tue, 11 Mar 2014 21:28:28 -0400
Message-ID: <1394587714-6966-3-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=6wfNG8DwPmS9lK2y9++z6h1wEdioYxRwgR30d3Jco2k=;
	b=VuLYa+3EFxGS4t2k38GeDQ+Y5rhSqAC6S3/aLodk2dfeCRVgtHawJgcOMZxm9NlIVt6rbhzQZPC4q3MkNLxUx1VajNr5bW+fme4mg/ihN0UGFLK2QDFEknID97gTN77KsFH5Kxtw3Fib6Z1bxJ3QfjGbGAtlMrLBm6j1lSoyFRY=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

It used to disable preemption and run sanity checks but now it's only
taking a number out of one percpu counter and putting it into another.
Do this directly in the callsite and save the indirection.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 393864c162ac..5abdfab957ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3776,16 +3776,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
-					      struct mem_cgroup *to,
-					      unsigned int nr_pages,
-					      enum mem_cgroup_stat_index idx)
-{
-	/* Update stat data for mem_cgroup */
-	__this_cpu_sub(from->stat->count[idx], nr_pages);
-	__this_cpu_add(to->stat->count[idx], nr_pages);
-}
-
 /**
  * mem_cgroup_move_account - move account of the page
  * @page: the page
@@ -3831,13 +3821,19 @@ static int mem_cgroup_move_account(struct page *page,
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (!anon && page_mapped(page))
-		mem_cgroup_move_account_page_stat(from, to, nr_pages,
-			MEM_CGROUP_STAT_FILE_MAPPED);
+	if (!anon && page_mapped(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       nr_pages);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       nr_pages);
+	}
 
-	if (PageWriteback(page))
-		mem_cgroup_move_account_page_stat(from, to, nr_pages,
-			MEM_CGROUP_STAT_WRITEBACK);
+	if (PageWriteback(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
+			       nr_pages);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
+			       nr_pages);
+	}
 
 	mem_cgroup_charge_statistics(from, page, anon, -nr_pages);
 
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

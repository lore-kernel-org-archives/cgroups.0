From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: memcontrol: clarify migration where old page is uncharged
Date: Sun, 19 Oct 2014 11:30:47 -0400
Message-ID: <1413732647-16043-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Better explain re-entrant migration when compaction races with
reclaim, and also mention swapcache readahead pages as possible
uncharged migration sources.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fc1d7ca96b9d..76892eb89d26 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6166,7 +6166,12 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 	if (PageCgroupUsed(pc))
 		return;
 
-	/* Re-entrant migration: old page already uncharged? */
+	/*
+	 * Swapcache readahead pages can get migrated before being
+	 * charged, and migration from compaction can happen to an
+	 * uncharged page when the PFN walker finds a page that
+	 * reclaim just put back on the LRU but has not released yet.
+	 */
 	pc = lookup_page_cgroup(oldpage);
 	if (!PageCgroupUsed(pc))
 		return;
-- 
2.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

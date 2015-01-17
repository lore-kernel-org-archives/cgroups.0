From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: memcontrol: default hierarchy interface for memory fix - high reclaim
Date: Sat, 17 Jan 2015 10:21:19 -0500
Message-ID: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

High limit reclaim can currently overscan in proportion to how many
charges are happening concurrently.  Tone it down such that charges
don't target the entire high-boundary excess, but instead only the
pages they charged themselves when excess is detected.

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 323a01fa1833..7adccee9fecb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2348,19 +2348,13 @@ done_restock:
 		refill_stock(memcg, batch - nr_pages);
 	/*
 	 * If the hierarchy is above the normal consumption range,
-	 * make the charging task trim the excess.
+	 * make the charging task trim their excess contribution.
 	 */
 	do {
-		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long high = ACCESS_ONCE(memcg->high);
-
-		if (nr_pages > high) {
-			mem_cgroup_events(memcg, MEMCG_HIGH, 1);
-
-			try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-						     gfp_mask, true);
-		}
-
+		if (page_counter_read(&memcg->memory) <= memcg->high)
+			continue;
+		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
+		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 done:
 	return ret;
-- 
2.2.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

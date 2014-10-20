From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 3/4] mm: memcontrol: remove unnecessary PCG_MEM memory charge flag
Date: Mon, 20 Oct 2014 11:22:11 -0400
Message-ID: <1413818532-11042-4-git-send-email-hannes@cmpxchg.org>
References: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

PCG_MEM is a remnant from an earlier version of 0a31bc97c80c ("mm:
memcontrol: rewrite uncharge API"), used to tell whether migration
cleared a charge while leaving pc->mem_cgroup valid and PCG_USED set.
But in the final version, mem_cgroup_migrate() directly uncharges the
source page, rendering this distinction unnecessary.  Remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/page_cgroup.h | 1 -
 mm/memcontrol.c             | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index da62ee2be28b..97536e685843 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -4,7 +4,6 @@
 enum {
 	/* flags for mem_cgroup */
 	PCG_USED = 0x01,	/* This page is charged to a memcg */
-	PCG_MEM = 0x02,		/* This page holds a memory charge */
 };
 
 struct pglist_data;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9bab35fc3e9e..1d66ac49e702 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2606,7 +2606,7 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED | PCG_MEM;
+	pc->flags = PCG_USED;
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
@@ -6177,8 +6177,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 	if (!PageCgroupUsed(pc))
 		return;
 
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
-
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
 
-- 
2.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 11/13] mm: memcontrol: do not acquire page_cgroup lock for kmem pages
Date: Wed, 18 Jun 2014 16:40:43 -0400
Message-ID: <1403124045-24361-12-git-send-email-hannes@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=x6RC+zv14ieS8uZCmB7bHFuUbDhd4IG91jp7Ow+1L4c=;
	b=R1EZmbEdY4vaMdh7p5YiP1279mPbUqDwixlufKUjCYB2RIwraoylccXWAffp6x0O8APFwDTkUOuW/3t6zwadfTQvujeOcbZUqqpe4NvHeQvqtwxrg446qe+4afJ/BNjYPnsIdH+LjIJMgV4GUrxxkD4HF6MhUtU88B3gHMohETw=;
In-Reply-To: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Kmem page charging and uncharging is serialized by means of exclusive
access to the page.  Do not take the page_cgroup lock and don't set
pc->flags atomically.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 199bd50359ad..5e7f8e7dc0d8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3407,12 +3407,13 @@ void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
 		memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 		return;
 	}
-
+	/*
+	 * The page is freshly allocated and not visible to any
+	 * outside callers yet.  Set up pc non-atomically.
+	 */
 	pc = lookup_page_cgroup(page);
-	lock_page_cgroup(pc);
 	pc->mem_cgroup = memcg;
-	SetPageCgroupUsed(pc);
-	unlock_page_cgroup(pc);
+	pc->flags = PCG_USED;
 }
 
 void __memcg_kmem_uncharge_pages(struct page *page, int order)
@@ -3422,19 +3423,11 @@ void __memcg_kmem_uncharge_pages(struct page *page, int order)
 
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * Fast unlocked return. Theoretically might have changed, have to
-	 * check again after locking.
-	 */
 	if (!PageCgroupUsed(pc))
 		return;
 
-	lock_page_cgroup(pc);
-	if (PageCgroupUsed(pc)) {
-		memcg = pc->mem_cgroup;
-		ClearPageCgroupUsed(pc);
-	}
-	unlock_page_cgroup(pc);
+	memcg = pc->mem_cgroup;
+	pc->flags = 0;
 
 	/*
 	 * We trust that only if there is a memcg associated with the page, it
-- 
2.0.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

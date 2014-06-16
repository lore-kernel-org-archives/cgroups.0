From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 10/12] mm: memcontrol: do not acquire page_cgroup lock for kmem pages
Date: Mon, 16 Jun 2014 15:54:30 -0400
Message-ID: <1402948472-8175-11-git-send-email-hannes@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=gjnNyz9/JVyRjZZZJnFsxea5JGWUOn4+JR4Gl1nKUXM=;
	b=qfHN3kE1Lx2FF5ux7bhU5CIEj9IzQnOOdTmG2IjVzHkBLjWgr4lxq61AGhlhdb2nTeX4L+Kc57IQ+earaWkZek8kFKTYv9r13J5AAG6c2moZ+2tTp3gb9E3VKq9DCWu9VtHnBqex9LsD/3vpepvrpCWqux++iX5nMpzgg+5XzCw=;
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

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
index 1cde6e2b33d9..764e182ccde3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3414,12 +3414,13 @@ void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
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
@@ -3429,19 +3430,11 @@ void __memcg_kmem_uncharge_pages(struct page *page, int order)
 
 
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

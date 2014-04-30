From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 7/9] mm: memcontrol: do not acquire page_cgroup lock for kmem pages
Date: Wed, 30 Apr 2014 16:25:41 -0400
Message-ID: <1398889543-23671-8-git-send-email-hannes@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=YuqAcGvqgsnNAyrkqym16OkJrR0+VYQoFT2PXVe+ae8=;
	b=Cap3gM1lflBM/LOzIFsVBaBmveJYAjBXbfvBkIfdzs6QZECJ25MtB7P6TeJ5FVTmLShv8+h6xOO+KH95mVp1Re0iL0p2w1F4bU/8KvmQAOMIk192mlHe0skN5fo41ayvH6brCgMttPe5uVT7vV4J0+zU2nRQycXbdljxDTfI3C0=;
In-Reply-To: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Kmem page charging and uncharging is serialized by means of exclusive
access to the page.  Do not take the page_cgroup lock and don't set
pc->flags atomically.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c528ae9ac230..d3961fce1d54 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3535,10 +3535,8 @@ void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
 	}
 
 	pc = lookup_page_cgroup(page);
-	lock_page_cgroup(pc);
 	pc->mem_cgroup = memcg;
-	SetPageCgroupUsed(pc);
-	unlock_page_cgroup(pc);
+	pc->flags = PCG_USED;
 }
 
 void __memcg_kmem_uncharge_pages(struct page *page, int order)
@@ -3548,19 +3546,11 @@ void __memcg_kmem_uncharge_pages(struct page *page, int order)
 
 
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
1.9.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

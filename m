From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 10/13] mm: memcontrol: remove ordering between pc->mem_cgroup and PageCgroupUsed
Date: Wed, 18 Jun 2014 16:40:42 -0400
Message-ID: <1403124045-24361-11-git-send-email-hannes@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=ph18LU18wiFwnCQ7Y0SQpc9kcx2Xz7qH3d+vHsYxtG8=;
	b=SNWMGHf1c6DCj4rKDA2zmU3LxaYsZCcOoQbfeKYWSrnS/z3bo+4ToWGTZpXCmlEecJPHVO5IrhiOFopgZUk/9weM0fpE03QygfMcsuaHvUBMpLYfgPZQu10ub6nzOv5LMBWK3mYXaEY62WrVpr3IjY5AdorMbUYZP2QXfmiSaw4=;
In-Reply-To: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

There is a write barrier between setting pc->mem_cgroup and
PageCgroupUsed, which was added to allow LRU operations to lookup the
memcg LRU list of a page without acquiring the page_cgroup lock.

But ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new
rule"), pages are ensured to be off-LRU while charging, so nobody else
is changing LRU state while pc->mem_cgroup is being written, and there
are no read barriers anymore.

Remove the unnecessary write barrier.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d2b8429002c0..199bd50359ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2795,14 +2795,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 	}
 
 	pc->mem_cgroup = memcg;
-	/*
-	 * We access a page_cgroup asynchronously without lock_page_cgroup().
-	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
-	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
-	 * before USED bit, we need memory barrier here.
-	 * See mem_cgroup_add_lru_list(), etc.
-	 */
-	smp_wmb();
 	SetPageCgroupUsed(pc);
 
 	if (lrucare) {
@@ -3483,7 +3475,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
 		pc->mem_cgroup = memcg;
-		smp_wmb();/* see __commit_charge() */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
-- 
2.0.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

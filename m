From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] mm/memcg: fix obsolete comment above MEM_CGROUP_MAX_RECLAIM_LOOPS
Date: Thu, 13 Jul 2023 20:14:32 +0800
Message-ID: <20230713121432.273381-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com
Cc: muchun.song@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linmiaohe@huawei.com

Since commit 5660048ccac8 ("mm: move memcg hierarchy reclaim to generic
reclaim code"), mem_cgroup_hierarchical_reclaim() is already renamed to
mem_cgroup_soft_reclaim(). Update the corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3eaeb69ef9f5..93e3cc581b51 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -197,7 +197,7 @@ static struct move_charge_struct {
 };
 
 /*
- * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
+ * Maximum loops in mem_cgroup_soft_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
  */
 #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
-- 
2.33.0


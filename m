From: Richard Cochran <rcochran@linutronix.de>
Subject: [PATCH 1/5] mm: memcontrol: Remove redundant hot plug notifier test.
Date: Fri, 18 Mar 2016 22:26:07 +0100
Message-ID: <1458336371-17748-1-git-send-email-rcochran@linutronix.de>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: rt@linutronix.de, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org

The test for ONLINE is redundant because the following test for !DEAD
already includes the online case.  This patch removes the superfluous
code.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Richard Cochran <rcochran@linutronix.de>
---
 mm/memcontrol.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d06cae2..993a261 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1916,9 +1916,6 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
 	int cpu = (unsigned long)hcpu;
 	struct memcg_stock_pcp *stock;
 
-	if (action == CPU_ONLINE)
-		return NOTIFY_OK;
-
 	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
-- 
2.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

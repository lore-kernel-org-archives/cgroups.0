From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] mm/memcontrol.c: Remove duplicate inclusion of sock.h file
Date: Tue, 11 Sep 2012 13:38:54 +0530
Message-ID: <1347350934-17712-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: sachin.kamat@linaro.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>

net/sock.h is included unconditionally at the beginning of the file.
Hence, another conditional include is not required.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 mm/memcontrol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 795e525..d5e76f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -413,7 +413,6 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
 
 /* Writing them here to avoid exposing memcg's inner layout */
 #ifdef CONFIG_MEMCG_KMEM
-#include <net/sock.h>
 #include <net/ip.h>
 
 static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
-- 
1.7.4.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

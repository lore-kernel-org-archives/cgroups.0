From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: [PATCH 1/2] mm: memcontrol: cleanup css_reset callback
Date: Tue, 1 Mar 2016 14:13:12 +0300
Message-ID: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

 - Do not take memcg_limit_mutex for resetting limits - the cgroup
   cannot be altered from userspace anymore, so no need to protect them.

 - Use plain page_counter_limit() for resetting ->memory and ->memsw
   limits instead of mem_cgrouop_resize_* helpers - we enlarge the
   limits, so no need in special handling.

 - Reset ->swap and ->tcpmem limits as well.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
---
 mm/memcontrol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae8b81c55685..8615b066b642 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4257,9 +4257,11 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
-	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
-	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->swap, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->memsw, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->kmem, PAGE_COUNTER_MAX);
+	page_counter_limit(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	memcg->low = 0;
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
-- 
2.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

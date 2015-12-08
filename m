From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/8] mm: memcontrol: remove double kmem page_counter init
Date: Tue,  8 Dec 2015 13:34:19 -0500
Message-ID: <1449599665-18047-3-git-send-email-hannes@cmpxchg.org>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The kmem page_counter's limit is initialized to PAGE_COUNTER_MAX
inside mem_cgroup_css_online(). There is no need to repeat this
from memcg_propagate_kmem().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eda8d43..02167db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2840,8 +2840,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_activate_kmem(struct mem_cgroup *memcg,
-			       unsigned long nr_pages)
+static int memcg_activate_kmem(struct mem_cgroup *memcg)
 {
 	int err = 0;
 	int memcg_id;
@@ -2876,13 +2875,6 @@ static int memcg_activate_kmem(struct mem_cgroup *memcg,
 		goto out;
 	}
 
-	/*
-	 * We couldn't have accounted to this cgroup, because it hasn't got
-	 * activated yet, so this should succeed.
-	 */
-	err = page_counter_limit(&memcg->kmem, nr_pages);
-	VM_BUG_ON(err);
-
 	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
 	 * A memory cgroup is considered kmem-active as soon as it gets
@@ -2903,10 +2895,14 @@ static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 	int ret;
 
 	mutex_lock(&memcg_limit_mutex);
-	if (!memcg_kmem_is_active(memcg))
-		ret = memcg_activate_kmem(memcg, limit);
-	else
-		ret = page_counter_limit(&memcg->kmem, limit);
+	/* Top-level cgroup doesn't propagate from root */
+	if (!memcg_kmem_is_active(memcg)) {
+		ret = memcg_activate_kmem(memcg);
+		if (ret)
+			goto out;
+	}
+	ret = page_counter_limit(&memcg->kmem, limit);
+out:
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
@@ -2925,7 +2921,7 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 	 * after this point, because it has at least one child already.
 	 */
 	if (memcg_kmem_is_active(parent))
-		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
+		ret = memcg_activate_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
-- 
2.6.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

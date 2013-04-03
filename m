From: Li Zefan <lizefan@huawei.com>
Subject: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
Date: Wed, 3 Apr 2013 17:12:21 +0800
Message-ID: <515BF275.5080408@huawei.com>
References: <515BF233.6070308@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <515BF233.6070308@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 43ca91d..dafacb8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3191,7 +3191,7 @@ void memcg_release_cache(struct kmem_cache *s)
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
-	mem_cgroup_put(memcg);
+	css_put(&memcg->css);
 out:
 	kfree(s->memcg_params);
 }
@@ -3350,16 +3350,18 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 
 	mutex_lock(&memcg_cache_mutex);
 	new_cachep = cachep->memcg_params->memcg_caches[idx];
-	if (new_cachep)
+	if (new_cachep) {
+		css_put(&memcg->css);
 		goto out;
+	}
 
 	new_cachep = kmem_cache_dup(memcg, cachep);
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
+		css_put(&memcg->css);
 		goto out;
 	}
 
-	mem_cgroup_get(memcg);
 	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
@@ -3449,8 +3451,6 @@ static void memcg_create_cache_work_func(struct work_struct *w)
 
 	cw = container_of(w, struct create_work, work);
 	memcg_create_kmem_cache(cw->memcg, cw->cachep);
-	/* Drop the reference gotten when we enqueued. */
-	css_put(&cw->memcg->css);
 	kfree(cw);
 }
 
-- 
1.8.0.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

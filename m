From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] memcg, kmem: use cache_from_memcg_idx instead of hard code
Date: Wed, 23 Oct 2013 19:31:15 +0800
Message-ID: <1382527875-10112-4-git-send-email-h.huangqiang@huawei.com>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382527875-10112-1-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 15ad0e3..5479b37 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2882,7 +2882,7 @@ static struct kmem_cache *memcg_params_to_cache(struct memcg_cache_params *p)
 
 	VM_BUG_ON(p->is_root_cache);
 	cachep = p->root_cache;
-	return cachep->memcg_params->memcg_caches[memcg_cache_id(p->memcg)];
+	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
 }
 
 #ifdef CONFIG_SLABINFO
@@ -3323,7 +3323,7 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	idx = memcg_cache_id(memcg);
 
 	mutex_lock(&memcg_cache_mutex);
-	new_cachep = cachep->memcg_params->memcg_caches[idx];
+	new_cachep = cache_from_memcg_idx(cachep, idx);
 	if (new_cachep) {
 		css_put(&memcg->css);
 		goto out;
@@ -3369,8 +3369,8 @@ void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 	 * we'll take the set_limit_mutex to protect ourselves against this.
 	 */
 	mutex_lock(&set_limit_mutex);
-	for (i = 0; i < memcg_limited_groups_array_size; i++) {
-		c = s->memcg_params->memcg_caches[i];
+	for_each_memcg_cache_index(i) {
+		c = cache_from_memcg_idx(s, i);
 		if (!c)
 			continue;
 
@@ -3503,8 +3503,8 @@ struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
 	 * code updating memcg_caches will issue a write barrier to match this.
 	 */
 	read_barrier_depends();
-	if (likely(cachep->memcg_params->memcg_caches[idx])) {
-		cachep = cachep->memcg_params->memcg_caches[idx];
+	if (likely(cache_from_memcg_idx(cachep, idx))) {
+		cachep = cache_from_memcg_idx(cachep, idx);
 		goto out;
 	}
 
-- 
1.8.3


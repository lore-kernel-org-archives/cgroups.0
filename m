From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH -mm v2 4/7] slab: use css id for naming per memcg caches
Date: Mon, 19 Jan 2015 14:23:22 +0300
Message-ID: <a7cf5287bcba440711c20801caf6068b46c53313.1421664712.git.vdavydov@parallels.com>
References: <cover.1421664712.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1421664712.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Currently, we use mem_cgroup->kmemcg_id to guarantee kmem_cache->name
uniqueness. This is correct, because kmemcg_id is only released on css
free after destroying all per memcg caches.

However, I am going to change that and release kmemcg_id on css offline,
because it is not wise to keep it for so long, wasting valuable entries
of memcg_cache_params->memcg_caches arrays. Therefore, to preserve cache
name uniqueness, let us switch to css->id.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 6a5a1dde84c1..7f90acf3a3ff 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -487,6 +487,7 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 			     struct kmem_cache *root_cache)
 {
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
+	struct cgroup_subsys_state *css = mem_cgroup_css(memcg);
 	struct memcg_cache_array *arr;
 	struct kmem_cache *s = NULL;
 	char *cache_name;
@@ -509,10 +510,9 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	if (arr->entries[idx])
 		goto out_unlock;
 
-	cgroup_name(mem_cgroup_css(memcg)->cgroup,
-		    memcg_name_buf, sizeof(memcg_name_buf));
+	cgroup_name(css->cgroup, memcg_name_buf, sizeof(memcg_name_buf));
 	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       idx, memcg_name_buf);
+			       css->id, memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

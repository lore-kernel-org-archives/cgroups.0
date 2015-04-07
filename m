From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH -mm] slab: use cgroup ino for naming per memcg caches
Date: Tue, 7 Apr 2015 16:53:18 +0300
Message-ID: <1428414798-12932-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The name of a per memcg kmem cache consists of three parts: the global
kmem cache name, the cgroup name, and the css id. The latter is used to
guarantee cache name uniqueness.

Since css ids are opaque to the userspace, in general it is impossible
to find a cache's owner cgroup given its name: there might be several
same-named cgroups with different parents so that their caches' names
will only differ by css id. Looking up the owner cgroup by a cache name,
however, could be useful for debugging. For instance, the cache name is
dumped to dmesg on a slab allocation failure. Another example is
/sys/kernel/slab, which exports some extra info/tunables for SLUB caches
referring to them by name.

This patch substitutes the css id with cgroup inode number, which, just
like css id, is reserved until css free, so that the cache names are
still guaranteed to be unique, but, in contrast to css id, it can be
easily obtained from userspace.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab_common.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 999bb3424d44..e97bf3e04ed7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -478,7 +478,7 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 			     struct kmem_cache *root_cache)
 {
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
-	struct cgroup_subsys_state *css = mem_cgroup_css(memcg);
+	struct cgroup *cgroup;
 	struct memcg_cache_array *arr;
 	struct kmem_cache *s = NULL;
 	char *cache_name;
@@ -508,9 +508,10 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	if (arr->entries[idx])
 		goto out_unlock;
 
-	cgroup_name(css->cgroup, memcg_name_buf, sizeof(memcg_name_buf));
-	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       css->id, memcg_name_buf);
+	cgroup = mem_cgroup_css(memcg)->cgroup;
+	cgroup_name(cgroup, memcg_name_buf, sizeof(memcg_name_buf));
+	cache_name = kasprintf(GFP_KERNEL, "%s(%lu:%s)", root_cache->name,
+			(unsigned long)cgroup_ino(cgroup), memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

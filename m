From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 4/5] memcg: stop using css id
Date: Mon, 23 Sep 2013 16:56:47 +0800
Message-ID: <5240024F.2040506@huawei.com>
References: <524001F8.6070205@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524001F8.6070205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Now memcg uses cgroup id instead of css id. Update some comments and
set mem_cgroup_subsys->use_id to 0.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e40ebe..32b2d33 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -592,16 +592,11 @@ static void disarm_sock_keys(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * This will be the memcg's index in each cache's ->memcg_params->memcg_caches.
- * There are two main reasons for not using the css_id for this:
- *  1) this works better in sparse environments, where we have a lot of memcgs,
- *     but only a few kmem-limited. Or also, if we have, for instance, 200
- *     memcgs, and none but the 200th is kmem-limited, we'd have to have a
- *     200 entry array for that.
- *
- *  2) In order not to violate the cgroup API, we would like to do all memory
- *     allocation in ->create(). At that point, we haven't yet allocated the
- *     css_id. Having a separate index prevents us from messing with the cgroup
- *     core for this
+ * The main reason for not using cgroup id for this:
+ *  this works better in sparse environments, where we have a lot of memcgs,
+ *  but only a few kmem-limited. Or also, if we have, for instance, 200
+ *  memcgs, and none but the 200th is kmem-limited, we'd have to have a
+ *  200 entry array for that.
  *
  * The current size of the caches array is stored in
  * memcg_limited_groups_array_size.  It will double each time we have to
@@ -616,14 +611,14 @@ int memcg_limited_groups_array_size;
  * cgroups is a reasonable guess. In the future, it could be a parameter or
  * tunable, but that is strictly not necessary.
  *
- * MAX_SIZE should be as large as the number of css_ids. Ideally, we could get
+ * MAX_SIZE should be as large as the number of cgrp_ids. Ideally, we could get
  * this constant directly from cgroup, but it is understandable that this is
  * better kept as an internal representation in cgroup.c. In any case, the
- * css_id space is not getting any smaller, and we don't have to necessarily
+ * cgrp_id space is not getting any smaller, and we don't have to necessarily
  * increase ours as well if it increases.
  */
 #define MEMCG_CACHES_MIN_SIZE 4
-#define MEMCG_CACHES_MAX_SIZE 65535
+#define MEMCG_CACHES_MAX_SIZE MEM_CGROUP_ID_MAX
 
 /*
  * A lot of the calls to the cache allocation functions are expected to be
@@ -6215,7 +6210,6 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 	size_t size = memcg_size();
 
 	mem_cgroup_remove_from_trees(memcg);
-	free_css_id(&mem_cgroup_subsys, &memcg->css);
 
 	for_each_node(node)
 		free_mem_cgroup_per_zone_info(memcg, node);
@@ -7012,7 +7006,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.bind = mem_cgroup_bind,
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
-	.use_id = 1,
 };
 
 #ifdef CONFIG_MEMCG_SWAP
-- 
1.8.0.2

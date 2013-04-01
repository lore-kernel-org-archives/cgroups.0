From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: avoid accessing memcg after releasing reference
Date: Mon, 1 Apr 2013 10:39:00 +0800
Message-ID: <5158F344.9020509@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

This might cause use-after-free bug.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

found when reading the code.

---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8ec501c..6391046 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3186,12 +3186,12 @@ void memcg_release_cache(struct kmem_cache *s)
 
 	root = s->memcg_params->root_cache;
 	root->memcg_params->memcg_caches[id] = NULL;
-	mem_cgroup_put(memcg);
 
 	mutex_lock(&memcg->slab_caches_mutex);
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
+	mem_cgroup_put(memcg);
 out:
 	kfree(s->memcg_params);
 }
-- 
1.8.0.2

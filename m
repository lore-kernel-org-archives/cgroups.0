From: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] mm/memcontrol.c: make cgroup_memory_noswap static
Date: Thu, 21 Apr 2022 20:47:36 +0800
Message-ID: <20220421124736.62180-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

cgroup_memory_noswap is only used in mm/memcontrol.c, therefore just make
it static, and remove export in include/linux/memcontrol.h

Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 4 ----
 mm/memcontrol.c            | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a68dce3873fc..2406cc5153d4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -937,10 +937,6 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
-#ifdef CONFIG_MEMCG_SWAP
-extern bool cgroup_memory_noswap;
-#endif
-
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
 void lock_page_memcg(struct page *page);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 725f76723220..2fc363ee258c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -89,7 +89,7 @@ static bool cgroup_memory_nokmem __ro_after_init;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-bool cgroup_memory_noswap __ro_after_init;
+static bool cgroup_memory_noswap __ro_after_init;
 #else
 #define cgroup_memory_noswap		1
 #endif
-- 
2.17.1


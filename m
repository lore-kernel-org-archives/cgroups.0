From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/8] memcg: convert to use cgroup_is_descendant()
Date: Wed, 24 Jul 2013 18:01:25 +0800
Message-ID: <51EFA5F5.3020406@huawei.com>
References: <51EFA554.6080801@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51EFA554.6080801-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This is a preparation to kill css_id.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d12ca6f..626c426 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1434,7 +1434,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 		return true;
 	if (!root_memcg->use_hierarchy || !memcg)
 		return false;
-	return css_is_ancestor(&memcg->css, &root_memcg->css);
+	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
 }
 
 static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-- 
1.8.0.2

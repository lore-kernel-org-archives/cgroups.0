From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: remove redundant code in mem_cgroup_force_empty_write()
Date: Thu, 25 Jul 2013 09:53:09 +0800
Message-ID: <51F08505.6050402@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

vfs guarantees the cgroup won't be destroyed, so it's redundant
to get a css reference.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03c8bf7..aa3e478 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5015,15 +5015,10 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int ret;
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	css_get(&memcg->css);
-	ret = mem_cgroup_force_empty(memcg);
-	css_put(&memcg->css);
-
-	return ret;
+	return mem_cgroup_force_empty(memcg);
 }
 
 
-- 
1.8.0.2

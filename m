From: Yang Li <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] mm/memcontrol: remove redundant NULL check
Date: Thu, 21 Jan 2021 16:00:29 +0800
Message-ID: <1611216029-34397-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Li <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Fix below warnings reported by coccicheck:
./mm/memcontrol.c:451:3-9: WARNING: NULL check before some freeing
functions is not needed.

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Yang Li <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 605f671..f6a561b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -447,8 +447,7 @@ static void memcg_free_shrinker_maps(struct mem_cgroup *memcg)
 	for_each_node(nid) {
 		pn = mem_cgroup_nodeinfo(memcg, nid);
 		map = rcu_dereference_protected(pn->shrinker_map, true);
-		if (map)
-			kvfree(map);
+		kvfree(map);
 		rcu_assign_pointer(pn->shrinker_map, NULL);
 	}
 }
-- 
1.8.3.1


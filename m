From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: use helper macro FLUSH_TIME
Date: Sat, 3 Jun 2023 15:21:16 +0800
Message-ID: <20230603072116.1101690-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Use helper macro FLUSH_TIME to indicate the flush time to improve the
readability a bit. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d8569594239c..f204c9f2e69c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5397,7 +5397,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
-				   2UL*HZ);
+				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 	return 0;
 offline_kmem:
-- 
2.27.0


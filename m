From: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] mm/memcontrol.c: replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled()
Date: Sat, 25 Jun 2022 14:18:44 +0800
Message-ID: <20220625061844.226764-1-xiangyang3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

mem_cgroup_kmem_disabled() checks whether the kmem accounting is off.
Therefore, replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled(),
which is the same work in percpu.c and slab_common.c.

Signed-off-by: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 85adc43c5a25..4672c9ddd188 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3815,7 +3815,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	if (cgroup_memory_nokmem)
+	if (mem_cgroup_kmem_disabled())
 		return 0;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
@@ -3830,7 +3830,7 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
-	if (cgroup_memory_nokmem)
+	if (mem_cgroup_kmem_disabled())
 		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
-- 
2.22.0


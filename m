From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Thu, 29 Jul 2021 20:57:52 +0800
Message-ID: <20210729125755.16871-3-linmiaohe@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210729125755.16871-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since percpu_charge_mutex is only used inside drain_all_stock(), we can
narrow the scope of percpu_charge_mutex by moving it here.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6580c2381a3e..a03e24e57cd9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2050,7 +2050,6 @@ struct memcg_stock_pcp {
 #define FLUSHING_CACHED_CHARGE	0
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
-static DEFINE_MUTEX(percpu_charge_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
 static void drain_obj_stock(struct obj_stock *stock);
@@ -2209,6 +2208,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_all_stock(struct mem_cgroup *root_memcg)
 {
+	static DEFINE_MUTEX(percpu_charge_mutex);
 	int cpu, curcpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
-- 
2.23.0


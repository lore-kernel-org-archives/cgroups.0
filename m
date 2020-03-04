From: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] mm: Make mem_cgroup_id_get_many dependent on MMU and MEMCG_SWAP
Date: Wed,  4 Mar 2020 14:23:48 +0000
Message-ID: <20200304142348.48167-1-vincenzo.frascino@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

mem_cgroup_id_get_many() is currently used only when MMU or MEMCG_SWAP
configuration options are enabled. Having them disabled triggers the
following warning at compile time:

linux/mm/memcontrol.c:4797:13: warning: ‘mem_cgroup_id_get_many’ defined
but not used [-Wunused-function]
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned
 int n)

Make mem_cgroup_id_get_many() dependent on MMU and MEMCG_SWAP to address
the issue.

Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d09776cd6e10..628cebeb4bdd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4794,10 +4794,12 @@ static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
+#if defined(CONFIG_MEMCG_SWAP) || defined(CONFIG_MMU)
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	refcount_add(n, &memcg->id.ref);
 }
+#endif
 
 static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
-- 
2.25.1


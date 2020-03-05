From: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v2] mm: Make mem_cgroup_id_get_many() __maybe_unused
Date: Thu,  5 Mar 2020 16:43:54 +0000
Message-ID: <20200305164354.48147-1-vincenzo.frascino@arm.com>
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

Make mem_cgroup_id_get_many() __maybe_unused to address the issue.

Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d09776cd6e10..2b9533ed52f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4794,7 +4794,8 @@ static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
+static void __maybe_unused mem_cgroup_id_get_many(struct mem_cgroup *memcg,
+						  unsigned int n)
 {
 	refcount_add(n, &memcg->id.ref);
 }
-- 
2.25.1


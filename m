From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/9] memcg: use css_get() in sock_update_memcg()
Date: Fri, 17 May 2013 15:03:38 +0800
Message-ID: <5195D64A.9090000@huawei.com>
References: <5195D5F8.7000609@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5195D5F8.7000609-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Use css_get/css_put instead of mem_cgroup_get/put.

Note, if at the same time someone is moving @current to a different
cgroup and removing the old cgroup, css_tryget() may return false,
and sock->sk_cgrp won't be initialized, which is fine.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d0458d..f1320d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -561,15 +561,15 @@ void sock_update_memcg(struct sock *sk)
 		 */
 		if (sk->sk_cgrp) {
 			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
-			mem_cgroup_get(sk->sk_cgrp->memcg);
+			css_get(&sk->sk_cgrp->memcg->css);
 			return;
 		}
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
-			mem_cgroup_get(memcg);
+		if (!mem_cgroup_is_root(memcg) &&
+		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
 		rcu_read_unlock();
@@ -583,7 +583,7 @@ void sock_release_memcg(struct sock *sk)
 		struct mem_cgroup *memcg;
 		WARN_ON(!sk->sk_cgrp->memcg);
 		memcg = sk->sk_cgrp->memcg;
-		mem_cgroup_put(memcg);
+		css_put(&sk->sk_cgrp->memcg->css);
 	}
 }
 
-- 
1.8.0.2

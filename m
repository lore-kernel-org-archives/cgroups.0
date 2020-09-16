From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm: memcontrol: correct the comment of mem_cgroup_unmark_under_oom()
Date: Wed, 16 Sep 2020 09:19:27 -0400
Message-ID: <20200916131927.11340-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit fb2a6fc56be6 ("mm: memcg: rework and document OOM waiting and
wakeup"), we have renamed mem_cgroup_oom_lock to mem_cgroup_oom_trylock. So
replace mem_cgroup_oom_lock with mem_cgroup_oom_trylock in comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d26b4b954e2..702aa4d7ebbc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1846,7 +1846,7 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
 
 	/*
 	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
+	 * mem_cgroup_oom_trylock() may not be called. Watch for underflow.
 	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
-- 
2.19.1


From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] mm: memcontrol: remove obsolete comment of mem_cgroup_unmark_under_oom()
Date: Thu, 17 Sep 2020 06:59:00 -0400
Message-ID: <20200917105900.4337-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here. But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cd5f83de9a6f..e44f5afaf78b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1848,10 +1848,6 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *iter;
 
-	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
-	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
 		if (iter->under_oom > 0)
-- 
2.19.1


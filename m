From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] mm: memcontrol: eliminate redundant check in __mem_cgroup_insert_exceeded()
Date: Mon, 12 Oct 2020 09:16:07 -0400
Message-ID: <20201012131607.10656-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The mz->usage_in_excess >= mz_node->usage_in_excess check is exactly the
else case of mz->usage_in_excess < mz_node->usage_in_excess. So we could
replace else if (mz->usage_in_excess >= mz_node->usage_in_excess) with else
equally. Also drop the comment which doesn't really explain much.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2636f8bad908..b080a9434b9e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -623,14 +623,9 @@ static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
 		if (mz->usage_in_excess < mz_node->usage_in_excess) {
 			p = &(*p)->rb_left;
 			rightmost = false;
-		}
-
-		/*
-		 * We can't avoid mem cgroups that are over their soft
-		 * limit by the same amount
-		 */
-		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
+		} else {
 			p = &(*p)->rb_right;
+		}
 	}
 
 	if (rightmost)
-- 
2.19.1


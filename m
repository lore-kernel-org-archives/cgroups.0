From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/3] mm: Fix dropped memcg from mem cgroup soft limit tree
Date: Tue,  9 Feb 2021 12:29:45 -0800
Message-ID: <d50e3bb513845d1f7816b94733576ce6f798682a.1612902157.git.tim.c.chen@linux.intel.com>
References: <cover.1612902157.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1612902157.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

During soft limit memory reclaim, we will temporarily remove the target
mem cgroup from the cgroup soft limit tree.  We then perform memory
reclaim, update the memory usage excess count and re-insert the mem
cgroup back into the mem cgroup soft limit tree according to the new
memory usage excess count.

However, when memory reclaim failed for a maximum number of attempts
and we bail out of the reclaim loop, we forgot to put the target mem
cgroup chosen for next reclaim back to the soft limit tree. This prevented
pages in the mem cgroup from being reclaimed in the future even though
the mem cgroup exceeded its soft limit.  Fix the logic and put the mem
cgroup back on the tree when page reclaim failed for the mem cgroup.

Reviewed-by: Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ed5cc78a8dbf..a51bf90732cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3505,8 +3505,12 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
-	if (next_mz)
+	if (next_mz) {
+		spin_lock_irq(&mctz->lock);
+		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
+		spin_unlock_irq(&mctz->lock);
 		css_put(&next_mz->memcg->css);
+	}
 	return nr_reclaimed;
 }
 
-- 
2.20.1


From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v4 11/14] memcg: allow a memcg with kmem charges to be destructed.
Date: Mon,  8 Oct 2012 14:06:17 +0400
Message-ID: <1349690780-15988-12-git-send-email-glommer@parallels.com>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349690780-15988-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

Because the ultimate goal of the kmem tracking in memcg is to track slab
pages as well, we can't guarantee that we'll always be able to point a
page to a particular process, and migrate the charges along with it -
since in the common case, a page will contain data belonging to multiple
processes.

Because of that, when we destroy a memcg, we only make sure the
destruction will succeed by discounting the kmem charges from the user
charges when we try to empty the cgroup.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 724a08b..2f92f89 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -546,6 +546,11 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
 	if (memcg_kmem_is_active(memcg))
 		static_key_slow_dec(&memcg_kmem_enabled_key);
+	/*
+	 * This check can't live in kmem destruction function,
+	 * since the charges will outlive the cgroup
+	 */
+	WARN_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
 }
 #else
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
@@ -3994,6 +3999,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
 	int node, zid, shrink;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct cgroup *cgrp = memcg->css.cgroup;
+	u64 usage;
 
 	css_get(&memcg->css);
 
@@ -4027,8 +4033,17 @@ move_account:
 		mem_cgroup_end_move(memcg);
 		memcg_oom_recover(memcg);
 		cond_resched();
+		/*
+		 * Kernel memory may not necessarily be trackable to a specific
+		 * process. So they are not migrated, and therefore we can't
+		 * expect their value to drop to 0 here.
+		 *
+		 * having res filled up with kmem only is enough
+		 */
+		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
+			res_counter_read_u64(&memcg->kmem, RES_USAGE);
 	/* "ret" should also be checked to ensure all lists are empty. */
-	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
+	} while (usage > 0 || ret);
 out:
 	css_put(&memcg->css);
 	return ret;
-- 
1.7.11.4

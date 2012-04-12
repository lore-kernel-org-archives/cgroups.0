From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 2/7] memcg: move charge to parent only when necessary.
Date: Thu, 12 Apr 2012 20:21:20 +0900
Message-ID: <4F86BAB0.5030809@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


When memcg->use_hierarchy==true, the parent res_counter includes
the usage in child's usage. So, it's not necessary to call try_charge()
in the parent.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |   39 ++++++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fa01106..3215880 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2409,6 +2409,20 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
 			res_counter_uncharge(&memcg->memsw, bytes);
 	}
 }
+/*
+ * Moving usage between a child to its parent if use_hierarchy==true.
+ */
+static void __mem_cgroup_move_charge_parent(struct mem_cgroup *memcg,
+					unsigned int nr_pages)
+{
+	if (!mem_cgroup_is_root(memcg)) {
+		unsigned long bytes = nr_pages * PAGE_SIZE;
+
+		res_counter_move_parent(&memcg->res, bytes);
+		if (do_swap_account)
+			res_counter_move_parent(&memcg->memsw, bytes);
+	}
+}
 
 /*
  * A helper function to get mem_cgroup from ID. must be called under
@@ -2666,18 +2680,29 @@ static int mem_cgroup_move_parent(struct page *page,
 		goto put;
 
 	nr_pages = hpage_nr_pages(page);
-
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
-	if (ret)
-		goto put_back;
+
+	if (!parent->use_hierarchy) {
+		ret = __mem_cgroup_try_charge(NULL, gfp_mask,
+					nr_pages, &parent, false);
+		if (ret)
+			goto put_back;
+	}
 
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent, true);
-	if (ret)
-		__mem_cgroup_cancel_charge(parent, nr_pages);
+	if (!parent->use_hierarchy) {
+		ret = mem_cgroup_move_account(page, nr_pages, pc,
+					child, parent, true);
+		if (ret)
+			__mem_cgroup_cancel_charge(parent, nr_pages);
+	} else {
+		ret = mem_cgroup_move_account(page, nr_pages, pc,
+					child, parent, false);
+		if (!ret)
+			__mem_cgroup_move_charge_parent(child, nr_pages);
+	}
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
-- 
1.7.4.1


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 3/7] memcg: move charges to root at rmdir()
Date: Thu, 12 Apr 2012 20:22:42 +0900
Message-ID: <4F86BB02.2060607@jp.fujitsu.com>
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

As recently discussed, Tejun Heo, the cgroup maintainer, tries to
remove ->pre_destroy() and cgroup will never return -EBUSY at rmdir().

To do that, in memcg, handling case of use_hierarchy==false is a problem.

We move memcg's charges to its parent at rmdir(). If use_hierarchy==true,
it's already accounted in the parent, no problem. If use_hierarchy==false,
we cannot guarantee we can move all charges to the parent.

This patch changes the behavior to move all charges to root_mem_cgroup
if use_hierarchy=false. It seems this matches semantics of use_hierarchy==false,which means parent and child has no hierarchical relationship.

With this, we can remove -ENOMEM error check at pre_destroy(), called at rmdir.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 Documentation/cgroups/memory.txt |    6 ++++--
 mm/memcontrol.c                  |   38 ++++++++++++--------------------------
 2 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 84d4f00..f717f6a 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -377,8 +377,10 @@ cgroup might have some charge associated with it, even though all
 tasks have migrated away from it. (because we charge against pages, not
 against tasks.)
 
-Such charges are freed or moved to their parent. At moving, both of RSS
-and CACHES are moved to parent.
+Such charges are freed or moved to their parent if use_hierarchy==true.
+If use_hierarchy==false, charges are moved to root memory cgroup.
+
+At moving, both of RSS and CACHES are moved to parent.
 rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
 
 Charges recorded in swap information is not updated at removal of cgroup.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3215880..8246418 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2662,15 +2662,14 @@ static int mem_cgroup_move_parent(struct page *page,
 				  struct mem_cgroup *child,
 				  gfp_t gfp_mask)
 {
-	struct cgroup *cg = child->css.cgroup;
-	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
 	unsigned int nr_pages;
 	unsigned long uninitialized_var(flags);
+	bool need_cancel = false;
 	int ret;
 
 	/* Is ROOT ? */
-	if (!pcg)
+	if (mem_cgroup_is_root(child))
 		return -EINVAL;
 
 	ret = -EBUSY;
@@ -2680,33 +2679,23 @@ static int mem_cgroup_move_parent(struct page *page,
 		goto put;
 
 	nr_pages = hpage_nr_pages(page);
-	parent = mem_cgroup_from_cont(pcg);
-
-	if (!parent->use_hierarchy) {
-		ret = __mem_cgroup_try_charge(NULL, gfp_mask,
-					nr_pages, &parent, false);
-		if (ret)
-			goto put_back;
+	parent = parent_mem_cgroup(child);
+	if (!parent) {
+		parent = root_mem_cgroup;
+		need_cancel = true;
 	}
 
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	if (!parent->use_hierarchy) {
-		ret = mem_cgroup_move_account(page, nr_pages, pc,
-					child, parent, true);
-		if (ret)
-			__mem_cgroup_cancel_charge(parent, nr_pages);
-	} else {
-		ret = mem_cgroup_move_account(page, nr_pages, pc,
-					child, parent, false);
-		if (!ret)
-			__mem_cgroup_move_charge_parent(child, nr_pages);
-	}
+	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent,
+					need_cancel);
+	if (!need_cancel && !ret)
+		__mem_cgroup_move_charge_parent(child, nr_pages);
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
-put_back:
+
 	putback_lru_page(page);
 put:
 	put_page(page);
@@ -3677,7 +3666,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM || ret == -EINTR)
+		if (ret == -EINTR)
 			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
@@ -3738,9 +3727,6 @@ move_account:
 		}
 		mem_cgroup_end_move(memcg);
 		memcg_oom_recover(memcg);
-		/* it seems parent cgroup doesn't have enough mem */
-		if (ret == -ENOMEM)
-			goto try_to_free;
 		cond_resched();
 	/* "ret" should also be checked to ensure all lists are empty. */
 	} while (memcg->res.usage > 0 || ret);
-- 
1.7.4.1


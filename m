From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH v3 4/6] memcg: move charges to root cgroup if use_hierarchy=0.
Date: Fri, 11 May 2012 18:49:22 +0900
Message-ID: <4FACE0A2.30608@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FACDED0.3020400-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Now, at removal of cgroup, ->pre_destroy() is called and move charges
to the parent cgroup. A major reason of -EBUSY returned by ->pre_destroy()
is that the 'moving' hits parent's resource limitation. It happens only
when use_hierarchy=0.

Considering use_hierarchy=0, all cgroups should be flat. So, no one
cannot justify moving charges to parent...parent and children are in
flat configuration, not hierarchical.

This patch modifes to move charges to root cgroup at rmdir/force_empty
if use_hierarchy==0. This will much simplify rmdir() and reduce error
in ->pre_destroy.

Changelog since v2:
  - use parent_mem_cgroup()
  - updated Documenation

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 Documentation/cgroups/memory.txt |   13 ++++++----
 mm/memcontrol.c                  |   49 +++++++++++++------------------------
 2 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 730e222a..8d0de70 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -393,14 +393,15 @@ cgroup might have some charge associated with it, even though all
 tasks have migrated away from it. (because we charge against pages, not
 against tasks.)
 
-Such charges are freed or moved to their parent. At moving, both of RSS
-and CACHES are moved to parent.
-rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
+We move the stats to root (if use_hierarchy==0) or parent (if
+use_hierarchy==1), and no change on the charge except uncharging
+from the child.
 
 Charges recorded in swap information is not updated at removal of cgroup.
 Recorded information is discarded and a cgroup which uses swap (swapcache)
 will be charged as a new owner of it.
 
+About use_hierarchy, see Section 6.
 
 5. Misc. interfaces.
 
@@ -413,13 +414,15 @@ will be charged as a new owner of it.
 
   Almost all pages tracked by this memory cgroup will be unmapped and freed.
   Some pages cannot be freed because they are locked or in-use. Such pages are
-  moved to parent and this cgroup will be empty. This may return -EBUSY if
-  VM is too busy to free/move all pages immediately.
+  moved to parent(if use_hierarchy==1) or root (if use_hierarchy==0) and this
+  cgroup will be empty.
 
   Typical use case of this interface is that calling this before rmdir().
   Because rmdir() moves all pages to parent, some out-of-use page caches can be
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
+  About use_hierarchy, see Section 6.
+
 5.2 stat file
 
 memory.stat file includes following statistics
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb90be1..f007c17 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2709,15 +2709,13 @@ static int mem_cgroup_move_parent(struct page *page,
 				  struct mem_cgroup *child,
 				  gfp_t gfp_mask)
 {
-	struct cgroup *cg = child->css.cgroup;
-	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
 	unsigned int nr_pages;
 	unsigned long uninitialized_var(flags);
 	int ret;
 
 	/* Is ROOT ? */
-	if (!pcg)
+	if (mem_cgroup_is_root(child))
 		return -EINVAL;
 
 	ret = -EBUSY;
@@ -2728,33 +2726,23 @@ static int mem_cgroup_move_parent(struct page *page,
 
 	nr_pages = hpage_nr_pages(page);
 
-	parent = mem_cgroup_from_cont(pcg);
-	if (!parent->use_hierarchy) {
-		ret = __mem_cgroup_try_charge(NULL,
-					gfp_mask, nr_pages, &parent, false);
-		if (ret)
-			goto put_back;
-	}
+	parent = parent_mem_cgroup(child);
+	/*
+	 * If no parent, move charges to root cgroup.
+	 */
+	if (!parent)
+		parent = root_mem_cgroup;
 
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	if (parent->use_hierarchy) {
-		ret = mem_cgroup_move_account(page, nr_pages,
-					pc, child, parent, false);
-		if (!ret)
-			__mem_cgroup_cancel_local_charge(child, nr_pages);
-	} else {
-		ret = mem_cgroup_move_account(page, nr_pages,
-					pc, child, parent, true);
-
-		if (ret)
-			__mem_cgroup_cancel_charge(parent, nr_pages);
-	}
+	ret = mem_cgroup_move_account(page, nr_pages,
+				pc, child, parent, false);
+	if (!ret)
+		__mem_cgroup_cancel_local_charge(child, nr_pages);
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
-put_back:
 	putback_lru_page(page);
 put:
 	put_page(page);
@@ -3351,9 +3339,8 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 	struct page_cgroup *pc;
 	int csize,  ret = 0;
 	struct res_counter *fail_res;
-	struct cgroup *pcgrp = cgroup->parent;
-	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
 	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct res_counter *counter;
 
 	if (!get_page_unless_zero(page))
@@ -3366,13 +3353,11 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 
 	csize = PAGE_SIZE << compound_order(page);
 	/* If parent->use_hierarchy == 0, we need to charge parent */
-	if (!parent->use_hierarchy) {
-		ret = res_counter_charge(&parent->hugepage[idx],
-					 csize, &fail_res);
-		if (ret) {
-			ret = -EBUSY;
-			goto err_out;
-		}
+	if (!parent) {
+		parent = root_mem_cgroup;
+		/* root has no limit */
+		res_counter_charge_nofail(&parent->hugepage[idx],
+				 csize, &fail_res);
 	}
 	counter = &memcg->hugepage[idx];
 	res_counter_uncharge_until(counter, counter->parent, csize);
-- 
1.7.4.1


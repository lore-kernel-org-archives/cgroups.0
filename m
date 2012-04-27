From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC][PATCH 5/9 v2] move charges to root at rmdir if use_hierarchy
 is unset
Date: Fri, 27 Apr 2012 14:58:52 +0900
Message-ID: <4F9A359C.10107@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F9A327A.6050409@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com

Now, at removal of cgroup, ->pre_destroy() is called and move charges
to the parent cgroup. A major reason of -EBUSY returned by ->pre_destroy()
is that the 'moving' hits parent's resource limitation. It happens only
when use_hierarchy=0. This was a mistake of original design.(it's me...)

Considering use_hierarchy=0, all cgroups are treated as flat. So, no one
cannot justify moving charges to parent...parent and children are in
flat configuration, not hierarchical.

This patch modifes to move charges to root cgroup at rmdir/force_empty
if use_hierarchy==0. This will much simplify rmdir() and reduce error
in ->pre_destroy.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/memory.txt |   12 ++++++----
 mm/memcontrol.c                  |   39 +++++++++++++------------------------
 2 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 54c338d..82ce1ef 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -393,14 +393,14 @@ cgroup might have some charge associated with it, even though all
 tasks have migrated away from it. (because we charge against pages, not
 against tasks.)
 
-Such charges are freed or moved to their parent. At moving, both of RSS
-and CACHES are moved to parent.
-rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
+Such charges are freed or moved to their parent if use_hierarchy=1.
+if use_hierarchy=0, the charges will be moved to root cgroup.
 
 Charges recorded in swap information is not updated at removal of cgroup.
 Recorded information is discarded and a cgroup which uses swap (swapcache)
 will be charged as a new owner of it.
 
+About use_hierarchy, see Section 6.
 
 5. Misc. interfaces.
 
@@ -413,13 +413,15 @@ will be charged as a new owner of it.
 
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
index ed53d64..62200f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2695,32 +2695,23 @@ static int mem_cgroup_move_parent(struct page *page,
 	nr_pages = hpage_nr_pages(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	if (!parent->use_hierarchy) {
-		ret = __mem_cgroup_try_charge(NULL,
-					gfp_mask, nr_pages, &parent, false);
-		if (ret)
-			goto put_back;
-	}
+	/*
+	 * if use_hierarchy==0, move charges to root cgroup.
+	 * in root cgroup, we don't touch res_counter
+	 */
+	if (!parent->use_hierarchy)
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
@@ -3338,12 +3329,10 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 	csize = PAGE_SIZE << compound_order(page);
 	/* If parent->use_hierarchy == 0, we need to charge parent */
 	if (!parent->use_hierarchy) {
-		ret = res_counter_charge(&parent->hugepage[idx],
-					 csize, &fail_res);
-		if (ret) {
-			ret = -EBUSY;
-			goto err_out;
-		}
+		parent = root_mem_cgroup;
+		/* root has no limit */
+		res_counter_charge_nofail(&parent->hugepage[idx],
+				 csize, &fail_res);
 	}
 	counter = &memcg->hugepage[idx];
 	res_counter_uncharge_until(counter, counter->parent, csize);
-- 
1.7.4.1


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

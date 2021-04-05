From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 06/11] mm: Handle top tier memory in cgroup soft limit memory tree utilities
Date: Mon,  5 Apr 2021 10:08:30 -0700
Message-ID: <86f4bad592a5232226c1779e6acce117a32b41ee.1617642417.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Update the utility functions __mem_cgroup_insert_exceeded() and
__mem_cgroup_remove_exceeded(), to allow addition and removal of cgroups
from the new red black tree that tracks the cgroups that exceed their
toptier memory limits.

Update also the function +mem_cgroup_largest_soft_limit_node(),
to allow returning the cgroup that has the largest exceess usage
of toptier memory.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/memcontrol.h |   9 +++
 mm/memcontrol.c            | 152 +++++++++++++++++++++++++++----------
 2 files changed, 122 insertions(+), 39 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 609d8590950c..0ed8ddfd5436 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -124,6 +124,15 @@ struct mem_cgroup_per_node {
 	unsigned long		usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
+
+	struct rb_node		toptier_tree_node;	 /* RB tree node */
+	unsigned long		toptier_usage_in_excess; /* Set to the value by which */
+						         /* the soft limit is exceeded*/
+	bool			on_toptier_tree;
+
+	bool			congested;	/* memcg has many dirty pages */
+						/* backed by a congested BDI */
+
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 90a78ff3fca8..8a7648b79635 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -616,24 +616,44 @@ soft_limit_tree_from_page(struct page *page, enum node_states type)
 
 static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
 					 struct mem_cgroup_tree_per_node *mctz,
-					 unsigned long new_usage_in_excess)
+					 unsigned long new_usage_in_excess,
+					 enum node_states type)
 {
 	struct rb_node **p = &mctz->rb_root.rb_node;
-	struct rb_node *parent = NULL;
+	struct rb_node *parent = NULL, *mz_tree_node;
 	struct mem_cgroup_per_node *mz_node;
-	bool rightmost = true;
+	bool rightmost = true, *mz_on_tree;
+	unsigned long usage_in_excess, *mz_usage_in_excess;
 
-	if (mz->on_tree)
+	if (type == N_TOPTIER) {
+		mz_usage_in_excess = &mz->toptier_usage_in_excess;
+		mz_tree_node = &mz->toptier_tree_node;
+		mz_on_tree = &mz->on_toptier_tree;
+	} else {
+		mz_usage_in_excess = &mz->usage_in_excess;
+		mz_tree_node = &mz->tree_node;
+		mz_on_tree = &mz->on_tree;
+	}
+
+	if (*mz_on_tree)
 		return;
 
-	mz->usage_in_excess = new_usage_in_excess;
-	if (!mz->usage_in_excess)
+	if (!new_usage_in_excess)
 		return;
+
 	while (*p) {
 		parent = *p;
-		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
+		if (type == N_TOPTIER) {
+			mz_node = rb_entry(parent, struct mem_cgroup_per_node,
+					toptier_tree_node);
+			usage_in_excess = mz_node->toptier_usage_in_excess;
+		} else {
+			mz_node = rb_entry(parent, struct mem_cgroup_per_node,
 					tree_node);
-		if (mz->usage_in_excess < mz_node->usage_in_excess) {
+			usage_in_excess = mz_node->usage_in_excess;
+		}
+
+		if (new_usage_in_excess < usage_in_excess) {
 			p = &(*p)->rb_left;
 			rightmost = false;
 		} else {
@@ -642,33 +662,47 @@ static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
 	}
 
 	if (rightmost)
-		mctz->rb_rightmost = &mz->tree_node;
+		mctz->rb_rightmost = mz_tree_node;
 
-	rb_link_node(&mz->tree_node, parent, p);
-	rb_insert_color(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = true;
+	rb_link_node(mz_tree_node, parent, p);
+	rb_insert_color(mz_tree_node, &mctz->rb_root);
+	*mz_usage_in_excess = new_usage_in_excess;
+	*mz_on_tree = true;
 }
 
 static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
-					 struct mem_cgroup_tree_per_node *mctz)
+					 struct mem_cgroup_tree_per_node *mctz,
+					 enum node_states type)
 {
-	if (!mz->on_tree)
+	bool *mz_on_tree;
+	struct rb_node *mz_tree_node;
+
+	if (type == N_TOPTIER) {
+		mz_tree_node = &mz->toptier_tree_node;
+		mz_on_tree = &mz->on_toptier_tree;
+	} else {
+		mz_tree_node = &mz->tree_node;
+		mz_on_tree = &mz->on_tree;
+	}
+
+	if (!(*mz_on_tree))
 		return;
 
-	if (&mz->tree_node == mctz->rb_rightmost)
-		mctz->rb_rightmost = rb_prev(&mz->tree_node);
+	if (mz_tree_node == mctz->rb_rightmost)
+		mctz->rb_rightmost = rb_prev(mz_tree_node);
 
-	rb_erase(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = false;
+	rb_erase(mz_tree_node, &mctz->rb_root);
+	*mz_on_tree = false;
 }
 
 static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
-				       struct mem_cgroup_tree_per_node *mctz)
+				       struct mem_cgroup_tree_per_node *mctz,
+				       enum node_states type)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&mctz->lock, flags);
-	__mem_cgroup_remove_exceeded(mz, mctz);
+	__mem_cgroup_remove_exceeded(mz, mctz, type);
 	spin_unlock_irqrestore(&mctz->lock, flags);
 }
 
@@ -696,13 +730,18 @@ static unsigned long soft_limit_excess(struct mem_cgroup *memcg, enum node_state
 	return excess;
 }
 
-static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
+static void mem_cgroup_update_tree(struct mem_cgroup *bottom_memcg, struct page *page)
 {
 	unsigned long excess;
 	struct mem_cgroup_per_node *mz;
 	struct mem_cgroup_tree_per_node *mctz;
+	enum node_states type = N_MEMORY;
+	struct mem_cgroup *memcg;
+
+repeat_toptier:
+	memcg = bottom_memcg;
+	mctz = soft_limit_tree_from_page(page, type);
 
-	mctz = soft_limit_tree_from_page(page, N_MEMORY);
 	if (!mctz)
 		return;
 	/*
@@ -710,27 +749,37 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 	 * because their event counter is not touched.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		bool on_tree;
+
 		mz = mem_cgroup_page_nodeinfo(memcg, page);
-		excess = soft_limit_excess(memcg, N_MEMORY);
+		excess = soft_limit_excess(memcg, type);
+
+		on_tree = (type == N_MEMORY) ? mz->on_tree: mz->on_toptier_tree;
 		/*
 		 * We have to update the tree if mz is on RB-tree or
 		 * mem is over its softlimit.
 		 */
-		if (excess || mz->on_tree) {
+		if (excess || on_tree) {
 			unsigned long flags;
 
 			spin_lock_irqsave(&mctz->lock, flags);
 			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(mz, mctz);
+			if (on_tree)
+				__mem_cgroup_remove_exceeded(mz, mctz, type);
+
 			/*
 			 * Insert again. mz->usage_in_excess will be updated.
 			 * If excess is 0, no tree ops.
 			 */
-			__mem_cgroup_insert_exceeded(mz, mctz, excess);
+			__mem_cgroup_insert_exceeded(mz, mctz, excess, type);
+
 			spin_unlock_irqrestore(&mctz->lock, flags);
 		}
 	}
+	if (type == N_MEMORY) {
+		type = N_TOPTIER;
+		goto repeat_toptier;
+	}
 }
 
 static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
@@ -743,12 +792,16 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 		mz = mem_cgroup_nodeinfo(memcg, nid);
 		mctz = soft_limit_tree_node(nid, N_MEMORY);
 		if (mctz)
-			mem_cgroup_remove_exceeded(mz, mctz);
+			mem_cgroup_remove_exceeded(mz, mctz, N_MEMORY);
+		mctz = soft_limit_tree_node(nid, N_TOPTIER);
+		if (mctz)
+			mem_cgroup_remove_exceeded(mz, mctz, N_TOPTIER);
 	}
 }
 
 static struct mem_cgroup_per_node *
-__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
+__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz,
+				     enum node_states type)
 {
 	struct mem_cgroup_per_node *mz;
 
@@ -757,15 +810,19 @@ __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 	if (!mctz->rb_rightmost)
 		goto done;		/* Nothing to reclaim from */
 
-	mz = rb_entry(mctz->rb_rightmost,
+	if (type == N_TOPTIER)
+		mz = rb_entry(mctz->rb_rightmost,
+		      struct mem_cgroup_per_node, toptier_tree_node);
+	else
+		mz = rb_entry(mctz->rb_rightmost,
 		      struct mem_cgroup_per_node, tree_node);
 	/*
 	 * Remove the node now but someone else can add it back,
 	 * we will to add it back at the end of reclaim to its correct
 	 * position in the tree.
 	 */
-	__mem_cgroup_remove_exceeded(mz, mctz);
-	if (!soft_limit_excess(mz->memcg, N_MEMORY) ||
+	__mem_cgroup_remove_exceeded(mz, mctz, type);
+	if (!soft_limit_excess(mz->memcg, type) ||
 	    !css_tryget(&mz->memcg->css))
 		goto retry;
 done:
@@ -773,12 +830,13 @@ __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 }
 
 static struct mem_cgroup_per_node *
-mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
+mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz,
+				   enum node_states type)
 {
 	struct mem_cgroup_per_node *mz;
 
 	spin_lock_irq(&mctz->lock);
-	mz = __mem_cgroup_largest_soft_limit_node(mctz);
+	mz = __mem_cgroup_largest_soft_limit_node(mctz, type);
 	spin_unlock_irq(&mctz->lock);
 	return mz;
 }
@@ -3472,7 +3530,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	struct mem_cgroup_per_node *mz, *next_mz = NULL;
 	unsigned long reclaimed;
 	int loop = 0;
-	struct mem_cgroup_tree_per_node *mctz;
+	struct mem_cgroup_tree_per_node *mctz, *mctz_sibling;
 	unsigned long excess;
 	unsigned long nr_scanned;
 	int migration_nid;
@@ -3481,6 +3539,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		return 0;
 
 	mctz = soft_limit_tree_node(pgdat->node_id, N_MEMORY);
+	mctz_sibling = soft_limit_tree_node(pgdat->node_id, N_TOPTIER);
 
 	/*
 	 * Do not even bother to check the largest node if the root
@@ -3516,7 +3575,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		if (next_mz)
 			mz = next_mz;
 		else
-			mz = mem_cgroup_largest_soft_limit_node(mctz);
+			mz = mem_cgroup_largest_soft_limit_node(mctz, N_MEMORY);
 		if (!mz)
 			break;
 
@@ -3526,7 +3585,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
-		__mem_cgroup_remove_exceeded(mz, mctz);
+		__mem_cgroup_remove_exceeded(mz, mctz, N_MEMORY);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
@@ -3534,7 +3593,8 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		 */
 		next_mz = NULL;
 		if (!reclaimed)
-			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
+			next_mz =
+			   __mem_cgroup_largest_soft_limit_node(mctz, N_MEMORY);
 
 		excess = soft_limit_excess(mz->memcg, N_MEMORY);
 		/*
@@ -3546,8 +3606,20 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		 * term TODO.
 		 */
 		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz, mctz, excess);
+		__mem_cgroup_insert_exceeded(mz, mctz, excess, N_MEMORY);
 		spin_unlock_irq(&mctz->lock);
+
+		/* update both affected N_MEMORY and N_TOPTIER trees */
+		if (mctz_sibling) {
+			spin_lock_irq(&mctz_sibling->lock);
+			__mem_cgroup_remove_exceeded(mz, mctz_sibling,
+						     N_TOPTIER);
+			excess = soft_limit_excess(mz->memcg, N_TOPTIER);
+			__mem_cgroup_insert_exceeded(mz, mctz, excess,
+						     N_TOPTIER);
+			spin_unlock_irq(&mctz_sibling->lock);
+		}
+
 		css_put(&mz->memcg->css);
 		loop++;
 		/*
@@ -5312,6 +5384,8 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	lruvec_init(&pn->lruvec);
 	pn->usage_in_excess = 0;
 	pn->on_tree = false;
+	pn->toptier_usage_in_excess = 0;
+	pn->on_toptier_tree = false;
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
-- 
2.20.1


From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v8 26/34] lru: add an element to a memcg list
Date: Fri, 24 May 2013 15:59:20 +0530
Message-ID: <1369391368-31562-27-git-send-email-glommer@openvz.org>
References: <1369391368-31562-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369391368-31562-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

With the infrastructure we now have, we can add an element to a memcg
LRU list instead of the global list. The memcg lists are still
per-node.

Technically, we will never trigger per-node shrinking in the memcg is
short of memory. Therefore an alternative to this would be to add the
element to *both* a single-node memcg array and a per-node global array.

There are two main reasons for this design choice:

1) adding an extra list_head to each of the objects would waste 16-bytes
per object, always remembering that we are talking about 1 dentry + 1
inode in the common case. This means a close to 10 % increase in the
dentry size, and a lower yet significant increase in the inode size. In
terms of total memory, this design pays 32-byte per-superblock-per-node
(size of struct list_lru_node), which means that in any scenario where
we have more than 10 dentries + inodes, we would already be paying more
memory in the two-list-heads approach than we will here with 1 node x 10
superblocks. The turning point of course depends on the workload, but I
hope the figures above would convince you that the memory footprint is
in my side in any workload that matters.

2) The main drawback of this, namely, that we loose global LRU order, is
not really seen by me as a disadvantage: if we are using memcg to
isolate the workloads, global pressure should try to balance the amount
reclaimed from all memcgs the same way the shrinkers will already
naturally balance the amount reclaimed from each superblock. (This
patchset needs some love in this regard, btw).

To help us easily tracking down which nodes have and which nodes doesn't
have elements in the list, we will count on an auxiliary node bitmap in
the global level.

[ v8: create LRUs before creating caches, and avoid races in which
  elements are added to a non existing LRU ]
[ v2: move memcg_kmem_lru_of_page to list_lru.c and then unpublish the
  auxiliary functions it uses ]
Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 include/linux/list_lru.h   |  11 +++++
 include/linux/memcontrol.h |   8 ++++
 lib/list_lru.c             | 114 +++++++++++++++++++++++++++++++++++++++++----
 mm/memcontrol.c            |  43 +++++++++++++----
 4 files changed, 158 insertions(+), 18 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 57fe0e3..3b8c301 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -53,12 +53,23 @@ struct list_lru {
 	 * structure, we may very well fail.
 	 */
 	struct list_lru_node	node[MAX_NUMNODES];
+	atomic_long_t		node_totals[MAX_NUMNODES];
 	nodemask_t		active_nodes;
 #ifdef CONFIG_MEMCG_KMEM
 	/* All memcg-aware LRUs will be chained in the lrus list */
 	struct list_head	lrus;
 	/* M x N matrix as described above */
 	struct list_lru_array	**memcg_lrus;
+	/*
+	 * The memcg_lrus is RCU protected, so we need to keep the previous
+	 * array around when we update it. But we can only do that after
+	 * synchronize_rcu(). A typical system has many LRUs, which means
+	 * that if we call synchronize_rcu after each LRU update, this
+	 * will become very expensive. We add this pointer here, and then
+	 * after all LRUs are update, we call synchronize_rcu() once, and
+	 * free all the old_arrays.
+	 */
+	void *old_array;
 #endif
 };
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3442eb9..50f199f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -24,6 +24,7 @@
 #include <linux/hardirq.h>
 #include <linux/jump_label.h>
 #include <linux/list_lru.h>
+#include <linux/mm.h>
 
 struct mem_cgroup;
 struct page_cgroup;
@@ -474,6 +475,8 @@ __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 int memcg_new_lru(struct list_lru *lru);
 int memcg_init_lru(struct list_lru *lru);
 
+struct mem_cgroup *mem_cgroup_from_kmem_page(struct page *page);
+
 int memcg_kmem_update_lru_size(struct list_lru *lru, int num_groups,
 			       bool new_lru);
 
@@ -645,6 +648,11 @@ static inline int memcg_init_lru(struct list_lru *lru)
 {
 	return 0;
 }
+
+static inline struct mem_cgroup *mem_cgroup_from_kmem_page(struct page *page)
+{
+	return NULL;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff --git a/lib/list_lru.c b/lib/list_lru.c
index db35edc..9274bd2 100644
--- a/lib/list_lru.c
+++ b/lib/list_lru.c
@@ -14,19 +14,95 @@
 #include <linux/list_lru.h>
 #include <linux/memcontrol.h>
 
+/*
+ * lru_node_of_index - returns the node-lru of a specific lru
+ * @lru: the global lru we are operating at
+ * @index: if positive, the memcg id. If negative, means global lru.
+ * @nid: node id of the corresponding node we want to manipulate
+ */
+static struct list_lru_node *
+lru_node_of_index(struct list_lru *lru, int index, int nid)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	struct list_lru_node *nlru;
+
+	if (index < 0)
+		return &lru->node[nid];
+
+	/*
+	 * If we reach here with index >= 0, it means the page where the object
+	 * comes from is associated with a memcg. Because memcg_lrus is
+	 * populated before the caches, we can be sure that this request is
+	 * truly for a LRU list that does not have memcg caches.
+	 */
+	if (!lru->memcg_lrus)
+		return &lru->node[nid];
+
+	/*
+	 * Because we will only ever free the memcg_lrus after synchronize_rcu,
+	 * we are safe with the rcu lock here: even if we are operating in the
+	 * stale version of the array, the data is still valid and we are not
+	 * risking anything.
+	 *
+	 * The read barrier is needed to make sure that we see the pointer
+	 * assigment for the specific memcg
+	 */
+	rcu_read_lock();
+	rmb();
+	/*
+	 * The array exist, but the particular memcg does not. That is an
+	 * impossible situation: it would mean we are trying to add to a list
+	 * belonging to a memcg that does not exist. Either wasn't created or
+	 * has been already freed. In both cases it should no longer have
+	 * objects. BUG_ON to avoid a NULL dereference.
+	 */
+	BUG_ON(!lru->memcg_lrus[index]);
+	nlru = &lru->memcg_lrus[index]->node[nid];
+	rcu_read_unlock();
+	return nlru;
+#else
+	BUG_ON(index >= 0); /* nobody should be passing index < 0 with !KMEM */
+	return &lru->node[nid];
+#endif
+}
+
+struct list_lru_node *
+memcg_kmem_lru_of_page(struct list_lru *lru, struct page *page)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_kmem_page(page);
+	int nid = page_to_nid(page);
+	int memcg_id;
+	struct list_lru_node *nlru;
+
+	if (!memcg || !memcg_kmem_is_active(memcg))
+		return &lru->node[nid];
+
+	memcg_id = memcg_cache_id(memcg);
+
+	return lru_node_of_index(lru, memcg_id, nid);
+}
+
 int
 list_lru_add(
 	struct list_lru	*lru,
 	struct list_head *item)
 {
-	int nid = page_to_nid(virt_to_page(item));
-	struct list_lru_node *nlru = &lru->node[nid];
+	struct page *page = virt_to_page(item);
+	struct list_lru_node *nlru;
+	int nid = page_to_nid(page);
+
+	nlru = memcg_kmem_lru_of_page(lru, page);
 
 	spin_lock(&nlru->lock);
 	BUG_ON(nlru->nr_items < 0);
 	if (list_empty(item)) {
 		list_add_tail(item, &nlru->list);
-		if (nlru->nr_items++ == 0)
+		nlru->nr_items++;
+		/*
+		 * We only consider a node active or inactive based on the
+		 * total figure for all involved children.
+		 */
+		if (atomic_long_add_return(1, &lru->node_totals[nid]) == 1)
 			node_set(nid, lru->active_nodes);
 		spin_unlock(&nlru->lock);
 		return 1;
@@ -41,14 +117,20 @@ list_lru_del(
 	struct list_lru	*lru,
 	struct list_head *item)
 {
-	int nid = page_to_nid(virt_to_page(item));
-	struct list_lru_node *nlru = &lru->node[nid];
+	struct page *page = virt_to_page(item);
+	struct list_lru_node *nlru;
+	int nid = page_to_nid(page);
+
+	nlru = memcg_kmem_lru_of_page(lru, page);
 
 	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
 		list_del_init(item);
-		if (--nlru->nr_items == 0)
+		nlru->nr_items--;
+
+		if (atomic_long_dec_and_test(&lru->node_totals[nid]))
 			node_clear(nid, lru->active_nodes);
+
 		BUG_ON(nlru->nr_items < 0);
 		spin_unlock(&nlru->lock);
 		return 1;
@@ -93,9 +175,10 @@ restart:
 		ret = isolate(item, &nlru->lock, cb_arg);
 		switch (ret) {
 		case LRU_REMOVED:
-			if (--nlru->nr_items == 0)
-				node_clear(nid, lru->active_nodes);
+			nlru->nr_items--;
 			BUG_ON(nlru->nr_items < 0);
+			if (atomic_long_dec_and_test(&lru->node_totals[nid]))
+				node_clear(nid, lru->active_nodes);
 			isolated++;
 			break;
 		case LRU_ROTATE:
@@ -224,6 +307,17 @@ int memcg_update_all_lrus(unsigned long num)
 			goto out;
 	}
 out:
+	/*
+	 * Even if we were to use call_rcu, we still have to keep the old array
+	 * pointer somewhere. It is easier for us to just synchronize rcu here
+	 * since we are in a fine context. Now we guarantee that there are no
+	 * more users of old_array, and proceed freeing it for all LRUs
+	 */
+	synchronize_rcu();
+	list_for_each_entry(lru, &all_memcg_lrus, lrus) {
+		kfree(lru->old_array);
+		lru->old_array = NULL;
+	}
 	mutex_unlock(&all_memcg_lrus_mutex);
 	return ret;
 }
@@ -254,8 +348,10 @@ int __list_lru_init(struct list_lru *lru, bool memcg_enabled)
 	int i;
 
 	nodes_clear(lru->active_nodes);
-	for (i = 0; i < MAX_NUMNODES; i++)
+	for (i = 0; i < MAX_NUMNODES; i++) {
 		list_lru_init_one(&lru->node[i]);
+		atomic_long_set(&lru->node_totals[i], 0);
+	}
 
 	if (memcg_enabled)
 		return memcg_init_lru(lru);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5d31b4a..846c82c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3162,19 +3162,22 @@ int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 	 */
 	memcg_kmem_set_activated(memcg);
 
-	ret = memcg_update_all_caches(num+1);
-	if (ret)
-		goto out;
-
 	/*
-	 * We should make sure that the array size is not updated until we are
-	 * done; otherwise we have no easy way to know whether or not we should
-	 * grow the array.
+	 * We have to make absolutely sure that we update the LRUs before we
+	 * update the caches. Once the caches are updated, they will be able to
+	 * start hosting objects. If a cache is created very quickly, and and
+	 * element is used and disposed to the LRU quickly as well, we may end
+	 * up with a NULL pointer in list_lru_add because the lists are not yet
+	 * ready.
 	 */
 	ret = memcg_update_all_lrus(num + 1);
 	if (ret)
 		goto out;
 
+	ret = memcg_update_all_caches(num+1);
+	if (ret)
+		goto out;
+
 	memcg->kmemcg_id = num;
 
 	memcg_update_array_size(num + 1);
@@ -3320,7 +3323,7 @@ int memcg_kmem_update_lru_size(struct list_lru *lru, int num_groups,
 		}
 
 		for (i = 0; lru->memcg_lrus && (i < num_memcgs); i++) {
-			if (lru->memcg_lrus && lru->memcg_lrus[i])
+			if (lru->memcg_lrus && !lru->memcg_lrus[i])
 				continue;
 			new_lru_array[i] =  lru->memcg_lrus[i];
 		}
@@ -3333,9 +3336,15 @@ int memcg_kmem_update_lru_size(struct list_lru *lru, int num_groups,
 		 * either follow the new array or the old one and they contain
 		 * exactly the same information. The new space in the end is
 		 * always empty anyway.
+		 *
+		 * We do have to make sure that no more users of the old
+		 * memcg_lrus array exist before we free, and this is achieved
+		 * by rcu. Since it would be too slow to synchronize RCU for
+		 * every LRU, we store the pointer and let the LRU code free
+		 * all of them when all LRUs are updated.
 		 */
 		if (lru->memcg_lrus)
-			kfree(old_array);
+			lru->old_array = old_array;
 	}
 
 	if (lru->memcg_lrus) {
@@ -3479,6 +3488,22 @@ static inline void memcg_resume_kmem_account(void)
 	current->memcg_kmem_skip_account--;
 }
 
+struct mem_cgroup *mem_cgroup_from_kmem_page(struct page *page)
+{
+	struct page_cgroup *pc;
+	struct mem_cgroup *memcg = NULL;
+
+	pc = lookup_page_cgroup(page);
+	if (!PageCgroupUsed(pc))
+		return NULL;
+
+	lock_page_cgroup(pc);
+	if (PageCgroupUsed(pc))
+		memcg = pc->mem_cgroup;
+	unlock_page_cgroup(pc);
+	return memcg;
+}
+
 static void kmem_cache_destroy_work_func(struct work_struct *w)
 {
 	struct kmem_cache *cachep;
-- 
1.8.1.4

From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v10 11/35] list_lru: per-node list infrastructure
Date: Thu, 6 Jun 2013 12:21:43 +0400
Message-ID: <51B04697.90106@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-12-git-send-email-glommer@openvz.org> <20130605160804.be25fb655f075efe70ec57c0@linux-foundation.org> <20130606032107.GQ29338@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------060106060804000607000707"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130606032107.GQ29338@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--------------060106060804000607000707
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 06/06/2013 07:21 AM, Dave Chinner wrote:
>> It's unclear that active_nodes is really needed - we could just iterate
>> > across all items in list_lru.node[].  Are we sure that the correct
>> > tradeoff decision was made here?
> Yup. Think of all the cache line misses that checking
> node[x].nr_items != 0 entails. If MAX_NUMNODES = 1024, there's 1024
> cacheline misses right there. The nodemask is a much more cache
> friendly method of storing active node state.
> 
> not to mention that for small machines with a large MAX_NUMNODES,
> we'd be checking nodes that never have items stored on them...
> 
>> > What's the story on NUMA node hotplug, btw?
> Do we care? hotplug doesn't change MAX_NUMNODES, and if you are
> removing a node you have to free all the memory on the node,
> so that should already be tken care of by external code....
> 

Mel have already complained about this.
I have a patch that makes it dynamic but I didn't include it in here
because the series was already too big. I was also hoping to get it
ontop of the others, to avoid disruption.

I am attaching here for your appreciation.

For the record, nr_node_ids is firmware provided and it is actually
possible nodes, not online nodes. So hotplug won't change that.



--------------060106060804000607000707
Content-Type: text/x-patch;
	name="0001-list_lru-dynamically-adjust-node-arrays.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-list_lru-dynamically-adjust-node-arrays.patch"

From cfc280ee20d93b1901c5ad2dcb13635ce7703d92 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Date: Wed, 22 May 2013 09:55:15 +0400
Subject: [PATCH] list_lru: dynamically adjust node arrays

We currently use a compile-time constant to size the node array for the
list_lru structure. Due to this, we don't need to allocate any memory at
initialization time. But as a consequence, the structures that contain
embedded list_lru lists can become way too big (the superblock for
instance contains two of them).

This patch aims at ameliorating this situation by dynamically allocating
the node arrays with the firmware provided nr_node_ids.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 fs/super.c               |  9 +++++++--
 fs/xfs/xfs_buf.c         |  6 +++++-
 fs/xfs/xfs_qm.c          | 10 ++++++++--
 include/linux/list_lru.h | 21 ++++---------------
 lib/list_lru.c           | 52 ++++++++++++++++++++++++++++++++++++++++++------
 5 files changed, 70 insertions(+), 28 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index ff40e33..f8dfcec 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -209,8 +209,10 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 
-		list_lru_init_memcg(&s->s_dentry_lru);
-		list_lru_init_memcg(&s->s_inode_lru);
+		if (list_lru_init_memcg(&s->s_dentry_lru))
+			goto err_out;
+		if (list_lru_init_memcg(&s->s_inode_lru))
+			goto err_out_dentry_lru;
 
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
@@ -251,6 +253,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	}
 out:
 	return s;
+
+err_out_dentry_lru:
+	list_lru_destroy(&s->s_dentry_lru);
 err_out:
 	security_sb_free(s);
 #ifdef CONFIG_SMP
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0d7a619..b8cde02 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1592,6 +1592,7 @@ xfs_free_buftarg(
 	struct xfs_mount	*mp,
 	struct xfs_buftarg	*btp)
 {
+	list_lru_destroy(&btp->bt_lru);
 	unregister_shrinker(&btp->bt_shrinker);
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
@@ -1666,9 +1667,12 @@ xfs_alloc_buftarg(
 	if (!btp->bt_bdi)
 		goto error;
 
-	list_lru_init(&btp->bt_lru);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
+
+	if (list_lru_init(&btp->bt_lru))
+		goto error;
+
 	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
 	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 85ca39e..29ea575 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -780,11 +780,18 @@ xfs_qm_init_quotainfo(
 
 	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
 
+	if ((error = list_lru_init(&qinf->qi_lru))) {
+		kmem_free(qinf);
+		mp->m_quotainfo = NULL;
+		return error;
+	}
+
 	/*
 	 * See if quotainodes are setup, and if not, allocate them,
 	 * and change the superblock accordingly.
 	 */
 	if ((error = xfs_qm_init_quotainos(mp))) {
+		list_lru_destroy(&qinf->qi_lru);
 		kmem_free(qinf);
 		mp->m_quotainfo = NULL;
 		return error;
@@ -794,8 +801,6 @@ xfs_qm_init_quotainfo(
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
 
-	list_lru_init(&qinf->qi_lru);
-
 	/* mutex used to serialize quotaoffs */
 	mutex_init(&qinf->qi_quotaofflock);
 
@@ -883,6 +888,7 @@ xfs_qm_destroy_quotainfo(
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
 
+	list_lru_destroy(&qi->qi_lru);
 	unregister_shrinker(&qi->qi_shrinker);
 
 	if (qi->qi_uquotaip) {
diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index dcb67dc..6d6efda 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -42,18 +42,8 @@ struct list_lru_array {
 };
 
 struct list_lru {
-	/*
-	 * Because we use a fixed-size array, this struct can be very big if
-	 * MAX_NUMNODES is big. If this becomes a problem this is fixable by
-	 * turning this into a pointer and dynamically allocating this to
-	 * nr_node_ids. This quantity is firwmare-provided, and still would
-	 * provide room for all nodes at the cost of a pointer lookup and an
-	 * extra allocation. Because that allocation will most likely come from
-	 * a different slab cache than the main structure holding this
-	 * structure, we may very well fail.
-	 */
-	struct list_lru_node	node[MAX_NUMNODES];
-	atomic_long_t		node_totals[MAX_NUMNODES];
+	struct list_lru_node	*node;
+	atomic_long_t		*node_totals;
 	nodemask_t		active_nodes;
 #ifdef CONFIG_MEMCG_KMEM
 	/* All memcg-aware LRUs will be chained in the lrus list */
@@ -78,14 +68,11 @@ struct mem_cgroup;
 struct list_lru_array *lru_alloc_array(void);
 int memcg_update_all_lrus(unsigned long num);
 void memcg_destroy_all_lrus(struct mem_cgroup *memcg);
-void list_lru_destroy(struct list_lru *lru);
 int __memcg_init_lru(struct list_lru *lru);
-#else
-static inline void list_lru_destroy(struct list_lru *lru)
-{
-}
 #endif
 
+void list_lru_destroy(struct list_lru *lru);
+
 int __list_lru_init(struct list_lru *lru, bool memcg_enabled);
 static inline int list_lru_init(struct list_lru *lru)
 {
diff --git a/lib/list_lru.c b/lib/list_lru.c
index f919f99..1b38d67 100644
--- a/lib/list_lru.c
+++ b/lib/list_lru.c
@@ -334,7 +334,6 @@ int __memcg_init_lru(struct list_lru *lru)
 {
 	int ret;
 
-	INIT_LIST_HEAD(&lru->lrus);
 	mutex_lock(&all_memcg_lrus_mutex);
 	list_add(&lru->lrus, &all_memcg_lrus);
 	ret = memcg_new_lru(lru);
@@ -369,8 +368,11 @@ out:
 	return ret;
 }
 
-void list_lru_destroy(struct list_lru *lru)
+static void list_lru_destroy_memcg(struct list_lru *lru)
 {
+	if (list_empty(&lru->lrus))
+		return;
+
 	mutex_lock(&all_memcg_lrus_mutex);
 	list_del(&lru->lrus);
 	mutex_unlock(&all_memcg_lrus_mutex);
@@ -388,20 +390,58 @@ void memcg_destroy_all_lrus(struct mem_cgroup *memcg)
 	}
 	mutex_unlock(&all_memcg_lrus_mutex);
 }
+
+int memcg_list_lru_init(struct list_lru *lru, bool memcg_enabled)
+{
+	INIT_LIST_HEAD(&lru->lrus);
+	if (memcg_enabled)
+		return memcg_init_lru(lru);
+
+	return 0;
+}
+#else
+static void list_lru_destroy_memcg(struct list_lru *lru)
+{
+}
+
+int memcg_list_lru_init(struct list_lru *lru, bool memcg_enabled)
+{
+	return 0;
+}
 #endif
 
 int __list_lru_init(struct list_lru *lru, bool memcg_enabled)
 {
 	int i;
 
+	size_t size;
+
+	size = sizeof(*lru->node) * nr_node_ids;
+	lru->node = kzalloc(size, GFP_KERNEL);
+	if (!lru->node)
+		return -ENOMEM;
+
+	size = sizeof(*lru->node) * nr_node_ids;
+	lru->node_totals = kzalloc(size, GFP_KERNEL);
+	if (!lru->node_totals) {
+		kfree(lru->node);
+		return -ENOMEM;
+	}
+
 	nodes_clear(lru->active_nodes);
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		list_lru_init_one(&lru->node[i]);
 		atomic_long_set(&lru->node_totals[i], 0);
 	}
 
-	if (memcg_enabled)
-		return memcg_init_lru(lru);
-	return 0;
+	return memcg_list_lru_init(lru, memcg_enabled);
 }
 EXPORT_SYMBOL_GPL(__list_lru_init);
+
+void list_lru_destroy(struct list_lru *lru)
+{
+	kfree(lru->node);
+	kfree(lru->node_totals);
+	list_lru_destroy_memcg(lru);
+}
+EXPORT_SYMBOL_GPL(list_lru_destroy);
-- 
1.8.1.4


--------------060106060804000607000707--

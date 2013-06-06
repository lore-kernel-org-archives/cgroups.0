From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v11 12/25] list_lru: per-node API
Date: Fri,  7 Jun 2013 00:34:45 +0400
Message-ID: <1370550898-26711-13-git-send-email-glommer@openvz.org>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370550898-26711-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-Y4LbUc7mvzI@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch adapts the list_lru API to accept an optional node argument,
to be used by NUMA aware shrinking functions. Code that does not care
about the NUMA placement of objects can still call into the very same
functions as before. They will simply iterate over all nodes.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 include/linux/list_lru.h | 39 ++++++++++++++++++++++++++++++++++-----
 mm/list_lru.c            | 37 +++++++++----------------------------
 2 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index f4d4cb6..2fe13e1 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -75,20 +75,32 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item);
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
 /**
- * list_lru_count: return the number of objects currently held by @lru
+ * list_lru_count_node: return the number of objects currently held by @lru
  * @lru: the lru pointer.
+ * @nid: the node id to count from.
  *
  * Always return a non-negative number, 0 for empty lists. There is no
  * guarantee that the list is not updated while the count is being computed.
  * Callers that want such a guarantee need to provide an outer lock.
  */
-unsigned long list_lru_count(struct list_lru *lru);
+unsigned long list_lru_count_node(struct list_lru *lru, int nid);
+static inline unsigned long list_lru_count(struct list_lru *lru)
+{
+	long count = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes)
+		count += list_lru_count_node(lru, nid);
+
+	return count;
+}
 
 typedef enum lru_status
 (*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
 /**
- * list_lru_walk: walk a list_lru, isolating and disposing freeable items.
+ * list_lru_walk_node: walk a list_lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
+ * @nid: the node id to scan from.
  * @isolate: callback function that is resposible for deciding what to do with
  *  the item currently being scanned
  * @cb_arg: opaque type that will be passed to @isolate
@@ -106,8 +118,25 @@ typedef enum lru_status
  *
  * Return value: the number of objects effectively removed from the LRU.
  */
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-		   void *cb_arg, unsigned long nr_to_walk);
+unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
+				 list_lru_walk_cb isolate, void *cb_arg,
+				 unsigned long *nr_to_walk);
+
+static inline unsigned long
+list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
+	      void *cb_arg, unsigned long nr_to_walk)
+{
+	long isolated = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes) {
+		isolated += list_lru_walk_node(lru, nid, isolate,
+					       cb_arg, &nr_to_walk);
+		if (nr_to_walk <= 0)
+			break;
+	}
+	return isolated;
+}
 
 typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
 /**
diff --git a/mm/list_lru.c b/mm/list_lru.c
index f2d1d6e..2822817 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -47,25 +47,22 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item)
 }
 EXPORT_SYMBOL_GPL(list_lru_del);
 
-unsigned long list_lru_count(struct list_lru *lru)
+unsigned long
+list_lru_count_node(struct list_lru *lru, int nid)
 {
 	unsigned long count = 0;
-	int nid;
-
-	for_each_node_mask(nid, lru->active_nodes) {
-		struct list_lru_node *nlru = &lru->node[nid];
+	struct list_lru_node *nlru = &lru->node[nid];
 
-		spin_lock(&nlru->lock);
-		BUG_ON(nlru->nr_items < 0);
-		count += nlru->nr_items;
-		spin_unlock(&nlru->lock);
-	}
+	spin_lock(&nlru->lock);
+	BUG_ON(nlru->nr_items < 0);
+	count += nlru->nr_items;
+	spin_unlock(&nlru->lock);
 
 	return count;
 }
-EXPORT_SYMBOL_GPL(list_lru_count);
+EXPORT_SYMBOL_GPL(list_lru_count_node);
 
-static unsigned long
+unsigned long
 list_lru_walk_node(struct list_lru *lru, int nid, list_lru_walk_cb isolate,
 		   void *cb_arg, unsigned long *nr_to_walk)
 {
@@ -120,22 +117,6 @@ restart:
 }
 EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-			    void *cb_arg, unsigned long nr_to_walk)
-{
-	unsigned long isolated = 0;
-	int nid;
-
-	for_each_node_mask(nid, lru->active_nodes) {
-		isolated += list_lru_walk_node(lru, nid, isolate,
-					       cb_arg, &nr_to_walk);
-		if (nr_to_walk <= 0)
-			break;
-	}
-	return isolated;
-}
-EXPORT_SYMBOL_GPL(list_lru_walk);
-
 static unsigned long list_lru_dispose_all_node(struct list_lru *lru, int nid,
 					       list_lru_dispose_cb dispose)
 {
-- 
1.8.1.4

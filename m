From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v9 14/35] list_lru: per-node API
Date: Thu, 30 May 2013 14:36:00 +0400
Message-ID: <1369910181-20026-15-git-send-email-glommer@openvz.org>
References: <1369910181-20026-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369910181-20026-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch adapts the list_lru API to accept an optional node argument,
to be used by NUMA aware shrinking functions. Code that does not care
about the NUMA placement of objects can still call into the very same
functions as before. They will simply iterate over all nodes.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 include/linux/list_lru.h | 35 ++++++++++++++++++++++++++++++++---
 lib/list_lru.c           | 41 +++++++++--------------------------------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 668f1f1..cf59a8a 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -42,15 +42,44 @@ struct list_lru {
 int list_lru_init(struct list_lru *lru);
 int list_lru_add(struct list_lru *lru, struct list_head *item);
 int list_lru_del(struct list_lru *lru, struct list_head *item);
-unsigned long list_lru_count(struct list_lru *lru);
+
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
 
 typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
 
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-		   void *cb_arg, unsigned long nr_to_walk);
+
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
 
 unsigned long
 list_lru_dispose_all(struct list_lru *lru, list_lru_dispose_cb dispose);
diff --git a/lib/list_lru.c b/lib/list_lru.c
index 7611df7..dae13d6 100644
--- a/lib/list_lru.c
+++ b/lib/list_lru.c
@@ -54,25 +54,21 @@ list_lru_del(
 EXPORT_SYMBOL_GPL(list_lru_del);
 
 unsigned long
-list_lru_count(struct list_lru *lru)
+list_lru_count_node(struct list_lru *lru, int nid)
 {
 	long count = 0;
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
 list_lru_walk_node(
 	struct list_lru		*lru,
 	int			nid,
@@ -118,26 +114,7 @@ restart:
 	spin_unlock(&nlru->lock);
 	return isolated;
 }
-
-unsigned long
-list_lru_walk(
-	struct list_lru	*lru,
-	list_lru_walk_cb isolate,
-	void		*cb_arg,
-	unsigned long	nr_to_walk)
-{
-	long isolated = 0;
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
+EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
 static unsigned long
 list_lru_dispose_all_node(
-- 
1.8.1.4

From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v10 07/16] list_lru: per-memcg walks
Date: Sun,  7 Jul 2013 11:56:47 -0400
Message-ID: <1373212616-11713-8-git-send-email-glommer@openvz.org>
References: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=q6Cd9IOdjZTom4kPFG2Qz/MyPNtmcX37g05xLIkdTHc=;
        b=daJ420Hf2Gs/CSMvJ/SsAwfDjRevi/l4DknVzSpmfByGOloWXjJ1P7ryTbm0NcnwoX
         HKcCzLOtAL+tkBrtmAncT4z1+NNACHovXTMxhSi3RQWV3oX6HgRot6GrW+meQBLSGPT0
         aT4TNAfa3rTfLqV1W50Otecr2030ZrMUUoJneEM32xzwnIHG5tGK7Nw3UljcfQv8bfDM
         XdC0pc7JlplM8p685Lb6H1kX6YRZt6+8u2z8DUpC6igRXb4BjZtt6BbxtevjZAQ8Sw6t
         uuX+vQGNsKqQuMo6JobRA/8JLejkucjU2g35aBnzzGAXxBlwe5AwrBUA7kFdZgG4xfIX
         X+HA==
In-Reply-To: <1373212616-11713-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-Y4LbUc7mvzI@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

This patch extends the list_lru interfaces to allow for a memcg
parameter. Because most of its users won't need it, instead of
modifying the function signatures we create a new set of _memcg()
functions and write the old API on top of that.

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
 include/linux/list_lru.h   | 30 +++++++++++++++++++++++++-----
 include/linux/memcontrol.h |  2 ++
 mm/list_lru.c              | 25 ++++++++++++++++++-------
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index e7a1199..57d0bb0 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -128,15 +128,24 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item);
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
 /**
- * list_lru_count_node: return the number of objects currently held by @lru
+ * list_lru_count_node_memcg: return the number of objects currently held by @lru
  * @lru: the lru pointer.
  * @nid: the node id to count from.
+ * @memcg: restricts the count to this memcg, NULL for global.
  *
  * Always return a non-negative number, 0 for empty lists. There is no
  * guarantee that the list is not updated while the count is being computed.
  * Callers that want such a guarantee need to provide an outer lock.
  */
-unsigned long list_lru_count_node(struct list_lru *lru, int nid);
+unsigned long list_lru_count_node_memcg(struct list_lru *lru, int nid,
+					struct mem_cgroup *memcg);
+
+static inline unsigned long
+list_lru_count_node(struct list_lru *lru, int nid)
+{
+	return list_lru_count_node_memcg(lru, nid, NULL);
+}
+
 static inline unsigned long list_lru_count(struct list_lru *lru)
 {
 	long count = 0;
@@ -158,6 +167,7 @@ typedef enum lru_status
  *  the item currently being scanned
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
+ * @memcg: restricts the scan to this memcg, NULL for global.
  *
  * This function will scan all elements in a particular list_lru, calling the
  * @isolate callback for each of those items, along with the current list
@@ -171,9 +181,19 @@ typedef enum lru_status
  *
  * Return value: the number of objects effectively removed from the LRU.
  */
-unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
-				 list_lru_walk_cb isolate, void *cb_arg,
-				 unsigned long *nr_to_walk);
+unsigned long
+list_lru_walk_node_memcg(struct list_lru *lru, int nid,
+			 list_lru_walk_cb isolate, void *cb_arg,
+			 unsigned long *nr_to_walk, struct mem_cgroup *memcg);
+
+static inline unsigned long
+list_lru_walk_node(struct list_lru *lru, int nid,
+		 list_lru_walk_cb isolate, void *cb_arg,
+		 unsigned long *nr_to_walk)
+{
+	return list_lru_walk_node_memcg(lru, nid, isolate, cb_arg,
+					nr_to_walk, NULL);
+}
 
 static inline unsigned long
 list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e069d53..a8c5493 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -591,6 +591,8 @@ static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
 
+#define memcg_limited_groups_array_size 0
+
 static inline bool memcg_kmem_enabled(void)
 {
 	return false;
diff --git a/mm/list_lru.c b/mm/list_lru.c
index bdd97cf..8ec51fa 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -128,10 +128,16 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item)
 EXPORT_SYMBOL_GPL(list_lru_del);
 
 unsigned long
-list_lru_count_node(struct list_lru *lru, int nid)
+list_lru_count_node_memcg(struct list_lru *lru, int nid,
+			  struct mem_cgroup *memcg)
 {
 	unsigned long count = 0;
-	struct list_lru_node *nlru = &lru->node[nid];
+	int memcg_id = memcg_cache_id(memcg);
+	struct list_lru_node *nlru;
+
+	nlru = lru_node_of_index(lru, memcg_id, nid);
+	if (!nlru)
+		return 0;
 
 	spin_lock(&nlru->lock);
 	WARN_ON_ONCE(nlru->nr_items < 0);
@@ -140,16 +146,18 @@ list_lru_count_node(struct list_lru *lru, int nid)
 
 	return count;
 }
-EXPORT_SYMBOL_GPL(list_lru_count_node);
+EXPORT_SYMBOL_GPL(list_lru_count_node_memcg);
 
 unsigned long
-list_lru_walk_node(struct list_lru *lru, int nid, list_lru_walk_cb isolate,
-		   void *cb_arg, unsigned long *nr_to_walk)
+list_lru_walk_node_memcg(struct list_lru *lru, int nid,
+			 list_lru_walk_cb isolate, void *cb_arg,
+			 unsigned long *nr_to_walk, struct mem_cgroup *memcg)
 {
 
-	struct list_lru_node	*nlru = &lru->node[nid];
 	struct list_head *item, *n;
 	unsigned long isolated = 0;
+	struct list_lru_node *nlru;
+	int memcg_id = memcg_cache_id(memcg);
 	/*
 	 * If we don't keep state of at which pass we are, we can loop at
 	 * LRU_RETRY, since we have no guarantees that the caller will be able
@@ -159,6 +167,9 @@ list_lru_walk_node(struct list_lru *lru, int nid, list_lru_walk_cb isolate,
 	 */
 	bool first_pass = true;
 
+	nlru = lru_node_of_index(lru, memcg_id, nid);
+	if (!nlru)
+		return 0;
 	spin_lock(&nlru->lock);
 restart:
 	list_for_each_safe(item, n, &nlru->list) {
@@ -196,7 +207,7 @@ restart:
 	spin_unlock(&nlru->lock);
 	return isolated;
 }
-EXPORT_SYMBOL_GPL(list_lru_walk_node);
+EXPORT_SYMBOL_GPL(list_lru_walk_node_memcg);
 
 /*
  * Each list_lru that is memcg-aware is inserted into the all_memcgs_lrus,
-- 
1.8.2.1

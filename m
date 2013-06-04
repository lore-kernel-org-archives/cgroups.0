From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] memcg: restructure mem_cgroup_iter()
Date: Mon,  3 Jun 2013 17:44:38 -0700
Message-ID: <1370306679-13129-3-git-send-email-tj@kernel.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=Gslv8t19ITihRkhXNYmVQXHPvYJodcueDx2zwLrabxQ=;
        b=R+2qoe+s1DyJanNRLmejW9tX/9BzBcHCZ+acv6AZ5tc0OCoCRTZ14U5Sdhq/RWDiIF
         tGHozrqPg2VCM9k/hi/tk0uqugGVklPVkyXLOOElKrN+fCi2DNo/lYOum1miJPMnLUYj
         W9oZiD8JZsb/gWBPhfFuBsyXs1XIzN0KV0K3m3qos18kKRluzsf1p3KzJrOLHQI7a+er
         XuK/2a9GGb2gPflSdeKINh/oynN7VnuvwJ57TCg5/Od1S1If5cOEG8kBaGyX6tHbM1KA
         iwjO2Tb6PcFLOnWUjJO3QExA8J15AUZER5rysCch0mw/o6+SzBE5UcFvNAedSEQNXSqL
         7xJw==
In-Reply-To: <1370306679-13129-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

mem_cgroup_iter() implements two iteration modes - plain and reclaim.
The former is normal pre-order tree walk.  The latter tries to share
iteration cursor per zone and priority pair among multiple reclaimers
so that they all contribute to scanning forward rather than banging on
the same cgroups simultaneously.

Implementing the two in the same function allows them to share code
paths which is fine but the current structure is unnecessarily
convoluted with conditionals on @reclaim spread across the function
rather obscurely and with a somewhat strange control flow which checks
for conditions which can't be and has duplicate tests for the same
conditions in different forms.

This patch restructures the function such that there's single test on
@reclaim and !reclaim path is contained in its block, which simplifies
both !reclaim and reclaim paths.  Also, the control flow in the
reclaim path is restructured and commented so that it's easier to
follow what's going on why.

Note that after the patch reclaim->generation is synchronized to the
iter's on success whether @prev was specified or not.  This doesn't
cause any functional differences as the two generation numbers are
guaranteed to be the same at that point if @prev and makes the code
slightly easier to follow.

This patch is pure restructuring and shouldn't introduce any
functional differences.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 131 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 60 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb2f91c..99e7357 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1170,8 +1170,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup *memcg = NULL;
-	struct mem_cgroup *last_visited = NULL;
-	unsigned long uninitialized_var(dead_count);
+	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_reclaim_iter *iter;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1179,9 +1179,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		last_visited = prev;
-
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
 			goto out_css_put;
@@ -1189,73 +1186,87 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	}
 
 	rcu_read_lock();
-	while (!memcg) {
-		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
-
-		if (reclaim) {
-			int nid = zone_to_nid(reclaim->zone);
-			int zid = zone_idx(reclaim->zone);
-			struct mem_cgroup_per_zone *mz;
-
-			mz = mem_cgroup_zoneinfo(root, nid, zid);
-			iter = &mz->reclaim_iter[reclaim->priority];
-			last_visited = iter->last_visited;
-			if (prev && reclaim->generation != iter->generation) {
-				iter->last_visited = NULL;
-				goto out_unlock;
-			}
 
+	/* non reclaim case is simple - just iterate from @prev */
+	if (!reclaim) {
+		memcg = __mem_cgroup_iter_next(root, prev);
+		goto out_unlock;
+	}
+
+	/*
+	 * @reclaim specified - find and share the per-zone-priority
+	 * iterator.
+	 */
+	mz = mem_cgroup_zoneinfo(root, zone_to_nid(reclaim->zone),
+				 zone_idx(reclaim->zone));
+	iter = &mz->reclaim_iter[reclaim->priority];
+
+	while (true) {
+		struct mem_cgroup *last_visited;
+		unsigned long dead_count;
+
+		/*
+		 * If this caller already iterated through some and @iter
+		 * wrapped since, finish this the iteration.
+		 */
+		if (prev && reclaim->generation != iter->generation) {
+			iter->last_visited = NULL;
+			break;
+		}
+
+		/*
+		 * If the dead_count mismatches, a destruction has happened
+		 * or is happening concurrently.  If the dead_count
+		 * matches, a destruction might still happen concurrently,
+		 * but since we checked under RCU, that destruction won't
+		 * free the object until we release the RCU reader lock.
+		 * Thus, the dead_count check verifies the pointer is still
+		 * valid, css_tryget() verifies the cgroup pointed to is
+		 * alive.
+		 */
+		dead_count = atomic_read(&root->dead_count);
+
+		last_visited = iter->last_visited;
+		if (last_visited) {
 			/*
-			 * If the dead_count mismatches, a destruction
-			 * has happened or is happening concurrently.
-			 * If the dead_count matches, a destruction
-			 * might still happen concurrently, but since
-			 * we checked under RCU, that destruction
-			 * won't free the object until we release the
-			 * RCU reader lock.  Thus, the dead_count
-			 * check verifies the pointer is still valid,
-			 * css_tryget() verifies the cgroup pointed to
-			 * is alive.
+			 * Paired with smp_wmb() below in this function.
+			 * The pair guarantee that last_visited is more
+			 * current than last_dead_count, which may lead to
+			 * spurious iteration resets but guarantees
+			 * reliable detection of dead condition.
 			 */
-			dead_count = atomic_read(&root->dead_count);
-
-			last_visited = iter->last_visited;
-			if (last_visited) {
-				/*
-				 * Paired with smp_wmb() below in this
-				 * function.  The pair guarantee that
-				 * last_visited is more current than
-				 * last_dead_count, which may lead to
-				 * spurious iteration resets but guarantees
-				 * reliable detection of dead condition.
-				 */
-				smp_rmb();
-				if ((dead_count != iter->last_dead_count) ||
-					!css_tryget(&last_visited->css)) {
-					last_visited = NULL;
-				}
+			smp_rmb();
+			if ((dead_count != iter->last_dead_count) ||
+			    !css_tryget(&last_visited->css)) {
+				last_visited = NULL;
 			}
 		}
 
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
-		if (reclaim) {
-			if (last_visited)
-				css_put(&last_visited->css);
+		if (last_visited)
+			css_put(&last_visited->css);
 
-			iter->last_visited = memcg;
-			/* paired with smp_rmb() above in this function */
-			smp_wmb();
-			iter->last_dead_count = dead_count;
+		iter->last_visited = memcg;
+		/* paired with smp_rmb() above in this function */
+		smp_wmb();
+		iter->last_dead_count = dead_count;
 
-			if (!memcg)
-				iter->generation++;
-			else if (!prev && memcg)
-				reclaim->generation = iter->generation;
+		/* if successful, sync the generation number and return */
+		if (likely(memcg)) {
+			reclaim->generation = iter->generation;
+			break;
 		}
 
-		if (prev && !memcg)
-			goto out_unlock;
+		/*
+		 * The iterator reached the end.  If this reclaimer already
+		 * visited some cgroups, finish the iteration; otherwise,
+		 * start a new iteration from the beginning.
+		 */
+		if (prev)
+			break;
+
+		iter->generation++;
 	}
 out_unlock:
 	rcu_read_unlock();
-- 
1.8.2.1

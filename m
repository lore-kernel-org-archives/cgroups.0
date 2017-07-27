From: Wenwei Tao <wenwei.tww@gmail.com>
Subject: [PATCH stable 3.10] mm: memcontrol: factor out reclaim iterator loading and updating
Date: Thu, 27 Jul 2017 21:59:06 +0800
Message-ID: <20170727135906.8596-1-wenwei.tww@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lgbwdbUY7feZotmj4LAOxQ1mCEvHDVWjx/U4dQpCOu0=;
        b=CpZpa2Xe+NAtsr0yh0OOoV4NVNipTBat8SpfQqz66tHZunefDRZE1iaDbTQTUGkSsj
         CBpLJcKLDPxDEJVjk2vaxq7mQ18+1ZjVnWLWmWLumlLDXlLrbyVpYz8Wse2yNr15DVNC
         mSjN/wjZd1gnq+yUb0lzzhyVoLutw8uxCH6hldTt+6z8S3E15LRGXTUhZma2qnObVAGO
         krOX654W5C9iPspGo6UhEikPtFdO9sPPjFLhemk7xdEd8hjXtgQS4HbXQs8wcDj30+QK
         wr+kZhs0HVMSDAj7Vllu9bKZSSIrOpk4mZVre7FrydtRnOR66+QeSVF+4BGg1Hawbzka
         MezQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stable@vger.kernel.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, wenwei.tww@alibaba-inc.com, yuwang.yuwang@alibaba-inc.com, Glauber Costa <glommer@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

From: Johannes Weiner <hannes@cmpxchg.org>

commit 519ebea3bf6df45439e79c54bda1d9e29fe13a64 upstream

It turned out that this is actually a bug fix which prevents a double
css_put on last_visited memcg which results in kernel BUG at kernel/cgroup.c:893!
See http://lkml.kernel.org/r/20170726130742.5976-1-wenwei.tww@gmail.com
for more details.

mem_cgroup_iter() is too hard to follow.  Factor out the lockless reclaim
iterator loading and updating so it's easier to follow the big picture.

Also document the iterator invalidation mechanism a bit more extensively.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[wt: Backported to linux-3.10.y: adjusted context]
Signed-off-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>
---
 mm/memcontrol.c | 97 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 29 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 437ae2c..fcde430 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1149,6 +1149,68 @@ skip_node:
 	return NULL;
 }
 
+static void mem_cgroup_iter_invalidate(struct mem_cgroup *root)
+{
+	/*
+	 * When a group in the hierarchy below root is destroyed, the
+	 * hierarchy iterator can no longer be trusted since it might
+	 * have pointed to the destroyed group.  Invalidate it.
+	 */
+	atomic_inc(&root->dead_count);
+}
+
+static struct mem_cgroup *
+mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
+		     struct mem_cgroup *root,
+		     int *sequence)
+{
+	struct mem_cgroup *position = NULL;
+	/*
+	 * A cgroup destruction happens in two stages: offlining and
+	 * release.  They are separated by a RCU grace period.
+	 *
+	 * If the iterator is valid, we may still race with an
+	 * offlining.  The RCU lock ensures the object won't be
+	 * released, tryget will fail if we lost the race.
+	 */
+	*sequence = atomic_read(&root->dead_count);
+	if (iter->last_dead_count == *sequence) {
+		smp_rmb();
+		position = iter->last_visited;
+
+		/*
+		 * We cannot take a reference to root because we might race
+		 * with root removal and returning NULL would end up in
+		 * an endless loop on the iterator user level when root
+		 * would be returned all the time.
+		 */
+		if (position && position != root &&
+				!css_tryget(&position->css))
+			position = NULL;
+	}
+	return position;
+}
+
+static void mem_cgroup_iter_update(struct mem_cgroup_reclaim_iter *iter,
+				   struct mem_cgroup *last_visited,
+				   struct mem_cgroup *new_position,
+				   struct mem_cgroup *root,
+				   int sequence)
+{
+	/* root reference counting symmetric to mem_cgroup_iter_load */
+	if (last_visited && last_visited != root)
+		css_put(&last_visited->css);
+	/*
+	 * We store the sequence count from the time @last_visited was
+	 * loaded successfully instead of rereading it here so that we
+	 * don't lose destruction events in between.  We could have
+	 * raced with the destruction of @new_position after all.
+	 */
+	iter->last_visited = new_position;
+	smp_wmb();
+	iter->last_dead_count = sequence;
+}
+
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -1172,7 +1234,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
-	unsigned long uninitialized_var(dead_count);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1192,6 +1253,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	rcu_read_lock();
 	while (!memcg) {
 		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
+		int uninitialized_var(seq);
 
 		if (reclaim) {
 			int nid = zone_to_nid(reclaim->zone);
@@ -1205,37 +1267,14 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				goto out_unlock;
 			}
 
-			/*
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
-			 */
-			dead_count = atomic_read(&root->dead_count);
-			if (dead_count == iter->last_dead_count) {
-				smp_rmb();
-				last_visited = iter->last_visited;
-				if (last_visited && last_visited != root &&
-				    !css_tryget(&last_visited->css))
-					last_visited = NULL;
-			}
+			last_visited = mem_cgroup_iter_load(iter, root, &seq);
 		}
 
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			if (last_visited && last_visited != root)
-				css_put(&last_visited->css);
-
-			iter->last_visited = memcg;
-			smp_wmb();
-			iter->last_dead_count = dead_count;
+			mem_cgroup_iter_update(iter, last_visited, memcg, root,
+					seq);
 
 			if (!memcg)
 				iter->generation++;
@@ -6346,14 +6385,14 @@ static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
 	struct mem_cgroup *parent = memcg;
 
 	while ((parent = parent_mem_cgroup(parent)))
-		atomic_inc(&parent->dead_count);
+		mem_cgroup_iter_invalidate(parent);
 
 	/*
 	 * if the root memcg is not hierarchical we have to check it
 	 * explicitely.
 	 */
 	if (!root_mem_cgroup->use_hierarchy)
-		atomic_inc(&root_mem_cgroup->dead_count);
+		mem_cgroup_iter_invalidate(root_mem_cgroup);
 }
 
 static void mem_cgroup_css_offline(struct cgroup *cont)
-- 
1.8.3.1


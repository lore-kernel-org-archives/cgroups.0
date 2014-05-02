From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Date: Fri, 2 May 2014 19:31:38 -0400
Message-ID: <20140502233138.GR23420@cmpxchg.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
 <20140422095923.GD29311@dhcp22.suse.cz>
 <20140428150426.GB24807@dhcp22.suse.cz>
 <20140501125450.GA23420@cmpxchg.org>
 <20140502150516.d42792bad53d86fb727816bd@linux-foundation.org>
 <20140502232908.GQ23420@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=hMastnQBLec3crxPIxXVx21XrC0EetV50zerH9j/B8w=;
	b=Ki1kxjKi+wklWbfT7nxL7PaljF0N2ir/lJ3vwE0R+P8w335Gg8Dj9qvK9W94cHYxvBABYS0uAZ5uuxEg+yH9jcv1rKfS3Uc6DJLr+rezx88CPxwX26s9KidWIB98qGLwv8LJxdRKn/QWMPdwzcfIotNtT1x4OIgfiLHMw5uEjb8=;
Content-Disposition: inline
In-Reply-To: <20140502232908.GQ23420@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Jianyu Zhan <nasa4836@gmail.com>, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.com

While in that area, I noticed that the soft limit tree updaters don't
actually use the memcg argument anymore...

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: memcontrol: remove unnecessary memcg argument from soft
 limit functions

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 83cbd5a0e62f..3381f76df084 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -714,11 +714,9 @@ soft_limit_tree_from_page(struct page *page)
 	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
 }
 
-static void
-__mem_cgroup_insert_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz,
-				unsigned long long new_usage_in_excess)
+static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_zone *mz,
+					 struct mem_cgroup_tree_per_zone *mctz,
+					 unsigned long long new_usage_in_excess)
 {
 	struct rb_node **p = &mctz->rb_root.rb_node;
 	struct rb_node *parent = NULL;
@@ -748,10 +746,8 @@ __mem_cgroup_insert_exceeded(struct mem_cgroup *memcg,
 	mz->on_tree = true;
 }
 
-static void
-__mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
+static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
+					 struct mem_cgroup_tree_per_zone *mctz)
 {
 	if (!mz->on_tree)
 		return;
@@ -759,13 +755,11 @@ __mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
 	mz->on_tree = false;
 }
 
-static void
-mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
+static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
+				       struct mem_cgroup_tree_per_zone *mctz)
 {
 	spin_lock(&mctz->lock);
-	__mem_cgroup_remove_exceeded(memcg, mz, mctz);
+	__mem_cgroup_remove_exceeded(mz, mctz);
 	spin_unlock(&mctz->lock);
 }
 
@@ -792,12 +786,12 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 			spin_lock(&mctz->lock);
 			/* if on-tree, remove it */
 			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(memcg, mz, mctz);
+				__mem_cgroup_remove_exceeded(mz, mctz);
 			/*
 			 * Insert again. mz->usage_in_excess will be updated.
 			 * If excess is 0, no tree ops.
 			 */
-			__mem_cgroup_insert_exceeded(memcg, mz, mctz, excess);
+			__mem_cgroup_insert_exceeded(mz, mctz, excess);
 			spin_unlock(&mctz->lock);
 		}
 	}
@@ -813,7 +807,7 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
 			mctz = soft_limit_tree_node_zone(nid, zid);
-			mem_cgroup_remove_exceeded(memcg, mz, mctz);
+			mem_cgroup_remove_exceeded(mz, mctz);
 		}
 	}
 }
@@ -836,7 +830,7 @@ retry:
 	 * we will to add it back at the end of reclaim to its correct
 	 * position in the tree.
 	 */
-	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+	__mem_cgroup_remove_exceeded(mz, mctz);
 	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
 		!css_tryget(&mz->memcg->css))
 		goto retry;
@@ -4694,7 +4688,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 					break;
 			} while (1);
 		}
-		__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+		__mem_cgroup_remove_exceeded(mz, mctz);
 		excess = res_counter_soft_limit_excess(&mz->memcg->res);
 		/*
 		 * One school of thought says that we should not add
@@ -4705,7 +4699,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 		 * term TODO.
 		 */
 		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz->memcg, mz, mctz, excess);
+		__mem_cgroup_insert_exceeded(mz, mctz, excess);
 		spin_unlock(&mctz->lock);
 		css_put(&mz->memcg->css);
 		loop++;
-- 
1.9.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

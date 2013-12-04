From: David Rientjes <rientjes@google.com>
Subject: [patch 2/8] mm, mempolicy: rename slab_node for clarity
Date: Tue, 3 Dec 2013 21:19:57 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312032117330.29733@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=KtrpTdcHesA1gPi33Og3JwR5fly2i5V+ADxeB8YyKkg=;
        b=ovkoB/5T9mvj/gXGtk1Tc8xFM6Epnamq+o0RuIsWi542wmXlrX3FHcL7RQljIxabkB
         AP8ZeZ8jmetg5xN75dlc69f3IGdIWRfmJz+VX98TK4akoCXgg/exrwrbRbC9IOVI0nql
         hiE2rsRx7+su8KccOWyvSutr5ofoDhcKOfHdpKF+IXpMembFsU3yM5v7LSusD/1sU9vE
         8Ti6bEgl15vdgtIX2KoNnOT19YSoeJHd1pB/VHCzbRmdbBPTyHCJq4C2fuisDgkVUDkk
         lHYhKKDgMDdJ6QBdADzQrUyLQARJZP3nvnzRb6viWo1UbQghT9z4yUWEISk+sO/lsm6C
         RxQQ==
In-Reply-To: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

slab_node() is actually a mempolicy function, so rename it to
mempolicy_slab_node() to make it clearer that it used for processes with
mempolicies.

At the same time, cleanup its code by saving numa_mem_id() in a local
variable (since we require a node with memory, not just any node) and
remove an obsolete comment that assumes the mempolicy is actually passed
into the function.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mempolicy.h |  2 +-
 mm/mempolicy.c            | 15 ++++++---------
 mm/slab.c                 |  4 ++--
 mm/slub.c                 |  2 +-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -151,7 +151,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
-extern unsigned slab_node(void);
+extern unsigned int mempolicy_slab_node(void);
 
 extern enum zone_type policy_zone;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1783,21 +1783,18 @@ static unsigned interleave_nodes(struct mempolicy *policy)
 /*
  * Depending on the memory policy provide a node from which to allocate the
  * next slab entry.
- * @policy must be protected by freeing by the caller.  If @policy is
- * the current task's mempolicy, this protection is implicit, as only the
- * task can change it's policy.  The system default policy requires no
- * such protection.
  */
-unsigned slab_node(void)
+unsigned int mempolicy_slab_node(void)
 {
 	struct mempolicy *policy;
+	int node = numa_mem_id();
 
 	if (in_interrupt())
-		return numa_node_id();
+		return node;
 
 	policy = current->mempolicy;
 	if (!policy || policy->flags & MPOL_F_LOCAL)
-		return numa_node_id();
+		return node;
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
@@ -1817,11 +1814,11 @@ unsigned slab_node(void)
 		struct zonelist *zonelist;
 		struct zone *zone;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
-		zonelist = &NODE_DATA(numa_node_id())->node_zonelists[0];
+		zonelist = &NODE_DATA(node)->node_zonelists[0];
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone ? zone->node : numa_node_id();
+		return zone ? zone->node : node;
 	}
 
 	default:
diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3042,7 +3042,7 @@ static void *alternate_node_alloc(struct kmem_cache *cachep, gfp_t flags)
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_slab_spread_node();
 	else if (current->mempolicy)
-		nid_alloc = slab_node();
+		nid_alloc = mempolicy_slab_node();
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3074,7 +3074,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
-	zonelist = node_zonelist(slab_node(), flags);
+	zonelist = node_zonelist(mempolicy_slab_node(), flags);
 
 retry:
 	/*
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1663,7 +1663,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 
 	do {
 		cpuset_mems_cookie = get_mems_allowed();
-		zonelist = node_zonelist(slab_node(), flags);
+		zonelist = node_zonelist(mempolicy_slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

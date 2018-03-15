From: David Rientjes <rientjes@google.com>
Subject: [patch -mm] mm, memcg: disregard mempolicies for cgroup-aware oom
 killer
Date: Thu, 15 Mar 2018 13:51:01 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803151350420.55261@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QG4Aq9zRX1OPG2dD0wIEUpcjmja3RjdfACzHImWOhiQ=;
        b=f5cvOKEsyiAwcUnDBKzAUWblhQUU6qsDx320N0cjqFF9oj3wPSK07/gKuF8TSTdpZZ
         s0SMw09zBPLtxy5xgnKGi5+cDj1JGlLl5+oic3X5UfoAjT7JffCfNs10jk30h/D7kbFn
         +Il6fW4T5ORPcxFNS1aLCOSbcfTJXaRmlAOJeqCnwTgzTI/yMFCDXZFmJYmFBpqbcoiU
         kYv/PDHLYeXRZCcfDjzEAfkpzMEQ329kMyVhvUQ6Apr2wU2tb5RCzHbILJaPPK567gfk
         GfCjSHasyCOlRady1q7h+kG9TnRAvWEc7vY+LhzNhCXIH8OmYoiVBhDXAOs+9m76aZgF
         qgdA==
In-Reply-To: <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

The cgroup-aware oom killer currently considers the set of allowed nodes
for the allocation that triggers the oom killer and discounts usage from
disallowed nodes when comparing cgroups.

If a cgroup has both the cpuset and memory controllers enabled, it may be
possible to restrict allocations to a subset of nodes, for example.  Some
latency sensitive users use cpusets to allocate only local memory, almost
to the point of oom even though there is an abundance of available free
memory on other nodes.

The same is true for processes that mbind(2) their memory to a set of
allowed nodes.

This yields very inconsistent results by considering usage from each mem
cgroup (and perhaps its subtree) for the allocation's set of allowed nodes
for its mempolicy.  Allocating a single page for a vma that is mbind to a
now-oom node can cause a cgroup that is restricted to that node by its
cpuset controller to be oom killed when other cgroups may have much higher
overall usage.

The cgroup-aware oom killer is described as killing the largest memory
consuming cgroup (or subtree) without mentioning the mempolicy of the
allocation.  For now, discount it.  It would be possible to add an
additional oom policy for NUMA awareness if it would be generally useful
later with the extensible interface.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Based on top of oom policy patch series at
 https://marc.info/?t=152090280800001 and follow-up patch at
 https://marc.info/?l=linux-kernel&m=152098687824112

 mm/memcontrol.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2608,19 +2608,15 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 	return ret;
 }
 
-static long memcg_oom_badness(struct mem_cgroup *memcg,
-			      const nodemask_t *nodemask)
+static long memcg_oom_badness(struct mem_cgroup *memcg)
 {
 	const bool is_root_memcg = memcg == root_mem_cgroup;
 	long points = 0;
 	int nid;
-	pg_data_t *pgdat;
 
 	for_each_node_state(nid, N_MEMORY) {
-		if (nodemask && !node_isset(nid, *nodemask))
-			continue;
+		pg_data_t *pgdat = NODE_DATA(nid);
 
-		pgdat = NODE_DATA(nid);
 		if (is_root_memcg) {
 			points += node_page_state(pgdat, NR_ACTIVE_ANON) +
 				  node_page_state(pgdat, NR_INACTIVE_ANON);
@@ -2656,8 +2652,7 @@ static long memcg_oom_badness(struct mem_cgroup *memcg,
  *   >0: memcg is eligible, and the returned value is an estimation
  *       of the memory footprint
  */
-static long oom_evaluate_memcg(struct mem_cgroup *memcg,
-			       const nodemask_t *nodemask)
+static long oom_evaluate_memcg(struct mem_cgroup *memcg)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
@@ -2691,7 +2686,7 @@ static long oom_evaluate_memcg(struct mem_cgroup *memcg,
 	if (eligible <= 0)
 		return eligible;
 
-	return memcg_oom_badness(memcg, nodemask);
+	return memcg_oom_badness(memcg);
 }
 
 static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
@@ -2751,7 +2746,7 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 		if (memcg_has_children(iter))
 			continue;
 
-		score = oom_evaluate_memcg(iter, oc->nodemask);
+		score = oom_evaluate_memcg(iter);
 
 		/*
 		 * Ignore empty and non-eligible memory cgroups.
@@ -2780,8 +2775,7 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 
 	if (oc->chosen_memcg != INFLIGHT_VICTIM) {
 		if (root == root_mem_cgroup) {
-			group_score = oom_evaluate_memcg(root_mem_cgroup,
-							 oc->nodemask);
+			group_score = oom_evaluate_memcg(root_mem_cgroup);
 			if (group_score > leaf_score) {
 				/*
 				 * Discount the sum of all leaf scores to find
